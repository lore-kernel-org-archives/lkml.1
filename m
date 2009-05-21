Return-Path: <linux-kernel-owner+w=401wt.eu-S1756621AbZEUCwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbZEUCwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 22:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbZEUCwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 22:52:32 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:48661 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbZEUCwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 22:52:31 -0400
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 May 2009 22:52:30 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=GUqpvmcZ9ZrZivJ/59O3Lir9dUvODJuDTVWiiuuiDU9n0v7NnMbA8jdEKJMa0DJw3b
         zeQyI6yVMB7cDHjbkwmJcs1frRod/LOZ+rEgzMdGLXnkkZohFyBo/VqMkQ4U4dyMDrGD
         FPj53X6Wvr5u+ItMQ6Z7j2aVVZaZKOXyHxUks=
Date: Wed, 20 May 2009 19:46:35 -0700
From: Chris Sanford <crsanford@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH] include KERN_* constant in printk calls
Message-ID: <20090521024635.GA4030@chrisubuntu-laptop>
Mail-Followup-To: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org, peterz@infradead.org
References: <20090518233121.GC3109@chrisubuntu-laptop> <20090519090049.GB9388@elte.hu> <20090520043215.GA3077@chrisubuntu-laptop> <20090520083719.GG6736@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090520083719.GG6736@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the updated patch for sched.c. It replaces all the printk calls with their
corresponding pr_* call. The five KERN_DEBUG calls have been changed to
pr_info.

Signed-off-by: Chris Sanford <crsanford@gmail.com>

---


diff --git a/kernel/sched.c b/kernel/sched.c
index 26efa47..cfe42e7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4912,7 +4912,7 @@ static noinline void __schedule_bug(struct task_struct *prev)
 {
 	struct pt_regs *regs = get_irq_regs();
 
-	printk(KERN_ERR "BUG: scheduling while atomic: %s/%d/0x%08x\n",
+	pr_err("BUG: scheduling while atomic: %s/%d/0x%08x\n",
 		prev->comm, prev->pid, preempt_count());
 
 	debug_show_held_locks(prev);
@@ -6474,23 +6474,23 @@ void sched_show_task(struct task_struct *p)
 	unsigned state;
 
 	state = p->state ? __ffs(p->state) + 1 : 0;
-	printk(KERN_INFO "%-13.13s %c", p->comm,
+	pr_info("%-13.13s %c", p->comm,
 		state < sizeof(stat_nam) - 1 ? stat_nam[state] : '?');
 #if BITS_PER_LONG == 32
 	if (state == TASK_RUNNING)
-		printk(KERN_CONT " running  ");
+		pr_cont(" running  ");
 	else
-		printk(KERN_CONT " %08lx ", thread_saved_pc(p));
+		pr_cont(" %08lx ", thread_saved_pc(p));
 #else
 	if (state == TASK_RUNNING)
-		printk(KERN_CONT "  running task    ");
+		pr_cont("  running task    ");
 	else
-		printk(KERN_CONT " %016lx ", thread_saved_pc(p));
+		pr_cont(" %016lx ", thread_saved_pc(p));
 #endif
 #ifdef CONFIG_DEBUG_STACK_USAGE
 	free = stack_not_used(p);
 #endif
-	printk(KERN_CONT "%5lu %5d %6d\n", free,
+	pr_cont("%5lu %5d %6d\n", free,
 		task_pid_nr(p), task_pid_nr(p->real_parent));
 
 	show_stack(p, NULL);
@@ -6501,10 +6501,10 @@ void show_state_filter(unsigned long state_filter)
 	struct task_struct *g, *p;
 
 #if BITS_PER_LONG == 32
-	printk(KERN_INFO
+	pr_info(
 		"  task                PC stack   pid father\n");
 #else
-	printk(KERN_INFO
+	pr_info(
 		"  task                        PC stack   pid father\n");
 #endif
 	read_lock(&tasklist_lock);
@@ -6833,7 +6833,7 @@ again:
 		 * leave kernel.
 		 */
 		if (p->mm && printk_ratelimit()) {
-			printk(KERN_INFO "process %d (%s) no "
+			pr_info("process %d (%s) no "
 			       "longer affine to cpu%d\n",
 			       task_pid_nr(p), p->comm, dead_cpu);
 		}
@@ -7315,52 +7315,52 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 
 	cpulist_scnprintf(str, sizeof(str), sched_domain_span(sd));
 	cpumask_clear(groupmask);
-
-	printk(KERN_DEBUG "%*s domain %d: ", level, "", level);
-
+	
+	pr_info("%*s domain %d: ", level, "", level);
+	
 	if (!(sd->flags & SD_LOAD_BALANCE)) {
-		printk("does not load-balance\n");
+		pr_cont("does not load-balance\n");
 		if (sd->parent)
-			printk(KERN_ERR "ERROR: !SD_LOAD_BALANCE domain"
+			pr_err("ERROR: !SD_LOAD_BALANCE domain"
 					" has parent");
 		return -1;
 	}
 
-	printk(KERN_CONT "span %s level %s\n", str, sd->name);
+	pr_cont("span %s level %s\n", str, sd->name);
 
 	if (!cpumask_test_cpu(cpu, sched_domain_span(sd))) {
-		printk(KERN_ERR "ERROR: domain->span does not contain "
+		pr_err("ERROR: domain->span does not contain "
 				"CPU%d\n", cpu);
 	}
 	if (!cpumask_test_cpu(cpu, sched_group_cpus(group))) {
-		printk(KERN_ERR "ERROR: domain->groups does not contain"
+		pr_err("ERROR: domain->groups does not contain"
 				" CPU%d\n", cpu);
 	}
 
-	printk(KERN_DEBUG "%*s groups:", level + 1, "");
+	pr_info("%*s groups:", level + 1, "");
 	do {
 		if (!group) {
-			printk("\n");
-			printk(KERN_ERR "ERROR: group is NULL\n");
+			pr_cont("\n");
+			pr_err("ERROR: group is NULL\n");
 			break;
 		}
 
 		if (!group->__cpu_power) {
-			printk(KERN_CONT "\n");
-			printk(KERN_ERR "ERROR: domain->cpu_power not "
+			pr_cont("\n");
+			pr_err("ERROR: domain->cpu_power not "
 					"set\n");
 			break;
 		}
 
 		if (!cpumask_weight(sched_group_cpus(group))) {
-			printk(KERN_CONT "\n");
-			printk(KERN_ERR "ERROR: empty group\n");
+			pr_cont("\n");
+			pr_err("ERROR: empty group\n");
 			break;
 		}
 
 		if (cpumask_intersects(groupmask, sched_group_cpus(group))) {
-			printk(KERN_CONT "\n");
-			printk(KERN_ERR "ERROR: repeated CPUs\n");
+			pr_cont("\n");
+			pr_err("ERROR: repeated CPUs\n");
 			break;
 		}
 
@@ -7368,22 +7368,22 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 
 		cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
 
-		printk(KERN_CONT " %s", str);
+		pr_cont(" %s", str);
 		if (group->__cpu_power != SCHED_LOAD_SCALE) {
-			printk(KERN_CONT " (__cpu_power = %d)",
+			pr_cont(" (__cpu_power = %d)",
 				group->__cpu_power);
 		}
 
 		group = group->next;
 	} while (group != sd->groups);
-	printk(KERN_CONT "\n");
+	pr_cont("\n");
 
 	if (!cpumask_equal(sched_domain_span(sd), groupmask))
-		printk(KERN_ERR "ERROR: groups don't span domain->span\n");
+		pr_err("ERROR: groups don't span domain->span\n");
 
 	if (sd->parent &&
 	    !cpumask_subset(groupmask, sched_domain_span(sd->parent)))
-		printk(KERN_ERR "ERROR: parent span is not a superset "
+		pr_err("ERROR: parent span is not a superset "
 			"of domain->span\n");
 	return 0;
 }
@@ -7394,14 +7394,14 @@ static void sched_domain_debug(struct sched_domain *sd, int cpu)
 	int level = 0;
 
 	if (!sd) {
-		printk(KERN_DEBUG "CPU%d attaching NULL sched-domain.\n", cpu);
+		pr_info("CPU%d attaching NULL sched-domain.\n", cpu);
 		return;
 	}
 
-	printk(KERN_DEBUG "CPU%d attaching sched-domain:\n", cpu);
+	pr_info("CPU%d attaching sched-domain:\n", cpu);
 
 	if (!alloc_cpumask_var(&groupmask, GFP_KERNEL)) {
-		printk(KERN_DEBUG "Cannot load-balance (out of memory)\n");
+		pr_info("Cannot load-balance (out of memory)\n");
 		return;
 	}
 
@@ -8095,14 +8095,14 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 	sched_group_nodes = kcalloc(nr_node_ids, sizeof(struct sched_group *),
 				    GFP_KERNEL);
 	if (!sched_group_nodes) {
-		printk(KERN_WARNING "Can not alloc sched group node list\n");
+		pr_warning("Can not alloc sched group node list\n");
 		goto free_tmpmask;
 	}
 #endif
 
 	rd = alloc_rootdomain();
 	if (!rd) {
-		printk(KERN_WARNING "Cannot alloc root domain\n");
+		pr_warning("Cannot alloc root domain\n");
 		goto free_sched_groups;
 	}
 
@@ -8241,7 +8241,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 		sg = kmalloc_node(sizeof(struct sched_group) + cpumask_size(),
 				  GFP_KERNEL, i);
 		if (!sg) {
-			printk(KERN_WARNING "Can not alloc domain group for "
+			pr_warning("Can not alloc domain group for "
 				"node %d\n", i);
 			goto error;
 		}
@@ -8275,7 +8275,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 					  cpumask_size(),
 					  GFP_KERNEL, i);
 			if (!sg) {
-				printk(KERN_WARNING
+				pr_warning(
 				"Can not alloc domain group for node %d\n", j);
 				goto error;
 			}
@@ -9075,10 +9075,10 @@ void __might_sleep(char *file, int line)
 		return;
 	prev_jiffy = jiffies;
 
-	printk(KERN_ERR
+	pr_err(
 		"BUG: sleeping function called from invalid context at %s:%d\n",
 			file, line);
-	printk(KERN_ERR
+	pr_err(
 		"in_atomic(): %d, irqs_disabled(): %d, pid: %d, name: %s\n",
 			in_atomic(), irqs_disabled(),
 			current->pid, current->comm);
