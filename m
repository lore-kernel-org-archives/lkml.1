Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448Ab0BCKZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 05:25:46 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:37397 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932439Ab0BCKZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 05:25:42 -0500
Date: Wed, 3 Feb 2010 11:25:41 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [RFC GIT PULL] perf/trace/lock optimization/scalability
	improvements
Message-ID: <20100203102540.GQ5733@kernel.dk>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03 2010, Frederic Weisbecker wrote:
> Hi,
> 
> There are many things that happen in this patchset, treating
> different problems:
> 
> - remove most of the string copy overhead in fast path
> - open the way for lock class oriented profiling (as
>   opposite to lock instance profiling. Both can be useful
>   in different ways).
> - remove the buffers muliplexing (less contention)
> - event injection support
> - remove violent lock events recursion (only 2 among 3, the remaining
>   one is detailed below).
> 
> Some differences, by running:
> 	perf lock record perf sched pipe -l 100000
> 
> Before the patchset:
> 
> 	Total time: 91.015 [sec]
> 
> 	     910.157300 usecs/op
> 		   1098 ops/sec
> 
> After this patchset applied:
> 
> 	Total time: 43.706 [sec]
> 
> 	     437.062080 usecs/op
> 		   2288 ops/sec

This does a lot better here, even if it isn't exactly stellar
performance. It generates a LOT of data:

root@nehalem:/dev/shm # time perf lock rec -fg ls
perf.data  perf.data.old
[ perf record: Woken up 0 times to write data ]
[ perf record: Captured and wrote 137.224 MB perf.data (~5995421
samples) ]

real    0m3.320s
user    0m0.000s
sys     0m3.220s

Without -g, it has 1.688s real and 1.590s sys time.

So while this is orders of magnitude better than the previous patchset,
it's still not anywhere near lean. But I expect you know that, just
consider this a 'I tested it and this is what happened' report :-)

-- 
Jens Axboe

