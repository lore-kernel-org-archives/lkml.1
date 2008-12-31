Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbYLaSh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbYLaSh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 13:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbYLaShu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 13:37:50 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:30121 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbYLaSht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 13:37:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=j32/0ssJrWy4IJEy9M00FXnw5Txvb+9CAb5BKIoYKR+QVyVE/3aRGRkCVXGPM5VYYB
         Bi1qVqie6axnTiXZmRHljPUuqo449WJxVB0LI1vAnq5p+xuiZTKG+5Nit7Qk0WlVFD24
         C4FDJZE+TylV4X/R9bCZes3elrGIGZRg17q64=
Message-ID: <e38d12ff0812311037i14efe091m8550080678d0e2@mail.gmail.com>
Date: Wed, 31 Dec 2008 13:37:46 -0500
From: "Andrey Vul" <andrey.vul@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.28: BUG in r8169
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trigger: wget 192.168.1.42/jdk-6-sdk-docs.zip
eth0 speed grinds to zero in a few seconds
IIRC r8169 worked fine in 2.6.27.8
Anybody want to assist me with my first git bisect?

[28481.701074] ------------[ cut here ]------------
[28481.701082] WARNING: at net/sched/sch_generic.c:226
dev_watchdog+0x131/0x1cc()
[28481.701087] NETDEV WATCHDOG: eth0 (r8169): transmit timed out
[28481.701091] Modules linked in: uvcvideo ohci1394 compat_ioctl32
sdhci_pci videodev ieee1394 sdhci sg iwlagn pcspkr joydev v4l1_compat
mmc_core r8169 iwlcore mii
[28481.701125] Pid: 0, comm: swapper Not tainted 2.6.28-gentoo #1
[28481.701130] Call Trace:
[28481.701134]  <IRQ>  [<ffffffff810387a1>] warn_slowpath+0xae/0xcd
[28481.701153]  [<ffffffff81048a4d>] ? __queue_work+0x35/0x3d
[28481.701161]  [<ffffffff8102f301>] ? __enqueue_entity+0x74/0x76
[28481.701168]  [<ffffffff8102f301>] ? __enqueue_entity+0x74/0x76
[28481.701176]  [<ffffffff81033b10>] ? enqueue_task_fair+0x16f/0x17b
[28481.701186]  [<ffffffff81050d3a>] ? getnstimeofday+0x3a/0x9b
[28481.701194]  [<ffffffff8105013b>] ? sched_clock_cpu+0x14b/0x158
[28481.701201]  [<ffffffff81050d3a>] ? getnstimeofday+0x3a/0x9b
[28481.701209]  [<ffffffff8104e8a8>] ? ktime_get_ts+0x49/0x4e
[28481.701218]  [<ffffffff8101c7cb>] ? lapic_next_event+0x15/0x19
[28481.701225]  [<ffffffff81053674>] ? clockevents_program_event+0x73/0x7c
[28481.701233]  [<ffffffff8105472d>] ? tick_dev_program_event+0x2a/0xa7
[28481.701241]  [<ffffffff8134cad2>] dev_watchdog+0x131/0x1cc
[28481.701249]  [<ffffffff8102142f>] ? hpet_legacy_next_event+0xb/0xd
[28481.701257]  [<ffffffff8104ec85>] ? hrtimer_run_pending+0x3a/0x105
[28481.701264]  [<ffffffff8105472d>] ? tick_dev_program_event+0x2a/0xa7
[28481.701271]  [<ffffffff8134c9a1>] ? dev_watchdog+0x0/0x1cc
[28481.701280]  [<ffffffff81041360>] run_timer_softirq+0x17f/0x1f7
[28481.701287]  [<ffffffff8103d3a2>] __do_softirq+0x72/0x149
[28481.701295]  [<ffffffff8100d1dc>] call_softirq+0x1c/0x28
[28481.701302]  [<ffffffff8100e86e>] do_softirq+0x34/0x72
[28481.701309]  [<ffffffff8103d288>] irq_exit+0x36/0x82
[28481.701316]  [<ffffffff8100ea16>] do_IRQ+0x16a/0x19c
[28481.701323]  [<ffffffff8100c466>] ret_from_intr+0x0/0xa
[28481.701326]  <EOI>  [<ffffffff812371c5>] ? acpi_idle_enter_bm+0x2cb/0x33b
[28481.701342]  [<ffffffff812371bb>] ? acpi_idle_enter_bm+0x2c1/0x33b
[28481.701351]  [<ffffffff812e4d21>] ? cpuidle_idle_call+0x89/0xc4
[28481.701358]  [<ffffffff8100ad10>] ? cpu_idle+0x47/0x7e
[28481.701367]  [<ffffffff814350bc>] ? start_secondary+0x175/0x17a
[28481.701372] ---[ end trace 975587f7eeca5188 ]---


-- 
Andrey Vul
