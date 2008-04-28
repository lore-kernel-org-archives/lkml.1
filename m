Return-Path: <linux-kernel-owner+w=401wt.eu-S1765765AbYD1G51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765765AbYD1G51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763092AbYD1G5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 02:57:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:1488 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763049AbYD1G5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 02:57:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ZGpt/roI0VM+fmtjY3yK0PxwPLe3zKvS1sLlJsGLo/VNGOpl5O9NHhF8UPrBKZYyEZOC8IX50G0lSIv0Iill/1ya7XP/zEu05lB0pIlRnSupUEuzdtjGcFoqqLZvS/2kxt+C0KEO3cDwPycJ6ijitNjXlKOZH0dh9Q+ODEsdOrg=
Date: Mon, 28 Apr 2008 14:57:37 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Dan Noe <dpn@isomerica.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu
Subject: Re: NULL dereference OOPS on SysRq-w
Message-ID: <20080428065736.GA2714@darkstar.te-china.tietoenator.com>
References: <48141EFA.6080700@isomerica.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48141EFA.6080700@isomerica.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 02:36:42AM -0400, Dan Noe wrote:
> I've experienced the following on a build done today from Linus's linux-2.6 
> tree.  After a fresh boot I do "echo "w" > /proc/sysrq_trigger" and I get 
> the OOPS, every time.  I looked at the sched_debug code but I admit I was 
> lost.  Not sure why sched.c includes sched_debug.c.
>
> Cheers,
> Dan
>
> Via netconsole:
>
> SysRq : Show Blocked State
>   task                        PC stack   pid father
> Sched Debug Version: v0.07, 2.6.25 #12
> now at 275558.648467 msecs

[snip]

>                : 2038  .shares        : 2048BUG: unable to handle kernel 
> NULL pointer dereference at 0000000000000018IP: [<ffffffff802b9ab6>] 
> seq_printf+0x2e/0xa7
> PGD 7dd05067 PUD 7e0fb067 PMD 0 Oops: 0000 [1] PREEMPT SMP 
> DEBUG_PAGEALLOCCPU 0
> Modules linked in: netconsole nfsd lockd nfs_acl auth_rpcgss sunrpc 
> exportfs ac battery ipv6 dm_snapshot dm_mirror dm_log dm_mod eeprom 
> coretemp loop parport_pc parport snd_hda_intel rtc iTCO_wdt 
> iTCO_vendor_support i2c_i801 i2c_core snd_pc
> m snd_timer snd soundcore snd_page_alloc button intel_agp evdev ext3 jbd 
> mbcache sd_mod ata_generic ata_piix pata_acpi libata scsi_mod dock ehci_hcd 
> uhci_hcd ide_pci_generic piix ide_core r8169 usbcore thermal processor fan
> Pid: 3078, comm: zsh Not tainted 2.6.25 #12
> RIP: 0010:[<ffffffff802b9ab6>]  [<ffffffff802b9ab6>] seq_printf+0x2e/0xa7
> RSP: 0018:ffff81007e387c68  EFLAGS: 00010092
> RAX: ffffffff804eec79 RBX: 0000000000000000 RCX: ffffee71806668f8
> RDX: ffff810001091f80 RSI: ffffffff804eec79 RDI: 0000000000000000
> RBP: ffff81007e387d48 R08: 0000000000000002 R09: ffffffff8024fb76
> R10: 00000000d59bb5d6 R11: ffff81007e387968 R12: 0000000000000000
> R13: 0000000000000000 R14: ffff810001091740 R15: 0000000000000007
> FS:  00007f7dce0896e0(0000) GS:ffffffff8057a000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000018 CR3: 000000007e3ed000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process zsh (pid: 3078, threadinfo ffff81007e386000, task ffff81007e090000)
> Stack:  0000000000000002 ffffffff8024fb76 ffff81007e090090 ffff81007e090000
>  ffffffff8022dc31 0000000000000046 ffff810001091f80 ffffee71806668f8
>  0000000000000002 ffffffff8024fb76 0000000000000096 0000000000000000
> Call Trace:
>  [<ffffffff8024fb76>] ? up+0xf/0x39
>  [<ffffffff8022dc31>] ? print_cfs_rq+0x130/0x465
>  [<ffffffff8024fb76>] ? up+0xf/0x39
>  [<ffffffff8041dfa5>] ? _spin_unlock_irqrestore+0x66/0x74
>  [<ffffffff8022df57>] ? print_cfs_rq+0x456/0x465
>  [<ffffffff8022e920>] sched_debug_show+0x9ba/0xd28
>  [<ffffffff8022f978>] ? cpu_clock+0xf0/0xff
>  [<ffffffff802745fe>] ? get_timestamp+0x9/0xf
>  [<ffffffff80274628>] ? touch_softlockup_watchdog+0x24/0x2d
>  [<ffffffff802319ec>] show_state_filter+0x8b/0xaa
>  [<ffffffff80375848>] sysrq_handle_showstate_blocked+0xe/0x10
>  [<ffffffff803757a3>] __handle_sysrq+0x9e/0x135
>  [<ffffffff802e2544>] ? write_sysrq_trigger+0x0/0x3a
>  [<ffffffff802e2574>] write_sysrq_trigger+0x30/0x3a
>  [<ffffffff802dc6b2>] proc_reg_write+0x8a/0xa7
>  [<ffffffff802a0118>] vfs_write+0xa7/0xe1
>  [<ffffffff802a020c>] sys_write+0x47/0x6d
>  [<ffffffff8020c3ab>] system_call_after_swapgs+0x7b/0x80
> Code: f0 48 89 e5 53 48 89 fb 48 81 ec d8 00 00 00 48 89 95 50 ff ff ff 48 
> 89 8d 58 ff ff ff 4c 89 85 60 ff ff ff 4c 89 8d 68 ff ff ff <48> 8b 7f 18 
> 48 3b 7b 08 73 5a 48 8b 73 08 48 8d 55 10 48 8d 8d
> RIP  [<ffffffff802b9ab6>] seq_printf+0x2e/0xa7
>  RSP <ffff81007e387c68>
> CR2: 0000000000000018
> ---[ end trace ffd04a8c8a72749a ]---

[snip]

I have a fix for the NULL pointer reference BUG, tested on my pc.
---

"m" will be NULL if seq_printf & seq_puts is called from sched_debug_show
Use SEQ_* macros to fix it 

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

---
include/linux/sched.h |   22 ++++++++++++++++++++++
kernel/sched_debug.c  |   12 ------------
kernel/sched_fair.c   |    6 +++---
3 files changed, 25 insertions(+), 15 deletions(-)

diff -upr linux/include/linux/sched.h linux.new/include/linux/sched.h
--- linux/include/linux/sched.h	2008-04-28 14:27:25.000000000 +0800
+++ linux.new/include/linux/sched.h	2008-04-28 14:37:45.000000000 +0800
@@ -2145,6 +2145,28 @@ static inline void migration_init(void)
 #define TASK_SIZE_OF(tsk)	TASK_SIZE
 #endif
 
+#ifdef CONFIG_SCHED_DEBUG
+/*
+ * This allows printing both to /proc/sched_debug and
+ * to the console
+ */
+#define SEQ_printf(m, x...)			\
+ do {						\
+	if (m)					\
+		seq_printf(m, x);		\
+	else					\
+		printk(x);			\
+ } while (0)
+
+#define SEQ_puts(m, x...)			\
+ do {						\
+	if (m)					\
+		seq_puts(m, x);			\
+	else					\
+		printk(x);			\
+ } while (0)
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif
diff -upr linux/kernel/sched_debug.c linux.new/kernel/sched_debug.c
--- linux/kernel/sched_debug.c	2008-04-28 14:24:02.000000000 +0800
+++ linux.new/kernel/sched_debug.c	2008-04-28 14:37:32.000000000 +0800
@@ -17,18 +17,6 @@
 #include <linux/utsname.h>
 
 /*
- * This allows printing both to /proc/sched_debug and
- * to the console
- */
-#define SEQ_printf(m, x...)			\
- do {						\
-	if (m)					\
-		seq_printf(m, x);		\
-	else					\
-		printk(x);			\
- } while (0)
-
-/*
  * Ease the printing of nsec fields:
  */
 static long long nsec_high(unsigned long long nsec)
diff -upr linux/kernel/sched_fair.c linux.new/kernel/sched_fair.c
--- linux/kernel/sched_fair.c	2008-04-28 14:16:17.000000000 +0800
+++ linux.new/kernel/sched_fair.c	2008-04-28 14:37:24.000000000 +0800
@@ -1623,9 +1623,9 @@ print_cfs_rq_tasks(struct seq_file *m, s
 		int i;
 
 		for (i = depth; i; i--)
-			seq_puts(m, "  ");
+			SEQ_puts(m, "  ");
 
-		seq_printf(m, "%lu %s %lu\n",
+		SEQ_printf(m, "%lu %s %lu\n",
 				se->load.weight,
 				entity_is_task(se) ? "T" : "G",
 				calc_delta_weight(SCHED_LOAD_SCALE, se)
@@ -1643,7 +1643,7 @@ static void print_cfs_stats(struct seq_f
 	for_each_leaf_cfs_rq(cpu_rq(cpu), cfs_rq)
 		print_cfs_rq(m, cpu, cfs_rq);
 
-	seq_printf(m, "\nWeight tree:\n");
+	SEQ_printf(m, "\nWeight tree:\n");
 	print_cfs_rq_tasks(m, &cpu_rq(cpu)->cfs, 1);
 	rcu_read_unlock();
 }
