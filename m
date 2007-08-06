Return-Path: <linux-kernel-owner+w=401wt.eu-S1764570AbXHFLzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764570AbXHFLzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 07:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763217AbXHFLy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 07:54:57 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:3931 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971AbXHFLy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 07:54:56 -0400
From: Thomas Klein <osstklei@de.ibm.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: [RESEND][PATCH 1/3] ehea: Fix workqueue handling
Date: Mon, 6 Aug 2007 13:54:29 +0200
User-Agent: KMail/1.8.2
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "Jan-Bernd Themann" <ossthema@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ppc" <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       netdev <netdev@vger.kernel.org>, Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <ossrosch@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1548
Message-Id: <200708061354.30653.osstklei@de.ibm.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix: Workqueue ehea_driver_wq was not destroyed

Signed-off-by: Thomas Klein <tklein@de.ibm.com>

---
 drivers/net/ehea/ehea.h      |    2 +-
 drivers/net/ehea/ehea_main.c |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ehea/ehea.h b/drivers/net/ehea/ehea.h
index 8ee2c2c..d67f97b 100644
--- a/drivers/net/ehea/ehea.h
+++ b/drivers/net/ehea/ehea.h
@@ -39,7 +39,7 @@
 #include <asm/io.h>
 
 #define DRV_NAME	"ehea"
-#define DRV_VERSION	"EHEA_0072"
+#define DRV_VERSION	"EHEA_0073"
 
 /* eHEA capability flags */
 #define DLPAR_PORT_ADD_REM 1
diff --git a/drivers/net/ehea/ehea_main.c b/drivers/net/ehea/ehea_main.c
index 58702f5..d43ab0f 100644
--- a/drivers/net/ehea/ehea_main.c
+++ b/drivers/net/ehea/ehea_main.c
@@ -3099,6 +3099,7 @@ out:
 
 static void __exit ehea_module_exit(void)
 {
+	destroy_workqueue(ehea_driver_wq);
 	driver_remove_file(&ehea_driver.driver, &driver_attr_capabilities);
 	ibmebus_unregister_driver(&ehea_driver);
 	ehea_destroy_busmap();
-- 
1.5.2


