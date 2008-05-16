Return-Path: <linux-kernel-owner+w=401wt.eu-S1757742AbYEPRRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbYEPRRD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 13:17:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbYEPRQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 13:16:50 -0400
Received: from lucidpixels.com ([75.144.35.66]:45718 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbYEPRQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 13:16:49 -0400
Date: Fri, 16 May 2008 13:16:48 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: David Greaves <david@dgreaves.com>
cc: David Chinner <dgc@sgi.com>, LinuxRaid <linux-raid@vger.kernel.org>,
       xfs@oss.sgi.com,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: Regression- XFS won't mount on partitioned md array
In-Reply-To: <482DC043.5000307@dgreaves.com>
Message-ID: <alpine.DEB.1.10.0805161316100.3118@p34.internal.lan>
References: <482DC043.5000307@dgreaves.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 16 May 2008, David Greaves wrote:

> I just attempted a kernel upgrade from 2.6.20.7 to 2.6.25.3 and it no longer
> mounts my xfs filesystem.
>
> I bisected it to around
> a67d7c5f5d25d0b13a4dfb182697135b014fa478
> [XFS] Move platform specific mount option parse out of core XFS code
>
> I have a RAID5 array with partitions:
>
> Partition Table for /dev/md_d0
>
>               First       Last
> # Type       Sector      Sector   Offset    Length   Filesystem Type (ID) Flag
> -- ------- ----------- ----------- ------ ----------- -------------------- ----
> 1 Primary           0  2500288279      4  2500288280 Linux (83)           None
> 2 Primary  2500288280  2500483583      0      195304 Non-FS data (DA)     None
>
>
> when I attempt to mount /media:
> /dev/md_d0p1 /media xfs rw,nobarrier,noatime,logdev=/dev/md_d0p2,allocsize=512m 0 0
>
> I get:
> md_d0: p1 p2
> XFS mounting filesystem md_d0p1
> attempt to access beyond end of device
> md_d0p2: rw=0, want=195311, limit=195304
> I/O error in filesystem ("md_d0p1") meta-data dev md_d0p2 block 0x2fae7
> ("xlog_bread") error 5 buf count 512
> XFS: empty log check failed
> XFS: log mount/recovery failed: error 5
> XFS: log mount failed
>
> A repair:
>  xfs_repair /dev/md_d0p1 -l /dev/md_d0p2
> gives no errors.
>
> Phase 1 - find and verify superblock...
> Phase 2 - using external log on /dev/md_d0p2
>        - zero log...
>        - scan filesystem freespace and inode maps...
>        - found root inode chunk
> ...
>
>
> David
>
>

Ouch, still on 2.6.25.1 here, didn't reboot yet, but I do not use 
mdraid'ed partitions, just regular mdraid, if you boot back to 2.6.20.7 
does it work again?
