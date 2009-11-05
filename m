Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbZKEIT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbZKEIT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 03:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755879AbZKEIT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 03:19:26 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46609 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870AbZKEITZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 03:19:25 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: mst@redhat.com
Cc: rusty@rustcorp.com.au, Sam Ravnborg <sam@ravnborg.org>,
       "David S. Miller" <davem@davemloft.net>,
       Alex Williamson <alex.williamson@hp.com>,
       Mark McLoughlin <markmc@redhat.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] virtio_net: rename driver struct to please modpost
Date: Thu,  5 Nov 2009 09:17:17 +0100
Message-Id: <1257409037-29916-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <200911051510.54163.rusty@rustcorp.com.au>
References: <200911051510.54163.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-PTX-Original-Recipient: ukl@pengutronix.de
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit

	3d1285b (move virtnet_remove to .devexit.text)

introduced the first reference to __devexit in struct virtio_driver
virtio_net which upset modpost ("Section mismatch in reference from the
variable virtio_net to the function .devexit.text:virtnet_remove()").

Fix this by renaming virtio_net to virtio_net_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reported-by: Michael S. Tsirkin <mst@redhat.com>
Blame-taken-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Alex Williamson <alex.williamson@hp.com>
Cc: Mark McLoughlin <markmc@redhat.com>
Cc: netdev@vger.kernel.org
---
Hello,

@Rusty: IMHO there's no need to apologize.  The driver was enhanced by
3d1285b and I consider it OK not to notice the (false) section warning.
(But if you think it was you who took my first patch, then you forgot to
add you S-o-b which is a worse trespass :-)

Best regards
Uwe

 drivers/net/virtio_net.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 05630f2..b9e002f 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -998,7 +998,7 @@ static unsigned int features[] = {
 	VIRTIO_NET_F_CTRL_RX, VIRTIO_NET_F_CTRL_VLAN,
 };
 
-static struct virtio_driver virtio_net = {
+static struct virtio_driver virtio_net_driver = {
 	.feature_table = features,
 	.feature_table_size = ARRAY_SIZE(features),
 	.driver.name =	KBUILD_MODNAME,
@@ -1011,12 +1011,12 @@ static struct virtio_driver virtio_net = {
 
 static int __init init(void)
 {
-	return register_virtio_driver(&virtio_net);
+	return register_virtio_driver(&virtio_net_driver);
 }
 
 static void __exit fini(void)
 {
-	unregister_virtio_driver(&virtio_net);
+	unregister_virtio_driver(&virtio_net_driver);
 }
 module_init(init);
 module_exit(fini);
-- 
1.6.5.2


