Return-Path: <linux-kernel-owner+w=401wt.eu-S1760366AbZDSGak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760366AbZDSGak (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 02:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755502AbZDSGac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 02:30:32 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:18511 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359AbZDSGab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 02:30:31 -0400
MIME-Version: 1.0
Date: Sun, 19 Apr 2009 07:30:29 +0100
X-Google-Sender-Auth: 7f67bca604790984
Message-ID: <b2cdc9f30904182330he82e0b9k1789a77aaaa62550@mail.gmail.com>
Subject: BUG: using smp_processor_id() in preemptible on 2.6.30-rc2
From: Alex Bennee <kernel-hacker@bennee.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These oops have started firing on 2.6.30-rc2 and some have been logged
with kerneloops. Is there any additional information I can add that
will help with debugging this?

[    6.542601] EXT3 FS on sda2, internal journal
[    6.751092] BUG: using smp_processor_id() in preemptible [00000000]
code: modprobe/3078
[    6.751100] caller is smp_call_function_many+0x29/0x1bd
[    6.751103] Pid: 3078, comm: modprobe Not tainted 2.6.30-rc2-ajb #56
[    6.751106] Call Trace:
[    6.751114]  [<ffffffff8034890a>] debug_smp_processor_id+0xce/0xe4
[    6.751118]  [<ffffffff8025d904>] smp_call_function_many+0x29/0x1bd
[    6.751126]  [<ffffffffa0132431>] ? do_drv_write+0x0/0x54 [acpi_cpufreq]
[    6.751131]  [<ffffffffa01326c6>] acpi_cpufreq_target+0x206/0x2ac
[acpi_cpufreq]
[    6.751137]  [<ffffffff8049459d>] ? _spin_unlock_irqrestore+0x17/0x30
[    6.751142]  [<ffffffff8040dfa2>] __cpufreq_driver_target+0x32/0x3b
[    6.751147]  [<ffffffff80410514>] cpufreq_governor_performance+0x20/0x24
[    6.751150]  [<ffffffff8040e0f4>] __cpufreq_governor+0xbc/0x105
[    6.751154]  [<ffffffff8040e3a9>] __cpufreq_set_policy+0x109/0x147
[    6.751157]  [<ffffffff8040f719>] cpufreq_add_dev+0x4cc/0x5b9
[    6.751161]  [<ffffffff8040f1d5>] ? handle_update+0x0/0x13
[    6.751166]  [<ffffffff803b3b01>] sysdev_driver_register+0xba/0x118
[    6.751171]  [<ffffffffa0022000>] ? acpi_cpufreq_init+0x0/0x82 [acpi_cpufreq]
[    6.751175]  [<ffffffff8040fc14>] cpufreq_register_driver+0x9c/0x14c
[    6.751180]  [<ffffffffa0022071>] acpi_cpufreq_init+0x71/0x82 [acpi_cpufreq]
[    6.751184]  [<ffffffff80209066>] do_one_initcall+0x5b/0x136
[    6.751188]  [<ffffffff80252285>] ? __blocking_notifier_call_chain+0x5d/0x6f
[    6.751193]  [<ffffffff80261bb6>] sys_init_module+0xa4/0x1ca
[    6.751197]  [<ffffffff8020b11b>] system_call_fastpath+0x16/0x1b
[    6.751701] BUG: using smp_processor_id() in preemptible [00000000]
code: modprobe/3078
[    6.751705] caller is smp_call_function_many+0x29/0x1bd
[    6.751708] Pid: 3078, comm: modprobe Not tainted 2.6.30-rc2-ajb #56
[    6.751710] Call Trace:
[    6.751714]  [<ffffffff8034890a>] debug_smp_processor_id+0xce/0xe4
[    6.751718]  [<ffffffff8025d904>] smp_call_function_many+0x29/0x1bd
[    6.751723]  [<ffffffffa0132431>] ? do_drv_write+0x0/0x54 [acpi_cpufreq]
[    6.751730]  [<ffffffffa01326c6>] acpi_cpufreq_target+0x206/0x2ac
[acpi_cpufreq]
[    6.751734]  [<ffffffff8049459d>] ? _spin_unlock_irqrestore+0x17/0x30
[    6.751738]  [<ffffffff8040dfa2>] __cpufreq_driver_target+0x32/0x3b
[    6.751742]  [<ffffffff80410514>] cpufreq_governor_performance+0x20/0x24
[    6.751746]  [<ffffffff8040e0f4>] __cpufreq_governor+0xbc/0x105
[    6.751749]  [<ffffffff8040e3a9>] __cpufreq_set_policy+0x109/0x147
[    6.751753]  [<ffffffff8040f719>] cpufreq_add_dev+0x4cc/0x5b9
[    6.751757]  [<ffffffff8040f1d5>] ? handle_update+0x0/0x13
[    6.751761]  [<ffffffff803b3b01>] sysdev_driver_register+0xba/0x118
[    6.751766]  [<ffffffffa0022000>] ? acpi_cpufreq_init+0x0/0x82 [acpi_cpufreq]
[    6.751770]  [<ffffffff8040fc14>] cpufreq_register_driver+0x9c/0x14c
[    6.751775]  [<ffffffffa0022071>] acpi_cpufreq_init+0x71/0x82 [acpi_cpufreq]
[    6.751779]  [<ffffffff80209066>] do_one_initcall+0x5b/0x136
[    6.751783]  [<ffffffff80252285>] ? __blocking_notifier_call_chain+0x5d/0x6f
[    6.751787]  [<ffffffff80261bb6>] sys_init_module+0xa4/0x1ca
[    6.751792]  [<ffffffff8020b11b>] system_call_fastpath+0x16/0x1b
[    7.033142] kjournald starting.  Commit interval 5 seconds


-- 
Alex, homepage: http://www.bennee.com/~alex/
CV: http://www.bennee.com/~alex/cv.php
