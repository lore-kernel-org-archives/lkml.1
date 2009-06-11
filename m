Return-Path: <linux-kernel-owner+w=401wt.eu-S1761756AbZFKCdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761756AbZFKCdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 22:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbZFKCdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 22:33:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:42000 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184AbZFKCdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 22:33:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,199,1243839600"; 
   d="scan'208";a="420703621"
Subject: Re: [PATCH 3/3] ring-buffer: add design document
From: Huang Ying <ying.huang@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       Christoph Hellwig <hch@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <alpine.DEB.2.00.0906102155420.30552@gandalf.stny.rr.com>
References: <20090610195311.767699959@goodmis.org>
	 <20090610195525.429316815@goodmis.org>
	 <1244681467.8361.654.camel@yhuang-dev.sh.intel.com>
	 <alpine.DEB.2.00.0906102155420.30552@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Thu, 11 Jun 2009 10:33:01 +0800
Message-Id: <1244687581.8361.703.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-11 at 09:58 +0800, Steven Rostedt wrote:
> On Thu, 11 Jun 2009, Huang Ying wrote:
> 
> > On Thu, 2009-06-11 at 03:53 +0800, Steven Rostedt wrote:
> > > +
> > > +cmpxchg - hardware assisted atomic transaction that performs the following:
> > > +
> > > +   A = B iff previous A == C
> > > +
> > > +   R = cmpxchg(A, C, B) is saying that we replace A with B if and only if
> > > +      current A is equal to C, and we put the old (current) A into R
> > > +
> > > +   R gets the previous A regardless if A is updated with B or not.
> > > +
> > > +   To see if the update was successful a compare of R == C may be used.
> > 
> > As far as I know, some architectures have no hardware assisted (NMI
> > safe) cmpxchg. Is it OK to use cmpxchg in architecture-independent code?
> 
> I can fall back to the lock solution for those archs without cmpxchg. It 
> is NMI safe, because we do spin_trylock() in NMI context. If we fail to 
> acquire the lock in NMI context, we simply drop the packet.

Yes. For users do not care about packet drop, it is acceptable. But
please select the implementation at run-time instead of build time.
Because on some architecture such as ARM, whether CPU has cmpxchg
support is determined at run-time.

> Are these archs without cmpxchg and NMIs, a concern for you?

ARM has no cmpxchg until ARM v6, but it has NMI like mechanism named
FIQ.

Best Regards,
Huang Ying


