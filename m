Return-Path: <linux-kernel-owner+w=401wt.eu-S1757975AbXGNOdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbXGNOdl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 10:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758797AbXGNOdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 10:33:23 -0400
Received: from [87.201.200.205] ([87.201.200.205]:45154 "EHLO HasBox.COM"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757975AbXGNOdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 10:33:22 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Jul 2007 10:33:21 EDT
Message-ID: <4698DB26.8040704@0Bits.COM>
Date: Sat, 14 Jul 2007 18:18:14 +0400
From: Mitch <Mitch@0bits.com>
User-Agent: Thunderbird 3.0a1pre (X11/2007071217)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ext3_ordered_writepage panic on shiny new 2.6.22
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Light load on my system and encoding a home video to the disk using 
mencoder and i get this...


BUG: unable to handle kernel NULL pointer dereference at virtual address 
00000004
  printing eip:
c01a478e
*pde = 00000000
Oops: 0000 [#1]
PREEMPT SMP
Modules linked in: nls_iso8859_1 nls_cp437 vfat fat vmnet(P) parport_pc 
parport vmblock(P) vmmon(P) nvidia(P) bridge iptable_filter appletalk 
psnap llc nfsd exportfs lockd sunrpc ftdi_sio usbserial uhci_hcd 
ehci_hcd ohci_hcd i2c_nforce2 ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_conntrack ip_tables x_tables forcedeth usblp 
snd_hda_intel snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device 
snd_pcm_oss snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd 
usb_storage it87 hwmon_vid i2c_isa i2c_dev i2c_core
CPU:    1
EIP:    0060:[<c01a478e>]    Tainted: P       VLI
EFLAGS: 00010246   (2.6.22 #2)
EIP is at walk_page_buffers+0x4e/0x90
eax: 00000001   ebx: 00000000   ecx: 00000000   edx: 00000001
esi: 00000000   edi: 00000000   ebp: c8607a7c   esp: cbaabdf8
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process pdflush (pid: 2566, ti=cbaaa000 task=d49cb030 task.ti=cbaaa000)
Stack: 00000000 d16343d8 00000000 c2092360 d16343d8 c8607a7c d16343d8 
c01a7861
        00001000 00000000 c01a47d0 cbaabebc 00000286 cbaabf6c c90ecd3c 
00000009
        cbaabf6c 00000000 c014b438 c2092360 c014b88f 00000000 0000000e 
c014b430
Call Trace:
  [<c01a7861>] ext3_ordered_writepage+0xe1/0x190
  [<c01a47d0>] bget_one+0x0/0x10
  [<c014b438>] __writepage+0x8/0x30
  [<c014b88f>] write_cache_pages+0x1ff/0x320
  [<c014b430>] __writepage+0x0/0x30
  [<c014b430>] __writepage+0x0/0x30
  [<c014b9d0>] generic_writepages+0x20/0x30
  [<c014ba29>] do_writepages+0x49/0x50
  [<c0180604>] __writeback_single_inode+0x94/0x3c0
  [<c0180cf2>] sync_sb_inodes+0x192/0x270
  [<c01811a5>] writeback_inodes+0x95/0xd0
  [<c014c009>] background_writeout+0x89/0xb0
  [<c014c470>] pdflush+0x0/0x1d0
  [<c014c56e>] pdflush+0xfe/0x1d0
  [<c014bf80>] background_writeout+0x0/0xb0
  [<c0131dd2>] kthread+0x42/0x70
  [<c0131d90>] kthread+0x0/0x70
  [<c0103673>] kernel_thread_helper+0x7/0x14
  =======================
Code: 24 85 d2 74 10 8b 01 a8 01 75 0a 8b 44 24 24 c7 00 01 00 00 00 31 
f6 39 fd 89 f9 0f 95 c2 85 db 0f 94 c0 08 c2 74 2e 03 5c 24 08 <8b> 79 
04 3b 1c 24 89 da 0f 96 c0 2b 54 24 08 3b 54 24 20 0f 93
EIP: [<c01a478e>] walk_page_buffers+0x4e/0x90 SS:ESP 0068:cbaabdf8

This is an AMD SMP system.

$ uname -a
Linux home 2.6.22 #2 SMP PREEMPT Fri Jul 13 17:56:35 GST 2007 i686 
unknown unknown GNU/Linux

