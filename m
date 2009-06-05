Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbZFEO4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbZFEO4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbZFEOzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:55:55 -0400
Received: from mail.atmel.fr ([81.80.104.162]:44439 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823AbZFEOzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:55:55 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, david-b@pacbell.net,
       haavard.skinnemoen@atmel.com, patrice.vilchez@atmel.com,
       Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] atmel_usba_udc: change way of specifying bias function
Date: Fri,  5 Jun 2009 17:46:16 +0200
Message-Id: <1244216776-22760-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.3.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The toggle_bias() function was specified differently for avr32 and at91
architectures. Now, new at91 have the same behavior as avr32.
Consequently, we change to a particular chip function definition: only for
at91sam9rl.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---

 drivers/usb/gadget/atmel_usba_udc.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
index 563d572..a31df12 100644
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -326,13 +326,7 @@ static int vbus_is_present(struct usba_udc *udc)
 	return 1;
 }
 
-#if defined(CONFIG_AVR32)
-
-static void toggle_bias(int is_on)
-{
-}
-
-#elif defined(CONFIG_ARCH_AT91)
+#if defined(CONFIG_ARCH_AT91SAM9RL)
 
 #include <mach/at91_pmc.h>
 
@@ -346,7 +340,13 @@ static void toggle_bias(int is_on)
 		at91_sys_write(AT91_CKGR_UCKR, uckr & ~(AT91_PMC_BIASEN));
 }
 
-#endif /* CONFIG_ARCH_AT91 */
+#else
+
+static void toggle_bias(int is_on)
+{
+}
+
+#endif /* CONFIG_ARCH_AT91SAM9RL */
 
 static void next_fifo_transaction(struct usba_ep *ep, struct usba_request *req)
 {
-- 
1.5.3.7

