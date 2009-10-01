Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbZJAG5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbZJAG5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 02:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755534AbZJAG5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 02:57:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754396AbZJAG5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 02:57:19 -0400
Date: Wed, 30 Sep 2009 23:57:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Santiago Garcia Mantinan <manty@manty.net>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: kernel BUG at drivers/ide/ide-disk.c:187 (2.6.31)
Message-Id: <20090930235709.43ff1255.akpm@linux-foundation.org>
In-Reply-To: <20090930110529.GA3676@dis.manty.net>
References: <20090930110529.GA3676@dis.manty.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-ide)

On Wed, 30 Sep 2009 13:05:29 +0200 Santiago Garcia Mantinan <manty@manty.net> wrote:

> Hi!
> 
> Right after I compiled my first 2.6.31 for my server I got a crash, machine
> stops at user level, network, keyboard, ... still work, seems to me that
> only disk access crashes. I know 2.6.31.1 is out but the changelog didn't
> seem to show anything related to this, I'll try to test it anyway just to be
> sure.
> 
> It took me a while to get the crash to happen again and get a photo of the
> screen which then I passed through gocr and then I corrected (sorry if there
> are any typos left). It seems that the bug tends to happen on weekends or
> so, as I had the machine working throughout the week without any problem and
> then it crashed again on the next weekend, but I haven't identified any
> special disk related jobs, other than the typical weekly jobs that the
> distro (Debian) runs, which didn't seem relevant to me.
> 
> Machine is a Pentium III and had previously been running 2.6.30.5 without
> any problem at all.
> 
> I don't know what else to add, so I leave here the trace I got, please don't
> hesitate to contact me if you need any other info.
>
> ------------[ cut here ]------------
> kernel BUG at drivers/ide/ide-disk.c:187!
> invalid opcode; 0000 [#1]
> last sysfs file: /sys/devices/pci0000:00/0000:00:0c.0/i2c-adapter/i2c-0/name
> Modules linked in: gl518sm fue smbfs zd1201 tuner tea5767 tda8290 tuner_xc2028
> snd_sbawe snd_opl3_lib snd_hwdep xc5000 tda9887 snd_sb16_dsp snd_sb_common tuner
> _simple snd_mpu401_uart tuner_types mt20xx tea5761 snd_rawmidi snd_seq_device tv
> audio snd_pcm snd_timer snd snd_page_alloc tda7432 msp3400 bttv ir_common i2c_al
> go_bit v4l2_common uhci_hcd ehci_hcd ohci_hcd videodev v4l1_compat videobuf_dma_
> sg videobuf_core btcx_risc tveeprom i2c_viapro i2c_core dl2k usbcore parport_pc
> via_agp parport agpgart
> 
> Pid: 77, comm: kblockd/0 Not tainted  (2.6.31 #1)
> EIP: 0060:[<c0205bca>] EFLAGS: 00010206 CPU: 0
> EIP is at ide_do_rw_disk+0x26/0x266
> EAX: ef8d5e00 EBX: 000c2d3f ECX: 000c2d3f EDX: c7911834
> ESI: ef9e3c00 EDI: 00000088 EBP: c7911834 ESP: ef90beb8
>  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> Process kblockd/0 (pid: 77, ti=ef90a000 task=ef8feec0 task.ti=ef90a000)
> Stack:
>  c019df97 c7911834 c791187c c01a5a42 ef8d5200 ef8d9f04 c7911834 ef8d9f04
> <0> efb090e8 ef8d5200 c01a5b09 00000000 c01ab97d c01fea56 4088c800 00000000
> <0> ef9e3c00 ef90bf78 c7911834 c01ff098 000004e2 ef90bf13 c02b2334 ef9e3c00
> Call Trace:
>  [<c019df97>] ? elv_rb_del+0x20/0x2e
>  [<c01a5a42>] ? cfq_remove_request+0xbf/0x162
>  [<c01a5b09>] ? cfq_dispatch_insert+0x24/0x32
>  [<c01ab97d>] ? __const_udelay+0x15/0x16
>  [<c01fea56>] ? __ide_wait_stat+0x81/0xb0
>  [<c01ff098>] ? ide_wait_stat+0x3f/0x6f
>  [<c02055e9>] ? ide_gd_do_request+0x7/0x9
>  [<c01fe7f2>] ? do_ide_request+0x316/0x488
>  [<c010f865>] ? dequeue_task+x90/0x9e
>  [<c029d777>] ? schedule+0x2ad/0x2d9
>  [<c019f63a>] ? __blk_run_queue+0x39/0x60
>  [<c0la4f97>] ? cfq_kick_queue+0x0/0xb
>  [<c01a4fa0>] ? cfq_kick_queue+0x9/0xb
>  [<c011dd82>] ? worker_thread+0xae/0x11c
>  [<c0120354>] ? autoremove_wake_function+0x0/0x2d
>  [<c011dcd4>] ? worker_thread+0x0/0x11c
>  [<c0120084>] ? kthread+0x6b/0x70
>  [<c0120019>] ? kthread+0x0/0x70
>  [<c0102d43>] ? kernel_thread_helper+0x7/0x10
> Code: 00 c3 31 c0 c3 55 57 56 89 c6 53 89 cb 83 ec 58 f6 46 2a 02 89 54 24 04 8b
>  40 20 74 04 0f 0b eb fe 8b 54 24 04 83 7a 28 01 74 04 <0f> 0b eb fe 8b 48 6c 85
>  c9 74 08 8b 54 24 04 89 f0 ff d1 8b 44
> EIP: [<c0205bca>] ide_do_rw_disk+0x26/0x266 SS:ESP 0068:ef90beb8
> ---[ end trace 76b3e81fa9e97b6f ]---

