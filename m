Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbYGCVkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbYGCVkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756748AbYGCVgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:36:46 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48228 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754593AbYGCVge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:36:34 -0400
Message-Id: <20080703213634.107311480@attica.americas.sgi.com>
References: <20080703213348.489120321@attica.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 03 Jul 2008 16:34:01 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com
Subject: [patch 13/13] GRU Driver V3 -  driver/misc Makefile & Kconfig changes
Content-Disposition: inline; filename=grup_driver_misc_patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver/misc changes for the GRU driver


Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/Kconfig      |   23 +++++++++++++++++++++++
 drivers/misc/Makefile     |    1 +

---
 drivers/misc/Kconfig  |   23 +++++++++++++++++++++++
 drivers/misc/Makefile |    1 +
 2 files changed, 24 insertions(+)

Index: linux/drivers/misc/Kconfig
===================================================================
--- linux.orig/drivers/misc/Kconfig	2008-07-03 15:57:10.000000000 -0500
+++ linux/drivers/misc/Kconfig	2008-07-03 16:19:17.000000000 -0500
@@ -433,4 +433,27 @@ config SGI_XP
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
--- linux.orig/drivers/misc/Makefile	2008-07-03 15:57:10.000000000 -0500
+++ linux/drivers/misc/Makefile	2008-07-03 16:19:17.000000000 -0500
@@ -27,3 +27,4 @@ obj-$(CONFIG_INTEL_MENLOW)	+= intel_menl
 obj-$(CONFIG_ENCLOSURE_SERVICES) += enclosure.o
 obj-$(CONFIG_KGDB_TESTS)	+= kgdbts.o
 obj-$(CONFIG_SGI_XP)		+= sgi-xp/
+obj-$(CONFIG_SGI_GRU)		+= sgi-gru/

-- 
