Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab0BENAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 08:00:06 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:44378 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047Ab0BENAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 08:00:04 -0500
Date: Fri, 5 Feb 2010 14:00:02 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kswapd continuously active
Message-ID: <20100205130002.GI1025@kernel.dk>
References: <alpine.LSU.2.01.1001230037350.20442@obet.zrqbmnf.qr> <20100125130627.GO13771@kernel.dk> <alpine.LSU.2.01.1001251416340.8189@obet.zrqbmnf.qr> <alpine.LSU.2.01.1002051329090.7843@obet.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.1002051329090.7843@obet.zrqbmnf.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05 2010, Jan Engelhardt wrote:
> 
> On Monday 2010-01-25 14:22, Jan Engelhardt wrote:
> >On Monday 2010-01-25 14:06, Jens Axboe wrote:
> >>> 
> >>> with 2.6.32.2 on sparc64 I am seeing that there is a sync(1) process 
> >>> busy in D state, with the following trace:
> >>> 
> >>> sync          D 000000000079299c  7552  4851      1 0x208061101000004
> >>> Call Trace:
> >>>  [000000000053ca58] bdi_sched_wait+0xc/0x1c[...]
> >>>  [000000000053ca78] sync_inodes_sb+0x10/0xfc
> >>> 
> >>> kswapd is also active all the time, writing something to disk[...]
> >>
> >>That doesn't sound good. What does /proc/meminfo say? What file systems
> >>are you using?
> 
> >January 25			Feb-05
> >MemTotal:        8166752 kB	8166752
> >MemFree:         3243552 kB	3781776
> >Buffers:          207968 kB	4912
> >Cached:          2728216 kB	2684400
> >SwapCached:            0 kB	0
> >Active:          2203136 kB	495624
> >Inactive:        2152544 kB	3263136
> >Active(anon):    1167256 kB	488168
> >Inactive(anon):   252952 kB	583912
> >Active(file):    1035880 kB	7456
> >Inactive(file):  1899592 kB	2679224
> >Unevictable:           0 kB	0
> >Mlocked:               0 kB	0
> >SwapTotal:             0 kB	0
> >SwapFree:              0 kB	0
> >Dirty:            141624 kB	2662184
> >Writeback:             0 kB	..
> 
> Today this happened again. So I looked at /proc/meminfo to paste today's
> values next to those from January. That is when I noticed the "Dirty"
> value - and thus I ran
> 
> 	watch -d -n 1 'grep Dirty /proc/meminfo'
> 
> What I see is that the dirty amount - a sync is currently running -
> only decreases with at most 400 KB/sec, often less than that.

I'm guessing the barriers and commits are what is killing your
performance. What happens with barrier=0?

-- 
Jens Axboe

