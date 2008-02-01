Return-Path: <linux-kernel-owner+w=401wt.eu-S1763974AbYBAN0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763974AbYBAN0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 08:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755909AbYBANZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 08:25:57 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:53440 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761860AbYBANZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:25:55 -0500
Date: Fri, 1 Feb 2008 14:25:52 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24-git9 ACPI oops - regression
Message-ID: <20080201132551.GA4199@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Fri, 01 Feb 2008 14:25:53 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I encountered oops on my laptop Lenovo T61 and dock. If I press undock on the
dock, I got the following oops:

[79721.755165] BUG: unable to handle kernel paging request at 000000340000000e
[79721.755165] IP: [<ffffffff8034d147>] acpi_ns_map_handle_to_node+0x14/0x1d
[79721.755165] PGD 7203a067 PUD 0
[79721.755165] Oops: 0000 [1] SMP
[79721.755165] CPU 1
[79721.755165] Modules linked in: usb_storage i915 drm rfcomm l2cap bluetooth fuse arc4 ecb crypto_blkcipher ehci_hcd uhci_hcd e1000e snd_hda_intel intel_agp thinkpad_acpi [last unloaded: cfg80211]
[79721.755165] Pid: 69, comm: kacpi_notify Not tainted 2.6.24-git9 #4
[79721.755165] RIP: 0010:[<ffffffff8034d147>]  [<ffffffff8034d147>] acpi_ns_map_handle_to_node+0x14/0x1d
[79721.755165] RSP: 0018:ffff81007d197d28  EFLAGS: 00010246
[79721.755165] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[79721.755165] RDX: 0000000000017567 RSI: 000000100002c0d0 RDI: 0000003400000006
[79721.755165] RBP: 0000000000000000 R08: ffff810003c00000 R09: 0000000000000000
[79721.755165] R10: 0000000000000002 R11: 0000000000000001 R12: 0000003400000006
[79721.755165] R13: 0000000000000000 R14: ffff81007d197d68 R15: ffff81007d197d70
[79721.755165] FS:  0000000000000000(0000) GS:ffff81007d00e380(0000) knlGS:0000000000000000
[79721.755165] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[79721.755165] CR2: 000000340000000e CR3: 000000007200a000 CR4: 00000000000006a0
[79721.755165] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[79721.755165] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[79721.755165] Process kacpi_notify (pid: 69, threadinfo ffff81007d196000, task ffff81007d18ef20)
[79721.755165] Stack:  ffffffff8034e19f ffff8100519e8800 ffff81007d197de0 0000000000000001
[79721.755165]  0000000000000000 0000000000000001 ffffffff80357d3d ffff81007d02cdc0
[79721.755165]  0000000000000000 0000003400000006 0000000000000000 ffffffff8058cbaa
[79721.755165] Call Trace:
[79721.755165]  [<ffffffff8034e19f>] acpi_get_next_object+0x3b/0x99
[79721.755165]  [<ffffffff80357d3d>] acpi_bus_trim+0x57/0x109
[79721.755165]  [<ffffffff8035b28b>] hotplug_dock_devices+0x97/0x117
[79721.755166]  [<ffffffff8035b3a9>] handle_eject_request+0x4e/0xd3
[79721.755166]  [<ffffffff8033e04a>] acpi_os_execute_notify+0x0/0x2c
[79721.755166]  [<ffffffff80356088>] acpi_bus_get_device+0x1d/0x2e
[79721.755166]  [<ffffffff803560b0>] acpi_bus_notify+0x17/0x4c
[79721.755166]  [<ffffffff8033e04a>] acpi_os_execute_notify+0x0/0x2c
[79721.755166]  [<ffffffff80343a1d>] acpi_ev_notify_dispatch+0x57/0x60
[79721.755166]  [<ffffffff8033e06d>] acpi_os_execute_notify+0x23/0x2c
[79721.755166]  [<ffffffff802460bf>] run_workqueue+0xbf/0x160
[79721.755166]  [<ffffffff80246b00>] worker_thread+0x0/0x100
[79721.755166]  [<ffffffff80246b00>] worker_thread+0x0/0x100
[79721.755166]  [<ffffffff80246b9f>] worker_thread+0x9f/0x100
[79721.755166]  [<ffffffff80249e50>] autoremove_wake_function+0x0/0x30
[79721.755166]  [<ffffffff80246b00>] worker_thread+0x0/0x100
[79721.755166]  [<ffffffff80246b00>] worker_thread+0x0/0x100
[79721.755166]  [<ffffffff80249a4b>] kthread+0x4b/0x80
[79721.755166]  [<ffffffff8020d128>] child_rip+0xa/0x12
[79721.755166]  [<ffffffff80249a00>] kthread+0x0/0x80
[79721.755166]  [<ffffffff8020d11e>] child_rip+0x0/0x12
[79721.755166]
[79721.755166]
[79721.755166] Code: 00 c3 49 ff c1 48 83 c6 04 41 ff c8 45 85 c0 75 a8 31 c0 c6 06 00 c3 48 8d 47 ff 48 83 f8 fd 76 08 48 8b 05 dc 49 39 00 c3 31 c0 <80> 7f 08 0f 48 0f 44 c7 c3 48 89 f8 c3 31 c0 48 85 ff 74 0d f6
[79721.755166] RIP  [<ffffffff8034d147>] acpi_ns_map_handle_to_node+0x14/0x1d
[79721.755166]  RSP <ffff81007d197d28>
[79721.755166] CR2: 000000340000000e
[79721.755166] ---[ end trace 05a1f30122eb8809 ]---

-- 
Luká¹ Hejtmánek
