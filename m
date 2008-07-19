Return-Path: <linux-kernel-owner+w=401wt.eu-S1752334AbYGSFMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbYGSFMi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 01:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbYGSFMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 01:12:30 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:60991 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750704AbYGSFM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 01:12:29 -0400
Date: Sat, 19 Jul 2008 01:12:27 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86,pci: dmi check for mackpro 2.2 mmconf
Message-ID: <20080719051227.GA10044@bromo.msbb.uc.edu>
References: <200807180941.09779.yhlu.kernel@gmail.com> <20080718202118.GC24122@elte.hu> <86802c440807181326l489b7763sdb040f5b6e575d8c@mail.gmail.com> <20080719005849.GA9055@bromo.msbb.uc.edu> <86802c440807181822l5138ff85k7d8c2e2702a11025@mail.gmail.com> <20080719032845.GA9662@bromo.msbb.uc.edu> <86802c440807182145s58ce6cb2xfc85a6fc849a2a73@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807182145s58ce6cb2xfc85a6fc849a2a73@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 09:45:08PM -0700, Yinghai Lu wrote:
> On Fri, Jul 18, 2008 at 8:28 PM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
> > YH,
> >   The mmconf_end_bus_num_detect.patch and mmconf_end_bus_num_detect_fix.patch both applied
> > cleanly to the current linus kernel git and solve my problems with MMCONFIG not starting.
> > I am attaching a dmesg log below of a boot with 'debug apic=verbose initcall_debug pci=routeirq'.
> > If you look at the section immediately before the line...
> >
> > pci 0000:00:1e.0: transparent bridge
> >
> > you will see that it is radically different from what I posted for the freeze under PCIEASPM
> > with MMCONFIG (using your original mmconfig patch)...
> 
> calling  pci_arch_init+0x0/0x53
> PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
> PCI: MCFG area at f0000000 reserved in E820
> PCI: updated MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
> PCI: Using MMCONFIG at f0000000 - f3ffffff
> PCI: Using configuration type 1 for base access
> initcall pci_arch_init+0x0/0x53 returned 0 after 14 msecs
> 
> that mean it reduce the bus number according to e820 reserved area.
> 
> YH

YH,
   Would that imply that this might be more fallout of the BIOS bug in the
MacBook Pro where insufficient address space is reserved for the number of
buses claimed? Is there some point in the PCIEASPM based code where you
could duplicate the same sort of fix? I would be happy to test any debug
patches that might help pinpoint where such a fix is needed.
                  Jack
