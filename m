Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbZHYUdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbZHYUdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 16:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755523AbZHYUdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 16:33:14 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:57815 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281AbZHYUdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 16:33:13 -0400
Date: Wed, 26 Aug 2009 02:03:07 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Patch 0/1] HW-BKPT: Allow per-cpu kernel-space Hardware
	Breakpoint requests
Message-ID: <20090825203307.GA5834@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090817124641.GA13354@in.ibm.com> <20090819161119.GA3633@in.ibm.com> <20090819173259.GF4972@nowhere> <20090820172719.GA16499@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820172719.GA16499@in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 10:57:19PM +0530, K.Prasad wrote:
> On Wed, Aug 19, 2009 at 07:33:00PM +0200, Frederic Weisbecker wrote:
> > On Wed, Aug 19, 2009 at 09:41:19PM +0530, K.Prasad wrote:
> > > On Mon, Aug 17, 2009 at 06:16:41PM +0530, K.Prasad wrote:
> > > > Hi All,
> > > > 	Please find a patch that enables kernel-space breakpoints to be
> > > > requested for a subset of the available CPUs in the system. This allows
> > > > per-CPU breakpoints and comes with the associated benefit of reduced
> > > > overhead during (un)registration.
> > > > 
> > > > This enhancement allows exploitation of hardware breakpoint registers by
> > > > 'perf' which produces a CPU-wise information.
> > > > 
> [edited]
> > > 
> > > Hi Frederic,
> > > 	Do you find these patches, that provide the ability to restrict
> > > kernel-space breakpoints to any given subset of CPUs, to bring the
> > > requisite features for exploitation of hw-bkpt by 'perf tools'?
> > > 
> > > Also of interest would be the reduced overhead associated with
> > > (un)register_kernel_hw_breakpoint() operations (no IPI in case of
> > > single-CPU breakpoint request).
> > > 
[edited]
> > - having a callback that quickly swap two breakpoints in order to support
> >   the hardware register multiplexing. I guess the pmu object would just need
> >   to call it when the multiplexing is decided.
> > 
> > 
> 
> Are you suggesting something like a modify_kernel_hw_breakpoint() that
> can quickly change a breakpoint address/characteristics?
> 
> That's quite doable...it requires a quick validation through
> arch_validate_hwbkpt_settings() and the requisite IPIs (depending on
> what the new cpumask is).
> 
> I will send a patch to that effect soon.
>

Hi Frederic,
	I just sent a patchset that adds the ability to specify per-cpu
kernel-space breakpoints + a (relatively) lightweight function to modify
the characteristics of a kernel-space breakpoint that can be used to
swap between two breakpoint requests.

Please pull them into -tip tree if you find them mature and ready.

With these new feature additions, I see the HW-Breakpoint infrastructure
code ready to meet the needs for exploitation by perf-tools and I presume
you would restart your effort on the same?

Thanks,
K.Prasad

