Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbZL3Ti2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbZL3Ti2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 14:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZL3Ti1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 14:38:27 -0500
Received: from exprod6og106.obsmtp.com ([64.18.1.191]:58870 "HELO
	exprod6og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753212AbZL3Ti0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 14:38:26 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/atm/fore200e.c: use %pM to show MAC address
Date: Wed, 30 Dec 2009 14:38:25 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F663@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/atm/fore200e.c: use %pM to show MAC address
Thread-Index: AcqJh6d2BiW0sqA9QKO64PHBMxQAAg==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Cc: "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 30 Dec 2009 19:38:24.0057 (UTC) FILETIME=[A6816A90:01CA8987]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

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
