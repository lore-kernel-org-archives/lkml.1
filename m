Return-Path: <linux-kernel-owner+w=401wt.eu-S932773AbXHFUn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773AbXHFUn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 16:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765214AbXHFUm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 16:42:56 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:58305 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764200AbXHFUmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 16:42:54 -0400
Date: Mon, 6 Aug 2007 22:42:49 +0200
From: Andreas Mohr <andi@lisas.de>
To: David Edwards <powertop@dpe.lusars.net>
Cc: power@bughost.org, Thomas Gleixner <tglx@linutronix.de>,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       linux-kernel@vger.kernel.org
Subject: HPET force-enable investigations on Via VT8235 (was: Re: extra
	timer interrupt + konqueror)
Message-ID: <20070806204249.GA25957@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708041253520.18298@fortytwo.lusars.net>
X-Priority: none
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[CC'd LKML for broader testing]

Hi,

On Sat, Aug 04, 2007 at 12:58:20PM -0400, David Edwards wrote:
> Andreas Mohr wrote:
> >> Same for "hpet-force-enable-on-vt8235-37-chipsets.patch" (I use this
> >> one on my Asrock P4VT8+ motherboard (VT8237 based) with no pb).
> >
> > What!?!?!?
> > Why did nobody tell me that VT8235 *does* actually have a HPET
> > implementation? ;)
> > I've been investigating this during a couple evenings some months ago,
> > with apparently negative result for my VT8235 (blank I/O area at the
> > place where VT8237 has its HPET, and I wasn't able to activate anything),
> > which I then reported on LKML.
> > And now you report that one found that it's actually possible. Yay!!
> 
> Erm... Don't get too excited. The HPET patch does not enable the HPET on 
> my VT8235 (EPIA ME-6000 mini-itx board), so it may not be universally 
> functional.
> 
> > I'm going to test this patch on my EPOX 8K5A2+ (VT8235, i.e. PCI ID 0x3177).
> 
> Cool. Let me know if it works for you. :)

Err... nope. :((

I've added the full 2.6.23-rc1-hrt1 patchset
(http://www.tglx.de/projects/hrtimers/2.6.23-rc1/patch-2.6.23-rc1-hrt1.patch),
and I do get the "Failed to force enable HPET",
so I know it's running that function, however it fails
since the 0x80 bit is NOT set after the force-enable
(which sadly happens to match my experience during my much earlier efforts
to try to get HPET to work on this board).

So, *please* (I'd *love* to get this working somehow):
whoever has a VT8235 and is listening here,
- give a "lspci -nn" (two 'n'!), to figure out details of chipset revision etc.
- give a "lspci -d 1106:3177 -xxx", to try to figure out whether there happen
  to be additional magical "enable" bits to map in those HPET I/O areas which
  some BIOS versions configure and some don't (that's my fragile theory
  at least)
- oh, and don't forget to tell whether HPET works or not

For my system (again, it's EPOX 8K5A2+ with VT8235):

root@andi:/usr/src/linux-2.6.23-rc1-hrt1# lspci -nn
00:00.0 Host bridge [0600]: VIA Technologies, Inc. VT8366/A/7 [Apollo
KT266/A/333] [1106:3099]
00:01.0 PCI bridge [0604]: VIA Technologies, Inc. VT8366/A/7 [Apollo
KT266/A/333 AGP] [1106:b099]
00:09.0 FireWire (IEEE 1394) [0c00]: Duet Technologies Unknown device
[1306:3044] (rev 46)
00:0a.0 Multimedia audio controller [0401]: Aureal Semiconductor Vortex
2 [12eb:0002] (rev fe)
00:0c.0 Ethernet controller [0200]: Intel Corporation 82557/8/9
[Ethernet Pro 100] [8086:1229] (rev 08)
00:0d.0 Multimedia audio controller [0401]: Aztech System Ltd 3328 Audio
[122d:50dc] (rev 10)
00:10.0 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB
1.1 Controller [1106:3038] (rev 80)
00:10.1 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB
1.1 Controller [1106:3038] (rev 80)
00:10.2 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB
1.1 Controller [1106:3038] (rev 80)
00:10.3 USB Controller [0c03]: VIA Technologies, Inc. USB 2.0
[1106:3104] (rev 82)
00:11.0 ISA bridge [0601]: VIA Technologies, Inc. VT8235 ISA Bridge
[1106:3177]
00:11.1 IDE interface [0101]: VIA Technologies, Inc.
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE [1106:0571] (rev
06)
00:11.5 Multimedia audio controller [0401]: VIA Technologies, Inc.
VT8233/A/8235/8237 AC97 Audio Controller [1106:3059] (rev 50)
00:12.0 Ethernet controller [0200]: VIA Technologies, Inc. VT6102
[Rhine-II] [1106:3065] (rev 74)
01:00.0 VGA compatible controller [0300]: ATI Technologies Inc Radeon
RV250 If [Radeon 9000] [1002:4966] (rev 01)
01:00.1 Display controller [0380]: ATI Technologies Inc Radeon RV250
[Radeon 9000] (Secondary) [1002:496e] (rev 01)

root@andi:/usr/src/linux-2.6.23-rc1-hrt1# lspci -d 1106:3177 -xxx
00:11.0 ISA bridge: VIA Technologies, Inc. VT8235 ISA Bridge
00: 06 11 77 31 87 00 10 02 00 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 06 11 77 31
30: 00 00 00 00 c0 00 00 00 00 00 00 00 00 00 00 00
40: 44 00 f8 0b 00 00 00 00 0c 20 00 00 04 00 0a 08
50: 81 1d 09 00 00 20 22 20 43 80 00 00 00 00 f0 40
60: 00 00 00 00 00 00 02 04 00 00 00 00 00 00 00 00
70: 06 11 77 31 00 00 00 00 00 00 00 00 20 00 00 00
80: 20 84 59 00 ba 10 00 00 01 40 00 00 da 10 00 00
90: 00 4a 00 88 a0 40 03 00 00 b7 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 01 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 01 50 01 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 04 08 02 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 03 00 00 00 00 00 00 00 00 00

Thanks a lot,

Andreas Mohr
