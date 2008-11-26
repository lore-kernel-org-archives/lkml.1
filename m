Return-Path: <linux-kernel-owner+w=401wt.eu-S1754416AbYKZOUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbYKZOUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 09:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbYKZOUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 09:20:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53676 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbYKZOUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 09:20:04 -0500
Date: Wed, 26 Nov 2008 15:19:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, x86@kernel.org,
       andi@firstfloor.org, eranian@gmail.com, sfr@canb.auug.org.au
Subject: Re: [patch 00/24] perfmon: introduction
Message-ID: <20081126141936.GI6562@elte.hu>
References: <492d0bd3.1ade660a.31f9.5137@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492d0bd3.1ade660a.31f9.5137@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,OBSCURED_EMAIL autolearn=no SpamAssassin version=3.2.3
	0.0 OBSCURED_EMAIL         BODY: Message seems to contain rot13ed address
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A generic request (i'll continue to post my specific remarks to the 
subject patches):

before submitting patches to lkml, please run them through 
scripts/checkpatch.pl. Your current lot introduces an excessive number 
of 69 (!) new errors+warnings:

  total: 45 errors, 24 warnings, 7394 lines checked

Thanks,

	Ingo

-------------------->
ERROR: need space after that ',' (ctx:VxV)
#403: FILE: arch/x86/include/asm/mach-default/entry_arch.h:37:
+BUILD_INTERRUPT(pmu_interrupt,LOCAL_PERFMON_VECTOR)
                              ^

WARNING: line over 80 characters
#770: FILE: arch/x86/include/asm/perfmon_kern.h:320:
+static inline void pfm_arch_ovfl_reset_pmd(struct pfm_context *ctx, unsigned int cnum)

WARNING: line over 80 characters
#784: FILE: arch/x86/include/asm/perfmon_kern.h:334:
+static inline int pfm_arch_context_create(struct pfm_context *ctx, u32 ctx_flags)

WARNING: line over 80 characters
#802: FILE: arch/x86/include/asm/perfmon_kern.h:352:
+int  pfm_arch_ctxswout_thread(struct task_struct *task, struct pfm_context *ctx);

ERROR: use tabs not spaces
#1059: FILE: arch/x86/kernel/process_32.c:465:
+ ^Iif (test_tsk_thread_flag(prev_p, TIF_PERFMON_CTXSW))$

ERROR: use tabs not spaces
#1060: FILE: arch/x86/kernel/process_32.c:466:
+ ^I^Ipfm_ctxsw_out(prev_p, next_p);$

ERROR: use tabs not spaces
#1138: FILE: arch/x86/kernel/signal_32.c:689:
+  ^I/* process perfmon asynchronous work (e.g. block thread or reset) */$

ERROR: use tabs not spaces
#1139: FILE: arch/x86/kernel/signal_32.c:690:
+  ^Iif (thread_info_flags & _TIF_PERFMON_WORK)$

ERROR: use tabs not spaces
#1140: FILE: arch/x86/kernel/signal_32.c:691:
+  ^I^Ipfm_handle_work(regs);$

ERROR: use tabs not spaces
#1161: FILE: arch/x86/kernel/signal_64.c:489:
+ ^I/* process perfmon asynchronous work (e.g. block thread or reset) */$

ERROR: use tabs not spaces
#1162: FILE: arch/x86/kernel/signal_64.c:490:
+ ^Iif (thread_info_flags & _TIF_PERFMON_WORK)$

ERROR: use tabs not spaces
#1163: FILE: arch/x86/kernel/signal_64.c:491:
+ ^I^Ipfm_handle_work(regs);$

WARNING: line over 80 characters
#1969: FILE: arch/x86/perfmon/perfmon_amd64.c:70:
+/* pmc0  */ PMC_D(PFM_REG_I64, "PERFSEL0", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL0),

WARNING: line over 80 characters
#1970: FILE: arch/x86/perfmon/perfmon_amd64.c:71:
+/* pmc1  */ PMC_D(PFM_REG_I64, "PERFSEL1", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL1),

WARNING: line over 80 characters
#1971: FILE: arch/x86/perfmon/perfmon_amd64.c:72:
+/* pmc2  */ PMC_D(PFM_REG_I64, "PERFSEL2", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL2),

WARNING: line over 80 characters
#1972: FILE: arch/x86/perfmon/perfmon_amd64.c:73:
+/* pmc3  */ PMC_D(PFM_REG_I64, "PERFSEL3", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL3),

ERROR: use tabs not spaces
#2289: FILE: arch/x86/perfmon/perfmon_amd64.c:390:
+^I^I        set->used_pmcs,$

ERROR: use tabs not spaces
#2290: FILE: arch/x86/perfmon/perfmon_amd64.c:391:
+^I^I        enable_mask,$

ERROR: use tabs not spaces
#2291: FILE: arch/x86/perfmon/perfmon_amd64.c:392:
+^I^I        max_enable);$

ERROR: need space after that ',' (ctx:VxV)
#2328: FILE: arch/x86/perfmon/perfmon_amd64.c:429:
+					pfm_arch_bv_set_bit(i,set->povfl_pmds);
 					                     ^

ERROR: need consistent spacing around '+' (ctx:VxW)
#2563: FILE: arch/x86/perfmon/perfmon_intel_arch.c:176:
+		max_enable = i+ 1;
 		              ^

ERROR: use tabs not spaces
#2748: FILE: arch/x86/perfmon/perfmon_intel_arch.c:361:
+ ^I/*$

ERROR: need spaces around that '=' (ctx:VxV)
#2936: FILE: arch/x86/perfmon/perfmon_intel_arch.c:549:
+	for (i=0; i < 16; i++) {
 	      ^

ERROR: need spaces around that '=' (ctx:VxV)
#2941: FILE: arch/x86/perfmon/perfmon_intel_arch.c:554:
+	for (i=16; i < PFM_IA_MAX_PMDS; i++) {
 	      ^

WARNING: line over 80 characters
#3260: FILE: include/linux/perfmon_kern.h:133:
+	struct pfm_regdesc	regs;		/* registers available to context */

WARNING: line over 80 characters
#3286: FILE: include/linux/perfmon_kern.h:159:
+		if (unlikely((pfm_controls.debug & lm) && printk_ratelimit())) { \

WARNING: printk() should include KERN_ facility level
#3287: FILE: include/linux/perfmon_kern.h:160:
+			printk("perfmon: %s.%d: CPU%d [%d]: " f "\n", \

ERROR: use tabs not spaces
#3565: FILE: include/linux/sched.h:1356:
+ ^Istruct pfm_context *pfm_context;$

WARNING: line over 80 characters
#3581: FILE: include/linux/syscalls.h:630:
+			       char  __user *f, void __user *uarg, size_t uarg_size);

WARNING: line over 80 characters
#3583: FILE: include/linux/syscalls.h:632:
+asmlinkage long sys_pfm_write(int fd, int flags, int type, void __user *arg, size_t s);

WARNING: line over 80 characters
#3584: FILE: include/linux/syscalls.h:633:
+asmlinkage long sys_pfm_read(int fd, int flags, int type, void __user *arg, size_t s);

ERROR: use tabs not spaces
#3865: FILE: perfmon/perfmon_attach.c:100:
+ ^I * link context to task$

ERROR: use tabs not spaces
#3866: FILE: perfmon/perfmon_attach.c:101:
+ ^I */$

ERROR: use tabs not spaces
#3897: FILE: perfmon/perfmon_attach.c:132:
+ ^I^I * on UP, we may have to push out the PMU$

ERROR: use tabs not spaces
#3898: FILE: perfmon/perfmon_attach.c:133:
+ ^I^I * state of the last monitored thread$

ERROR: use tabs not spaces
#3899: FILE: perfmon/perfmon_attach.c:134:
+ ^I^I */$

ERROR: use tabs not spaces
#3922: FILE: perfmon/perfmon_attach.c:157:
+ ^I * will cause switch_to() to invoke PMU$

ERROR: use tabs not spaces
#3923: FILE: perfmon/perfmon_attach.c:158:
+ ^I * context switch code$

ERROR: use tabs not spaces
#3924: FILE: perfmon/perfmon_attach.c:159:
+ ^I */$

ERROR: "foo * bar" should be "foo *bar"
#5014: FILE: perfmon/perfmon_file.c:245:
+	struct inode * inode;

ERROR: use tabs not spaces
#5145: FILE: perfmon/perfmon_init.c:65:
+ ^Iif (pfm_init_sysfs())$

ERROR: use tabs not spaces
#5146: FILE: perfmon/perfmon_init.c:66:
+ ^I^Igoto error_disable;$

WARNING: line over 80 characters
#5687: FILE: perfmon/perfmon_pmu.c:215:
+			memset(&pfm_pmu_conf->regs_all, 0, sizeof(struct pfm_regdesc));

ERROR: use tabs not spaces
#5690: FILE: perfmon/perfmon_pmu.c:218:
+^I^I^I^I  ^I     unavail_pmcs,$

WARNING: line over 80 characters
#5694: FILE: perfmon/perfmon_pmu.c:222:
+				(unsigned long long)pfm_pmu_conf->regs_all.pmcs[0]);

WARNING: line over 80 characters
#6194: FILE: perfmon/perfmon_rw.c:84:
+static inline int update_changes(struct pfm_context *ctx, struct pfm_event_set *set,

ERROR: need a space before the open parenthesis '('
#6219: FILE: perfmon/perfmon_rw.c:109:
+	for(p = 0; n; n--, p = q+1) {

ERROR: need space before that '-' (ctx:VxV)
#6768: FILE: perfmon/perfmon_syscalls.c:204:
+		state, check_mask, task ? task->pid:-1);
 		                                    ^

ERROR: need space after that ',' (ctx:VxV)
#6859: FILE: perfmon/perfmon_syscalls.c:295:
+	PFM_DBG("ret=%d",ret);
 	                ^

ERROR: need a space before the open parenthesis '('
#6987: FILE: perfmon/perfmon_syscalls.c:423:
+	switch(type) {

ERROR: need a space before the open parenthesis '('
#7081: FILE: perfmon/perfmon_syscalls.c:517:
+	switch(type) {

WARNING: kfree(NULL) is safe this check is probabally not required
#7100: FILE: perfmon/perfmon_syscalls.c:536:
+	if (fptr)
+		kfree(fptr);

ERROR: need a space before the open parenthesis '('
#7145: FILE: perfmon/perfmon_syscalls.c:581:
+	switch(type) {

WARNING: kfree(NULL) is safe this check is probabally not required
#7160: FILE: perfmon/perfmon_syscalls.c:596:
+	if (fptr)
+		kfree(fptr);

ERROR: need a space before the open parenthesis '('
#7180: FILE: perfmon/perfmon_syscalls.c:616:
+	switch(state) {

ERROR: use tabs not spaces
#7258: FILE: perfmon/perfmon_syscalls.c:694:
+ ^I * handle detach in a separate function$

ERROR: use tabs not spaces
#7259: FILE: perfmon/perfmon_syscalls.c:695:
+ ^I */$

ERROR: use tabs not spaces
#7276: FILE: perfmon/perfmon_syscalls.c:712:
+   ^Iif (target != current->pid) {$

WARNING: line over 80 characters
#7394: FILE: perfmon/perfmon_sysfs.c:84:
+static ssize_t pfm_controls_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)

WARNING: line over 80 characters
#7398: FILE: perfmon/perfmon_sysfs.c:88:
+		return snprintf(buf, PAGE_SIZE, "%u.%u\n",  PFM_VERSION_MAJ, PFM_VERSION_MIN);

WARNING: line over 80 characters
#7407: FILE: perfmon/perfmon_sysfs.c:97:
+		return snprintf(buf, PAGE_SIZE, "%d\n", pfm_controls.task_group);

WARNING: line over 80 characters
#7410: FILE: perfmon/perfmon_sysfs.c:100:
+		return snprintf(buf, PAGE_SIZE, "%zu\n", pfm_controls.arg_mem_max);

WARNING: line over 80 characters
#7415: FILE: perfmon/perfmon_sysfs.c:105:
+static ssize_t pfm_controls_store(struct kobject *kobj, struct kobj_attribute *attr,

ERROR: use tabs not spaces
#7416: FILE: perfmon/perfmon_sysfs.c:106:
+^I^I^I ^I  const char *buf, size_t count)$

WARNING: line over 80 characters
#7518: FILE: perfmon/perfmon_sysfs.c:208:
+static ssize_t pfm_pmu_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)

ERROR: use tabs not spaces
#7635: FILE: perfmon/perfmon_sysfs.c:325:
+ ^I * dynamic allocation happens on pfm_kernel_kobj,$

ERROR: use tabs not spaces
#7636: FILE: perfmon/perfmon_sysfs.c:326:
+ ^I * but a release callback is attached$

ERROR: use tabs not spaces
#7637: FILE: perfmon/perfmon_sysfs.c:327:
+ ^I */$

ERROR: Missing Signed-off-by: line(s)

total: 45 errors, 24 warnings, 7394 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.
