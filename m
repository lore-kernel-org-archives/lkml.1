Return-Path: <linux-kernel-owner+w=401wt.eu-S1761752AbZFKB6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761752AbZFKB6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 21:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758922AbZFKB6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 21:58:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47242 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757978AbZFKB6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 21:58:00 -0400
Date: Wed, 10 Jun 2009 21:58:01 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Huang Ying <ying.huang@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Subject: Re: [PATCH 3/3] ring-buffer: add design document
In-Reply-To: <1244681467.8361.654.camel@yhuang-dev.sh.intel.com>
Message-ID: <alpine.DEB.2.00.0906102155420.30552@gandalf.stny.rr.com>
References: <20090610195311.767699959@goodmis.org>  <20090610195525.429316815@goodmis.org> <1244681467.8361.654.camel@yhuang-dev.sh.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 11 Jun 2009, Huang Ying wrote:

> On Thu, 2009-06-11 at 03:53 +0800, Steven Rostedt wrote:
> > +
> > +cmpxchg - hardware assisted atomic transaction that performs the following:
> > +
> > +   A = B iff previous A == C
> > +
> > +   R = cmpxchg(A, C, B) is saying that we replace A with B if and only if
> > +      current A is equal to C, and we put the old (current) A into R
> > +
> > +   R gets the previous A regardless if A is updated with B or not.
> > +
> > +   To see if the update was successful a compare of R == C may be used.
> 
> As far as I know, some architectures have no hardware assisted (NMI
> safe) cmpxchg. Is it OK to use cmpxchg in architecture-independent code?

I can fall back to the lock solution for those archs without cmpxchg. It 
is NMI safe, because we do spin_trylock() in NMI context. If we fail to 
acquire the lock in NMI context, we simply drop the packet.

Are these archs without cmpxchg and NMIs, a concern for you?

-- Steve

