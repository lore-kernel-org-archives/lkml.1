Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbYITOxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbYITOxz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 10:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbYITOxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 10:53:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:63102 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYITOxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 10:53:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Kb83tAm3oQFBzlyBCkMoRTqSQepQfbDwWCJCse7i/FunrT3Qy+lLWfCHgsvvXisrpI
         rVYy4tmWrG4bKOsmboYiLLK1FYVJLmSBKCHBeBu3krNdwij3aCmQzFgWSv7pe7YrWlIQ
         /a+KBQoTCt5GliafjUXZkv9KtoNOWim1TWpxM=
Date: Sat, 20 Sep 2008 16:53:10 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: oops in find_get_page
Message-ID: <20080920145253.GA15982@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.6.27-rc6 + one patch (read below):

[15124.027313] general protection fault: 0000 [1] PREEMPT
[15124.027343] CPU 0
[15124.027358] Modules linked in: kqemu af_packet snd_pcm_oss snd_mixer_oss snd_seq_oss snd_seq_midi_event snd_seq tuner tea5767 tda8290 tuner_xc2028 xc5000 tda9887 tuner_simple tuner_types mt20xx tea5761 tda9875 uhci_hcd ehci_hcd usbcore bttv ir_common compat_ioctl32 videodev v4l1_compat snd_via82xx v4l2_common snd_ac97_codec ac97_bus snd_pcm videobuf_dma_sg snd_timer videobuf_core snd_page_alloc btcx_risc snd_mpu401_uart snd_rawmidi tveeprom snd_seq_device i2c_viapro snd soundcore
[15124.027616] Pid: 14760, comm: ld Not tainted 2.6.27-rc6-fasync #372
[15124.027623] RIP: 0010:[<ffffffff8026a7bf>]  [<ffffffff8026a7bf>] find_get_page+0x73/0xcc
[15124.027645] RSP: 0018:ffff8800088b3ce8  EFLAGS: 00010217
[15124.027652] RAX: 0287e887625ca707 RBX: 0287e887625ca708 RCX: 0000000000000000
[15124.027659] RDX: ffff88000000ff10 RSI: 00000000000007ee RDI: 0000000000000000
[15124.027666] RBP: ffff8800088b3d08 R08: 0000000000000000 R09: 0000000000000000
[15124.027673] R10: ffff8800088b3ed8 R11: 0000000000000001 R12: 00000000000007ee
[15124.027680] R13: ffff88003d193bb8 R14: 00000000000007ed R15: ffff88003d193bb8
[15124.027687] FS:  00002ba4d9462b00(0000) GS:ffffffff80623200(0000) knlGS:00000000f74e86d0
[15124.027694] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[15124.027701] CR2: 000000000354a2fc CR3: 000000003c8fc000 CR4: 00000000000006e0
[15124.027708] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15124.027715] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[15124.027723] Process ld (pid: 14760, threadinfo ffff8800088b2000, task ffff88002edb4100)
[15124.027729] Stack:  ffffffff8026a74c ffff88001811a210 ffff8800088b3de8 00000000000007ee
[15124.027768]  ffff8800088b3dd8 ffffffff8026c53c ffff88001811a188 0000000000000000
[15124.027795]  0000000000000000 ffff8800088b3e68 00000000200ea270 0000000000000000
[15124.027817] Call Trace:
[15124.027830]  [<ffffffff8026a74c>] ? find_get_page+0x0/0xcc
[15124.027840]  [<ffffffff8026c53c>] generic_file_aio_read+0x20e/0x5c0
[15124.027854]  [<ffffffff802914a2>] do_sync_read+0xe7/0x12b
[15124.027864]  [<ffffffff80241704>] ? autoremove_wake_function+0x0/0x3d
[15124.027874]  [<ffffffff802cb40c>] ? dnotify_parent+0x6f/0x77
[15124.027884]  [<ffffffff80494b9d>] ? sub_preempt_count+0xcc/0xe1
[15124.027892]  [<ffffffff80291c62>] vfs_read+0xb0/0x139
[15124.027900]  [<ffffffff80291f87>] sys_read+0x4c/0x75
[15124.027908]  [<ffffffff8020b54b>] system_call_fastpath+0x16/0x1b
[15124.027915]
[15124.027920]
[15124.027926] Code: 49 8d 7d 08 4c 89 e6 e8 6e 26 0d 00 48 85 c0 48 89 c2 74 29 48 8b 00 48 83 cb ff a8 01 48 0f 44 d8 48 8d 43 ff 48 83 f8 fd 77 d5 <ff> 43 08 48 3b 1a 74 0c 48 89 df e8 f4 82 00 00 eb c3 31 db 48
[15124.028009] RIP  [<ffffffff8026a7bf>] find_get_page+0x73/0xcc
[15124.028009]  RSP <ffff8800088b3ce8>
[15124.028561] ---[ end trace fc3c0b61df73f774 ]---
[15124.028569] note: ld[14760] exited with preempt_count 1
[15124.028586] BUG: scheduling while atomic: ld/14760/0x10000002
[15124.028593] INFO: lockdep is turned off.
[15124.028598] Modules linked in: kqemu af_packet snd_pcm_oss snd_mixer_oss snd_seq_oss snd_seq_midi_event snd_seq tuner tea5767 tda8290 tuner_xc2028 xc5000 tda9887 tuner_simple tuner_types mt20xx tea5761 tda9875 uhci_hcd ehci_hcd usbcore bttv ir_common compat_ioctl32 videodev v4l1_compat snd_via82xx v4l2_common snd_ac97_codec ac97_bus snd_pcm videobuf_dma_sg snd_timer videobuf_core snd_page_alloc btcx_risc snd_mpu401_uart snd_rawmidi tveeprom snd_seq_device i2c_viapro snd soundcore
[15124.028871] Pid: 14760, comm: ld Tainted: G      D   2.6.27-rc6-fasync #372
[15124.028878]
[15124.028879] Call Trace:
[15124.028891]  [<ffffffff8024c8da>] ? __debug_show_held_locks+0x1b/0x24
[15124.028900]  [<ffffffff80228f6c>] __schedule_bug+0x6b/0x70
[15124.028924]  [<ffffffff8048f302>] schedule+0x7b/0x41e
[15124.028932]  [<ffffffff80228f95>] __cond_resched+0x24/0x42
[15124.028940]  [<ffffffff8048f895>] _cond_resched+0x2d/0x38
[15124.028948]  [<ffffffff80278a4c>] unmap_vmas+0x5c1/0x733
[15124.028956]  [<ffffffff8027c5f5>] exit_mmap+0x69/0xfc
[15124.028964]  [<ffffffff8022bbfd>] mmput+0x45/0xbf
[15124.028972]  [<ffffffff8022f890>] exit_mm+0xe9/0xf4
[15124.028980]  [<ffffffff8025a800>] ? acct_collect+0x181/0x1a2
[15124.028987]  [<ffffffff80230dbf>] do_exit+0x203/0x7ac
[15124.028995]  [<ffffffff80492a37>] oops_begin+0x0/0x79
[15124.029028]  [<ffffffff8020cc19>] die+0x62/0x6b
[15124.029036]  [<ffffffff80493177>] do_general_protection+0x12d/0x135
[15124.029044]  [<ffffffff8049252d>] error_exit+0x0/0xa9
[15124.029052]  [<ffffffff8026a7bf>] ? find_get_page+0x73/0xcc
[15124.029059]  [<ffffffff8026a7a0>] ? find_get_page+0x54/0xcc
[15124.029067]  [<ffffffff8026a74c>] ? find_get_page+0x0/0xcc
[15124.029075]  [<ffffffff8026c53c>] generic_file_aio_read+0x20e/0x5c0
[15124.029083]  [<ffffffff802914a2>] do_sync_read+0xe7/0x12b
[15124.029091]  [<ffffffff80241704>] ? autoremove_wake_function+0x0/0x3d
[15124.029100]  [<ffffffff802cb40c>] ? dnotify_parent+0x6f/0x77
[15124.029123]  [<ffffffff80494b9d>] ? sub_preempt_count+0xcc/0xe1
[15124.029131]  [<ffffffff80291c62>] vfs_read+0xb0/0x139
[15124.029138]  [<ffffffff80291f87>] sys_read+0x4c/0x75
[15124.029145]  [<ffffffff8020b54b>] system_call_fastpath+0x16/0x1b
[15124.029152]


Decodecode:
/tmp/tmp.2j6qJyHbfM.o:     file format elf64-x86-64

Disassembly of section .text:

0000000000000000 <.text>:
   0:   49 8d 7d 08             lea    0x8(%r13),%rdi
   4:   4c 89 e6                mov    %r12,%rsi
   7:   e8 6e 26 0d 00          callq  0xd267a
   c:   48 85 c0                test   %rax,%rax
   f:   48 89 c2                mov    %rax,%rdx
  12:   74 29                   je     0x3d
  14:   48 8b 00                mov    (%rax),%rax
  17:   48 83 cb ff             or     $0xffffffffffffffff,%rbx
  1b:   a8 01                   test   $0x1,%al
  1d:   48 0f 44 d8             cmove  %rax,%rbx
  21:   48 8d 43 ff             lea    -0x1(%rbx),%rax
  25:   48 83 f8 fd             cmp    $0xfffffffffffffffd,%rax
  29:   77 d5                   ja     0x0

/tmp/tmp.2j6qJyHbfM.o:     file format elf64-x86-64

Disassembly of section .text:

0000000000000000 <.text>:
   0:   ff 43 08                incl   0x8(%rbx)
   3:   48 3b 1a                cmp    (%rdx),%rbx
   6:   74 0c                   je     0x14
   8:   48 89 df                mov    %rbx,%rdi
   b:   e8 f4 82 00 00          callq  0x8304
  10:   eb c3                   jmp    0xffffffffffffffd5
  12:   31 db                   xor    %ebx,%ebx
  14:   48                      rex.W

There are some factors which might have influenced system state:
- applied: http://lkml.org/lkml/2008/9/14/129
- suspend to ram
- kqemu loaded
- "Emergency Sync" 3 minutes before oops (I wanted to check whether qemu will handle it :)

You can find full dmesg and config at http://www.kadu.net/~joi/kernel/2008.09.20/

Marcin
