Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbYKFPBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbYKFPBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbYKFPBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:01:13 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:52264 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbYKFPBM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:01:12 -0500
Message-ID: <49130694.7000007@cosmosbay.com>
Date: Thu, 06 Nov 2008 16:00:36 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Robert Richter <robert.richter@amd.com>,
       Andi Kleen <andi@firstfloor.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: linux-2.6.28-rc2 regression : oprofile doesnt work anymore ?
References: <4909F690.9090208@cosmosbay.com> <84144f020810310721x1d1eccbeica5d10608d7b2e57@mail.gmail.com> <20081104181855.GK9785@erda.amd.com> <Pine.LNX.4.64.0811042118460.1597@melkki.cs.Helsinki.FI> <4910CD65.1010301@cosmosbay.com> <49113894.5040806@cosmosbay.com>
In-Reply-To: <49113894.5040806@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 06 Nov 2008 16:00:51 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> Eric Dumazet a écrit :
>> Pekka J Enberg a écrit :
>>> Hi Robert,
>>>
>>> On Tue, 4 Nov 2008, Robert Richter wrote:
>>>> your patchset breaks oprofile on Intel Core 2 cpus. I could bisect the
>>>> bug for c493756..5951290. Please take a look at this and send me a fix.
>>>
>>> Unfortunately I don't have my machine with me right now so I can't 
>>> test this, but don't we want something like this? Andi?
>>
>> Thanks a lot Pekka, this patch restores oprofile on my HP BL460c G1
>>
>> Tested-by: Eric Dumazet <dada1@cosmosbay.com>
> 
> Update :
> 
> After a while, no more NMI are delivered. No anymore samples.
> 

Ingo asked me to test a revert of b99170288421c79f0c2efa8b33e26e65f4bb7fb8
(oprofile: Implement Intel architectural perfmon support)

Same problem than previous patch.

(doing a tbench 8 in background)

oprofile works a few seconds, then no more NMI / samples

# opcontrol --vmlinux=vmlinux --start
Using 2.6+ OProfile kernel interface.
Reading module info.
Using log file /var/lib/oprofile/samples/oprofiled.log
Daemon started.
Profiler running.
# grep NMI /proc/interrupts
NMI:    3102535    1009518     733819    2088857    1414146     703880    1229563     473603   Non-maskable interrupts
# grep NMI /proc/interrupts
NMI:    3490492    1009518     767878    2212917    1812791    1654826    2151141     473603   Non-maskable interrupts
# grep NMI /proc/interrupts
NMI:    3490492    1009518     767878    2212917    1812791    2188653    2671979     473603   Non-maskable interrupts
# grep NMI /proc/interrupts
NMI:    3490492    1009518     767878    2212917    1812791    2612789    2671979     473603   Non-maskable interrupts
# grep NMI /proc/interrupts
NMI:    3490492    1009518     767878    2212917    1812791    2612789    2671979     473603   Non-maskable interrupts
# opcontrol --deinit
Stopping profiling.
Killing daemon.
# grep NMI /proc/interrupts
NMI:    3490492    1009518     767878    2212917    1812791    2612789    2671979     473603   Non-maskable interrupts
# opcontrol --vmlinux=vmlinux --start
Using 2.6+ OProfile kernel interface.
Reading module info.
Using log file /var/lib/oprofile/samples/oprofiled.log
Daemon started.
Profiler running.
# grep NMI /proc/interrupts
NMI:    3730357    1265822    1174545    2485635    2257881    3082318    3078445     931068   Non-maskable interrupts
# grep NMI /proc/interrupts
NMI:    3730357    1265822    1573509    2485635    2469701    3512810    3477233    1143043   Non-maskable interrupts
# grep NMI /proc/interrupts
NMI:    3730357    1265822    2069149    2485635    2469701    3512810    3511350    1143043   Non-maskable interrupts
# grep NMI /proc/interrupts
NMI:    3730357    1265822    2069149    2485635    2469701    3512810    3511350    1143043   Non-maskable interrupts
# grep NMI /proc/interrupts
NMI:    3730357    1265822    2069149    2485635    2469701    3512810    3511350    1143043   Non-maskable interrupts

# grep . /dev/oprofile/*/* /dev/oprofile/*
/dev/oprofile/0/count:10000
/dev/oprofile/0/enabled:1
/dev/oprofile/0/event:60
/dev/oprofile/0/kernel:1
/dev/oprofile/0/unit_mask:0
/dev/oprofile/0/user:1
/dev/oprofile/1/count:0
/dev/oprofile/1/enabled:0
/dev/oprofile/1/event:0
/dev/oprofile/1/kernel:0
/dev/oprofile/1/unit_mask:0
/dev/oprofile/1/user:0
/dev/oprofile/stats/bt_lost_no_mapping:0
/dev/oprofile/stats/event_lost_overflow:83466
/dev/oprofile/stats/sample_lost_no_mapping:19174
/dev/oprofile/stats/sample_lost_no_mm:0
/dev/oprofile/backtrace_depth:0
grep: /dev/oprofile/buffer: Device or resource busy
/dev/oprofile/buffer_size:131072
/dev/oprofile/buffer_watershed:32768
/dev/oprofile/cpu_buffer_size:8192
/dev/oprofile/cpu_type:i386/core_2
grep: /dev/oprofile/dump: Invalid argument
/dev/oprofile/enable:1
/dev/oprofile/pointer_size:4

I tried with bigger buffer_size, same problem

opcontrol --vmlinux=vmlinux --cpu-buffer-size=65536 --buffer-size=1048576 --start

# grep . /dev/oprofile/*/* /dev/oprofile/*
/dev/oprofile/0/count:10000
/dev/oprofile/0/enabled:1
/dev/oprofile/0/event:60
/dev/oprofile/0/kernel:1
/dev/oprofile/0/unit_mask:0
/dev/oprofile/0/user:1
/dev/oprofile/1/count:0
/dev/oprofile/1/enabled:0
/dev/oprofile/1/event:0
/dev/oprofile/1/kernel:0
/dev/oprofile/1/unit_mask:0
/dev/oprofile/1/user:0
/dev/oprofile/stats/bt_lost_no_mapping:0
/dev/oprofile/stats/event_lost_overflow:1465392
/dev/oprofile/stats/sample_lost_no_mapping:117498
/dev/oprofile/stats/sample_lost_no_mm:20
/dev/oprofile/backtrace_depth:0
grep: /dev/oprofile/buffer: Device or resource busy
/dev/oprofile/buffer_size:1048576
/dev/oprofile/buffer_watershed:32768
/dev/oprofile/cpu_buffer_size:65536
/dev/oprofile/cpu_type:i386/core_2
grep: /dev/oprofile/dump: Invalid argument
/dev/oprofile/enable:1
/dev/oprofile/pointer_size:4

