Return-Path: <linux-kernel-owner+w=401wt.eu-S1758537AbYARALV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537AbYARALV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbYARALJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 19:11:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:64796 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbYARALG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 19:11:06 -0500
X-ExtLoop1: 1
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: IOATDMA: driver oopses on request_irq()
Date: Thu, 17 Jan 2008 16:11:04 -0800
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C03D0D609@orsmsx418.amr.corp.intel.com>
In-Reply-To: <478FEC37.2010702@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: IOATDMA: driver oopses on request_irq()
Thread-Index: AchZZUnZr61br0A9T3ehLLPgyVfiZwAADtPA
References: <478FEC37.2010702@redhat.com>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Jan 2008 00:11:05.0169 (UTC) FILETIME=[9DF53C10:01C85966]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Chuck Ebbert [mailto:cebbert@redhat.com] 
>Sent: Thursday, January 17, 2008 4:01 PM
>To: Nelson, Shannon
>Cc: linux-kernel
>Subject: IOATDMA: driver oopses on request_irq()
>
>https://bugzilla.redhat.com/show_bug.cgi?id=311991
>[still present in 2.6.23.8]
>
>[Drivers really need to actually be ready to receive interrupts when
>they call request_irq(). We keep finding drivers that aren't because
>we enable CONFIG_DEBUG_SHIRQ]
>
>kernel version: 2.6.22.7-85.fc7debug
>modprobe ioatdma during bootup sez:
>
>[  142.497353] Module ioatdma cannot be unloaded due to unsafe usage in
>drivers/dma/ioatdma.c:829
>[  142.497906] ACPI: PCI Interrupt 0000:00:08.0[A] -> GSI 16 
>(level, low) -> IRQ 16
>[  142.497945] Unable to handle kernel NULL pointer dereference at
>0000000000000003 RIP: 
>[  142.498002]  [<ffffffff8835adc0>] 
>:ioatdma:ioat_do_interrupt+0xd/0x50
>[  142.498770] PGD 10fc46067 PUD 114a56067 PMD 0 
>[  142.499156] Oops: 0000 [1] SMP 
>[  142.499498] last sysfs file: /block/sr0/removable
>[  142.499753] CPU 3 
>[  142.500049] Modules linked in: ioatdma dell_rbu nfsd 
>exportfs lockd nfs_acl
>ipmi_devintf ipmi_si ipmi_msghandler hidp l2cap bluetooth sunr
>pc xt_length ipt_TOS xt_state xt_tcpudp ipt_REJECT ipt_LOG xt_limit
>iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 
>nf_conntrack nfnetlin
>k iptable_filter ip_tables x_tables ppp_deflate zlib_deflate 
>ppp_synctty
>ppp_async crc_ccitt ppp_generic slhc bridge dm_mirror dm_multipath d
>m_mod video sbs button dock battery ac tcp_westwood kvm_intel 
>kvm sr_mod cdrom
>ata_generic ata_piix serio_raw libata bnx2 rtc_cmos sg joydev 
>usb_storage shpchp megaraid_sas sd_mod scsi_mod ext3 jbd 
>mbcache ehci_hcd
>ohci_hcd uhci_hcd
>[  142.505129] Pid: 5239, comm: modprobe Not tainted 
>2.6.22.7-85.fc7debug #1
>[  142.505386] RIP: 0010:[<ffffffff8835adc0>]  [<ffffffff8835adc0>]
>:ioatdma:ioat_do_interrupt+0xd/0x50
>[  142.505892] RSP: 0018:ffff81010ff83c48  EFLAGS: 00010096
>[  142.506146] RAX: 0000000000001214 RBX: 0000000000000202 
>RCX: ffffffff8835b0f5
>[  142.506405] RDX: 0000000000000000 RSI: ffff81012cc11700 
>RDI: 00000000000008f4
>[  142.506663] RBP: ffff81012cc11700 R08: ffff81012cc11700 
>R09: ffff81012cc11700
>[  142.506919] R10: 000000000000005a R11: ffffffff811f2016 
>R12: 0000000000000020
>[  142.507176] R13: ffff81012cc11700 R14: ffffffff8835adb3 
>R15: 00000000000008f4
>[  142.507434] FS:  00002aaaaaae0250(0000) GS:ffff810105855900(0000)
>knlGS:0000000000000000
>[  142.507892] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>[  142.508147] CR2: 0000000000000003 CR3: 0000000110281000 
>CR4: 00000000000026e0
>[  142.508406] Process modprobe (pid: 5239, threadinfo 
>ffff81010ff82000, task
>ffff8101106dcf60)
>[  142.508866] Stack:  ffff81012cc11700 0000000000000202 
>ffff81012447ab40
>ffffffff81069bd8
>[  142.509544]  ffff81012447ac80 ffffffff8835b0f5 
>01ff81012f971070 ffff81012f971070
>[  142.510176]  ffff81012cc11700 ffff81012f971000 
>00000000fffffff4 0000000000000000
>[  142.510566] Call Trace:
>[  142.511063]  [<ffffffff81069bd8>] request_irq+0xcc/0x120
>[  142.511321]  [<ffffffff8835aab7>] :ioatdma:ioat_probe+0x15b/0x457
>[  142.511581]  [<ffffffff8126a916>] _spin_unlock+0x17/0x20
>[  142.511839]  [<ffffffff8112c1be>] pci_device_probe+0xcd/0x134
>[  142.512097]  [<ffffffff811a54a3>] driver_probe_device+0xff/0x17c
>[  142.512354]  [<ffffffff811a5668>] __driver_attach+0x90/0xcc
>[  142.512609]  [<ffffffff811a55d8>] __driver_attach+0x0/0xcc
>[  142.512865]  [<ffffffff811a55d8>] __driver_attach+0x0/0xcc
>[  142.513120]  [<ffffffff811a4824>] bus_for_each_dev+0x43/0x6e
>[  142.513378]  [<ffffffff811a4b9c>] bus_add_driver+0x7b/0x19d
>[  142.513634]  [<ffffffff8112c3a0>] __pci_register_driver+0x68/0x9a
>[  142.513892]  [<ffffffff81055f70>] sys_init_module+0x163f/0x17a1
>[  142.514153]  [<ffffffff81067540>] audit_syscall_entry+0x141/0x174
>[  142.514414]  [<ffffffff81009d2e>] tracesys+0xd5/0xda
>[  142.514673] 
>[  142.514920] 
>[  142.514920] Code: 8a 42 03 0f b6 d8 31 c0 f6 c3 01 74 31 f6 
>c3 02 75 0a 0f b6 
>[  142.516541] RIP  [<ffffffff8835adc0>] 
>:ioatdma:ioat_do_interrupt+0xd/0x50
>[  142.516841]  RSP <ffff81010ff83c48>
>[  142.517091] CR2: 0000000000000003


Chuck - We did some significant rework on the ioatdma driver last
summer.  Unfortunately it didn't make it into 2.6.23, but it is
available in 2.6.24 as well as out-of-core on our SourceForge site.
Please try the newer code - I believe it will fix your problem.

Thanks,
sln
======================================================================
Mr. Shannon Nelson                 LAN Access Division, Intel Corp.
Shannon.Nelson@intel.com                I don't speak for Intel
(503) 712-7659                    Parents can't afford to be squeamish.
