Return-Path: <linux-kernel-owner+w=401wt.eu-S1752678AbXBECmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbXBECmy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 21:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbXBECmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 21:42:54 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:22954 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbXBECmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 21:42:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=LBYDIL/ysQZdAj7LjjGYI+bRPZ0CS1oZ6xYa8upZu54IuoqaMEBSfxtH0Wsc6XPhJg+78Ay0GXU6pZruOpQ7iiAQPKElC+qQCBhcWIK5bQ9h+Ed3tqUgJUW0rhwLul+vHhys31pWD/UKSDKIRJHpM9Ls3xfFzKzgrY8542gSji4=
Date: Mon, 5 Feb 2007 04:42:37 +0200
To: uclinux-v850@lsi.nec.co.jp
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20] arch V850: user ARRAY_SIZE macro when appropriate
Message-ID: <20070205024237.GL18118@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205023935.GG18118@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

A patch to use ARRAY_SIZE macro already defined in linux/kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
Patch isn't compile checked cause I have no V850 board at hand.
Thanks,

diff --git a/arch/v850/kernel/anna.c b/arch/v850/kernel/anna.c
index 40892d3..0e42904 100644
--- a/arch/v850/kernel/anna.c
+++ b/arch/v850/kernel/anna.c
@@ -114,7 +114,7 @@ static struct v850e_intc_irq_init irq_inits[] = {
 	{ "ST",  IRQ_INTST(0), 	IRQ_INTST_NUM, 	3, 5 },
 	{ 0 }
 };
-#define NUM_IRQ_INITS ((sizeof irq_inits / sizeof irq_inits[0]) - 1)
+#define NUM_IRQ_INITS (ARRAY_SIZE(irq_inits) - 1)
 
 static struct hw_interrupt_type hw_itypes[NUM_IRQ_INITS];
 
diff --git a/arch/v850/kernel/as85ep1.c b/arch/v850/kernel/as85ep1.c
index 5352f8a..18437bc 100644
--- a/arch/v850/kernel/as85ep1.c
+++ b/arch/v850/kernel/as85ep1.c
@@ -142,7 +142,7 @@ static struct v850e_intc_irq_init irq_inits[] = {
 	{ "ST",  IRQ_INTST(0), 	IRQ_INTST_NUM, 	3, 5 },
 	{ 0 }
 };
-#define NUM_IRQ_INITS ((sizeof irq_inits / sizeof irq_inits[0]) - 1)
+#define NUM_IRQ_INITS (ARRAY_SIZE(irq_inits) - 1)
 
 static struct hw_interrupt_type hw_itypes[NUM_IRQ_INITS];
 
diff --git a/arch/v850/kernel/fpga85e2c.c b/arch/v850/kernel/fpga85e2c.c
index cb04a69..5c49235 100644
--- a/arch/v850/kernel/fpga85e2c.c
+++ b/arch/v850/kernel/fpga85e2c.c
@@ -138,7 +138,7 @@ struct v850e_intc_irq_init irq_inits[] = {
 	{ "RPU", IRQ_RPU(0),	IRQ_RPU_NUM,	1, 6 },
 	{ 0 }
 };
-#define NUM_IRQ_INITS ((sizeof irq_inits / sizeof irq_inits[0]) - 1)
+#define NUM_IRQ_INITS (ARRAY_SIZE(irq_inits) - 1)
 
 struct hw_interrupt_type hw_itypes[NUM_IRQ_INITS];
 
diff --git a/arch/v850/kernel/gbus_int.c b/arch/v850/kernel/gbus_int.c
index 25d636e..b2bcc25 100644
--- a/arch/v850/kernel/gbus_int.c
+++ b/arch/v850/kernel/gbus_int.c
@@ -16,6 +16,7 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/signal.h>
+#include <linux/kernel.h>
 
 #include <asm/machdep.h>
 
@@ -36,7 +37,7 @@ struct used_gint {
 	{ 1, GBUS_INT_PRIORITY_HIGH },
 	{ 3, GBUS_INT_PRIORITY_LOW }
 };
-#define NUM_USED_GINTS	(sizeof used_gint / sizeof used_gint[0])
+#define NUM_USED_GINTS ARRAY_SIZE(used_gint)
 
 /* A table of which GINT is used by each GBUS interrupts (they are
    assigned based on priority).  */
@@ -231,8 +232,7 @@ struct gbus_int_irq_init gbus_irq_inits[] __initdata = {
 	{ "GBUS_INT", IRQ_GBUS_INT(0), IRQ_GBUS_INT_NUM, 1, 6},
 	{ 0 }
 };
-#define NUM_GBUS_IRQ_INITS  \
-   ((sizeof gbus_irq_inits / sizeof gbus_irq_inits[0]) - 1)
+#define NUM_GBUS_IRQ_INITS (ARRAY_SIZE(gbus_irq_inits) - 1)
 
 static struct hw_interrupt_type gbus_hw_itypes[NUM_GBUS_IRQ_INITS];
 
diff --git a/arch/v850/kernel/ma.c b/arch/v850/kernel/ma.c
index 2aa8ab0..143774d 100644
--- a/arch/v850/kernel/ma.c
+++ b/arch/v850/kernel/ma.c
@@ -43,7 +43,7 @@ static struct v850e_intc_irq_init irq_inits[] = {
 	{ "ST",  IRQ_INTST(0), 	IRQ_INTST_NUM, 	4, 5 },
 	{ 0 }
 };
-#define NUM_IRQ_INITS ((sizeof irq_inits / sizeof irq_inits[0]) - 1)
+#define NUM_IRQ_INITS (ARRAY_SIZE(irq_inits) - 1)
 
 static struct hw_interrupt_type hw_itypes[NUM_IRQ_INITS];
 
diff --git a/arch/v850/kernel/me2.c b/arch/v850/kernel/me2.c
index 14b0c88..38be5c1 100644
--- a/arch/v850/kernel/me2.c
+++ b/arch/v850/kernel/me2.c
@@ -44,7 +44,7 @@ static struct v850e_intc_irq_init irq_inits[] = {
 	{ "UBTITO", IRQ_INTUBTITO(0), IRQ_INTUBTITO_NUM, 5, 4 },
 	{ 0 }
 };
-#define NUM_IRQ_INITS ((sizeof irq_inits / sizeof irq_inits[0]) - 1)
+#define NUM_IRQ_INITS (ARRAY_SIZE(irq_inits) - 1)
 
 static struct hw_interrupt_type hw_itypes[NUM_IRQ_INITS];
 
diff --git a/arch/v850/kernel/rte_cb.c b/arch/v850/kernel/rte_cb.c
index 0f7f6cd..43018e1 100644
--- a/arch/v850/kernel/rte_cb.c
+++ b/arch/v850/kernel/rte_cb.c
@@ -15,6 +15,7 @@
 #include <linux/irq.h>
 #include <linux/fs.h>
 #include <linux/module.h>
+#include <linux/kernel.h>
 
 #include <asm/machdep.h>
 #include <asm/v850e_uart.h>
@@ -176,8 +177,7 @@ static struct gbus_int_irq_init gbus_irq_inits[] = {
 #endif
 	{ 0 }
 };
-#define NUM_GBUS_IRQ_INITS  \
-   ((sizeof gbus_irq_inits / sizeof gbus_irq_inits[0]) - 1)
+#define NUM_GBUS_IRQ_INITS (ARRAY_SIZE(gbus_irq_inits) - 1)
 
 static struct hw_interrupt_type gbus_hw_itypes[NUM_GBUS_IRQ_INITS];
 
diff --git a/arch/v850/kernel/rte_mb_a_pci.c b/arch/v850/kernel/rte_mb_a_pci.c
index 35213fa..35a4bd5 100644
--- a/arch/v850/kernel/rte_mb_a_pci.c
+++ b/arch/v850/kernel/rte_mb_a_pci.c
@@ -70,8 +70,7 @@ static struct mb_pci_dev_irq mb_pci_dev_irqs[] = {
 	/* PCI slot 2 */
 	{ 9, 	IRQ_MB_A_PCI2(0),	1 }
 };
-#define NUM_MB_PCI_DEV_IRQS \
-  (sizeof mb_pci_dev_irqs / sizeof mb_pci_dev_irqs[0])
+#define NUM_MB_PCI_DEV_IRQS ARRAY_SIZE(mb_pci_dev_irqs)
 
 
 /* PCI configuration primitives.  */
diff --git a/arch/v850/kernel/rte_me2_cb.c b/arch/v850/kernel/rte_me2_cb.c
index 3be355a..46803d4 100644
--- a/arch/v850/kernel/rte_me2_cb.c
+++ b/arch/v850/kernel/rte_me2_cb.c
@@ -170,8 +170,7 @@ static struct cb_pic_irq_init cb_pic_irq_inits[] = {
 	{ "CB_EXTTM2",       IRQ_CB_EXTTM2,       1, 1, 6 },
 	{ 0 }
 };
-#define NUM_CB_PIC_IRQ_INITS  \
-   ((sizeof cb_pic_irq_inits / sizeof cb_pic_irq_inits[0]) - 1)
+#define NUM_CB_PIC_IRQ_INITS (ARRAY_SIZE(cb_pic_irq_inits) - 1)
 
 static struct hw_interrupt_type cb_pic_hw_itypes[NUM_CB_PIC_IRQ_INITS];
 static unsigned char cb_pic_active_irqs = 0;
diff --git a/arch/v850/kernel/teg.c b/arch/v850/kernel/teg.c
index 290d506..699248f 100644
--- a/arch/v850/kernel/teg.c
+++ b/arch/v850/kernel/teg.c
@@ -43,7 +43,7 @@ static struct v850e_intc_irq_init irq_inits[] = {
 	{ "ST",	 IRQ_INTST(0),	IRQ_INTST_NUM,	1, 5 },
 	{ 0 }
 };
-#define NUM_IRQ_INITS ((sizeof irq_inits / sizeof irq_inits[0]) - 1)
+#define NUM_IRQ_INITS (ARRAY_SIZE(irq_inits) - 1)
 
 static struct hw_interrupt_type hw_itypes[NUM_IRQ_INITS];
 

-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
