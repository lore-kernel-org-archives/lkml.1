Return-Path: <linux-kernel-owner+w=401wt.eu-S969029AbXG3WGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969029AbXG3WGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967494AbXG3WF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:05:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58903 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968496AbXG3WFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:05:55 -0400
Date: Tue, 31 Jul 2007 03:48:13 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Christoph Hellwig <hch@lst.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Dave Young <hidave.darkstar@gmail.com>,
       Grant Wilson <grant.wilson@zen.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1-mm1
In-Reply-To: <20070730184203.GA14219@lst.de>
Message-ID: <alpine.LFD.0.999.0707310344430.17287@enigma.security.iitk.ac.in>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
 <20070729164946.0b86a414@the-diner.swandive.local>
 <a8e1da0707300258k4ee5ed93yadd9e87af45b9330@mail.gmail.com>
 <20070730112720.cdc6a8c4.akpm@linux-foundation.org>
 <20070730184203.GA14219@lst.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Jul 2007, Christoph Hellwig wrote:

> On Mon, Jul 30, 2007 at 11:27:20AM -0700, Andrew Morton wrote:
> > ho hum, crap.  Yes, ioctl_by_bdev() doesn't have a file* and so it makes
> > unlocked_ioctl() rather tricky.  We could cook up a `struct file' on the
> > stack (we do that in various places), but that sucks.
> > 
> > Christoph, have you any clever suggestions?
> 
> There's two ways to deal with it, one ugly and quick and one to do it
> right.
> 
> The quick hack is to fake up a file struct similar to blkdev_get().

Gargh, please no. I've been thinking of how to get rid of that fake
on-stack file and dentry stuff from blkdev_get() myself -- it makes
pktcdvd incompatible with 4k kernel stacks ... btw any reason why we
can't just kmalloc() the fake file and dentry there?


> The proper solutions is to get rid of the file (and inode) in the
> blockdev ->ioctl prototype.  Only thing keeping is from that is
> floppy.c (and some cut & paste variants for m68k) due to their awkard
> permission checking hacks.

Hmm, care to explain this in more detail?


Satyam
