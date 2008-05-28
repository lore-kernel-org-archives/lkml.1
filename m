Return-Path: <linux-kernel-owner+w=401wt.eu-S1753643AbYE1IyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbYE1IyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 04:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYE1Ixt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 04:53:49 -0400
Received: from lucidpixels.com ([75.144.35.66]:39846 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbYE1Ixs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 04:53:48 -0400
Date: Wed, 28 May 2008 04:53:47 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
Message-ID: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hardware:

1. Utilized (6) 400 gigabyte sata hard drives.
2. Everything is on PCI-e (965 chipset & a 2port sata card)

Used the following 'optimizations' for all tests.

# Set read-ahead.
echo "Setting read-ahead to 64 MiB for /dev/md3"
blockdev --setra 65536 /dev/md3

# Set stripe-cache_size for RAID5.
echo "Setting stripe_cache_size to 16 MiB for /dev/md3"
echo 16384 > /sys/block/md3/md/stripe_cache_size

# Disable NCQ on all disks.
echo "Disabling NCQ on all disks..."
for i in $DISKS
do
   echo "Disabling NCQ on $i"
   echo 1 > /sys/block/"$i"/device/queue_depth
done

Software:

Kernel: 2.6.23.1 x86_64
Filesystem: XFS
Mount options: defaults,noatime

Results:

http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.html
http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.txt

Note: 'deg' means degraded and the number after is the number of disks 
failed, I did not test degraded raid10 because there are many ways you can 
degrade a raid10; however, the 3 types of raid10 were benchmarked 
f2,n2,o2.

Each test was run 3 times and averaged--FYI.

Justin.
