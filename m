Return-Path: <linux-kernel-owner+w=401wt.eu-S932337AbZJAIaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbZJAIaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932315AbZJAIaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:30:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56746 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147AbZJAI36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:29:58 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alex Williamson <alex.williamson@hp.com>,
       Mark McLoughlin <markmc@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH 30/34] move virtnet_remove to .devexit.text
Date: Thu,  1 Oct 2009 10:28:34 +0200
Message-Id: <1254385718-14254-30-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <20091001082607.GA2181@pengutronix.de>
References: <20091001082607.GA2181@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function virtnet_remove is used only wrapped by __devexit_p so define
it using __devexit.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alex Williamson <alex.williamson@hp.com>
Cc: Mark McLoughlin <markmc@redhat.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/virtio_net.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index d445845..8d00976 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -948,7 +948,7 @@ free:
 	return err;
 }
 
-static void virtnet_remove(struct virtio_device *vdev)
+static void __devexit virtnet_remove(struct virtio_device *vdev)
 {
 	struct virtnet_info *vi = vdev->priv;
 	struct sk_buff *skb;
-- 
1.6.4.3

