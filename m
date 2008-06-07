Return-Path: <linux-kernel-owner+w=401wt.eu-S1763592AbYFGP5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763592AbYFGP5x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 11:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762874AbYFGP5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 11:57:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40740 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762831AbYFGP5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 11:57:01 -0400
Date: Sat, 7 Jun 2008 12:56:53 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Oops at dvb_core:dvb_frontend_detach+0xa/0x82
Message-ID: <20080607125653.4178926a@gaivota>
In-Reply-To: <1212851960.8419.3.camel@marge.simson.net>
References: <1212851960.8419.3.camel@marge.simson.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

I've just committed a fix for the OOPS it at V4L/DVB mercurial. Probably, there's
something else broken at firmware loading code. I'll work on it before sending
the fixes upstream.

Cheers,
Mauro.

On Sat, 07 Jun 2008 17:19:20 +0200
Mike Galbraith <efault@gmx.de> wrote:

> Greetings,
> 
> This morning, git.today tossed the non-repeatable oops below.
> 
> [   19.377557] BUG: unable to handle kernel NULL pointer dereference at 00000000000000b0
> [   19.380399] IP: [<ffffffffa02b59e3>] :dvb_core:dvb_frontend_detach+0xa/0x82
> [   19.380399] PGD bcde8067 PUD 37862067 PMD 0 
> [   19.380399] Oops: 0000 [1] SMP 
> [   19.380399] CPU 2 
> [   19.380399] Modules linked in: tda1004x saa7134_dvb(+) videobuf_dvb dvb_core tuner saa7134 snd_hda_intel snd_pcm compat_ioctl32 videodev snd_timer v4l1_compat v4l2_common snd_page_alloc firewire_ohci snd_hwdep videobuf_dma_sg firewire_core snd videobuf_core usbhid usb_storage ir_kbd_i2c rtc_cmos e1000e ir_common crc_itu_t rtc_core tveeprom sr_mod iTCO_wdt ohci1394 i2c_i801 rtc_lib serio_raw hid cdrom ieee1394 soundcore iTCO_vendor_support i2c_core button intel_agp ff_memless sg uhci_hcd ehci_hcd sd_mod usbcore edd ext3 mbcache jbd fan ahci libata scsi_mod dock thermal processor
> [   19.380399] Pid: 2207, comm: modprobe Not tainted 2.6.26-smp #264
> [   19.380399] RIP: 0010:[<ffffffffa02b59e3>]  [<ffffffffa02b59e3>] :dvb_core:dvb_frontend_detach+0xa/0x82
> [   19.380399] RSP: 0000:ffff8100be9fdcc8  EFLAGS: 00010282
> [   19.380399] RAX: 00000000ffffffea RBX: ffff8100be01c000 RCX: 0000000000000001
> [   19.380399] RDX: 00000000ffffffea RSI: 0000000000000000 RDI: 0000000000000000
> [   19.380399] RBP: ffff8100be9fdcd8 R08: 0000000000000000 R09: 0000000000000000
> [   19.380399] R10: ffff810000000000 R11: ffffffffa02d2b00 R12: 0000000000000000
> [   19.380399] R13: ffffffffa02ccf00 R14: ffff8100be01c170 R15: ffffc20010300850
> [   19.380399] FS:  00007f19de1b46f0(0000) GS:ffff8100bf806600(0000) knlGS:0000000000000000
> [   19.380399] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   19.380399] CR2: 00000000000000b0 CR3: 00000000be561000 CR4: 00000000000006e0
> [   19.380399] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   19.380399] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   19.380399] Process modprobe (pid: 2207, threadinfo ffff8100be9fc000, task ffff8100bd01ef60)
> [   19.380399] Stack:  ffff8100be01c000 ffff8100be01c000 ffff8100be9fdd58 ffffffffa02c99d3
> [   19.380399]  ffffc200000000d8 ffff8100be01c000 ffffc2001032c000 ffffc2001032c000
> [   19.380399]  ffff8100be9fdd48 0000000000000202 ffff8100bf8f9cc0 0000000000000055
> [   19.380399] Call Trace:
> [   19.380399]  [<ffffffffa02c99d3>] :saa7134_dvb:dvb_init+0x14a6/0x15f6
> [   19.380399]  [<ffffffffa0282efa>] :saa7134:mpeg_ops_attach+0x36/0x46
> [   19.380399]  [<ffffffffa028368a>] :saa7134:saa7134_ts_register+0x2a/0x73
> [   19.380399]  [<ffffffffa0151010>] :saa7134_dvb:dvb_register+0x10/0x12
> [   19.380399]  [<ffffffff802526b8>] sys_init_module+0x1962/0x1aa3
> [   19.380399]  [<ffffffff80239e29>] ? msleep+0x0/0x1e
> [   19.380399]  [<ffffffff8020bf4b>] system_call_after_swapgs+0x7b/0x80
> [   19.380399] 
> [   19.380399] 
> [   19.380399] Code: 89 e5 48 83 ec 20 48 39 f1 48 89 7d f0 48 89 75 f8 48 89 55 e0 48 89 4d e8 7c 02 89 c8 c9 29 f0 c3 55 48 89 e5 41 54 49 89 fc 53 <48> 8b 87 b0 00 00 00 48 85 c0 74 0f ff d0 49 8b bc 24 b0 00 00 
> [   19.380399] RIP  [<ffffffffa02b59e3>] :dvb_core:dvb_frontend_detach+0xa/0x82
> [   19.380399]  RSP <ffff8100be9fdcc8>
> [   19.380399] CR2: 00000000000000b0
> 
> 




Cheers,
Mauro
