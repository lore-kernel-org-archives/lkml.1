Return-Path: <linux-kernel-owner+w=401wt.eu-S1757820AbZALWV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820AbZALWV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbZALWVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:21:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42599 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbZALWVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:21:19 -0500
Date: Mon, 12 Jan 2009 23:20:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] irq: update all archs to use new irq_desc
	cpumask_var_t's.
Message-ID: <20090112222040.GA15294@elte.hu>
References: <20090112220519.566749000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112220519.566749000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

> Impact: cleanup, use new cpumask API.
> 
> Minor cleanup to use the new affinity and pending_mask cpumask_var_t's
> in irq_desc:
> 
> 	alpha irq: update alpha for new irq_desc
> 	arm irq: update arm for new irq_desc
> 	blackfin irq: update blackfin for new irq_desc
> 	ia64 irq: update ia64 for new irq_desc
> 	mips irq: update mips for new irq_desc
> 	parisc irq: update parisc for new irq_desc
> 	powerpc irq: update powerpc for new irq_desc
> 	arm irq: update arm for new irq_desc

this should all be a single patch, because the cpus4096 tree does not 
build on these arhitectures right now.

in fact, i think i'll rebase the whole lineup (so no need to resend - i'll 
squash these fixes together), because this is how it looks like right now:

28e0886: xen: fix too early kmalloc call
92296c6: cpumask, irq: non-x86 build failures
542d865: kstat: modify kstat_irqs_legacy to be variable sized
9332fcc: irq: initialize nr_irqs based on nr_cpu_ids
0fa0ebb: irq: allocate irq_desc_ptrs array based on nr_irqs
e2f4d06: irq: use WARN() instead of WARN_ON().
9594949: irq: change references from NR_IRQS to nr_irqs
c7a3589: Xen: reduce memory required for cpu_evtchn_mask
d38b223: cpumask: reduce stack usage in find_lowest_rq
c90e785: cpumask: use cpumask_var_t in dcdbas.c
f9b9056: x86: reduce stack usage in init_intel_cacheinfo
a1c33bb: x86: cleanup remaining cpumask_t code in mce_amd_64.c
0e21990: SGI UV cpumask: use static temp cpumask in flush_tlb
4595f96: x86: change flush_tlb_others to take a const struct cpumask
802bf93: cpumask: fix bug in use cpumask_var_t in irq_desc
651f811: cpumask: convert other misc kernel functions
2f8975f: cpumask: convert drivers/net/sfc
f7df8ed: cpumask: convert misc driver functions
fbd59a8: cpumask: Use topology_core_cpumask()/topology_thread_cpumask()
7f7ace0: cpumask: update irq_desc to use cpumask_var_t

those architectures break with the first patch: 7f7ace0. That's bisection 
breakage window of about 20 commits - too big and we want to avoid it if 
we can (and we still can).

	Ingo
