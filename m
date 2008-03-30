Return-Path: <linux-kernel-owner+w=401wt.eu-S1751708AbYC3If7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbYC3If7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 04:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYC3Ift
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 04:35:49 -0400
Received: from mail-07.jhb.wbs.co.za ([196.2.97.4]:36970 "EHLO
	mail-07.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbYC3Ifr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 04:35:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AroEAFft7kfEAmHEZ2dsb2JhbACRQg8TFpYn
From: Bongani Hlope <bonganilinux@mweb.co.za>
To: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: v4l oops in 2.6.25-rc7
Date: Sun, 30 Mar 2008 10:35:41 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, mchehab@infradead.org
References: <20080327230430.GA28795@codemonkey.org.uk> <20080329204615.GA25345@codemonkey.org.uk>
In-Reply-To: <20080329204615.GA25345@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803301035.41328.bonganilinux@mweb.co.za>
X-Original-Subject: Re: v4l oops in 2.6.25-rc7
X-Scan-Signature: da8f769171e61a087399dd266ea5cbf4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 March 2008 22:46:15 Dave Jones wrote:
> On Thu, Mar 27, 2008 at 07:04:30PM -0400, Dave Jones wrote:
>  > Booted up with an ancient bt848 card present and got this..
>  >
>  >
>  > BUG: unable to handle kernel NULL pointer dereference at 000001e0
>  > IP: [<c0500ba2>] strlen+0xb/0x15
>  > *pde = 02e0d067 *pte = 00000000
>  > Oops: 0000 [#1] SMP
>  > Modules linked in: sha256_generic aes_generic cbc dm_crypt
>  > crypto_blkcipher dm_emc dm_round_robin dm_multipath dm_snapshot
>  > dm_mirror dm_zero dm_mod xfs jfs reiserfs lock_nolock gfs2 msdos linear
>  > raid10 raid456 async_xor async_memcpy async_tx xor raid1 raid0 sg sr_mod
>  > cdrom sd_mod ata_generic bttv videodev v4l1_compat ir_common
>  > compat_ioctl32 i2c_algo_bit v4l2_common videobuf_dma_sg videobuf_core
>  > btcx_risc tveeprom i2c_core e100 tulip ehci_hcd mii ata_piix pata_acpi
>  > ohci_hcd libata uhci_hcd iscsi_tcp libiscsi scsi_transport_iscsi
>  > scsi_mod ext2 ext3 jbd ext4dev jbd2 mbcache crc16 squashfs pcspkr edd
>  > floppy loop nfs lockd nfs_acl sunrpc vfat fat cramfs
>  >
>  > Pid: 1513, comm: hald-probe-vide Not tainted (2.6.25-0.161.rc7.fc9.i586
>  > #1) EIP: 0060:[<c0500ba2>] EFLAGS: 00010246 CPU: 0
>  > EIP is at strlen+0xb/0x15
>  > EAX: 00000000 EBX: 000001e0 ECX: ffffffff EDX: 000001e0
>  > ESI: 00000020 EDI: 000001e0 EBP: c2e8bdfc ESP: c2e8bdf8
>  >  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>  > Process hald-probe-vide (pid: 1513, ti=c2e8b000 task=c2dda000
>  > task.ti=c2e8b000) Stack: c2e8bf34 c2e8be14 c04ff683 c2e8bedc c2e8becc
>  > cf116a70 c2e8bf34 c2e8be24 d0a7d931 d0a7d903 c2fd1500 c2e8bea4 d0a4dfc1
>  > c2e8be40 80685600 c2fd1500 cd68e050 d0a9830c c2dda6c0 c2e8be4c c040a6e2
>  > c2e8be60 c2e8be64 c040a9b0 Call Trace:
>  >  [<c04ff683>] ? strlcpy+0x17/0x48
>  >  [<d0a7d931>] ? radio_querycap+0x2e/0x5b [bttv]
>  >  [<d0a7d903>] ? radio_querycap+0x0/0x5b [bttv]
>  >  [<d0a4dfc1>] ? __video_do_ioctl+0x494/0x295e [videodev]
>  >  [<c040a6e2>] ? sched_clock+0x8/0xb
>  >  [<c040a9b0>] ? native_sched_clock+0xb5/0xd1
>  >  [<d0a5063b>] ? video_ioctl2+0x1b0/0x24d [videodev]
>  >  [<c063bb4a>] ? __down_failed+0xa/0x10
>  >  [<c0495d96>] ? vfs_ioctl+0x4e/0x67
>  >  [<c0495fe8>] ? do_vfs_ioctl+0x239/0x24c
>  >  [<c04dbb8d>] ? selinux_file_ioctl+0xa8/0xab
>  >  [<c049603b>] ? sys_ioctl+0x40/0x5d
>  >  [<c0405d52>] ? syscall_call+0x7/0xb
>  >  =======================
>  > Code: 5d c3 55 89 e5 56 89 c6 89 d0 88 c4 ac 38 e0 74 09 84 c0 75 f7 be
>  > 01 00 00 00 89 f0 48 5e 5d c3 55 83 c9 ff 89 e5 57 89 c7 31 c0 <f2> ae
>  > f7 d1 49 89 c8 5f 5d c3 55 89 e5 57 31 ff 85 c9 74 0e 89 EIP:
>  > [<c0500ba2>] strlen+0xb/0x15 SS:ESP 0068:c2e8bdf8
>  > ---[ end trace fba34738c02be064 ]---
>
> I looked at this a bit closer.  The problem seems to be caused by an
> selinux denial.  The selinux policy is being updated to allow the action to
> succeed, but we shouldn't oops in the case that an action gets denied.
>
> 	Dave

I have a similar oops, but I don't have selinux

BUG: unable to handle kernel NULL pointer dereference at 0000000000000250
IP: [<ffffffff8030fe54>] strlcpy+0x11/0x36
PGD 68650067 PUD 7526f067 PMD 0
Oops: 0000 [1] PREEMPT SMP
CPU 1
Modules linked in: snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq 
binfmt_misc loop nls_cp437 vfat fat nls_iso8859_1 ntfs thermal processor fan 
container button pcspkr snd_pcm_oss snd_mixer_oss tuner snd_emu10k1 tea5767 
tda8290 tuner_xc2028 tda9887 tuner_simple snd_rawmidi mt20xx snd_ac97_codec 
tea5761 bttv ac97_bus snd_pcm ir_common snd_seq_device compat_ioctl32 
snd_timer firewire_ohci videodev snd_page_alloc uhci_hcd firewire_core 
ehci_hcd snd_util_mem v4l1_compat v4l2_common snd_hwdep usbcore crc_itu_t 
ide_cd_mod videobuf_dma_sg snd sr_mod ohci1394 videobuf_core btcx_risc 
emu10k1_gp ieee1394 cdrom i2c_viapro tg3 gameport soundcore sg tveeprom evdev
Pid: 4756, comm: v4l-info Tainted: G   M     2.6.25-rc5 #44
RIP: 0010:[<ffffffff8030fe54>]  [<ffffffff8030fe54>] strlcpy+0x11/0x36
RSP: 0018:ffff81006414fcb8  EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff81006414fdf8 RCX: ffffffffffffffff
RDX: 0000000000000020 RSI: 0000000000000250 RDI: 0000000000000250
RBP: ffff81006414fcb8 R08: ffff81006414fe08 R09: ffff81006414fdf8
R10: ffff81007d885788 R11: 0000000000000202 R12: ffff81007fbe7800
R13: 0000000080685600 R14: ffff81007e76d800 R15: ffffffff88165110
FS:  00007f00eb5666f0(0000) GS:ffff81007fb6adc0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000250 CR3: 000000007686f000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process v4l-info (pid: 4756, threadinfo ffff81006414e000, task 
ffff81007e8da180)
Stack:  ffff81006414fcd8 ffffffff88145d33 ffff81007d885788 ffff81006414fdf8
 ffff81006414fdb8 ffffffff88100e58 ffffffffc008561c ffff81006414fd28
 ffff81006414fd08 ffffffff88149b72 ffff81006414fd58 ffffffff88142ed2
Call Trace:
 [<ffffffff88145d33>] :bttv:radio_querycap+0x39/0x6b
 [<ffffffff88100e58>] :videodev:__video_do_ioctl+0x579/0x2e16
 [<ffffffff88149b72>] ? :bttv:bttv_call_i2c_clients+0x16/0x18
 [<ffffffff88142ed2>] ? :bttv:audio_mux+0x105/0x1b5
 [<ffffffff80260449>] ? filemap_fault+0x1fe/0x371
 [<ffffffff88103a95>] :videodev:video_ioctl2+0x1b8/0x259
 [<ffffffff8026d36b>] ? handle_mm_fault+0x341/0x69b
 [<ffffffff80291252>] vfs_ioctl+0x5e/0x77
 [<ffffffff802914b8>] do_vfs_ioctl+0x24d/0x262
 [<ffffffff8045d881>] ? do_page_fault+0x434/0x7aa
 [<ffffffff8029150f>] sys_ioctl+0x42/0x67
 [<ffffffff8020b32b>] system_call_after_swapgs+0x7b/0x80


Code: 4c 29 c2 48 39 d0 72 04 48 8d 4a ff fc 4c 89 cf 4c 01 c0 f3 a4 c6 07 00 
c9 c3 55 31 c0 48 83 c9 ff fc 49 89 f8 48 89 f7 48 89 e5 <f2> ae 48 85 d2 48 
f7 d1 48 8d 41 ff 74 15 48 39 d0 48 89 c1 72
RIP  [<ffffffff8030fe54>] strlcpy+0x11/0x36
 RSP <ffff81006414fcb8>
CR2: 0000000000000250
---[ end trace 7e58c9e343c88870 ]---


