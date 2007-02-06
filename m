Return-Path: <linux-kernel-owner+w=401wt.eu-S1750905AbXBFHFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750905AbXBFHFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 02:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbXBFHFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 02:05:06 -0500
Received: from colo.lackof.org ([198.49.126.79]:55924 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbXBFHFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 02:05:04 -0500
Date: Tue, 6 Feb 2007 00:04:56 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       greg@kroah.com
Subject: Re: 2.6.20 PCI Cannot allocate resource region 2
Message-ID: <20070206070456.GA20752@colo.lackof.org>
References: <1a297b360702041709l3b0309c7y8fcd33df1d487889@mail.gmail.com> <20070206045528.GA4228@colo.lackof.org> <20070206050331.GB4228@colo.lackof.org> <20070205213339.80239a22.akpm@linux-foundation.org> <1a297b360702052228r2b3eb84bpa2d3d836f5777456@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a297b360702052228r2b3eb84bpa2d3d836f5777456@mail.gmail.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 10:28:56AM +0400, Manu Abraham wrote:
> On 2/6/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> >On Mon, 5 Feb 2007 22:03:31 -0700 Grant Grundler 
> ><grundler@parisc-linux.org> wrote:
> >
> >> On Mon, Feb 05, 2007 at 09:55:28PM -0700, Grant Grundler wrote:
> >> ...
> >> > >   Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> >ParErr- Stepping- SERR- FastB2B-
> >> > >   Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
> ><TAbort- <MAbort- >SERR+ <PERR+
> >> > >   Latency: 0, Cache Line Size 0c
> >> > >   BIST is running
> >> >
> >> > BIST is required to complete in 2 seconds. Either with success or 
> >failure.
> >> > I expect BIOS to have complained before launching grub/lilo.
> >>
> >> Gregkh,
> >> I just realized linux-pci bus scan should ignore devices (print a 
> >warning)
> >> which have BIST set.  Want a patch for this?
> >>
> >> Slight risk some previously "working" device which violates the
> >> spec might get ignored...but I hope there aren't too many of those.
> >
> >Should we wait two seconds before declaring the device dead?  To see 
> >whether
> >it will come back?
> >
> 
> 
> Wonders !
> 
> I was about to give the card it's last rites. I thought well let me
> try under the other OS

Could you be more specific? Which OS? FreeBSD? :)


> I didn't have any drivers for the same, since the demodulator driver
> doesn't exist in the other OS also, but the bridge device does have
> the driver.
> 
> I plugged the card in, the OS searched for drivers, since i didn't
> have any didn't load any..
> So it went under a question mark.
> 
> Looking under Resources,
> 
> It showed the PCI information string like this ..
> 
> PCI\VEN_1822&DEV_4E35&SUBSYS_00311822&REV_01\4&2E98101C&0&10F0
> 
> then i thought try with the driver eventhough support for the
> demodulator doesn't exist ..
> 
> Downloaded and installed drivers ..
> 
> Lo ..!
> 
> Memory Range: F87FF000 - F87FFFFF
> IRQ : 17
> 
> it got assigned a memory region indeed.

Excellent.

> So, to wrap it up, the device is not dead .. We have something wrong
> in the PCI subsystem probably.

Hrm maybe but not likely. I'm more inclined to believe PCI subsystem
is missing hacks needed for that device and/or BIOS.

grant
