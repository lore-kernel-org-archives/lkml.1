Return-Path: <linux-kernel-owner+w=401wt.eu-S969650AbXG3WPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969650AbXG3WPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969110AbXG3WMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:12:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:53915 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S969013AbXG3WM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:12:28 -0400
Date: Mon, 30 Jul 2007 15:11:41 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] usb-storage autosuspend bug?
Message-ID: <20070730221141.GA5410@suse.de>
References: <Pine.LNX.4.44L0.0707271010320.3428-100000@iolanthe.rowland.org> <alpine.LFD.0.999.0707291956580.4161@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707291956580.4161@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 08:00:01PM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 27 Jul 2007, Alan Stern wrote:
> > 
> > I don't think it's a refcounting problem.  My guess is that the 
> > underlying cause is the bug in your urb->status removal patch for 
> > usb_start_wait_urb() -- the one I fixed here:
> > 
> > http://marc.info/?l=linux-usb-devel&m=118531582013355&w=2
> > 
> > Of course, my guess could be wrong.  I haven't tried to recreate 
> > Linus's bug with that patch reverted.  But with the patch present I was 
> > not able to duplicate the bug.
> 
> I finally got around to testing this, and while I still have problems with 
> that reader, I can't reproduce the oops with that patch in place either.
> 
> Of course, I only ever saw the oops once, so I really don't know how 
> reproducible it was. Maybe you have to remove the USB reader at _just_ the 
> right moment. But I did get
> 
> 	...
> 	usb 2-6: reset high speed USB device using ehci_hcd and address 4
> 	usb 2-6: USB disconnect, address 4
> 	sd 6:0:0:1: [sdc] Result: hostbyte=0x07 driverbyte=0x00
> 	end_request: I/O error, dev sdc, sector 1999855
> 	...
> 	scsi 6:0:0:1: rejecting I/O to dead device
> 
> so the testing was done with the kind of behaviour that resulted in an 
> oops and a dead khubd last time around.
> 
> So I guess I'll ack the patch for whatever that is worth.

Ok, the patch is in the series I just sent to you.

If you run into that bug again, please let us know.

thanks,

greg k-h
