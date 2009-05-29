Return-Path: <linux-kernel-owner+w=401wt.eu-S932147AbZE2SqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147AbZE2SqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 14:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754983AbZE2SqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 14:46:08 -0400
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:41975 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336AbZE2SqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 14:46:07 -0400
Message-ID: <4A202D6B.5010803@linux.vnet.ibm.com>
Date: Fri, 29 May 2009 15:46:03 -0300
From: Breno Leitao <leitao@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] icom: fix compile errors when defining ICOM_TRACE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As it is, defining ICOM_TRACE produces some compile errors, as
"parameter name omitted" and "redefinition of ‘trace’"

This patch removes the wrong trace definition.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
---
 drivers/serial/icom.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/serial/icom.c b/drivers/serial/icom.c
index a461b3b..ccb5e79 100644
--- a/drivers/serial/icom.c
+++ b/drivers/serial/icom.c
@@ -137,7 +137,12 @@ static LIST_HEAD(icom_adapter_head);
 static spinlock_t icom_lock;
 
 #ifdef ICOM_TRACE
-static inline void trace(struct icom_port *, char *, unsigned long) {};
+static inline void trace(struct icom_port *icom_port, char *trace_pt,
+			unsigned long trace_data)
+{
+	dev_info(&icom_port->adapter->pci_dev->dev, ":%d:%s - %lx\n",
+	icom_port->port, trace_pt, trace_data);
+}
 #else
 static inline void trace(struct icom_port *icom_port, char *trace_pt, unsigned long trace_data) {};
 #endif
@@ -1647,15 +1652,6 @@ static void __exit icom_exit(void)
 module_init(icom_init);
 module_exit(icom_exit);
 
-#ifdef ICOM_TRACE
-static inline void trace(struct icom_port *icom_port, char *trace_pt,
-		  unsigned long trace_data)
-{
-	dev_info(&icom_port->adapter->pci_dev->dev, ":%d:%s - %lx\n",
-		 icom_port->port, trace_pt, trace_data);
-}
-#endif
-
 MODULE_AUTHOR("Michael Anderson <mjanders@us.ibm.com>");
 MODULE_DESCRIPTION("IBM iSeries Serial IOA driver");
 MODULE_SUPPORTED_DEVICE
-- 
1.6.0.2

