Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbZL3UAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbZL3UAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 15:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbZL3UAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 15:00:32 -0500
Received: from exprod6og108.obsmtp.com ([64.18.1.21]:46798 "HELO
	exprod6og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753121AbZL3UAb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 15:00:31 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/media/dvb/dvb-core/dvb_net.c: use %pM to show MAC address
Date: Wed, 30 Dec 2009 15:00:31 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F66B@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/media/dvb/dvb-core/dvb_net.c: use %pM to show MAC address
Thread-Index: AcqJir2+4KpV9iH4StuRyMG0LFGbYQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Cc: "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 30 Dec 2009 20:00:29.0534 (UTC) FILETIME=[BC8D27E0:01CA898A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address and mask.

The only difference in the output is that the output is shown in
the usual colon-separated hex notation.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

diff --git a/drivers/media/dvb/dvb-core/dvb_net.c b/drivers/media/dvb/dvb-core/dvb_net.c
index 8b8558f..da6552d 100644
--- a/drivers/media/dvb/dvb-core/dvb_net.c
+++ b/drivers/media/dvb/dvb-core/dvb_net.c
@@ -949,11 +949,8 @@ static int dvb_net_filter_sec_set(struct net_device *dev,
 	(*secfilter)->filter_mask[10] = mac_mask[1];
 	(*secfilter)->filter_mask[11]=mac_mask[0];
 
-	dprintk("%s: filter mac=%02x %02x %02x %02x %02x %02x\n",
-	       dev->name, mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
-	dprintk("%s: filter mask=%02x %02x %02x %02x %02x %02x\n",
-	       dev->name, mac_mask[0], mac_mask[1], mac_mask[2],
-	       mac_mask[3], mac_mask[4], mac_mask[5]);
+	dprintk("%s: filter mac=%pM\n", dev->name, mac);
+	dprintk("%s: filter mask=%pM\n", dev->name, mac_mask);
 
 	return 0;
 } 
