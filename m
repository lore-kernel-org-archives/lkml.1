Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab0CCKuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 05:50:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35301
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108Ab0CCKuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 05:50:08 -0500
Date: Wed, 03 Mar 2010 02:50:26 -0800 (PST)
Message-Id: <20100303.025026.243831910.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
CC: grant.likely@secretlab.ca
Subject: [PATCH] uartlite: Fix build on sparc.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We can get this driver enabled via MFD_TIMBERDALE which only
requires GPIO to be on.

But the of_address_to_resource() function is only present on
powerpc and microblaze, so we have to conditionalize the
CONFIG_OF probing bits on that.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/serial/uartlite.c b/drivers/serial/uartlite.c
index ab2ab3c..f0a6c61 100644
--- a/drivers/serial/uartlite.c
+++ b/drivers/serial/uartlite.c
@@ -19,7 +19,7 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <asm/io.h>
-#if defined(CONFIG_OF)
+#if defined(CONFIG_OF) && (defined(CONFIG_PPC32) || defined(CONFIG_MICROBLAZE))
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_platform.h>
@@ -581,7 +581,7 @@ static struct platform_driver ulite_platform_driver = {
 /* ---------------------------------------------------------------------
  * OF bus bindings
  */
-#if defined(CONFIG_OF)
+#if defined(CONFIG_OF) && (defined(CONFIG_PPC32) || defined(CONFIG_MICROBLAZE))
 static int __devinit
 ulite_of_probe(struct of_device *op, const struct of_device_id *match)
 {
@@ -631,11 +631,11 @@ static inline void __exit ulite_of_unregister(void)
 {
 	of_unregister_platform_driver(&ulite_of_driver);
 }
-#else /* CONFIG_OF */
-/* CONFIG_OF not enabled; do nothing helpers */
+#else /* CONFIG_OF && (CONFIG_PPC32 || CONFIG_MICROBLAZE) */
+/* Appropriate config not enabled; do nothing helpers */
 static inline int __init ulite_of_register(void) { return 0; }
 static inline void __exit ulite_of_unregister(void) { }
-#endif /* CONFIG_OF */
+#endif /* CONFIG_OF && (CONFIG_PPC32 || CONFIG_MICROBLAZE) */
 
 /* ---------------------------------------------------------------------
  * Module setup/teardown
