Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbXC0Kaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbXC0Kaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 06:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbXC0Kaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 06:30:39 -0400
Received: from lucidpixels.com ([75.144.35.66]:57887 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476AbXC0Kai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 06:30:38 -0400
Date: Tue, 27 Mar 2007 06:30:38 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Tejun Heo <htejun@gmail.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Why is NCQ enabled by default by libata? (2.6.20)
In-Reply-To: <4608ED89.5040407@gmail.com>
Message-ID: <Pine.LNX.4.64.0703270629180.31853@p34.internal.lan>
References: <Pine.LNX.4.64.0703241232580.11608@p34.internal.lan>
 <20070324184300.3250fab0@the-village.bc.nu> <Pine.LNX.4.64.0703270554320.31853@p34.internal.lan>
 <4608ED89.5040407@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 27 Mar 2007, Tejun Heo wrote:

> Justin Piszcz wrote:
>> Checking the benchmarks on various hardware websites, anandtech, 
>> hothardware and others, they generally all come to the same conclusion if 
>> there is only 1 thread using I/O (single user system) then NCQ off is the 
>> best.
>
> Are they testing using Linux?  I/O performance is highly dependent on 
> workload and scheduling, so result on windows wouldn't be very useful. 
> Posting some links here would be nice.
>
>> I see 30-50MB/s faster speeds with NCQ turned off on two different SW 
>> RAID5s.
>
> You're testing raptors, right?  If the performance drop is that drastic and 
> consistent over different workloads, we'll have to disable NCQ for raptors. 
> I'm not sure about other drives.  Care to perform tests over more popular 
> ones (e.g. recent seagates or 7200rpm wds)?
>
> -- 
> tejun
>

You are correct, it definitely depends upon the workload, and a lot of the 
benchmarks do use Windows; however, I will have to check later, I recall 
finding a few that did test under Linux.

For a plain untar with lots of small files, the benefit is not as big as 
sequential reads/writes of big files; however, there is still an 
improvement:

Raid5 Quad 150 Raptor (NCQ)
# time sh -c 'tar xf linux-2.6.20.tar; sync'

real    0m21.721s
user    0m0.174s
sys     0m1.541s

Raid5 Quad 150 Raptor (NO NCQ)
# time sh -c 'tar xf linux-2.6.20.tar; sync'

real    0m16.761s
user    0m0.195s
sys     0m1.361s

Raid5 Six 400GB Sata Drives (NO NCQ)
# time sh -c 'tar xf linux-2.6.20.tar; sync'
real    0m54.844s
user    0m0.189s
sys     0m1.432s

Raid5 Six 400GB Sata Drives (NCQ)
# time sh -c 'tar xf linux-2.6.20.tar; sync'
real    1m7.322s
user    0m0.194s
sys     0m1.492s

Justin.
