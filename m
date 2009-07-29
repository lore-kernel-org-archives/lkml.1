Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbZG2O6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbZG2O6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 10:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbZG2O6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 10:58:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59952 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258AbZG2O6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 10:58:03 -0400
Date: Wed, 29 Jul 2009 11:57:18 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: prasad@linux.vnet.ibm.com, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 5/5] perfcounter: Add support for kernel hardware
	breakpoints
Message-ID: <20090729145718.GB3040@ghostprotocols.net>
References: <20090724174723.GA11985@nowhere> <1248519416.5780.12.camel@laptop> <20090725141918.GA5295@nowhere> <1248538972.5780.25.camel@laptop> <20090725235702.GA5082@in.ibm.com> <1248684817.6987.1573.camel@twins> <20090728161218.GA3526@in.ibm.com> <1248799286.6987.3026.camel@twins> <20090729063704.GA3297@in.ibm.com> <1248859372.6987.3062.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248859372.6987.3062.camel@twins>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 29, 2009 at 11:22:52AM +0200, Peter Zijlstra escreveu:
> On Wed, 2009-07-29 at 12:07 +0530, K.Prasad wrote:
> 
> > > That still doesn't provide per-cpu breakpoints.
> > > 
> > 
> > Yes, it doesn't provide a per-cpu only implementation. One can obtain
> > the per-cpu data from the system-wide breakpoints by filtering it for a
> > given CPU (agreed, it will associated overhead).
> > 
> > A true per-cpu breakpoint implementation that co-exists with
> > system-wide and per-task breakpoints will be difficult. It might require
> > the re-introduction of some old features and a few new ones (like switching
> > between kernel and user-space breakpoints at syscall time) that were
> > rejected earlier by the community.
> 
> I'm not clear on why you'd need to switch breakpoints on syscall entry.
> You can simply leave the kernel address breakpoint around in userspace,
> they're not able to poke at that address space anyway.
> 
> > Also, the reason for a per-cpu only breakpoint (user and kernel-space)
> > isn't very obvious. While kernel variables can be read/written
> > throughout the system and user-space variables are per-task, the need
> > for obtaining per-cpu information isn't clear.
> 
> Well, suppose you're monitoring a per-cpu variable, or interested in the
> effects of a workload confined to 1 cpu or node, there is no reason to
> have this breakpoint on all cpus.

I was going to talk about exactly that, CPU isolation for one specific
workload, I don't want that hits on tcp_v4_rcv on another CPU get
counted, just the ones on that specific CPU.

The other CPUs can be given a break (pun intended :-P) by not having to
process traps we're uninterested in.

- Arnaldo
