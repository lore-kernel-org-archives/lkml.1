Return-Path: <linux-kernel-owner+w=401wt.eu-S935641AbXFFU1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935641AbXFFU1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932488AbXFFU1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:27:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:40176 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbXFFU1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:27:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=k8+Ijjs6+NGcS2TflLen1SHh7TVx5rOC0AZulv7Oq6bPlRtNNjYTudZwBUDrJErZsQGryzcJbMDBw3CwDbis+jXzscCCLhaOVgt3VL4olxpGLYlYbbyEmCy+Uc5+hsuyAjsfVJi8vss2EbP7YtJoskQe+gsOF2usmrY4xPoN6Iw=
Message-ID: <466718B6.4080105@gmail.com>
Date: Wed, 06 Jun 2007 22:27:34 +0200
From: Robert de Rooy <robert.de.rooy@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       linux-pcmcia@lists.infradead.org
Subject: Re: libata and legacy ide pcmcia failure
References: <464A0321.3080201@gmail.com>	<464C1575.8070005@gmail.com>	<464CB7C9.2080807@gmail.com>	<46503192.1040300@gmail.com>	<4650B9E3.7070409@gmail.com>	<46518798.2020808@gmail.com>	<4651B66E.6030505@gmail.com>	<4651B834.3060702@gmail.com>	<4651C4A1.6000101@gmail.com>	<4651C74B.7020108@gmail.com>	<46520B36.90409@garzik.org> <20070523150229.00a0c3c4@the-village.bc.nu>
In-Reply-To: <20070523150229.00a0c3c4@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>>   http://thread.gmane.org/gmane.linux.kernel/530099
>>>
>>> It seems we're losing interrupts from the CFA device.  Any ideas?
>>>       
>> Alan probably knows more, but ISTR some CFA PCMCIA devices that needed 
>> polling...
>>     
>
> Not that I know of. Not devices anyway - there are embedded boxes with no
> IRQ configuration for the CF slot but we've never supported those (indeed
> there are even people who bitbang ATA on GPIO pins...)
>
>   
I was able to test the same PCMCIA adapter in a different ThinkPad, an X40.
The X40 also fails although it has a totally different Cardbus 
controller (TI on the T40 vs Ricoh on the X40)

Here is the log from the X40 running the same kernel as before 
(2.6.22rc1-git5 + timing-debug.patch + 
disable-dev_init_param-and-setxfermode-for-CFA.patch)

pccard: PCMCIA card inserted into slot 0
pcmcia: registering new device pcmcia0.0
Jun  6 22:10:21 localhost kernel: pccard: PCMCIA card inserted into slot 0
Jun  6 22:10:21 localhost kernel: cs: memory probe 
0xf0000000-0xf7ffffff: excluding 0xf0000000-0xf7ffffff
Jun  6 22:10:21 localhost kernel: cs: memory probe 
0xd0200000-0xdfffffff: excluding 0xd0200000-0xd11fffff 
0xd1a00000-0xd21fffff 0xd2a00000-0xd31fffff 0xd3a00000-0xd81fffff 
0xd8a00000-0xd91fffff 0xd9a00000-0xda1fffff 0xdaa00000-0xdb1fffff 
0xdba00000-0xdc1fffff 0xdca00000-0xdd1fffff 0xdda00000-0xde1fffff 
0xdea00000-0xdf1fffff 0xdfa00000-0xe01fffff
Jun  6 22:10:21 localhost kernel: pcmcia: registering new device pcmcia0.0
Jun  6 22:10:21 localhost kernel: scsi3 : pata_pcmcia
Jun  6 22:10:21 localhost kernel: ata3: PATA max PIO0 cmd 0x00013100 ctl 
0x0001310e bmdma 0x00000000 irq 0
Jun  6 22:10:21 localhost kernel: ata3: soft resetting port
Jun  6 22:10:32 localhost kernel: ata3: SRST failed (errno=-16)
Jun  6 22:10:32 localhost kernel: ata3: soft resetting port
Jun  6 22:10:42 localhost kernel: ata3: SRST failed (errno=-16)
Jun  6 22:10:42 localhost kernel: ata3: soft resetting port
ata3: SRST failed (errno=-16)
Jun  6 22:11:17 localhost kernel: ata3: SRST failed (errno=-16)
Jun  6 22:11:17 localhost kernel: ata3: soft resetting port
ata3: SRST failed (errno=-16)
ata3: reset failed, giving up
Jun  6 22:11:22 localhost kernel: ata3: SRST failed (errno=-16)
Jun  6 22:11:22 localhost kernel: ata3: reset failed, giving up
Jun  6 22:11:22 localhost kernel: ata3: EH complete
Jun  6 22:11:22 localhost udevd-event[2459]: udev_rules_apply_format: 
unknown format variable '$modalias'

And here is the lspci data from the X40

00:00.0 Host bridge: Intel Corporation 82852/82855 GM/GME/PM/GMV 
Processor to I/O Controller (rev 02)
    Subsystem: IBM Thinkpad R50e model 1634
    Flags: bus master, fast devsel, latency 0
    Memory at <unassigned> (32-bit, prefetchable)
    Capabilities: [40] Vendor Specific Information
00: 86 80 80 35 06 01 90 20 02 00 00 06 00 00 80 00
10: 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 14 10 5c 05
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 00 00 00
40: 09 00 05 81 00 00 00 00 00 00 c1 fe 02 28 00 0e
50: 00 01 34 00 10 00 00 00 00 10 11 11 00 30 11 11
60: 0a 79 00 02 00 00 08 00 00 00 00 00 00 00 00 00
70: 02 09 00 00 56 60 00 02 01 00 80 00 00 00 00 00
80: 02 00 00 66 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 02 00 20 00 17 02 00 1f 01 00 00 00 00 00 00 00
b0: 00 00 f0 eb 00 00 00 00 00 00 00 00 20 10 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 02 00 06 01 00 00

00:00.1 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV 
Processor to I/O Controller (rev 02)
    Subsystem: IBM Thinkpad R50e model 1634
    Flags: bus master, fast devsel, latency 0
00: 86 80 84 35 06 00 80 00 02 00 80 08 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 14 10 5d 05
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 04 08 18 28 00 00 00 00 00 00 00 00 00 00 00 00
50: 11 33 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 05 42 00 2a 00 00 00 00 00 00 c0 10 00 00 00 00
70: 75 99 00 20 01 00 00 00 74 e9 1f 00 00 00 00 00
80: 69 00 af 00 bc 01 00 00 10 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 b9 19 12 04 b7 0a 00 00
a0: ff 52 05 30 00 00 00 00 98 87 00 00 a1 b4 20 00
b0: 00 00 00 00 00 00 00 00 84 59 00 00 66 02 9d 04
c0: 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:00.3 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV 
Processor to I/O Controller (rev 02)
    Subsystem: IBM Thinkpad R50e model 1634
    Flags: bus master, fast devsel, latency 0
00: 86 80 85 35 06 00 80 00 02 00 80 08 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 14 10 5e 05
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 04 04 00 00 00 00 11 11 3c 51 65 0b 50 64 0b 51
50: 65 0b 00 00 00 00 00 00 01 08 39 2d 35 33 03 0b
60: 00 00 00 00 00 00 00 00 04 04 00 00 31 3e 00 00
70: 00 00 00 00 04 04 41 27 e7 c7 0f 46 27 12 84 02
80: ff 1f 00 00 ef 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 80 13 1f 00 00 00 00
b0: 00 00 00 00 80 02 00 00 00 00 00 00 00 00 00 00
c0: 07 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 01 00 21 02 00 00 00 00 08 c3 00 ff 25 00 00 00
e0: 2a 00 27 00 da 00 a7 00 00 00 00 00 00 04 00 00
f0: 00 00 00 c0 00 00 00 00 00 00 00 00 00 00 00 00

00:02.0 VGA compatible controller: Intel Corporation 82852/855GM 
Integrated Graphics Device (rev 02) (prog-if 00 [VGA])
    Subsystem: IBM Unknown device 0557
    Flags: fast devsel, IRQ 11
    Memory at e0000000 (32-bit, prefetchable) [size=128M]
    Memory at d0000000 (32-bit, non-prefetchable) [size=512K]
    I/O ports at 1800 [size=8]
    Capabilities: [d0] Power Management version 1
00: 86 80 82 35 03 00 90 00 02 00 00 03 00 00 80 00
10: 08 00 00 e0 00 00 00 d0 01 18 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 14 10 57 05
30: 00 00 00 00 d0 00 00 00 00 00 00 00 0b 01 00 00
40: 09 00 05 81 00 40 00 00 00 00 00 00 00 00 00 00
50: 00 01 34 00 10 00 00 00 00 00 02 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: ff 52 05 30 00 00 00 00 e8 88 00 00 29 c5 20 00
b0: 00 00 00 00 00 00 00 00 5c 5a 00 00 fa e4 9e 04
c0: 07 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 01 00 21 02 00 00 00 00 08 c3 00 ff 25 00 00 00
e0: 2a 00 27 00 da 00 a7 00 00 00 00 00 00 04 00 00
f0: 00 00 00 00 ff 00 00 00 00 00 00 00 00 00 00 00

00:02.1 Display controller: Intel Corporation 82852/855GM Integrated 
Graphics Device (rev 02)
    Subsystem: IBM Unknown device 0557
    Flags: fast devsel
    Memory at e8000000 (32-bit, prefetchable) [size=128M]
    Memory at d0080000 (32-bit, non-prefetchable) [size=512K]
    Capabilities: [d0] Power Management version 1
00: 86 80 82 35 03 00 90 00 02 00 80 03 00 00 80 00
10: 08 00 00 e8 00 00 08 d0 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 14 10 57 05
30: 00 00 00 00 d0 00 00 00 00 00 00 00 00 00 00 00
40: 09 00 05 81 00 40 00 00 00 00 00 00 00 00 00 00
50: 00 01 34 00 10 00 00 00 00 00 02 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: ff 52 05 30 00 00 00 00 4a 89 00 00 83 cc 20 00
b0: 00 00 00 00 00 00 00 00 90 5a 00 00 11 dc 9f 04
c0: 07 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 01 00 21 02 00 00 00 00 08 c3 00 ff 25 00 00 00
e0: 2a 00 27 00 da 00 a7 00 00 00 00 00 00 04 00 00
f0: 00 00 00 00 ff 00 00 00 00 00 00 00 00 00 00 00

00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM 
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 01) (prog-if 00 [UHCI])
    Subsystem: IBM Thinkpad R50e model 1634
    Flags: bus master, medium devsel, latency 0, IRQ 16
    I/O ports at 1820 [size=32]
00: 86 80 c2 24 05 00 80 02 01 00 03 0c 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 21 18 00 00 00 00 00 00 00 00 00 00 14 10 2d 05
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 25 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 00 00

00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM 
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 01) (prog-if 00 [UHCI])
    Subsystem: IBM Thinkpad R50e model 1634
    Flags: bus master, medium devsel, latency 0, IRQ 18
    I/O ports at 1840 [size=32]
00: 86 80 c4 24 05 00 80 02 01 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 41 18 00 00 00 00 00 00 00 00 00 00 14 10 2d 05
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 02 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 25 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 00 00

00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM 
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 01) (prog-if 00 [UHCI])
    Subsystem: IBM Thinkpad R50e model 1634
    Flags: bus master, medium devsel, latency 0, IRQ 19
    I/O ports at 1860 [size=32]
00: 86 80 c7 24 05 00 80 02 01 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 61 18 00 00 00 00 00 00 00 00 00 00 14 10 2d 05
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 03 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 25 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 00 00

00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 
EHCI Controller (rev 01) (prog-if 20 [EHCI])
    Subsystem: IBM Thinkpad R50e model 1634
    Flags: bus master, medium devsel, latency 0, IRQ 20
    Memory at d0100000 (32-bit, non-prefetchable) [size=1K]
    Capabilities: [50] Power Management version 2
    Capabilities: [58] Debug port
00: 86 80 cd 24 06 01 90 02 01 20 03 0c 00 00 00 00
10: 00 00 10 d0 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 14 10 2e 05
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 04 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 58 c2 c9 00 80 00 00 0a 00 80 20 00 00 00 00
60: 20 20 1f 00 00 00 00 00 01 00 00 00 00 00 08 c0
70: 00 00 df 0f 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3f 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 78 bf 1f 00 88 83 00 00 60 0f 00 00 06 00 00 00

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 81) 
(prog-if 00 [Normal decode])
    Flags: bus master, fast devsel, latency 0
    Bus: primary=00, secondary=02, subordinate=05, sec-latency=64
    I/O behind bridge: 00003000-00007fff
    Memory behind bridge: d0200000-dfffffff
    Prefetchable memory behind bridge: f0000000-f7ffffff
00: 86 80 48 24 07 01 80 80 81 00 04 06 00 00 01 00
10: 00 00 00 00 00 00 00 00 00 02 05 40 30 70 80 22
20: 20 d0 f0 df 00 f0 f0 f7 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 04 00
40: 02 28 20 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 02 74 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 40 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 86 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 10 00 08 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 01 00 02 00 00 00 c0 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 4e 32

00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface 
Bridge (rev 01)
    Flags: bus master, medium devsel, latency 0
00: 86 80 cc 24 0f 00 80 02 01 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 01 10 00 00 10 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 81 11 00 00 10 00 00 00
60: 8b 8b 8b 8b 92 00 00 00 8b 8b 80 8b 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: ff fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 24 02 00 00 00 00 00 00 12 00 00 00 00 00 08 00
b0: 00 00 00 00 00 00 00 00 00 00 02 0a 00 00 00 00
c0: 10 00 00 00 e0 15 00 00 00 00 00 00 0f 00 00 00
d0: 87 69 20 00 02 0f 00 00 04 00 00 00 00 00 00 00
e0: 10 02 00 ff 01 16 07 3c 33 22 11 00 81 16 67 45
f0: 00 00 00 00 00 00 00 00 60 0f 03 00 00 00 80 00

00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE 
Controller (rev 01) (prog-if 8a [Master SecP PriP])
    Subsystem: IBM Thinkpad R50e model 1634
    Flags: bus master, medium devsel, latency 0, IRQ 19
    I/O ports at 01f0 [size=8]
    I/O ports at 03f4 [size=1]
    I/O ports at 0170 [size=8]
    I/O ports at 0374 [size=1]
    I/O ports at 1810 [size=16]
    Memory at 60000000 (32-bit, non-prefetchable) [size=1K]
00: 86 80 ca 24 07 00 80 02 01 8a 01 01 00 00 00 00
10: 01 00 00 00 01 00 00 00 01 00 00 00 01 00 00 00
20: 11 18 00 00 00 00 00 60 00 00 00 00 14 10 2d 05
30: 00 00 00 00 00 00 00 00 00 00 00 00 ff 01 00 00
40: 07 a3 07 a3 00 00 00 00 05 00 01 01 00 00 00 00
50: 00 00 00 00 50 54 00 00 00 00 00 00 00 00 00 00
60: 08 00 00 00 00 00 00 00 08 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 00 00

00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) 
SMBus Controller (rev 01)
    Subsystem: IBM Thinkpad R50e model 1634
    Flags: medium devsel, IRQ 17
    I/O ports at 1880 [size=32]
00: 86 80 c3 24 01 00 80 02 01 00 05 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 81 18 00 00 00 00 00 00 00 00 00 00 14 10 2d 05
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 02 00 00
40: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 00 00

00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM 
(ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 01)
    Subsystem: IBM Unknown device 0558
    Flags: bus master, medium devsel, latency 0, IRQ 17
    I/O ports at 1c00 [size=256]
    I/O ports at 18c0 [size=64]
    Memory at d0100c00 (32-bit, non-prefetchable) [size=512]
    Memory at d0100800 (32-bit, non-prefetchable) [size=256]
    Capabilities: [50] Power Management version 2
00: 86 80 c5 24 07 00 90 02 01 00 01 04 00 00 00 00
10: 01 1c 00 00 c1 18 00 00 00 0c 10 d0 00 08 10 d0
20: 00 00 00 00 00 00 00 00 00 00 00 00 14 10 58 05
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 02 00 00
40: 09 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 00 c2 c9 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 00 00

00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) 
AC'97 Modem Controller (rev 01) (prog-if 00 [Generic])
    Subsystem: IBM Unknown device 055a
    Flags: bus master, medium devsel, latency 0, IRQ 17
    I/O ports at 2400 [size=256]
    I/O ports at 2000 [size=128]
    Capabilities: [50] Power Management version 2
00: 86 80 c6 24 05 00 90 02 01 00 03 07 00 00 00 00
10: 01 24 00 00 01 20 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 14 10 5a 05
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 02 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 00 c2 c9 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 00 00

02:00.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev 8d)
    Subsystem: IBM Unknown device 0555
    Flags: bus master, medium devsel, latency 168, IRQ 16
    Memory at b0000000 (32-bit, non-prefetchable) [size=4K]
    Bus: primary=02, secondary=03, subordinate=04, sec-latency=176
    Memory window 0: f0000000-f3fff000 (prefetchable)
    Memory window 1: d4000000-d7fff000
    I/O window 0: 00003000-000030ff
    I/O window 1: 00003400-000034ff
    16-bit legacy interface ports at 0001
00: 80 11 76 04 07 00 10 02 8d 00 07 06 00 a8 82 00
10: 00 00 00 b0 dc 00 00 02 02 03 04 b0 00 00 00 f0
20: 00 f0 ff f3 00 00 00 d4 00 f0 ff d7 00 30 00 00
30: fc 30 00 00 00 34 00 00 fc 34 00 00 0b 01 80 05
40: 14 10 55 05 01 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 01 00 80 04 00 03 00 00 64 04 63 04 01 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 8a 00 00 00 00 00 00 00 f0 00 00 00 00 00
b0: 00 00 00 00 00 00 00 36 00 38 00 00 00 00 00 00
c0: 14 10 55 05 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 0a fe
e0: 00 40 c0 24 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

02:00.1 Generic system peripheral [0805]: Ricoh Co Ltd R5C822 
SD/SDIO/MMC/MS/MSPro Host Adapter (rev 13)
    Subsystem: IBM Thinkpad X40
    Flags: bus master, medium devsel, latency 64, IRQ 17
    Memory at d0221000 (32-bit, non-prefetchable) [size=256]
    Capabilities: [80] Power Management version 2
00: 80 11 22 08 06 01 10 02 13 00 05 08 00 40 80 00
10: 00 10 22 d0 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 14 10 56 05
30: 00 00 00 00 80 00 00 00 00 00 00 00 0b 02 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 01 00 02 fe 00 40 00 48 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 14 10 56 05
b0: 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: a1 21 80 01 00 00 00 00 40 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 03 00 20 04 00 00 00 00

02:01.0 Ethernet controller: Intel Corporation 82541GI Gigabit Ethernet 
Controller
    Subsystem: IBM Unknown device 055b
    Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 21
    Memory at d0200000 (32-bit, non-prefetchable) [size=128K]
    I/O ports at 7000 [size=64]
    Capabilities: [dc] Power Management version 2
    Capabilities: [e4] PCI-X non-bridge device
00: 86 80 77 10 17 01 30 02 00 00 00 02 08 40 00 00
10: 00 00 20 d0 00 00 00 00 01 70 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 14 10 5b 05
30: 00 00 00 00 dc 00 00 00 00 00 00 00 0b 01 ff 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 e4 22 c8
e0: 00 20 00 14 07 00 02 00 00 00 40 00 00 00 00 00
f0: 05 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00

02:02.0 Network controller: Intel Corporation PRO/Wireless 2200BG 
Network Connection (rev 05)
    Subsystem: Intel Corporation Unknown device 2711
    Flags: bus master, medium devsel, latency 64, IRQ 22
    Memory at d0220000 (32-bit, non-prefetchable) [size=4K]
    Capabilities: [dc] Power Management version 2
00: 86 80 20 42 16 01 90 02 05 00 80 02 08 40 00 00
10: 00 00 22 d0 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 11 27
30: 00 00 00 00 dc 00 00 00 00 00 00 00 0b 01 03 18
40: 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 22 c8
e0: 00 20 00 13 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00


