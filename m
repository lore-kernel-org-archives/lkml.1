Return-Path: <linux-kernel-owner+w=401wt.eu-S1751749AbXC2JAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbXC2JAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 05:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbXC2JAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 05:00:53 -0400
Received: from lucidpixels.com ([75.144.35.66]:47097 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbXC2JAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 05:00:52 -0400
Date: Thu, 29 Mar 2007 05:00:51 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: Software RAID (non-preempt) server blocking question. (2.6.20.4)
In-Reply-To: <20070329085612.GA19278@khazad-dum.debian.net>
Message-ID: <Pine.LNX.4.64.0703290459330.32099@p34.internal.lan>
References: <Pine.LNX.4.64.0703270557360.31853@p34.internal.lan>
 <17931.23488.160031.119117@notabene.brown> <Pine.LNX.4.64.0703290410260.32099@p34.internal.lan>
 <20070329085612.GA19278@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 Mar 2007, Henrique de Moraes Holschuh wrote:

> On Thu, 29 Mar 2007, Justin Piszcz wrote:
>>> Did you look at "cat /proc/mdstat" ?? What sort of speed was the check
>>> running at?
>> Around 44MB/s.
>>
>> I do use the following optimization, perhaps a bad idea if I want other
>> processes to 'stay alive'?
>>
>> echo "Setting minimum resync speed to 200MB/s..."
>> echo "This improves the resync speed from 2.1MB/s to 44MB/s"
>> echo 200000 > /sys/block/md0/md/sync_speed_min
>> echo 200000 > /sys/block/md1/md/sync_speed_min
>> echo 200000 > /sys/block/md2/md/sync_speed_min
>> echo 200000 > /sys/block/md3/md/sync_speed_min
>> echo 200000 > /sys/block/md4/md/sync_speed_min
>
> md RAID1 resync reacts *extremely* badly to CFQ.  Just a data point, you may
> want to check on it.  Might mean other RAID types also get screwed, and also
> that md "check" is also disturbed by CFQ (or disturbs CFQ, whatever).
>
> I reverted everything here to non-CFQ while the RAID did its resync (which
> fixed all issues immediately), and we went back to 2.6.16.x later for other
> reasons.
>
> --
>  "One disk to rule them all, One disk to find them. One disk to bring
>  them all and in the darkness grind them. In the Land of Redmond
>  where the shadows lie." -- The Silicon Valley Tarot
>  Henrique Holschuh
>

I am using the AS scheduler; not CFQ.

$ find /sys 2>/dev/null|grep -i scheduler|xargs -n1 cat
noop [anticipatory]
noop [anticipatory]
noop [anticipatory]
noop [anticipatory]
noop [anticipatory]
noop [anticipatory]
noop [anticipatory]
noop [anticipatory]
noop [anticipatory]
noop [anticipatory]
noop [anticipatory]
noop [anticipatory]

Justin.
