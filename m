Return-Path: <linux-kernel-owner+w=401wt.eu-S964983AbXHGUvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964983AbXHGUvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935372AbXHGUsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:48:04 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:57308 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760744AbXHGUsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:48:03 -0400
Date: Tue, 7 Aug 2007 22:48:00 +0200
From: Andreas Mohr <andi@lisas.de>
To: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>
Cc: Andreas Mohr <andi@lisas.de>,
       =?utf-8?B?UmFmYcWC?= Bilski <rafalbilski@interia.pl>,
       David Edwards <powertop@dpe.lusars.net>, power@bughost.org,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: HPET force-enable investigations on Via VT8235
Message-ID: <20070807204800.GA15603@rhlx01.hs-esslingen.de>
References: <20070806204249.GA25957@rhlx01.hs-esslingen.de> <46B79512.6090704@interia.pl> <20070806235752.1e6c5653@laptop.hypervisor.org> <20070807131131.163b09fc@laptop.hypervisor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070807131131.163b09fc@laptop.hypervisor.org>
X-Priority: none
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 07, 2007 at 01:11:31PM +0200, Udo A. Steinberg wrote:
> On Mon, 6 Aug 2007 23:57:52 +0200 Udo A. Steinberg (UAS) wrote:
> 
> UAS> My guess is that newer revisions of VT8235 have HPET whereas older
> UAS> revisions do not. I'll get an lspci dump from our box tomorrow.
> 
> Here is the lspci dump from our K7VT4A+ board, where HPET works.

Thanks for all your reports!

Unfortunately I was NOT successful in trying to get it to work here.
The EPOX 8K5A2+ probably(?) is a KT333 chipset (or KT333A?),
and thus possibly the first one to sport a HPET is KT400 (plus its
correspondingly modern VT8235 companion chip) or even more modern chipsets.

Here is my hexdump analysis, and unfortunately I was unable to
get any bit to enable the HPET range.
I didn't want to get too brave, since this is obviously also
rather dangerous... (I adhered to the specs rather closely without
trying too many exciting things)

xAM 00: 06 11 77 31 87 00 10 02 00 00 01 06 00 00 80 00
xDE 00: 06 11 77 31 87 00 10 02 00 00 01 06 00 00 80 00
*RB 00: 06 11 77 31 87 00 10 02 00 00 01 06 00 00 80 00
*US 00: 06 11 77 31 87 00 10 02 00 00 01 06 00 00 80 00
== EQUAL ==

xAM 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
xDE 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
*RB 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
*US 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
== EQUAL ==

xAM 20: 00 00 00 00 00 00 00 00 00 00 00 00 06 11 77 31
xDE 20: 00 00 00 00 00 00 00 00 00 00 00 00 06 11 01 aa
*RB 20: 00 00 00 00 00 00 00 00 00 00 00 00 06 11 01 aa
*US 20: 00 00 00 00 00 00 00 00 00 00 00 00 49 18 77 31
== PCI ID differences ==

xAM 30: 00 00 00 00 c0 00 00 00 00 00 00 00 00 00 00 00
xDE 30: 00 00 00 00 c0 00 00 00 00 00 00 00 00 00 00 00
*RB 30: 00 00 00 00 c0 00 00 00 00 00 00 00 00 00 00 00
*US 30: 00 00 00 00 c0 00 00 00 00 00 00 00 00 00 00 00
== EQUAL ==

xAM 40: 44 00 f8 0b 00 00 00 00 0c 20 00 00 04 00 0a 08
xDE 40: 45 00 f0 00 00 00 00 00 0c 20 00 00 44 00 0a 08
*RB 40: 45 00 f0 00 00 00 00 00 0c 20 00 00 44 00 0a 08
*US 40: 44 00 78 00 00 00 00 00 0c 01 00 00 44 00 08 08
== nothing suspicious ==

xAM 50: 81 1d 09 00 00 20 22 20 43 80 00 00 00 00 f0 40
xDE 50: 81 1d 09 00 00 b0 a5 b0 03 00 00 00 00 00 00 00
*RB 50: 81 1d 09 00 00 b0 a5 30 03 00 00 00 00 00 00 00
*US 50: 81 1d 09 00 00 00 00 00 43 00 ff 01 00 00 04 08
== nothing suspicious ==
(except for *maybe* 0x57, which is IRQ routing only)

xAM 60: 00 00 00 00 00 00 02 04 00 00 00 00 00 00 00 00
xDE 60: 00 00 00 00 00 00 00 04 00 00 00 00 00 00 00 00
*RB 60: 00 00 00 00 00 00 00 04 80 00 d0 fe 00 00 00 00
*US 60: 00 00 00 00 10 00 02 04 00 00 00 00 00 00 00 00
== nothing suspicious ==

xAM 70: 06 11 77 31 00 00 00 00 00 00 00 00 20 00 00 00
xDE 70: 06 11 01 aa 00 00 00 00 00 00 00 00 20 00 00 00
*RB 70: 06 11 01 aa 00 00 00 00 00 00 00 00 20 00 00 00
*US 70: 49 18 77 31 00 00 00 00 00 00 00 00 10 00 00 00
== nothing suspicious ==

xAM 80: 20 84 59 00 ba 10 00 00 01 40 00 00 da 10 00 00
xDE 80: 20 84 59 00 b2 30 00 00 01 04 00 00 00 18 00 00
*RB 80: 20 84 59 00 b2 30 00 00 01 04 00 00 00 18 00 00
*US 80: 20 84 59 00 9a 10 00 00 01 08 00 00 04 18 00 00
== nothing suspicious ==

xAM 90: 00 4a 00 88 a0 40 03 00 00 b7 00 00 00 00 00 00
xDE 90: 00 07 10 88 a0 c0 00 00 00 7f 00 00 00 00 00 00
*RB 90: 00 1f 50 88 b0 c0 00 00 00 97 00 00 00 00 00 00
*US 90: 00 77 d8 00 b4 c5 08 00 10 92 00 00 00 00 00 00
==
0x91 bit 4 is interesting, but writing e.g. 1f still keeps 4a there for me
0x92 bit 6 is interesting, but...
0x94 bit 4 is interesting. can be changed, but HPET still cannot be enabled
0x99 bit 6 is interesting, but changing doesn't work


xAM a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
xDE a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
*RB a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
*US a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
== EQUAL ==

xAM b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
xDE b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
*RB b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
*US b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
== EQUAL ==

xAM c0: 01 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
xDE c0: 01 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
*RB c0: 01 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
*US c0: 01 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
== EQUAL ==

xAM d0: 01 50 01 00 00 00 00 00 00 00 00 00 00 00 00 00
xDE d0: 01 05 01 00 00 00 00 00 00 00 00 00 00 00 00 00
*RB d0: 01 05 01 00 00 00 00 00 00 00 00 00 00 00 00 00
*US d0: 01 04 01 00 00 00 00 00 00 00 00 00 00 00 00 00
== nothing suspicious ==

xAM e0: 00 00 00 00 04 08 02 00 00 00 00 00 00 00 00 00
xDE e0: 00 00 00 00 14 88 00 00 00 00 00 00 00 00 00 00
*RB e0: 00 00 00 00 14 88 00 00 00 00 00 00 00 00 00 00
*US e0: 00 00 00 00 04 08 c0 00 00 00 00 00 00 00 00 00
== nothing suspicious ==

xAM f0: 00 00 00 00 00 00 03 00 00 00 00 00 00 00 00 00
xDE f0: 00 00 00 00 00 00 05 00 00 00 00 00 00 00 00 00
*RB f0: 00 00 00 00 00 00 16 00 00 00 00 00 01 00 00 00
*US f0: 00 00 00 00 00 00 16 00 00 00 00 00 01 00 00 00
== hmm, 0xf6 bit 4/1 or 0xfc bit 0? ==
0xf6 is not modifiable, but 0xfc is, but HPET still cannot be enabled

Oh, my i815E P3 notebook (== ICH2, 8086:244c) does NOT allow me
to enable HPET either, the corresponding bit (on 0xD2, IIRC)
does not stick (since ICH3 is said to be the first chipset to enjoy
force-enable support, and I wanted to verify this).

About SiS support... SiS 964 is said to contain HPET support,
so possibly 963, 962, ... secretly have it, too?
Some of those might need some force-enabling as well...
I don't have any such machines, though, only a rotten SiS 735 board ;)
(the well-known K7S5A).

Andreas Mohr
