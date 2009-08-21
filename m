Return-Path: <linux-kernel-owner+w=401wt.eu-S932208AbZHUO2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208AbZHUO2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 10:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755652AbZHUO2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 10:28:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38665 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755659AbZHUO2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 10:28:36 -0400
Date: Fri, 21 Aug 2009 16:28:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Patch 0/1] HW-BKPT: Allow per-cpu kernel-space Hardware
	Breakpoint requests
Message-ID: <20090821142811.GF11098@elte.hu>
References: <20090817124641.GA13354@in.ibm.com> <20090819161119.GA3633@in.ibm.com> <20090819173259.GF4972@nowhere> <20090820172719.GA16499@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820172719.GA16499@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* K.Prasad <prasad@linux.vnet.ibm.com> wrote:

> > Providing those would let us build a pmu struct on top of this 
> > high level API, hopefully.

Note that there's a PMU struct already in 
arch/x86/kernel/cpu/perf_counter.c. Could debug-register ops be 
tacked on to it?

> > All that would be a benefit in both sides. It avoids us building 
> > a low level PMU that reinvent the wheel, ie: the hardware 
> > breakpoints API handles a lot of things both in arch and core 
> > sides (debug register setting tricks with dr7 and co, cpu 
> > hotplug, kexec, etc...). In the bp API it brings more power 
> > (register switching only if needed, per cpu support, clone 
> > inheritance support, etc...)
> > 
> > And in the end we have a pmu (which unifies the control of this 
> > profiling unit through a well established and known object for 
> > perfcounter) controlled by a high level API that could also 
> > benefit to other debugging subsystems.
> > 
> > What do you think? It would be also nice to have Peter's and 
> > Ingo opinion about it, to be sure we are not going in the wrong 
> > direction.
> 
> Indeed, it will be nice to know from Ingo and Peter that we are 
> heading right.

If you do this proper perfcounters integration then i'm certainly 
happy.

	Ingo
