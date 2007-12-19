Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbXLSPHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbXLSPHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 10:07:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbXLSPHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 10:07:00 -0500
Received: from el-out-1112.google.com ([209.85.162.182]:53974 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbXLSPG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 10:06:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=lFJsKOywGIWhlo5MeANj64WM9HuGLvBs2BX3WiYH8ZHxzSROCmrvpwU8+wCo7P5HhBKzNPGIOkEbK7teBkUItAD6Aev/yexI3Emr+/40pdVgZBlhucaqBdgzEo+kgyAkY+aueBlbId6X0ZRiobHp7Biv/xMkqwvNwBQT+qZ84D0=
Message-ID: <47693385.1010901@gmail.com>
Date: Wed, 19 Dec 2007 10:06:45 -0500
From: Miles Lane <miles.lane@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@suse.cz>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc5-mm1 -- inconsistent {in-hardirq-W} -> {hardirq-on-W}
 usage -- pm-hibernate/9940 [HC0[0]:SC0[0]:HE1:SE1]
References: <a44ae5cd0712190517t7c80e15bv759fa5486dfca234@mail.gmail.com>
In-Reply-To: <a44ae5cd0712190517t7c80e15bv759fa5486dfca234@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I discovered that I can use IMAP with GMail now, so I can send messages 
using Thunderbird and avoid the line wrapping problem.

I tried doing a series:  suspend-to-disk, suspend-to-ram and suspend-to-disk
Here is the result:

[   11.827653] PM: Creating hibernation image:
[   11.827658] WARNING: at arch/x86/kernel/smp_32.c:561 
native_smp_call_function_mask()
[   11.827661] Pid: 9940, comm: pm-hibernate Not tainted 2.6.24-rc5-mm1 #8
[   11.827665]  [<c0107d55>] show_trace_log_lvl+0x12/0x25
[   11.827673]  [<c010848a>] show_trace+0xd/0x10
[   11.827677]  [<c0108763>] dump_stack+0x57/0x5f
[   11.827681]  [<c0117db4>] native_smp_call_function_mask+0x41/0x126
[   11.827686]  [<c01192d9>] smp_call_function+0x18/0x1f
[   11.827690]  [<c012c624>] on_each_cpu+0x12/0x40
[   11.827695]  [<c0166ece>] drain_all_pages+0x13/0x16
[   11.827700]  [<c014f7b3>] swsusp_save+0x18/0x46b
[   11.827705]  [<c03103fa>] swsusp_arch_suspend+0x2a/0x2c
[   11.827710]  [<c014e7d8>] hibernate+0xba/0x16e
[   11.827714]  [<c014d56b>] state_store+0x45/0xac
[   11.827717]  [<c01ffe95>] kobj_attr_store+0x1a/0x22
[   11.827722]  [<c01b92c7>] sysfs_write_file+0xb8/0xe3
[   11.827726]  [<c01837eb>] vfs_write+0xa4/0x120
[   11.827731]  [<c0183d5e>] sys_write+0x3b/0x60
[   11.827734]  [<c0106bae>] sysenter_past_esp+0x6b/0xc1
[   11.827738]  =======================
[   11.920363] PM: Need to copy 124108 pages
[   11.920368] PM: Normal pages needed: 46468 + 1024 + 40, available 
pages: 182806
[   15.623893] PM: Hibernation image created (124108 pages copied)
[   15.624618] Intel machine check architecture supported.
[   15.624625] Intel machine check reporting enabled on CPU#0.
[   15.624992]
[   15.624993] =================================
[   15.624995] [ INFO: inconsistent lock state ]
[   15.624998] 2.6.24-rc5-mm1 #8
[   15.624999] ---------------------------------
[   15.625001] inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
[   15.625005] pm-hibernate/9940 [HC0[0]:SC0[0]:HE1:SE1] takes:
[   15.625007]  (&cpu_base->lock_key){++..}, at: [<c013c453>] 
retrigger_next_event+0x63/0x9f
[   15.625017] {in-hardirq-W} state was registered at:
[   15.625019]   [<c0145432>] __lock_acquire+0x408/0xbf4
[   15.625025]   [<c0145c94>] lock_acquire+0x76/0x9d
[   15.625029]   [<c039aa08>] _spin_lock+0x19/0x28
[   15.625035]   [<c013cd92>] hrtimer_interrupt+0x72/0x1b0
[   15.625039]   [<c011a2b7>] smp_apic_timer_interrupt+0x69/0x7c
[   15.625045]   [<c0107777>] apic_timer_interrupt+0x33/0x38
[   15.625050]   [<c01054b5>] mwait_idle+0x1b/0x1d
[   15.625054]   [<c01055e9>] cpu_idle+0xb3/0xd4
[   15.625058]   [<c03986c5>] rest_init+0x49/0x4b
[   15.625062]   [<c04f696d>] start_kernel+0x357/0x35f
[   15.625069]   [<00000000>] 0x0
[   15.625082]   [<ffffffff>] 0xffffffff
[   15.625087] irq event stamp: 1182359
[   15.625089] hardirqs last  enabled at (1182359): [<c0106cb3>] 
restore_nocheck+0x12/0x15
[   15.625094] hardirqs last disabled at (1182358): [<c010776d>] 
apic_timer_interrupt+0x29/0x38
[   15.625098] softirqs last  enabled at (933018): [<c0137d89>] 
__rcu_offline_cpu+0x32/0x62
[   15.625104] softirqs last disabled at (933016): [<c039aa22>] 
_spin_lock_bh+0xb/0x2d
[   15.625109]
[   15.625110] other info that might help us debug this:
[   15.625112] 2 locks held by pm-hibernate/9940:
[   15.625114]  #0:  (&buffer->mutex){--..}, at: [<c01b9234>] 
sysfs_write_file+0x25/0xe3
[   15.625121]  #1:  (pm_mutex){--..}, at: [<c014e72e>] hibernate+0x10/0x16e
[   15.625127]
[   15.625128] stack backtrace:
[   15.625131] Pid: 9940, comm: pm-hibernate Not tainted 2.6.24-rc5-mm1 #8
[   15.625133]  [<c0107d55>] show_trace_log_lvl+0x12/0x25
[   15.625138]  [<c010848a>] show_trace+0xd/0x10
[   15.625141]  [<c0108763>] dump_stack+0x57/0x5f
[   15.625144]  [<c0143e45>] print_usage_bug+0x10a/0x117
[   15.625148]  [<c01447de>] mark_lock+0x1e7/0x3fe
[   15.625152]  [<c014549f>] __lock_acquire+0x475/0xbf4
[   15.625156]  [<c0145c94>] lock_acquire+0x76/0x9d
[   15.625159]  [<c039aa08>] _spin_lock+0x19/0x28
[   15.625163]  [<c013c453>] retrigger_next_event+0x63/0x9f
[   15.625167]  [<c013caf7>] hres_timers_resume+0x4d/0x4f
[   15.625170]  [<c013eed1>] timekeeping_resume+0x117/0x11e
[   15.625175]  [<c027b2ba>] __sysdev_resume+0x14/0x34
[   15.625179]  [<c027b752>] sysdev_resume+0x21/0x57
[   15.625183]  [<c027f426>] device_power_up+0x8/0xf
[   15.625188]  [<c014e6e7>] hibernation_snapshot+0x13c/0x173
[   15.625192]  [<c014e7d8>] hibernate+0xba/0x16e
[   15.625195]  [<c014d56b>] state_store+0x45/0xac
[   15.625199]  [<c01ffe95>] kobj_attr_store+0x1a/0x22
[   15.625203]  [<c01b92c7>] sysfs_write_file+0xb8/0xe3
[   15.625207]  [<c01837eb>] vfs_write+0xa4/0x120
[   15.625211]  [<c0183d5e>] sys_write+0x3b/0x60
[   15.625214]  [<c0106bae>] sysenter_past_esp+0x6b/0xc1
[   15.625217]  =======================
[   15.625242] agpgart-intel 0000:00:00.0: EARLY resume
...
[   15.624618] Intel machine check architecture supported.
[   15.624625] Intel machine check reporting enabled on CPU#0.
[   15.624992]
[   15.624993] =================================
[   15.624995] [ INFO: inconsistent lock state ]
[   15.624998] 2.6.24-rc5-mm1 #8
[   15.624999] ---------------------------------
[   15.625001] inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
[   15.625005] pm-hibernate/9940 [HC0[0]:SC0[0]:HE1:SE1] takes:
[   15.625007]  (&cpu_base->lock_key){++..}, at: [<c013c453>] 
retrigger_next_event+0x63/0x9f
[   15.625017] {in-hardirq-W} state was registered at:
[   15.625019]   [<c0145432>] __lock_acquire+0x408/0xbf4
[   15.625025]   [<c0145c94>] lock_acquire+0x76/0x9d
[   15.625029]   [<c039aa08>] _spin_lock+0x19/0x28
[   15.625035]   [<c013cd92>] hrtimer_interrupt+0x72/0x1b0
[   15.625039]   [<c011a2b7>] smp_apic_timer_interrupt+0x69/0x7c
[   15.625045]   [<c0107777>] apic_timer_interrupt+0x33/0x38
[   15.625050]   [<c01054b5>] mwait_idle+0x1b/0x1d
[   15.625054]   [<c01055e9>] cpu_idle+0xb3/0xd4
[   15.625058]   [<c03986c5>] rest_init+0x49/0x4b
[   15.625062]   [<c04f696d>] start_kernel+0x357/0x35f
[   15.625069]   [<00000000>] 0x0
[   15.625082]   [<ffffffff>] 0xffffffff
[   15.625087] irq event stamp: 1182359
[   15.625089] hardirqs last  enabled at (1182359): [<c0106cb3>] 
restore_nocheck+0x12/0x15
[   15.625094] hardirqs last disabled at (1182358): [<c010776d>] 
apic_timer_interrupt+0x29/0x38
[   15.625098] softirqs last  enabled at (933018): [<c0137d89>] 
__rcu_offline_cpu+0x32/0x62
[   15.625104] softirqs last disabled at (933016): [<c039aa22>] 
_spin_lock_bh+0xb/0x2d
[   15.625109]
[   15.625110] other info that might help us debug this:
[   15.625112] 2 locks held by pm-hibernate/9940:
[   15.625114]  #0:  (&buffer->mutex){--..}, at: [<c01b9234>] 
sysfs_write_file+0x25/0xe3
[   15.625121]  #1:  (pm_mutex){--..}, at: [<c014e72e>] hibernate+0x10/0x16e
[   15.625127]
[   15.625128] stack backtrace:
[   15.625131] Pid: 9940, comm: pm-hibernate Not tainted 2.6.24-rc5-mm1 #8
[   15.625133]  [<c0107d55>] show_trace_log_lvl+0x12/0x25
[   15.625138]  [<c010848a>] show_trace+0xd/0x10
[   15.625141]  [<c0108763>] dump_stack+0x57/0x5f
[   15.625144]  [<c0143e45>] print_usage_bug+0x10a/0x117
[   15.625148]  [<c01447de>] mark_lock+0x1e7/0x3fe
[   15.625152]  [<c014549f>] __lock_acquire+0x475/0xbf4
[   15.625156]  [<c0145c94>] lock_acquire+0x76/0x9d
[   15.625159]  [<c039aa08>] _spin_lock+0x19/0x28
[   15.625163]  [<c013c453>] retrigger_next_event+0x63/0x9f
[   15.625167]  [<c013caf7>] hres_timers_resume+0x4d/0x4f
[   15.625170]  [<c013eed1>] timekeeping_resume+0x117/0x11e
[   15.625175]  [<c027b2ba>] __sysdev_resume+0x14/0x34
[   15.625179]  [<c027b752>] sysdev_resume+0x21/0x57
[   15.625183]  [<c027f426>] device_power_up+0x8/0xf
[   15.625188]  [<c014e6e7>] hibernation_snapshot+0x13c/0x173
[   15.625192]  [<c014e7d8>] hibernate+0xba/0x16e
[   15.625195]  [<c014d56b>] state_store+0x45/0xac
[   15.625199]  [<c01ffe95>] kobj_attr_store+0x1a/0x22
[   15.625203]  [<c01b92c7>] sysfs_write_file+0xb8/0xe3
[   15.625207]  [<c01837eb>] vfs_write+0xa4/0x120
[   15.625211]  [<c0183d5e>] sys_write+0x3b/0x60
[   15.625214]  [<c0106bae>] sysenter_past_esp+0x6b/0xc1
[   15.625217]  =======================
[   15.625242] agpgart-intel 0000:00:00.0: EARLY resume

