Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463Ab0AYNGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab0AYNGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 08:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694Ab0AYNG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 08:06:29 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:55038 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab0AYNG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 08:06:29 -0500
Date: Mon, 25 Jan 2010 14:06:27 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kswapd continuously active
Message-ID: <20100125130627.GO13771@kernel.dk>
References: <alpine.LSU.2.01.1001230037350.20442@obet.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.1001230037350.20442@obet.zrqbmnf.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 23 2010, Jan Engelhardt wrote:
> Hi,
> 
> 
> with 2.6.32.2 on sparc64 I am seeing that there is a sync(1) process 
> busy in D state, with the following trace:
> 
> sync          D 000000000079299c  7552  4851      1 0x208061101000004
> Call Trace:
>  [000000000053ca58] bdi_sched_wait+0xc/0x1c
>  [000000000079299c] __wait_on_bit+0x58/0xb8
>  [0000000000792a5c] out_of_line_wait_on_bit+0x60/0x74
>  [000000000053ca3c] bdi_sync_writeback+0x6c/0x7c
>  [000000000053ca78] sync_inodes_sb+0x10/0xfc
>  [0000000000540dd0] __sync_filesystem+0x50/0x88
>  [0000000000540ec8] sync_filesystems+0xc0/0x124
>  [0000000000540f80] sys_sync+0x1c/0x48
>  [0000000000406294] linux_sparc_syscall+0x34/0x44
> 
> kswapd is also active all the time, writing something to disk - LED is 
> blinking, and that's been going on for over half an hour despite the box 
> being not busy. How do I see what kswapd is still flushing to disk? Even 
> if all RAM (8 GB) was filled with dirty data, syncing it out would not 
> take that long - that is to say, the sync process should have long 
> exited.

That doesn't sound good. What does /proc/meminfo say? What file systems
are you using?

-- 
Jens Axboe

