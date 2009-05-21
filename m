Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbZEUDaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbZEUDaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 23:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755358AbZEUDaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 23:30:08 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1311 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbZEUDaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 23:30:06 -0400
Subject: Re: [PATCH] include KERN_* constant in printk calls
From: Joe Perches <joe@perches.com>
To: Chris Sanford <crsanford@gmail.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       peterz@infradead.org
In-Reply-To: <20090521024635.GA4030@chrisubuntu-laptop>
References: <20090518233121.GC3109@chrisubuntu-laptop>
	 <20090519090049.GB9388@elte.hu> <20090520043215.GA3077@chrisubuntu-laptop>
	 <20090520083719.GG6736@elte.hu>  <20090521024635.GA4030@chrisubuntu-laptop>
Content-Type: text/plain
Date: Wed, 20 May 2009 20:30:01 -0700
Message-Id: <1242876601.3373.17.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris.

Minor comments.

On Wed, 2009-05-20 at 19:46 -0700, Chris Sanford wrote:
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 26efa47..cfe42e7 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
[]
> @@ -6501,10 +6501,10 @@ void show_state_filter(unsigned long state_filter)
>  	struct task_struct *g, *p;
>  
>  #if BITS_PER_LONG == 32
> -	printk(KERN_INFO
> +	pr_info(
>  		"  task                PC stack   pid father\n");
>  #else
> -	printk(KERN_INFO
> +	pr_info(
>  		"  task                        PC stack   pid father\n");
>  #endif
>  	read_lock(&tasklist_lock);

One line please.  pr_info("  task etc...

> @@ -6833,7 +6833,7 @@ again:
>  		 * leave kernel.
>  		 */
>  		if (p->mm && printk_ratelimit()) {
> -			printk(KERN_INFO "process %d (%s) no "
> +			pr_info("process %d (%s) no "
>  			       "longer affine to cpu%d\n",
>  			       task_pid_nr(p), p->comm, dead_cpu);
>  		}

pr_info("process $d (%s) no longer affine to cpu%d\n"

> @@ -7315,52 +7315,52 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
>  
>  	cpulist_scnprintf(str, sizeof(str), sched_domain_span(sd));
>  	cpumask_clear(groupmask);
> -
> -	printk(KERN_DEBUG "%*s domain %d: ", level, "", level);
> -
> +	
> +	pr_info("%*s domain %d: ", level, "", level);
> +	
>  	if (!(sd->flags & SD_LOAD_BALANCE)) {
> -		printk("does not load-balance\n");
> +		pr_cont("does not load-balance\n");
>  		if (sd->parent)
> -			printk(KERN_ERR "ERROR: !SD_LOAD_BALANCE domain"
> +			pr_err("ERROR: !SD_LOAD_BALANCE domain"
>  					" has parent");

Make single line and add "\n"?

			pr_err("ERROR: !SD_LOAD_BALANCE domain has parent\n"
>  		return -1;
>  	}
>  
> -	printk(KERN_CONT "span %s level %s\n", str, sd->name);
> +	pr_cont("span %s level %s\n", str, sd->name);
>  
>  	if (!cpumask_test_cpu(cpu, sched_domain_span(sd))) {
> -		printk(KERN_ERR "ERROR: domain->span does not contain "
> +		pr_err("ERROR: domain->span does not contain "
>  				"CPU%d\n", cpu);

Single line?

>  	}
>  	if (!cpumask_test_cpu(cpu, sched_group_cpus(group))) {
> -		printk(KERN_ERR "ERROR: domain->groups does not contain"
> +		pr_err("ERROR: domain->groups does not contain"
>  				" CPU%d\n", cpu);

Single line?

> @@ -7368,22 +7368,22 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
>  
>  		cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
>  
> -		printk(KERN_CONT " %s", str);
> +		pr_cont(" %s", str);
>  		if (group->__cpu_power != SCHED_LOAD_SCALE) {
> -			printk(KERN_CONT " (__cpu_power = %d)",
> +			pr_cont(" (__cpu_power = %d)",
>  				group->__cpu_power);
>  		}
>  
>  		group = group->next;
>  	} while (group != sd->groups);
> -	printk(KERN_CONT "\n");
> +	pr_cont("\n");
>  
>  	if (!cpumask_equal(sched_domain_span(sd), groupmask))
> -		printk(KERN_ERR "ERROR: groups don't span domain->span\n");
> +		pr_err("ERROR: groups don't span domain->span\n");
>  
>  	if (sd->parent &&
>  	    !cpumask_subset(groupmask, sched_domain_span(sd->parent)))
> -		printk(KERN_ERR "ERROR: parent span is not a superset "
> +		pr_err("ERROR: parent span is not a superset "
>  			"of domain->span\n");

Single line?

> @@ -8095,14 +8095,14 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
>  	sched_group_nodes = kcalloc(nr_node_ids, sizeof(struct sched_group *),
>  				    GFP_KERNEL);
>  	if (!sched_group_nodes) {
> -		printk(KERN_WARNING "Can not alloc sched group node list\n");
> +		pr_warning("Can not alloc sched group node list\n");
>  		goto free_tmpmask;
>  	}
>  #endif
>  
>  	rd = alloc_rootdomain();
>  	if (!rd) {
> -		printk(KERN_WARNING "Cannot alloc root domain\n");
> +		pr_warning("Cannot alloc root domain\n");
>  		goto free_sched_groups;
>  	}
>  

"Can not" vs "Cannot", maybe choose a single style?

> @@ -8241,7 +8241,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
>  		sg = kmalloc_node(sizeof(struct sched_group) + cpumask_size(),
>  				  GFP_KERNEL, i);
>  		if (!sg) {
> -			printk(KERN_WARNING "Can not alloc domain group for "
> +			pr_warning("Can not alloc domain group for "
>  				"node %d\n", i);

Single line string?  Maybe:
			pr_warning("Can not alloc domain group for node %d\n",
				   i);

> @@ -9075,10 +9075,10 @@ void __might_sleep(char *file, int line)
>  		return;
>  	prev_jiffy = jiffies;
>  
> -	printk(KERN_ERR
> +	pr_err(
>  		"BUG: sleeping function called from invalid context at %s:%d\n",
>  			file, line);

pr_err("BUG: etc

> -	printk(KERN_ERR
> +	pr_err(
>  		"in_atomic(): %d, irqs_disabled(): %d, pid: %d, name: %s\n",
>  			in_atomic(), irqs_disabled(),
>  			current->pid, current->comm);

here too.

cheers, Joe

