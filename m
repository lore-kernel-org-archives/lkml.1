Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbYECU33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbYECU33 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 16:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbYECU3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 16:29:19 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:45728 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbYECU3S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 16:29:18 -0400
Date: Sat, 03 May 2008 22:29:16 +0200
Message-Id: <263898027@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org,
       jgarzik@redhat.com, rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: modprobe aha1542 oops with git17
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18lDeXmE0k7jUFtygUpjmHB8bXELTn9LQjeN7hS29clVUcGc
 KFpMJ8BHqilSCykymJSzsicP3asnqTPHHMJ2fUZshkFMmmacAk=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this also happens on real hardware with latest git - no aha1542 attached

didn`t happen before - looks like a regression to me



List:       linux-kernel
Subject:    modprobe aha1542 oops with git17
From:       "Roland" <devzero () web ! de>
Date:       2008-05-01 23:49:54

2.6.25-git17-default on vmware - i`m getting oops when modprobe aha1542 (ok, 
makes no sense in vmware, but i think this is a regression because it never 
happend before. i did the same test with older kernels)


BUG: unable to handle kernel NULL pointer dereference at 00000004
IP: [<d0820766>] :scsi_mod:scsi_destroy_command_freelist+0xd/0x4f
*pde = 00000000
Oops: 0000 [#1] SMP
Modules linked in: aha1542(+) iptable_filter ip_tables ip6table_filter 
ip6_tables x_tables ipv6 af_packet microcode firmware_class fuse loop dm_mod 
ide_cd_mod cdrom pata_acpi ata_piix ahci ata_generic libata dock 
ide_pci_generic rtc_cmos shpchp rtc_core intel_agp piix parport_pc pcnet32 
rtc_lib i2c_piix4 parport mii container agpgart ac pci_hotplug button 
ide_core i2c_core uhci_hcd usbcore edd ext3 mbcache jbd fan mptsas 
scsi_transport_sas mptfc scsi_transport_fc scsi_tgt mptspi mptscsih mptbase 
scsi_transport_spi sd_mod sg scsi_mod thermal processor [last unloaded: 
speedstep_lib]

Pid: 2543, comm: modprobe Not tainted (2.6.25-git17-default #1)
EIP: 0060:[<d0820766>] EFLAGS: 00010217 CPU: 0
EIP is at scsi_destroy_command_freelist+0xd/0x4f [scsi_mod]
EAX: c0c08800 EBX: 00000000 ECX: 00000000 EDX: fffffffc
ESI: c0c08800 EDI: c0c08818 EBP: d0b4469c ESP: cf3c7e44
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process modprobe (pid: 2543, ti=cf3c6000 task=ce8e94a0 task.ti=cf3c6000)
Stack: c0c08800 00000000 00000000 d0820e05 c0c08960 c037a7cc c0231479 
c01cc33b
       c0c08964 c01cc2fe 00000330 c01ccd5a ce1a5b40 d0a7a980 d08dd8ca 
cda0d4e0
       c01106a6 d0a7a8b8 00000000 c01106bc 00000000 c0c08800 00000000 
c036c380
Call Trace:
 [<d0820e05>] scsi_host_dev_release+0x68/0x93 [scsi_mod]
 [<c0231479>] device_release+0x34/0x56
 [<c01cc33b>] kobject_release+0x3d/0x4f
 [<c01cc2fe>] kobject_release+0x0/0x4f
 [<c01ccd5a>] kref_put+0x36/0x40
 [<d08dd8ca>] aha1542_detect+0x790/0x7b8 [aha1542]
 [<c01106a6>] do_flush_tlb_all+0x0/0x3c
 [<c01106bc>] do_flush_tlb_all+0x16/0x3c
 [<d08dd0cc>] init_this_scsi_driver+0x56/0xc4 [aha1542]
 [<c013db4c>] sys_init_module+0x1694/0x17a7
 [<c0125fe7>] __request_region+0x0/0x74
 [<c01079de>] sys_mmap2+0x62/0x77
 [<c010491f>] sysenter_past_esp+0x78/0xb9
 =======================
Code: 08 75 0f 8b 06 e8 10 b2 94 ef 8b 46 04 e8 08 b2 94 ef 5b b8 90 1b 84 
d0 5e e9 c1 13 aa ef 57 56 89 c6 53 8d 78 18 eb 1c 8d 53 fc <8b> 42 08 8b 4a 
04 89 41 04 89 08 89 5a 08 89 5a 04 8b 46 10 e8
EIP: [<d0820766>] scsi_destroy_command_freelist+0xd/0x4f [scsi_mod] SS:ESP 
0068:cf3c7e44
---[ end trace 3406cf5eaefbd6bf ]---
_______________________________________________________________________
Jetzt neu! Schützen Sie Ihren PC mit McAfee und WEB.DE. 30 Tage
kostenlos testen. http://www.pc-sicherheit.web.de/startseite/?mc=022220

