Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbXJCFaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbXJCFaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 01:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbXJCFaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 01:30:09 -0400
Received: from [87.201.200.205] ([87.201.200.205]:59015 "EHLO HasBox.COM"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbXJCFaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 01:30:06 -0400
X-Greylist: delayed 1952 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Oct 2007 01:30:05 EDT
Message-ID: <47031D4C.7060807@0Bits.COM>
Date: Wed, 03 Oct 2007 08:40:44 +0400
From: Mitch <Mitch@0Bits.COM>
User-Agent: Thunderbird 3.0a1pre (X11/2007100119)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: More ext3 panics on 2.6.22 [Fwd: ext3_ordered_writepage panic on
 shiny new 2.6.22]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes i know my kernel is tainted with vmblock and nvidia, but i'm not 
convinced it is related. I'm putting the panics here if anyone interested.

Oct  2 20:08:39 home kernel: Assertion failure in journal_unmap_buffer() 
at fs/jbd/transaction.c:1886: "!buffer_jbddirty(bh)"
Oct  2 20:08:39 home kernel: ------------[ cut here ]------------
Oct  2 20:08:39 home kernel: kernel BUG at fs/jbd/transaction.c:1886!
Oct  2 20:08:39 home kernel: invalid opcode: 0000 [#1]
Oct  2 20:08:39 home kernel: PREEMPT SMP
Oct  2 20:08:39 home kernel: Modules linked in: iuu_phoenix cdc_acm 
nvidia(P) vmnet(P) parport_pc parport vmblock(P) vmmon(P) udf isofs 
nls_iso8859_1 nls_cp43
7 vfat fat appletalk psnap llc nfsd exportfs lockd sunrpc ftdi_sio 
usbserial uhci_hcd ohci_hcd i2c_nforce2 forcedeth usblp snd_hda_intel 
snd_seq_oss snd_seq_m
idi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer 
snd_page_alloc snd_mixer_oss snd usb_storage it87 hwmon_vid i2c_isa 
i2c_dev i2c_core
Oct  2 20:08:39 home kernel: CPU:    0
Oct  2 20:08:39 home kernel: EIP: 
0060:[journal_invalidatepage+505/1088]    Tainted: P       VLI
Oct  2 20:08:39 home kernel: EFLAGS: 00210296   (2.6.22 #3)
Oct  2 20:08:39 home kernel: EIP is at journal_invalidatepage+0x1f9/0x440
Oct  2 20:08:39 home kernel: eax: 00000064   ebx: d53fc770   ecx: 
c03e8a5c   edx: 00200002
Oct  2 20:08:39 home kernel: esi: 00006f72   edi: f6e14a00   ebp: 
d53fc770   esp: dfe63e4c
Oct  2 20:08:39 home kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033 
ss: 0068
Oct  2 20:08:39 home kernel: Process rm (pid: 3813, ti=dfe62000 
task=c672da90 task.ti=dfe62000)
Oct  2 20:08:39 home kernel: Stack: c03a44c4 c035850a c03a2ef0 0000075e 
c03a2ff3 f6e14adc f6e14a14 00000000
Oct  2 20:08:39 home kernel:        c2092360 00000000 00000001 00000000 
00000001 0000000a f1ac0964 c01a8b80
Oct  2 20:08:39 home kernel:        00006f72 0000000b ffffffff c014e116 
c2092360 c014e425 c2092360 c014e514
Oct  2 20:08:39 home kernel: Call Trace:
Oct  2 20:08:39 home kernel:  [ext3_invalidatepage+0/48] 
ext3_invalidatepage+0x0/0x30
Oct  2 20:08:39 home kernel:  [do_invalidatepage+22/32] 
do_invalidatepage+0x16/0x20
Oct  2 20:08:39 home kernel:  [truncate_complete_page+69/80] 
truncate_complete_page+0x45/0x50
Oct  2 20:08:39 home kernel:  [truncate_inode_pages_range+228/720] 
truncate_inode_pages_range+0xe4/0x2d0
Oct  2 20:08:39 home kernel:  [truncate_inode_pages+23/32] 
truncate_inode_pages+0x17/0x20
Oct  2 20:08:39 home kernel:  [ext3_delete_inode+19/208] 
ext3_delete_inode+0x13/0xd0
Oct  2 20:08:39 home kernel:  [ext3_delete_inode+0/208] 
ext3_delete_inode+0x0/0xd0
Oct  2 20:08:39 home kernel:  [generic_delete_inode+94/208] 
generic_delete_inode+0x5e/0xd0
Oct  2 20:08:39 home kernel:  [iput+92/112] iput+0x5c/0x70
Oct  2 20:08:39 home kernel:  [do_unlinkat+239/336] do_unlinkat+0xef/0x150
Oct  2 20:08:39 home kernel:  [irq_exit+91/144] irq_exit+0x5b/0x90
Oct  2 20:08:39 home kernel:  [smp_apic_timer_interrupt+87/144] 
smp_apic_timer_interrupt+0x57/0x90
Oct  2 20:08:39 home kernel:  [sysenter_past_esp+95/133] 
sysenter_past_esp+0x5f/0x85
Oct  2 20:08:39 home kernel:  =======================
Oct  2 20:08:39 home kernel: Code: 44 24 10 f3 2f 3a c0 c7 44 24 0c 5e 
07 00 00 c7 44 24 08 f0 2e 3a c0 c7 44 24 04 0a 85 35 c0 c7 04 24 c4 44 
3a c0 e8 b7 a9
f6 ff <0f> 0b eb fe 8b 74 24 1c 85 f6 0f 85 22 fe ff ff 8b 5c 24 28 85
Oct  2 20:08:39 home kernel: EIP: [journal_invalidatepage+505/1088] 
journal_invalidatepage+0x1f9/0x440 SS:ESP 0068:dfe63e4c

And later...


Oct  3 03:01:51 home kernel: BUG: unable to handle kernel NULL pointer 
dereference at virtual address 00000000
Oct  3 03:01:51 home kernel:  printing eip:
Oct  3 03:01:51 home kernel: c01bbbf0
Oct  3 03:01:51 home kernel: *pdpt = 00000000345fd001
Oct  3 03:01:51 home kernel: *pde = 0000000000000000
Oct  3 03:01:51 home kernel: Oops: 0002 [#2]
Oct  3 03:01:51 home kernel: PREEMPT SMP
Oct  3 03:01:51 home kernel: Modules linked in: iuu_phoenix cdc_acm 
nvidia(P) vmnet(P) parport_pc parport vmblock(P) vmmon(P) udf isofs 
nls_iso8859_1 nls_cp43
7 vfat fat appletalk psnap llc nfsd exportfs lockd sunrpc ftdi_sio 
usbserial uhci_hcd ohci_hcd i2c_nforce2 forcedeth usblp snd_hda_intel 
snd_seq_oss snd_seq_m
idi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer 
snd_page_alloc snd_mixer_oss snd usb_storage it87 hwmon_vid i2c_isa 
i2c_dev i2c_core
Oct  3 03:01:51 home kernel: CPU:    0
Oct  3 03:01:51 home kernel: EIP: 
0060:[journal_grab_journal_head+16/144]    Tainted: P       VLI
Oct  3 03:01:51 home kernel: EFLAGS: 00010202   (2.6.22 #3)
Oct  3 03:01:51 home kernel: EIP is at journal_grab_journal_head+0x10/0x90
Oct  3 03:01:51 home kernel: eax: f7c7e000   ebx: 00000000   ecx: 
f6f6c8dc   edx: c3492360
Oct  3 03:01:51 home kernel: esi: 00000000   edi: 00000000   ebp: 
d862a534   esp: f7c7fe48
Oct  3 03:01:51 home kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0000 
ss: 0068
Oct  3 03:01:51 home kernel: Process kswapd0 (pid: 202, ti=f7c7e000 
task=c3ba5030 task.ti=f7c7e000)
Oct  3 03:01:51 home kernel: Stack: 00000000 00000000 c01b6bec 00000246 
e622a7f0 00000001 cb7fe184 c3984de0
Oct  3 03:01:51 home kernel:        f6f6c8dc c3492360 c01a8bb0 00000000 
00010263 f7c7fea0 c0148cac c3492360
Oct  3 03:01:51 home kernel:        0000000c c014e7e8 0000000e ffffffff 
cb7fe184 0000395b 0000000e 00000000
Oct  3 03:01:51 home kernel: Call Trace:
Oct  3 03:01:51 home kernel:  [journal_try_to_free_buffers+108/432] 
journal_try_to_free_buffers+0x6c/0x1b0
Oct  3 03:01:51 home kernel:  [ext3_releasepage+0/160] 
ext3_releasepage+0x0/0xa0
Oct  3 03:01:51 home kernel:  [try_to_release_page+44/64] 
try_to_release_page+0x2c/0x40
Oct  3 03:01:51 home kernel:  [invalidate_mapping_pages+200/256] 
invalidate_mapping_pages+0xc8/0x100
Oct  3 03:01:51 home kernel:  [shrink_icache_memory+551/576] 
shrink_icache_memory+0x227/0x240
Oct  3 03:01:51 home kernel:  [shrink_slab+300/416] shrink_slab+0x12c/0x1a0
Oct  3 03:01:51 home kernel:  [kswapd+775/1168] kswapd+0x307/0x490
Oct  3 03:01:51 home kernel:  [autoremove_wake_function+0/80] 
autoremove_wake_function+0x0/0x50
Oct  3 03:01:51 home kernel:  [kswapd+0/1168] kswapd+0x0/0x490
Oct  3 03:01:51 home kernel:  [kthread+66/112] kthread+0x42/0x70
Oct  3 03:01:51 home kernel:  [kthread+0/112] kthread+0x0/0x70
Oct  3 03:01:51 home kernel:  [kernel_thread_helper+7/20] 
kernel_thread_helper+0x7/0x14
Oct  3 03:01:51 home kernel:  =======================
Oct  3 03:01:51 home kernel: Code: 24 08 8d 54 24 10 e8 c0 6e f7 ff e9 
40 ff ff ff 8d 74 26 00 8d bc 27 00 00 00 00 56 53 89 c3 89 e0 25 00 e0 
ff ff ff 40 14
89 f6 <f0> 0f ba 2b 16 19 c0 85 c0 74 28 8b 03 a9 00 00 40 00 74 ec 89
Oct  3 03:01:51 home kernel: EIP: [journal_grab_journal_head+16/144] 
journal_grab_journal_head+0x10/0x90 SS:ESP 0068:f7c7fe48

At this point , a hard hang.

-------- Original Message --------
Subject: ext3_ordered_writepage panic on shiny new 2.6.22
Date: Sat, 14 Jul 2007 18:18:14 +0400
From: Mitch <Mitch@0Bits.COM>
To: linux-kernel@vger.kernel.org

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



