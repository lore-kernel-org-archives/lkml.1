Return-Path: <linux-kernel-owner+w=401wt.eu-S1757787AbYFLJ1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787AbYFLJ1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 05:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbYFLJ11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 05:27:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37268 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213AbYFLJ1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 05:27:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH - supplement] PM: Remove remaining obsolete definitions from pm.h (was: Re: [PATCH 0/4] Remove some obsolete PM stuff)
Date: Thu, 12 Jun 2008 11:26:27 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200806121025.24668.rjw@sisk.pl>
In-Reply-To: <200806121025.24668.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806121126.27862.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Remove the remaining obsolete definitions from
include/linux/pm.h and move the definitions of PM_SUSPEND and
PM_RESUME to the header of h3600 which is the only user of them.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/asm-arm/arch-sa1100/h3600.h |    5 ++++
 include/linux/pm.h                  |   41 ------------------------------------
 2 files changed, 5 insertions(+), 41 deletions(-)

Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -26,52 +26,6 @@
 #include <asm/errno.h>
 
 /*
- * Power management requests... these are passed to pm_send_all() and friends.
- *
- * these functions are old and deprecated, see below.
- */
-typedef int __bitwise pm_request_t;
-
-#define PM_SUSPEND	((__force pm_request_t) 1)	/* enter D1-D3 */
-#define PM_RESUME	((__force pm_request_t) 2)	/* enter D0 */
-
-
-/*
- * Device types... these are passed to pm_register
- */
-typedef int __bitwise pm_dev_t;
-
-#define PM_UNKNOWN_DEV	((__force pm_dev_t) 0)	/* generic */
-#define PM_SYS_DEV	((__force pm_dev_t) 1)	/* system device (fan, KB controller, ...) */
-#define PM_PCI_DEV	((__force pm_dev_t) 2)	/* PCI device */
-#define PM_USB_DEV	((__force pm_dev_t) 3)	/* USB device */
-#define PM_SCSI_DEV	((__force pm_dev_t) 4)	/* SCSI device */
-#define PM_ISA_DEV	((__force pm_dev_t) 5)	/* ISA device */
-#define	PM_MTD_DEV	((__force pm_dev_t) 6)	/* Memory Technology Device */
-
-/*
- * System device hardware ID (PnP) values
- */
-enum
-{
-	PM_SYS_UNKNOWN = 0x00000000, /* generic */
-	PM_SYS_KBC =	 0x41d00303, /* keyboard controller */
-	PM_SYS_COM =	 0x41d00500, /* serial port */
-	PM_SYS_IRDA =	 0x41d00510, /* IRDA controller */
-	PM_SYS_FDC =	 0x41d00700, /* floppy controller */
-	PM_SYS_VGA =	 0x41d00900, /* VGA controller */
-	PM_SYS_PCMCIA =	 0x41d00e00, /* PCMCIA controller */
-};
-
-/*
- * Device identifier
- */
-#define PM_PCI_ID(dev) ((dev)->bus->number << 16 | (dev)->devfn)
-
-/* Functions above this comment are list-based old-style power
- * management. Please avoid using them.  */
-
-/*
  * Callbacks for platform drivers to implement.
  */
 extern void (*pm_idle)(void);
Index: linux-2.6/include/asm-arm/arch-sa1100/h3600.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-sa1100/h3600.h
+++ linux-2.6/include/asm-arm/arch-sa1100/h3600.h
@@ -23,6 +23,11 @@
 #ifndef _INCLUDE_H3600_H_
 #define _INCLUDE_H3600_H_
 
+typedef int __bitwise pm_request_t;
+
+#define PM_SUSPEND	((__force pm_request_t) 1)	/* enter D1-D3 */
+#define PM_RESUME	((__force pm_request_t) 2)	/* enter D0 */
+
 /* generalized support for H3xxx series Compaq Pocket PC's */
 #define machine_is_h3xxx() (machine_is_h3100() || machine_is_h3600() || machine_is_h3800())
 
