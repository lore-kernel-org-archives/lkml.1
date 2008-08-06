Return-Path: <linux-kernel-owner+w=401wt.eu-S964824AbYHFTti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964824AbYHFTti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 15:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbYHFTt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 15:49:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60913 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751235AbYHFTt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 15:49:28 -0400
Date: Wed, 6 Aug 2008 15:49:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Simon Arlott <simon@fire.lp0.eu>
cc: Rene Herman <rene.herman@keyaccess.nl>,
       Arjan van de Ven <arjan@infradead.org>, <linux-kernel@vger.kernel.org>,
       <mingo@elte.hu>, Daniel Walker <dwalker@mvista.com>,
       USB list <linux-usb@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH RFC] USB: Add HCD fastboot
In-Reply-To: <4899F96D.9060809@simon.arlott.org.uk>
Message-ID: <Pine.LNX.4.44L0.0808061543340.2138-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008, Simon Arlott wrote:

> > Wouldn't it be much simpler, and less objectionable, to do what I
> > suggested earlier?  That is, add a 5-second delay at the start of
> > hub_thread() in drivers/usb/core/hub.c.  No messing with Makefiles, no
> > changes to the initcall scheduling.
> 
> Aside from 5 seconds being too long, and anything less being a race between 
> hub_thread() and driver initcalls, it doesn't improve anything because it'll 
> still have to wait for the devices to finish initialising in userspace instead.

Why is 5 seconds too long?  Too long for what?

What you're doing is already a race between hub_thread() and driver 
initcalls.  My suggestion is no worse.

"it'll still have to wait..."  If by "it" you mean the initcall
thread, you're wrong.  If by "it" you mean the user, you still aren't
necessarily correct; the user can do plenty of other things while
waiting for USB devices to initialize.

I suppose you could make the hub_thread delay time a module parameter 
for usbcore, defaulting to 0.  Then it could be set by just the people 
who want to use it -- many (most?) people keep their drivers in 
modules, and it wouldn't do them any good.

Alan Stern

