Return-Path: <linux-kernel-owner+w=401wt.eu-S965185AbXBTPzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965185AbXBTPzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:55:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965186AbXBTPzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:55:47 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:48764 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965185AbXBTPzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:55:46 -0500
Date: Tue, 20 Feb 2007 10:55:45 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Douglas Gilbert <dougg@torque.net>
cc: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>,
       <linux-kernel@vger.kernel.org>, <jens.axboe@oracle.com>,
       <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] Block layer: separate out queue-oriented ioctls
In-Reply-To: <45DA7D77.9020709@torque.net>
Message-ID: <Pine.LNX.4.44L0.0702201052360.4992-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Feb 2007, Douglas Gilbert wrote:

> > Come to think of it, the reserved_size value used when a new sg device is
> > created should also be capped at max_sectors * 512.  Agreed?  I can't see
> > any reason for ever having a larger buffer -- it would be impossible to
> > make use of the extra space.
> 
> Alan,
> That depends whether or not max_sectors can be changed
> (via sysfs) subsequent to a sg device being created.
> And I think it can.
> 
> # ls -l /sys/block/sdc/queue/
> total 0
> drwxr-xr-x 2 root root    0 Feb 19 18:29 iosched
> -r--r--r-- 1 root root 4096 Feb 19 23:41 max_hw_sectors_kb
> -rw-r--r-- 1 root root 4096 Feb 19 23:41 max_sectors_kb
> -rw-r--r-- 1 root root 4096 Feb 19 23:41 nr_requests
> -rw-r--r-- 1 root root 4096 Feb 19 23:41 read_ahead_kb
> -rw-r--r-- 1 root root 4096 Feb 19 23:41 scheduler

Yes, it definitely can be changed.

> # cat max_hw_sectors_kb > max_sectors_kb
> 
> ... is the real maximum if the LLD that set max_hw_sectors_kb
> is to be believed (actually it is often a finger in
> the wind).

That's why my patch computes the minimum value every time the 
GET_RESERVED_SIZE ioctl runs -- in case max_sectors has changed.

If the user decides to increase max_sectors, then the reserved_size can be 
increased immediately afterward.  This shouldn't cause any problems.

I will submit a revised patch shortly, on the linux-scsi list.

Alan Stern

