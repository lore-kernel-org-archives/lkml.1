Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbZGBTsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbZGBTsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 15:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbZGBTsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 15:48:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752764AbZGBTsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 15:48:32 -0400
Date: Thu, 2 Jul 2009 12:47:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: mmotm 2009-06-30-12-50 uploaded
Message-Id: <20090702124726.a253f13d.akpm@linux-foundation.org>
In-Reply-To: <6719.1246562163@turing-police.cc.vt.edu>
References: <200906301951.n5UJpUSY013305@imap1.linux-foundation.org>
	<6719.1246562163@turing-police.cc.vt.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Jul 2009 15:16:03 -0400
Valdis.Kletnieks@vt.edu wrote:

> On Tue, 30 Jun 2009 12:51:30 PDT, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2009-06-30-12-50 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> This whinges at me during early startup:
> 
> [    0.654180] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
> [    0.655101] ACPI: SSDT 000000007fe82138 00244 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
> [    0.655547] power_supply AC: prop ONLINE=1
> [    0.655984] ACPI: SSDT 000000007fe81eed 001C6 (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
> [    0.657061] ------------[ cut here ]------------
> [    0.657296] WARNING: at kernel/lockdep.c:2143 trace_hardirqs_on_caller+0xc7/0x145()
> [    0.657664] Hardware name: Latitude D820
> [    0.657933] Modules linked in:
> [    0.658056] Pid: 0, comm: swapper Not tainted 2.6.31-rc1-mmotm0630 #1
> [    0.658056] Call Trace:
> [    0.658056]  <IRQ>  [<ffffffff8103ef3d>] warn_slowpath_common+0x77/0x8f
> [    0.658056]  [<ffffffff8120a76a>] ? acpi_processor_get_throttling_fadt+0x81/0x8c
> [    0.658056]  [<ffffffff8103ef64>] warn_slowpath_null+0xf/0x11
> [    0.658056]  [<ffffffff81065ba9>] trace_hardirqs_on_caller+0xc7/0x145
> [    0.658056]  [<ffffffff81065c34>] trace_hardirqs_on+0xd/0xf
> [    0.658056]  [<ffffffff8120a76a>] acpi_processor_get_throttling_fadt+0x81/0x8c
> [    0.658056]  [<ffffffff8120a3c4>] get_throttling+0x18/0x1f
> [    0.658056]  [<ffffffff8106dbbf>] generic_smp_call_function_single_interrupt+0x73/0x95
> [    0.658056]  [<ffffffff8101e9bf>] smp_call_function_single_interrupt+0x13/0x23
> [    0.658056]  [<ffffffff8100c093>] call_function_single_interrupt+0x13/0x20
> [    0.658056]  <EOI>  [<ffffffff81012a52>] ? mwait_idle+0x7a/0x95
> [    0.658056]  [<ffffffff81012a49>] ? mwait_idle+0x71/0x95
> [    0.658056]  [<ffffffff814a8d49>] ? atomic_notifier_call_chain+0xf/0x11
> [    0.658056]  [<ffffffff8100a4aa>] ? enter_idle+0x20/0x22
> [    0.658056]  [<ffffffff8100a521>] ? cpu_idle+0x75/0xfd
> [    0.658056]  [<ffffffff8148bc41>] ? rest_init+0x75/0x77
> [    0.658056]  [<ffffffff81801c53>] ? start_kernel+0x36e/0x379
> [    0.658056]  [<ffffffff8180129c>] ? x86_64_start_reservations+0xac/0xb0
> [    0.658056]  [<ffffffff81801384>] ? x86_64_start_kernel+0xe4/0xeb
> [    0.658056] ---[ end trace a7919e7f17c0a725 ]---
> [    0.803166] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
> [    0.814078] processor LNXCPU:00: registered as cooling_device0
> [    0.825244] ACPI: Processor [CPU0] (supports 8 throttling states)

apart from having a crappy title, linux-next's

: commit f29876421ec11f7d66f3d982219ef3af9bcccf32
: Author: Rusty Russell <rusty@rustcorp.com.au>
: AuthorDate: Wed Jul 1 12:37:19 2009 +1000
: Commit: Stephen Rothwell <sfr@canb.auug.org.au>
: CommitDate: Wed Jul 1 12:37:19 2009 +1000
:
: misc:work_on_cpu-acpi
:

causes get_throttling() to newly be called from an IPI, and lockdep doesn't
like irq-disabled interrupt handlers doing local_irq_enable().


If we rely upon these functions only ever being called from
smp_call_function_single(), and if smp_call_function_single() is
correctly implemented, we should be able to do this:

--- a/drivers/acpi/processor_throttling.c~a
+++ a/drivers/acpi/processor_throttling.c
@@ -616,6 +616,8 @@ static int acpi_processor_get_throttling
 	u32 duty_mask = 0;
 	u32 duty_value = 0;
 
+	WARN_ON_ONCE(!irqs_disabled());
+
 	if (!pr)
 		return -EINVAL;
 
@@ -628,8 +630,6 @@ static int acpi_processor_get_throttling
 
 	duty_mask <<= pr->throttling.duty_offset;
 
-	local_irq_disable();
-
 	value = inl(pr->throttling.address);
 
 	/*
@@ -646,8 +646,6 @@ static int acpi_processor_get_throttling
 
 	pr->throttling.state = state;
 
-	local_irq_enable();
-
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 			  "Throttling state is T%d (%d%% throttling applied)\n",
 			  state, pr->throttling.states[state].performance));
@@ -919,6 +917,8 @@ static int acpi_processor_set_throttling
 	u32 duty_mask = 0;
 	u32 duty_value = 0;
 
+	WARN_ON_ONCE(!irqs_disabled());
+
 	if (!pr)
 		return -EINVAL;
 
@@ -948,8 +948,6 @@ static int acpi_processor_set_throttling
 		duty_mask = ~duty_mask;
 	}
 
-	local_irq_disable();
-
 	/*
 	 * Disable throttling by writing a 0 to bit 4.  Note that we must
 	 * turn it off before you can change the duty_value.
@@ -975,8 +973,6 @@ static int acpi_processor_set_throttling
 
 	pr->throttling.state = state;
 
-	local_irq_enable();
-
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 			  "Throttling state set to T%d (%d%%)\n", state,
 			  (pr->throttling.states[state].performance ? pr->
_

