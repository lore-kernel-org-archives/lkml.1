Return-Path: <linux-kernel-owner+w=401wt.eu-S1759049AbXL3WI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759049AbXL3WI6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 17:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757978AbXL3WIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 17:08:51 -0500
Received: from fmmailgate04.web.de ([217.72.192.242]:51173 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757980AbXL3WIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 17:08:50 -0500
Date: Sun, 30 Dec 2007 23:08:48 +0100
Message-Id: <77335004@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Subject: [BUG] 2.6.24rc6 allmodconfig - unload capidrv fails
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+T8mraXqup3fmOw6nkFRyzmmCfXhmCqoXTuhJ3PXmC4NQjo
 NljslqHgHu769zOzY3xKPoSX07DtFR5M95cIcdAitq52SYXAfk=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rmmod capidrv never returns

this is 2.6.24-rc6 with allmodconfig
gcc version 4.2.1 (SUSE Linux)

also see https://bugzilla.novell.com/show_bug.cgi?id=350850


[ 1807.666763] capidrv: Rev 1.1.2.2: loaded
[ 1810.803450] capidrv: Rev 1.1.2.2 : unloaded
[ 1810.808417] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000009
[ 1810.808446] printing eip: c020afca *pde = 00000000
[ 1810.809301] Oops: 0000 [#1] SMP
[ 1810.810225] Modules linked in: capidrv kernelcapi isdn slhc iptable_filter ip_tables edd ip6table_filter ip6_tables x_tables ipv6 af_packet microcode firmware_class fuse loop dm_mod 8250_pnp ide_cd cdrom pata_acpi ata_piix ahci parport_pc floppy pcnet32 8250 parport serial_core ata_generic rtc_cmos rtc_core mii rtc_lib libata pcspkr i2c_piix4 i2c_core piix generic container ac ide_core intel_agp power_supply agpgart button thermal shpchp processor pci_hotplug mousedev evdev sg ext3 jbd mbcache sd_mod mptspi mptscsih mptbase scsi_transport_spi scsi_mod
[ 1810.810402]
[ 1810.810471] Pid: 4500, comm: kstopmachine Not tainted (2.6.24-rc6allmodconfig #3)
[ 1810.810488] EIP: 0060:[<c020afca>] EFLAGS: 00010092 CPU: 0
[ 1810.810609] EIP is at list_del+0xa/0x61
[ 1810.810716] EAX: e0ae8704 EBX: 00000009 ECX: 00000000 EDX: df686e10
[ 1810.810808] ESI: de8f4ef0 EDI: 00000000 EBP: deb57fb4 ESP: deb57fa4
[ 1810.810890]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[ 1810.812131] Process kstopmachine (pid: 4500, ti=deb57000 task=df686e10 task.ti=deb57000)
[ 1810.812156] Stack: c03f50ac 00000046 00000000 00000008 deb57fbc c0153506 deb57fd0 c015fb58
[ 1810.812412]        de8f4ef0 c015fa9c 00000000 deb57fe0 c013fe7e c013fe43 00000000 00000000
[ 1810.812424]        c0108d77 de8f4e6c 00000000 00000000 00000000 00000000 00000000
[ 1810.812444] Call Trace:
[ 1810.812485]  [<c01091cd>] show_trace_log_lvl+0x1a/0x2f
[ 1810.812569]  [<c010927d>] show_stack_log_lvl+0x9b/0xa3
[ 1810.812577]  [<c010932c>] show_registers+0xa7/0x179
[ 1810.812584]  [<c0109538>] die+0x13a/0x225
[ 1810.812589]  [<c02eb811>] do_page_fault+0x554/0x632
[ 1810.812616]  [<c02e9e52>] error_code+0x72/0x78
[ 1810.812624]  [<c0153506>] __unlink_module+0xb/0xf
[ 1810.812635]  [<c015fb58>] do_stop+0xbc/0x110
[ 1810.812643]  [<c013fe7e>] kthread+0x3b/0x61
[ 1810.812649]  [<c0108d77>] kernel_thread_helper+0x7/0x10
[ 1810.812669]  =======================
[ 1810.812680] Code: 00 00 8b 53 10 8d 4b 0c 8d 46 0c e8 72 00 00 00 89 f8 e8 87 fe ff ff 83 c4 10 5b 5e 5f 5d c3 90 90 55 89 e5 53 83 ec 0c 8b 58 04 <8b> 0b 39 c1 74 18 89 4c 24 08 89 44 24 04 c7 04 24 1a 1d 39 c0
[ 1810.812691] EIP: [<c020afca>] list_del+0xa/0x61 SS:ESP 0068:deb57fa4
[ 1810.812700] ---[ end trace 25d0c1bb6d183e81 ]---

______________________________________________________________________________
Jetzt neu! Im riesigen WEB.DE Club SmartDrive Dateien freigeben und mit 
Freunden teilen! http://www.freemail.web.de/club/smartdrive_ttc.htm/?mc=021134

