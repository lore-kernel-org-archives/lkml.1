Return-Path: <linux-kernel-owner+w=401wt.eu-S933885AbXG0JDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933885AbXG0JDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 05:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760016AbXG0JDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 05:03:08 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:41056 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758494AbXG0JDG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 05:03:06 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 4/5 v3] Add RapidIO support to powerpc architecture.
Date: Fri, 27 Jul 2007 17:03:01 +0800
Message-ID: <46B96294322F7D458F9648B60E15112C74D156@zch01exm26.fsl.freescale.net>
In-Reply-To: <FFA9FE6D-81C8-429C-A0CD-FE356CF98C69@kernel.crashing.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 4/5 v3] Add RapidIO support to powerpc architecture.
Thread-Index: AcfQJx11ZOSpIn8eROu3Na6uVHz3GgABDEIg
References: <11854393721520-git-send-email-wei.zhang@freescale.com> <11854393733580-git-send-email-wei.zhang@freescale.com> <11854393741899-git-send-email-wei.zhang@freescale.com> <11854393753986-git-send-email-wei.zhang@freescale.com> <11854393763547-git-send-email-wei.zhang@freescale.com> <FFA9FE6D-81C8-429C-A0CD-FE356CF98C69@kernel.crashing.org>
From: "Zhang Wei-r63237" <Wei.Zhang@freescale.com>
To: "Kumar Gala" <galak@kernel.crashing.org>
Cc: <mporter@kernel.crashing.org>, <paulus@samba.org>,
       <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kumar, 

> -----Original Message-----
> From: Kumar Gala [mailto:galak@kernel.crashing.org] 
> On Jul 26, 2007, at 3:42 AM, Zhang Wei wrote:
> 
> > This patch adds the RapidIO support to the powerpc architecture.
> > Some files are moved from ppc. OF-tree and OF-device supports are  
> > added.
> > New silicons such as MPC8548, MPC8641 with serial RapidIO  
> > controller are
> > all supported.
> > Memory driver hardware operations are added.
> > Global mport variables are changed to master port private variables.
> > Multi master ports are supported.
> >
> > Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
> > ---
> >  arch/powerpc/Kconfig          |    8 +
> >  arch/powerpc/kernel/Makefile  |    1 +
> >  arch/powerpc/kernel/rio.c     |   64 ++
> >  arch/powerpc/sysdev/Makefile  |    1 +
> >  arch/powerpc/sysdev/fsl_rio.c | 1455 
> ++++++++++++++++++++++++++++++ 
> > +++++++++++
> 
> how much of this moved from ppc85xx_rio.c?

>From the code size, 2/3 are moved from pcc85xx_rio.c with clean up, 1/3
are new coding.

> 
> >  arch/powerpc/sysdev/fsl_rio.h |   20 +
> >  6 files changed, 1549 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/powerpc/kernel/rio.c
> >  create mode 100644 arch/powerpc/sysdev/fsl_rio.c
> >  create mode 100644 arch/powerpc/sysdev/fsl_rio.h
> >
> > diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> > index 00099ef..45f32f1 100644
> > --- a/arch/powerpc/Kconfig
> > +++ b/arch/powerpc/Kconfig
> > @@ -492,6 +492,14 @@ source "drivers/pci/Kconfig"
> >
> >  source "drivers/pcmcia/Kconfig"
> >
> > +config RAPIDIO
> > +	bool "RapidIO support" if MPC8540 || MPC8560 || MPC8641 
> || MPC8548
> > +	help
> > +	  If you say Y here, the kernel will include drivers and
> > +	  infrastructure code to support RapidIO interconnect devices.
> 
> why not make this depend on something like HAS_RAPIDIO and let the  
> boards select HAS_RAPIDIO if they have it

It's more clear, We can know how many and which processors support
RapidIO. :-)

> 
> > +
> > +source "drivers/rapidio/Kconfig"
> > +
> >  source "drivers/pci/hotplug/Kconfig"
> >
> >  endmenu
> > diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/ 
> > Makefile
> > index 42c42ec..02d4100 100644
> > --- a/arch/powerpc/kernel/Makefile
> > +++ b/arch/powerpc/kernel/Makefile
> > @@ -70,6 +70,7 @@ pci64-$(CONFIG_PPC64)		+= 
> pci_64.o pci_dn.o isa- 
> > bridge.o
> >  pci32-$(CONFIG_PPC32)		:= pci_32.o
> >  obj-$(CONFIG_PCI)		+= $(pci64-y) $(pci32-y) pci-common.o
> >  obj-$(CONFIG_PCI_MSI)		+= msi.o
> > +obj-$(CONFIG_RAPIDIO)		+= rio.o
> 
> should probably live in sysdev/rio.c

This just keep the same position of ppc arch.

Thanks!
-zw
