Return-Path: <linux-kernel-owner+w=401wt.eu-S934304AbYD1NnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934304AbYD1NnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 09:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932312AbYD1NnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 09:43:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57519 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932291AbYD1NnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:43:11 -0400
Date: Mon, 28 Apr 2008 15:42:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] x86: cleanup early per cpu variables/accesses
	v5-folded
Message-ID: <20080428134253.GD3973@elte.hu>
References: <20080426001548.829332000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426001548.829332000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> 1/11:	Increase the limit of NR_CPUS to 4096 and introduce a boolean
> 	called "MAXSMP" which when set (e.g. "allyesconfig"), will set
> 	NR_CPUS = 4096 and NODES_SHIFT = 9 (512).  Changed max setting
> 	for NODES_SHIFT from 15 to 9 to accurately reflect the real limit.
> 
> 2/11:	Introduce a new PER_CPU macro called "EARLY_PER_CPU".  This is
> 	used by some per_cpu variables that are initialized and accessed
> 	before there are per_cpu areas allocated.
> 
> 	Add a flag "arch_provides_topology_pointers" that indicates pointers
> 	to topology cpumask_t maps are available.  Otherwise, use the function
> 	returning the cpumask_t value.  This is useful if cpumask_t set size
> 	is very large to avoid copying data on to/off of the stack.
> 
> 3/11:	Restore the nodenumber field in the x86_64 pda.  This field is slightly
> 	different than the x86_cpu_to_node_map mainly because it's a static
> 	indication of which node the cpu is on while the cpu to node map is a
> 	dyanamic mapping that may get reset if the cpu goes offline.  This also
> 	simplifies the numa_node_id() macro.
> 
> 4/11:	Consolidate node_to_cpumask operations and remove the 256k
> 	byte node_to_cpumask_map.  This is done by allocating the
> 	node_to_cpumask_map array after the number of possible
> 	nodes (nr_node_ids) is known.
> 
> 5/11:	Replace usages of MAX_NUMNODES with nr_node_ids in kernel/sched.c,
> 	where appropriate.  This saves some allocated space as well as many
> 	wasted cycles going through node entries that are non-existent.
> 
> 6/11:	Changed some global definitions in drivers/base/cpu.c to static.
> 
> 7/11:	Remove 544k bytes from the kernel by removing the boot_cpu_pda
> 	array from the data section and allocating it during startup.
> 
> 8/11:	Increase performance for systems with large count NR_CPUS by
> 	limiting the range of the cpumask operators that loop over
> 	the bits in a cpumask_t variable.  This removes a large amount
> 	of wasted cpu cycles.
> 
> 9/11:	Change references from for_each_cpu_mask to for_each_cpu_mask_ptr
> 	in all cases for x86_64 and generic code.
> 
> 10/11:	Change references from next_cpu to next_cpu_nr (or for_each_cpu_mask_ptr
> 	if applicable), in all cases for x86_64 and generic code.
> 
> 11/11:  Pass reference to cpumask variable in net/sunrpc/svc.c

thanks Travis, applied.

	Ingo
