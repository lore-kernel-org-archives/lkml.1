Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025Ab0BXPvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 10:51:41 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55760 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756615Ab0BXPvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 10:51:39 -0500
Date: Wed, 24 Feb 2010 10:51:38 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Testing for dirty buffers on a block device
In-Reply-To: <20100223221329.GO1025@kernel.dk>
Message-ID: <Pine.LNX.4.44L0.1002241039190.2436-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010, Jens Axboe wrote:

> > That's not what I meant.  Dirty buffers on a filesystem make no 
> > difference because they always get written out when the filesystem is 
> > unmounted.  The device file remains open as long as the filesystem 
> > is mounted, which would prevent the device from being powered down.
> > 
> > I was asking about dirty buffers on a block device that isn't holding a 
> > filesystem -- where the raw device is being used directly for I/O.
> 
> OK, so just specifically the page cache of the device. Is that really
> enough of an issue to warrant special checking? I mean, what normal
> setup would even use buffer raw device access?

Doesn't fdisk use it?  There might be other applications too.

> But if you wanted, I guess the only way would be to lookup
> dirty/writeback pages on the bdev inode mapping. For that you'd need the
> bdev, not the gendisk or the queue though.

I can get the bdev from the gendisk by calling bdget_disk() with a 
partition number of 0, right?  What would the next step be?  Would this 
check for dirty pages associated with any of the partitions or would it 
only look at pages associated with the inode for the entire disk?

Alan Stern

