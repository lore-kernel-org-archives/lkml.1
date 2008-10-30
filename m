Return-Path: <linux-kernel-owner+w=401wt.eu-S1758142AbYJ3STY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142AbYJ3STY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbYJ3STO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:19:14 -0400
Received: from fmmailgate09.web.de ([217.72.192.184]:55100 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbYJ3STN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:19:13 -0400
Date: Thu, 30 Oct 2008 19:19:11 +0100
Message-Id: <489086328@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: airlied@linux.ie
Subject: BUG:  amd64-agp  oopses on 2nd load
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/GSvGluqr3QmY/nM3MJ7EPsJIz4xrgicoYdLwqrH3b/ehWy
 r40XsBy6o5pbfsN7o78WFaLhe8l0awgZrej1weC3kdAWeJzOGE=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

found during module testing.

reproduce:

modprobe amd64-agp 

module does not load (expected)

then modprobe amd64-agp a second time and you get the oops below (which is not expected)

2.6.28-rc2-git3-default 
vmware workstation 6.5
non amd-platform
no X11 running

if not reproducible, i can provide .config or further information.

regards
roland


BUG: unable to handle kernel paging request at 0356402e
IP: [<c01cbd9f>] kobject_put+0x7/0x37
*pde = 00000000
Oops: 0000 [#1] SMP
last sysfs file: /sys/firmware/edd/int13_dev80/extensions
Modules linked in: amd64_agp(+) iptable_filter ip_tables ip6table_filter ip6_tables x_tables ipv6 af_packet microcode firmware_class fuse loop dm_mod ide_cd_mod cdrom pata_acpi ata_piix mousedev ahci serio_raw ata_generic libata psmouse ide_pci_generic ppdev 8250_pnp rtc_cmos 8250 rtc_core parport_pc pcnet32 piix shpchp intel_agp container i2c_piix4 mii button ac pci_hotplug rtc_lib pcspkr parport ide_core serial_core agpgart evdev i2c_core floppy uhci_hcd usbcore edd ext3 mbcache jbd fan mptsas scsi_transport_sas mptfc scsi_transport_fc scsi_tgt mptspi mptscsih mptbase scsi_transport_spi sd_mod crc_t10dif sg scsi_mod thermal processor thermal_sys [last unloaded: speedstep_lib]

Pid: 2471, comm: modprobe Tainted: G        W  (2.6.28-rc2-git3-default #4) VMware Virtual Platform
EIP: 0060:[<c01cbd9f>] EFLAGS: 00010202 CPU: 0
EIP is at kobject_put+0x7/0x37
EAX: 0356400e EBX: 0356400e ECX: f0869034 EDX: f0863fbc
ESI: f0869fbc EDI: f0869fbc EBP: ee94a000 ESP: ee94be84
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process modprobe (pid: 2471, ti=ee94a000 task=ef381470 task.ti=ee94a000)
Stack:
 f0869f88 c021fbf9 c01b1472 f0869f88 f086e000 f0869fbc ee94a000 c01d818f
 f086a200 f086e000 00000000 f086e027 f086a200 c010113d 00000246 00000000
 00000282 0000001e efbd9c20 00000001 00000282 efbcb980 00000001 00000001
Call Trace:
 [<c021fbf9>] driver_register+0x51/0xc2
 [<c01b1472>] sysfs_addrm_finish+0x13/0x1aa
 [<f086e000>] agp_amd64_init+0x0/0xbd [amd64_agp]
 [<c01d818f>] __pci_register_driver+0x3c/0x69
 [<f086e000>] agp_amd64_init+0x0/0xbd [amd64_agp]
 [<f086e027>] agp_amd64_init+0x27/0xbd [amd64_agp]
 [<c010113d>] _stext+0x4d/0x148
 [<c0142936>] load_module+0x12cd/0x142e
 [<c01295dc>] __request_region+0x0/0x80
 [<c0142b1e>] sys_init_module+0x87/0x176
 [<c01039eb>] sysenter_do_call+0x12/0x2f
Code: a3 34 c0 ba d0 80 00 00 53 31 db e8 17 87 fa ff 85 c0 74 0c ba 04 c6 34 c0 89 c3 e8 8b ff ff ff 89 d8 5b c3 85 c0 53 89 c3 74 2e <f6> 40 20 01 75 1a 50 ff 30 68 c7 c6 30 c0 68 50 02 00 00 68 16
EIP: [<c01cbd9f>] kobject_put+0x7/0x37 SS:ESP 0068:ee94be84
---[ end trace 4eaa2a86a8e2da22 ]---


__________________________________________________________________
Run, Fatboy, Run" sowie "Rails & Ties" kostenlos anschauen!
Blockbuster-Gutscheine sichern unter http://www.blockbuster.web.de

