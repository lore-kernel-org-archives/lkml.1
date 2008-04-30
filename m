Return-Path: <linux-kernel-owner+w=401wt.eu-S1760242AbYD3P1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242AbYD3P1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 11:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbYD3P1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 11:27:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58959 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbYD3P1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 11:27:04 -0400
Date: Wed, 30 Apr 2008 12:25:14 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch, -git] drivers/media build fix for modular builds
Message-ID: <20080430122514.2a52942d@gaivota>
In-Reply-To: <1209560592.5265.2.camel@marge.simson.net>
References: <20080429185009.716c3284@gaivota>
	<20080430074807.GA11224@elte.hu>
	<20080430.005212.46815036.davem@davemloft.net>
	<20080430081345.GA16519@elte.hu>
	<1209544030.30990.2.camel@marge.simson.net>
	<1209544951.15609.3.camel@marge.simson.net>
	<1209545784.31419.2.camel@marge.simson.net>
	<1209547231.4898.2.camel@marge.simson.net>
	<20080430044009.6c5bbc8d.akpm@linux-foundation.org>
	<1209560592.5265.2.camel@marge.simson.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Wed, 30 Apr 2008 15:03:12 +0200
Mike Galbraith <efault@gmx.de> wrote:

> 
> On Wed, 2008-04-30 at 04:40 -0700, Andrew Morton wrote:
> > On Wed, 30 Apr 2008 11:20:31 +0200 Mike Galbraith <efault@gmx.de> wrote:
> > 
> > > [   16.299803] kernel BUG at kernel/module.c:784!
> > > [   16.307170] invalid opcode: 0000 [1] SMP 
> > > [   16.314110] CPU 3 
> > > [   16.318911] Modules linked in: tuner(+) snd_hda_intel(+) saa7134(+) compat_ioctl32 firewire_ohci videodev snd_pcm firewire_core v4l1_compat v4l2_common snd_timer videobuf_dma_sg videobuf_core crc_itu_t snd_page_alloc snd_hwdep ir_kbd_i2c ohci1394 snd ir_common usb_storage rtc_cmos ieee1394 tveeprom rtc_core i2c_i801 button sr_mod intel_agp serio_raw e1000e iTCO_wdt i2c_core iTCO_vendor_support rtc_lib cdrom sg soundcore usbhid hid ff_memless ehci_hcd uhci_hcd sd_mod usbcore edd ext3 mbcache jbd fan ahci libata scsi_mod dock thermal processor
> > > [   16.386303] Pid: 2239, comm: modprobe Not tainted 2.6.26-smp #1
> > > [   16.395339] RIP: 0010:[<ffffffff80254714>]  [<ffffffff80254714>] __symbol_put+0x22/0x31
> > 
> > Does this make it feel better?
> 
> Well, it doesn't go BUG() any more, but it now goes oops.
> 
> [   13.443404] saa7133[0]: i2c eeprom 00: be 16 0d 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> [   13.456281] saa7133[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff 00 01 50 32 79 01 3c ca 50
> [   13.469575] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 03 01 00 06 ff 00 29 02 51 96 2b
> [   13.483794] saa7133[0]: i2c eeprom 30: a7 58 7a 1f 03 8e 84 5e da 7a 04 b3 05 87 b2 3c
> [   13.498518] saa7133[0]: i2c eeprom 40: ff 28 00 c0 96 10 03 00 c0 1c fd 79 44 9f c2 8f
> [   13.507664] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   13.507670] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   13.507676] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   13.507680] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   13.507684] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   13.507688] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   13.507692] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   13.507696] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   13.507700] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   13.507703] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   13.507707] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   13.666587] TUNER: Unable to find symbol tda829x_probe()
> [   13.674638] tuner' 1-004b: chip found @ 0x96 (saa7133[0])
> [   13.691175] DVB: Unable to find symbol tda9887_attach()
> [   13.698968] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> [   13.709509] IP: [<ffffffff80302934>] strlcpy+0x11/0x36
> [   13.711135] PGD be167067 PUD be140067 PMD 0 
> [   13.711137] Oops: 0000 [1] SMP 
> [   13.711139] CPU 2 
> [   13.711140] Modules linked in: tuner(+) snd_hda_intel(+) saa7134(+) compat_ioctl32 snd_pcm videodev firewire_ohci v4l1_compat firewire_core v4l2_common snd_timer videobuf_dma_sg videobuf_core crc_itu_t snd_page_alloc snd_hwdep ir_kbd_i2c rtc_cmos snd rtc_core ohci1394 ir_common usb_storage usbhid tveeprom ieee1394 sr_mod e1000e i2c_i801 rtc_lib cdrom i2c_core hid iTCO_wdt button intel_agp serio_raw ff_memless soundcore iTCO_vendor_support sg ehci_hcd uhci_hcd sd_mod usbcore edd ext3 mbcache jbd fan ahci libata scsi_mod dock thermal processor
> [   13.711158] Pid: 2175, comm: modprobe Not tainted 2.6.26-smp #3
> [   13.711160] RIP: 0010:[<ffffffff80302934>]  [<ffffffff80302934>] strlcpy+0x11/0x36
> [   13.711163] RSP: 0018:ffff8100bcc45b68  EFLAGS: 00010286
> [   13.711164] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffffffffffff
> [   13.711165] RDX: 0000000000000014 RSI: 0000000000000000 RDI: 0000000000000000
> [   13.711167] RBP: ffff8100bcc45b68 R08: ffff8100bf0b7404 R09: 0000000000000000
> [   13.711169] R10: ffff8100bcc45908 R11: ffff81003784ab70 R12: ffff8100bf0b6400
> [   13.711170] R13: ffff8100bf0b7400 R14: 000000000000004a R15: 000000000000000e
> [   13.711172] FS:  00007fcb8bad66f0(0000) GS:ffff8100bf806780(0000) knlGS:0000000000000000
> [   13.711174] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   13.711175] CR2: 0000000000000000 CR3: 00000000be142000 CR4: 00000000000006e0
> [   13.711177] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   13.711178] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   13.711180] Process modprobe (pid: 2175, threadinfo ffff8100bcc44000, task ffff8100bd112c40)
> [   13.711181] Stack:  ffff8100bcc45c08 ffffffffa02d43a3 0000000000000096 ffff8100bd486490
> [   13.711185]  0000000000000000 ffffffffa02d681c ffff8100bcc45bd8 ffffffff80253b08
> [   13.711187]  ffff8100bcc45bf8 ffff8100bf0b7400 ffff8100bf0b6400 ffffffffa02d8e80
> [   13.711190] Call Trace:
> [   13.711196]  [<ffffffffa02d43a3>] :tuner:set_type+0x682/0x9ed
> [   13.711201]  [<ffffffff80253b08>] ? __find_symbol+0x2c5/0x34b
> [   13.711213]  [<ffffffffa02d4cdb>] :tuner:tuner_probe+0x4d1/0x50f
> [   13.711220]  [<ffffffffa0135ba6>] ? :i2c_core:__i2c_check_addr+0x0/0x31
> [   13.711225]  [<ffffffffa02d478d>] ? :tuner:v4l2_i2c_drv_attach_legacy+0x0/0x20
> [   13.711234]  [<ffffffffa0200362>] :v4l2_common:v4l2_i2c_attach+0x65/0x96
> [   13.711237]  [<ffffffffa02d480a>] ? :tuner:tuner_probe+0x0/0x50f
> [   13.711243]  [<ffffffffa02d478d>] ? :tuner:v4l2_i2c_drv_attach_legacy+0x0/0x20
> [   13.711248]  [<ffffffffa02d47ab>] :tuner:v4l2_i2c_drv_attach_legacy+0x1e/0x20
> [   13.711255]  [<ffffffffa0134b6c>] :i2c_core:i2c_probe_address+0xbe/0x105
> [   13.711264]  [<ffffffffa0134d0f>] :i2c_core:i2c_probe+0x15c/0x16f
> [   13.711268]  [<ffffffffa02d478d>] ? :tuner:v4l2_i2c_drv_attach_legacy+0x0/0x20
> [   13.711275]  [<ffffffffa02d4784>] :tuner:v4l2_i2c_drv_probe_legacy+0x3f/0x48
> [   13.711284]  [<ffffffffa013541b>] :i2c_core:i2c_register_driver+0xa4/0xef
> [   13.711292]  [<ffffffffa02d47c0>] :tuner:i2c_add_driver+0x13/0x15
> [   13.711296]  [<ffffffffa01a9083>] :tuner:v4l2_i2c_drv_init+0x83/0xf2
> [   13.711300]  [<ffffffff80256170>] sys_init_module+0x18be/0x19f4
> [   13.711341]  [<ffffffffa0134d6d>] ? :i2c_core:i2c_master_send+0x0/0x48
> [   13.711351]  [<ffffffff80290142>] ? vfs_read+0xa8/0x102
> [   13.711368]  [<ffffffff8020c18b>] system_call_after_swapgs+0x7b/0x80
> [   13.711386] 
> [   13.711387] 
> [   13.711387] Code: 4c 29 c2 48 39 d0 72 04 48 8d 4a ff fc 4c 89 cf 4c 01 c0 f3 a4 c6 07 00 c9 c3 55 31 c0 48 83 c9 ff fc 49 89 f8 48 89 f7 48 89 e5 <f2> ae 48 85 d2 48 f7 d1 48 8d 41 ff 74 15 48 39 d0 48 89 c1 72 
> [   13.711400] RIP  [<ffffffff80302934>] strlcpy+0x11/0x36
> [   13.711402]  RSP <ffff8100bcc45b68>
> [   13.711403] CR2: 0000000000000000
> [   13.711408] ---[ end trace 482cc92db4db2b64 ]---
> [   13.729702] saa7133[0]: registered device video0 [v4l2]
> [   13.729719] saa7133[0]: registered device vbi0
> [   13.810238] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0010dc000152c873]
> [   14.766645] DVB: Unable to find symbol tda827x_attach()
> [   14.775058] saa7133[0]/dvb: no tda827x tuner found at addr: 60
> [   14.784121] DVB: registering new adapter (saa7133[0])
> [   14.792324] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
> [   14.882015] tda1004x: setting up plls for 48MHz sampling clock
> [   16.886159] tda1004x: found firmware revision 26 -- ok

There are two different issues here. The first one is not finding the symbol.
This is weird. Here, everything looks ok:

[ 3929.936478] Linux video capture interface: v2.00
[ 3929.948852] saa7130/34: v4l2 driver version 0.2.14 loaded
[ 3929.949245] saa7133[0]: found at 0000:06:00.0, rev: 209, irq: 20, latency: 64, mmio: 0x8c000000
[ 3929.949439] saa7133[0]: subsystem: 4e42:3502, board: LifeView FlyDVB-T Hybrid Cardbus/MSI TV @nywhere A/D NB [card=94,autodetected]
[ 3929.949673] saa7133[0]: board init: gpio is 10000
[ 3930.034191] saa7133[0]: i2c eeprom 00: 42 4e 02 35 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
[ 3930.034244] saa7133[0]: i2c eeprom 10: 00 00 62 08 ff 20 ff ff ff ff ff ff ff ff ff ff
[ 3930.034312] saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 ff 01 eb ff ff ff ff
[ 3930.034380] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 3930.034448] saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 05 01 01 16 32 15 ff ff ff ff
[ 3930.034517] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 3930.034584] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 3930.034653] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 3930.034721] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 3930.034788] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 3930.034857] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 3930.034926] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 3930.034995] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 3930.035063] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 3930.035133] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 3930.035202] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 3930.083461] tuner' 1-004b: tda829x detected
[ 3930.083470] tuner' 1-004b: Setting mode_mask to 0x0e
[ 3930.083475] tuner' 1-004b: chip found @ 0x96 (saa7133[0])
[ 3930.083482] tuner' 1-004b: tuner 0x4b: Tuner type absent
[ 3930.080597] tuner' 1-004b: TUNER_SET_TYPE_ADDR
[ 3930.080607] tuner' 1-004b: Calling set_type_addr for type=54, addr=0xff, mode=0x0e, config=0x00
[ 3930.080612] tuner' 1-004b: defining GPIO callback
[ 3930.115546] tda829x 1-004b: setting tuner address to 61
[ 3930.155513] tda829x 1-004b: type set to tda8290+75a
[ 3930.183856] tuner' 1-004b: type set to tda8290+75a
[ 3930.183860] tuner' 1-004b: tv freq set to 400.00
[ 3930.779947] tuner' 1-004b: saa7133[0] tuner' I2C addr 0x96 with type 54 used for 0x0e


The other one is that the error handling seems to be incomplete on both
tuner-core and saa7134-dvb.

Please try this patch. It should avoid an OOPS, if attach fails.

Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>

diff -r 341e0cd5c1a4 linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Wed Apr 30 11:40:17 2008 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Wed Apr 30 12:16:38 2008 -0300
@@ -541,19 +541,23 @@
 	return 0;
 }
 
-static void configure_tda827x_fe(struct saa7134_dev *dev, struct tda1004x_config *cdec_conf,
-							  struct tda827x_config *tuner_conf)
+static int configure_tda827x_fe(struct saa7134_dev *dev,
+				struct tda1004x_config *cdec_conf,
+				struct tda827x_config *tuner_conf)
 {
 	dev->dvb.frontend = dvb_attach(tda10046_attach, cdec_conf, &dev->i2c_adap);
 	if (dev->dvb.frontend) {
 		if (cdec_conf->i2c_gate)
 			dev->dvb.frontend->ops.i2c_gate_ctrl = tda8290_i2c_gate_ctrl;
-		if (dvb_attach(tda827x_attach, dev->dvb.frontend, cdec_conf->tuner_address,
-							&dev->i2c_adap, tuner_conf) == NULL) {
-			wprintk("no tda827x tuner found at addr: %02x\n",
+		if (dvb_attach(tda827x_attach, dev->dvb.frontend,
+			       cdec_conf->tuner_address,
+			       &dev->i2c_adap, tuner_conf))
+			return 0;
+
+		wprintk("no tda827x tuner found at addr: %02x\n",
 				cdec_conf->tuner_address);
-		}
 	}
+	return -EINVAL;
 }
 
 /* ------------------------------------------------------------------ */
@@ -1000,7 +1004,9 @@
 		break;
 	case SAA7134_BOARD_FLYDVBTDUO:
 	case SAA7134_BOARD_FLYDVBT_DUO_CARDBUS:
-		configure_tda827x_fe(dev, &tda827x_lifeview_config, &tda827x_cfg_0);
+		if (configure_tda827x_fe(dev, &tda827x_lifeview_config,
+					 &tda827x_cfg_0) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_PHILIPS_EUROPA:
 	case SAA7134_BOARD_VIDEOMATE_DVBT_300:
@@ -1025,36 +1031,52 @@
 		}
 		break;
 	case SAA7134_BOARD_KWORLD_DVBT_210:
-		configure_tda827x_fe(dev, &kworld_dvb_t_210_config, &tda827x_cfg_2);
+		if (configure_tda827x_fe(dev, &kworld_dvb_t_210_config,
+					 &tda827x_cfg_2) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_PHILIPS_TIGER:
-		configure_tda827x_fe(dev, &philips_tiger_config, &tda827x_cfg_0);
+		if (configure_tda827x_fe(dev, &philips_tiger_config,
+					 &tda827x_cfg_0) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_PINNACLE_PCTV_310i:
-		configure_tda827x_fe(dev, &pinnacle_pctv_310i_config, &tda827x_cfg_1);
+		if (configure_tda827x_fe(dev, &pinnacle_pctv_310i_config,
+					 &tda827x_cfg_1) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
-		configure_tda827x_fe(dev, &hauppauge_hvr_1110_config, &tda827x_cfg_1);
+		if (configure_tda827x_fe(dev, &hauppauge_hvr_1110_config,
+					 &tda827x_cfg_1) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_ASUSTeK_P7131_DUAL:
-		configure_tda827x_fe(dev, &asus_p7131_dual_config, &tda827x_cfg_0);
+		if (configure_tda827x_fe(dev, &asus_p7131_dual_config,
+					 &tda827x_cfg_0) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_FLYDVBT_LR301:
-		configure_tda827x_fe(dev, &tda827x_lifeview_config, &tda827x_cfg_0);
+		if (configure_tda827x_fe(dev, &tda827x_lifeview_config,
+					 &tda827x_cfg_0) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_FLYDVB_TRIO:
-		if(! use_frontend) {	/* terrestrial */
-			configure_tda827x_fe(dev, &lifeview_trio_config, &tda827x_cfg_0);
+		if (!use_frontend) {	/* terrestrial */
+			if (configure_tda827x_fe(dev, &lifeview_trio_config,
+						 &tda827x_cfg_0) < 0)
+				goto dettach_frontend;
 		} else {  		/* satellite */
 			dev->dvb.frontend = dvb_attach(tda10086_attach, &flydvbs, &dev->i2c_adap);
 			if (dev->dvb.frontend) {
 				if (dvb_attach(tda826x_attach, dev->dvb.frontend, 0x63,
 									&dev->i2c_adap, 0) == NULL) {
 					wprintk("%s: Lifeview Trio, No tda826x found!\n", __func__);
+					goto dettach_frontend;
 				}
 				if (dvb_attach(isl6421_attach, dev->dvb.frontend, &dev->i2c_adap,
 										0x08, 0, 0) == NULL) {
 					wprintk("%s: Lifeview Trio, No ISL6421 found!\n", __func__);
+					goto dettach_frontend;
 				}
 			}
 		}
@@ -1070,15 +1092,20 @@
 								&ads_duo_cfg) == NULL) {
 				wprintk("no tda827x tuner found at addr: %02x\n",
 					ads_tech_duo_config.tuner_address);
+				goto dettach_frontend;
 			}
 		}
 		break;
 	case SAA7134_BOARD_TEVION_DVBT_220RF:
-		configure_tda827x_fe(dev, &tevion_dvbt220rf_config, &tda827x_cfg_0);
+		if (configure_tda827x_fe(dev, &tevion_dvbt220rf_config,
+					 &tda827x_cfg_0) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_MEDION_MD8800_QUADRO:
 		if (!use_frontend) {     /* terrestrial */
-			configure_tda827x_fe(dev, &md8800_dvbt_config, &tda827x_cfg_0);
+			if (configure_tda827x_fe(dev, &md8800_dvbt_config,
+						 &tda827x_cfg_0) < 0)
+				goto dettach_frontend;
 		} else {        /* satellite */
 			dev->dvb.frontend = dvb_attach(tda10086_attach,
 							&flydvbs, &dev->i2c_adap);
@@ -1089,16 +1116,20 @@
 				struct i2c_msg msg = {.addr = 0x08, .flags = 0, .len = 1};
 
 				if (dvb_attach(tda826x_attach, dev->dvb.frontend,
-						0x60, &dev->i2c_adap, 0) == NULL)
+						0x60, &dev->i2c_adap, 0) == NULL) {
 					wprintk("%s: Medion Quadro, no tda826x "
 						"found !\n", __func__);
+					goto dettach_frontend;
+				}
 				if (dev_id != 0x08) {
 					/* we need to open the i2c gate (we know it exists) */
 					fe->ops.i2c_gate_ctrl(fe, 1);
 					if (dvb_attach(isl6405_attach, fe,
-							&dev->i2c_adap, 0x08, 0, 0) == NULL)
+							&dev->i2c_adap, 0x08, 0, 0) == NULL) {
 						wprintk("%s: Medion Quadro, no ISL6405 "
 							"found !\n", __func__);
+						goto dettach_frontend;
+					}
 					if (dev_id == 0x07) {
 						/* fire up the 2nd section of the LNB supply since
 						   we can't do this from the other section */
@@ -1120,19 +1151,17 @@
 	case SAA7134_BOARD_AVERMEDIA_AVERTVHD_A180:
 		dev->dvb.frontend = dvb_attach(nxt200x_attach, &avertvhda180,
 					       &dev->i2c_adap);
-		if (dev->dvb.frontend) {
+		if (dev->dvb.frontend)
 			dvb_attach(dvb_pll_attach, dev->dvb.frontend, 0x61,
 				   NULL, DVB_PLL_TDHU2);
-		}
 		break;
 	case SAA7134_BOARD_KWORLD_ATSC110:
 		dev->dvb.frontend = dvb_attach(nxt200x_attach, &kworldatsc110,
 					       &dev->i2c_adap);
-		if (dev->dvb.frontend) {
+		if (dev->dvb.frontend)
 			dvb_attach(simple_tuner_attach, dev->dvb.frontend,
 				   &dev->i2c_adap, 0x61,
 				   TUNER_PHILIPS_TUV1236D);
-		}
 		break;
 	case SAA7134_BOARD_FLYDVBS_LR300:
 		dev->dvb.frontend = dvb_attach(tda10086_attach, &flydvbs,
@@ -1141,10 +1170,12 @@
 			if (dvb_attach(tda826x_attach, dev->dvb.frontend, 0x60,
 				       &dev->i2c_adap, 0) == NULL) {
 				wprintk("%s: No tda826x found!\n", __func__);
+				goto dettach_frontend;
 			}
 			if (dvb_attach(isl6421_attach, dev->dvb.frontend,
 				       &dev->i2c_adap, 0x08, 0, 0) == NULL) {
 				wprintk("%s: No ISL6421 found!\n", __func__);
+				goto dettach_frontend;
 			}
 		}
 		break;
@@ -1171,43 +1202,65 @@
 		}
 		break;
 	case SAA7134_BOARD_CINERGY_HT_PCMCIA:
-		configure_tda827x_fe(dev, &cinergy_ht_config, &tda827x_cfg_0);
+		if (configure_tda827x_fe(dev, &cinergy_ht_config,
+					 &tda827x_cfg_0) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_CINERGY_HT_PCI:
-		configure_tda827x_fe(dev, &cinergy_ht_pci_config, &tda827x_cfg_0);
+		if (configure_tda827x_fe(dev, &cinergy_ht_pci_config,
+					 &tda827x_cfg_0) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_PHILIPS_TIGER_S:
-		configure_tda827x_fe(dev, &philips_tiger_s_config, &tda827x_cfg_2);
+		if (configure_tda827x_fe(dev, &philips_tiger_s_config,
+					 &tda827x_cfg_2) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_ASUS_P7131_4871:
-		configure_tda827x_fe(dev, &asus_p7131_4871_config, &tda827x_cfg_2);
+		if (configure_tda827x_fe(dev, &asus_p7131_4871_config,
+					 &tda827x_cfg_2) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
-		configure_tda827x_fe(dev, &asus_p7131_hybrid_lna_config, &tda827x_cfg_2);
+		if (configure_tda827x_fe(dev, &asus_p7131_hybrid_lna_config,
+					 &tda827x_cfg_2) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_SUPER_007:
-		configure_tda827x_fe(dev, &avermedia_super_007_config, &tda827x_cfg_0);
+		if (configure_tda827x_fe(dev, &avermedia_super_007_config,
+					 &tda827x_cfg_0) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_TWINHAN_DTV_DVB_3056:
-		configure_tda827x_fe(dev, &twinhan_dtv_dvb_3056_config, &tda827x_cfg_2_sw42);
+		if (configure_tda827x_fe(dev, &twinhan_dtv_dvb_3056_config,
+					 &tda827x_cfg_2_sw42) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_PHILIPS_SNAKE:
 		dev->dvb.frontend = dvb_attach(tda10086_attach, &flydvbs,
 						&dev->i2c_adap);
 		if (dev->dvb.frontend) {
 			if (dvb_attach(tda826x_attach, dev->dvb.frontend, 0x60,
-					&dev->i2c_adap, 0) == NULL)
+					&dev->i2c_adap, 0) == NULL) {
 				wprintk("%s: No tda826x found!\n", __func__);
+				goto dettach_frontend;
+			}
 			if (dvb_attach(lnbp21_attach, dev->dvb.frontend,
-					&dev->i2c_adap, 0, 0) == NULL)
+					&dev->i2c_adap, 0, 0) == NULL) {
 				wprintk("%s: No lnbp21 found!\n", __func__);
+				goto dettach_frontend;
+			}
 		}
 		break;
 	case SAA7134_BOARD_CREATIX_CTX953:
-		configure_tda827x_fe(dev, &md8800_dvbt_config, &tda827x_cfg_0);
+		if (configure_tda827x_fe(dev, &md8800_dvbt_config,
+					 &tda827x_cfg_0) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_MSI_TVANYWHERE_AD11:
-		configure_tda827x_fe(dev, &philips_tiger_s_config, &tda827x_cfg_2);
+		if (configure_tda827x_fe(dev, &philips_tiger_s_config,
+					 &tda827x_cfg_2) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
 #if 0
@@ -1225,16 +1278,20 @@
 		if (dev->dvb.frontend) {
 			struct dvb_frontend *fe;
 			if (dvb_attach(dvb_pll_attach, dev->dvb.frontend, 0x60,
-				  &dev->i2c_adap, DVB_PLL_PHILIPS_SD1878_TDA8261) == NULL)
+				  &dev->i2c_adap, DVB_PLL_PHILIPS_SD1878_TDA8261) == NULL) {
 				wprintk("%s: MD7134 DVB-S, no SD1878 "
 					"found !\n", __func__);
+				goto dettach_frontend;
+			}
 			/* we need to open the i2c gate (we know it exists) */
 			fe = dev->dvb.frontend;
 			fe->ops.i2c_gate_ctrl(fe, 1);
 			if (dvb_attach(isl6405_attach, fe,
-					&dev->i2c_adap, 0x08, 0, 0) == NULL)
+					&dev->i2c_adap, 0x08, 0, 0) == NULL) {
 				wprintk("%s: MD7134 DVB-S, no ISL6405 "
 					"found !\n", __func__);
+				goto dettach_frontend;
+			}
 			fe->ops.i2c_gate_ctrl(fe, 0);
 			dev->original_set_voltage = fe->ops.set_voltage;
 			fe->ops.set_voltage = md8800_set_voltage;
@@ -1261,10 +1318,7 @@
 		if (!fe) {
 			printk(KERN_ERR "%s/2: xc3028 attach failed\n",
 			       dev->name);
-			dvb_frontend_detach(dev->dvb.frontend);
-			dvb_unregister_frontend(dev->dvb.frontend);
-			dev->dvb.frontend = NULL;
-			return -1;
+			goto dettach_frontend;
 		}
 	}
 
@@ -1289,6 +1343,13 @@
 			dev->dvb.frontend->ops.tuner_ops.sleep(dev->dvb.frontend);
 	}
 	return ret;
+
+dettach_frontend:
+	dvb_frontend_detach(dev->dvb.frontend);
+	dvb_unregister_frontend(dev->dvb.frontend);
+	dev->dvb.frontend = NULL;
+
+	return -1;
 }
 
 static int dvb_fini(struct saa7134_dev *dev)
diff -r 341e0cd5c1a4 linux/drivers/media/video/tuner-core.c
--- a/linux/drivers/media/video/tuner-core.c	Wed Apr 30 11:40:17 2008 +0000
+++ b/linux/drivers/media/video/tuner-core.c	Wed Apr 30 12:16:38 2008 -0300
@@ -369,16 +369,6 @@
 	tuner_warn("====================== WARNING! ======================\n");
 }
 
-static void attach_tda829x(struct tuner *t)
-{
-	struct tda829x_config cfg = {
-		.lna_cfg        = t->config,
-		.tuner_callback = t->tuner_callback,
-	};
-	dvb_attach(tda829x_attach,
-		   &t->fe, t->i2c->adapter, t->i2c->addr, &cfg);
-}
-
 static struct xc5000_config xc5000_cfg;
 
 static void set_type(struct i2c_client *c, unsigned int type,
@@ -414,12 +404,19 @@
 
 	switch (t->type) {
 	case TUNER_MT2032:
-		dvb_attach(microtune_attach,
-			   &t->fe, t->i2c->adapter, t->i2c->addr);
+		if (!dvb_attach(microtune_attach,
+			   &t->fe, t->i2c->adapter, t->i2c->addr))
+			goto attach_failed;
 		break;
 	case TUNER_PHILIPS_TDA8290:
 	{
-		attach_tda829x(t);
+		struct tda829x_config cfg = {
+			.lna_cfg        = t->config,
+			.tuner_callback = t->tuner_callback,
+		};
+		if (!dvb_attach(tda829x_attach, &t->fe, t->i2c->adapter,
+				t->i2c->addr, &cfg))
+			goto attach_failed;
 		break;
 	}
 	case TUNER_TEA5767:
@@ -470,8 +467,9 @@
 		break;
 	}
 	case TUNER_TDA9887:
-		dvb_attach(tda9887_attach,
-			   &t->fe, t->i2c->adapter, t->i2c->addr);
+		if (!dvb_attach(tda9887_attach,
+			   &t->fe, t->i2c->adapter, t->i2c->addr))
+			goto attach_failed;
 		break;
 	case TUNER_XC5000:
 	{

