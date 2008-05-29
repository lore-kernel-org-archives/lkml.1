Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbYE2RCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbYE2RCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 13:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYE2RCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 13:02:42 -0400
Received: from lucidpixels.com ([75.144.35.66]:57526 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbYE2RCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 13:02:41 -0400
Date: Thu, 29 May 2008 13:02:40 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Holger Kiehl <Holger.Kiehl@dwd.de>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Performance Characteristics of All Linux RAIDs
 (mdadm/bonnie++)
In-Reply-To: <Pine.LNX.4.64.0805290636020.20192@diagnostix.dwd.de>
Message-ID: <alpine.DEB.1.10.0805291302190.23633@p34.internal.lan>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan> <Pine.LNX.4.64.0805290636020.20192@diagnostix.dwd.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 May 2008, Holger Kiehl wrote:

> On Wed, 28 May 2008, Justin Piszcz wrote:
>
>> Hardware:
>> 
>> 1. Utilized (6) 400 gigabyte sata hard drives.
>> 2. Everything is on PCI-e (965 chipset & a 2port sata card)
>> 
>> Used the following 'optimizations' for all tests.
>> 
>> # Set read-ahead.
>> echo "Setting read-ahead to 64 MiB for /dev/md3"
>> blockdev --setra 65536 /dev/md3
>> 
>> # Set stripe-cache_size for RAID5.
>> echo "Setting stripe_cache_size to 16 MiB for /dev/md3"
>> echo 16384 > /sys/block/md3/md/stripe_cache_size
>> 
>> # Disable NCQ on all disks.
>> echo "Disabling NCQ on all disks..."
>> for i in $DISKS
>> do
>>  echo "Disabling NCQ on $i"
>>  echo 1 > /sys/block/"$i"/device/queue_depth
>> done
>> 
>> Software:
>> 
>> Kernel: 2.6.23.1 x86_64
>> Filesystem: XFS
>> Mount options: defaults,noatime
>> 
>> Results:
>> 
>> http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.html
>> http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.txt
>> 
> Why is the Sequential Output (Block) for raid6 165719 and for raid5 only
> 86797? I would have thought that raid6 was always a bit slower in writting
> due to having to write double amount of parity data.
>
> Holger
>

RAID5 (2nd test of 3 averaged runs) & Single disk added:
http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.html
