Return-Path: <linux-kernel-owner+w=401wt.eu-S1758348AbXHGJC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348AbXHGJC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 05:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbXHGJCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 05:02:49 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:53345 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbXHGJCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 05:02:48 -0400
Date: Tue, 7 Aug 2007 11:02:47 +0200
From: Andreas Mohr <andi@lisas.de>
To: Rafa?? Bilski <rafalbilski@interia.pl>
Cc: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       Andreas Mohr <andi@lisas.de>, David Edwards <powertop@dpe.lusars.net>,
       power@bughost.org, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: HPET force-enable investigations on Via VT8235
Message-ID: <20070807090247.GA5806@rhlx01.hs-esslingen.de>
References: <20070806204249.GA25957@rhlx01.hs-esslingen.de> <46B79512.6090704@interia.pl> <20070806235752.1e6c5653@laptop.hypervisor.org> <46B82F2B.7010704@interia.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B82F2B.7010704@interia.pl>
X-Priority: none
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 07, 2007 at 10:36:59AM +0200, Rafa?? Bilski wrote:
> >RB> VT8235 does *NOT* have a HPET(*). Only part which has HPET is VT8237. 
> >It
> >RB> is device 00:17.0 too, but only 1106:3227 has HPET enable and memory
> >RB> base registers. VT8235 one and only feature which doesn't have driver
> >RB> yet seems to be hardware watchdog.
> >RB> (*) Datasheet revision 2.03 March 16, 2005
> >
> >We have an Asrock K7VT4A+ board with VT8235 southbridge in our lab and it
> >does have an HPET. Just because the datasheet does not document HPET does
> >not mean it is not implemented.
> >
> >My guess is that newer revisions of VT8235 have HPET whereas older 
> >revisions
> >do not. I'll get an lspci dump from our box tomorrow.
> Indeed datasheet lies. I have VIA EPIA M10000 Rev. B motherboard.

Many datasheets are incorrect and don't follow realities of chipset
design evolution. Which is why I started this quest in the first place ;)

> % dmesg | grep -i hpet
> Force enabled HPET at base address 0xfed00000
> hpet clockevent registered
> hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> hpet0: 3 32-bit timers, 14318180 Hz
> Time: hpet clocksource has been installed.

Lucky bastard! :)

> 00: 06 11 77 31 87 00 10 02 00 00 01 06 00 00 80 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 06 11 01 aa
> 30: 00 00 00 00 c0 00 00 00 00 00 00 00 00 00 00 00
> 40: 45 00 f0 00 00 00 00 00 0c 20 00 00 44 00 0a 08
> 50: 81 1d 09 00 00 b0 a5 30 03 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 04 80 00 d0 fe 00 00 00 00
> 70: 06 11 01 aa 00 00 00 00 00 00 00 00 20 00 00 00
> 80: 20 84 59 00 b2 30 00 00 01 04 00 00 00 18 00 00
> 90: 00 1f 50 88 b0 c0 00 00 00 97 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 01 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 01 05 01 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 14 88 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 16 00 00 00 00 00 01 00 00 00

Thanks a lot!
I'll do a diff on this versus the "non-working"
dumps and have a peek at the VT8235/VT8237 datasheet
to see whether there can something be done about it.
I still don't entirely buy the "different chipset revision"
theory, hopefully I'm correct and it's just another bit to
tweak (but hopefully it's not a "write-only" bit that needs
tweaking...).

BTW, is there any obvious chipset ecosystem difference
in your system? Are any other important PCI IDs/revs
different from mine?

Further working/non-working dumps greatly appreciated!

Andreas Mohr
