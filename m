Return-Path: <linux-kernel-owner+w=401wt.eu-S932581AbXGTDef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581AbXGTDef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 23:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757368AbXGTDda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 23:33:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35658 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763769AbXGTDd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 23:33:29 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 5/8] m68k: missing __init
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Message-Id: <E1IBjFA-0004lm-5l@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 20 Jul 2007 04:33:28 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/m68k/apollo/config.c   |    4 ++--
 arch/m68k/apollo/dn_ints.c  |    2 +-
 arch/m68k/bvme6000/config.c |    2 +-
 arch/m68k/kernel/time.c     |    2 +-
 arch/m68k/mac/config.c      |    6 +++---
 arch/m68k/mac/macints.c     |    4 +++-
 arch/m68k/mm/init.c         |    2 +-
 arch/m68k/mvme147/config.c  |    2 +-
 arch/m68k/mvme16x/config.c  |    2 +-
 arch/m68k/q40/q40ints.c     |    2 +-
 arch/m68k/sun3/sun3ints.c   |    2 +-
 arch/m68k/sun3x/prom.c      |    2 +-
 12 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/arch/m68k/apollo/config.c b/arch/m68k/apollo/config.c
index cb8e760..78df98f 100644
--- a/arch/m68k/apollo/config.c
+++ b/arch/m68k/apollo/config.c
@@ -148,8 +148,8 @@ void dn_serial_print (const char *str)
     }
 }
 
-void config_apollo(void) {
-
+void __init config_apollo(void)
+{
 	int i;
 
 	dn_setup_model();
diff --git a/arch/m68k/apollo/dn_ints.c b/arch/m68k/apollo/dn_ints.c
index 13bd41b..5d47f3a 100644
--- a/arch/m68k/apollo/dn_ints.c
+++ b/arch/m68k/apollo/dn_ints.c
@@ -37,7 +37,7 @@ static struct irq_controller apollo_irq_controller = {
 };
 
 
-void dn_init_IRQ(void)
+void __init dn_init_IRQ(void)
 {
 	m68k_setup_user_interrupt(VEC_USER + 96, 16, dn_process_int);
 	m68k_setup_irq_controller(&apollo_irq_controller, IRQ_APOLLO, 16);
diff --git a/arch/m68k/bvme6000/config.c b/arch/m68k/bvme6000/config.c
index 896ae3d..9433a88 100644
--- a/arch/m68k/bvme6000/config.c
+++ b/arch/m68k/bvme6000/config.c
@@ -97,7 +97,7 @@ static int bvme6000_get_hardware_list(char *buffer)
  * This function is called during kernel startup to initialize
  * the bvme6000 IRQ handling routines.
  */
-static void bvme6000_init_IRQ(void)
+static void __init bvme6000_init_IRQ(void)
 {
 	m68k_setup_user_interrupt(VEC_USER, 192, NULL);
 }
diff --git a/arch/m68k/kernel/time.c b/arch/m68k/kernel/time.c
index 4c065f9..7db4159 100644
--- a/arch/m68k/kernel/time.c
+++ b/arch/m68k/kernel/time.c
@@ -72,7 +72,7 @@ static irqreturn_t timer_interrupt(int irq, void *dummy)
 	return IRQ_HANDLED;
 }
 
-void time_init(void)
+void __init time_init(void)
 {
 	struct rtc_time time;
 
diff --git a/arch/m68k/mac/config.c b/arch/m68k/mac/config.c
index 9a7f14e..8547dbc 100644
--- a/arch/m68k/mac/config.c
+++ b/arch/m68k/mac/config.c
@@ -85,7 +85,7 @@ extern void nubus_sweep_video(void);
 
 static void mac_get_model(char *str);
 
-static void mac_sched_init(irq_handler_t vector)
+static void __init mac_sched_init(irq_handler_t vector)
 {
 	via_init_clock(vector);
 }
@@ -770,7 +770,7 @@ static struct mac_model mac_data_table[] = {
 	}
 };
 
-void mac_identify(void)
+void __init mac_identify(void)
 {
 	struct mac_model *m;
 
@@ -847,7 +847,7 @@ void mac_identify(void)
 	baboon_init();
 }
 
-void mac_report_hardware(void)
+void __init mac_report_hardware(void)
 {
 	printk(KERN_INFO "Apple Macintosh %s\n", macintosh_config->name);
 }
diff --git a/arch/m68k/mac/macints.c b/arch/m68k/mac/macints.c
index 0fc72d8..ecddac4 100644
--- a/arch/m68k/mac/macints.c
+++ b/arch/m68k/mac/macints.c
@@ -114,6 +114,7 @@
  *
  */
 
+#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -224,7 +225,7 @@ static struct irq_controller mac_irq_controller = {
 	.disable	= mac_disable_irq,
 };
 
-void mac_init_IRQ(void)
+void __init mac_init_IRQ(void)
 {
 #ifdef DEBUG_MACINTS
 	printk("mac_init_IRQ(): Setting things up...\n");
@@ -391,6 +392,7 @@ int mac_irq_pending(unsigned int irq)
 	}
 	return 0;
 }
+EXPORT_SYMBOL(mac_irq_pending);
 
 static int num_debug[8];
 
diff --git a/arch/m68k/mm/init.c b/arch/m68k/mm/init.c
index f1de19e..f42caa7 100644
--- a/arch/m68k/mm/init.c
+++ b/arch/m68k/mm/init.c
@@ -44,7 +44,7 @@ pg_data_t *pg_data_table[65];
 EXPORT_SYMBOL(pg_data_table);
 #endif
 
-void m68k_setup_node(int node)
+void __init m68k_setup_node(int node)
 {
 #ifndef CONFIG_SINGLE_MEMORY_CHUNK
 	struct mem_info *info = m68k_memory + node;
diff --git a/arch/m68k/mvme147/config.c b/arch/m68k/mvme147/config.c
index 4a7df9c..92fe507 100644
--- a/arch/m68k/mvme147/config.c
+++ b/arch/m68k/mvme147/config.c
@@ -89,7 +89,7 @@ static int mvme147_get_hardware_list(char *buffer)
  * the mvme147 IRQ handling routines.
  */
 
-void mvme147_init_IRQ(void)
+void __init mvme147_init_IRQ(void)
 {
 	m68k_setup_user_interrupt(VEC_USER, 192, NULL);
 }
diff --git a/arch/m68k/mvme16x/config.c b/arch/m68k/mvme16x/config.c
index c829ebb..daa7851 100644
--- a/arch/m68k/mvme16x/config.c
+++ b/arch/m68k/mvme16x/config.c
@@ -119,7 +119,7 @@ static int mvme16x_get_hardware_list(char *buffer)
  * that the base vectors for the VMEChip2 and PCCChip2 are valid.
  */
 
-static void mvme16x_init_IRQ (void)
+static void __init mvme16x_init_IRQ (void)
 {
 	m68k_setup_user_interrupt(VEC_USER, 192, NULL);
 }
diff --git a/arch/m68k/q40/q40ints.c b/arch/m68k/q40/q40ints.c
index 2fb25ae..ad3ed1f 100644
--- a/arch/m68k/q40/q40ints.c
+++ b/arch/m68k/q40/q40ints.c
@@ -79,7 +79,7 @@ static struct irq_controller q40_irq_controller = {
 
 static int disabled;
 
-void q40_init_IRQ(void)
+void __init q40_init_IRQ(void)
 {
 	m68k_setup_irq_controller(&q40_irq_controller, 1, Q40_IRQ_MAX);
 
diff --git a/arch/m68k/sun3/sun3ints.c b/arch/m68k/sun3/sun3ints.c
index 50df34b..cf93481 100644
--- a/arch/m68k/sun3/sun3ints.c
+++ b/arch/m68k/sun3/sun3ints.c
@@ -97,7 +97,7 @@ static struct irq_controller sun3_irq_controller = {
 	.disable	= sun3_disable_irq,
 };
 
-void sun3_init_IRQ(void)
+void __init sun3_init_IRQ(void)
 {
 	*sun3_intreg = 1;
 
diff --git a/arch/m68k/sun3x/prom.c b/arch/m68k/sun3x/prom.c
index 48f8eb7..a7b7e81 100644
--- a/arch/m68k/sun3x/prom.c
+++ b/arch/m68k/sun3x/prom.c
@@ -92,7 +92,7 @@ static struct console sun3x_debug = {
 	.index	= -1,
 };
 
-void sun3x_prom_init(void)
+void __init sun3x_prom_init(void)
 {
 	/* Read the vector table */
 
-- 
1.5.3.GIT


