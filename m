Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab0BJKR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 05:17:27 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:33303 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab0BJKR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 05:17:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fmDBXOxAW58tVmHo+h/gzUFxRL+gSVwVBj91DSPifFx5unv2cwTikAcVWfOTTezRyi
         mGBdRqdqMW09zFzK3pa9NVV3+vsj6t21Rpp3PUbzol12w2orHDuyxuJAkdLi8wqaMdOD
         gMUBHCVlUettF2n8eauwIKjX4RxsQsAjf3JWU=
Date: Wed, 10 Feb 2010 11:17:07 +0100
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
Message-ID: <20100210101703.GB5035@nowhere>
References: <20100205104937.GB29515@elte.hu> <1265371808.22001.502.camel@laptop> <1265371973.22001.508.camel@laptop> <1265374915.22001.562.camel@laptop> <20100206111209.GC5062@nowhere> <1265455442.30057.499.camel@laptop> <20100206114046.GD5062@nowhere> <1265465867.30057.507.camel@laptop> <20100206161052.GB5060@nowhere> <1265535955.12224.17.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265535955.12224.17.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 07, 2010 at 10:45:55AM +0100, Peter Zijlstra wrote:
> On Sat, 2010-02-06 at 17:10 +0100, Frederic Weisbecker wrote:
> > 
> > > > Looks pretty what I'm looking for. Except that it still continues
> > > > to fill and keep track of the locks held by the current thread,
> > > > namely the copies in curr->held_locks.
> > > 
> > > Which is exactly what you need for that lock hierarchy recording you
> > > wanted :-)
> > 
> > 
> > Well, the lock hierarchy should probably be retrieved from the traces,
> > using state machines.
> > Otherwise we would need yet other lock events for that, which is going
> > to add even more overhead.
> 
> 
> Right, well you could look at adding a mode that also strips out the
> held_lock tracing, but since you really need the register class stuff to
> re-generate the class mapping, avoiding the held_lock tracing doesn't
> look like it's going to save you much, its all thread local storage.


But if we draw a tree based representation (per-instances or per-class)
from perf lock, we'll already need to get the locking scenarios from
post processing, which induce the dependencies.

I don't think it will help much.

Thanks.

