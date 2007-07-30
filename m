Return-Path: <linux-kernel-owner+w=401wt.eu-S966257AbXG3DBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966257AbXG3DBQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 23:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759913AbXG3DBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 23:01:03 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57316 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753741AbXG3DBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 23:01:00 -0400
Date: Sun, 29 Jul 2007 20:00:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Greg KH <gregkh@suse.de>, Oliver Neukum <oliver@neukum.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] usb-storage autosuspend bug?
In-Reply-To: <Pine.LNX.4.44L0.0707271010320.3428-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.0.999.0707291956580.4161@woody.linux-foundation.org>
References: <Pine.LNX.4.44L0.0707271010320.3428-100000@iolanthe.rowland.org
 >
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Jul 2007, Alan Stern wrote:
> 
> I don't think it's a refcounting problem.  My guess is that the 
> underlying cause is the bug in your urb->status removal patch for 
> usb_start_wait_urb() -- the one I fixed here:
> 
> http://marc.info/?l=linux-usb-devel&m=118531582013355&w=2
> 
> Of course, my guess could be wrong.  I haven't tried to recreate 
> Linus's bug with that patch reverted.  But with the patch present I was 
> not able to duplicate the bug.

I finally got around to testing this, and while I still have problems with 
that reader, I can't reproduce the oops with that patch in place either.

Of course, I only ever saw the oops once, so I really don't know how 
reproducible it was. Maybe you have to remove the USB reader at _just_ the 
right moment. But I did get

	...
	usb 2-6: reset high speed USB device using ehci_hcd and address 4
	usb 2-6: USB disconnect, address 4
	sd 6:0:0:1: [sdc] Result: hostbyte=0x07 driverbyte=0x00
	end_request: I/O error, dev sdc, sector 1999855
	...
	scsi 6:0:0:1: rejecting I/O to dead device

so the testing was done with the kind of behaviour that resulted in an 
oops and a dead khubd last time around.

So I guess I'll ack the patch for whatever that is worth.

Over to you, Greg..

		Linus
