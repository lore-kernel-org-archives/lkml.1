Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbZAIS1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbZAIS1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 13:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbZAIS1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 13:27:02 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47456 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbZAIS1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 13:27:00 -0500
Date: Fri, 9 Jan 2009 19:26:53 +0100
From: Andi Kleen <andi@firstfloor.org>
To: linux-usb@vger.kernel.org, tiwai@suse.de, linux-kernel@vger.kernel.org
Subject: usb alsa oops in 2.6.28 in snd_mixer_oss_notify_handler
Message-ID: <20090109182653.GA12123@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just got this oops in ALSA with 2.6.28 when I pulled a usb 
sound device while something was writing to it.
It looks like it jumped to Nirvana through a bad function
pointer.

...
ALSA /home/lsrc/linux-2.6.28-test/sound/usb/usbaudio.c:873: cannot submit datapipe for urb 0, error -19: no device
ALSA /home/lsrc/linux-2.6.28-test/sound/usb/usbaudio.c:873: cannot submit datapipe for urb 0, error -19: no device
ALSA /home/lsrc/linux-2.6.28-test/sound/usb/usbaudio.c:873: cannot submit datapipe for urb 0, error -19: no device
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
BUG: unable to handle kernel paging request at ffffffffa023c0a7
IP: [<ffffffffa023c0a7>] 0xffffffffa023c0a7
PGD 203067 PUD 207063 PMD 11bd79067 PTE 0
Oops: 0010 [#1] SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:05:04.0/resource
CPU 1 
Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq snd_hda_intel sha256_generic autofs4 netconsole ipt_MASQUERADE iptable_nat nf_nat_sip nf_conntrack_sip nf_nat_ftp nf_nat_irc nf_nat ip6t_LOG ip6t_REJECT ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack_ftp nf_conntrack_irc nf_conntrack xt_tcpudp cbc ipt_LOG ipt_REJECT iptable_filter ip_tables x_tables binfmt_misc dm_crypt aes_x86_64 aes_generic eeprom lm85 hwmon_vid arc4 ecb i2c_i801 pl2303 zd1211rw usbserial mac80211 i2c_core cfg80211 snd_usb_audio snd_pcm sbp2 snd_timer snd_page_alloc snd_usb_lib snd_rawmidi snd_seq_device snd_hwdep snd [last unloaded: snd_hda_intel]
Pid: 11810, comm: mpg321 Not tainted 2.6.28-BASIL #13
RIP: 0010:[<ffffffffa023c0a7>]  [<ffffffffa023c0a7>] 0xffffffffa023c0a7
RSP: 0018:ffff880075cabd90  EFLAGS: 00010282
RAX: ffffffffa023c0a7 RBX: ffff880118806000 RCX: ffffffff807ba488
RDX: ffffe20003ee93b8 RSI: ffffe20003ee9390 RDI: ffff880118806230
RBP: ffff880118806230 R08: 0000000000000000 R09: 00000000ffffff8e
R10: 0000000000000202 R11: ffffffffa0052245 R12: 0000000000000007
R13: ffff88011c895368 R14: ffff88011a225410 R15: ffff8800cadf6000
FS:  00007f99a8c376f0(0000) GS:ffff88011f802b80(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffa023c0a7 CR3: 000000008edc5000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mpg321 (pid: 11810, threadinfo ffff880075caa000, task ffff88009dbbc2b0)
Stack:
 ffffffffa008fabc 0000000000000000 ffffffff8026b88d ffffe20001a41180
 00000001802727f8 0000000000000000 0000000000000000 0000000000000000
 ffffffff80286651 0000000300000000 ffff88011cc47618 0000000000000000
Call Trace:
 [<ffffffffa008fabc>] ? snd_mixer_oss_notify_handler+0x23c/0x26a [snd_mixer_oss]
 [<ffffffff8026b88d>] ? release_pages+0x130/0x142
 [<ffffffff80286651>] ? add_partial+0x11/0x55
 [<ffffffff8022aba0>] ? __wake_up+0x38/0x4e
 [<ffffffffa000065d>] ? snd_card_do_free+0x17/0xe4 [snd]
 [<ffffffffa000102e>] ? snd_card_file_remove+0xcb/0x103 [snd]
 [<ffffffffa00522bb>] ? snd_pcm_release+0x76/0x82 [snd_pcm]
 [<ffffffff8028c232>] ? __fput+0xd6/0x17f
 [<ffffffff802762c1>] ? remove_vma+0x3d/0x61
 [<ffffffff80276df9>] ? do_munmap+0x2a4/0x2c6
 [<ffffffff80574431>] ? __down_write_nested+0x12/0xa5
 [<ffffffff80277f6b>] ? sys_munmap+0x40/0x5a
 [<ffffffff8020bdab>] ? system_call_fastpath+0x16/0x1b
Code:  Bad RIP value.
RIP  [<ffffffffa023c0a7>] 0xffffffffa023c0a7
 RSP <ffff880075cabd90>
CR2: ffffffffa023c0a7
---[ end trace a3c034a20c35a963 ]---

-Andi
-- 
ak@linux.intel.com
