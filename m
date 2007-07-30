Return-Path: <linux-kernel-owner+w=401wt.eu-S935415AbXG3Pva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935415AbXG3Pva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 11:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755027AbXG3PvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 11:51:11 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:53787 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbXG3PvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 11:51:08 -0400
From: Thomas Klein <osstklei@de.ibm.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 2/3] ehea: Simplify resource usage check
Date: Mon, 30 Jul 2007 17:50:36 +0200
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
X-Length: 1674
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707301750.36297.osstklei@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use shorter method to determine whether adapter has configured ports

Signed-off-by: Thomas Klein <tklein@de.ibm.com>

---
 drivers/net/ehea/ehea_main.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ehea/ehea_main.c b/drivers/net/ehea/ehea_main.c
index d43ab0f..36ca322 100644
--- a/drivers/net/ehea/ehea_main.c
+++ b/drivers/net/ehea/ehea_main.c
@@ -2165,24 +2165,18 @@ static int ehea_clean_all_portres(struct ehea_port *port)
 	return ret;
 }
 
-static void ehea_remove_adapter_mr (struct ehea_adapter *adapter)
+static void ehea_remove_adapter_mr(struct ehea_adapter *adapter)
 {
-	int i;
-
-	for (i=0; i < EHEA_MAX_PORTS; i++)
-		if (adapter->port[i])
-			return;
+	if (adapter->active_ports)
+		return;
 
 	ehea_rem_mr(&adapter->mr);
 }
 
-static int ehea_add_adapter_mr (struct ehea_adapter *adapter)
+static int ehea_add_adapter_mr(struct ehea_adapter *adapter)
 {
-	int i;
-
-	for (i=0; i < EHEA_MAX_PORTS; i++)
-		if (adapter->port[i])
-			return 0;
+	if (adapter->active_ports)
+		return 0;
 
 	return ehea_reg_kernel_mr(adapter, &adapter->mr);
 }
-- 
1.5.2



