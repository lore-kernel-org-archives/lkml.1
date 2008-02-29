Return-Path: <linux-kernel-owner+w=401wt.eu-S933197AbYB2Xha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197AbYB2Xha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 18:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760658AbYB2XhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 18:37:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759959AbYB2XhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 18:37:18 -0500
Message-ID: <47C8972B.10602@redhat.com>
Date: Fri, 29 Feb 2008 18:37:15 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Karsten Keil <kkeil@suse.de>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Hisax driver oopses when CONFIG_DEBUG_SHIRQ is enabled
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From https://bugzilla.redhat.com/show_bug.cgi?id=362621

The driver enables interrupts before it is ready to receive them.

In drivers/isdn/hisax/hisax_fcpcipnp.c, adapter->read_hdlc etc. are
not initialized and the driver attempts to call these functions.

Nov 18 14:54:02 studienpraefekt kernel: hisax_fcpcipnp: found adapter Fritz!Card PCI v2 at 0000:00:0a.0
Nov 18 14:54:02 studienpraefekt kernel: Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP:
Nov 18 14:54:02 studienpraefekt kernel:  [<0000000000000000>]
Nov 18 14:54:02 studienpraefekt kernel: PGD 240ee067 PUD 3effd067 PMD 0
Nov 18 14:54:02 studienpraefekt kernel: Oops: 0010 [1] SMP
Nov 18 14:54:02 studienpraefekt kernel: CPU 0
Nov 18 14:54:02 studienpraefekt kernel: Modules linked in: hisax_fcpcipnp hisax_isac hisax crc_ccitt isdn slhc rfcomm l2cap bluetooth autofs4 nls_utf8 cifs sunrpc nf_conntrack_netbios_ns nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink ipt_REJECT iptable_filter ip_tables xt_tcpudp ip6t_REJECT ip6table_filter ip6_tables x_tables cpufreq_ondemand dm_multipath ipv6 snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss nvidia(P)(U) snd_pcm parport_pc parport snd_timer snd button soundcore k8temp i2c_core floppy hwmon snd_page_alloc pcspkr r8169 usblp sr_mod sg cdrom usb_storage dm_snapshot dm_zero dm_mirror dm_mod sata_sis pata_sis ata_generic libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd
Nov 18 14:54:02 studienpraefekt kernel: Pid: 26799, comm: modprobe Tainted: P        2.6.23.1-49.fc8 #1
Nov 18 14:54:02 studienpraefekt kernel: RIP: 0010:[<0000000000000000>]  [<0000000000000000>]
Nov 18 14:54:02 studienpraefekt kernel: RSP: 0018:ffff810010341c50  EFLAGS: 00010046
Nov 18 14:54:02 studienpraefekt kernel: RAX: 0000000000000000 RBX: ffff810008758270 RCX: ffffffff8106a940
Nov 18 14:54:02 studienpraefekt kernel: RDX: 0000000000001c02 RSI: 0000000000000000 RDI: ffff810008758000
Nov 18 14:54:02 studienpraefekt kernel: RBP: ffff810008758000 R08: ffff810008758000 R09: ffffffff81281000
Nov 18 14:54:02 studienpraefekt kernel: R10: 00000000fffffff4 R11: 0000000080000000 R12: 0000000000000000
Nov 18 14:54:02 studienpraefekt kernel: R13: 0000000000000000 R14: ffffffff88a89f12 R15: 0000000000000080
Nov 18 14:54:02 studienpraefekt kernel: FS:  00002aaaaaadc6f0(0000) GS:ffffffff813bd000(0000) knlGS:00000000f7e266d0
Nov 18 14:54:02 studienpraefekt kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Nov 18 14:54:02 studienpraefekt kernel: CR2: 0000000000000000 CR3: 000000003202c000 CR4: 00000000000006e0
Nov 18 14:54:02 studienpraefekt kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 18 14:54:02 studienpraefekt kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 18 14:54:02 studienpraefekt kernel: Process modprobe (pid: 26799, threadinfo ffff810010340000, task ffff810021094820)
Nov 18 14:54:02 studienpraefekt kernel: Stack:  ffffffff88a89f60 ffffffff811640e4 0000000000000202 ffff810031b2b4c0
Nov 18 14:54:02 studienpraefekt kernel:  ffff810008758000 0000000000000011 ffffffff8106a97f ffffffff813782e0
Nov 18 14:54:02 studienpraefekt kernel:  ffffffff88a8a00b 01000000fffffff4 ffff810008758000 ffff810001ef3000
Nov 18 14:54:02 studienpraefekt kernel: Call Trace:
Nov 18 14:54:02 studienpraefekt kernel:  [<ffffffff88a89f60>] :hisax_fcpcipnp:fcpci2_irq+0x4e/0x8e
Nov 18 14:54:02 studienpraefekt kernel:  [<ffffffff811640e4>] acpi_pci_allocate_irq+0x0/0x4d
Nov 18 14:54:02 studienpraefekt kernel:  [<ffffffff8106a97f>] request_irq+0xb1/0xe6
Nov 18 14:54:02 studienpraefekt kernel:  [<ffffffff88a89548>] :hisax_fcpcipnp:fcpci_probe+0x1b9/0x441
Nov 18 14:54:02 studienpraefekt kernel:  [<ffffffff8112da13>] pci_device_probe+0xd0/0x137
Nov 18 14:54:02 studienpraefekt kernel:  [<ffffffff811963e2>] driver_probe_device+0xff/0x17c
Nov 18 14:54:02 studienpraefekt kernel:  [<ffffffff811965a7>] __driver_attach+0x90/0xcc
Nov 18 14:54:02 studienpraefekt kernel:  [<ffffffff81196517>] __driver_attach+0x0/0xcc
Nov 18 14:54:02 studienpraefekt kernel:  [<ffffffff81196517>] __driver_attach+0x0/0xcc
Nov 18 14:54:02 studienpraefekt kernel:  [<ffffffff81195786>] bus_for_each_dev+0x43/0x6e
Nov 18 14:54:02 studienpraefekt kernel:  [<ffffffff81195afe>] bus_add_driver+0x7b/0x19d
Nov 18 14:54:02 studienpraefekt kernel:  [<ffffffff8112dbde>] __pci_register_driver+0x58/0x8a
Nov 18 14:54:02 studienpraefekt kernel:  [<ffffffff81056e25>] sys_init_module+0x15d5/0x173a
Nov 18 14:54:02 studienpraefekt kernel:  [<ffffffff8100bd45>] tracesys+0xd5/0xda
