Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbZGCM0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbZGCM0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbZGCM0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:26:01 -0400
Received: from mail-bw0-f207.google.com ([209.85.218.207]:61294 "EHLO
	mail-bw0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbZGCM0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:26:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JtGyurJaKfQ0uQL+rajvGeSNhzX9DVnv+N+JjPDtSLnavNVV407VEAIhsy4fMvKNg7
         BI3ONYfsu6gMODYSc0cogjEbrz3wdAxBGjbfJ3T8RNJHyZOE9kkc9FZDOdQlGHGpIAY9
         dah5DRI5wx9uWauGFS9Kyz6I3KnZGRMLKucYk=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH 1/4] Staging: at76_usb: fix !CONFIG_WIRELESS_EXT build
Date: Fri,  3 Jul 2009 16:25:50 +0400
Message-Id: <1246623953-23215-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this build error when CONFIG_WIRELESS_EXT is not set
at76_usb.c:5322: error: 'struct net_device' has no member named 'wireless_data'
at76_usb.c:5325: error: 'struct net_device' has no member named 'wireless_handlers'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/at76_usb/at76_usb.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/at76_usb/at76_usb.c b/drivers/staging/at76_usb/at76_usb.c
index 3f303ae..8339504 100644
--- a/drivers/staging/at76_usb/at76_usb.c
+++ b/drivers/staging/at76_usb/at76_usb.c
@@ -5319,10 +5319,12 @@ static int at76_init_new_device(struct at76_priv *priv,
 
 	/* Add pointers to enable iwspy support. */
 	priv->wireless_data.spy_data = &priv->spy_data;
+#ifdef CONFIG_WIRELESS_EXT
 	netdev->wireless_data = &priv->wireless_data;
+	netdev->wireless_handlers = &at76_handler_def;
+#endif
 
 	netdev->watchdog_timeo = 2 * HZ;
-	netdev->wireless_handlers = &at76_handler_def;
 	dev_alloc_name(netdev, "wlan%d");
 
 	ret = register_netdev(priv->netdev);
-- 
1.6.3.3

