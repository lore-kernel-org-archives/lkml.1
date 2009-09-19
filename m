Return-Path: <linux-kernel-owner+w=401wt.eu-S1752735AbZISVQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbZISVQS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZISVQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:16:18 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49530 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbZISVQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:16:17 -0400
Date: Sat, 19 Sep 2009 14:15:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH tip/core/rcu] RCU whitespace fixes
Message-ID: <20090919211552.GB6674@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090918172819.GA24405@linux.vnet.ibm.com> <20090919070552.GB17617@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090919070552.GB17617@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 19, 2009 at 09:05:52AM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Fix a number of whitespace ^Ierrors in the include/linux/rcu* and the 
> > kernel/rcu* files.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> > 
> >  include/linux/rculist_nulls.h |    2 +-
> >  include/linux/rcupdate.h      |    6 +++---
> >  include/linux/rcutree.h       |    2 +-
> >  kernel/rcupdate.c             |    4 ++--
> >  kernel/rcutorture.c           |    4 ++--
> >  kernel/rcutree.c              |    2 +-
> >  kernel/rcutree.h              |    2 +-
> >  kernel/rcutree_plugin.h       |    4 ++--
> >  kernel/rcutree_trace.c        |    2 +-
> >  9 files changed, 14 insertions(+), 14 deletions(-)
> 
> thanks Paul - i also did a few more checkpatch trivial fixes to create a 
> clean baseline.

Many thanks!!!

And I have added --patch to my "git format-patch script".

> Here's a full list of the remaining 'problems' in kernel/rcu*.[ch] files 
> checked via checkpatch --file kernel/rcu*.[ch] , with annotations by me 
> that suggest resolutions:

Thank you for looking this over -- I clearly need to get checkpatch
back into my workflow.  :-/

I will resolve these after I finish getting rcutiny forward-ported and
shrunk a bit further.  The rcutiny work is critically needed to repair
a rent in the space-time continuum...  :-)

							Thanx, Paul

> [ Andy: see one checkpatch bug mentioned below. Plus it would be 
>   _really_ nice if line 80 warnings would only be emitted if the line 
>   also contains 2 or more tabs - i.e. excessive nesting. Longer than 100 
>   lines should be warned about unconditionally. ]
> 
> -----------------------
> WARNING: externs should be avoided in .c files
> #262: FILE: rcupdate.c:262:
> +extern int rcu_cpu_notify(struct notifier_block *self,
> 
> -----------------------> Move rcu_cpu_notify() prototype to rcutree.h?
> 
> WARNING: line over 80 characters
> #87: FILE: rcutorture.c:87:
> +	do { printk(KERN_ALERT "%s" TORTURE_FLAG s "\n", torture_type); } while (0)
> 
> -----------------------> Ignore.
> 
> WARNING: line over 80 characters
> #89: FILE: rcutorture.c:89:
> +	do { if (verbose) printk(KERN_ALERT "%s" TORTURE_FLAG s "\n", torture_type); } while (0)
> 
> -----------------------> Ignore.
> 
> WARNING: line over 80 characters
> #91: FILE: rcutorture.c:91:
> +	do { if (verbose) printk(KERN_ALERT "%s" TORTURE_FLAG "!!! " s "\n", torture_type); } while (0)
> 
> -----------------------> Ignore.
> 
> WARNING: line over 80 characters
> #247: FILE: rcutorture.c:247:
> +			schedule_timeout_interruptible(round_jiffies_relative(HZ));
> 
> -----------------------> Ignore.
> 
> WARNING: externs should be avoided in .c files
> #609: FILE: rcutorture.c:609:
> +extern int rcu_expedited_torture_stats(char *page);
> 
> -----------------------> Move rcu_expedited_torture_stats() prototype to sched.h?
> 
> CHECK: memory barrier without comment
> #653: FILE: rcutorture.c:653:
> +		smp_wmb();
> 
> -----------------------> Add comment?
> 
> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> #56: FILE: rcutree.c:56:
> +EXPORT_SYMBOL_GPL(rcu_lock_map);
> 
> -----------------------> checkpatch.pl bug?
> 
> WARNING: externs should be avoided in .c files
> #84: FILE: rcutree.c:84:
> +extern long rcu_batches_completed_sched(void);
> 
> -----------------------> Move rcu_batches_completed_sched() to sched.h?
> 
> WARNING: usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc
> #1498: FILE: rcutree.c:1498:
> +	cprv = NR_CPUS;
> 
> -----------------------> Ignore.
> 
> WARNING: usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc
> #1535: FILE: rcutree.c:1535:
> +			if (rnp->grphi >= NR_CPUS)
> 
> -----------------------> Ignore.
> 
> WARNING: usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc
> #1536: FILE: rcutree.c:1536:
> +				rnp->grphi = NR_CPUS - 1;
> 
> -----------------------> Ignore.
> 
> WARNING: usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc
> #48: FILE: rcutree.h:48:
> +#elif NR_CPUS <= RCU_FANOUT_SQ
> 
> -----------------------> Ignore.
> 
> WARNING: usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc
> #54: FILE: rcutree.h:54:
> +#elif NR_CPUS <= RCU_FANOUT_CUBE
> 
> -----------------------> Ignore.
> 
> CHECK: spinlock_t definition without comment
> #82: FILE: rcutree.h:82:
> +	spinlock_t lock;
> 
> -----------------------> Add comment?
> 
> WARNING: struct file_operations should normally be const
> #96: FILE: rcutree_trace.c:96:
> +static struct file_operations rcudata_fops = {
> 
> -----------------------> Add const?
> 
> WARNING: struct file_operations should normally be const
> #148: FILE: rcutree_trace.c:148:
> +static struct file_operations rcudata_csv_fops = {
> 
> -----------------------> Add const?
> 
> ERROR: code indent should use tabs where possible
> #162: FILE: rcutree_trace.c:162:
> +^I              "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu\n",$
> 
> -----------------------> s/        /^T/
> 
> WARNING: struct file_operations should normally be const
> #199: FILE: rcutree_trace.c:199:
> +static struct file_operations rcuhier_fops = {
> 
> -----------------------> Add const?
> 
> WARNING: struct file_operations should normally be const
> #225: FILE: rcutree_trace.c:225:
> +static struct file_operations rcugp_fops = {
> 
> -----------------------> Add const?
> 
> WARNING: struct file_operations should normally be const
> #279: FILE: rcutree_trace.c:279:
> +static struct file_operations rcu_pending_fops = {
> 
> -----------------------> Add const?
> 
> Thanks,
> 
> 	Ingo
