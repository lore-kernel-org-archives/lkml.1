Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbZLYXN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbZLYXN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 18:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756650AbZLYXN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 18:13:56 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:38976 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476AbZLYXNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 18:13:55 -0500
Date: Sat, 26 Dec 2009 00:13:54 +0100
From: Andreas Mohr <andi@lisas.de>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org
Subject: BUG: (2.6.32.2) sleeping function called from invalid context at
	drivers/acpi/acpica/psloop.c:826
Message-ID: <20091225231354.GA13330@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

got this after a lid close (ACPI S1, obviously).
Inspiron 8000 (P3/700).

Might be similar/same to
"Kernel BUG during suspend to disk with 2.6.32-rc8-git3",
http://www.gossamer-threads.com/lists/linux/kernel/1160868

Suspending type 'cpu':
 cpu0
Back to C!
Resuming System Devices
Resuming type 'cpu':
 cpu0
Resuming type 'i8259':
 i82590
Resuming type 'i8237':
 i82370
Resuming type 'machinecheck':
 machinecheck0
Resuming type 'ioapic':
Resuming type 'timekeeping':
 timekeeping0
Resuming type 'clocksource':
 clocksource0
Resuming type 'irqrouter':
 irqrouter0
BUG: sleeping function called from invalid context at drivers/acpi/acpica/psloop.c:826
in_atomic(): 0, irqs_disabled(): 1, pid: 12013, name: default.sh
1 lock held by default.sh/12013:
 #0:  (pm_mutex){......}, at: [<c1052c0b>] enter_state+0x29/0x121
Pid: 12013, comm: default.sh Not tainted 2.6.32.2 #1
Call Trace:
 [<c1048bc7>] ? __debug_show_held_locks+0x1e/0x20
 [<c10230a4>] __might_sleep+0xb6/0xbb
 [<c114ed9c>] acpi_ps_complete_op+0x224/0x238
 [<c114f20d>] ? acpi_ps_parse_loop+0x45d/0x8e8
 [<c113ba0a>] ? acpi_ds_exec_end_op+0x419/0x47f
 [<c114f548>] acpi_ps_parse_loop+0x798/0x8e8
 [<c114e706>] acpi_ps_parse_aml+0xcf/0x31f
 [<c114fcee>] acpi_ps_execute_method+0x1d5/0x2b7
 [<c114b1ac>] acpi_ns_evaluate+0x13c/0x242
 [<c1151105>] acpi_rs_set_srs_method_data+0xed/0x108
 [<c1150bd4>] acpi_set_current_resources+0x2e/0x39
 [<c11370cb>] acpi_pci_link_set+0x132/0x202
 [<c11371c4>] irqrouter_resume+0x29/0x3e
 [<c1184b6e>] __sysdev_resume+0x14/0xa3
 [<c1184c77>] sysdev_resume+0x7a/0xb2
 [<c1052b75>] suspend_devices_and_enter+0xf8/0x165
 [<c1052cc2>] enter_state+0xe0/0x121
 [<c1052d1c>] pm_suspend+0x19/0x1f
 [<c1131f48>] acpi_suspend+0x3c/0x54
 [<c11322cf>] acpi_system_write_sleep+0x60/0x75
 [<c113226f>] ? acpi_system_write_sleep+0x0/0x75
 [<c10c6827>] proc_reg_write+0x60/0x74
 [<c10c67c7>] ? proc_reg_write+0x0/0x74
 [<c10923bb>] vfs_write+0x8a/0x13b
 [<c1092505>] sys_write+0x3b/0x60
 [<c10029b0>] sysenter_do_call+0x12/0x31
Resuming type 'lapic_nmi':
 lapic_nmi0
ACPI: Waking up from system sleep state S1
platform dock.0: EARLY resume
agpgart-intel 0000:00:00.0: EARLY resume
agpgart-intel 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x21
pci 0000:00:01.0: EARLY resume
pci 0000:00:01.0: calling quirk_cardbus_legacy+0x0/0x21
pci 0000:00:1e.0: EARLY resume
pci 0000:00:1e.0: calling quirk_cardbus_legacy+0x0/0x21
pci 0000:00:1f.0: EARLY resume
pci 0000:00:1f.0: calling quirk_cardbus_legacy+0x0/0x21
ata_piix 0000:00:1f.1: EARLY resume
ata_piix 0000:00:1f.1: restoring config space at offset 0x1 (was 0x2800001, writing 0x2800005)
ata_piix 0000:00:1f.1: calling quirk_cardbus_legacy+0x0/0x21
uhci_hcd 0000:00:1f.2: EARLY resume
uhci_hcd 0000:00:1f.2: calling quirk_cardbus_legacy+0x0/0x21
