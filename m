Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbXEUIuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbXEUIuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 04:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbXEUIuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 04:50:15 -0400
Received: from kim.schedom-europe.net ([193.109.184.78]:37770 "HELO
	kim-in.schedom-europe.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1755664AbXEUIuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 04:50:13 -0400
Message-ID: <46515D3F.2020609@kcore.org>
Date: Mon, 21 May 2007 10:50:07 +0200
From: Jan De Luyck <ml_linuxkernel_20060528@kcore.org>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel BUG at drivers/xen/core/evtchn.c:481!
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yesterday, on a Xen box running debian etch (kernel 2.6.18.4) we were modifying the network configuration in one of the domU's, when suddenly this triggered, taking down the entire box. Network was no longer available either.

May 20 23:52:41 xen02 kernel: ADDRCONF(NETDEV_UP): vif20.0: link is not ready
May 20 23:52:42 xen02 logger: /etc/xen/scripts/vif-bridge: Successful vif-bridge online for vif20.0, bridge xenbr0.
May 20 23:52:42 xen02 logger: /etc/xen/scripts/vif-bridge: Writing backend/vif/20/0/hotplug-status connected to xenstore.
May 20 23:52:42 xen02 logger: /etc/xen/scripts/block: Writing backend/vbd/20/2049/physical-device fd:6 to xenstore.
May 20 23:52:42 xen02 logger: /etc/xen/scripts/block: Writing backend/vbd/20/2049/hotplug-status connected to xenstore.
May 20 23:52:43 xen02 logger: /etc/xen/scripts/block: Writing backend/vbd/20/2050/physical-device fd:7 to xenstore.
May 20 23:52:43 xen02 logger: /etc/xen/scripts/block: Writing backend/vbd/20/2050/hotplug-status connected to xenstore.
May 20 23:52:43 xen02 kernel: ------------[ cut here ]------------
May 20 23:52:43 xen02 kernel: kernel BUG at drivers/xen/core/evtchn.c:481!
May 20 23:52:43 xen02 kernel: invalid opcode: 0000 [#1]
May 20 23:52:43 xen02 kernel: SMP
May 20 23:52:43 xen02 kernel: Modules linked in: xt_tcpudp xt_physdev iptable_filter ip_tables x_tables ipv6 button ac battery bridge loop floppy rtc evdev serio_raw psmouse pcspkr i2c_nforce2 i2c_core ext3 jbd mbcache dm_mirror dm_snapshot dm_mod raid1 md_mod ide_generic ide_cd cdrom sd_mod ehci_hcd ohci_hcd amd74xx sata_sil24 forcedeth usbcore sata_nv libata scsi_mod generic ide_core thermal processor fan
May 20 23:52:43 xen02 kernel: CPU:    1
May 20 23:52:43 xen02 kernel: EIP:    0061:[<c020c14a>]    Not tainted VLI
May 20 23:52:43 xen02 kernel: EFLAGS: 00010046   (2.6.18-4-xen-686 #1)
May 20 23:52:43 xen02 kernel: EIP is at retrigger+0x1f/0x35
May 20 23:52:43 xen02 kernel: eax: 00000000   ebx: 02080000   ecx: 0000002a   edx: f55f6000
May 20 23:52:43 xen02 kernel: esi: c0318760   edi: 00000116   ebp: 00000000   esp: c039deb0
May 20 23:52:43 xen02 kernel: ds: 007b   es: 007b   ss: 0069
May 20 23:52:43 xen02 kernel: Process xenwatch (pid: 11, ti=c039c000 task=c0f2a000 task.ti=c039c000)
May 20 23:52:43 xen02 kernel: Stack: c013b259 c0318760 00000116 c0318788 c013afaf ceb322c0 00000000 00000000
May 20 23:52:43 xen02 kernel:        ceb322c0 c02170f0 00000000 c02174d0 c021065f 00000010 00000000 0000020b
May 20 23:52:43 xen02 kernel:        0000020a 00000000 00000000 c9c643f6 c02e67a4 d13f8000 00000000 00000002
May 20 23:52:43 xen02 kernel: Call Trace:
May 20 23:52:43 xen02 kernel:  [<c013b259>] check_irq_resend+0x41/0x48
May 20 23:52:43 xen02 kernel:  [<c013afaf>] enable_irq+0x72/0x87
May 20 23:52:43 xen02 kernel:  [<c02170f0>] __netif_up+0xb/0x13
May 20 23:52:43 xen02 kernel:  [<c02174d0>] netif_map+0x247/0x26f
May 20 23:52:43 xen02 kernel:  [<c021065f>] xs_talkv+0xe3/0x128
May 20 23:52:43 xen02 kernel:  [<c02109a8>] xenbus_read+0x34/0x3b
May 20 23:52:43 xen02 kernel:  [<c0210d6a>] xenbus_scanf+0x18/0x4d
May 20 23:52:43 xen02 kernel:  [<c0216b61>] frontend_changed+0x29f/0x4a8
May 20 23:52:43 xen02 kernel:  [<c0211d48>] otherend_changed+0x74/0x79 
May 20 23:52:43 xen02 kernel:  [<c02104e2>] xenwatch_handle_callback+0x12/0x44
May 20 23:52:43 xen02 kernel:  [<c0210f27>] xenwatch_thread+0x105/0x11b
May 20 23:52:43 xen02 kernel:  [<c012b6e5>] autoremove_wake_function+0x0/0x2d
May 20 23:52:43 xen02 kernel:  [<c0210e22>] xenwatch_thread+0x0/0x11b
May 20 23:52:43 xen02 kernel:  [<c012b619>] kthread+0xc0/0xeb
May 20 23:52:43 xen02 kernel:  [<c012b559>] kthread+0x0/0xeb
May 20 23:52:43 xen02 kernel:  [<c010293d>] kernel_thread_helper+0x5/0xb
May 20 23:52:43 xen02 kernel: Code: ee 85 f6 75 96 58 5a 5b 5e 5f 5d c3 0f b7 0c 85 40 b8 37 c0 8b 15 84 19 2d c0 85 c9 74 1d 0f a3 8a 80 08 00 00 19 c0 85 c0 75 08 <0f> 0b e1 01 b2 1a 2b c0 f0 0f ab 8a 00 08 00 00 b8 01 00 00 00
May 20 23:52:43 xen02 kernel: EIP: [<c020c14a>] retrigger+0x1f/0x35 SS:ESP 0069:c039deb0

Anyone any ideas?

Thanks,

Jan
