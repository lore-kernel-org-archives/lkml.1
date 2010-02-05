Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab0BENJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 08:09:06 -0500
Received: from borg.medozas.de ([188.40.89.202]:38105 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab0BENJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 08:09:02 -0500
Date: Fri, 5 Feb 2010 14:09:01 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kswapd continuously active
In-Reply-To: <20100205130002.GI1025@kernel.dk>
Message-ID: <alpine.LSU.2.01.1002051408280.23211@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1001230037350.20442@obet.zrqbmnf.qr> <20100125130627.GO13771@kernel.dk> <alpine.LSU.2.01.1001251416340.8189@obet.zrqbmnf.qr> <alpine.LSU.2.01.1002051329090.7843@obet.zrqbmnf.qr> <20100205130002.GI1025@kernel.dk>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2010-02-05 14:00, Jens Axboe wrote:
>> >January 25			Feb-05
>> >MemTotal:        8166752 kB	8166752
>> >MemFree:         3243552 kB	3781776
>> >Buffers:          207968 kB	4912
>> >Cached:          2728216 kB	2684400
>> >SwapCached:            0 kB	0
>> >Active:          2203136 kB	495624
>> >Inactive:        2152544 kB	3263136
>> >Active(anon):    1167256 kB	488168
>> >Inactive(anon):   252952 kB	583912
>> >Active(file):    1035880 kB	7456
>> >Inactive(file):  1899592 kB	2679224
>> >Unevictable:           0 kB	0
>> >Mlocked:               0 kB	0
>> >SwapTotal:             0 kB	0
>> >SwapFree:              0 kB	0
>> >Dirty:            141624 kB	2662184
>> >Writeback:             0 kB	..
>> 
>> Today this happened again. So I looked at /proc/meminfo to paste today's
>> values next to those from January. That is when I noticed the "Dirty"
>> value - and thus I ran
>> 
>> 	watch -d -n 1 'grep Dirty /proc/meminfo'
>> 
>> What I see is that the dirty amount - a sync is currently running -
>> only decreases with at most 400 KB/sec, often less than that.
>
>I'm guessing the barriers and commits are what is killing your
>performance. What happens with barrier=0?

The ext4 filesystem is already mounted with barrier=0. If there
is any block-level barriers I also can turn off, what would be
the command?


thanks,
Jan
