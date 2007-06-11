Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbXFKTld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbXFKTld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbXFKTlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:41:24 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:13165 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752903AbXFKTlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:41:23 -0400
Message-ID: <466DA551.8040303@interia.pl>
Date: Mon, 11 Jun 2007 21:41:05 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 2.0.0.0 (X11/20070524)
MIME-Version: 1.0
To: video4linux-list@redhat.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Problem with SAA7134 driver
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
X-EMID: 91902acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I have bought recently
00:14.0 Multimedia controller: Philips Semiconductors SAA7134/SAA7135HL Video Broadcast Decoder (rev 01)
        Subsystem: KNC One KNC One TV-Station DVR
        Flags: bus master, medium devsel, latency 32, IRQ 11
        Memory at d6003000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [40] Power Management version 1
It was very cheap - 12 euro. I couldn't resist because it has hardware MPEG2 
video and audio encoder. TV is working OK. I have video and analog audio. But 
saa7134-alsa driver wasn't working and audio stream wasn't present in MPEG-TS 
stream. After receiving "User guide" from NXP I have started to dig in driver. 
Problem is caused by ACNI and ACPF not set before snd_card_saa7134_capture_prepare(). 
If I set them manually in this function then DMA capture is starting to working 
and audio stream is present in MPEG-TS. Unfortunatly MPlayer can't play audio 
from this stream. Also I have to set 32.11MHz as master clock, but driver is 
using 24.576MHz for this card? I see that ACNI is set in 
saa7134-tvaudio.c/tvaudio_init(). How it gets cleared? I will dig further, but 
if somebody has any idea...
Would be OK to make saa7134-empress driver MPlayer compatible? All MPlayer needs 
is audio input (now present) and info about current standard. I see that at least 
one other driver has MPlayer compatibility.

Please CC me.

Rafa³

saa7130/34: v4l2 driver version 0.2.14 loaded
saa7134[0]: found at 0000:00:14.0, rev: 1, irq: 11, latency: 32, mmio: 0xd6003000
saa7134[0]: subsystem: 1894:a006, board: KNC One TV-Station DVR [card=24,autodetected]
saa7134[0]: board init: gpio is 830000
saa7134[0]: i2c eeprom 00: 94 18 06 a0 06 80 00 01 00 00 00 00 00 00 01 00
saa7134[0]: i2c eeprom 10: 00 ff 86 0e ff 20 ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 20: 01 40 01 02 02 03 01 03 06 ff 01 df ff ff ff ff
saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 40: ff 05 00 c0 86 ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 70: 00 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner 1-0043: chip found @ 0x86 (saa7134[0])
tda9887 1-0043: tda988[5/6/7] found @ 0x43 (tuner)
tuner 1-0060: All bytes are equal. It is not a TEA5767
tuner 1-0060: chip found @ 0xc0 (saa7134[0])
tuner 1-0060: type set to 38 (Philips PAL/SECAM multi (FM1216ME MK3))
tuner 1-0060: type set to 38 (Philips PAL/SECAM multi (FM1216ME MK3))
saa6752hs 1-0020: saa6752hs: chip found @ 0x40
saa7134[0]: registered device video0 [v4l2]
saa7134[0]: registered device vbi0
saa7134[0]: registered device radio0



----------------------------------------------------------------------
Po meczu.....kurde...:)
>>> http://link.interia.pl/f1a72

