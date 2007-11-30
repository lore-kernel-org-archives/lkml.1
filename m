Return-Path: <linux-kernel-owner+w=401wt.eu-S1764021AbXK3C6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764021AbXK3C6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 21:58:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764043AbXK3C6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 21:58:22 -0500
Received: from netrider.rowland.org ([192.131.102.5]:2972 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1764019AbXK3C6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 21:58:21 -0500
Date: Thu, 29 Nov 2007 21:58:20 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Mark Lord <lkml@rtr.ca>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-usb-devel@lists.sourceforge.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [PATCH] base/class.c: prevent ooops due to
 insert/remove race (v3)
In-Reply-To: <alpine.LFD.0.9999.0711291505440.8458@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0711292155360.12541-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007, Linus Torvalds wrote:

> Heh. It definitely hasn't gotten lost by "the git software".

No, it sure hasn't.  In fact it was staring me right in the face and I 
didn't realize it.

> In fact, with 
> the kinds of hints you already gave, git makes it really _trivial_ to find 
> it.
> 
> Here's what you do:
> 
> 	git log v2.6.23.. --author=Wilcox
> 
> and then just search for "scan_mutex", in the hope that Matthew wrote a 
> nice commit message. And yes, he did, so in less than a blink you get:
> 
> 	commit 6b7f123f378743d739377871c0cbfbaf28c7d25a
> 	Author: Matthew Wilcox <matthew@wil.cx>
> 	Date:   Tue Jun 26 15:18:51 2007 -0600
> 	
> 	    [SCSI] Fix async scanning double-add problems
> 
> 	    Stress-testing and some thought has revealed some places where
> 	    asynchronous scanning needs some more attention to locking.
> 	
> 	     - Since async_scan is a bit, we need to hold the host_lock while
> 	       modifying it to prevent races against other CPUs modifying the word
> 	       that bit is in.  This is probably a theoretical race for the moment,
> 	       but other patches may change that.
> 	     - The async_scan bit means not only that this host is being scanned
> 	       asynchronously, but that all the devices attached to this host are not
> 	       yet added to sysfs.  So we must ensure that this bit is always in sync.
> 	       I've chosen to do this with the scan_mutex since it's already acquired
> 	       in most of the right places.
> 		...
> 
> which I assume is the commit you're talking about.

Yep, that's the one.

Alan Stern

