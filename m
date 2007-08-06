Return-Path: <linux-kernel-owner+w=401wt.eu-S933952AbXHFXTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952AbXHFXTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 19:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932623AbXHFXTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 19:19:09 -0400
Received: from server1.thedotin.net ([65.99.213.166]:57155 "EHLO
	fortytwo.lusars.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085AbXHFXTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 19:19:08 -0400
X-Greylist: delayed 2741 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Aug 2007 19:19:07 EDT
Date: Mon, 6 Aug 2007 18:33:01 -0400 (EDT)
From: David Edwards <powertop@dpe.lusars.net>
X-X-Sender: dpe@fortytwo.lusars.net
To: Andreas Mohr <andi@lisas.de>
cc: power@bughost.org, Thomas Gleixner <tglx@linutronix.de>,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       linux-kernel@vger.kernel.org
Subject: Re: HPET force-enable investigations on Via VT8235 (was: Re: extra
 timer interrupt + konqueror)
In-Reply-To: <20070806204249.GA25957@rhlx01.hs-esslingen.de>
Message-ID: <Pine.LNX.4.64.0708061830100.3077@fortytwo.lusars.net>
References: <20070806204249.GA25957@rhlx01.hs-esslingen.de>
X-message-flag: WinErr 0x0013: Email application fault! Please close all programs and reboot immediately!
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2007, Andreas Mohr wrote:
> whoever has a VT8235 and is listening here,
> - give a "lspci -nn" (two 'n'!), to figure out details of chipset revision etc.

00:00.0 Host bridge [0600]: VIA Technologies, Inc. VT8623 [Apollo CLE266] [1106:3123]
00:01.0 PCI bridge [0604]: VIA Technologies, Inc. VT8633 [Apollo Pro266 AGP] [1106:b091]
00:0d.0 FireWire (IEEE 1394) [0c00]: VIA Technologies, Inc. IEEE 1394 Host Controller [1106:3044] (rev 80)
00:10.0 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038] (rev 80)
00:10.1 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038] (rev 80)
00:10.2 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038] (rev 80)
00:10.3 USB Controller [0c03]: VIA Technologies, Inc. USB 2.0 [1106:3104] (rev 82)
00:11.0 ISA bridge [0601]: VIA Technologies, Inc. VT8235 ISA Bridge [1106:3177]
00:11.1 IDE interface [0101]: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE [1106:0571] (rev 06)
00:11.5 Multimedia audio controller [0401]: VIA Technologies, Inc. VT8233/A/8235/8237 AC97 Audio Controller [1106:3059] (rev 50)
00:12.0 Ethernet controller [0200]: VIA Technologies, Inc. VT6102 [Rhine-II] [1106:3065] (rev 74)
01:00.0 VGA compatible controller [0300]: VIA Technologies, Inc. VT8623 [Apollo CLE266] integrated CastleRock graphics [1106:3122] (rev 03)


> - give a "lspci -d 1106:3177 -xxx", to try to figure out whether there happen
>  to be additional magical "enable" bits to map in those HPET I/O areas which
>  some BIOS versions configure and some don't (that's my fragile theory
>  at least)

00:11.0 ISA bridge: VIA Technologies, Inc. VT8235 ISA Bridge
00: 06 11 77 31 87 00 10 02 00 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 06 11 01 aa
30: 00 00 00 00 c0 00 00 00 00 00 00 00 00 00 00 00
40: 45 00 f0 00 00 00 00 00 0c 20 00 00 44 00 0a 08
50: 81 1d 09 00 00 b0 a5 b0 03 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 04 00 00 00 00 00 00 00 00
70: 06 11 01 aa 00 00 00 00 00 00 00 00 20 00 00 00
80: 20 84 59 00 b2 30 00 00 01 04 00 00 00 18 00 00
90: 00 07 10 88 a0 c0 00 00 00 7f 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 01 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 01 05 01 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 14 88 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 05 00 00 00 00 00 00 00 00 00

> - oh, and don't forget to tell whether HPET works or not

Nope.

>
> For my system (again, it's EPOX 8K5A2+ with VT8235):
>
> root@andi:/usr/src/linux-2.6.23-rc1-hrt1# lspci -nn
> 00:00.0 Host bridge [0600]: VIA Technologies, Inc. VT8366/A/7 [Apollo
> KT266/A/333] [1106:3099]
> 00:01.0 PCI bridge [0604]: VIA Technologies, Inc. VT8366/A/7 [Apollo
> KT266/A/333 AGP] [1106:b099]
> 00:09.0 FireWire (IEEE 1394) [0c00]: Duet Technologies Unknown device
> [1306:3044] (rev 46)
> 00:0a.0 Multimedia audio controller [0401]: Aureal Semiconductor Vortex
> 2 [12eb:0002] (rev fe)
> 00:0c.0 Ethernet controller [0200]: Intel Corporation 82557/8/9
> [Ethernet Pro 100] [8086:1229] (rev 08)
> 00:0d.0 Multimedia audio controller [0401]: Aztech System Ltd 3328 Audio
> [122d:50dc] (rev 10)
> 00:10.0 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB
> 1.1 Controller [1106:3038] (rev 80)
> 00:10.1 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB
> 1.1 Controller [1106:3038] (rev 80)
> 00:10.2 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB
> 1.1 Controller [1106:3038] (rev 80)
> 00:10.3 USB Controller [0c03]: VIA Technologies, Inc. USB 2.0
> [1106:3104] (rev 82)
> 00:11.0 ISA bridge [0601]: VIA Technologies, Inc. VT8235 ISA Bridge
> [1106:3177]
> 00:11.1 IDE interface [0101]: VIA Technologies, Inc.
> VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE [1106:0571] (rev
> 06)
> 00:11.5 Multimedia audio controller [0401]: VIA Technologies, Inc.
> VT8233/A/8235/8237 AC97 Audio Controller [1106:3059] (rev 50)
> 00:12.0 Ethernet controller [0200]: VIA Technologies, Inc. VT6102
> [Rhine-II] [1106:3065] (rev 74)
> 01:00.0 VGA compatible controller [0300]: ATI Technologies Inc Radeon
> RV250 If [Radeon 9000] [1002:4966] (rev 01)
> 01:00.1 Display controller [0380]: ATI Technologies Inc Radeon RV250
> [Radeon 9000] (Secondary) [1002:496e] (rev 01)
>
> root@andi:/usr/src/linux-2.6.23-rc1-hrt1# lspci -d 1106:3177 -xxx
> 00:11.0 ISA bridge: VIA Technologies, Inc. VT8235 ISA Bridge
> 00: 06 11 77 31 87 00 10 02 00 00 01 06 00 00 80 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 06 11 77 31
> 30: 00 00 00 00 c0 00 00 00 00 00 00 00 00 00 00 00
> 40: 44 00 f8 0b 00 00 00 00 0c 20 00 00 04 00 0a 08
> 50: 81 1d 09 00 00 20 22 20 43 80 00 00 00 00 f0 40
> 60: 00 00 00 00 00 00 02 04 00 00 00 00 00 00 00 00
> 70: 06 11 77 31 00 00 00 00 00 00 00 00 20 00 00 00
> 80: 20 84 59 00 ba 10 00 00 01 40 00 00 da 10 00 00
> 90: 00 4a 00 88 a0 40 03 00 00 b7 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 01 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 01 50 01 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 04 08 02 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 03 00 00 00 00 00 00 00 00 00
>
> Thanks a lot,
>
> Andreas Mohr
>
>
