Return-Path: <linux-kernel-owner+w=401wt.eu-S1761964AbZFKCiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761964AbZFKCiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 22:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbZFKCiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 22:38:08 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:49454 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753949AbZFKCiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 22:38:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqoEAI8IMEpMQW1W/2dsb2JhbACBT84GhA0F
Date: Wed, 10 Jun 2009 22:38:07 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       Christoph Hellwig <hch@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 3/3] ring-buffer: add design document
Message-ID: <20090611023807.GA12407@Krystal>
References: <20090610195311.767699959@goodmis.org> <20090610195525.429316815@goodmis.org> <1244681467.8361.654.camel@yhuang-dev.sh.intel.com> <alpine.DEB.2.00.0906102155420.30552@gandalf.stny.rr.com> <1244687581.8361.703.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1244687581.8361.703.camel@yhuang-dev.sh.intel.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:36:39 up 102 days, 23:02,  5 users,  load average: 0.19, 0.39,
	0.36
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Huang Ying (ying.huang@intel.com) wrote:
> On Thu, 2009-06-11 at 09:58 +0800, Steven Rostedt wrote:
> > On Thu, 11 Jun 2009, Huang Ying wrote:
> > 
> > > On Thu, 2009-06-11 at 03:53 +0800, Steven Rostedt wrote:
> > > > +
> > > > +cmpxchg - hardware assisted atomic transaction that performs the following:
> > > > +
> > > > +   A = B iff previous A == C
> > > > +
> > > > +   R = cmpxchg(A, C, B) is saying that we replace A with B if and only if
> > > > +      current A is equal to C, and we put the old (current) A into R
> > > > +
> > > > +   R gets the previous A regardless if A is updated with B or not.
> > > > +
> > > > +   To see if the update was successful a compare of R == C may be used.
> > > 
> > > As far as I know, some architectures have no hardware assisted (NMI
> > > safe) cmpxchg. Is it OK to use cmpxchg in architecture-independent code?
> > 
> > I can fall back to the lock solution for those archs without cmpxchg. It 
> > is NMI safe, because we do spin_trylock() in NMI context. If we fail to 
> > acquire the lock in NMI context, we simply drop the packet.
> 
> Yes. For users do not care about packet drop, it is acceptable. But
> please select the implementation at run-time instead of build time.
> Because on some architecture such as ARM, whether CPU has cmpxchg
> support is determined at run-time.
> 
> > Are these archs without cmpxchg and NMIs, a concern for you?
> 
> ARM has no cmpxchg until ARM v6, but it has NMI like mechanism named
> FIQ.
> 

One could probably adapt the cmpxchg for earlier ARM so it disables
FIQs. Note that the current limitation is that there is only a
fiq disable, not a fiq save/restore.

Mathieu

> Best Regards,
> Huang Ying
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
