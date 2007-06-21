Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbXFULuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbXFULuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 07:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbXFULt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 07:49:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:17833 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbXFULtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 07:49:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tlHMjKk7cqykc/nIej+scgF6Di3Yd1kfazEHtdHyIQgpfNqzK4jhhkf70NphFap6yTFDxLVKuzo+VWNzaKJznkNV/4cm+Tvtbb3+TgiwfIboVisMmwnYXWz0xtrd2ZIaoEjfaZvWY7BOIGJyT3/4pgF7tDirlrFLukHja3rRyUs=
Subject: Dual slot PCI riser messes up ivtv
From: Islam Amer <pharon@gmail.com>
Reply-To: pharon@gmail.com
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 21 Jun 2007 14:49:45 +0300
Message-Id: <1182426585.9143.2.camel@iamer-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone.

I am trying to build a settop box with two cards, a PVR-150 and a DVB
card. The mini-ITX motherboard has only one PCI slot, so I bought an
active PCI riser.

First I tried with two cheap lifeview cards on the riser and they
worked.
 
The PVR-150 is working fine alone, and so does the DVB card. But when I
use them with the riser nothing works.

Here's the debugging output when using both cards on the PCI riser.

[   37.506596] ivtv:  ==================== START INIT IVTV
====================
[   37.506603] ivtv:  version 1.0.0 (2.6.22-rc5 SMP mod_unload 586 )
loading
[   37.507978] ivtv0: Autodetected Hauppauge card (cx23416 based)
[   37.508022] ivtv0 info: base addr: 0x48000000
[   37.508025] ivtv0 info: Enabling pci device
[   37.508048] ACPI: PCI Interrupt 0000:00:0d.0[A] -> GSI 17 (level,
low) -> IRQ 22
[   37.508060] ivtv0 info: Bus Mastering Enabled.
[   37.508066] ivtv0: Unreasonably low latency timer, setting to 64 (was
32)
[   37.508074] ivtv0 info: 22 (rev 1) at 00:0d.0, irq: 22, latency: 64,
memory: 0x48000000
[   37.508078] ivtv0 info: attempting ioremap at 0x48000000 len
0x00800000
[   37.508125] ivtv0 info: attempting ioremap at 0x4a000000 len
0x00010000
[   37.508130] ivtv0 info: Preparing for firmware halt.
[   37.514147] ivtv0 info: Stopping VDM
[   37.514149] ivtv0 info: Stopping AO
[   37.514151] ivtv0 info: pinging (?) APU
[   37.514153] ivtv0 info: Stopping VPU
[   37.514156] ivtv0 info: Resetting Hw Blocks
[   37.514158] ivtv0 info: Stopping SPU
[   37.522095] ivtv0 info: init Encoder SDRAM pre-charge
[   37.522097] ivtv0 info: init Encoder SDRAM refresh to 1us
[   37.522100] ivtv0 info: Sleeping for 600ms (600 recommended)
[   38.121365] ivtv0 info: Loading encoder image
[   38.121406] PM: Adding info for No Bus:0000:00:0d.0
[   38.226760] PM: Removing info for No Bus:0000:00:0d.0
[   38.236949] ivtv0: loaded v4l-cx2341x-enc.fw firmware (376836 bytes)
[   38.433021] ivtv0 api: API Call: CX2341X_ENC_PING_FW
[   38.440985] ivtv0 info: Getting firmware version..
[   38.440989] ivtv0 api: API Call: CX2341X_ENC_GET_VERSION
[   38.448973] ivtv0: Encoder revision: 0x02060039
[   38.448978] ivtv0 info: GPIO initial dir: 0000c000 out: 00000000
[   38.448981] ivtv0 info: activating i2c...
[   38.448984] ivtv0 i2c: i2c init
[   38.448988] ivtv0 i2c: setting scl and sda to 1
[   38.449035] PM: Adding info for No Bus:i2c-0
[   38.450977] PM: Adding info for i2c:0-0050
[   38.451003] ivtv0 i2c: i2c client attach
[   38.455940] ivtv0 info: Active card count: 1.
[   38.464603] ivtv0 info: Loaded module tveeprom
[   38.516786] tveeprom 0-0050: Hauppauge model 25019, rev C589, serial#
9928629
[   38.516790] tveeprom 0-0050: tuner model is TCL MFPE05 2 (idx 89,
type 38)
[   38.516794] tveeprom 0-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L')
PAL(D/D1/K) (eeprom 0x74)
[   38.516798] tveeprom 0-0050: audio processor is CX25843 (idx 37)
[   38.516801] tveeprom 0-0050: decoder processor is CX25843 (idx 30)
[   38.516805] tveeprom 0-0050: has radio, has no IR receiver, has no IR
transmitter
[   38.516809] ivtv0: Autodetected Hauppauge WinTV PVR-150
[   38.516812] ivtv0 info: PAL tuner detected
[   38.570720] tuner 0-0043: chip found @ 0x86 (ivtv i2c driver #0)
[   38.570739] PM: Adding info for i2c:0-0043
[   38.570756] ivtv0 i2c: i2c client attach
[   38.570760] tda9887 0-0043: tda988[5/6/7] found @ 0x43 (tuner)
[   38.573960] tuner 0-0061: chip found @ 0xc2 (ivtv i2c driver #0)
[   38.573967] PM: Adding info for i2c:0-0061
[   38.573977] ivtv0 i2c: i2c client attach
[   38.587917] ivtv0 info: Loaded module tuner
[   38.623595] cx25840 0-0044: cx25843-24 found @ 0x88 (ivtv i2c driver
#0)
[   38.623612] PM: Adding info for i2c:0-0044
[   38.623631] ivtv0 i2c: i2c client attach
[   38.640454] PM: Adding info for No Bus:0-0044
[   38.664008] PM: Removing info for No Bus:0-0044
[   42.138437] cx25840 0-0044: loaded v4l-cx25840.fw firmware (16382
bytes)
[   42.216603] ivtv0 info: Loaded module cx25840
[   42.256928] wm8775 0-001b: chip found @ 0x36 (ivtv i2c driver #0)
[   42.265203] PM: Adding info for i2c:0-001b
[   42.265220] ivtv0 i2c: i2c client attach
[   42.265378] ivtv0 info: Loaded module wm8775
[   42.265385] ivtv0 i2c: call_i2c_client addr=44
[   42.304807] tuner 0-0061: type set to 38 (Philips PAL/SECAM multi
(FM1216ME MK3))
[   42.304814] ivtv0 info: Changing input from 1 to 0
[   42.304818] ivtv0 ioctl: VIDIOC_S_CTRL(00980909, 1)
[   42.304822] ivtv0 i2c: call_i2c_client addr=44
[   42.307546] ivtv0 info: Mute
[   42.307549] ivtv0 i2c: call_i2c_client addr=44
[   42.348205] ivtv0 i2c: call_i2c_client addr=1b
[   42.350733] ivtv0 i2c: call_i2c_client addr=44
[   42.390123] ivtv0 api: API Call: CX2341X_ENC_INITIALIZE_INPUT
[   42.496011] ivtv0 ioctl: VIDIOC_S_CTRL(00980909, 0)
[   42.496020] ivtv0 i2c: call_i2c_client addr=44
[   42.497922] ivtv0 info: Unmute
[   42.497927] ivtv0 ioctl: VIDIOC_S_CTRL(00980909, 1)
[   42.497929] ivtv0 i2c: call_i2c_client addr=44
[   42.500652] ivtv0 info: Mute
[   42.500655] ivtv0 info: v4l2 ioctl: set frequency 6400
[   42.518775] ivtv0 api: API Call: CX2341X_ENC_INITIALIZE_INPUT
[   42.623895] ivtv0 ioctl: VIDIOC_S_CTRL(00980909, 0)
[   42.623904] ivtv0 i2c: call_i2c_client addr=44
[   42.625806] ivtv0 info: Unmute
[   42.627473] ivtv0: Registered device video0 for encoder MPEG (4 MB)
[   42.627481] ivtv0 info: Allocate DMA encoder MPEG stream: 128 x 32768
buffers (4096kB total)
[   42.629322] ivtv0: Registered device video32 for encoder YUV (2 MB)
[   42.629330] ivtv0 info: Allocate DMA encoder YUV stream: 161 x 12960
buffers (2037kB total)
[   42.629984] ivtv0: Registered device vbi0 for encoder VBI (1 MB)
[   42.629989] ivtv0 info: Allocate DMA encoder VBI stream: 40 x 26208
buffers (1023kB total)
[   42.630464] ivtv0: Registered device video24 for encoder PCM audio (1
MB)
[   42.630471] ivtv0 info: Allocate DMA encoder PCM audio stream: 227 x
4608 buffers (1021kB total)
[   42.631139] ivtv0: Registered device radio0 for encoder radio
[   42.631148] ivtv0 info: Switching standard to f.
[   42.661697] ivtv0 irq: Masking interrupts
[   42.661721] ivtv0: Initialized Hauppauge WinTV PVR-150, card #0
[   42.661758] ivtv:  ====================  END INIT IVTV
====================


It seems to me that it is initialised correctly. But when I try to use
tvtime it gives this error :

videoinput: Card failed to allocate capture buffers: Invalid argument

Mplayer Just crashes.

The other card is messed up as well :

[   37.297009] saa7130/34: v4l2 driver version 0.2.14 loaded
[   37.298400] ACPI: PCI Interrupt 0000:00:05.0[A] -> GSI 17 (level,
low) -> IRQ 22
[   37.298413] saa7134[0]: found at 0000:00:05.0, rev: 1, irq: 22,
latency: 32, mmio: 0x0
[   37.298422] saa7134[0]: subsystem: 5168:0300, board: LifeView
FlyDVB-S /Acorp TV134DS [card=97,autodetected]
[   37.298428] saa7134[0]: can't get MMIO memory @ 0x0
[   37.298436] saa7134: probe of 0000:00:05.0 failed with error -16
[   37.388554] saa7134 ALSA driver for DMA sound loaded
[   37.388561] saa7134 ALSA: no saa7134 cards found


I am using ubuntu feisty, and the situation is the same with the distro
provided kernel 2.6.20-16-generic and ivtv-0.10.2

I also compiled ivtv-0.10.3 and nothing changed.

I even compiled a 2.6.22-rc5 since I found out that the ivtv module got
merged in mainline.

I emailed this to ivtv mailing list as well as the linux-dvb mailing
list, but I thought I would re-post here in case the support team moved
after merging with mainline.

Can anyone please point me to the right way ?

Thank you.

