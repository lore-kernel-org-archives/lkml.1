Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbZDVHce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbZDVHce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 03:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZDVHcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 03:32:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:64641 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbZDVHcU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 03:32:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [BUILD FAILURE 11/12] Next April 21 : PPC64 randconfig [drivers/usb/host/ohci-hcd.o]
Date: Wed, 22 Apr 2009 09:30:00 +0200
User-Agent: KMail/1.9.9
Cc: David Brownell <david-b@pacbell.net>,
       Kumar Gala <galak@kernel.crashing.org>, subrata@linux.vnet.ibm.com,
       linux-usb@vger.kernel.org, Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next <linux-next@vger.kernel.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>, samr <sam@ravnborg.org>
References: <1240340081.9110.144.camel@subratamodak.linux.ibm.com> <200904211919.38104.david-b@pacbell.net> <49EE8855.1080306@oracle.com>
In-Reply-To: <49EE8855.1080306@oracle.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904220930.01735.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/gbSfm9RBrG1UigGBiobc3mhkRR/M/+CSkyuS
 edi/uqrzf7NK1qiJ72h0LOQnHiXEhc21ec9T+mm7Jst4erBif9
 wwQvhhkcZJYnvLiaRaUOQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 April 2009, Randy Dunlap wrote:
> > Is there maybe a way to force Kconfig to just reject
> > such illegal configs -- neither option set -- rather
> > than trying some how to fix it?
> 
> Not that I know of.  cc-ing Sam.

We could just make the USB_OHCI_HCD_PPC_OF option implicit
and selected only if at least one of USB_OHCI_HCD_PPC_OF_BE
and USB_OHCI_HCD_PPC_OF_LE are set.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 845479f..07e3e25 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -161,26 +161,26 @@ config USB_OHCI_HCD_PPC_SOC
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
+	default USB_OHCI_HCD_PPC_OF_BE || USB_OHCI_HCD_PPC_OF_LE
 
 config USB_OHCI_HCD_PCI
 	bool "OHCI support for PCI-bus USB controllers"
