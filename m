Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbYJYJSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbYJYJSd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 05:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYJYJSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 05:18:25 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:42235 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbYJYJSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 05:18:24 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: WARNING: at drivers/ata/libata-eh.c:664 (and others) with 2.6.27-05178
Date: Sat, 25 Oct 2008 11:18:14 +0200
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_WRuAJC2X5p1TTxO"
Message-Id: <200810251118.14714.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_WRuAJC2X5p1TTxO
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello Jens,

while doing a backup on DVD+R I got the following warning (and a k3b hung).
the drive is a Plextor 716A on a jmicron PATA port.
I have never seen this with earlier kernels. I am a bit reluctant to
reproduce or bisect this problem, since it might kills my blank DVDs.
Could this be related to commit
e013e13bf605b9e6b702adffbe2853cfc60e7806 (libata: fix bug with non-ncq devices)?
Thank you for any idea.


Oct 24 19:49:15 Festrechner kernel: [21790.704070] ------------[ cut here ]------------
Oct 24 19:49:15 Festrechner kernel: [21790.704073] WARNING: at drivers/ata/libata-eh.c:664 ata_scsi_error+0x432/0x750()
Oct 24 19:49:15 Festrechner kernel: [21790.704075] Modules linked in: ehci_hcd uhci_hcd
Oct 24 19:49:15 Festrechner kernel: [21790.704079] Pid: 560, comm: scsi_eh_6 Not tainted 2.6.27-05178-g2e532d6-dirty #31
Oct 24 19:49:15 Festrechner kernel: [21790.704081] Call Trace:
Oct 24 19:49:15 Festrechner kernel: [21790.704085]  [<ffffffff8025e124>] warn_on_slowpath+0x64/0xa0
Oct 24 19:49:15 Festrechner kernel: [21790.704089]  [<ffffffff8041f5d9>] __next_cpu+0x19/0x30
Oct 24 19:49:15 Festrechner kernel: [21790.704093]  [<ffffffff806e09b5>] _spin_unlock_irq+0x5/0x40
Oct 24 19:49:15 Festrechner kernel: [21790.704096]  [<ffffffff802710bd>] __cancel_work_timer+0xad/0x190
Oct 24 19:49:15 Festrechner kernel: [21790.704098]  [<ffffffff806e09b5>] _spin_unlock_irq+0x5/0x40
Oct 24 19:49:15 Festrechner kernel: [21790.704100]  [<ffffffff80519725>] atapi_qc_complete+0x2b5/0x300
Oct 24 19:49:15 Festrechner kernel: [21790.704102]  [<ffffffff8051fda0>] __ata_eh_qc_complete+0x50/0x90
Oct 24 19:49:15 Festrechner kernel: [21790.704104]  [<ffffffff805235a0>] ata_sff_softreset+0x0/0x190
Oct 24 19:49:15 Festrechner kernel: [21790.704109]  [<ffffffff80246285>] default_spin_lock_flags+0x5/0x10
Oct 24 19:49:15 Festrechner kernel: [21790.704111]  [<ffffffff80520a82>] ata_scsi_error+0x432/0x750
Oct 24 19:49:15 Festrechner kernel: [21790.704114]  [<ffffffff804fc454>] scsi_error_handler+0xe4/0x390
Oct 24 19:49:15 Festrechner kernel: [21790.704116]  [<ffffffff804fc370>] scsi_error_handler+0x0/0x390
Oct 24 19:49:15 Festrechner kernel: [21790.704118]  [<ffffffff802749a7>] kthread+0x47/0x90
Oct 24 19:49:15 Festrechner kernel: [21790.704121]  [<ffffffff80255d67>] schedule_tail+0x27/0x70
Oct 24 19:49:15 Festrechner kernel: [21790.704124]  [<ffffffff8022a799>] child_rip+0xa/0x11
Oct 24 19:49:15 Festrechner kernel: [21790.704126]  [<ffffffff80274960>] kthread+0x0/0x90
Oct 24 19:49:15 Festrechner kernel: [21790.704128]  [<ffffffff8022a78f>] child_rip+0x0/0x11
Oct 24 19:49:15 Festrechner kernel: [21790.704129] ---[ end trace d8575dac2ce59ba0 ]---
Oct 24 19:49:15 Festrechner kernel: [21790.704216] ------------[ cut here ]------------
Oct 24 19:49:15 Festrechner kernel: [21790.704217] WARNING: at drivers/ata/libata-eh.c:3239 ata_eh_finish+0xc3/0xd0()
Oct 24 19:49:15 Festrechner kernel: [21790.704219] Modules linked in: ehci_hcd uhci_hcd
Oct 24 19:49:15 Festrechner kernel: [21790.704221] Pid: 560, comm: scsi_eh_6 Tainted: G        W 2.6.27-05178-g2e532d6-dirty #31
Oct 24 19:49:15 Festrechner kernel: [21790.704223] Call Trace:
Oct 24 19:49:15 Festrechner kernel: [21790.704224]  [<ffffffff8025e124>] warn_on_slowpath+0x64/0xa0
Oct 24 19:49:15 Festrechner kernel: [21790.704226]  [<ffffffff8051e355>] ata_eh_link_autopsy+0x115/0x770
Oct 24 19:49:15 Festrechner kernel: [21790.704229]  [<ffffffff804f8420>] scsi_done+0x0/0x10
Oct 24 19:49:15 Festrechner kernel: [21790.704231]  [<ffffffff806e06b4>] _spin_lock+0x14/0x20
Oct 24 19:49:15 Festrechner kernel: [21790.704233]  [<ffffffff8041f5d9>] __next_cpu+0x19/0x30
Oct 24 19:49:15 Festrechner kernel: [21790.704235]  [<ffffffff806e09b5>] _spin_unlock_irq+0x5/0x40
Oct 24 19:49:15 Festrechner kernel: [21790.704237]  [<ffffffff802710bd>] __cancel_work_timer+0xad/0x190
Oct 24 19:49:15 Festrechner kernel: [21790.704239]  [<ffffffff80246285>] default_spin_lock_flags+0x5/0x10
Oct 24 19:49:15 Festrechner kernel: [21790.704241]  [<ffffffff806e054d>] _spin_lock_irqsave+0x3d/0x50
Oct 24 19:49:15 Festrechner kernel: [21790.704243]  [<ffffffff805235a0>] ata_sff_softreset+0x0/0x190
Oct 24 19:49:15 Festrechner kernel: [21790.704245]  [<ffffffff805235a0>] ata_sff_softreset+0x0/0x190
Oct 24 19:49:15 Festrechner kernel: [21790.704248]  [<ffffffff8052abc0>] jmicron_pre_reset+0x0/0x180
Oct 24 19:49:15 Festrechner kernel: [21790.704250]  [<ffffffff8051fed3>] ata_eh_finish+0xc3/0xd0
Oct 24 19:49:15 Festrechner kernel: [21790.704252]  [<ffffffff805209ca>] ata_scsi_error+0x37a/0x750
Oct 24 19:49:15 Festrechner kernel: [21790.704254]  [<ffffffff804fc454>] scsi_error_handler+0xe4/0x390
Oct 24 19:49:15 Festrechner kernel: [21790.704256]  [<ffffffff804fc370>] scsi_error_handler+0x0/0x390
Oct 24 19:49:15 Festrechner kernel: [21790.704258]  [<ffffffff802749a7>] kthread+0x47/0x90
Oct 24 19:49:15 Festrechner kernel: [21790.704260]  [<ffffffff80255d67>] schedule_tail+0x27/0x70
Oct 24 19:49:15 Festrechner kernel: [21790.704262]  [<ffffffff8022a799>] child_rip+0xa/0x11
Oct 24 19:49:15 Festrechner kernel: [21790.704264]  [<ffffffff80274960>] kthread+0x0/0x90
Oct 24 19:49:15 Festrechner kernel: [21790.704265]  [<ffffffff8022a78f>] child_rip+0x0/0x11
Oct 24 19:49:15 Festrechner kernel: [21790.704266] ---[ end trace d8575dac2ce59ba0 ]---
Oct 24 19:49:15 Festrechner kernel: [21790.704273] ------------[ cut here ]------------
Oct 24 19:49:15 Festrechner kernel: [21790.704274] WARNING: at drivers/ata/libata-core.c:4851 ata_qc_issue+0x42/0x250()
Oct 24 19:49:15 Festrechner kernel: [21790.704275] Modules linked in: ehci_hcd uhci_hcd
Oct 24 19:49:15 Festrechner kernel: [21790.704278] Pid: 560, comm: scsi_eh_6 Tainted: G        W 2.6.27-05178-g2e532d6-dirty #31
Oct 24 19:49:15 Festrechner kernel: [21790.704279] Call Trace:
Oct 24 19:49:15 Festrechner kernel: [21790.704281]  [<ffffffff8025e124>] warn_on_slowpath+0x64/0xa0
Oct 24 19:49:15 Festrechner kernel: [21790.704283]  [<ffffffff80246285>] default_spin_lock_flags+0x5/0x10
Oct 24 19:49:15 Festrechner kernel: [21790.704285]  [<ffffffff806e054d>] _spin_lock_irqsave+0x3d/0x50
Oct 24 19:49:15 Festrechner kernel: [21790.704288]  [<ffffffff80279466>] up+0x16/0x50
Oct 24 19:49:15 Festrechner kernel: [21790.704290]  [<ffffffff806e054d>] _spin_lock_irqsave+0x3d/0x50
Oct 24 19:49:15 Festrechner kernel: [21790.704292]  [<ffffffff8025e92d>] release_console_sem+0x1ad/0x200
Oct 24 19:49:15 Festrechner kernel: [21790.704295]  [<ffffffff80231632>] read_tsc+0x12/0x40
Oct 24 19:49:15 Festrechner kernel: [21790.704297]  [<ffffffff80512322>] ata_qc_issue+0x42/0x250
Oct 24 19:49:15 Festrechner kernel: [21790.704299]  [<ffffffff80518b20>] ata_scsi_translate+0xa0/0x180
Oct 24 19:49:15 Festrechner kernel: [21790.704301]  [<ffffffff804f8420>] scsi_done+0x0/0x10
Oct 24 19:49:15 Festrechner kernel: [21790.704303]  [<ffffffff8051b606>] ata_scsi_queuecmd+0xb6/0x2e0
Oct 24 19:49:15 Festrechner kernel: [21790.704305]  [<ffffffff804f851f>] scsi_dispatch_cmd+0xef/0x220
Oct 24 19:49:15 Festrechner kernel: [21790.704308]  [<ffffffff804fefe8>] scsi_request_fn+0x2a8/0x3c0
Oct 24 19:49:15 Festrechner kernel: [21790.704310]  [<ffffffff8041122d>] blk_invoke_request_fn+0x3d/0x130
Oct 24 19:49:15 Festrechner kernel: [21790.704312]  [<ffffffff80411408>] blk_run_queue+0x28/0x50
Oct 24 19:49:15 Festrechner kernel: [21790.704314]  [<ffffffff804fe5fb>] scsi_next_command+0x3b/0x60
Oct 24 19:49:15 Festrechner kernel: [21790.704316]  [<ffffffff804fe6c3>] scsi_end_request+0xa3/0xb0
Oct 24 19:49:15 Festrechner kernel: [21790.704319]  [<ffffffff804fe7ed>] scsi_io_completion+0x11d/0x430
Oct 24 19:49:15 Festrechner kernel: [21790.704321]  [<ffffffff806e054d>] _spin_lock_irqsave+0x3d/0x50
Oct 24 19:49:15 Festrechner kernel: [21790.704323]  [<ffffffff804fdbb9>] scsi_device_unbusy+0x79/0xb0
Oct 24 19:49:15 Festrechner kernel: [21790.704325]  [<ffffffff804fb5d9>] scsi_eh_flush_done_q+0x49/0xc0
Oct 24 19:49:15 Festrechner kernel: [21790.704327]  [<ffffffff806e054d>] _spin_lock_irqsave+0x3d/0x50
Oct 24 19:49:15 Festrechner kernel: [21790.704329]  [<ffffffff80520a8b>] ata_scsi_error+0x43b/0x750
Oct 24 19:49:15 Festrechner kernel: [21790.704331]  [<ffffffff804fc454>] scsi_error_handler+0xe4/0x390
Oct 24 19:49:15 Festrechner kernel: [21790.704333]  [<ffffffff804fc370>] scsi_error_handler+0x0/0x390
Oct 24 19:49:15 Festrechner kernel: [21790.704335]  [<ffffffff802749a7>] kthread+0x47/0x90
Oct 24 19:49:15 Festrechner kernel: [21790.704336]  [<ffffffff80255d67>] schedule_tail+0x27/0x70
Oct 24 19:49:15 Festrechner kernel: [21790.704338]  [<ffffffff8022a799>] child_rip+0xa/0x11
Oct 24 19:49:15 Festrechner kernel: [21790.704340]  [<ffffffff80274960>] kthread+0x0/0x90
Oct 24 19:49:15 Festrechner kernel: [21790.704342]  [<ffffffff8022a78f>] child_rip+0x0/0x11
Oct 24 19:49:15 Festrechner kernel: [21790.704343] ---[ end trace d8575dac2ce59ba0 ]---


--Boundary-00=_WRuAJC2X5p1TTxO
Content-Type: text/plain;
  charset="iso 8859-15";
  name="lspci"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci"

00:00.0 Host bridge: Intel Corporation 82G33/G31/P35/P31 Express DRAM Controller (rev 02)
00:01.0 PCI bridge: Intel Corporation 82G33/G31/P35/P31 Express PCI Express Root Port (rev 02)
00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 02)
00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 02)
00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 02)
00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 02)
00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 02)
00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 5 (rev 02)
00:1c.5 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 6 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
00:1f.0 ISA bridge: Intel Corporation 82801IB (ICH9) LPC Interface Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801IB (ICH9) 2 port SATA IDE Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 02)
00:1f.5 IDE interface: Intel Corporation 82801I (ICH9 Family) 2 port SATA IDE Controller (rev 02)
01:00.0 VGA compatible controller: ATI Technologies Inc RV505 CE [Radeon X1550 64-bit]
01:00.1 Display controller: ATI Technologies Inc Device 717f
02:00.0 Ethernet controller: Attansic Technology Corp. L1 Gigabit Ethernet Adapter (rev b0)
03:00.0 SATA controller: JMicron Technologies, Inc. JMicron 20360/20363 AHCI Controller (rev 03)
03:00.1 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363 AHCI Controller (rev 03)
05:03.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306 Fire II IEEE 1394 OHCI Link Layer Controller (rev c0)

--Boundary-00=_WRuAJC2X5p1TTxO
Content-Type: application/x-gzip;
  name="config-2.6.27-05178-g2e532d6-dirty.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="config-2.6.27-05178-g2e532d6-dirty.gz"

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
/j8FHGnym7EAAA==

--Boundary-00=_WRuAJC2X5p1TTxO--
