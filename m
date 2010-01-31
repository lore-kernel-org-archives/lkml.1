Return-Path: <linux-kernel-owner+w=401wt.eu-S1754441Ab0AaUoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab0AaUoM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 15:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147Ab0AaUoK
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 15:44:10 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:37660 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570Ab0AaUoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 15:44:09 -0500
Date: Sun, 31 Jan 2010 21:44:08 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 00/12] perf lock: New subcommand "perf lock", for
	analyzing  lock statistics
Message-ID: <20100131204408.GC13771@kernel.dk>
References: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <20100129143403.GJ13771@kernel.dk> <4B641F4D.6090704@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B641F4D.6090704@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 30 2010, Hitoshi Mitake wrote:
> (2010???01???29??? 23:34), Jens Axboe wrote:
>> On Fri, Jan 22 2010, Hitoshi Mitake wrote:
>>    
>>> Adding new subcommand "perf lock" to perf.
>>>
>>> I made this patch series on
>>> latest perf/core of tip (ef12a141306c90336a3a10d40213ecd98624d274),
>>> so please apply this series to perf/core.
>>>      
>> [snip]
>>
>> I wanted to give this a go today, since I think it's pretty nifty and a
>> lot better than using /proc/lock_stat. But it basically spirals the
>> system into death [1]. How big a system did you test this on?
>>
>> [1] Got this: [  117.097918] hrtimer: interrupt took 35093901 ns
>>
>>    
>
> I tested this on Core i7 965 + 3GB DRAM machine.
> Test program is mainly "perf bench sched messaging".
>
> Could you tell me the detail of your test situation?

I tried to run it on a 64 thread box, on a fio job that was driving 80
disks. It was just a quick test, but after ~20 seconds it had not even
gotten started yet, it was still stuck in setting up the jobs and
traversing sysfs for finding disk stats, etc. I can try something
lighter to see if it's the cpu count or the tough job that was making it
spiral into (near) death.

-- 
Jens Axboe

