Return-Path: <linux-kernel-owner+w=401wt.eu-S1756165AbYILADb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbYILADb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 20:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbYILADV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 20:03:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698AbYILADU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 20:03:20 -0400
Date: Thu, 11 Sep 2008 17:02:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: bugme-daemon@bugzilla.kernel.org, j_kernel@hoblitt.com
Subject: Re: [Bugme-new] [Bug 11543] New: kernel panic: softlockup in
 tick_periodic() ???
Message-Id: <20080911170258.aa0bea0d.akpm@linux-foundation.org>
In-Reply-To: <bug-11543-10286@http.bugzilla.kernel.org/>
References: <bug-11543-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Thu, 11 Sep 2008 16:46:29 -0700 (PDT)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11543
> 
>            Summary: kernel panic: softlockup in tick_periodic() ???
>            Product: Platform Specific/Hardware
>            Version: 2.5
>      KernelVersion: 2.6.27-rc4-21704-gd25e26b
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: x86-64
>         AssignedTo: platform_x86_64@kernel-bugs.osdl.org
>         ReportedBy: j_kernel@hoblitt.com
> 

Is this a regression?  Was 2.6.26 OK, for example?

> [11532.103605] do_IRQ: 0.175 No irq handler for vector
> <Sep/11 12:13 pm>[11532.103613] do_IRQ: 2.175 No irq handler for vector
> <Sep/11 12:13 pm>[11532.103617] do_IRQ: 1.175 No irq handler for vector
> <Sep/11 12:14 pm>[11560.779989] do_IRQ: 0.179 No irq handler for vector
> <Sep/11 12:15 pm>[11622.181968] Kernel panic - not syncing: softlockup: hung
> tas<Sep/11 12:15 pm>
>                  <Sep/11 12:15 pm>[11622.181968] ------------[ cut here
> ]------------
> <Sep/11 12:15 pm>[11622.181968] WARNING: at kernel/mutex.c:351
> mutex_trylock+0x45/0xf6()
> <Sep/11 12:15 pm>[11622.181968] Modules linked in: w83627hf hwmon_vid autofs4
> smsc37b787_wdt k8temp forcedeth i2c_nforce2 i2c_core tg3 libphy e1000 xfs
> dm_snapshot dm_mirror dm_log aacraid 3w_9xxx 3w_xxxx atp870u arcmsr aic7xxx
> scsi_wait_scan
> <Sep/11 12:15 pm>[11622.181968] Pid: 17192, comm: ppImage Not tainted
> 2.6.27-rc4-21704-gd25e26b #1
> <Sep/11 12:15 pm>[11622.181968] 
> <Sep/11 12:15 pm>[11622.181968] Call Trace:
> <Sep/11 12:15 pm>[11622.181968]  <IRQ>  [<ffffffff80235319>]
> warn_on_slowpath+0x51/0x77
> <Sep/11 12:15 pm>[11622.181968]  [<ffffffff802357ce>]
> release_console_sem+0x3e/0x1a1
> <Sep/11 12:15 pm>[11622.181968]  [<ffffffff805c6031>] mutex_trylock+0x45/0xf6
> <Sep/11 12:15 pm>[11622.181968]  [<ffffffff8025efc3>] crash_kexec+0x17/0xef
> <Sep/11 12:15 pm>[11622.181968]  [<ffffffff803bb5b9>] bust_spinlocks+0x15/0x30
> <Sep/11 12:15 pm>[11622.181968]  [<ffffffff80235218>] panic+0x8f/0x13f
> <Sep/11 12:15 pm>[11622.181968]  [<ffffffff802357ce>]
> release_console_sem+0x3e/0x1a1
> <Sep/11 12:15 pm>[11622.181968]  [<ffffffff802357ce>]
> release_console_sem+0x3e/0x1a1
> <Sep/11 12:15 pm>[11622.181968]  [<ffffffff80272145>]
> softlockup_tick+0x19e/0x1ab
> <Sep/11 12:15 pm>[11622.181968]  [<ffffffff8023dda4>]
> update_process_times+0x26/0x4b
> 
> <Sep/11 12:15 pm>[11622.181968]  [<ffffffff8024f7a4>] tick_periodic+0x6e/0x79
> <Sep/11 12:15 pm>[11622.181968]  [<ffffffff8024f7c7>]
> tick_handle_periodic+0x18/0x59
> <Sep/11 12:15 pm>[11622.181968]  [<ffffffff8024f96a>]
> tick_do_broadcast+0x4d/0x86
> <Sep/11 12:15 pm>[11622.181968]  [<ffffffff8024fa20>]
> tick_do_periodic_broadcast+0x23/0x31
> <Sep/11 12:15 pm>[11622.181968]  [<ffffffff8024fa3c>]
> tick_handle_periodic_broadcast+0xe/0x42
> <Sep/11 12:15 pm>[11622.181968]  [<ffffffff8020e9f6>]
> timer_event_interrupt+0x1a/0x21
> <Sep/11 12:15 pm>[11622.181968]  [<ffffffff80272591>]
> handle_IRQ_event+0x1e/0x4c
> <Sep/11 12:15 pm>[11622.181968]  [<ffffffff80273885>]
> handle_edge_irq+0xe8/0x12b
> <Sep/11 12:15 pm>[11622.181968]  [<ffffffff8020e96f>] do_IRQ+0xf1/0x15e
> <Sep/11 12:15 pm>[11622.181968]  [<ffffffff8020c3e1>] ret_from_intr+0x0/0xa
> <Sep/11 12:15 pm>[11622.181968]  <EOI>  [<ffffffff8021b79b>]
> native_flush_tlb_others+0x64/0xb3
> <Sep/11 12:15 pm>[11622.181968]  [<ffffffff8021b7c5>]
> native_flush_tlb_others+0x8e/0xb3
> <Sep/11 12:15 pm>[11622.181968]  [<ffffffff8021b7be>]
> native_flush_tlb_others+0x87/0xb3
> <Sep/11 12:15 pm>[11622.181968]  [<ffffffff8021b8b2>] flush_tlb_page+0x5e/0x65
> <Sep/11 12:15 pm>[11622.181968]  [<ffffffff8022531b>]
> ptep_set_access_flags+0x1b/0x1f
> <Sep/11 12:15 pm>[11622.181968]  [<ffffffff80285193>] do_wp_page+0x48b/0x51e

argh, death by wordwrapping.

I can't work out who called panic(), nor why.

The panic code called the kexec code which called mutex_trylock() which
called spin_lock_mutex() which then stupidly went and blurted a load of
debug stuff because of in_interrupt().

Something like this:

--- a/include/linux/debug_locks.h~a
+++ a/include/linux/debug_locks.h
@@ -17,7 +17,7 @@ extern int debug_locks_off(void);
 ({									\
 	int __ret = 0;							\
 									\
-	if (unlikely(c)) {						\
+	if (!oops_in_progress && unlikely(c)) {				\
 		if (debug_locks_off() && !debug_locks_silent)		\
 			WARN_ON(1);					\
 		__ret = 1;						\
_

might prevent the debugging code from preventing us from finding bugs :(

