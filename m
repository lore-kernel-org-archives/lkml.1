Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbXCHRgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbXCHRgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 12:36:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbXCHRgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 12:36:11 -0500
Received: from outmx001.isp.belgacom.be ([195.238.5.51]:60596 "EHLO
	outmx001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbXCHRgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 12:36:09 -0500
From: Jan De Luyck <ml_linuxkernel_20060528@kcore.org>
Subject: EXT3-fs warning (device sdd2): dx_probe: Unrecognised inode hash code 232
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Disposition: inline
To: linux-kernel@vger.kernel.org
Date: Thu, 8 Mar 2007 18:35:54 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200703081835.54380.ml_linuxkernel_20060528@kcore.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Running 2.6.19.1 on AMD64.

While copying some files on an ext3 partition, I got this in the logs:

EXT3-fs warning (device sdd2): dx_probe: Unrecognised inode hash code 232
Assertion failure in dx_probe() at fs/ext3/namei.c:384: "dx_get_limit(entries) 
== dx_root_limit(dir, root->info.info_length)"
----------- [cut here ] --------- [please bite here ] ---------
Kernel BUG at fs/ext3/namei.c:384
invalid opcode: 0000 [1] PREEMPT SMP
CPU 0
Modules linked in: xt_multiport iptable_filter ip_tables x_tables binfmt_misc 
fuse parport_pc lp parport thermal fan button nls_iso8859_15 ntfs kqemu(P) 
tcp_diag inet_diag w83627ehf i2c_isa cpufreq_ondemand powernow_k8 freq_table 
processor snd_hda_intel snd_hda_codec snd_pcm evdev snd_timer psmouse snd 
pcspkr floppy ehci_hcd soundcore snd_page_alloc usbcore k8temp hwmon ohci1394 
ieee1394 forcedeth i2c_nforce2 i2c_core sg sr_mod cdrom
Pid: 4018, comm: find Tainted: P      2.6.19.5 #1
RIP: 0010:[<ffffffff802efe2b>]  [<ffffffff802efe2b>] dx_probe+0x18b/0x320
RSP: 0018:ffff81006b789d28  EFLAGS: 00010292
RAX: 0000000000000081 RBX: ffff810066f07018 RCX: 00000000c0000100
RDX: ffff81006b788000 RSI: ffff81006b5c62c0 RDI: 00000000ffffffff
RBP: 0000000000000000 R08: ffff81006b788000 R09: 0000000000000001
R10: 0000000000000000 R11: ffffffff80212a20 R12: ffff810066e6f8e8
R13: 0000000000000000 R14: 0000000000000000 R15: ffff810066f06730
FS:  00002ae8c9f5c6d0(0000) GS:ffffffff80586000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002af535db8086 CR3: 000000006b7b2000 CR4: 00000000000006e0
Process find (pid: 4018, threadinfo ffff81006b788000, task ffff81006b5c62c0)
Stack:  ffff81006b789dd4 ffff81006b789d88 ffff81007f79d750 ffff810066e6acc0
 0000000000000000 ffff810066f06730 ffff810066f06730 0000000000000000
 ffff81007efca580 ffffffff802f13ab ffff810066e6ace8 000000007ff98780
Call Trace:
 [<ffffffff802f13ab>] ext3_htree_fill_tree+0xab/0x1e0
 [<ffffffff802e8d69>] ext3_readdir+0x1a9/0x530
 [<ffffffff802359b3>] vfs_readdir+0x73/0xc0
 [<ffffffff802bea1f>] sys_getdents64+0x7f/0xd0
 [<ffffffff802607fe>] system_call+0x7e/0x83
 [<00002ae8c9dad41a>]


Code: 0f 0b 68 f0 0c 48 80 c2 80 01 48 8b 54 24 08 48 89 54 24 10
RIP  [<ffffffff802efe2b>] dx_probe+0x18b/0x320
 RSP <ffff81006b789d28>

Yeah, I know it's tainted - just wanted to hear if anyone saw this one before. 
System seems to be fine otherwise, I'll run a fsck on the filesystem lateron.

Jan

-- 
Common sense is instinct, and enough of it is genius.
		-- Josh Billings
