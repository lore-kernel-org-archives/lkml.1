Return-Path: <linux-kernel-owner+w=401wt.eu-S1759357AbYDBUKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357AbYDBUKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757845AbYDBUJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:09:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44392 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757409AbYDBUJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:09:57 -0400
Date: Wed, 2 Apr 2008 16:09:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mark Lord <lkml@rtr.ca>
cc: Oliver Neukum <oliver@neukum.org>, Pavel Machek <pavel@suse.cz>,
       Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, <jikos@suse.cz>,
       <linux-usb@vger.kernel.org>
Subject: Re: 2.6.25-rc7:  Ugh. ---> PATCH
In-Reply-To: <47F3A9C3.7030702@rtr.ca>
Message-ID: <Pine.LNX.4.44L0.0804021601490.2107-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, Mark Lord wrote:

> When comparing 2.6.24 against 2.6.25, this line of code
> stood out as not looking entirely correct, given the new
> uses of QH_STATE_UNLINK_WAIT in 2.6.25.

> --- linux-2.6.25-rc8/drivers/usb/host/ehci-hcd.c	2008-03-11 11:18:40.000000000 -0400
> +++ linux/drivers/usb/host/ehci-hcd.c	2008-04-02 11:36:13.000000000 -0400
> @@ -815,7 +815,7 @@
>  		end_unlink_async(ehci);
>  
>  	/* if it's not linked then there's nothing to do */
> -	if (qh->qh_state != QH_STATE_LINKED)
> +	if (qh->qh_state != QH_STATE_LINKED && qh->qh_state != QH_STATE_UNLINK_WAIT)
>  		;
>  
>  	/* defer till later if busy */

To answer your implied question...

QH_STATE_UNLINK_WAIT doesn't have a new meaning in 2.6.25.  Just as 
before, it means that qh is on a queue waiting to be unlinked.

qh->qh_state can never be equal to QH_STATE_UNLINK_WAIT at this point.  
If it were, it would mean that some part of the driver had tried to
unlink qh twice.  But even then, the correct move would be to follow
the "nothing to do" path -- since qh is already waiting to be unlinked,
there's no point trying to do any more.

Alan Stern

