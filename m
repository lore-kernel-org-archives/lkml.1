Return-Path: <linux-kernel-owner+w=401wt.eu-S1750910AbXBFHNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750910AbXBFHNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 02:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbXBFHNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 02:13:23 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:43507 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbXBFHNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 02:13:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZzPjj/RbBBAH1T4IFIIeTFyKfWGYTo7yfMLkUbnyZUCbWngO6aCL8P+8cKtDhCx1caFsU0JESJWCGFI2Nl4nUe2kgDg7Yhko/zl+9G8KcRhwP1b6OnmsLKpPZaDUAaG8SpVRwWQzcU4DIdcBg7/SvXOYaosbO73spRDxDJQWf8A=
Message-ID: <1a297b360702052313g490a5e38jd7a227005375930f@mail.gmail.com>
Date: Tue, 6 Feb 2007 11:13:21 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Grant Grundler" <grundler@parisc-linux.org>
Subject: Re: 2.6.20 PCI Cannot allocate resource region 2
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, greg@kroah.com
In-Reply-To: <20070206070456.GA20752@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1a297b360702041709l3b0309c7y8fcd33df1d487889@mail.gmail.com>
	 <20070206045528.GA4228@colo.lackof.org>
	 <20070206050331.GB4228@colo.lackof.org>
	 <20070205213339.80239a22.akpm@linux-foundation.org>
	 <1a297b360702052228r2b3eb84bpa2d3d836f5777456@mail.gmail.com>
	 <20070206070456.GA20752@colo.lackof.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/6/07, Grant Grundler <grundler@parisc-linux.org> wrote:
> On Tue, Feb 06, 2007 at 10:28:56AM +0400, Manu Abraham wrote:
> > On 2/6/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > >On Mon, 5 Feb 2007 22:03:31 -0700 Grant Grundler
> > ><grundler@parisc-linux.org> wrote:
> > >
> > >> On Mon, Feb 05, 2007 at 09:55:28PM -0700, Grant Grundler wrote:
> > >> ...
> > >> > >   Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
> > >ParErr- Stepping- SERR- FastB2B-
> > >> > >   Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> > ><TAbort- <MAbort- >SERR+ <PERR+
> > >> > >   Latency: 0, Cache Line Size 0c
> > >> > >   BIST is running
> > >> >
> > >> > BIST is required to complete in 2 seconds. Either with success or
> > >failure.
> > >> > I expect BIOS to have complained before launching grub/lilo.
> > >>
> > >> Gregkh,
> > >> I just realized linux-pci bus scan should ignore devices (print a
> > >warning)
> > >> which have BIST set.  Want a patch for this?
> > >>
> > >> Slight risk some previously "working" device which violates the
> > >> spec might get ignored...but I hope there aren't too many of those.
> > >
> > >Should we wait two seconds before declaring the device dead?  To see
> > >whether
> > >it will come back?
> > >
> >
> >
> > Wonders !
> >
> > I was about to give the card it's last rites. I thought well let me
> > try under the other OS
>
> Could you be more specific? Which OS? FreeBSD? :)
>


Hehe, we don't get question marks and stuff like that for those OS 's .. ;-)

M$ XP SP2


>
> > I didn't have any drivers for the same, since the demodulator driver
> > doesn't exist in the other OS also, but the bridge device does have
> > the driver.
> >
> > I plugged the card in, the OS searched for drivers, since i didn't
> > have any didn't load any..
> > So it went under a question mark.
> >
> > Looking under Resources,
> >
> > It showed the PCI information string like this ..
> >
> > PCI\VEN_1822&DEV_4E35&SUBSYS_00311822&REV_01\4&2E98101C&0&10F0
> >
> > then i thought try with the driver eventhough support for the
> > demodulator doesn't exist ..
> >
> > Downloaded and installed drivers ..
> >
> > Lo ..!
> >
> > Memory Range: F87FF000 - F87FFFFF
> > IRQ : 17
> >
> > it got assigned a memory region indeed.
>
> Excellent.
>
> > So, to wrap it up, the device is not dead .. We have something wrong
> > in the PCI subsystem probably.
>
> Hrm maybe but not likely. I'm more inclined to believe PCI subsystem
> is missing hacks needed for that device and/or BIOS.
>

I have access to the source there, but there are no PCI specific
stuff, i think the NT HAL just handles all the PCI stuff over there.

It would be great , if we could have the missing hacks under Linux as well.

> grant
>

regards,
manu
