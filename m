Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab0BFLk6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 06:40:58 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:48659 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab0BFLk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 06:40:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Xl427iShuep8wcHQ/1jgfl727b8JxY6/xKCvFZqaBXZ/Pgj8WeNdDEeIL+ml6dLATo
         TSf+yWmprLh5x1o8EVxzGYFZC5ztYrzOyW223DUKaDn+9GSCkN7oFU7HhcWy6YYL6eQl
         P/lGs57FApC4Wa/79lUPTCFe7dQQby+FTBrk8=
Date: Sat, 6 Feb 2010 12:40:49 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       paulmck@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 10/11] tracing/perf: Fix lock events recursions in the
	fast path
Message-ID: <20100206114046.GD5062@nowhere>
References: <20100204154700.GE6676@linux.vnet.ibm.com> <4B6B84A1.60805@cn.fujitsu.com> <1265363102.22001.286.camel@laptop> <1265363441.22001.300.camel@laptop> <20100205104937.GB29515@elte.hu> <1265371808.22001.502.camel@laptop> <1265371973.22001.508.camel@laptop> <1265374915.22001.562.camel@laptop> <20100206111209.GC5062@nowhere> <1265455442.30057.499.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265455442.30057.499.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 06, 2010 at 12:24:02PM +0100, Peter Zijlstra wrote:
> On Sat, 2010-02-06 at 12:12 +0100, Frederic Weisbecker wrote:
> 
> > That said, I think this is good for a first step, but we can't continue
> > to force the lock events -> lockdep dependency in the long term. We
> > can't have a serious lock profiling if we are doomed to suffer the
> > slowness due to lockdep checks at the same time.
> > 
> > Sure we can continue to support having both, but I think we should also
> > think about a solution to handle lock events without it in the future.
> > That will require some minimal lockdep functionalities (keeping the
> > lockdep map, and class hashes).
> 
> You mean like building without CONFIG_PROVE_LOCKING, or boot with
> lockdep.prove_locking=0, or use echo 0
> > /sys/modules/lockdep/prove_locking ?
> 
> That keeps the lock tracking but does away with all the dependency
> analysis and was created for just such an use case as you are looking
> at, namely lockstat.


Looks pretty what I'm looking for. Except that it still continues
to fill and keep track of the locks held by the current thread,
namely the copies in curr->held_locks.

