Return-Path: <linux-kernel-owner+w=401wt.eu-S934021AbXC2ILk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934021AbXC2ILk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 04:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934039AbXC2ILk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 04:11:40 -0400
Received: from lucidpixels.com ([75.144.35.66]:34545 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934021AbXC2ILi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 04:11:38 -0400
Date: Thu, 29 Mar 2007 04:11:37 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Neil Brown <neilb@suse.de>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: Software RAID (non-preempt) server blocking question. (2.6.20.4)
In-Reply-To: <17931.23488.160031.119117@notabene.brown>
Message-ID: <Pine.LNX.4.64.0703290410260.32099@p34.internal.lan>
References: <Pine.LNX.4.64.0703270557360.31853@p34.internal.lan>
 <17931.23488.160031.119117@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 Mar 2007, Neil Brown wrote:

> On Tuesday March 27, jpiszcz@lucidpixels.com wrote:
>> I ran a check on my SW RAID devices this morning.  However, when I did so,
>> I had a few lftp sessions open pulling files.  After I executed the check,
>> the lftp processes entered 'D' state and I could do 'nothing' in the
>> process until the check finished.  Is this normal?  Should a check block
>> all I/O to the device and put the processes writing to a particular device
>> in 'D' state until it is finished?
>
> No, that shouldn't happen.  The 'check' should notice any other disk
> activity and slow down if anything else is happening on the device.
>
> Did the check run to completion?  And if so, did the 'lftp' start
> working normally again?
Yes it did and the lftp did start working normally again.

>
> Did you look at "cat /proc/mdstat" ?? What sort of speed was the check
> running at?
Around 44MB/s.

I do use the following optimization, perhaps a bad idea if I want other 
processes to 'stay alive'?

echo "Setting minimum resync speed to 200MB/s..."
echo "This improves the resync speed from 2.1MB/s to 44MB/s"
echo 200000 > /sys/block/md0/md/sync_speed_min
echo 200000 > /sys/block/md1/md/sync_speed_min
echo 200000 > /sys/block/md2/md/sync_speed_min
echo 200000 > /sys/block/md3/md/sync_speed_min
echo 200000 > /sys/block/md4/md/sync_speed_min



>
> NeilBrown
>
