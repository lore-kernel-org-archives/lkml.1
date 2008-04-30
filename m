Return-Path: <linux-kernel-owner+w=401wt.eu-S1760704AbYD3JUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704AbYD3JUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 05:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757028AbYD3JUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 05:20:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:46256 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750991AbYD3JUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 05:20:36 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+D/ZsP9E+DLUUbVo6oFNuZUQ9GV4+a1swa4GVXZK
	jLXGodeQSBoOYk
Subject: Re: [patch, -git] drivers/media build fix for modular builds
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, mchehab@infradead.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
       Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <1209545784.31419.2.camel@marge.simson.net>
References: <20080429185009.716c3284@gaivota>
	 <20080430074807.GA11224@elte.hu>
	 <20080430.005212.46815036.davem@davemloft.net>
	 <20080430081345.GA16519@elte.hu>
	 <1209544030.30990.2.camel@marge.simson.net>
	 <1209544951.15609.3.camel@marge.simson.net>
	 <1209545784.31419.2.camel@marge.simson.net>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 11:20:31 +0200
Message-Id: <1209547231.4898.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-30 at 10:56 +0200, Mike Galbraith wrote:

> > > Kernel: arch/x86/boot/bzImage is ready  (#3)
> > > ERROR: "tea5761_attach" [drivers/media/video/tuner.ko] undefined!
> > > ERROR: "tea5761_autodetection" [drivers/media/video/tuner.ko] undefined!
> > > ERROR: "microtune_attach" [drivers/media/video/tuner.ko] undefined!
> > > ERROR: "simple_tuner_attach" [drivers/media/video/tuner.ko] undefined!
> > > ERROR: "tda9887_attach" [drivers/media/video/tuner.ko] undefined!
> > > ERROR: "tea5767_autodetection" [drivers/media/video/tuner.ko] undefined!
> > > ERROR: "xc5000_attach" [drivers/media/video/tuner.ko] undefined!
> > > ERROR: "xc2028_attach" [drivers/media/video/tuner.ko] undefined!
> > > ERROR: "tda829x_probe" [drivers/media/video/tuner.ko] undefined!
> > > ERROR: "tda829x_attach" [drivers/media/video/tuner.ko] undefined!
> > > ERROR: "tea5767_attach" [drivers/media/video/tuner.ko] undefined!
> > > ERROR: "xc2028_attach" [drivers/media/video/saa7134/saa7134-dvb.ko] undefined!
> > > ERROR: "simple_tuner_attach" [drivers/media/video/saa7134/saa7134-dvb.ko] undefined!
> > > ERROR: "tda827x_attach" [drivers/media/video/saa7134/saa7134-dvb.ko] undefined!
> > 
> > Hm, so I thought.  Error is constant.  Going back to .yesterday.
> 
> Turning CONFIG_MEDIA_ATTACH on fixed it.  I must have switched it somehow before.

With modular build patch and CONFIG_MEDIA_ATTACH, she builds, but BUG()s

[   15.437741] Linux video capture interface: v2.00
[   15.807047] saa7130/34: v4l2 driver version 0.2.14 loaded
[   15.817083] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[   15.828480] saa7133[0]: found at 0000:02:00.0, rev: 209, irq: 16, latency: 84, mmio: 0xfddff000
[   15.841223] saa7133[0]: subsystem: 16be:000d, board: Medion Md8800 Quadro [card=96,autodetected]
[   15.854174] saa7133[0]: board init: gpio is 0
[   15.897026] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
[   15.908649] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   15.954989] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
[   16.026049] saa7133[0]: i2c eeprom 00: be 16 0d 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
[   16.038843] saa7133[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff 00 01 50 32 79 01 3c ca 50
[   16.051778] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 03 01 00 06 ff 00 29 02 51 96 2b
[   16.065076] saa7133[0]: i2c eeprom 30: a7 58 7a 1f 03 8e 84 5e da 7a 04 b3 05 87 b2 3c
[   16.078816] saa7133[0]: i2c eeprom 40: ff 28 00 c0 96 10 03 00 c0 1c fd 79 44 9f c2 8f
[   16.092851] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   16.107096] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   16.121254] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   16.135583] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   16.149827] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   16.163636] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   16.177386] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   16.190724] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   16.203395] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   16.215396] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   16.226733] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   16.283864] TUNER: Unable to find symbol tda829x_probe()
[   16.292221] ------------[ cut here ]------------
[   16.299803] kernel BUG at kernel/module.c:784!
[   16.307170] invalid opcode: 0000 [1] SMP 
[   16.314110] CPU 3 
[   16.318911] Modules linked in: tuner(+) snd_hda_intel(+) saa7134(+) compat_ioctl32 firewire_ohci videodev snd_pcm firewire_core v4l1_compat v4l2_common snd_timer videobuf_dma_sg videobuf_core crc_itu_t snd_page_alloc snd_hwdep ir_kbd_i2c ohci1394 snd ir_common usb_storage rtc_cmos ieee1394 tveeprom rtc_core i2c_i801 button sr_mod intel_agp serio_raw e1000e iTCO_wdt i2c_core iTCO_vendor_support rtc_lib cdrom sg soundcore usbhid hid ff_memless ehci_hcd uhci_hcd sd_mod usbcore edd ext3 mbcache jbd fan ahci libata scsi_mod dock thermal processor
[   16.386303] Pid: 2239, comm: modprobe Not tainted 2.6.26-smp #1
[   16.395339] RIP: 0010:[<ffffffff80254714>]  [<ffffffff80254714>] __symbol_put+0x22/0x31
[   16.406519] RSP: 0000:ffff8100be941bf8  EFLAGS: 00010202
[   16.414959] RAX: fffffffffffffffe RBX: 00000000ffffffea RCX: 0000000000000001
[   16.425228] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffa02d881c
[   16.435431] RBP: ffff8100be941c08 R08: 0000000000000000 R09: 0000000000000000
[   16.445677] R10: ffff8100be9419a8 R11: 0000000000000000 R12: ffff8100bf0c0800
[   16.455893] R13: ffffffffa02dae80 R14: ffff8100bf0c0c00 R15: ffffffffa02db4c0
[   16.460556] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0010dc000152c873]
[   16.476190] FS:  00007f3ed02db6f0(0000) GS:ffff8100bf806980(0000) knlGS:0000000000000000
[   16.487494] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   16.496539] CR2: 00007f7316720000 CR3: 00000000bdde2000 CR4: 00000000000006e0
[   16.507132] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   16.517755] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   16.528427] Process modprobe (pid: 2239, threadinfo ffff8100be940000, task ffff8100be94ac40)
[   16.540498] Stack:  ffffffffa000b4c0 ffffffffa000b4c0 ffff8100be941c68 ffffffffa02d6a7c
[   16.552429]  0000000000000000 ffffffffa0138ba6 ffff8100be941cb4 ffffffffa02d678d
[   16.563921]  ffff8100be941c48 ffff8100bf0c0c00 000000000000004b ffffffffa02dae80
[   16.571370] Call Trace:
[   16.582036]  [<ffffffffa02d6a7c>] :tuner:tuner_probe+0x272/0x517
[   16.592342]  [<ffffffffa0138ba6>] ? :i2c_core:__i2c_check_addr+0x0/0x31
[   16.603233]  [<ffffffffa02d678d>] ? :tuner:v4l2_i2c_drv_attach_legacy+0x0/0x20
[   16.614711]  [<ffffffffa0202362>] :v4l2_common:v4l2_i2c_attach+0x65/0x96
[   16.625682]  [<ffffffffa02d680a>] ? :tuner:tuner_probe+0x0/0x517
[   16.635958]  [<ffffffffa02d678d>] ? :tuner:v4l2_i2c_drv_attach_legacy+0x0/0x20
[   16.647515]  [<ffffffffa02d67ab>] :tuner:v4l2_i2c_drv_attach_legacy+0x1e/0x20
[   16.658925]  [<ffffffffa0137b6c>] :i2c_core:i2c_probe_address+0xbe/0x105
[   16.669767]  [<ffffffffa0137d0f>] :i2c_core:i2c_probe+0x15c/0x16f
[   16.679843]  [<ffffffffa02d678d>] ? :tuner:v4l2_i2c_drv_attach_legacy+0x0/0x20
[   16.690998]  [<ffffffffa02d6784>] :tuner:v4l2_i2c_drv_probe_legacy+0x3f/0x48
[   16.701787]  [<ffffffffa013841b>] :i2c_core:i2c_register_driver+0xa4/0xef
[   16.712292]  [<ffffffffa02d67c0>] :tuner:i2c_add_driver+0x13/0x15
[   16.722085]  [<ffffffffa0176083>] :tuner:v4l2_i2c_drv_init+0x83/0xf2
[   16.732062]  [<ffffffff80256170>] sys_init_module+0x18be/0x19f4
[   16.741580]  [<ffffffffa0137d6d>] ? :i2c_core:i2c_master_send+0x0/0x48
[   16.751632]  [<ffffffff80290142>] ? vfs_read+0xa8/0x102
[   16.760344]  [<ffffffff8020c18b>] system_call_after_swapgs+0x7b/0x80
[   16.770237] 
[   16.775238] 
[   16.780136] Code: 00 00 e8 e5 80 fd ff c9 c3 55 b9 01 00 00 00 48 89 e5 48 83 ec 10 48 8d 55 f0 48 8d 75 f8 e8 37 f1 ff ff 48 3d 00 f0 ff ff 76 04 <0f> 0b eb fe 48 8b 7d f8 e8 9f ff ff ff c9 c3 55 48 89 e5 41 56 
[   16.810941] RIP  [<ffffffff80254714>] __symbol_put+0x22/0x31
[   16.820190]  RSP <ffff8100be941bf8>
[   16.827218] ---[ end trace a7ad785569c3ce7b ]---
[   16.847695] saa7133[0]: registered device video0 [v4l2]
[   16.856523] saa7133[0]: registered device vbi0
[   17.346021] DVB: Unable to find symbol tda827x_attach()
[   17.354672] saa7133[0]/dvb: no tda827x tuner found at addr: 60
[   17.363917] DVB: registering new adapter (saa7133[0])
[   17.372277] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
[   17.457008] tda1004x: setting up plls for 48MHz sampling clock
[   19.466337] tda1004x: found firmware revision 26 -- ok


