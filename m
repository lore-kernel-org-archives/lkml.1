Return-Path: <linux-kernel-owner+w=401wt.eu-S1756349AbYGSSTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbYGSSTc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 14:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbYGSSTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 14:19:24 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:46453 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755150AbYGSSTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 14:19:24 -0400
Date: Sat, 19 Jul 2008 14:19:21 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH] x86,pci: dmi check for mackpro 2.2 mmconf
Message-ID: <20080719181921.GB19250@bromo.msbb.uc.edu>
References: <200807180941.09779.yhlu.kernel@gmail.com> <20080719051227.GA10044@bromo.msbb.uc.edu> <86802c440807182228u5259eba1x238ec3af5fc4324c@mail.gmail.com> <200807191026.03172.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807191026.03172.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2008 at 10:26:02AM -0700, Jesse Barnes wrote:
> On Friday, July 18, 2008 10:28 pm Yinghai Lu wrote:
> > On Fri, Jul 18, 2008 at 10:12 PM, Jack Howarth
> >
> > <howarth@bromo.msbb.uc.edu> wrote:
> > >   Would that imply that this might be more fallout of the BIOS bug in the
> > > MacBook Pro where insufficient address space is reserved for the number
> > > of buses claimed?
> >
> > that is good enough with 64 buses like laptop.
> >
> > > Is there some point in the PCIEASPM based code where you
> > > could duplicate the same sort of fix? I would be happy to test any debug
> > > patches that might help pinpoint where such a fix is needed.
> >
> > Jesse, who is maintainer for ASPM code?
> 
> I've been looking to Shaohua (cc'd) for ASPM stuff.
> 
> Jesse

Jesse,
   I have just tried tip with CONFIG_PCIEASPM and I get the same hang as always.
I am currently using 'debug initcall_debug' as I can only see a limited number of
lines on my screen. These show...

PCI: 0000:00:1d.7 reg 10 32bit mmio: [d840500, d84057ff]
pci: 0000:00:1d.7 PME# supported from D0 D3hot D3cold
pci: 0000:00:1d.7 PME# disabled
pci: 0000:00:1f.0 quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci: 0000:00:1f.0 quirk: region 0500-053f claimed by ICH6 GPIO
PCI: 0000:00:1f.1 reg 10 io port: [40d8,40df]
PCI: 0000:00:1f.1 reg 14 io port: [40ec,40ef]
PCI: 0000:00:1f.1 reg 18 io port: [40d0,40d7]
PCI: 0000:00:1f.1 reg 1c io port: [40e8,40eb]
PCI: 0000:00:1f.1 reg 20 io port: [40b0,40bf]
PCI: 0000:00:1f.2 reg 10 io port: [40c8,40cf]
PCI: 0000:00:1f.2 reg 14 io port: [40e4,40e7]
PCI: 0000:00:1f.2 reg 18 io port: [40c0,40c7]
PCI: 0000:00:1f.2 reg 1c io port: [40e0,40e3]
PCI: 0000:00:1f.2 reg 20 io port: [40a0,40af]
PCI: 0000:00:1f.2 reg 24 32bit mmio: [d8405000,d84053ff]
pci: 0000:00:1f.2 PME# supported from D3hot
pci: 0000:00:1f.2 PME# disabled
PCI: 0000:00:1f.3 reg 20 io port [efa0,efbf]
PCI: 0000:01:00.0 reg 10 32bit mmio: [c0000000,cfffffff]
PCI: 0000:01:00.0 reg 14 io port: [3000,30ff]
PCI: 0000:01:00.0 reg 18 32bit mmio: [d8300000,d830ffff]
pci: 0000:01:00.0 : supports D1
pci: 0000:01:00.0 : supports D2

...at which point the machine freezes. If I boot tip with quiet, I happen to
see the message...

ACPI: EC: GPE Storm detected, disabling EC GPE

which I never haven't seen with 2.6.26 built without PCIEASPM. I also
have CONFIG_PCIEASPM_DEBUG set. What options to have have to pass to the
kernel when booting to cause that feature to spew useful info?
                          Jack
