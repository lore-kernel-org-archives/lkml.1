Return-Path: <linux-kernel-owner+w=401wt.eu-S1765219AbYARSqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765219AbYARSqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764899AbYARSqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:46:18 -0500
Received: from nn7.de ([85.214.94.156]:53141 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764224AbYARSqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:46:17 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jan 2008 13:46:16 EST
Subject: 2.6.24-rc8 oops ext3_clear_inode+0x25/0xa0
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 18 Jan 2008 19:39:33 +0100
Message-Id: <1200681573.4252.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I've just got this oops (causing the machine to hang finally)...

Any ideas?
Soeren

BUG: unable to handle kernel paging request at virtual address 66e88e66
printing eip: c01fac85 *pde = 00000000 
Oops: 0002 [#1] PREEMPT SMP 
Modules linked in: hci_usb hidp rfcomm l2cap bluetooth tun cpufreq_stats coretemp xfrm_user xfrm4_tunnel tunnel4 ipcomp esp4 ah4 aes_generic hfsplus binfmt_misc fuse ebtable_broute bridge llc ebtable_nat ebtable_filter ebtables eeprom applesmc hwmon input_polldev snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_timer appletouch evdev i2c_i801 snd soundcore snd_page_alloc sky2 video intel_agp output agpgart

Pid: 205, comm: kswapd0 Not tainted (2.6.24-rc8-sonne #7)
EIP: 0060:[<c01fac85>] EFLAGS: 00010213 CPU: 1
EIP is at ext3_clear_inode+0x25/0xa0
EAX: c008f0a0 EBX: c008f000 ECX: 00000000 EDX: 66e88e66
ESI: c008f0a0 EDI: 0f01c883 EBP: 0000004d ESP: f7d29ebc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kswapd0 (pid: 205, ti=f7d28000 task=f7fdf540 task.ti=f7d28000)
Stack: c008f0a0 00000000 f7d29ef8 c0192d62 0000004d c008f0a0 c008f0a8 c019309a 
       e98b9ac8 00000080 00000080 f7d29ef8 c01932ec 00000000 00000080 c008f2b0 
       ea1bdcd8 0002d438 0000013f c04ac24c 000000d0 c0166e4c 00002e0b 00000000 
Call Trace:
 [<c0192d62>] clear_inode+0x62/0x140
 [<c019309a>] dispose_list+0x1a/0xe0
 [<c01932ec>] shrink_icache_memory+0x18c/0x250
 [<c0166e4c>] shrink_slab+0x12c/0x1a0
 [<c016726d>] kswapd+0x32d/0x4d0
 [<c0142020>] autoremove_wake_function+0x0/0x40
 [<c0127c5d>] complete+0x3d/0x60
 [<c0166f40>] kswapd+0x0/0x4d0
 [<c0141d52>] kthread+0x42/0x70
 [<c0141d10>] kthread+0x0/0x70
 [<c01050b3>] kernel_thread_helper+0x7/0x14
 =======================
Code: 12 11 f8 ff 66 90 83 ec 0c 89 1c 24 8d 98 60 ff ff ff 89 74 24 04 89 c6 89 7c 24 08 8b 53 70 8b 7b 54 85 d2 74 16 83 fa ff 74 11 <f0> ff 0a 0f 94 c0 84 c0 75 51 c7 43 70 ff ff ff ff 8b 53 74 85 
EIP: [<c01fac85>] ext3_clear_inode+0x25/0xa0 SS:ESP 0068:f7d29ebc
---[ end trace 8dd028de7ae6e34e ]---

