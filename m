Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbXFCOn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbXFCOn0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 10:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbXFCOlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 10:41:06 -0400
Received: from web50110.mail.re2.yahoo.com ([206.190.38.38]:33834 "HELO
	web50110.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755250AbXFCOlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 10:41:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=1uUOWRphcZ8Y2ylXaXhfeHOk96EX416UiskF75NtOWtNeLaWBvIsH0C0iKalVB/qhisoutFfH/WrJ6YlN8PNLzdNzxFxnWrSlnZuLx33yendsjub79rklFpgcCATDjiI+glzyXdNpHkdj6b4eKd5tCi+6yiHAkQDP8pzKiFZx4M=;
X-YMail-OSG: 73a.0FgVM1kGVRcu9HPu_rDih2qdznrN_OT1eso576T27GtFkrPQ6RDSK9igABl_af4qBOpidEH2u3dKNwzE.javP4M0Ql2PK9qTv1aKko19mN0-
Date: Sun, 3 Jun 2007 07:41:01 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: [PATCH 13/36] drivers edac mod to include edac_core.h
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <846409.47248.qm@web50110.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Douglas Thompson <dougthompson@xmission.com>

In the refactoring of edac_mc.c into several subsystem files,
the header file edac_mc.h became meaningless. A new header file
edac_core.h was created. All the files that previously included
"edac_mc.h" are changed to include "edac_core.h".


Signed-off-by:	Douglas Thompson <dougthompson@xmission.com>
---
 amd76x_edac.c     |    4 ++--
 e752x_edac.c      |    4 ++--
 e7xxx_edac.c      |    4 ++--
 edac_mc.c         |    2 +-
 edac_mc_sysfs.c   |    2 +-
 edac_module.c     |    4 ++--
 edac_pci_sysfs.c  |    4 ++--
 i5000_edac.c      |    4 ++--
 i82443bxgx_edac.c |    2 +-
 i82860_edac.c     |    4 ++--
 i82875p_edac.c    |    4 ++--
 r82600_edac.c     |    4 ++--
 12 files changed, 21 insertions(+), 21 deletions(-)

---
Index: linux-2.6.21.1/drivers/edac/amd76x_edac.c
===================================================================
--- linux-2.6.21.1.orig/drivers/edac/amd76x_edac.c
+++ linux-2.6.21.1/drivers/edac/amd76x_edac.c
@@ -17,9 +17,9 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
-#include "edac_mc.h"
+#include "edac_core.h"
 
-#define AMD76X_REVISION	" Ver: 2.0.1 "  __DATE__
+#define AMD76X_REVISION	" Ver: 2.0.2 "  __DATE__
 #define EDAC_MOD_STR	"amd76x_edac"
 
 #define amd76x_printk(level, fmt, arg...) \
Index: linux-2.6.21.1/drivers/edac/e752x_edac.c
===================================================================
--- linux-2.6.21.1.orig/drivers/edac/e752x_edac.c
+++ linux-2.6.21.1/drivers/edac/e752x_edac.c
@@ -23,9 +23,9 @@
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
 #include <linux/edac.h>
-#include "edac_mc.h"
+#include "edac_core.h"
 
-#define E752X_REVISION	" Ver: 2.0.1 " __DATE__
+#define E752X_REVISION	" Ver: 2.0.2 " __DATE__
 #define EDAC_MOD_STR	"e752x_edac"
 
 static int force_function_unhide;
Index: linux-2.6.21.1/drivers/edac/edac_mc.c
===================================================================
--- linux-2.6.21.1.orig/drivers/edac/edac_mc.c
+++ linux-2.6.21.1/drivers/edac/edac_mc.c
@@ -31,7 +31,7 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/edac.h>
-#include "edac_mc.h"
+#include "edac_core.h"
 #include "edac_module.h"
 
 
Index: linux-2.6.21.1/drivers/edac/edac_mc_sysfs.c
===================================================================
--- linux-2.6.21.1.orig/drivers/edac/edac_mc_sysfs.c
+++ linux-2.6.21.1/drivers/edac/edac_mc_sysfs.c
@@ -12,7 +12,7 @@
 #include <linux/sysdev.h>
 #include <linux/ctype.h>
 
-#include "edac_mc.h"
+#include "edac_core.h"
 #include "edac_module.h"
 
 /* MC EDAC Controls, setable by module parameter, and sysfs */
Index: linux-2.6.21.1/drivers/edac/edac_module.c
===================================================================
--- linux-2.6.21.1.orig/drivers/edac/edac_module.c
+++ linux-2.6.21.1/drivers/edac/edac_module.c
@@ -3,10 +3,10 @@
 #include <linux/kthread.h>
 #include <linux/edac.h>
 
-#include "edac_mc.h"
+#include "edac_core.h"
 #include "edac_module.h"
 
-#define EDAC_MC_VERSION "Ver: 2.0.3" __DATE__
+#define EDAC_MC_VERSION "Ver: 2.0.4 " __DATE__
 
 #ifdef CONFIG_EDAC_DEBUG
 /* Values of 0 to 4 will generate output */
Index: linux-2.6.21.1/drivers/edac/edac_pci_sysfs.c
===================================================================
--- linux-2.6.21.1.orig/drivers/edac/edac_pci_sysfs.c
+++ linux-2.6.21.1/drivers/edac/edac_pci_sysfs.c
@@ -1,4 +1,4 @@
-/* edac_mc kernel module
+/*
  * (C) 2005, 2006 Linux Networx (http://lnxi.com)
  * This file may be distributed under the terms of the
  * GNU General Public License.
@@ -10,7 +10,7 @@
 #include <linux/sysdev.h>
 #include <linux/ctype.h>
 
-#include "edac_mc.h"
+#include "edac_core.h"
 #include "edac_module.h"
 
 
Index: linux-2.6.21.1/drivers/edac/i5000_edac.c
===================================================================
--- linux-2.6.21.1.orig/drivers/edac/i5000_edac.c
+++ linux-2.6.21.1/drivers/edac/i5000_edac.c
@@ -22,12 +22,12 @@
 #include <linux/edac.h>
 #include <asm/mmzone.h>
 
-#include "edac_mc.h"
+#include "edac_core.h"
 
 /*
  * Alter this version for the I5000 module when modifications are made
  */
-#define I5000_REVISION    " Ver: 2.0.11.devel " __DATE__
+#define I5000_REVISION    " Ver: 2.0.12 " __DATE__
 
 #define i5000_printk(level, fmt, arg...) \
         edac_printk(level, "i5000", fmt, ##arg)
Index: linux-2.6.21.1/drivers/edac/i82443bxgx_edac.c
===================================================================
--- linux-2.6.21.1.orig/drivers/edac/i82443bxgx_edac.c
+++ linux-2.6.21.1/drivers/edac/i82443bxgx_edac.c
@@ -29,7 +29,7 @@
 
 #include <linux/slab.h>
 
-#include "edac_mc.h"
+#include "edac_core.h"
 
 #define I82443_REVISION	"0.1"
 
Index: linux-2.6.21.1/drivers/edac/i82860_edac.c
===================================================================
--- linux-2.6.21.1.orig/drivers/edac/i82860_edac.c
+++ linux-2.6.21.1/drivers/edac/i82860_edac.c
@@ -14,9 +14,9 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
-#include "edac_mc.h"
+#include "edac_core.h"
 
-#define  I82860_REVISION " Ver: 2.0.1 " __DATE__
+#define  I82860_REVISION " Ver: 2.0.2 " __DATE__
 #define EDAC_MOD_STR	"i82860_edac"
 
 #define i82860_printk(level, fmt, arg...) \
Index: linux-2.6.21.1/drivers/edac/i82875p_edac.c
===================================================================
--- linux-2.6.21.1.orig/drivers/edac/i82875p_edac.c
+++ linux-2.6.21.1/drivers/edac/i82875p_edac.c
@@ -18,9 +18,9 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
-#include "edac_mc.h"
+#include "edac_core.h"
 
-#define I82875P_REVISION	" Ver: 2.0.1 " __DATE__
+#define I82875P_REVISION	" Ver: 2.0.2 " __DATE__
 #define EDAC_MOD_STR		"i82875p_edac"
 
 #define i82875p_printk(level, fmt, arg...) \
Index: linux-2.6.21.1/drivers/edac/r82600_edac.c
===================================================================
--- linux-2.6.21.1.orig/drivers/edac/r82600_edac.c
+++ linux-2.6.21.1/drivers/edac/r82600_edac.c
@@ -20,9 +20,9 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
-#include "edac_mc.h"
+#include "edac_core.h"
 
-#define R82600_REVISION	" Ver: 2.0.1 " __DATE__
+#define R82600_REVISION	" Ver: 2.0.2 " __DATE__
 #define EDAC_MOD_STR	"r82600_edac"
 
 #define r82600_printk(level, fmt, arg...) \
Index: linux-2.6.21.1/drivers/edac/e7xxx_edac.c
===================================================================
--- linux-2.6.21.1.orig/drivers/edac/e7xxx_edac.c
+++ linux-2.6.21.1/drivers/edac/e7xxx_edac.c
@@ -28,9 +28,9 @@
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
 #include <linux/edac.h>
-#include "edac_mc.h"
+#include "edac_core.h"
 
-#define	E7XXX_REVISION " Ver: 2.0.1 " __DATE__
+#define	E7XXX_REVISION " Ver: 2.0.2 " __DATE__
 #define	EDAC_MOD_STR	"e7xxx_edac"
 
 #define e7xxx_printk(level, fmt, arg...) \

