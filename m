Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbYE1W5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbYE1W5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 18:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYE1W5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 18:57:05 -0400
Received: from mail.tmr.com ([64.65.253.246]:48983 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbYE1W5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 18:57:04 -0400
Message-ID: <483DE612.5000804@tmr.com>
Date: Wed, 28 May 2008 19:09:06 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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
> 
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

I have two tiny nits to pick with this information. One is the 
readahead, which as someone else mentioned is in sectors. The other is 
the unaligned display of the numbers, leading the eye to believe that 
values with a similar number of digits can be compared. In truth there's 
a decimal, but only sometimes. I imported the csv file, formatted all 
the numbers to an equal number of places after the decimal, and it is 
far easier to read.

Okay, and a half-nit, there were some patches to improve raid-1 
performance, I think by running io on multiple drives when you can, and 
by doing reads from the outer tracks if there are two idle drives. 
That's not in the stable version you used, I assume, it may not be in 
2.6.26 either, I'm doing other things at the moment.

A very nice bit of work, my only questions is if you ever feel motivated 
to repeat this test, it would be fun to do it with ext3 (or ext4) using 
the stride= parameter. I did limited testing and it really seemed to 
help, but nothing remotely as format as your test.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
