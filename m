Return-Path: <linux-kernel-owner+w=401wt.eu-S1751901AbYLUU1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbYLUU1p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 15:27:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbYLUU1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 15:27:36 -0500
Received: from 1wt.eu ([62.212.114.60]:1107 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbYLUU1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 15:27:35 -0500
Date: Sun, 21 Dec 2008 21:27:30 +0100
From: Willy Tarreau <w@1wt.eu>
To: Keith Chew <keith.chew@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: bug or hardware memory error?
Message-ID: <20081221202730.GB6800@1wt.eu>
References: <20f65d530812211205m1df7c210w873f25cd2a26ce8b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20f65d530812211205m1df7c210w873f25cd2a26ce8b@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 22, 2008 at 09:05:58AM +1300, Keith Chew wrote:
> Hi
> 
> I have been experiencing some occasional errors in bttv using kernel
> 2.6.20.1, we suspect could either be:
> - hardware memory problem
> - software memory problem
> - IRQ conflict with wireless WIFI driver (zd1211 module below)

well, it could be any. 2.6.20.1 is very old, even for the 2.6.20 branch.
A few hundreds of bugs have been fixed since. If you don't need to stick
to 2.6.20, you should try 2.6.27.10. If you need to stick to 2.6.20 for
whatever reason, please at least try with 2.6.20.21 (the latest 2.6.20
patch). Even with that, there's no guarantee that the present bug will
be fixed though.

> Can someone assist by looking at this stack trace:
> --------------------------------------------------------
> Dec 20 18:28:00 localhost kernel: BUG: unable to handle kernel paging
> request at virtual address fdedaf8f
> Dec 20 18:28:00 localhost kernel:  printing eip:
> Dec 20 18:28:00 localhost kernel: c044667a
> Dec 20 18:28:00 localhost kernel: *pde = 00000000
> Dec 20 18:28:00 localhost kernel: Oops: 0000 [#1]
> Dec 20 18:28:00 localhost kernel: Modules linked in: zd1211 i915 drm
> w83627hf hwmon_vid hwmon i2c_isa dm_multipath video dock button
> battery ac lp bt878 bttv video_buf ir_common compat_ioctl32
> i2c_algo_bit snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy
> btcx_risc snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_pcm_oss snd_mixer_oss tveeprom snd_pcm snd_timer snd soundcore
> ieee1394 videodev i2c_i801 pcspkr parport_pc e100 i2c_core
> snd_page_alloc v4l2_common parport mii v4l1_compat dm_snapshot dm_zero
> dm_mirror dm_mod ata_piix libata sd_mod scsi_mod ext3 jbd ehci_hcd
> ohci_hcd
> Dec 20 18:28:00 localhost kernel: CPU:    0
> Dec 20 18:28:00 localhost kernel: EIP:    0060:[<c044667a>]    Not tainted VLI
> Dec 20 18:28:00 localhost kernel: EFLAGS: 00010203   (2.6.20.1 #4)
> Dec 20 18:28:00 localhost kernel: EIP is at put_page+0x5/0x83
> Dec 20 18:28:00 localhost kernel: eax: fdedaf8f   ebx: fdedaf8f   ecx:
> f7fff5c0   edx: c163db40
> Dec 20 18:28:00 localhost kernel: esi: 00000002   edi: f7c63210   ebp:
> f8a7a1cc   esp: f7335c38
> Dec 20 18:28:00 localhost kernel: ds: 007b   es: 007b   ss: 0068
> Dec 20 18:28:00 localhost kernel: Process mencoder (pid: 2341,
> ti=f7334000 task=f6c1a430 task.ti=f7334000)
> Dec 20 18:28:00 localhost kernel: Stack: f1e2eba4 00000002 f7c63210
> f8a2633e 00200200 f7c63210 f1e2eba4 f1e2eba4
> Dec 20 18:28:00 localhost kernel:        f1e2eb80 f8a63c25 f7c63210
> 00000002 00000282 f8a7a1cc f8a258bd f7c63210
> Dec 20 18:28:00 localhost kernel:        00000000 f7c63200 f8a25949
> 00000002 f27f2140 f8a5f355 00000282 00000282
> Dec 20 18:28:00 localhost kernel: Call Trace:
> Dec 20 18:28:00 localhost kernel:  [<f8a2633e>]
> videobuf_dma_free+0x49/0x88 [video_buf]
> Dec 20 18:28:00 localhost kernel:  [<f8a63c25>] bttv_dma_free+0x3c/0x64 [bttv]
> Dec 20 18:28:00 localhost kernel:  [<f8a258bd>]
> videobuf_queue_cancel+0x61/0x7a [video_buf]
> Dec 20 18:28:00 localhost kernel:  [<f8a25949>]
> videobuf_streamoff+0x20/0x36 [video_buf]
> Dec 20 18:28:00 localhost kernel:  [<f8a5f355>]
> bttv_do_ioctl+0x1367/0x1b86 [bttv]
> Dec 20 18:28:00 localhost kernel:  [<f90198b5>]
> zd_ReceivePkt+0x1a5/0x420 [zd1211]
> Dec 20 18:28:00 localhost kernel:  [<c05678e3>] usb_hcd_submit_urb+0x7ce/0x873
> Dec 20 18:28:00 localhost kernel:  [<c0477717>] end_buffer_async_write+0xc7/0xe1
> Dec 20 18:28:00 localhost kernel:  [<c0415eb2>] enqueue_task+0x29/0x39
> Dec 20 18:28:00 localhost kernel:  [<c04161d8>] __activate_task+0x1c/0x29
> Dec 20 18:28:00 localhost kernel:  [<c0416b4a>] try_to_wake_up+0x11c/0x126
> Dec 20 18:28:00 localhost kernel:  [<c04158c0>] __wake_up_common+0x32/0x55
> Dec 20 18:28:00 localhost kernel:  [<c0457ab1>] free_block+0xbd/0xdc
> Dec 20 18:28:00 localhost kernel:  [<c045787d>] cache_flusharray+0x7a/0x9d
> Dec 20 18:28:00 localhost kernel:  [<c04cdb6e>] memmove+0xe/0x22
> Dec 20 18:28:00 localhost kernel:  [<c05fd7b9>] kprobe_flush_task+0x4b/0x80
> Dec 20 18:28:00 localhost kernel:  [<c05fa406>] __sched_text_start+0x54e/0x588
> Dec 20 18:28:00 localhost kernel:  [<c0419a37>] release_console_sem+0x181/0x1c0
> Dec 20 18:28:00 localhost kernel:  [<c05fa9ed>] schedule_timeout+0x13/0x97
> Dec 20 18:28:00 localhost kernel:  [<c042cfb3>] unqueue_me+0x75/0x7d
> Dec 20 18:28:00 localhost kernel:  [<f89ae785>]
> video_usercopy+0x172/0x237 [videodev]
> Dec 20 18:28:00 localhost kernel:  [<c0440ae7>] find_get_page+0x35/0x3a
> Dec 20 18:28:00 localhost kernel:  [<c0442ca1>] filemap_nopage+0x159/0x2c6
> Dec 20 18:28:00 localhost kernel:  [<c0416b54>] default_wake_function+0x0/0xc
> Dec 20 18:28:00 localhost kernel:  [<f8a5bfa7>] bttv_ioctl+0x42/0x47 [bttv]
> Dec 20 18:28:00 localhost kernel:  [<f8a5dfee>] bttv_do_ioctl+0x0/0x1b86 [bttv]
> Dec 20 18:28:00 localhost kernel:  [<f8a5bf65>] bttv_ioctl+0x0/0x47 [bttv]
> Dec 20 18:28:00 localhost kernel:  [<c0464ef2>] do_ioctl+0x3e/0x4d
> Dec 20 18:28:00 localhost kernel:  [<c0465100>] vfs_ioctl+0x1ff/0x216
> Dec 20 18:28:00 localhost kernel:  [<c0465163>] sys_ioctl+0x4c/0x65
> Dec 20 18:28:00 localhost kernel:  [<c0403bda>] sysenter_past_esp+0x5f/0x85
> Dec 20 18:28:00 localhost kernel:  =======================
> Dec 20 18:28:00 localhost kernel: Code: 97 e8 00 00 00 89 d8 e8 42 8a
> 08 00 ff 87 00 01 00 00 ff 05 60 c6 77 c0 8d 87 d8 00 00 00 5b 5e 5f
> e9 53 52 1b 00 57 56 53 89 c3 <8b> 00 f6 c4 40 74 0a 89 d8 5b 5e 5f e9
> f1 fc ff ff ff 4b 04 0f
> Dec 20 18:28:00 localhost kernel: EIP: [<c044667a>] put_page+0x5/0x83
> SS:ESP 0068:f7335c38
> Dec 20 18:28:00 localhost kernel:  <3>BUG: sleeping function called
> from invalid context at kernel/rwsem.c:20
> Dec 20 18:28:00 localhost kernel: in_atomic():0, irqs_disabled():1
> Dec 20 18:28:00 localhost kernel:  [<c042be67>] down_read+0x12/0x1f
> Dec 20 18:28:00 localhost kernel:  [<c0436761>] acct_collect+0x38/0x13f
> Dec 20 18:28:00 localhost kernel:  [<c041bd32>] do_exit+0x1a6/0x704
> Dec 20 18:28:00 localhost kernel:  [<c041a064>] printk+0x1b/0x1f
> Dec 20 18:28:00 localhost kernel:  [<c0404f65>] die+0x1dd/0x202
> Dec 20 18:28:00 localhost kernel:  [<c05fcf00>] do_page_fault+0x3fe/0x4d1
> Dec 20 18:28:00 localhost kernel:  [<c05fcb02>] do_page_fault+0x0/0x4d1
> Dec 20 18:28:00 localhost kernel:  [<c05fb984>] error_code+0x74/0x7c
> Dec 20 18:28:00 localhost kernel:  [<c044667a>] put_page+0x5/0x83
> Dec 20 18:28:00 localhost kernel:  [<f8a2633e>]
> videobuf_dma_free+0x49/0x88 [video_buf]
> Dec 20 18:28:00 localhost kernel:  [<f8a63c25>] bttv_dma_free+0x3c/0x64 [bttv]
> Dec 20 18:28:00 localhost kernel:  [<f8a258bd>]
> videobuf_queue_cancel+0x61/0x7a [video_buf]
> Dec 20 18:28:00 localhost kernel:  [<f8a25949>]
> videobuf_streamoff+0x20/0x36 [video_buf]
> Dec 20 18:28:00 localhost kernel:  [<f8a5f355>]
> bttv_do_ioctl+0x1367/0x1b86 [bttv]
> Dec 20 18:28:00 localhost kernel:  [<f90198b5>]
> zd_ReceivePkt+0x1a5/0x420 [zd1211]
> Dec 20 18:28:00 localhost kernel:  [<c05678e3>] usb_hcd_submit_urb+0x7ce/0x873
> Dec 20 18:28:00 localhost kernel:  [<c0477717>] end_buffer_async_write+0xc7/0xe1
> Dec 20 18:28:00 localhost kernel:  [<c0415eb2>] enqueue_task+0x29/0x39
> Dec 20 18:28:00 localhost kernel:  [<c04161d8>] __activate_task+0x1c/0x29
> Dec 20 18:28:00 localhost kernel:  [<c0416b4a>] try_to_wake_up+0x11c/0x126
> Dec 20 18:28:00 localhost kernel:  [<c04158c0>] __wake_up_common+0x32/0x55
> Dec 20 18:28:00 localhost kernel:  [<c0457ab1>] free_block+0xbd/0xdc
> Dec 20 18:28:00 localhost kernel:  [<c045787d>] cache_flusharray+0x7a/0x9d
> Dec 20 18:28:00 localhost kernel:  [<c04cdb6e>] memmove+0xe/0x22
> Dec 20 18:28:00 localhost kernel:  [<c05fd7b9>] kprobe_flush_task+0x4b/0x80
> Dec 20 18:28:00 localhost kernel:  [<c05fa406>] __sched_text_start+0x54e/0x588
> Dec 20 18:28:00 localhost kernel:  [<c0419a37>] release_console_sem+0x181/0x1c0
> Dec 20 18:28:00 localhost kernel:  [<c05fa9ed>] schedule_timeout+0x13/0x97
> Dec 20 18:28:00 localhost kernel:  [<c042cfb3>] unqueue_me+0x75/0x7d
> Dec 20 18:28:00 localhost kernel:  [<f89ae785>]
> video_usercopy+0x172/0x237 [videodev]
> Dec 20 18:28:00 localhost kernel:  [<c0440ae7>] find_get_page+0x35/0x3a
> Dec 20 18:28:00 localhost kernel:  [<c0442ca1>] filemap_nopage+0x159/0x2c6
> Dec 20 18:28:00 localhost kernel:  [<c0416b54>] default_wake_function+0x0/0xc
> Dec 20 18:28:00 localhost kernel:  [<f8a5bfa7>] bttv_ioctl+0x42/0x47 [bttv]
> Dec 20 18:28:00 localhost kernel:  [<f8a5dfee>] bttv_do_ioctl+0x0/0x1b86 [bttv]
> Dec 20 18:28:00 localhost kernel:  [<f8a5bf65>] bttv_ioctl+0x0/0x47 [bttv]
> Dec 20 18:28:00 localhost kernel:  [<c0464ef2>] do_ioctl+0x3e/0x4d
> Dec 20 18:28:00 localhost kernel:  [<c0465100>] vfs_ioctl+0x1ff/0x216
> Dec 20 18:28:01 localhost kernel:  [<c0465163>] sys_ioctl+0x4c/0x65
> Dec 20 18:28:01 localhost kernel:  [<c0403bda>] sysenter_past_esp+0x5f/0x85
> Dec 20 18:28:01 localhost kernel:  =======================
> --------------------------------------------------------
> 
> Quite often, we see this in the logs, but the above is the first stack
> trace that we manage to capture:
> --------------------------------------------------------
> Dec 20 18:25:48 localhost kernel: bttv3: IRQ lockup, cleared int mask
> [bits: FMTCHG* VSYNC* HSYNC* OFLOW* HLOCK* VPRES* 6* 7* I2CDONE*
> GPINT* 10* RISCI* FBUS* FTRGT* FDSR* PPERR* RIPERR* PABORT* OCERR*
> SCERR*]
> Dec 20 18:25:48 localhost kernel: bttv3: SCERROCERR @ 36df303c,bits:
> FMTCHG* VSYNC* HSYNC* OFLOW* HLOCK* VPRES* 6* 7* I2CDONE* GPINT* 10*
> RISCI* FBUS* FTRGT* FDSR* PPERR* RIPERR* PABORT* OCERR* SCERR*
> Dec 20 18:25:48 localhost kernel: bttv3: IRQ lockup, cleared int mask
> [bits: FMTCHG* VSYNC* HSYNC* OFLOW* HLOCK* VPRES* 6* 7* I2CDONE*
> GPINT* 10* RISCI* FBUS* FTRGT* FDSR* PPERR* RIPERR* PABORT* OCERR*
> SCERR*]
> Dec 20 18:25:48 localhost kernel: bttv3: IRQ lockup, cleared int mask
> [bits: HSYNC* OFLOW*]
> Dec 20 18:25:48 localhost kernel: bttv3: timeout: drop=0
> irq=2177037/2571854, risc=36df301c, bits: VSYNC HSYNC OFLOW RISCI
> Dec 20 18:25:48 localhost kernel: bttv3: reset, reinitialize
> Dec 20 18:25:48 localhost kernel: bttv3: PLL: 28636363 => 35468950 . ok
> --------------------------------------------------------
> 
> Regards
> Keith

Willy

