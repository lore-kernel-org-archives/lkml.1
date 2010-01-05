Return-Path: <linux-kernel-owner+w=401wt.eu-S1755087Ab0AEQlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab0AEQlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 11:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132Ab0AEQlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 11:41:13 -0500
Received: from [206.15.93.42] ([206.15.93.42]:6958 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755052Ab0AEQkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 11:40:39 -0500
X-Greylist: delayed 1092 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jan 2010 11:40:34 EST
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/atm/fore200e.c: use %pM to show MAC address
Date: Tue, 5 Jan 2010 09:22:20 -0700
Cc: netdev@vger.kernel.org, davem@davemloft.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001050922.20870.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

Repost due to merge issues.

diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
index bc53fed..f7d6eba 100644
--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -2064,12 +2064,10 @@ fore200e_get_esi(struct fore200e* fore200e)
 	return -EBUSY;
     }
 	
-    printk(FORE200E "device %s, rev. %c, S/N: %d, ESI: %02x:%02x:%02x:%02x:%02x:%02x\n", 
+    printk(FORE200E "device %s, rev. %c, S/N: %d, ESI: %pM\n",
 	   fore200e->name, 
 	   (prom->hw_revision & 0xFF) + '@',    /* probably meaningless with SBA boards */
-	   prom->serial_number & 0xFFFF,
-	   prom->mac_addr[ 2 ], prom->mac_addr[ 3 ], prom->mac_addr[ 4 ],
-	   prom->mac_addr[ 5 ], prom->mac_addr[ 6 ], prom->mac_addr[ 7 ]);
+	   prom->serial_number & 0xFFFF, &prom->mac_addr[2]);
 	
     for (i = 0; i < ESI_LEN; i++) {
 	fore200e->esi[ i ] = fore200e->atm_dev->esi[ i ] = prom->mac_addr[ i + 2 ];
@@ -2845,13 +2843,12 @@ fore200e_proc_read(struct atm_dev *dev, loff_t* pos, char* page)
 		"   interrupt line:\t\t%s\n"
 		"   physical base address:\t0x%p\n"
 		"   virtual base address:\t0x%p\n"
-		"   factory address (ESI):\t%02x:%02x:%02x:%02x:%02x:%02x\n"
+		"   factory address (ESI):\t%pM\n"
 		"   board serial number:\t\t%d\n\n",
 		fore200e_irq_itoa(fore200e->irq),
 		(void*)fore200e->phys_base,
 		fore200e->virt_base,
-		fore200e->esi[0], fore200e->esi[1], fore200e->esi[2],
-		fore200e->esi[3], fore200e->esi[4], fore200e->esi[5],
+		fore200e->esi,
 		fore200e->esi[4] * 256 + fore200e->esi[5]);
 
 	return len;
