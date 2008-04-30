Return-Path: <linux-kernel-owner+w=401wt.eu-S1765694AbYD3Ugm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765694AbYD3Ugm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759908AbYD3Uge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:36:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:6639 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231AbYD3Ugd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:36:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=O0mDqIHfsPro6Xp1mhoJ8TYoi7U6t/eO0lhtQPHFpM53Ip7s5smOLsuMbt/Lgb+nfEUYVbMNQj6rOnsCqKRxoJIVOFa7Hnno1hBTHE+/dyozwFd4nwjN88D+sVp9pv9sD6sjUwR0/m01FAEYNfvpqIPA+QFJVYFj36RjypB7EPI=
Date: Wed, 30 Apr 2008 22:36:31 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: pata_jmicron: no drives found on post 2.6.25 kernels
Message-ID: <20080430203630.GA6126@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I noticed that with recent (git-current) kernels pata_jmicron does not
detect the drives attached to the controller. This is the boot log with
ATA_DEBUG (kernel is 0ff5ce7f):

[   74.364721] IOAPIC[0]: Set routing entry (2-17 -> 0x81 -> IRQ 17 Mode:1 Active:1)
[   74.364724] ACPI: PCI Interrupt 0000:02:00.1[B] -> GSI 17 (level, low) -> IRQ 17
[   74.365349] ata_host_alloc: ENTER
[   74.365889] ata_port_alloc: ENTER
[   74.366439] ata_port_alloc: ENTER
[   74.367002] PCI: Setting latency timer of device 0000:02:00.1 to 64
[   74.367016] __ata_port_freeze: ata4294967295 port frozen
[   74.367590] __ata_port_freeze: ata4294967295 port frozen
[   74.368200] scsi8 : pata_jmicron
[   74.369129] scsi9 : pata_jmicron
[   74.370719] ata9: PATA max UDMA/100 cmd 0xac00 ctl 0xa880 bmdma 0xa400 irq 17
[   74.371320] ata10: PATA max UDMA/100 cmd 0xa800 ctl 0xa480 bmdma 0xa408 irq 17
[   74.371922] ata_host_register: probe begin
[   74.372492] ata_port_schedule_eh: port EH scheduled
[   74.372552] ata_scsi_error: ENTER
[   74.372553] ata_port_flush_task: ENTER
[   74.372555] ata9: ata_port_flush_task: EXIT
[   74.374263] ata_eh_link_autopsy: ENTER
[   74.374834] ata_eh_recover: ENTER
[   74.375395] __ata_port_freeze: ata9 port frozen
[   74.375974] ata_sff_softreset: ENTER
[   74.376560] ata_sff_softreset: about to softreset, devmask=0
[   74.377149] ata_bus_softreset: ata9: bus reset via SRST
[   74.377782] ata_eh_recover: EXIT, rc=0
[   74.378362] ata_scsi_error: EXIT
[   74.378930] ata_eh_recover: EXIT, rc=0
[   74.379503] ata_scsi_error: EXIT
[   74.518163] ata_sff_softreset: EXIT, classes[0]=9 [1]=9
[   74.518782] ata_std_postreset: ENTER
[   74.535319] ata_std_postreset: EXIT
[   74.535894] ata_sff_postreset: EXIT, no device
[   74.536502] ata_eh_thaw_port: ata9 port thawed
[   74.537085] ata_eh_revalidate_and_attach: ENTER
[   74.537672] ata_eh_recover: EXIT, rc=0
[   74.538248] ata_scsi_error: EXIT
[   74.550074] ata_port_schedule_eh: port EH scheduled
[   74.550078] ata_scsi_error: ENTER
[   74.550080] ata_port_flush_task: ENTER
[   74.550082] ata10: ata_port_flush_task: EXIT
[   74.551850] ata_eh_link_autopsy: ENTER
[   74.552420] ata_eh_recover: ENTER
[   74.552986] __ata_port_freeze: ata10 port frozen
[   74.553572] ata_sff_softreset: ENTER
[   74.554177] ata_sff_softreset: about to softreset, devmask=0
[   74.554787] ata_bus_softreset: ata10: bus reset via SRST
[   74.567885] ata_sff_softreset: EXIT, classes[0]=9 [1]=9
[   74.568513] ata_std_postreset: ENTER
[   74.711145] ata_std_postreset: EXIT
[   74.711727] ata_sff_postreset: EXIT, no device
[   74.721846] ata10: abnormal Status 0x7F
[   74.721867] ata_eh_thaw_port: ata10 port thawed
[   74.722476] ata_eh_revalidate_and_attach: ENTER
[   74.723083] ata_eh_recover: EXIT, rc=0
[   74.723665] ata_scsi_error: EXIT
[   74.737866] ata_host_register: host probe begin
[   74.738485] ata_port_schedule_eh: port EH scheduled
[   74.738488] ata_scsi_error: ENTER
[   74.738489] ata_port_flush_task: ENTER
[   74.738491] ata9: ata_port_flush_task: EXIT
[   74.738499] ata_eh_link_autopsy: ENTER
[   74.738501] ata_eh_recover: ENTER
[   74.738502] ata_eh_revalidate_and_attach: ENTER
[   74.738504] ata_eh_recover: EXIT, rc=0
[   74.738506] ata_scsi_error: EXIT
[   74.743134] ata_port_schedule_eh: port EH scheduled
[   74.743141] ata_scsi_error: ENTER
[   74.743143] ata_port_flush_task: ENTER
[   74.743144] ata10: ata_port_flush_task: EXIT
[   74.743153] ata_eh_link_autopsy: ENTER
[   74.743155] ata_eh_recover: ENTER
[   74.743156] ata_eh_revalidate_and_attach: ENTER
[   74.743158] ata_eh_recover: EXIT, rc=0
[   74.743160] ata_scsi_error: EXIT

The controller has 2 optical drives attached; the first non-working kernel
according to the logs is b69d398 (this is the first one that I tried after
2.6.25, I've *not* bisected - yet). The last known working is 2.6.25, which
shows:

[    1.738722] PCI: Enabling device 0000:02:00.1 (0000 -> 0001)
[    1.740145] IOAPIC[0]: Set routing entry (2-17 -> 0x79 -> IRQ 17 Mode:1 Active:1)
[    1.740149] ACPI: PCI Interrupt 0000:02:00.1[B] -> GSI 17 (level, low) -> IRQ 17
[    1.742572] PCI: Setting latency timer of device 0000:02:00.1 to 64
[    1.742720] scsi0 : pata_jmicron
[    1.744310] scsi1 : pata_jmicron
[    1.749367] ata1: PATA max UDMA/100 cmd 0xac00 ctl 0xa880 bmdma 0xa400 irq 17
[    1.752234] ata2: PATA max UDMA/100 cmd 0xa800 ctl 0xa480 bmdma 0xa408 irq 17
[    1.160600] ata1.00: ATAPI: HL-DT-ST DVDRAM GSA-4167B, DL13, max UDMA/33
[    1.164104] ata1.01: ATAPI: WAITEC  ALADAR/1, 0.010000, max UDMA/33
[    1.788122] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input1
[    1.232612] ata1.00: configured for UDMA/33
[    1.248741] ata1.01: configured for UDMA/33
[    1.848126] scsi 0:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4167B DL13 PQ: 0 ANSI: 5
[    1.863120] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.864130] Uniform CD-ROM driver Revision: 3.20
[    1.868305] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    1.868513] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    1.872777] scsi 0:0:1:0: CD-ROM            WAITEC   ALADAR/1         B1.5 PQ: 0 ANSI: 5
[    1.881239] sr1: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
[    1.884241] sr 0:0:1:0: Attached scsi CD-ROM sr1
[    1.884356] sr 0:0:1:0: Attached scsi generic sg1 type 5

The other controllers (pata_ali and ahci) work fine.

I'll try to bisect in the weekend, unless someone can spot the bug right away
;)

Luca
-- 
The trouble with computers is that they do what you tell them, 
not what you want.
D. Cohen
