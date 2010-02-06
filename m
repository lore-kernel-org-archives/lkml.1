Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab0BFOSH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 09:18:07 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51659 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab0BFOSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 09:18:05 -0500
Subject: Re: [PATCH 10/11] tracing/perf: Fix lock events recursions in the
 fast path
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       paulmck@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <20100206114046.GD5062@nowhere>
References: <20100204154700.GE6676@linux.vnet.ibm.com>
	 <4B6B84A1.60805@cn.fujitsu.com> <1265363102.22001.286.camel@laptop>
	 <1265363441.22001.300.camel@laptop> <20100205104937.GB29515@elte.hu>
	 <1265371808.22001.502.camel@laptop> <1265371973.22001.508.camel@laptop>
	 <1265374915.22001.562.camel@laptop> <20100206111209.GC5062@nowhere>
	 <1265455442.30057.499.camel@laptop>  <20100206114046.GD5062@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 06 Feb 2010 15:17:47 +0100
Message-ID: <1265465867.30057.507.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-06 at 12:40 +0100, Frederic Weisbecker wrote:
> On Sat, Feb 06, 2010 at 12:24:02PM +0100, Peter Zijlstra wrote:
> > On Sat, 2010-02-06 at 12:12 +0100, Frederic Weisbecker wrote:
> > 
> > > That said, I think this is good for a first step, but we can't continue
> > > to force the lock events -> lockdep dependency in the long term. We
> > > can't have a serious lock profiling if we are doomed to suffer the
> > > slowness due to lockdep checks at the same time.
> > > 
> > > Sure we can continue to support having both, but I think we should also
> > > think about a solution to handle lock events without it in the future.
> > > That will require some minimal lockdep functionalities (keeping the
> > > lockdep map, and class hashes).
> > 
> > You mean like building without CONFIG_PROVE_LOCKING, or boot with
> > lockdep.prove_locking=0, or use echo 0
> > > /sys/modules/lockdep/prove_locking ?
> > 
> > That keeps the lock tracking but does away with all the dependency
> > analysis and was created for just such an use case as you are looking
> > at, namely lockstat.
> 
> 
> Looks pretty what I'm looking for. Except that it still continues
> to fill and keep track of the locks held by the current thread,
> namely the copies in curr->held_locks.

Which is exactly what you need for that lock hierarchy recording you
wanted :-)

