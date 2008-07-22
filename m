Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbYGVLY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbYGVLY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 07:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbYGVLYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 07:24:49 -0400
Received: from nn7.de ([85.214.94.156]:43257 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbYGVLYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 07:24:48 -0400
Subject: BUG: unable to handle kernel paging request at 00be00e0 in 2.6.26
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 22 Jul 2008 13:24:18 +0200
Message-Id: <1216725858.19431.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all, 

I am having an uptime on this notebook (mbp1,1) with 2.6.26 of 5 days
now, even though I've suspend/resumed several times (yeah!). However,
just today I've seen this in dmesg. While the machine still works, I am
slightly worried what it could be. The machine is tainted due to
madwifi, though it really looks unrelated.

Any ideas?
Soeren

BUG: unable to handle kernel paging request at 00be00e0
IP: [<c019a306>] touch_atime+0x46/0x120
*pde = 00000000 
Oops: 0000 [#2] PREEMPT SMP 
Modules linked in: coretemp wlan_scan_sta ath_rate_sample ath_pci ath_hal(P) appletouch tun wlan_tkip wlan_ccmp wlan vfat fat usb_storage ppp_mppe ppp_async crc_ccitt ppp_generic slhc radeon drm hci_usb 

Pid: 17138, comm: evolution Tainted: P      D   (2.6.26-sonne #41)
EIP: 0060:[<c019a306>] EFLAGS: 00010246 CPU: 1
EIP is at touch_atime+0x46/0x120
EAX: 00000000 EBX: c008ef98 ECX: 00be00b0 EDX: 00000000
ESI: f71fec00 EDI: cd27df04 EBP: cd27ddd4 ESP: cd27ddcc
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process evolution (pid: 17138, ti=cd27c000 task=f11b6b70 task.ti=cd27c000)
Stack: c008ef98 00000000 cd27de4c c018fa63 f7dd8069 e7e9c458 00000101 5a3b0067 
       00000001 c1b47600 afa2301c f1a814d0 f1afbc00 c1ffc7bc c1627620 c1ff9904 
       00000286 cdcfe380 c01818b1 cd27df04 f7dd8000 00000000 5bba4c29 00000006 
Call Trace:
 [<c018fa63>] ? __link_path_walk+0xbb3/0xe10
 [<c01818b1>] ? __slab_alloc+0x91/0x6f0
 [<c018fd0c>] ? path_walk+0x4c/0xb0
 [<c018ff65>] ? do_path_lookup+0x85/0x1e0
 [<c019038d>] ? __path_lookup_intent_open+0x4d/0xa0
 [<c01903ff>] ? path_lookup_open+0x1f/0x30
 [<c01910ac>] ? do_filp_open+0x8c/0x820
 [<c0426c75>] ? schedule+0x3f5/0x9f0
 [<c0183d0d>] ? get_unused_fd_flags+0xad/0x100
 [<c0183db7>] ? do_sys_open+0x57/0xf0
 [<c0183eb9>] ? sys_open+0x29/0x40
 [<c01032d1>] ? sysenter_past_esp+0x6a/0x91
 =======================
Code: f6 83 38 01 00 00 02 74 1c 89 f0 e8 05 4f 00 00 8b 1c 24 8b 74 24 04 89 ec 5d c3 8d 76 00 8d bc 27 00 00 00 00 8b 8b 9c 00 00 00 <8b> 41 30 a9 01 04 00 00 75 d4 f6 c4 08 74 10 0f b7 43 6e 25 00 
EIP: [<c019a306>] touch_atime+0x46/0x120 SS:ESP 0068:cd27ddcc
---[ end trace 8b5f108dfcf9cdda ]---

