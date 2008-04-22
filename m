Return-Path: <linux-kernel-owner+w=401wt.eu-S1763915AbYDVNLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763915AbYDVNLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763667AbYDVNLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:11:13 -0400
Received: from h155.mvista.com ([63.81.120.155]:29001 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763653AbYDVNLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:11:08 -0400
Message-ID: <480DE3C4.5@ru.mvista.com>
Date: Tue, 22 Apr 2008 17:10:28 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, htejun@gmail.com
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [2.6 patch] select ATA_SFF
References: <20080421213147.GH2633@cs181133002.pp.htv.fi>
In-Reply-To: <20080421213147.GH2633@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Adrian Bunk wrote:

> Making ATA_SFF a user-visible option with the drivers needing it
> depending on it caused the following problems:
> - people lose their driver when accidentally disabling it
> - people not requiring it needlessly enable it

> Fortunately, we don't have to bother the user with this option at all
> since we can simply select it when it's required.

> Signed-off-by: Adrian Bunk <bunk@kernel.org>

[...]

> @@ -132,6 +119,7 @@ config SATA_NV
>  config PDC_ADMA
>  	tristate "Pacific Digital ADMA support"
>  	depends on PCI
> +	select ATA_SFF
>  	help
>  	  This option enables support for Pacific Digital ADMA controllers

    ADMA is not SFF-8038i compilant, it's the IDE DMA spec of its own. And I'm 
seeing references to libata-sff.c... confusing.

> @@ -248,6 +249,7 @@ config PATA_ARTOP
>  config PATA_AT32
>  	tristate "Atmel AVR32 PATA support (Experimental)"
>  	depends on AVR32 && PLATFORM_AT32AP && EXPERIMENTAL
> +	select ATA_SFF
>  	help
>  	  This option enables support for the IDE devices on the
>  	  Atmel AT32AP platform.

    I'm seeing no DMA support here... yet there are calls to

> @@ -266,6 +269,7 @@ config PATA_ATIIXP
>  config PATA_CMD640_PCI
>  	tristate "CMD640 PCI PATA support (Very Experimental)"
>  	depends on PCI && EXPERIMENTAL
> +	select ATA_SFF
>  	help
>  	  This option enables support for the CMD640 PCI IDE
>  	  interface chip. Only the primary channel is currently

    PIO only chip... yet its driver seems to call libata-sff.c...

> @@ -285,6 +290,7 @@ config PATA_CMD64X
>  config PATA_CS5520
>  	tristate "CS5510/5520 PATA support"
>  	depends on PCI
> +	select ATA_SFF
>  	help
>  	  This option enables support for the Cyrix 5510/5520
>  	  companion chip used with the MediaGX/Geode processor family.

    These chips are PIO only. Yet the driver calls libata-sff.c, hm...

> @@ -375,6 +390,7 @@ config PATA_HPT3X2N
>  config PATA_HPT3X3
>  	tristate "HPT 343/363 PATA support"
>  	depends on PCI
> +	select ATA_SFF
>  	help
>  	  This option enables support for the HPT 343/363
>  	  PATA controllers via the new ATA layer
> @@ -384,6 +400,7 @@ config PATA_HPT3X3
>  config PATA_HPT3X3_DMA
>  	bool "HPT 343/363 DMA support (Experimental)"
>  	depends on PATA_HPT3X3
> +	select ATA_SFF

    I don't think this 'select' is needed, since it's not on option that 
enables the driver itself, just DMA support in it.

>  	help
>  	  This option enables DMA support for the HPT343/363
>  	  controllers. Enable with care as there are still some
> @@ -392,6 +409,7 @@ config PATA_HPT3X3_DMA
>  config PATA_ISAPNP
>  	tristate "ISA Plug and Play PATA support (Experimental)"
>  	depends on EXPERIMENTAL && ISAPNP
> +	select ATA_SFF
>  	help
>  	  This option enables support for ISA plug & play ATA
>  	  controllers such as those found on old soundcards.

    PnP IDE is not SFF-8038i compliant, and not DMA capable, IIUC.

> @@ -429,6 +450,7 @@ config PATA_JMICRON
>  config PATA_LEGACY
>  	tristate "Legacy ISA PATA support (Experimental)"
>  	depends on ISA && EXPERIMENTAL
> +	select ATA_SFF
>  	help
>  	  This option enables support for ISA/VLB bus legacy PATA
>  	  ports and allows them to be accessed via the new ATA layer.

    PIO only driver, no SFF-8038i stuff... but calls libata-sff.c, hm...

> @@ -456,6 +480,7 @@ config PATA_MARVELL
>  config PATA_MPC52xx
>  	tristate "Freescale MPC52xx SoC internal IDE"
>  	depends on PPC_MPC52xx
> +	select ATA_SFF
>  	help
>  	  This option enables support for integrated IDE controller
>  	  of the Freescale MPC52xx SoC.

    DMA is not SFF-8038i compliant -- however it calls libata-sff.c...

> @@ -465,6 +490,7 @@ config PATA_MPC52xx
>  config PATA_MPIIX
>  	tristate "Intel PATA MPIIX support"
>  	depends on PCI
> +	select ATA_SFF
>  	help
>  	  This option enables support for MPIIX PATA support.

    PIO only, no SFF-8038i compliant registers. Yet it calls liabat-sff.c...

> @@ -490,6 +518,7 @@ config PATA_NETCELL
>  config PATA_NINJA32
>  	tristate "Ninja32/Delkin Cardbus ATA support (Experimental)"
>  	depends on PCI && EXPERIMENTAL
> +	select ATA_SFF
>  	help
>  	  This option enables support for the Ninja32, Delkin and
>  	  possibly other brands of Cardbus ATA adapter

    BMDMA here is not SFF-8038i compatible. Uses libata-sff.c though, it seems...

> @@ -499,6 +528,7 @@ config PATA_NINJA32
>  config PATA_NS87410
>  	tristate "Nat Semi NS87410 PATA support (Experimental)"
>  	depends on PCI && EXPERIMENTAL
> +	select ATA_SFF
>  	help
>  	  This option enables support for the National Semiconductor
>  	  NS87410 PCI-IDE controller.

    PIO only driver, no SFF-8038i compatible registers. Seems to be calling 
libata-sff.c though...

> @@ -517,6 +548,7 @@ config PATA_NS87415
>  config PATA_OPTI
>  	tristate "OPTI621/6215 PATA support (Very Experimental)"
>  	depends on PCI && EXPERIMENTAL
> +	select ATA_SFF
>  	help
>  	  This option enables full PIO support for the early Opti ATA
>  	  controllers found on some old motherboards.

    PIO only driver, not SFF-8038i compliant. Seems to be calling libata-sff.c...

> @@ -536,6 +569,7 @@ config PATA_OPTIDMA
>  config PATA_PCMCIA
>  	tristate "PCMCIA PATA support"
>  	depends on PCMCIA
> +	select ATA_SFF
>  	help
>  	  This option enables support for PCMCIA ATA interfaces, including
>  	  compact flash card adapters via the new ATA layer.

    PCMCIA driver is PIO only, not SFF-8038i "by definition" since it's not 
PCI. Yet seems to call libab-sff.c...

> @@ -554,12 +589,14 @@ config PATA_PDC_OLD
>  config PATA_QDI
>  	tristate "QDI VLB PATA support"
>  	depends on ISA
> +	select ATA_SFF
>  	help
>  	  Support for QDI 6500 and 6580 PATA controllers on VESA local bus.

    QDI6580 is VLB PIO only driver -- therefore not SFF-8038i compliant.

> @@ -578,6 +616,7 @@ config PATA_RB500
>  config PATA_RZ1000
>  	tristate "PC Tech RZ1000 PATA support"
>  	depends on PCI
> +	select ATA_SFF
>  	help
>  	  This option enables basic support for the PC Tech RZ1000/1
>  	  PATA controllers via the new ATA layer

    RZ1000 is PIO only, IIRC -- no SFF-8038i registers.

> @@ -647,6 +693,7 @@ config PATA_WINBOND
>  config PATA_WINBOND_VLB
>  	tristate "Winbond W83759A VLB PATA support (Experimental)"
>  	depends on ISA && EXPERIMENTAL
> +	select ATA_SFF
>  	help
>  	  Support for the Winbond W83759A controller on Vesa Local Bus
>  	  systems.

    This is VLB PIO only driver -- no SFF-8038i. Seems to call libata-sff.c 
though...

> @@ -673,6 +722,7 @@ config PATA_OF_PLATFORM
>  config PATA_ICSIDE
>  	tristate "Acorn ICS PATA support"
>  	depends on ARM && ARCH_ACORN
> +	select ATA_SFF
>  	help
>  	  On Acorn systems, say Y here if you wish to use the ICS PATA
>  	  interface card.  This is not required for ICS partition support.

    ICS is not SFF-8038i compliant. However it calls libata-sff.c... go figure.

> @@ -691,6 +742,7 @@ config PATA_IXP4XX_CF
>  config PATA_SCC
>  	tristate "Toshiba's Cell Reference Set IDE support"
>  	depends on PCI && PPC_CELLEB
> +	select ATA_SFF

    SCC PATA is not SFF-8038i compliant. Seem to calls libata-sff.c however...

>  	help
>  	  This option enables support for the built-in IDE controller on
>  	  Toshiba Cell Reference Board.

    Looks like there's no clean separation within libata-sff.c itself between 
SFF-8038i (BMDMA spec) and IDE registers itself -- that confused me: at first 
I thought there's a big issue with a patch. :-/

    Jeff, Tejun, what "sff" in the file name actually means? Isn't it strange 
that the drivers lacking DMA support or not really compliant with SFF-8038i 
have to link with this file?

MBR, Sergei
