Return-Path: <linux-kernel-owner+w=401wt.eu-S1760912AbZEMQzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760912AbZEMQzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 12:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760867AbZEMQyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 12:54:46 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57425 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760854AbZEMQyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 12:54:45 -0400
Date: Wed, 13 May 2009 22:24:33 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: perf counter issue -
	WARN_ON_ONCE(!list_empty(&tsk->perf_counter_ctx.counter_list));
Message-ID: <20090513165433.GD16373@in.ibm.com>
Reply-To: vatsa@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am hitting this warning in kernel/exit.c (latest -tip code):

WARN_ON_ONCE(!list_empty(&tsk->perf_counter_ctx.counter_list));

I was using perf counters against a java benchmark. Any suggestions for
me to try out?

Full stack-traceback is below:


WARNING: at kernel/exit.c:158 delayed_put_task_struct+0x34/0x7c()
Hardware name: IBM System x3550 -[79787AA]-
Modules linked in: autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6
cpufreq_ondemand acpi_cpufreq freq_table dm_mirror dm_multipath scsi_dh
sbs sbshc battery acpi_memhotplug ac parport_pc lp parport sg sr_mod
bnx2 ide_cd_mod cdrom button rtc_cmos rtc_core rtc_lib i2c_i801 i2c_core
i5000_edac edac_core pcspkr dm_region_hash dm_log dm_mod usb_storage
ata_piix libata shpchp aacraid sd_mod scsi_mod ext3 jbd uhci_hcd
ohci_hcd ehci_hcd [last unloaded: microcode]
Pid: 0, comm: swapper Not tainted 2.6.30-rc5-tip #12
Call Trace:
 <IRQ>  [<ffffffff8023eab8>] ? warn_slowpath_fmt+0xd9/0xf6
 [<ffffffff80351233>] ? cpumask_next_and+0x2a/0x3b
 [<ffffffff80233de3>] ? find_busiest_group+0x1e6/0x82a
 [<ffffffff802535fc>] ? lock_hrtimer_base+0x1b/0x3c
 [<ffffffff802886d6>] ? __perf_counter_sched_in+0x1c/0x143
 [<ffffffff802181f0>] ? x86_pmu_enable+0x136/0x161
 [<ffffffff80287a19>] ? counter_sched_in+0x26/0x8e
 [<ffffffff8028804d>] ? group_sched_in+0x54/0xe2
 [<ffffffff80256ec6>] ? getnstimeofday+0x56/0xb5
 [<ffffffff80240193>] ? delayed_put_task_struct+0x34/0x7c
 [<ffffffff80272af6>] ? __rcu_process_callbacks+0x101/0x1ac
 [<ffffffff80272bc7>] ? rcu_process_callbacks+0x26/0x4a
 [<ffffffff80243eed>] ? __do_softirq+0xa3/0x162
 [<ffffffff8020ca3c>] ? call_softirq+0x1c/0x28
 [<ffffffff8020dcc6>] ? do_softirq+0x2c/0x68
 [<ffffffff8021e7b8>] ? smp_apic_timer_interrupt+0x8d/0x9d
 [<ffffffff8020c413>] ? apic_timer_interrupt+0x13/0x20
 <EOI>  [<ffffffff80211ed0>] ? mwait_idle+0xa3/0xd1
 [<ffffffff804cd309>] ? notifier_call_chain+0x29/0x4c
 [<ffffffff8020aa1d>] ? cpu_idle+0x40/0x5e
---[ end trace 026134fcfb5c588d ]---
WARNING: at kernel/exit.c:158 delayed_put_task_struct+0x34/0x7c()
Hardware name: IBM System x3550 -[79787AA]-
Modules linked in: autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6
cpufreq_ondemand acpi_cpufreq freq_table dm_mirror dm_multipath scsi_dh
sbs sbshc battery acpi_memhotplug ac parport_pc lp parport sg sr_mod
bnx2 ide_cd_mod cdrom button rtc_cmos rtc_core rtc_lib i2c_i801 i2c_core
i5000_edac edac_core pcspkr dm_region_hash dm_log dm_mod usb_storage
ata_piix libata shpchp aacraid sd_mod scsi_mod ext3 jbd uhci_hcd
ohci_hcd ehci_hcd [last unloaded: microcode]
Pid: 0, comm: swapper Tainted: G        W  2.6.30-rc5-tip #12
Call Trace:
 <IRQ>  [<ffffffff8023eab8>] ? warn_slowpath_fmt+0xd9/0xf6
 [<ffffffff80351233>] ? cpumask_next_and+0x2a/0x3b
 [<ffffffff80233de3>] ? find_busiest_group+0x1e6/0x82a
 [<ffffffff80230df4>] ? update_curr+0x6f/0xab
 [<ffffffff802303b4>] ? wakeup_preempt_entity+0xb5/0xc2
 [<ffffffff8023b994>] ? check_preempt_wakeup+0x118/0x135
 [<ffffffff802535fc>] ? lock_hrtimer_base+0x1b/0x3c
 [<ffffffff8025359d>] ? hrtimer_init+0x18/0x5c
 [<ffffffff80288d1a>] ? task_clock_perf_counter_enable+0x29/0x57
 [<ffffffff80287eec>] ? perf_swcounter_enable+0x5/0x8
 [<ffffffff80287a19>] ? counter_sched_in+0x26/0x8e
 [<ffffffff8028804d>] ? group_sched_in+0x54/0xe2
 [<ffffffff80256ec6>] ? getnstimeofday+0x56/0xb5
 [<ffffffff80240193>] ? delayed_put_task_struct+0x34/0x7c
 [<ffffffff80272af6>] ? __rcu_process_callbacks+0x101/0x1ac
 [<ffffffff80272bc7>] ? rcu_process_callbacks+0x26/0x4a
 [<ffffffff80243eed>] ? __do_softirq+0xa3/0x162
 [<ffffffff8020ca3c>] ? call_softirq+0x1c/0x28
 [<ffffffff8020dcc6>] ? do_softirq+0x2c/0x68
 [<ffffffff8021e7b8>] ? smp_apic_timer_interrupt+0x8d/0x9d
 [<ffffffff8020c413>] ? apic_timer_interrupt+0x13/0x20
 <EOI>  [<ffffffff80211ed0>] ? mwait_idle+0xa3/0xd1
 [<ffffffff804cd309>] ? notifier_call_chain+0x29/0x4c
 [<ffffffff8020aa1d>] ? cpu_idle+0x40/0x5e
---[ end trace 026134fcfb5c588e ]---

- vatsa
