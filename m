Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbZKQWvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbZKQWvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756601AbZKQWv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:51:29 -0500
Received: from www.tglx.de ([62.245.132.106]:41569 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756631AbZKQWvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:51:25 -0500
Message-Id: <20091117224916.679637750@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 17 Nov 2009 22:51:10 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Hirokazu Takata <takata@linux-m32r.org>,
       linux-m32r@ml.linux-m32r.org
Subject: [patch 09/13] m32r: Fixup last users of irq_chip->typename 
References: <20091117224852.846805939@linutronix.de>
Content-Disposition: inline; filename=m32r-replace-obsolete-typename.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The typename member of struct irq_chip was kept for migration purposes
and is obsolete since more than 2 years. Fix up the leftovers.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: linux-m32r@ml.linux-m32r.org
---
 arch/m32r/kernel/irq.c               |    2 +-
 arch/m32r/platforms/m32104ut/setup.c |    2 +-
 arch/m32r/platforms/m32700ut/setup.c |    8 ++++----
 arch/m32r/platforms/mappi/setup.c    |    2 +-
 arch/m32r/platforms/mappi2/setup.c   |    2 +-
 arch/m32r/platforms/mappi3/setup.c   |    2 +-
 arch/m32r/platforms/oaks32r/setup.c  |    2 +-
 arch/m32r/platforms/opsput/setup.c   |    6 +++---
 arch/m32r/platforms/usrv/setup.c     |    4 ++--
 9 files changed, 15 insertions(+), 15 deletions(-)

Index: linux-2.6/arch/m32r/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/m32r/kernel/irq.c
+++ linux-2.6/arch/m32r/kernel/irq.c
@@ -51,7 +51,7 @@ int show_interrupts(struct seq_file *p, 
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
-		seq_printf(p, " %14s", irq_desc[i].chip->typename);
+		seq_printf(p, " %14s", irq_desc[i].chip->name);
 		seq_printf(p, "  %s", action->name);
 
 		for (action=action->next; action; action = action->next)
Index: linux-2.6/arch/m32r/platforms/m32104ut/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/m32104ut/setup.c
+++ linux-2.6/arch/m32r/platforms/m32104ut/setup.c
@@ -65,7 +65,7 @@ static void shutdown_m32104ut_irq(unsign
 
 static struct irq_chip m32104ut_irq_type =
 {
-	.typename = "M32104UT-IRQ",
+	.name = "M32104UT-IRQ",
 	.startup = startup_m32104ut_irq,
 	.shutdown = shutdown_m32104ut_irq,
 	.enable = enable_m32104ut_irq,
Index: linux-2.6/arch/m32r/platforms/m32700ut/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/m32700ut/setup.c
+++ linux-2.6/arch/m32r/platforms/m32700ut/setup.c
@@ -71,7 +71,7 @@ static void shutdown_m32700ut_irq(unsign
 
 static struct irq_chip m32700ut_irq_type =
 {
-	.typename = "M32700UT-IRQ",
+	.name = "M32700UT-IRQ",
 	.startup = startup_m32700ut_irq,
 	.shutdown = shutdown_m32700ut_irq,
 	.enable = enable_m32700ut_irq,
@@ -148,7 +148,7 @@ static void shutdown_m32700ut_pld_irq(un
 
 static struct irq_chip m32700ut_pld_irq_type =
 {
-	.typename = "M32700UT-PLD-IRQ",
+	.name = "M32700UT-PLD-IRQ",
 	.startup = startup_m32700ut_pld_irq,
 	.shutdown = shutdown_m32700ut_pld_irq,
 	.enable = enable_m32700ut_pld_irq,
@@ -217,7 +217,7 @@ static void shutdown_m32700ut_lanpld_irq
 
 static struct irq_chip m32700ut_lanpld_irq_type =
 {
-	.typename = "M32700UT-PLD-LAN-IRQ",
+	.name = "M32700UT-PLD-LAN-IRQ",
 	.startup = startup_m32700ut_lanpld_irq,
 	.shutdown = shutdown_m32700ut_lanpld_irq,
 	.enable = enable_m32700ut_lanpld_irq,
@@ -286,7 +286,7 @@ static void shutdown_m32700ut_lcdpld_irq
 
 static struct irq_chip m32700ut_lcdpld_irq_type =
 {
-	.typename = "M32700UT-PLD-LCD-IRQ",
+	.name = "M32700UT-PLD-LCD-IRQ",
 	.startup = startup_m32700ut_lcdpld_irq,
 	.shutdown = shutdown_m32700ut_lcdpld_irq,
 	.enable = enable_m32700ut_lcdpld_irq,
Index: linux-2.6/arch/m32r/platforms/mappi/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/mappi/setup.c
+++ linux-2.6/arch/m32r/platforms/mappi/setup.c
@@ -65,7 +65,7 @@ static void shutdown_mappi_irq(unsigned 
 
 static struct irq_chip mappi_irq_type =
 {
-	.typename = "MAPPI-IRQ",
+	.name = "MAPPI-IRQ",
 	.startup = startup_mappi_irq,
 	.shutdown = shutdown_mappi_irq,
 	.enable = enable_mappi_irq,
Index: linux-2.6/arch/m32r/platforms/mappi2/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/mappi2/setup.c
+++ linux-2.6/arch/m32r/platforms/mappi2/setup.c
@@ -72,7 +72,7 @@ static void shutdown_mappi2_irq(unsigned
 
 static struct irq_chip mappi2_irq_type =
 {
-	.typename = "MAPPI2-IRQ",
+	.name = "MAPPI2-IRQ",
 	.startup = startup_mappi2_irq,
 	.shutdown = shutdown_mappi2_irq,
 	.enable = enable_mappi2_irq,
Index: linux-2.6/arch/m32r/platforms/mappi3/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/mappi3/setup.c
+++ linux-2.6/arch/m32r/platforms/mappi3/setup.c
@@ -72,7 +72,7 @@ static void shutdown_mappi3_irq(unsigned
 
 static struct irq_chip mappi3_irq_type =
 {
-	.typename = "MAPPI3-IRQ",
+	.name = "MAPPI3-IRQ",
 	.startup = startup_mappi3_irq,
 	.shutdown = shutdown_mappi3_irq,
 	.enable = enable_mappi3_irq,
Index: linux-2.6/arch/m32r/platforms/oaks32r/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/oaks32r/setup.c
+++ linux-2.6/arch/m32r/platforms/oaks32r/setup.c
@@ -63,7 +63,7 @@ static void shutdown_oaks32r_irq(unsigne
 
 static struct irq_chip oaks32r_irq_type =
 {
-	.typename = "OAKS32R-IRQ",
+	.name = "OAKS32R-IRQ",
 	.startup = startup_oaks32r_irq,
 	.shutdown = shutdown_oaks32r_irq,
 	.enable = enable_oaks32r_irq,
Index: linux-2.6/arch/m32r/platforms/opsput/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/opsput/setup.c
+++ linux-2.6/arch/m32r/platforms/opsput/setup.c
@@ -72,7 +72,7 @@ static void shutdown_opsput_irq(unsigned
 
 static struct irq_chip opsput_irq_type =
 {
-	.typename = "OPSPUT-IRQ",
+	.name = "OPSPUT-IRQ",
 	.startup = startup_opsput_irq,
 	.shutdown = shutdown_opsput_irq,
 	.enable = enable_opsput_irq,
@@ -149,7 +149,7 @@ static void shutdown_opsput_pld_irq(unsi
 
 static struct irq_chip opsput_pld_irq_type =
 {
-	.typename = "OPSPUT-PLD-IRQ",
+	.name = "OPSPUT-PLD-IRQ",
 	.startup = startup_opsput_pld_irq,
 	.shutdown = shutdown_opsput_pld_irq,
 	.enable = enable_opsput_pld_irq,
@@ -218,7 +218,7 @@ static void shutdown_opsput_lanpld_irq(u
 
 static struct irq_chip opsput_lanpld_irq_type =
 {
-	.typename = "OPSPUT-PLD-LAN-IRQ",
+	.name = "OPSPUT-PLD-LAN-IRQ",
 	.startup = startup_opsput_lanpld_irq,
 	.shutdown = shutdown_opsput_lanpld_irq,
 	.enable = enable_opsput_lanpld_irq,
Index: linux-2.6/arch/m32r/platforms/usrv/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/usrv/setup.c
+++ linux-2.6/arch/m32r/platforms/usrv/setup.c
@@ -63,7 +63,7 @@ static void shutdown_mappi_irq(unsigned 
 
 static struct irq_chip mappi_irq_type =
 {
-	.typename = "M32700-IRQ",
+	.name = "M32700-IRQ",
 	.startup = startup_mappi_irq,
 	.shutdown = shutdown_mappi_irq,
 	.enable = enable_mappi_irq,
@@ -136,7 +136,7 @@ static void shutdown_m32700ut_pld_irq(un
 
 static struct irq_chip m32700ut_pld_irq_type =
 {
-	.typename = "USRV-PLD-IRQ",
+	.name = "USRV-PLD-IRQ",
 	.startup = startup_m32700ut_pld_irq,
 	.shutdown = shutdown_m32700ut_pld_irq,
 	.enable = enable_m32700ut_pld_irq,


