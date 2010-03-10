Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab0CJPzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 10:55:15 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:41483 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756766Ab0CJPzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 10:55:14 -0500
Date: Wed, 10 Mar 2010 16:55:11 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 1/3] lockdep: Move lock events under lockdep recursion
	protection
Message-ID: <20100310155511.GZ5768@kernel.dk>
References: <1267599302-2886-1-git-send-regression-fweisbec@gmail.com> <1267599302-2886-2-git-send-regression-fweisbec@gmail.com> <20100309083410.GD5768@kernel.dk> <20100309234518.GE5058@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100309234518.GE5058@nowhere>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10 2010, Frederic Weisbecker wrote:
> On Tue, Mar 09, 2010 at 09:34:10AM +0100, Jens Axboe wrote:
> > I went to try this on 2.6.34-rc1 to see how much it would improve things
> > here. With 2.6.34-rc1, a
> > 
> > $ time sudo perf lock record ls /dev/shm
> > 
> > essentially hangs the box, it ends up crashing hard (not just live
> > locked like before). With the patch in place, it does eventually finish:
> > 
> > real    0m21.301s
> > user    0m0.030s
> > sys     0m21.040s
> > 
> > The directory is empty.
> 
> 
> Hehe :-)
> 
> That said you are probably missing a part of the puzzle.
> This patch avoids the scary recursions we had. But there
> is another separate patch that fixes the buffers multiplexing
> dependency we had. Buffering is now done per cpu.
> 
> You need this patch:
> 
> 	commit b67577dfb45580c498bfdb1bc76c00c3b2ad6310
> 	Author: Frederic Weisbecker <fweisbec@gmail.com>
> 	Date:   Wed Feb 3 09:09:33 2010 +0100
> 
> 	perf lock: Drop the buffers multiplexing dependency
> 
> But this is not in -rc1, you need to checkout tip/perf/core
> 
> Well, the best would be you actually pull this on top of -rc1:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/core
> 
> so that you get the buffers multiplexing dependency that is in -tip,
> and you also get the recursions fixes, not yet in -tip (but should make
> it soon).
> 
> I bet you still won't have magic results after that, but still it should
> be better.

OK, I will give it a spin and see what happens. I had seen the
de-multiplexing patch, but just assumed it was in -rc1 already.

> We still have further projects in mind to improve the scalability,
> like the events injection thing (that avoids the string copy)
> 
> Again, you are my eyes on this, I'm still blind with my poor dual
> laptop or my atom testbox.
> 
> Thanks for your testing.

Not a problem, thank you for trying to get some nicer lock profiling in
the kernel :-)

-- 
Jens Axboe

