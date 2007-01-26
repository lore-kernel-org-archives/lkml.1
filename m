Return-Path: <linux-kernel-owner+w=401wt.eu-S1030843AbXAZRSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030843AbXAZRSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 12:18:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030878AbXAZRSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 12:18:23 -0500
Received: from kepler.fjfi.cvut.cz ([147.32.6.11]:54064 "EHLO
	kepler.fjfi.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030843AbXAZRSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 12:18:22 -0500
Date: Fri, 26 Jan 2007 18:18:19 +0100 (CET)
From: Martin Drab <drab@kepler.fjfi.cvut.cz>
To: Luming Yu <luming.yu@gmail.com>
cc: Oleg Verych <olecom@flower.upol.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Intel PCI-E bridge ACPI resources and possibly related SATA
 unstability problems on ASUS A8Js
In-Reply-To: <3877989d0701260703q37bd586awabdeb172f63a8018@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0701261805031.8105@kepler.fjfi.cvut.cz>
References: <Pine.LNX.4.64.0701250142180.14408@kepler.fjfi.cvut.cz> 
 <E1HA1Se-0002Y3-VQ@flower>  <Pine.LNX.4.64.0701251325250.20484@kepler.fjfi.cvut.cz>
  <20070125135813.GB9917@flower.upol.cz>  <Pine.LNX.4.64.0701261320260.6213@kepler.fjfi.cvut.cz>
 <3877989d0701260703q37bd586awabdeb172f63a8018@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007, Luming Yu wrote:

> On 1/26/07, Martin Drab <drab@kepler.fjfi.cvut.cz> wrote:
> > On Thu, 25 Jan 2007, Oleg Verych wrote:
> > 
> > > On Thu, Jan 25, 2007 at 01:28:56PM +0100, Martin Drab wrote:
> > > > On Thu, 25 Jan 2007, Oleg Verych wrote:
> > > >
> > > > > gmane.linux.kernel:
> > > > > > recently I got my hands on an ASUS A8Js notebook (Core 2 Duo T7200,
> > > > > > Intel 945 PM PCI-E Chipset, for details see attached log). After
> > booting
> > > > > > the latest 2.6.20-rc5-git3 kernel (but the same behaviour occurs
> > also with
> > > > > > the 2.6.19.2, didn't try any other), some strange behaviour can be
> > > > > > observed.
> > > > >
> > > > > There were disscussions about mmconfig and what nightmare it brought
> > to
> > > > > PCI(E) configuration in scope of BIOS, chip bugs. Here's (one of)
> > such:
> > > > > <http://marc.theaimsgroup.com/?l=linux-kernel&m=116007091004503&w=2>
> > > > >
> > > > > > At first the following messages appear in the log:
> > > > > >
> > > > > > ...
> > >       [   40.303154] PCI: BIOS *Bug*: MCFG area at e0000000 is not
> > E820-reserved
> > > > > > [   40.303157] PCI: Not using MMCONFIG.
> > > > > >
> > > > > > (not sure whether this is really a problem)
> > > > >
> > > > > I think it may be the major problem.
> > > >
> > > > Hmm, it may be. Was there suggested any solution (or at least proposal)
> > > > that I may try?
> > >
> > > Try fix BIOS bugs: <http://permalink.gmane.org/gmane.linux.kernel/462632>
> > 
> > ASUS refused to help fixing the BIOS with words that ASUS notebooks do not
> > support Linux. So if we do not workaround this somehow, Linux would really
> > be unusable on this HW. :(
> > 
> Does pci=nommconf work for you. Also why not use memmap=exactmap  ...
> boot command line to workaround this bios bug?

pci=nommconf causes the two above-mentioned messages regarding MMCONFIG 
disapear, but otherwise everything behaves the same. Which makes me think 
whether the problem isn't somewhere else. Isn't it possible that it really 
is some other bug in the libata? Is anybody successfully using the 
sata_sil24 with SiI3132 and/or ata_piix with i945PM or simillar?

What exactly do messages like these mean?

-----------
[  231.828794] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
[  231.849673] ata3.00: (irq_stat 0x00020002, device error via D2H FIS)
[  231.871059] ata3.00: cmd c8/00:00:08:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 131072 in
[  231.871061]          res 51/84:00:08:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
[  232.217493] ata3: soft resetting port
[  232.318609] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  232.319782] ata3.00: configured for UDMA/100
[  232.319792] ata3: EH complete
-----------

Couldn't it be a problem somewhere else? Because strange is that it also 
apears for the ata_piix disk, which isn't (I think) on that PCI-E 
controller that fails to allocate the resources (the one that the 
ExpressCard uses). Or is it?


When I try memmap=exactmap kernel panics at immediatelly booting like 
this:

-----------
Decompressing Linux...done.
Booting the kernel.
Kernel alive
PANIC: early exception rip ffffffff8027a4f0 error 0 cr2 ffffffffff5fd030

-----------

and that's it. Can anybody explain me this panic?

Martin
