Return-Path: <linux-kernel-owner+w=401wt.eu-S967950AbXG3SmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967950AbXG3SmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 14:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965966AbXG3SmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 14:42:11 -0400
Received: from verein.lst.de ([213.95.11.210]:43829 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967900AbXG3SmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 14:42:10 -0400
Date: Mon, 30 Jul 2007 20:42:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Grant Wilson <grant.wilson@zen.co.uk>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Subject: Re: 2.6.23-rc1-mm1
Message-ID: <20070730184203.GA14219@lst.de>
References: <20070725040304.111550f4.akpm@linux-foundation.org> <20070729164946.0b86a414@the-diner.swandive.local> <a8e1da0707300258k4ee5ed93yadd9e87af45b9330@mail.gmail.com> <20070730112720.cdc6a8c4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070730112720.cdc6a8c4.akpm@linux-foundation.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 11:27:20AM -0700, Andrew Morton wrote:
> ho hum, crap.  Yes, ioctl_by_bdev() doesn't have a file* and so it makes
> unlocked_ioctl() rather tricky.  We could cook up a `struct file' on the
> stack (we do that in various places), but that sucks.
> 
> Christoph, have you any clever suggestions?

There's two ways to deal with it, one ugly and quick and one to do it
right.

The quick hack is to fake up a file struct similar to blkdev_get().

The proper solutions is to get rid of the file (and inode) in the
blockdev ->ioctl prototype.  Only thing keeping is from that is
floppy.c (and some cut & paste variants for m68k) due to their awkard
permission checking hacks.

