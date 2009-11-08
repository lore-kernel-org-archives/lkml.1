Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbZKHM0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbZKHM0r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbZKHM0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:26:45 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:59080 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbZKHMW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:22:26 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 06/23] sysctl: Remove references to ctl_name and strategy from the generic sysctl table
Date: Sun,  8 Nov 2009 04:21:53 -0800
Message-Id: <1257682930-31401-6-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m14op5jjo4.fsf@fess.ebiederm.org>
References: <m14op5jjo4.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Now that sys_sysctl is a generic wrapper around /proc/sys  .ctl_name
and .strategy members of sysctl tables are dead code.  Remove them.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/sysctl.c |  195 ++-----------------------------------------------------
 1 files changed, 7 insertions(+), 188 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f82e955..f6dacc3 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -205,31 +205,26 @@ extern int lock_stat;
 
 static struct ctl_table root_table[] = {
 	{
-		.ctl_name	= CTL_KERN,
 		.procname	= "kernel",
 		.mode		= 0555,
 		.child		= kern_table,
 	},
 	{
-		.ctl_name	= CTL_VM,
 		.procname	= "vm",
 		.mode		= 0555,
 		.child		= vm_table,
 	},
 	{
-		.ctl_name	= CTL_FS,
 		.procname	= "fs",
 		.mode		= 0555,
 		.child		= fs_table,
 	},
 	{
-		.ctl_name	= CTL_DEBUG,
 		.procname	= "debug",
 		.mode		= 0555,
 		.child		= debug_table,
 	},
 	{
-		.ctl_name	= CTL_DEV,
 		.procname	= "dev",
 		.mode		= 0555,
 		.child		= dev_table,
@@ -238,7 +233,7 @@ static struct ctl_table root_table[] = {
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
  */
-	{ .ctl_name = 0 }
+	{ }
 };
 
 #ifdef CONFIG_SCHED_DEBUG
@@ -250,7 +245,6 @@ static int max_wakeup_granularity_ns = NSEC_PER_SEC;	/* 1 second */
 
 static struct ctl_table kern_table[] = {
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_child_runs_first",
 		.data		= &sysctl_sched_child_runs_first,
 		.maxlen		= sizeof(unsigned int),
@@ -259,40 +253,33 @@ static struct ctl_table kern_table[] = {
 	},
 #ifdef CONFIG_SCHED_DEBUG
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_min_granularity_ns",
 		.data		= &sysctl_sched_min_granularity,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &sched_nr_latency_handler,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &min_sched_granularity_ns,
 		.extra2		= &max_sched_granularity_ns,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_latency_ns",
 		.data		= &sysctl_sched_latency,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &sched_nr_latency_handler,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &min_sched_granularity_ns,
 		.extra2		= &max_sched_granularity_ns,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_wakeup_granularity_ns",
 		.data		= &sysctl_sched_wakeup_granularity,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &min_wakeup_granularity_ns,
 		.extra2		= &max_wakeup_granularity_ns,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_shares_ratelimit",
 		.data		= &sysctl_sched_shares_ratelimit,
 		.maxlen		= sizeof(unsigned int),
@@ -300,17 +287,14 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_shares_thresh",
 		.data		= &sysctl_sched_shares_thresh,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_features",
 		.data		= &sysctl_sched_features,
 		.maxlen		= sizeof(unsigned int),
@@ -318,7 +302,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_migration_cost",
 		.data		= &sysctl_sched_migration_cost,
 		.maxlen		= sizeof(unsigned int),
@@ -326,7 +309,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_nr_migrate",
 		.data		= &sysctl_sched_nr_migrate,
 		.maxlen		= sizeof(unsigned int),
@@ -334,7 +316,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_time_avg",
 		.data		= &sysctl_sched_time_avg,
 		.maxlen		= sizeof(unsigned int),
@@ -342,19 +323,16 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "timer_migration",
 		.data		= &sysctl_timer_migration,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
 #endif
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_rt_period_us",
 		.data		= &sysctl_sched_rt_period,
 		.maxlen		= sizeof(unsigned int),
@@ -362,7 +340,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &sched_rt_handler,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_rt_runtime_us",
 		.data		= &sysctl_sched_rt_runtime,
 		.maxlen		= sizeof(int),
@@ -370,7 +347,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &sched_rt_handler,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_compat_yield",
 		.data		= &sysctl_sched_compat_yield,
 		.maxlen		= sizeof(unsigned int),
@@ -379,7 +355,6 @@ static struct ctl_table kern_table[] = {
 	},
 #ifdef CONFIG_PROVE_LOCKING
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "prove_locking",
 		.data		= &prove_locking,
 		.maxlen		= sizeof(int),
@@ -389,7 +364,6 @@ static struct ctl_table kern_table[] = {
 #endif
 #ifdef CONFIG_LOCK_STAT
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "lock_stat",
 		.data		= &lock_stat,
 		.maxlen		= sizeof(int),
@@ -398,7 +372,6 @@ static struct ctl_table kern_table[] = {
 	},
 #endif
 	{
-		.ctl_name	= KERN_PANIC,
 		.procname	= "panic",
 		.data		= &panic_timeout,
 		.maxlen		= sizeof(int),
@@ -406,7 +379,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= KERN_CORE_USES_PID,
 		.procname	= "core_uses_pid",
 		.data		= &core_uses_pid,
 		.maxlen		= sizeof(int),
@@ -414,16 +386,13 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= KERN_CORE_PATTERN,
 		.procname	= "core_pattern",
 		.data		= core_pattern,
 		.maxlen		= CORENAME_MAX_SIZE,
 		.mode		= 0644,
 		.proc_handler	= &proc_dostring,
-		.strategy	= &sysctl_string,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "core_pipe_limit",
 		.data		= &core_pipe_limit,
 		.maxlen		= sizeof(unsigned int),
@@ -449,7 +418,6 @@ static struct ctl_table kern_table[] = {
 #endif
 #ifdef CONFIG_BLK_DEV_INITRD
 	{
-		.ctl_name	= KERN_REALROOTDEV,
 		.procname	= "real-root-dev",
 		.data		= &real_root_dev,
 		.maxlen		= sizeof(int),
@@ -458,7 +426,6 @@ static struct ctl_table kern_table[] = {
 	},
 #endif
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "print-fatal-signals",
 		.data		= &print_fatal_signals,
 		.maxlen		= sizeof(int),
@@ -467,16 +434,13 @@ static struct ctl_table kern_table[] = {
 	},
 #ifdef CONFIG_SPARC
 	{
-		.ctl_name	= KERN_SPARC_REBOOT,
 		.procname	= "reboot-cmd",
 		.data		= reboot_command,
 		.maxlen		= 256,
 		.mode		= 0644,
 		.proc_handler	= &proc_dostring,
-		.strategy	= &sysctl_string,
 	},
 	{
-		.ctl_name	= KERN_SPARC_STOP_A,
 		.procname	= "stop-a",
 		.data		= &stop_a_enabled,
 		.maxlen		= sizeof (int),
@@ -484,7 +448,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= KERN_SPARC_SCONS_PWROFF,
 		.procname	= "scons-poweroff",
 		.data		= &scons_pwroff,
 		.maxlen		= sizeof (int),
@@ -494,7 +457,6 @@ static struct ctl_table kern_table[] = {
 #endif
 #ifdef CONFIG_SPARC64
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "tsb-ratio",
 		.data		= &sysctl_tsb_ratio,
 		.maxlen		= sizeof (int),
@@ -504,7 +466,6 @@ static struct ctl_table kern_table[] = {
 #endif
 #ifdef __hppa__
 	{
-		.ctl_name	= KERN_HPPA_PWRSW,
 		.procname	= "soft-power",
 		.data		= &pwrsw_enabled,
 		.maxlen		= sizeof (int),
@@ -512,7 +473,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= KERN_HPPA_UNALIGNED,
 		.procname	= "unaligned-trap",
 		.data		= &unaligned_enabled,
 		.maxlen		= sizeof (int),
@@ -521,7 +481,6 @@ static struct ctl_table kern_table[] = {
 	},
 #endif
 	{
-		.ctl_name	= KERN_CTLALTDEL,
 		.procname	= "ctrl-alt-del",
 		.data		= &C_A_D,
 		.maxlen		= sizeof(int),
@@ -530,7 +489,6 @@ static struct ctl_table kern_table[] = {
 	},
 #ifdef CONFIG_FUNCTION_TRACER
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "ftrace_enabled",
 		.data		= &ftrace_enabled,
 		.maxlen		= sizeof(int),
@@ -540,7 +498,6 @@ static struct ctl_table kern_table[] = {
 #endif
 #ifdef CONFIG_STACK_TRACER
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "stack_tracer_enabled",
 		.data		= &stack_tracer_enabled,
 		.maxlen		= sizeof(int),
@@ -550,7 +507,6 @@ static struct ctl_table kern_table[] = {
 #endif
 #ifdef CONFIG_TRACING
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "ftrace_dump_on_oops",
 		.data		= &ftrace_dump_on_oops,
 		.maxlen		= sizeof(int),
@@ -560,16 +516,13 @@ static struct ctl_table kern_table[] = {
 #endif
 #ifdef CONFIG_MODULES
 	{
-		.ctl_name	= KERN_MODPROBE,
 		.procname	= "modprobe",
 		.data		= &modprobe_path,
 		.maxlen		= KMOD_PATH_LEN,
 		.mode		= 0644,
 		.proc_handler	= &proc_dostring,
-		.strategy	= &sysctl_string,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "modules_disabled",
 		.data		= &modules_disabled,
 		.maxlen		= sizeof(int),
@@ -582,18 +535,15 @@ static struct ctl_table kern_table[] = {
 #endif
 #if defined(CONFIG_HOTPLUG) && defined(CONFIG_NET)
 	{
-		.ctl_name	= KERN_HOTPLUG,
 		.procname	= "hotplug",
 		.data		= &uevent_helper,
 		.maxlen		= UEVENT_HELPER_PATH_LEN,
 		.mode		= 0644,
 		.proc_handler	= &proc_dostring,
-		.strategy	= &sysctl_string,
 	},
 #endif
 #ifdef CONFIG_CHR_DEV_SG
 	{
-		.ctl_name	= KERN_SG_BIG_BUFF,
 		.procname	= "sg-big-buff",
 		.data		= &sg_big_buff,
 		.maxlen		= sizeof (int),
@@ -603,7 +553,6 @@ static struct ctl_table kern_table[] = {
 #endif
 #ifdef CONFIG_BSD_PROCESS_ACCT
 	{
-		.ctl_name	= KERN_ACCT,
 		.procname	= "acct",
 		.data		= &acct_parm,
 		.maxlen		= 3*sizeof(int),
@@ -613,7 +562,6 @@ static struct ctl_table kern_table[] = {
 #endif
 #ifdef CONFIG_MAGIC_SYSRQ
 	{
-		.ctl_name	= KERN_SYSRQ,
 		.procname	= "sysrq",
 		.data		= &__sysrq_enabled,
 		.maxlen		= sizeof (int),
@@ -631,7 +579,6 @@ static struct ctl_table kern_table[] = {
 	},
 #endif
 	{
-		.ctl_name	= KERN_MAX_THREADS,
 		.procname	= "threads-max",
 		.data		= &max_threads,
 		.maxlen		= sizeof(int),
@@ -639,37 +586,31 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= KERN_RANDOM,
 		.procname	= "random",
 		.mode		= 0555,
 		.child		= random_table,
 	},
 	{
-		.ctl_name	= KERN_OVERFLOWUID,
 		.procname	= "overflowuid",
 		.data		= &overflowuid,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &minolduid,
 		.extra2		= &maxolduid,
 	},
 	{
-		.ctl_name	= KERN_OVERFLOWGID,
 		.procname	= "overflowgid",
 		.data		= &overflowgid,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &minolduid,
 		.extra2		= &maxolduid,
 	},
 #ifdef CONFIG_S390
 #ifdef CONFIG_MATHEMU
 	{
-		.ctl_name	= KERN_IEEE_EMULATION_WARNINGS,
 		.procname	= "ieee_emulation_warnings",
 		.data		= &sysctl_ieee_emulation_warnings,
 		.maxlen		= sizeof(int),
@@ -678,7 +619,6 @@ static struct ctl_table kern_table[] = {
 	},
 #endif
 	{
-		.ctl_name	= KERN_S390_USER_DEBUG_LOGGING,
 		.procname	= "userprocess_debug",
 		.data		= &sysctl_userprocess_debug,
 		.maxlen		= sizeof(int),
@@ -687,18 +627,15 @@ static struct ctl_table kern_table[] = {
 	},
 #endif
 	{
-		.ctl_name	= KERN_PIDMAX,
 		.procname	= "pid_max",
 		.data		= &pid_max,
 		.maxlen		= sizeof (int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= sysctl_intvec,
 		.extra1		= &pid_max_min,
 		.extra2		= &pid_max_max,
 	},
 	{
-		.ctl_name	= KERN_PANIC_ON_OOPS,
 		.procname	= "panic_on_oops",
 		.data		= &panic_on_oops,
 		.maxlen		= sizeof(int),
@@ -707,7 +644,6 @@ static struct ctl_table kern_table[] = {
 	},
 #if defined CONFIG_PRINTK
 	{
-		.ctl_name	= KERN_PRINTK,
 		.procname	= "printk",
 		.data		= &console_loglevel,
 		.maxlen		= 4*sizeof(int),
@@ -715,16 +651,13 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= KERN_PRINTK_RATELIMIT,
 		.procname	= "printk_ratelimit",
 		.data		= &printk_ratelimit_state.interval,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
-		.strategy	= &sysctl_jiffies,
 	},
 	{
-		.ctl_name	= KERN_PRINTK_RATELIMIT_BURST,
 		.procname	= "printk_ratelimit_burst",
 		.data		= &printk_ratelimit_state.burst,
 		.maxlen		= sizeof(int),
@@ -732,19 +665,16 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "printk_delay",
 		.data		= &printk_delay_msec,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 		.extra2		= &ten_thousand,
 	},
 #endif
 	{
-		.ctl_name	= KERN_NGROUPS_MAX,
 		.procname	= "ngroups_max",
 		.data		= &ngroups_max,
 		.maxlen		= sizeof (int),
@@ -753,7 +683,6 @@ static struct ctl_table kern_table[] = {
 	},
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
 	{
-		.ctl_name       = KERN_UNKNOWN_NMI_PANIC,
 		.procname       = "unknown_nmi_panic",
 		.data           = &unknown_nmi_panic,
 		.maxlen         = sizeof (int),
@@ -770,7 +699,6 @@ static struct ctl_table kern_table[] = {
 #endif
 #if defined(CONFIG_X86)
 	{
-		.ctl_name	= KERN_PANIC_ON_NMI,
 		.procname	= "panic_on_unrecovered_nmi",
 		.data		= &panic_on_unrecovered_nmi,
 		.maxlen		= sizeof(int),
@@ -778,7 +706,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "panic_on_io_nmi",
 		.data		= &panic_on_io_nmi,
 		.maxlen		= sizeof(int),
@@ -786,7 +713,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= KERN_BOOTLOADER_TYPE,
 		.procname	= "bootloader_type",
 		.data		= &bootloader_type,
 		.maxlen		= sizeof (int),
@@ -794,7 +720,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "bootloader_version",
 		.data		= &bootloader_version,
 		.maxlen		= sizeof (int),
@@ -802,7 +727,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "kstack_depth_to_print",
 		.data		= &kstack_depth_to_print,
 		.maxlen		= sizeof(int),
@@ -810,7 +734,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "io_delay_type",
 		.data		= &io_delay_type,
 		.maxlen		= sizeof(int),
@@ -820,7 +743,6 @@ static struct ctl_table kern_table[] = {
 #endif
 #if defined(CONFIG_MMU)
 	{
-		.ctl_name	= KERN_RANDOMIZE,
 		.procname	= "randomize_va_space",
 		.data		= &randomize_va_space,
 		.maxlen		= sizeof(int),
@@ -830,7 +752,6 @@ static struct ctl_table kern_table[] = {
 #endif
 #if defined(CONFIG_S390) && defined(CONFIG_SMP)
 	{
-		.ctl_name	= KERN_SPIN_RETRY,
 		.procname	= "spin_retry",
 		.data		= &spin_retry,
 		.maxlen		= sizeof (int),
@@ -849,7 +770,6 @@ static struct ctl_table kern_table[] = {
 #endif
 #ifdef CONFIG_IA64
 	{
-		.ctl_name	= KERN_IA64_UNALIGNED,
 		.procname	= "ignore-unaligned-usertrap",
 		.data		= &no_unaligned_warning,
 		.maxlen		= sizeof (int),
@@ -857,7 +777,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "unaligned-dump-stack",
 		.data		= &unaligned_dump_stack,
 		.maxlen		= sizeof (int),
@@ -867,71 +786,58 @@ static struct ctl_table kern_table[] = {
 #endif
 #ifdef CONFIG_DETECT_SOFTLOCKUP
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "softlockup_panic",
 		.data		= &softlockup_panic,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "softlockup_thresh",
 		.data		= &softlockup_thresh,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dosoftlockup_thresh,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &neg_one,
 		.extra2		= &sixty,
 	},
 #endif
 #ifdef CONFIG_DETECT_HUNG_TASK
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "hung_task_panic",
 		.data		= &sysctl_hung_task_panic,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "hung_task_check_count",
 		.data		= &sysctl_hung_task_check_count,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= &proc_doulongvec_minmax,
-		.strategy	= &sysctl_intvec,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "hung_task_timeout_secs",
 		.data		= &sysctl_hung_task_timeout_secs,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= &proc_dohung_task_timeout_secs,
-		.strategy	= &sysctl_intvec,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "hung_task_warnings",
 		.data		= &sysctl_hung_task_warnings,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= &proc_doulongvec_minmax,
-		.strategy	= &sysctl_intvec,
 	},
 #endif
 #ifdef CONFIG_COMPAT
 	{
-		.ctl_name	= KERN_COMPAT_LOG,
 		.procname	= "compat-log",
 		.data		= &compat_log,
 		.maxlen		= sizeof (int),
@@ -941,7 +847,6 @@ static struct ctl_table kern_table[] = {
 #endif
 #ifdef CONFIG_RT_MUTEXES
 	{
-		.ctl_name	= KERN_MAX_LOCK_DEPTH,
 		.procname	= "max_lock_depth",
 		.data		= &max_lock_depth,
 		.maxlen		= sizeof(int),
@@ -950,17 +855,14 @@ static struct ctl_table kern_table[] = {
 	},
 #endif
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "poweroff_cmd",
 		.data		= &poweroff_cmd,
 		.maxlen		= POWEROFF_CMD_PATH_LEN,
 		.mode		= 0644,
 		.proc_handler	= &proc_dostring,
-		.strategy	= &sysctl_string,
 	},
 #ifdef CONFIG_KEYS
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "keys",
 		.mode		= 0555,
 		.child		= key_sysctls,
@@ -968,7 +870,6 @@ static struct ctl_table kern_table[] = {
 #endif
 #ifdef CONFIG_RCU_TORTURE_TEST
 	{
-		.ctl_name       = CTL_UNNUMBERED,
 		.procname       = "rcutorture_runnable",
 		.data           = &rcutorture_runnable,
 		.maxlen         = sizeof(int),
@@ -978,7 +879,6 @@ static struct ctl_table kern_table[] = {
 #endif
 #ifdef CONFIG_SLOW_WORK
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "slow-work",
 		.mode		= 0555,
 		.child		= slow_work_sysctls,
@@ -986,7 +886,6 @@ static struct ctl_table kern_table[] = {
 #endif
 #ifdef CONFIG_PERF_EVENTS
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "perf_event_paranoid",
 		.data		= &sysctl_perf_event_paranoid,
 		.maxlen		= sizeof(sysctl_perf_event_paranoid),
@@ -994,7 +893,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "perf_event_mlock_kb",
 		.data		= &sysctl_perf_event_mlock,
 		.maxlen		= sizeof(sysctl_perf_event_mlock),
@@ -1002,7 +900,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "perf_event_max_sample_rate",
 		.data		= &sysctl_perf_event_sample_rate,
 		.maxlen		= sizeof(sysctl_perf_event_sample_rate),
@@ -1012,7 +909,6 @@ static struct ctl_table kern_table[] = {
 #endif
 #ifdef CONFIG_KMEMCHECK
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "kmemcheck",
 		.data		= &kmemcheck_enabled,
 		.maxlen		= sizeof(int),
@@ -1022,7 +918,6 @@ static struct ctl_table kern_table[] = {
 #endif
 #ifdef CONFIG_BLOCK
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "blk_iopoll",
 		.data		= &blk_iopoll_enabled,
 		.maxlen		= sizeof(int),
@@ -1034,12 +929,11 @@ static struct ctl_table kern_table[] = {
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
  */
-	{ .ctl_name = 0 }
+	{ }
 };
 
 static struct ctl_table vm_table[] = {
 	{
-		.ctl_name	= VM_OVERCOMMIT_MEMORY,
 		.procname	= "overcommit_memory",
 		.data		= &sysctl_overcommit_memory,
 		.maxlen		= sizeof(sysctl_overcommit_memory),
@@ -1047,7 +941,6 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= VM_PANIC_ON_OOM,
 		.procname	= "panic_on_oom",
 		.data		= &sysctl_panic_on_oom,
 		.maxlen		= sizeof(sysctl_panic_on_oom),
@@ -1055,7 +948,6 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "oom_kill_allocating_task",
 		.data		= &sysctl_oom_kill_allocating_task,
 		.maxlen		= sizeof(sysctl_oom_kill_allocating_task),
@@ -1063,7 +955,6 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "oom_dump_tasks",
 		.data		= &sysctl_oom_dump_tasks,
 		.maxlen		= sizeof(sysctl_oom_dump_tasks),
@@ -1071,7 +962,6 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= VM_OVERCOMMIT_RATIO,
 		.procname	= "overcommit_ratio",
 		.data		= &sysctl_overcommit_ratio,
 		.maxlen		= sizeof(sysctl_overcommit_ratio),
@@ -1079,7 +969,6 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= VM_PAGE_CLUSTER,
 		.procname	= "page-cluster", 
 		.data		= &page_cluster,
 		.maxlen		= sizeof(int),
@@ -1087,45 +976,37 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= VM_DIRTY_BACKGROUND,
 		.procname	= "dirty_background_ratio",
 		.data		= &dirty_background_ratio,
 		.maxlen		= sizeof(dirty_background_ratio),
 		.mode		= 0644,
 		.proc_handler	= &dirty_background_ratio_handler,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 		.extra2		= &one_hundred,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "dirty_background_bytes",
 		.data		= &dirty_background_bytes,
 		.maxlen		= sizeof(dirty_background_bytes),
 		.mode		= 0644,
 		.proc_handler	= &dirty_background_bytes_handler,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &one_ul,
 	},
 	{
-		.ctl_name	= VM_DIRTY_RATIO,
 		.procname	= "dirty_ratio",
 		.data		= &vm_dirty_ratio,
 		.maxlen		= sizeof(vm_dirty_ratio),
 		.mode		= 0644,
 		.proc_handler	= &dirty_ratio_handler,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 		.extra2		= &one_hundred,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "dirty_bytes",
 		.data		= &vm_dirty_bytes,
 		.maxlen		= sizeof(vm_dirty_bytes),
 		.mode		= 0644,
 		.proc_handler	= &dirty_bytes_handler,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &dirty_bytes_min,
 	},
 	{
@@ -1143,7 +1024,6 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= VM_NR_PDFLUSH_THREADS,
 		.procname	= "nr_pdflush_threads",
 		.data		= &nr_pdflush_threads,
 		.maxlen		= sizeof nr_pdflush_threads,
@@ -1151,13 +1031,11 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= VM_SWAPPINESS,
 		.procname	= "swappiness",
 		.data		= &vm_swappiness,
 		.maxlen		= sizeof(vm_swappiness),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 		.extra2		= &one_hundred,
 	},
@@ -1172,7 +1050,6 @@ static struct ctl_table vm_table[] = {
 		.extra2		= (void *)&hugetlb_infinity,
 	 },
 	 {
-		.ctl_name	= VM_HUGETLB_GROUP,
 		.procname	= "hugetlb_shm_group",
 		.data		= &sysctl_hugetlb_shm_group,
 		.maxlen		= sizeof(gid_t),
@@ -1180,7 +1057,6 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= &proc_dointvec,
 	 },
 	 {
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "hugepages_treat_as_movable",
 		.data		= &hugepages_treat_as_movable,
 		.maxlen		= sizeof(int),
@@ -1188,7 +1064,6 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= &hugetlb_treat_movable_handler,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "nr_overcommit_hugepages",
 		.data		= NULL,
 		.maxlen		= sizeof(unsigned long),
@@ -1199,46 +1074,37 @@ static struct ctl_table vm_table[] = {
 	},
 #endif
 	{
-		.ctl_name	= VM_LOWMEM_RESERVE_RATIO,
 		.procname	= "lowmem_reserve_ratio",
 		.data		= &sysctl_lowmem_reserve_ratio,
 		.maxlen		= sizeof(sysctl_lowmem_reserve_ratio),
 		.mode		= 0644,
 		.proc_handler	= &lowmem_reserve_ratio_sysctl_handler,
-		.strategy	= &sysctl_intvec,
 	},
 	{
-		.ctl_name	= VM_DROP_PAGECACHE,
 		.procname	= "drop_caches",
 		.data		= &sysctl_drop_caches,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= drop_caches_sysctl_handler,
-		.strategy	= &sysctl_intvec,
 	},
 	{
-		.ctl_name	= VM_MIN_FREE_KBYTES,
 		.procname	= "min_free_kbytes",
 		.data		= &min_free_kbytes,
 		.maxlen		= sizeof(min_free_kbytes),
 		.mode		= 0644,
 		.proc_handler	= &min_free_kbytes_sysctl_handler,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 	},
 	{
-		.ctl_name	= VM_PERCPU_PAGELIST_FRACTION,
 		.procname	= "percpu_pagelist_fraction",
 		.data		= &percpu_pagelist_fraction,
 		.maxlen		= sizeof(percpu_pagelist_fraction),
 		.mode		= 0644,
 		.proc_handler	= &percpu_pagelist_fraction_sysctl_handler,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &min_percpu_pagelist_fract,
 	},
 #ifdef CONFIG_MMU
 	{
-		.ctl_name	= VM_MAX_MAP_COUNT,
 		.procname	= "max_map_count",
 		.data		= &sysctl_max_map_count,
 		.maxlen		= sizeof(sysctl_max_map_count),
@@ -1247,104 +1113,85 @@ static struct ctl_table vm_table[] = {
 	},
 #else
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "nr_trim_pages",
 		.data		= &sysctl_nr_trim_pages,
 		.maxlen		= sizeof(sysctl_nr_trim_pages),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 	},
 #endif
 	{
-		.ctl_name	= VM_LAPTOP_MODE,
 		.procname	= "laptop_mode",
 		.data		= &laptop_mode,
 		.maxlen		= sizeof(laptop_mode),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
-		.strategy	= &sysctl_jiffies,
 	},
 	{
-		.ctl_name	= VM_BLOCK_DUMP,
 		.procname	= "block_dump",
 		.data		= &block_dump,
 		.maxlen		= sizeof(block_dump),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 	},
 	{
-		.ctl_name	= VM_VFS_CACHE_PRESSURE,
 		.procname	= "vfs_cache_pressure",
 		.data		= &sysctl_vfs_cache_pressure,
 		.maxlen		= sizeof(sysctl_vfs_cache_pressure),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 	},
 #ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
 	{
-		.ctl_name	= VM_LEGACY_VA_LAYOUT,
 		.procname	= "legacy_va_layout",
 		.data		= &sysctl_legacy_va_layout,
 		.maxlen		= sizeof(sysctl_legacy_va_layout),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 	},
 #endif
 #ifdef CONFIG_NUMA
 	{
-		.ctl_name	= VM_ZONE_RECLAIM_MODE,
 		.procname	= "zone_reclaim_mode",
 		.data		= &zone_reclaim_mode,
 		.maxlen		= sizeof(zone_reclaim_mode),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 	},
 	{
-		.ctl_name	= VM_MIN_UNMAPPED,
 		.procname	= "min_unmapped_ratio",
 		.data		= &sysctl_min_unmapped_ratio,
 		.maxlen		= sizeof(sysctl_min_unmapped_ratio),
 		.mode		= 0644,
 		.proc_handler	= &sysctl_min_unmapped_ratio_sysctl_handler,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 		.extra2		= &one_hundred,
 	},
 	{
-		.ctl_name	= VM_MIN_SLAB,
 		.procname	= "min_slab_ratio",
 		.data		= &sysctl_min_slab_ratio,
 		.maxlen		= sizeof(sysctl_min_slab_ratio),
 		.mode		= 0644,
 		.proc_handler	= &sysctl_min_slab_ratio_sysctl_handler,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 		.extra2		= &one_hundred,
 	},
 #endif
 #ifdef CONFIG_SMP
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "stat_interval",
 		.data		= &sysctl_stat_interval,
 		.maxlen		= sizeof(sysctl_stat_interval),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
-		.strategy	= &sysctl_jiffies,
 	},
 #endif
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "mmap_min_addr",
 		.data		= &dac_mmap_min_addr,
 		.maxlen		= sizeof(unsigned long),
@@ -1353,43 +1200,36 @@ static struct ctl_table vm_table[] = {
 	},
 #ifdef CONFIG_NUMA
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "numa_zonelist_order",
 		.data		= &numa_zonelist_order,
 		.maxlen		= NUMA_ZONELIST_ORDER_LEN,
 		.mode		= 0644,
 		.proc_handler	= &numa_zonelist_order_handler,
-		.strategy	= &sysctl_string,
 	},
 #endif
 #if (defined(CONFIG_X86_32) && !defined(CONFIG_UML))|| \
    (defined(CONFIG_SUPERH) && defined(CONFIG_VSYSCALL))
 	{
-		.ctl_name	= VM_VDSO_ENABLED,
 		.procname	= "vdso_enabled",
 		.data		= &vdso_enabled,
 		.maxlen		= sizeof(vdso_enabled),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 	},
 #endif
 #ifdef CONFIG_HIGHMEM
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "highmem_is_dirtyable",
 		.data		= &vm_highmem_is_dirtyable,
 		.maxlen		= sizeof(vm_highmem_is_dirtyable),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
 #endif
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "scan_unevictable_pages",
 		.data		= &scan_unevictable_pages,
 		.maxlen		= sizeof(scan_unevictable_pages),
@@ -1398,24 +1238,20 @@ static struct ctl_table vm_table[] = {
 	},
 #ifdef CONFIG_MEMORY_FAILURE
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "memory_failure_early_kill",
 		.data		= &sysctl_memory_failure_early_kill,
 		.maxlen		= sizeof(sysctl_memory_failure_early_kill),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "memory_failure_recovery",
 		.data		= &sysctl_memory_failure_recovery,
 		.maxlen		= sizeof(sysctl_memory_failure_recovery),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
@@ -1425,18 +1261,17 @@ static struct ctl_table vm_table[] = {
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
  */
-	{ .ctl_name = 0 }
+	{ }
 };
 
 #if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
 static struct ctl_table binfmt_misc_table[] = {
-	{ .ctl_name = 0 }
+	{ }
 };
 #endif
 
 static struct ctl_table fs_table[] = {
 	{
-		.ctl_name	= FS_NRINODE,
 		.procname	= "inode-nr",
 		.data		= &inodes_stat,
 		.maxlen		= 2*sizeof(int),
@@ -1444,7 +1279,6 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= FS_STATINODE,
 		.procname	= "inode-state",
 		.data		= &inodes_stat,
 		.maxlen		= 7*sizeof(int),
@@ -1459,7 +1293,6 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= &proc_nr_files,
 	},
 	{
-		.ctl_name	= FS_MAXFILE,
 		.procname	= "file-max",
 		.data		= &files_stat.max_files,
 		.maxlen		= sizeof(int),
@@ -1467,7 +1300,6 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "nr_open",
 		.data		= &sysctl_nr_open,
 		.maxlen		= sizeof(int),
@@ -1477,7 +1309,6 @@ static struct ctl_table fs_table[] = {
 		.extra2		= &sysctl_nr_open_max,
 	},
 	{
-		.ctl_name	= FS_DENTRY,
 		.procname	= "dentry-state",
 		.data		= &dentry_stat,
 		.maxlen		= 6*sizeof(int),
@@ -1485,30 +1316,25 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= FS_OVERFLOWUID,
 		.procname	= "overflowuid",
 		.data		= &fs_overflowuid,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &minolduid,
 		.extra2		= &maxolduid,
 	},
 	{
-		.ctl_name	= FS_OVERFLOWGID,
 		.procname	= "overflowgid",
 		.data		= &fs_overflowgid,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &minolduid,
 		.extra2		= &maxolduid,
 	},
 #ifdef CONFIG_FILE_LOCKING
 	{
-		.ctl_name	= FS_LEASES,
 		.procname	= "leases-enable",
 		.data		= &leases_enable,
 		.maxlen		= sizeof(int),
@@ -1518,7 +1344,6 @@ static struct ctl_table fs_table[] = {
 #endif
 #ifdef CONFIG_DNOTIFY
 	{
-		.ctl_name	= FS_DIR_NOTIFY,
 		.procname	= "dir-notify-enable",
 		.data		= &dir_notify_enable,
 		.maxlen		= sizeof(int),
@@ -1529,7 +1354,6 @@ static struct ctl_table fs_table[] = {
 #ifdef CONFIG_MMU
 #ifdef CONFIG_FILE_LOCKING
 	{
-		.ctl_name	= FS_LEASE_TIME,
 		.procname	= "lease-break-time",
 		.data		= &lease_break_time,
 		.maxlen		= sizeof(int),
@@ -1555,7 +1379,6 @@ static struct ctl_table fs_table[] = {
 #endif /* CONFIG_AIO */
 #ifdef CONFIG_INOTIFY_USER
 	{
-		.ctl_name	= FS_INOTIFY,
 		.procname	= "inotify",
 		.mode		= 0555,
 		.child		= inotify_table,
@@ -1570,19 +1393,16 @@ static struct ctl_table fs_table[] = {
 #endif
 #endif
 	{
-		.ctl_name	= KERN_SETUID_DUMPABLE,
 		.procname	= "suid_dumpable",
 		.data		= &suid_dumpable,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 		.extra2		= &two,
 	},
 #if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "binfmt_misc",
 		.mode		= 0555,
 		.child		= binfmt_misc_table,
@@ -1592,13 +1412,12 @@ static struct ctl_table fs_table[] = {
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
  */
-	{ .ctl_name = 0 }
+	{ }
 };
 
 static struct ctl_table debug_table[] = {
 #if defined(CONFIG_X86) || defined(CONFIG_PPC)
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "exception-trace",
 		.data		= &show_unhandled_signals,
 		.maxlen		= sizeof(int),
@@ -1606,11 +1425,11 @@ static struct ctl_table debug_table[] = {
 		.proc_handler	= proc_dointvec
 	},
 #endif
-	{ .ctl_name = 0 }
+	{ }
 };
 
 static struct ctl_table dev_table[] = {
-	{ .ctl_name = 0 }
+	{ }
 };
 
 static DEFINE_SPINLOCK(sysctl_lock);
-- 
1.6.5.2.143.g8cc62

