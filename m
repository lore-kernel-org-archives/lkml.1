Return-Path: <linux-kernel-owner+w=401wt.eu-S1752190AbZHSQLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbZHSQLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbZHSQLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:11:33 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:43505 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbZHSQLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:11:33 -0400
Date: Wed, 19 Aug 2009 21:41:19 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Patch 0/1] HW-BKPT: Allow per-cpu kernel-space Hardware
	Breakpoint requests
Message-ID: <20090819161119.GA3633@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090817124641.GA13354@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090817124641.GA13354@in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 06:16:41PM +0530, K.Prasad wrote:
> Hi All,
> 	Please find a patch that enables kernel-space breakpoints to be
> requested for a subset of the available CPUs in the system. This allows
> per-CPU breakpoints and comes with the associated benefit of reduced
> overhead during (un)registration.
> 
> This enhancement allows exploitation of hardware breakpoint registers by
> 'perf' which produces a CPU-wise information.
> 
> Design changes
> --------------
> - Every breakpoint request 'consumes' the first available debug register
>   (starting from HBP_NUM) in each CPU represented by 'cpumask' field in
>   'struct hw_breakpoint'.
> 
> - 'hbp_kernel_pos' (that separates kernel-space breakpoints from the
>   free/user-space breakpoints) now points to the maximum of debug
>   registers consumed on any given CPU.
>   -- 'hbp_kernel_pos' is decremented (one-at-a-time) to allow a new-slot
>      for kernel-space requests iff all debug registers on the given CPU
>      (from HBP_NUM - 1 to 'hbp_kernel_pos' are already consumed.
>   -- 'hbp_kernel_pos' is incremented (one-at-a-time) to free a slot iff
>      a removal request results in the release of a bkpt request that
>      consumed maximum debug registers for kernel-space.
> 
> - Every removal request results in compaction of breakpoint registers
>   (on a per-cpu basis) to occupy the vacant debug register.
>  
> The patch is based on commit b6c720b811aed0eeda89f277f13c1bd1bdf721fd of
> -tip tree and has been tested to work fine on an x86 machine for both
> cases (i.e. system-wide kernel breakpoints and bkpts for a subset of CPUs).
> 
> Please let me know your comments on the same.
> 
> Thanks,
> K.Prasad
> 

Hi Frederic,
	Do you find these patches, that provide the ability to restrict
kernel-space breakpoints to any given subset of CPUs, to bring the
requisite features for exploitation of hw-bkpt by 'perf tools'?

Also of interest would be the reduced overhead associated with
(un)register_kernel_hw_breakpoint() operations (no IPI in case of
single-CPU breakpoint request).

Thanks,
K.Prasad

