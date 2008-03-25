Return-Path: <linux-kernel-owner+w=401wt.eu-S1757129AbYCYP42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129AbYCYP42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 11:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbYCYP4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 11:56:21 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:38807 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676AbYCYP4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 11:56:20 -0400
From: Thomas Klein <osstklei@de.ibm.com>
To: stable@kernel.org
Subject: [PATCH 2.6.24-stable] ehea: Fix IPv6 support
Date: Tue, 25 Mar 2008 16:56:15 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ppc" <linuxppc-dev@ozlabs.org>, netdev <netdev@vger.kernel.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Hannes Hering <hering2@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803251656.16065.osstklei@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indicate that HEA calculates IPv4 checksums only

Signed-off-by: Thomas Klein <tklein@de.ibm.com>

---
diff -Nurp linux-2.6.24.4.org/drivers/net/ehea/ehea.h linux-2.6.24.4/drivers/net/ehea/ehea.h
--- linux-2.6.24.4.org/drivers/net/ehea/ehea.h	2008-03-25 12:42:18.000000000 +0100
+++ linux-2.6.24.4/drivers/net/ehea/ehea.h	2008-03-25 13:13:29.000000000 +0100
@@ -40,7 +40,7 @@
 #include <asm/io.h>
 
 #define DRV_NAME	"ehea"
-#define DRV_VERSION	"EHEA_0083"
+#define DRV_VERSION	"EHEA_0083a"
 
 /* eHEA capability flags */
 #define DLPAR_PORT_ADD_REM 1
diff -Nurp linux-2.6.24.4.org/drivers/net/ehea/ehea_main.c linux-2.6.24.4/drivers/net/ehea/ehea_main.c
--- linux-2.6.24.4.org/drivers/net/ehea/ehea_main.c	2008-03-25 12:42:18.000000000 +0100
+++ linux-2.6.24.4/drivers/net/ehea/ehea_main.c	2008-03-25 13:13:12.000000000 +0100
@@ -2945,7 +2945,7 @@ struct ehea_port *ehea_setup_single_port
 	dev->vlan_rx_add_vid = ehea_vlan_rx_add_vid;
 	dev->vlan_rx_kill_vid = ehea_vlan_rx_kill_vid;
 	dev->features = NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_TSO
-		      | NETIF_F_HIGHDMA | NETIF_F_HW_CSUM | NETIF_F_HW_VLAN_TX
+		      | NETIF_F_HIGHDMA | NETIF_F_IP_CSUM | NETIF_F_HW_VLAN_TX
 		      | NETIF_F_HW_VLAN_RX | NETIF_F_HW_VLAN_FILTER
 		      | NETIF_F_LLTX;
 	dev->tx_timeout = &ehea_tx_watchdog;
