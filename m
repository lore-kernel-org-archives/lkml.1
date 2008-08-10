Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbYHJHcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbYHJHcq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 03:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbYHJHcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 03:32:36 -0400
Received: from relay04.mail-hub.dodo.com.au ([123.2.6.239]:37296 "EHLO
	relay04.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752589AbYHJHcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 03:32:35 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: Grant Coady <gcoady.lk@gmail.com>
Cc: Grant Coady <gcoady.lk@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Grant Coady <gcoady.lk@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] cleanup Serial ATA and Parallel ATA Kconfig try3
Date: Sun, 10 Aug 2008 17:32:22 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <8a6t94tejebqrneini4dqml71b79mveo8e@4ax.com>
References: <njhp94pr4ha1nfgmj11n662enalpd9663h@4ax.com> <m3sktfw1v5.fsf@maximus.localdomain> <alpine.LFD.1.10.0808081911080.3254@localhost.localdomain> <20080809103331.1d475d5c@lxorguk.ukuu.org.uk> <m3zlnm75u1.fsf@maximus.localdomain> <20080809141028.14db9bc7@lxorguk.ukuu.org.uk> <m3skteuhod.fsf@maximus.localdomain> <20080809215918.32f25c4b@lxorguk.ukuu.org.uk> <nifs94lqm5a3qjr3rm2p9mks5tad33cbmi@4ax.com> <cu4t94hi8ei77t57vbmc9am4f2bpsrjtrh@4ax.com>
In-Reply-To: <cu4t94hi8ei77t57vbmc9am4f2bpsrjtrh@4ax.com>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



I'm sorry, please ignore this patch, it's busted :(  Tomorrow...


On Sun, 10 Aug 2008 17:10:17 +1000, Grant Coady <grant_lkml@dodo.com.au> wrote:

>On Sun, 10 Aug 2008 11:07:30 +1000, Grant Coady <grant_lkml@dodo.com.au> wrote:
>
>Okay, third time lucky?  This one brings back the indentation and is 
>smaller than the last patch too.
>
>Grant.
>
>
>From: Grant Coady <gcoady.lk@gmail.com>
>
>Cleanup ATA Kconfig, this patch replaces earlier RFC patches.
>
>Cleanup ATA Kconfig, hide the SFF option behind new PATA and SATA menu
>items, sort drivers into a single list, add missing "if unsure, say..."
>help text, this version gets the items indented in make menuconfig, some
>inconsistent text resolved, and one long (>80 col) help line split.
>
>Signed-off-by: Grant Coady <gcoady.lk@gmail.com>
>
>---
> Kconfig |  157 ++++++++++++++++------------------------------------------------
> 1 files changed, 40 insertions(+), 117 deletions(-)
>
>--- linux-2.6.27-rc2/drivers/ata/Kconfig	2008-07-14 07:51:29.000000000 +1000
>+++ linux-2.6.27-rc2d/drivers/ata/Kconfig	2008-08-10 17:05:01.906675949 +1000
>@@ -73,155 +73,78 @@
> 
> 	  If unsure, say N.
> 
>-config ATA_SFF
>-	bool "ATA SFF support"
>+config SATA_PMP
>+	bool "SATA Port Multiplier support"
> 	default y
> 	help
>-	  This option adds support for ATA controllers with SFF
>-	  compliant or similar programming interface.
>-
>-	  SFF is the legacy IDE interface that has been around since
>-	  the dawn of time.  Almost all PATA controllers have an
>-	  SFF interface.  Many SATA controllers have an SFF interface
>-	  when configured into a legacy compatibility mode.
>-
>-	  For users with exclusively modern controllers like AHCI,
>-	  Silicon Image 3124, or Marvell 6440, you may choose to
>-	  disable this uneeded SFF support.
>+	  This option adds support for SATA Port Multipliers
>+	  (the SATA version of an ethernet hub, or SAS expander).
> 
> 	  If unsure, say Y.
> 
>-if ATA_SFF
>-
>-config SATA_SVW
>-	tristate "ServerWorks Frodo / Apple K2 SATA support"
>-	depends on PCI
>-	help
>-	  This option enables support for Broadcom/Serverworks/Apple K2
>-	  SATA support.
>-
>-	  If unsure, say N.
>-
>-config ATA_PIIX
>-	tristate "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
>-	depends on PCI
>-	help
>-	  This option enables support for ICH5/6/7/8 Serial ATA
>-	  and support for PATA on the Intel ESB/ICH/PIIX3/PIIX4 series
>-	  host controllers.
>-
>-	  If unsure, say N.
>-
>-config SATA_MV
>-	tristate "Marvell SATA support (HIGHLY EXPERIMENTAL)"
>-	depends on EXPERIMENTAL
>-	help
>-	  This option enables support for the Marvell Serial ATA family.
>-	  Currently supports 88SX[56]0[48][01] chips.
>-
>-	  If unsure, say N.
>-
>-config SATA_NV
>-	tristate "NVIDIA SATA support"
>+config SATA_SIL24
>+	tristate "Silicon Image 3124/3132 SATA support"
> 	depends on PCI
> 	help
>-	  This option enables support for NVIDIA Serial ATA.
>+	  This option enables support for Silicon Image 3124/3132 Serial ATA.
> 
> 	  If unsure, say N.
> 
>-config PDC_ADMA
>-	tristate "Pacific Digital ADMA support"
>-	depends on PCI
>-	help
>-	  This option enables support for Pacific Digital ADMA controllers
>-
>-	  If unsure, say N.
>-
>-config SATA_QSTOR
>-	tristate "Pacific Digital SATA QStor support"
>-	depends on PCI
>-	help
>-	  This option enables support for Pacific Digital Serial ATA QStor.
>-
>-	  If unsure, say N.
>-
>-config SATA_PROMISE
>-	tristate "Promise SATA TX2/TX4 support"
>-	depends on PCI
>-	help
>-	  This option enables support for Promise Serial ATA TX2/TX4.
>-
>-	  If unsure, say N.
>-
>-config SATA_SX4
>-	tristate "Promise SATA SX4 support"
>-	depends on PCI && EXPERIMENTAL
>+config ATA_SFF_PATA
>+	bool "Parallel ATA (PATA) support"
>+	default y
> 	help
>-	  This option enables support for Promise Serial ATA SX4.
>-
>-	  If unsure, say N.
>+	  Say Y here if you want support for Parallel ATA (PATA) devices,
>+	  also known as IDE devices.
> 
>-config SATA_SIL
>-	tristate "Silicon Image SATA support"
>-	depends on PCI
>-	help
>-	  This option enables support for Silicon Image Serial ATA.
>+	  This option enables a list of available PATA drivers.
> 
>-	  If unsure, say N.
>+	  You may turn this option off if running AHCI or similar devices.
> 
>-config SATA_SIS
>-	tristate "SiS 964/965/966/180 SATA support"
>-	depends on PCI
>-	select PATA_SIS
>-	help
>-	  This option enables support for SiS Serial ATA on
>-	  SiS 964/965/966/180 and Parallel ATA on SiS 180.
>-	  The PATA support for SiS 180 requires additionally to
>-	  enable the PATA_SIS driver in the config.
>-	  If unsure, say N.
>+	  If unsure, say Y.
> 
>-config SATA_ULI
>-	tristate "ULi Electronics SATA support"
>-	depends on PCI
>+config ATA_SFF_SATA
>+	bool "Serial ATA (SATA) support"
>+	default y
> 	help
>-	  This option enables support for ULi Electronics SATA.
>+	  Say Y here if you want support for Serial ATA (SATA) devices.
> 
>-	  If unsure, say N.
>+	  This option enables a list of available SATA drivers.
> 
>-config SATA_VIA
>-	tristate "VIA SATA support"
>-	depends on PCI
>-	help
>-	  This option enables support for VIA Serial ATA.
>+	  You may turn this option off if running AHCI or similar devices.
> 
>-	  If unsure, say N.
>-
>-config SATA_VITESSE
>-	tristate "VITESSE VSC-7174 / INTEL 31244 SATA support"
>-	depends on PCI
>-	help
>-	  This option enables support for Vitesse VSC7174 and Intel 31244 Serial ATA.
>+	  If unsure, say Y.
> 
>-	  If unsure, say N.
>+config ATA_SFF
>+	bool
>+	default y
>+	depends on ATA_SFF_PATA || ATA_SFF_SATA
> 
>-config SATA_INIC162X
>-	tristate "Initio 162x SATA support"
>-	depends on PCI
>-	help
>-	  This option enables support for Initio 162x Serial ATA.
>+if ATA_SFF
> 
> config PATA_ACPI
> 	tristate "ACPI firmware driver for PATA"
>-	depends on ATA_ACPI
>+	depends on ATA_ACPI && ATA_SFF_PATA
> 	help
> 	  This option enables an ACPI method driver which drives
> 	  motherboard PATA controller interfaces through the ACPI
> 	  firmware in the BIOS. This driver can sometimes handle
> 	  otherwise unsupported hardware.
> 
>+	  If unsure, say Y.
>+
>+config PATA_ICSIDE
>+	tristate "Acorn ICS PATA support"
>+	depends on ARM && ARCH_ACORN && ATA_SFF_PATA
>+	help
>+	  On Acorn systems, say Y here if you wish to use the ICS PATA
>+	  interface card.  This is not required for ICS partition support.
>+
>+	  If unsure, say N.
>+
> config PATA_ALI
> 	tristate "ALi PATA support (Experimental)"
>-	depends on PCI && EXPERIMENTAL
>+	depends on PCI && ATA_SFF_PATA && EXPERIMENTAL
> 	help
> 	  This option enables support for the ALi ATA interfaces
> 	  found on the many ALi chipsets.

