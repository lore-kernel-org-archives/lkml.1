Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179Ab0A1MxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab0A1MxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 07:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730Ab0A1MxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 07:53:10 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:52699 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab0A1MxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 07:53:09 -0500
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jan 2010 07:53:09 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=l4DyDyKVR1/AKlADupuie26wIedOBDARvvcYoyHX/JBPKpqhVeDNJx9xxAJhVQSdn+
         Mgp8lACmFGTBy8VTMMYHx6CdWIaBQktXThbieVl2S5+LOdDv9VeXPp2Z2MfByc8QlUDe
         5Nis4AHsf3fHxDcBUhmBamgmA6mTDMyYyY1SU=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux@arm.linux.org.uk
Cc: eric.y.miao@gmail.com, tony@atomide.com, linux-kernel@vger.kernel.org,
       khilman@deeprootsystems.com, lethal@linux-sh.org, ben-linux@fluff.org,
       Magnus Damm <magnus.damm@gmail.com>,
       linux-arm-kernel@lists.infradead.org
Date: Thu, 28 Jan 2010 21:41:31 +0900
Message-Id: <20100128124131.8982.21545.sendpatchset@rxone.opensource.se>
In-Reply-To: <20100128124028.8982.16123.sendpatchset@rxone.opensource.se>
References: <20100128124028.8982.16123.sendpatchset@rxone.opensource.se>
Subject: [PATCH 06/06] sh-sci: Preliminary SuperH Mobile ARM support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Add preliminary SuperH Mobile ARM support to the sh-sci
driver. Enough to get serial console working. Needs more
work. Is really disconnected from the ARM support code
but is included here for completeness.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/serial/Kconfig  |    2 +-
 drivers/serial/sh-sci.h |   23 ++++++++++++++++++-----
 2 files changed, 19 insertions(+), 6 deletions(-)

--- 0001/drivers/serial/Kconfig
+++ work/drivers/serial/Kconfig	2010-01-21 19:55:26.000000000 +0900
@@ -996,7 +996,7 @@ config SERIAL_IP22_ZILOG_CONSOLE
 
 config SERIAL_SH_SCI
 	tristate "SuperH SCI(F) serial port support"
-	depends on HAVE_CLK && (SUPERH || H8300)
+	depends on HAVE_CLK && (SUPERH || H8300 || ARCH_SHMOBILE)
 	select SERIAL_CORE
 
 config SERIAL_SH_SCI_NR_UARTS
--- 0001/drivers/serial/sh-sci.h
+++ work/drivers/serial/sh-sci.h	2010-01-21 19:57:10.000000000 +0900
@@ -174,6 +174,10 @@
 # define SCSPTR3 0xffc60020		/* 16 bit SCIF */
 # define SCIF_ORER 0x0001		/* Overrun error bit */
 # define SCSCR_INIT(port)	0x38	/* TIE=0,RIE=0,TE=1,RE=1,REIE=1 */
+#elif defined(CONFIG_ARCH_SHMOBILE)
+# define SCSCR_INIT(port)	0x0030
+# define SCIF_ONLY
+# define SCIF_ORER		0x0200
 #else
 # error CPU subtype not defined
 #endif
@@ -261,7 +265,8 @@
 
 #if defined(CONFIG_CPU_SUBTYPE_SH7705) || \
     defined(CONFIG_CPU_SUBTYPE_SH7720) || \
-    defined(CONFIG_CPU_SUBTYPE_SH7721)
+    defined(CONFIG_CPU_SUBTYPE_SH7721) || \
+    defined(CONFIG_ARCH_SHMOBILE)
 # define SCxSR_RDxF_CLEAR(port)	 (sci_in(port, SCxSR) & 0xfffc)
 # define SCxSR_ERROR_CLEAR(port) (sci_in(port, SCxSR) & 0xfd73)
 # define SCxSR_TDxE_CLEAR(port)	 (sci_in(port, SCxSR) & 0xffdf)
@@ -356,7 +361,7 @@
     SCI_OUT(sci_size, sci_offset, value);				\
   }
 
-#ifdef CONFIG_CPU_SH3
+#if defined(CONFIG_CPU_SH3) || defined(CONFIG_ARCH_SHMOBILE)
 #if defined(CONFIG_CPU_SUBTYPE_SH7710) || defined(CONFIG_CPU_SUBTYPE_SH7712)
 #define SCIx_FNS(name, sh3_sci_offset, sh3_sci_size, sh4_sci_offset, sh4_sci_size, \
 		                sh3_scif_offset, sh3_scif_size, sh4_scif_offset, sh4_scif_size, \
@@ -366,7 +371,8 @@
 	  CPU_SCIF_FNS(name, sh4_scif_offset, sh4_scif_size)
 #elif defined(CONFIG_CPU_SUBTYPE_SH7705) || \
       defined(CONFIG_CPU_SUBTYPE_SH7720) || \
-      defined(CONFIG_CPU_SUBTYPE_SH7721)
+      defined(CONFIG_CPU_SUBTYPE_SH7721) || \
+      defined(CONFIG_ARCH_SHMOBILE)
 #define SCIF_FNS(name, scif_offset, scif_size) \
   CPU_SCIF_FNS(name, scif_offset, scif_size)
 #else
@@ -401,7 +407,8 @@
 
 #if defined(CONFIG_CPU_SUBTYPE_SH7705) || \
     defined(CONFIG_CPU_SUBTYPE_SH7720) || \
-    defined(CONFIG_CPU_SUBTYPE_SH7721)
+    defined(CONFIG_CPU_SUBTYPE_SH7721) || \
+    defined(CONFIG_ARCH_SHMOBILE)
 
 SCIF_FNS(SCSMR,  0x00, 16)
 SCIF_FNS(SCBRR,  0x04,  8)
@@ -548,6 +555,11 @@ static inline int sci_rxd_in(struct uart
 		return sci_in(port, SCxSR) & 0x0003 ? 1 : 0;
 	return 1;
 }
+#elif defined(CONFIG_ARCH_SHMOBILE)
+static inline int sci_rxd_in(struct uart_port *port)
+{
+	return 1;
+}
 #elif defined(CONFIG_CPU_SUBTYPE_SH7750)  || \
       defined(CONFIG_CPU_SUBTYPE_SH7751)  || \
       defined(CONFIG_CPU_SUBTYPE_SH7751R) || \
@@ -801,7 +813,8 @@ static inline int sci_rxd_in(struct uart
 #define SCBRR_VALUE(bps, clk) ((clk+16*bps)/(16*bps)-1)
 #elif defined(CONFIG_CPU_SUBTYPE_SH7705) || \
       defined(CONFIG_CPU_SUBTYPE_SH7720) || \
-      defined(CONFIG_CPU_SUBTYPE_SH7721)
+      defined(CONFIG_CPU_SUBTYPE_SH7721) || \
+      defined(CONFIG_ARCH_SHMOBILE)
 #define SCBRR_VALUE(bps, clk) (((clk*2)+16*bps)/(32*bps)-1)
 #elif defined(CONFIG_CPU_SUBTYPE_SH7723) ||\
       defined(CONFIG_CPU_SUBTYPE_SH7724)
