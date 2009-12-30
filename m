Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZL3Ty4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZL3Ty4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 14:54:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbZL3Tyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 14:54:55 -0500
Received: from exprod6ob114.obsmtp.com ([64.18.1.32]:49912 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751416AbZL3Tyz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 14:54:55 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/infiniband/hw/cxgb3/iwch_cm.c: use %pM to show MAC address
Date: Wed, 30 Dec 2009 14:54:54 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F66A@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/infiniband/hw/cxgb3/iwch_cm.c: use %pM to show MAC address
Thread-Index: AcqJifSp/hxlZNLNS0SXyi4JcYtraw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: <swise@chelsio.com>
X-OriginalArrivalTime: 30 Dec 2009 19:54:53.0143 (UTC) FILETIME=[F40BF670:01CA8989]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

The only difference in the output is that the MAC address is
shown in the usual colon-separated hex notation.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Steve Wise <swise@chelsio.com>

---

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 66b4135..d94388b 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -1371,15 +1371,8 @@ static int pass_accept_req(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 	tim.mac_addr = req->dst_mac;
 	tim.vlan_tag = ntohs(req->vlan_tag);
 	if (tdev->ctl(tdev, GET_IFF_FROM_MAC, &tim) < 0 || !tim.dev) {
-		printk(KERN_ERR
-			"%s bad dst mac %02x %02x %02x %02x %02x %02x\n",
-			__func__,
-			req->dst_mac[0],
-			req->dst_mac[1],
-			req->dst_mac[2],
-			req->dst_mac[3],
-			req->dst_mac[4],
-			req->dst_mac[5]);
+		printk(KERN_ERR "%s bad dst mac %pM\n",
+			__func__, req->dst_mac);
 		goto reject;
 	}
  
