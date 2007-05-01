Return-Path: <linux-kernel-owner+w=401wt.eu-S1423809AbXEAEM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423809AbXEAEM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423789AbXEAEM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:12:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39780 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423777AbXEAEMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 00:12:17 -0400
Date: Tue, 1 May 2007 13:51:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ppc-dev <linuxppc-dev@ozlabs.org>, paulus@samba.org,
       "David S. Miller" <davem@davemloft.net>, jgarzik@pobox.com,
       netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] get_property returns const
Message-Id: <20070501135132.f6546878.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the last place that needs changing since get_property was changed
to return "const void *".

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/ehea/ehea_main.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/drivers/net/ehea/ehea_main.c b/drivers/net/ehea/ehea_main.c
index c7a5614..519bb9f 100644
--- a/drivers/net/ehea/ehea_main.c
+++ b/drivers/net/ehea/ehea_main.c
@@ -2603,14 +2603,13 @@ static int ehea_setup_ports(struct ehea_adapter *adapter)
 {
 	struct device_node *lhea_dn;
 	struct device_node *eth_dn = NULL;
-
-	u32 *dn_log_port_id;
+	const u32 *dn_log_port_id;
 	int i = 0;
 
 	lhea_dn = adapter->ebus_dev->ofdev.node;
 	while ((eth_dn = of_get_next_child(lhea_dn, eth_dn))) {
 
-		dn_log_port_id = (u32*)get_property(eth_dn, "ibm,hea-port-no",
+		dn_log_port_id = get_property(eth_dn, "ibm,hea-port-no",
 						    NULL);
 		if (!dn_log_port_id) {
 			ehea_error("bad device node: eth_dn name=%s",
@@ -2645,12 +2644,12 @@ static struct device_node *ehea_get_eth_dn(struct ehea_adapter *adapter,
 {
 	struct device_node *lhea_dn;
 	struct device_node *eth_dn = NULL;
-	u32 *dn_log_port_id;
+	const u32 *dn_log_port_id;
 
 	lhea_dn = adapter->ebus_dev->ofdev.node;
 	while ((eth_dn = of_get_next_child(lhea_dn, eth_dn))) {
 
-		dn_log_port_id = (u32*)get_property(eth_dn, "ibm,hea-port-no",
+		dn_log_port_id = get_property(eth_dn, "ibm,hea-port-no",
 						    NULL);
 		if (dn_log_port_id)
 			if (*dn_log_port_id == logical_port_id)
@@ -2774,7 +2773,7 @@ static int __devinit ehea_probe_adapter(struct ibmebus_dev *dev,
 					const struct of_device_id *id)
 {
 	struct ehea_adapter *adapter;
-	u64 *adapter_handle;
+	const u64 *adapter_handle;
 	int ret;
 
 	if (!dev || !dev->ofdev.node) {
@@ -2791,7 +2790,7 @@ static int __devinit ehea_probe_adapter(struct ibmebus_dev *dev,
 
 	adapter->ebus_dev = dev;
 
-	adapter_handle = (u64*)get_property(dev->ofdev.node, "ibm,hea-handle",
+	adapter_handle = get_property(dev->ofdev.node, "ibm,hea-handle",
 					    NULL);
 	if (adapter_handle)
 		adapter->handle = *adapter_handle;
-- 
1.5.1.2

