Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbZL3URO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbZL3URO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 15:17:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbZL3URN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 15:17:13 -0500
Received: from exprod6ob109.obsmtp.com ([64.18.1.22]:49226 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753057AbZL3URM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 15:17:12 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/net/skfp/skfddi.c: use %pM to show MAC address
Date: Wed, 30 Dec 2009 15:17:13 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F672@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/net/skfp/skfddi.c: use %pM to show MAC address
Thread-Index: AcqJjRK+lolK6rKKSwiYbtLRy/yE8Q==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Cc: "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 30 Dec 2009 20:17:10.0939 (UTC) FILETIME=[116F6EB0:01CA898D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

The only difference in the output is that the MAC address is
shown in the usual colon-separated hex notation.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

diff --git a/drivers/net/skfp/skfddi.c b/drivers/net/skfp/skfddi.c
index db216a7..4f17c9d 100644
--- a/drivers/net/skfp/skfddi.c
+++ b/drivers/net/skfp/skfddi.c
@@ -435,13 +435,7 @@ static  int skfp_driver_init(struct net_device *dev)
 		goto fail;
 	}
 	read_address(smc, NULL);
-	pr_debug(KERN_INFO "HW-Addr: %02x %02x %02x %02x %02x %02x\n",
-	       smc->hw.fddi_canon_addr.a[0],
-	       smc->hw.fddi_canon_addr.a[1],
-	       smc->hw.fddi_canon_addr.a[2],
-	       smc->hw.fddi_canon_addr.a[3],
-	       smc->hw.fddi_canon_addr.a[4],
-	       smc->hw.fddi_canon_addr.a[5]);
+	pr_debug(KERN_INFO "HW-Addr: %pM\n", smc->hw.fddi_canon_addr.a);
 	memcpy(dev->dev_addr, smc->hw.fddi_canon_addr.a, 6);
 
 	smt_reset_defaults(smc, 0);
@@ -890,15 +884,8 @@ static void skfp_ctl_set_multicast_list_wo_lock(struct net_device *dev)
 							  (struct fddi_addr *)dmi->dmi_addr, 
 							  1);
 
-					pr_debug(KERN_INFO "ENABLE MC ADDRESS:");
-					pr_debug(" %02x %02x %02x ",
-					       dmi->dmi_addr[0],
-					       dmi->dmi_addr[1],
-					       dmi->dmi_addr[2]);
-					pr_debug("%02x %02x %02x\n",
-					       dmi->dmi_addr[3],
-					       dmi->dmi_addr[4],
-					       dmi->dmi_addr[5]);
+					pr_debug(KERN_INFO "ENABLE MC ADDRESS: %pM\n",
+						dmi->dmi_addr);
 					dmi = dmi->next;
 				}	// for
  
