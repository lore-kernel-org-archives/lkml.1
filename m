Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbYHOShc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbYHOShc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 14:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbYHOShY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 14:37:24 -0400
Received: from atlantis.8hz.com ([212.129.237.78]:58402 "EHLO atlantis.8hz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883AbYHOShY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 14:37:24 -0400
Date: Fri, 15 Aug 2008 18:37:23 +0000
From: Sean Young <sean@mess.org>
To: linux-kernel@vger.kernel.org
Subject: AMD Elan regression with 2.6.27-rc3
Message-ID: <20080815183723.GA35232@atlantis.8hz.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_SC520_CPUFREQ=y on AMD Elan (ancient CPU where rdtsc is not 
supported), I get:

invalid opcode: 0000 [#1]

Pid: 1, comm: swapper Not tainted (2.6.27-rc3-00216-gffaa5b9 #1)
EIP: 0060:[<c0105b43>] EFLAGS: 00010082 CPU: 0
EIP is at native_read_tsc+0x6/0xf
EAX: 1211fa10 EBX: 00000000 ECX: fffedb53 EDX: 00000000
ESI: 00000246 EDI: c0287fac EBP: c0281a6c ESP: c1c1ddec
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process swapper (pid: 1, ti=c1c1c000 task=c1c1a000 task.ti=c1c1c000)
Stack: c01056ce c02785c4 c1c1de70 c0105a93 c018b2fb c1c1de44 c02b4444 c02785c4
       ffffffff 00000000 c0281a6c c011d71c c1c1de70 00000000 c02b95dc c1c1de70
       c02b95c8 00000000 c011d80e ffffffff 00000000 00000000 c1c1de70 c1c60780
Call Trace:
 [<c01056ce>] set_cyc2ns_scale+0x11/0x31
 [<c0105a93>] time_cpufreq_notifier+0xf1/0xfe
 [<c018b2fb>] idr_get_empty_slot+0x122/0x1e6
 [<c011d71c>] notifier_call_chain+0x2a/0x47
 [<c011d80e>] __srcu_notifier_call_chain+0x32/0x47
 [<c011d82c>] srcu_notifier_call_chain+0x9/0xc
 [<c01c8fca>] cpufreq_notify_transition+0x4f/0x8b
 [<c0107d40>] sc520_freq_target+0x54/0x80
 [<c0107cec>] sc520_freq_target+0x0/0x80
 [<c01c8f4d>] __cpufreq_driver_target+0x1a/0x24
 [<c01ca27d>] cpufreq_governor_userspace+0xfc/0x123
 [<c01c8f74>] __cpufreq_governor+0x1d/0x24
 [<c01c9180>] __cpufreq_set_policy+0xf9/0x107
 [<c01c9e16>] cpufreq_add_dev+0x189/0x1fb
 [<c01c99eb>] handle_update+0x0/0x8
 [<c01a52b7>] sysdev_driver_register+0x51/0x7e
 [<c01c9c44>] cpufreq_register_driver+0x4d/0x96
 [<c028fd5d>] sc520_freq_init+0x48/0x5c
 [<c010103a>] _stext+0x3a/0x12a
 [<c028fd15>] sc520_freq_init+0x0/0x5c
 [<c015e440>] create_proc_entry+0x69/0x7b
 [<c0125901>] register_irq_proc+0x6b/0x84
 [<c015e313>] proc_register+0xd0/0x10b
 [<c028c658>] kernel_init+0x56/0xa4
 [<c028c602>] kernel_init+0x0/0xa4
 [<c0102d27>] kernel_thread_helper+0x7/0x10
 =======================
Code: 90 eb f3 0f b1 15 80 ce 2a c0 85 c0 75 e8 88 d8 e6 70 89 f0 e6 71 c7 05 8
EIP: [<c0105b43>] native_read_tsc+0x6/0xf SS:ESP 0068:c1c1ddec
---[ end trace a7919e7f17c0a725 ]---
Kernel panic - not syncing: Attempted to kill init!

