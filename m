Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbZFQPL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbZFQPL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 11:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbZFQPLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 11:11:20 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:55630 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbZFQPLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 11:11:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NhrFuN6ob1A1Yhbrbj088JVI3QHezkAyZJbyF53lz2mCnrPI80YZE2RoMtAJvianSC
         i8XPjp53505hR3OrfxGp5AH0U2sEft7lRqdAGqwY44EfHeYpcHFbzdBPNhaP4ZjwV1ni
         Y2ORy21/QZXRTHr3rMh8oEFKRCXwdvzNexr8I=
MIME-Version: 1.0
Date: Wed, 17 Jun 2009 17:11:20 +0200
Message-ID: <19f34abd0906170811h36a7082asf68294db9490a049@mail.gmail.com>
Subject: WARNING: at arch/x86/kernel/apic/apic.c:249 native_apic_write_dummy
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just saw this warning on latest mainline when shutting down a box:

[  503.576724] ACPI: Preparing to enter system sleep state S5
[  503.710857] Disabling non-boot CPUs ...
[  503.716853] Power down.
[  503.717770] ------------[ cut here ]------------
[  503.717770] WARNING: at arch/x86/kernel/apic/apic.c:249 native_apic_write_du)
[  503.717770] Hardware name: OptiPlex GX100
[  503.717770] Modules linked in:
[  503.717770] Pid: 2136, comm: halt Not tainted 2.6.30 #443
[  503.717770] Call Trace:
[  503.717770]  [<c154d327>] ? printk+0x18/0x1a
[  503.717770]  [<c1017358>] ? native_apic_write_dummy+0x38/0x50
[  503.717770]  [<c10360fc>] warn_slowpath_common+0x6c/0xc0
[  503.717770]  [<c1017358>] ? native_apic_write_dummy+0x38/0x50
[  503.717770]  [<c1036165>] warn_slowpath_null+0x15/0x20
[  503.717770]  [<c1017358>] native_apic_write_dummy+0x38/0x50
[  503.717770]  [<c1017173>] disconnect_bsp_APIC+0x63/0x100
[  503.717770]  [<c1019e48>] disable_IO_APIC+0xb8/0xc0
[  503.717770]  [<c1214231>] ? acpi_power_off+0x0/0x29
[  503.717770]  [<c1015e55>] native_machine_shutdown+0x65/0x80
[  503.717770]  [<c1015c36>] native_machine_power_off+0x26/0x30
[  503.717770]  [<c1015c49>] machine_power_off+0x9/0x10
[  503.717770]  [<c1046596>] kernel_power_off+0x36/0x40
[  503.717770]  [<c104680d>] sys_reboot+0xfd/0x1f0
[  503.717770]  [<c109daa0>] ? perf_swcounter_event+0xb0/0x130
[  503.717770]  [<c109db7d>] ? perf_counter_task_sched_out+0x5d/0x120
[  503.717770]  [<c102dfc6>] ? finish_task_switch+0x56/0xd0
[  503.717770]  [<c154da1e>] ? schedule+0x49e/0xb40
[  503.717770]  [<c10444b0>] ? sys_kill+0x70/0x160
[  503.717770]  [<c119d9db>] ? selinux_file_ioctl+0x3b/0x50
[  503.717770]  [<c10dd443>] ? sys_ioctl+0x63/0x70
[  503.717770]  [<c1003024>] sysenter_do_call+0x12/0x22
[  503.717770] ---[ end trace 8157b5d0ed378f15 ]---
[  503.717770] acpi_power_off called

That's including this commit:

commit 103428e57be323c3c5545db8ad12667099bc6005
Author: Cyrill Gorcunov <gorcunov@openvz.org>
Date:   Sun Jun 7 16:48:40 2009 +0400

    x86, apic: Fix dummy apic read operation together with broken MP handling


Vegard
