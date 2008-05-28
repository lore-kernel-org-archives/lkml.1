Return-Path: <linux-kernel-owner+w=401wt.eu-S1753057AbYE1RyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbYE1RyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 13:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbYE1RyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 13:54:01 -0400
Received: from lucidpixels.com ([75.144.35.66]:49860 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbYE1RyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 13:54:00 -0400
Date: Wed, 28 May 2008 13:53:57 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Chris Snook <csnook@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Performance Characteristics of All Linux RAIDs
 (mdadm/bonnie++)
In-Reply-To: <alpine.DEB.1.10.0805281329450.29755@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0805281351020.29755@p34.internal.lan>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan> <483D7CE8.4000600@redhat.com> <alpine.DEB.1.10.0805281329450.29755@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 28 May 2008, Justin Piszcz wrote:

>
>
> On Wed, 28 May 2008, Chris Snook wrote:
>
>> Justin Piszcz wrote:
>>> Hardware:
>>> 
>>> 1. Utilized (6) 400 gigabyte sata hard drives.
>>> 2. Everything is on PCI-e (965 chipset & a 2port sata card)
>>> 
>>> Used the following 'optimizations' for all tests.
>>> 
>>> # Set read-ahead.
>>> echo "Setting read-ahead to 64 MiB for /dev/md3"
>>> blockdev --setra 65536 /dev/md3
>>> 
>>> # Set stripe-cache_size for RAID5.
>>> echo "Setting stripe_cache_size to 16 MiB for /dev/md3"
>>> echo 16384 > /sys/block/md3/md/stripe_cache_size
>>> 
>>> # Disable NCQ on all disks.
>>> echo "Disabling NCQ on all disks..."
>>> for i in $DISKS
>>> do
>>>   echo "Disabling NCQ on $i"
>>>   echo 1 > /sys/block/"$i"/device/queue_depth
>>> done
>> 
>> Given that one of the greatest benefits of NCQ/TCQ is with parity RAID, I'd 
>> be fascinated to see how enabling NCQ changes your results.  Of course, 
>> you'd want to use a single SATA controller with a known good NCQ 
>> implementation, and hard drives known to not do stupid things like disable 
>> readahead when NCQ is enabled.
> Only/usually on multi-threaded jobs/tasks, yes?
>
> Also, I turn off NCQ on all of my hosts that has it enabled by default 
> because
> there are many bugs that occur when NCQ is on, they are working on it in the
> libata layer but IMO it is not safe at all for running SATA disks w/NCQ as
> with it on I have seen drives drop out of the array (with it off, no 
> problems).
>
>

I have done NCQ measurements in the past, for single threaded apps NCQ off 
is the way to go, check this out from earlier (10 raptors raid5):

http://home.comcast.net/~jpiszcz/ncq_vs_noncq/


