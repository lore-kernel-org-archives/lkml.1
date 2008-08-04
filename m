Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbYHDQsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbYHDQsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757930AbYHDQsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:48:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52052 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757276AbYHDQsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:48:11 -0400
Date: Mon, 4 Aug 2008 12:48:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alex Buell <alex.buell@munted.org.uk>
cc: linux-kernel@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>,
       Tomas Styblo <tripie@cpan.org>, <linux-usb@vger.kernel.org>,
       <usb-storage@lists.one-eyed-alien.net>
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix - device
 152d:2338
In-Reply-To: <20080803100706.5e52ce90.alex.buell@munted.org.uk>
Message-ID: <Pine.LNX.4.44L0.0808041245430.15613-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Aug 2008, Alex Buell wrote:

> > Which patch?  Several different ones have been posted.
> 
> This is the one that I applied:
> Index: usb-2.6/drivers/usb/storage/transport.c
> ===================================================================
> --- usb-2.6.orig/drivers/usb/storage/transport.c
> +++ usb-2.6/drivers/usb/storage/transport.c
> @@ -663,7 +663,7 @@ void usb_stor_invoke_transport(struct sc
>  	}
>  
>  	/* Did we transfer less than the minimum amount required? */
> -	if (srb->result == SAM_STAT_GOOD &&
> +	if ((srb->result == SAM_STAT_GOOD || srb->sense_buffer[2] == 0) && scsi_bufflen(srb) - scsi_get_resid(srb) < srb->underflow)
>  		srb->result = (DID_ERROR << 16) | (SUGGEST_RETRY << 24); 
> 
> > The log doesn't provide much help.  We need to see a log with 
> > CONFIG_USB_STORAGE_DEBUG enabled.
> 
> Which patch should I be trying out? 

That's the right patch.  You should use it with 2.6.27-rc1.

I just got one of those JMicron thingies; I'll try it out later today.  
No SATA devices available for testing, though, only PATA.

Alan Stern

