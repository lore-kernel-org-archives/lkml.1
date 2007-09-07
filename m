Return-Path: <linux-kernel-owner+w=401wt.eu-S1758486AbXIGT6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486AbXIGT6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 15:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758311AbXIGT6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 15:58:06 -0400
Received: from cg-p07-fb.rzone.de ([81.169.146.215]:49090 "EHLO
	cg-p07-fb.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbXIGT6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 15:58:04 -0400
Date: Fri, 7 Sep 2007 21:56:12 +0200
From: Alex Riesen <raa.lkml@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: crash while playing bzflag
Message-ID: <20070907195611.GA3259@steel.home>
Reply-To: Alex Riesen <raa.lkml@gmail.com>
Mail-Followup-To: Alex Riesen <raa.lkml@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-RZG-AUTH: z4gQVF2k5XWuW3CculzwpJKdLdI=
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel: v2.6.23-rc5+ (b21010ed6498391c0f359f2a89c907533fe07fec)
Ubuntu Feisty, Radeon R200 (9200) dual head, MergedFB, BZFlag in
OpenGL mode, frozen. That'll teach me playing games at home...

BUG: unable to handle kernel paging request at virtual address ffa85000
 printing eip:
c016eed1
*pde = 00005067
*pte = 00000000
Oops: 0000 [#1]
PREEMPT SMP 
Modules linked in: binfmt_misc nfs radeon drm nfsd exportfs lockd sunrpc fan firmware_class it87 hwmon_vid hwmon p4_clockmod speedstep_lib ipv6 sg sr_mod cdrom usb_storage snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device generic floppy snd ide_core intel_agp e100 uhci_hcd ehci_hcd soundcore snd_page_alloc agpgart evdev
CPU:    0
EIP:    0060:[__link_path_walk+2146/2867]    Not tainted VLI
EFLAGS: 00010287   (2.6.23-rc5-t #138)
EIP is at __link_path_walk+0x862/0xb33
eax: ffa85000   ebx: f0a4dd64   ecx: c0442130   edx: c1782d00
esi: eee51f30   edi: ffa85000   ebp: f0e49e40   esp: eee51de4
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process command-not-fou (pid: 2895, ti=eee51000 task=f08f1020 task.ti=eee51000)
Stack: f474c02c 00000101 f1db2d64 c016d3eb c1782d00 ffa85000 00000000 00000000 
       00000000 96ba5598 0000000b f474c021 c18eff00 f0e49e40 f08e1540 eee51f30 
       c1937c78 c18eff00 c016f1e6 f474c000 c1937c78 c18eff00 c180b180 f11a7600 
Call Trace:
 [do_lookup+79/323] do_lookup+0x4f/0x143
 [link_path_walk+68/179] link_path_walk+0x44/0xb3
 [_spin_unlock+5/28] _spin_unlock+0x5/0x1c
 [get_unused_fd_flags+198/208] get_unused_fd_flags+0xc6/0xd0
 [do_path_lookup+362/463] do_path_lookup+0x16a/0x1cf
 [__path_lookup_intent_open+69/117] __path_lookup_intent_open+0x45/0x75
 [path_lookup_open+32/37] path_lookup_open+0x20/0x25
 [open_namei+114/1364] open_namei+0x72/0x554
 [unmap_vmas+791/1240] unmap_vmas+0x317/0x4d8
 [do_filp_open+37/57] do_filp_open+0x25/0x39
 [_spin_unlock+5/28] _spin_unlock+0x5/0x1c
 [get_unused_fd_flags+198/208] get_unused_fd_flags+0xc6/0xd0
 [do_sys_open+68/192] do_sys_open+0x44/0xc0
 [sys_open+28/30] sys_open+0x1c/0x1e
 [sysenter_past_esp+95/133] sysenter_past_esp+0x5f/0x85
 [xfrm_bundle_ok+53/522] xfrm_bundle_ok+0x35/0x20a
 =======================
Code: f0 ff ff 0f 87 38 01 00 00 8b 46 1c 8b 44 86 20 89 44 24 14 31 ff 85 c0 0f 84 09 01 00 00 89 c7 3d 00 f0 ff ff 0f 87 f5 00 00 00 <80> 38 2f 0f 85 9f 00 00 00 89 f0 e8 38 e1 ff ff 64 a1 00 70 3f 
EIP: [__link_path_walk+2146/2867] __link_path_walk+0x862/0xb33 SS:ESP 0068:eee51de4
SysRq : Emergency Sync
Emergency Sync complete
SysRq : Emergency Sync
Emergency Sync complete

The config, lspci output, Xorg.0.log, and a more complete log of the
crash attached (the crash happened around Sep  7 21:24:27 in the log,
I panicked a bit and pressed Alt-SysRq-t and emergency sync).

