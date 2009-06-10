Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbZFJAjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbZFJAjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 20:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbZFJAjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 20:39:14 -0400
Received: from smtp101.sbc.mail.gq1.yahoo.com ([67.195.15.60]:33464 "HELO
	smtp101.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753171AbZFJAjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 20:39:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=e9OcAUW68d454nih5PmQBCFm4VTje8qpaKLfyunZodKytZgAcldPuHzhHlddamsZ+AafEzDb5uXP++Cb+mQc/WR9jndg3dypTr0/7e5EBVEkZ23/pVLoM4e/xGUb/+Ci14axZIoZaFhlE4hjzCtvmlTpdNCPxKmnMuV9jnFBddw=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: WoGg3.IVM1mCMPByxCesIFQgXDf_ZfF_cGhq4pD1xZto9x54xv2FYY4AEwZU9bHBY4WZMAIOpnHzQx8.o7GbWt6Q71acFhWNs1WRyMXDhtcO6UbGAoQ.TtfOcOxWNckCOwOL6MXDxzWCvU.X7zgc4xGZtnOVDfhQSY72T3C3v0NsYp2Om_wP._Bcclx3mvsEDyp0lQyQAXRSaoOZT_I.16F0Owbs.9nJdzzfAcG._CkIIpifdW9idhvx5.vvBcF8WPU35.4BZCTWE1FnIdGIvoq.xt7N7VPP6x26z2dTr83KID.0INDpNbniXg4_6wCStsR_M6pzyA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Subrata Modak <subrata@linux.vnet.ibm.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [BUILD FAILURE 02/04] Next June 04:PPC64 randconfig [drivers/usb/host/ohci-hcd.o]
Date: Tue, 9 Jun 2009 17:38:57 -0700
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Kumar Gala <galak@kernel.crashing.org>,
       "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "Linux-Next" <linux-next@vger.kernel.org>,
       Jon Smirl <jonsmirl@gmail.com>,
       "Linuxppc-dev" <Linuxppc-dev@ozlabs.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, kernel@wantstofly.org
References: <20090605182651.24094.36577.sendpatchset@elm3a191.beaverton.ibm.com>
In-Reply-To: <20090605182651.24094.36577.sendpatchset@elm3a191.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906091738.58154.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 June 2009, Subrata Modak wrote:
> Correct, it fixes the issue. However, since few changes might have gone
> to the Kconfig, the patch does not apply cleanly. Below is the patch, just
> a retake of the earlier one, but on the latest code. 

And it got mangled a bit along the way.  Plus, the original one
goofed up Kconfig dependency displays ... both issues fixed in
this version, against current mainline GIT.

If someone can verify all four PPC/OF/OHCI configs build on
on PPC64, I'm OK with it.

- Dave


========== CUT HERE
From: Arnd Bergmann <arnd@arndb.de>
Subject: fix build failure for PPC64 randconfig [usb/ohci]

We could just make the USB_OHCI_HCD_PPC_OF option implicit
and selected only if at least one of USB_OHCI_HCD_PPC_OF_BE
and USB_OHCI_HCD_PPC_OF_LE are set.

[ dbrownell@users.sourceforge.net: fix patch manglation and dependencies ]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Resent-by: Subrata Modak <subrata@linux.vnet.ibm.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/usb/host/Kconfig |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -180,26 +180,27 @@ config USB_OHCI_HCD_PPC_SOC
 	  Enables support for the USB controller on the MPC52xx or
 	  STB03xxx processor chip.  If unsure, say Y.
 
-config USB_OHCI_HCD_PPC_OF
-	bool "OHCI support for PPC USB controller on OF platform bus"
-	depends on USB_OHCI_HCD && PPC_OF
-	default y
-	---help---
-	  Enables support for the USB controller PowerPC present on the
-	  OpenFirmware platform bus.
-
 config USB_OHCI_HCD_PPC_OF_BE
-	bool "Support big endian HC"
-	depends on USB_OHCI_HCD_PPC_OF
-	default y
+	bool "OHCI support for OF platform bus (big endian)"
+	depends on USB_OHCI_HCD && PPC_OF
 	select USB_OHCI_BIG_ENDIAN_DESC
 	select USB_OHCI_BIG_ENDIAN_MMIO
+	---help---
+	  Enables support for big-endian USB controllers present on the
+	  OpenFirmware platform bus.
 
 config USB_OHCI_HCD_PPC_OF_LE
-	bool "Support little endian HC"
-	depends on USB_OHCI_HCD_PPC_OF
-	default n
+	bool "OHCI support for OF platform bus (little endian)"
+	depends on USB_OHCI_HCD && PPC_OF
 	select USB_OHCI_LITTLE_ENDIAN
+	---help---
+	  Enables support for little-endian USB controllers present on the
+	  OpenFirmware platform bus.
+
+config USB_OHCI_HCD_PPC_OF
+	bool
+	depends on USB_OHCI_HCD && PPC_OF
+	default USB_OHCI_HCD_PPC_OF_BE || USB_OHCI_HCD_PPC_OF_LE
 
 config USB_OHCI_HCD_PCI
 	bool "OHCI support for PCI-bus USB controllers"

