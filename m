Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab0BGJqm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 04:46:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:59766 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab0BGJqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 04:46:40 -0500
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
In-Reply-To: <20100206161052.GB5060@nowhere>
References: <1265363102.22001.286.camel@laptop>
	 <1265363441.22001.300.camel@laptop> <20100205104937.GB29515@elte.hu>
	 <1265371808.22001.502.camel@laptop> <1265371973.22001.508.camel@laptop>
	 <1265374915.22001.562.camel@laptop> <20100206111209.GC5062@nowhere>
	 <1265455442.30057.499.camel@laptop> <20100206114046.GD5062@nowhere>
	 <1265465867.30057.507.camel@laptop>  <20100206161052.GB5060@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 07 Feb 2010 10:45:55 +0100
Message-ID: <1265535955.12224.17.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-06 at 17:10 +0100, Frederic Weisbecker wrote:
> 
> > > Looks pretty what I'm looking for. Except that it still continues
> > > to fill and keep track of the locks held by the current thread,
> > > namely the copies in curr->held_locks.
> > 
> > Which is exactly what you need for that lock hierarchy recording you
> > wanted :-)
> 
> 
> Well, the lock hierarchy should probably be retrieved from the traces,
> using state machines.
> Otherwise we would need yet other lock events for that, which is going
> to add even more overhead.


Right, well you could look at adding a mode that also strips out the
held_lock tracing, but since you really need the register class stuff to
re-generate the class mapping, avoiding the held_lock tracing doesn't
look like it's going to save you much, its all thread local storage.

