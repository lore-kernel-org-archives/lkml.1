Return-Path: <linux-kernel-owner+w=401wt.eu-S936849AbXG0OOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936849AbXG0OOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 10:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760556AbXG0OON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 10:14:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43165 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760200AbXG0OOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 10:14:12 -0400
Date: Fri, 27 Jul 2007 10:14:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <gregkh@suse.de>, Oliver Neukum <oliver@neukum.org>
cc: USB development list <linux-usb-devel@lists.sourceforge.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] usb-storage autosuspend bug?
In-Reply-To: <200707271011.07471.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0707271010320.3428-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007, Oliver Neukum wrote:

> Am Donnerstag 26 Juli 2007 schrieb Greg KH:
> > Alan and Oliver, was this caused by the autosuspend changes for
> > usb-storage?
> 
> The oops itself looks like refcounting. What caused the initial io error
> does not become clear from the log. It is possible that the device cannot
> stand suspension. But there's no evidence from that. On the contrary,
> these devices usually do an unplug/plug cycle, which is not in the log.

I don't think it's a refcounting problem.  My guess is that the 
underlying cause is the bug in your urb->status removal patch for 
usb_start_wait_urb() -- the one I fixed here:

http://marc.info/?l=linux-usb-devel&m=118531582013355&w=2

Of course, my guess could be wrong.  I haven't tried to recreate 
Linus's bug with that patch reverted.  But with the patch present I was 
not able to duplicate the bug.

Alan Stern

