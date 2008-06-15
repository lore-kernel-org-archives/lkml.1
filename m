Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbYFOOEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbYFOOEi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 10:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758070AbYFOOBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 10:01:21 -0400
Received: from relay1.sgi.com ([192.48.171.29]:47043 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757912AbYFOOAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 10:00:19 -0400
Message-Id: <20080615140014.480988078@attica.americas.sgi.com>
References: <20080615135906.091354918@attica.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jun 2008 08:59:19 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com
Subject: [patch 13/13] GRU Driver V2 - driver/misc Makefile & Kconfig changes
Content-Disposition: inline; filename=grup_driver_misc_patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver/misc changes for the GRU driver


Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/Kconfig      |   23 +++++++++++++++++++++++
 drivers/misc/Makefile     |    1 +

Index: linux/drivers/misc/Kconfig
===================================================================
--- linux.orig/drivers/misc/Kconfig	2008-06-13 08:09:08.546801081 -0500
+++ linux/drivers/misc/Kconfig	2008-06-13 14:55:29.422256132 -0500
@@ -408,4 +408,27 @@ config SGI_XP
 	  this feature will allow for direct communication between SSIs
 	  based on a network adapter and DMA messaging.
 
+config SGI_GRU
+	tristate "SGI GRU driver"
+	depends on (X86_64 || IA64_SGI_UV || IA64_GENERIC) && SMP
+	default n
+	select MMU_NOTIFIER
+	---help---
+	The GRU is a hardware resource located in the system chipset. The GRU
+	contains memory that can be mmapped into the user address space. This memory is
+	used to communicate with the GRU to perform functions such as load/store,
+	scatter/gather, bcopy, AMOs, etc.  The GRU is directly accessed by user
+	instructions using user virtual addresses. GRU instructions (ex., bcopy) use
+	user virtual addresses for operands.
+
+	If you are not running on a SGI UV system, say N.
+
+config SGI_GRU_DEBUG
+	bool  "SGI GRU driver debug"
+	depends on SGI_GRU
+	default n
+	---help---
+	This option enables addition debugging code for the SGI GRU driver. If
+	you are unsure, say N.
+
 endif # MISC_DEVICES
Index: linux/drivers/misc/Makefile
===================================================================
--- linux.orig/drivers/misc/Makefile	2008-06-13 08:09:08.554802083 -0500
+++ linux/drivers/misc/Makefile	2008-06-13 14:55:29.454260087 -0500
@@ -26,3 +26,4 @@ obj-$(CONFIG_INTEL_MENLOW)	+= intel_menl
 obj-$(CONFIG_ENCLOSURE_SERVICES) += enclosure.o
 obj-$(CONFIG_KGDB_TESTS)	+= kgdbts.o
 obj-$(CONFIG_SGI_XP)		+= sgi-xp/
+obj-$(CONFIG_SGI_GRU)		+= sgi-gru/

-- 
