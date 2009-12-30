Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbZL3TI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbZL3TI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 14:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbZL3TI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 14:08:58 -0500
Received: from exprod6og115.obsmtp.com ([64.18.1.35]:56648 "HELO
	exprod6og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751577AbZL3TI6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 14:08:58 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/media/video/cx23885/cx23885-dvb.c: use %pM to show MAC address
Date: Wed, 30 Dec 2009 14:08:57 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F64E@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/media/video/cx23885/cx23885-dvb.c: use %pM to show MAC address
Thread-Index: AcqJg4mhoQZkyX+SR0er+5i2G9YAYw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Cc: <stoth@kernellabs.com>
X-OriginalArrivalTime: 30 Dec 2009 19:08:56.0199 (UTC) FILETIME=[88C7B170:01CA8983]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Steven Toth <stoth@kernellabs.com>

---

diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
index e45d2df..f9243de 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -994,15 +994,8 @@ static int dvb_register(struct cx23885_tsport *port)
 		netup_get_card_info(&dev->i2c_bus[0].i2c_adap, &cinfo);
 		memcpy(port->frontends.adapter.proposed_mac,
 				cinfo.port[port->nr - 1].mac, 6);
-		printk(KERN_INFO "NetUP Dual DVB-S2 CI card port%d MAC="
-			"%02X:%02X:%02X:%02X:%02X:%02X\n",
-			port->nr,
-			port->frontends.adapter.proposed_mac[0],
-			port->frontends.adapter.proposed_mac[1],
-			port->frontends.adapter.proposed_mac[2],
-			port->frontends.adapter.proposed_mac[3],
-			port->frontends.adapter.proposed_mac[4],
-			port->frontends.adapter.proposed_mac[5]);
+		printk(KERN_INFO "NetUP Dual DVB-S2 CI card port%d MAC=%pM\n",
+			port->nr, port->frontends.adapter.proposed_mac);
 
 		netup_ci_init(port);
 		break; 
