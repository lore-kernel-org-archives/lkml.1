Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbYJTRXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbYJTRXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911AbYJTRNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:13:45 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:59151 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755819AbYJTRNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:13:44 -0400
Date: Mon, 20 Oct 2008 19:12:48 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Miquel van Smoorenburg <mikevs@xs4all.net>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: disk statistics issue in 2.6.27
Message-ID: <20081020171248.GE19428@kernel.dk>
References: <20081019113102.GA18440@xs4all.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081019113102.GA18440@xs4all.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19 2008, Miquel van Smoorenburg wrote:
> I just upgraded one of our servers in the nntp cluster to 2.6.27.1 -
> most of the others are running 2.6.26.something.
> 
> I noticed that the "iostat -k -x 2" output does't make any sense.
> The number of reads/sec and number of writes/sec are about what I
> would expect, and so are the other fields, but rkB/sec and wkB/sec
> are  completely off-scale: gigabytes read/written per second.
> 
> To be sure it wasn't a bug in iostat I wrote a small perl script
> to process /sys/block/sda/stats, and it shows the same problem.
> 
> Note that the stats in /proc/diskstats and /sys/block/<dev>/stats
> are the same.
> 
> I've tried both the cfq and deadline I/O scheduler - no difference.
> 
> $ perl mystat.pl 
> Device:   r/s   w/s     rkB/s     wkB/s
> sda       141    53   2301120   1795200
> 
> Device:   r/s   w/s     rkB/s     wkB/s
> sda       145     7   2366400   3394560
> 
> I compiled a 2.6.26.6 kernel with the exact same .config and it
> doesn't show the problem.
> 
> I've been staring at include/linux/genhd.h and block/genhd.c
> for a while but I just don't see it.
> 
> The mystat.pl perl script and my .config are below.
> The machine is a dual xeon 2.2 Ghz, 32 bit, 4 GB mem, /dev/sda
> is a 3-scsi-disk RAID5 array on an adaptec 2005S controller.
> 
> Any idea what could be causing this ?

Weird, I cannot reproduce this at all, iostat works fine for me in .26,
.27 and current -git as well. So it's just a plain SCSI drive from
linux, no software raid or dm?

Are the reported values in iostat any sort of multiple of the real
throughtput, or is is just insanely large?

-- 
Jens Axboe

