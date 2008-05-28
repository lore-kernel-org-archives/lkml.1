Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbYE1KyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbYE1KyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 06:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYE1KyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 06:54:15 -0400
Received: from arx.rabbit.us ([76.244.88.238]:37399 "EHLO arx.rabbit.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbYE1KyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 06:54:14 -0400
Message-ID: <483D39D3.4020906@rabbit.us>
Date: Wed, 28 May 2008 12:54:11 +0200
From: Peter Rabbitson <rabbit+list@rabbit.us>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> Hardware:
> 
> 1. Utilized (6) 400 gigabyte sata hard drives.
> 2. Everything is on PCI-e (965 chipset & a 2port sata card)
> 
> Used the following 'optimizations' for all tests.
> 
> # Set read-ahead.
> echo "Setting read-ahead to 64 MiB for /dev/md3"
> blockdev --setra 65536 /dev/md3

That's actually 65k x 512byte blocks so 32MiB

> # Set stripe-cache_size for RAID5.
> echo "Setting stripe_cache_size to 16 MiB for /dev/md3"
> echo 16384 > /sys/block/md3/md/stripe_cache_size
> 
> # Disable NCQ on all disks.
> echo "Disabling NCQ on all disks..."
> for i in $DISKS
> do
>   echo "Disabling NCQ on $i"
>   echo 1 > /sys/block/"$i"/device/queue_depth
> done
> 
> Software:
> 
> Kernel: 2.6.23.1 x86_64
> Filesystem: XFS
> Mount options: defaults,noatime
> 
> Results:
> 
> http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.html
> http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.txt
> 
> Note: 'deg' means degraded and the number after is the number of disks 
> failed, I did not test degraded raid10 because there are many ways you 
> can degrade a raid10; however, the 3 types of raid10 were benchmarked 
> f2,n2,o2.
> 
> Each test was run 3 times and averaged--FYI.
> 

Results are meaningless without a crucial detail - what was the chunk size 
used during array creation time? Otherwise interesting test :)

Cheers

Peter

