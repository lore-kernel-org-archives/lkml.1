Return-Path: <linux-kernel-owner+w=401wt.eu-S1754414AbYKXRSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbYKXRSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 12:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbYKXRR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 12:17:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46795 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbYKXRR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 12:17:56 -0500
Date: Mon, 24 Nov 2008 18:17:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PULL] cpumask conversion patches for sched
Message-ID: <20081124171749.GB27851@elte.hu>
References: <200811250238.53883.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811250238.53883.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> Hi Ingo,
> 
>    Keeping track of sched.c changes without breaking linux-next has 
> proven impossible, so I've split the sched patches out for you, 
> split them nicely, and rebased against your linux-2.6-sched.  Please 
> pull.
> 
>    Works for me (with and without CONFIG_CPUMASK_OFFSTACK), but 
> there are a large number of config variations possible that I might 
> have broken.  Not to mention outright bugs.
> 
> The following changes since commit b27fef5b222564b6e7ae71f7110c233b2fb45a38:
>   Ingo Molnar (1):
>         Merge branch 'x86/defconfig'
> 
> are available in the git repository at:
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-ingo.git master
> 
> Mike Travis (1):
>       sched: Reduce stack size requirements in kernel/sched.c
> 
> Rusty Russell (20):
>       sched: convert sched.c from for_each_cpu_mask to for_each_cpu.
>       sched: get rid of boutique sched.c allocations, use cpumask_var_t.
>       sched: remove any_online_cpu()
>       sched: wrap sched_group and sched_domain cpumask accesses.
>       sched: convert struct sched_group/sched_domain cpumask_ts to variable bitmaps
>       sched: convert nohz_cpu_mask to cpumask_var_t.
>       sched: convert struct root_domain to cpumask_var_t.
>       sched: convert nohz struct to cpumask_var_t.
>       sched: convert idle_balance() to cpumask_var_t.
>       sched: convert rebalance_domains() to cpumask_var_t.
>       sched: convert sys_sched_getaffinity() to cpumask_var_t.
>       sched: avoid stack var in move_task_off_dead_cpu
>       sched: convert struct (sys_)sched_setaffinity() to cpumask_var_t.
>       sched: convert sched_domain_debug to cpumask_var_t.
>       sched: convert cpu_isolated_map to cpumask_var_t.
>       sched: convert falback_doms to cpumask_var_t.
>       sched: convert struct cpupri_vec cpumask_var_t.
>       sched: convert check_preempt_equal_prio to cpumask_var_t.
>       sched: convert local_cpu_mask to cpumask_var_t.
>       sched: convert remaining old-style cpumask operators
> 
>  include/linux/sched.h    |   35 ++-
>  kernel/rcuclassic.c      |    2 +-
>  kernel/sched.c           |  885 +++++++++++++++++++++++++---------------------
>  kernel/sched_cpupri.c    |   39 ++-
>  kernel/sched_cpupri.h    |    5 +-
>  kernel/sched_fair.c      |   14 +-
>  kernel/sched_rt.c        |   73 +++--
>  kernel/sched_stats.h     |    3 +-
>  kernel/time/tick-sched.c |   10 +-
>  9 files changed, 589 insertions(+), 477 deletions(-)

Pulled into tip/cpus4096, thanks Rusty!

Here are the new sha1's:

 96f874e: sched: convert remaining old-style cpumask operators
 0e3900e: sched: convert local_cpu_mask to cpumask_var_t.
 24600ce: sched: convert check_preempt_equal_prio to cpumask_var_t.
 68e7456: sched: convert struct cpupri_vec cpumask_var_t.
 4212823: sched: convert falback_doms to cpumask_var_t.
 dcc30a3: sched: convert cpu_isolated_map to cpumask_var_t.
 d5dd3db: sched: convert sched_domain_debug to cpumask_var_t.
 5a16f3d: sched: convert struct (sys_)sched_setaffinity() to cpumask_var_t.
 e76bd8d: sched: avoid stack var in move_task_off_dead_cpu
 f17c860: sched: convert sys_sched_getaffinity() to cpumask_var_t.
 a0e9024: sched: convert rebalance_domains() to cpumask_var_t.
 4d2732c: sched: convert idle_balance() to cpumask_var_t.
 7d1e6a9: sched: convert nohz struct to cpumask_var_t.
 c6c4927: sched: convert struct root_domain to cpumask_var_t.
 6a7b3dc: sched: convert nohz_cpu_mask to cpumask_var_t.
 6c99e9a: sched: convert struct sched_group/sched_domain cpumask_ts to variable bitmaps
 758b2cd: sched: wrap sched_group and sched_domain cpumask accesses.
 1e5ce4f: sched: remove any_online_cpu()
 3404c8d: sched: get rid of boutique sched.c allocations, use cpumask_var_t.
 abcd083: sched: convert sched.c from for_each_cpu_mask to for_each_cpu.
 ea6f18e: sched: reduce stack size requirements in kernel/sched.c
 943f3d0: Merge branches 'sched/core', 'core/core' and 'tracing/core' into cpus4096

The tip/cpus4096 topic tree is -git based and will be append-only with 
stable sha1's unless there's some really bad messup forcing a rebase.

I've also merged your commits into tip/master and have done cross-arch 
build testing:

testing 9 architectures.
testing      alpha:  -git:  pass ( 18),  -tip:  pass ( 18)
testing        arm:  -git:  pass (  5),  -tip:  pass (  5)
testing       cris:  -git:  pass ( 28),  -tip:  pass ( 18)
testing       i386:  -git:  pass ( 11),  -tip:  pass ( 11)
testing       ia64:  -git:  pass (132),  -tip:  pass (135)
testing       m32r:  -git:  pass ( 24),  -tip:  pass ( 24)
testing       m68k:  -git:  pass (150),  -tip:  pass (150)
testing       mips:  -git:  pass ( 12),  -tip:  pass (  4)
testing    powerpc:  -git:  pass ( 12),  -tip:  pass ( 10)

( The decimal number in paranthesis is the count of build warnings. 
  Twelve other architectures i have crosscompilers for do not 
  currently build fine on -git, with arch defconfigs, using latest gcc
  4.3.3. )

Based on these good test results i've also integrated a new 
cpus4096-next tree and pushed it out for linux-next pickup.

Thanks,

	Ingo
