Return-Path: <linux-kernel-owner+w=401wt.eu-S1758738AbYDLGH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbYDLGH7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 02:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbYDLGHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 02:07:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752752AbYDLGHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 02:07:48 -0400
Date: Fri, 11 Apr 2008 23:07:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.25-rc8-mm2
Message-Id: <20080411230720.4969a946.akpm@linux-foundation.org>
In-Reply-To: <17840.1207979639@turing-police.cc.vt.edu>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org>
	<17840.1207979639@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Apr 2008 01:53:59 -0400 Valdis.Kletnieks@vt.edu wrote:

> On Thu, 10 Apr 2008 20:33:54 PDT, Andrew Morton said:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm2/
> 
> Was in the middle of a bisection chasing a different problem, and hit this
> pair of warnings.  'quilt top' at the time was remove-div_long_long_rem.patch

yup, remove-div_long_long_rem.patch is a "good" bisection point (one with
no known fixes against it).

> (in other words, very nearly all of rc8-mm2 was applied). Feel free to delete
> if it's known-fixed in one of the last 100 or so patches. ;)
> 
> [    0.060389] ACPI: Core revision 20070126
> [    0.069072] ------------[ cut here ]------------
> [    0.069077] WARNING: at arch/x86/kernel/genapic_64.c:86 read_apic_id+0x41/0x7c()
> [    0.069084] Modules linked in:
> [    0.069090] Pid: 1, comm: swapper Not tainted 2.6.25-rc8 #5
> [    0.069094]
> [    0.069095] Call Trace:
> [    0.069104]  [<ffffffff8023d4fe>] warn_on_slowpath+0x67/0xb7
> [    0.069113]  [<ffffffff8021f12d>] ? __cpus_weight+0x4b/0x68
> [    0.069118]  [<ffffffff80225591>] read_apic_id+0x41/0x7c
> [    0.069126]  [<ffffffff80729d84>] verify_local_APIC+0xb4/0x177
> [    0.069132]  [<ffffffff80728a81>] native_smp_prepare_cpus+0x247/0x383
> [    0.069140]  [<ffffffff8071d712>] kernel_init+0x69/0x29c
> [    0.069148]  [<ffffffff8057908a>] ? _spin_unlock_irq+0x43/0x62
> [    0.069156]  [<ffffffff80237516>] ? finish_task_switch+0x3e/0xb4
> [    0.069163]  [<ffffffff8020d5f8>] child_rip+0xa/0x12
> [    0.069994]  [<ffffffff803b8237>] ? acpi_ds_init_one_object+0x0/0xb1
> [    0.070000]  [<ffffffff8071d6a9>] ? kernel_init+0x0/0x29c
> [    0.070006]  [<ffffffff8020d5ee>] ? child_rip+0x0/0x12
> [    0.070010]
> [    0.070019] ---[ end trace a7919e7f17c0a725 ]---
> [    0.070024] ------------[ cut here ]------------
> [    0.070028] WARNING: at arch/x86/kernel/genapic_64.c:86 read_apic_id+0x41/0x7c()
> [    0.070034] Modules linked in:
> [    0.070039] Pid: 1, comm: swapper Tainted: G        W 2.6.25-rc8 #5
> [    0.070043]
> [    0.070044] Call Trace:
> [    0.070049]  [<ffffffff8023d4fe>] warn_on_slowpath+0x67/0xb7
> [    0.070056]  [<ffffffff8021f12d>] ? __cpus_weight+0x4b/0x68
> [    0.070061]  [<ffffffff80225591>] read_apic_id+0x41/0x7c
> [    0.070067]  [<ffffffff80729db6>] verify_local_APIC+0xe6/0x177
> [    0.070072]  [<ffffffff80728a81>] native_smp_prepare_cpus+0x247/0x383
> [    0.070078]  [<ffffffff8071d712>] kernel_init+0x69/0x29c
> [    0.070084]  [<ffffffff8057908a>] ? _spin_unlock_irq+0x43/0x62
> [    0.070090]  [<ffffffff80237516>] ? finish_task_switch+0x3e/0xb4
> [    0.070096]  [<ffffffff8020d5f8>] child_rip+0xa/0x12
> [    0.070102]  [<ffffffff803b8237>] ? acpi_ds_init_one_object+0x0/0xb1
> [    0.070108]  [<ffffffff8071d6a9>] ? kernel_init+0x0/0x29c
> [    0.070113]  [<ffffffff8020d5ee>] ? child_rip+0x0/0x12
> [    0.070117]
> [    0.070120] ---[ end trace a7919e7f17c0a725 ]---
> [    0.080292] CPU0: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 06
> [    0.080300] Using local APIC timer interrupts.

So that may well be a destined-for-2.6.25 problem.
