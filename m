Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbZLBVKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbZLBVKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 16:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbZLBVKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 16:10:40 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:50194 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbZLBVKk (ORCPT
	<rfc822;groupwise-PMullaney@novell.com:0:0>);
	Wed, 2 Dec 2009 16:10:40 -0500
From: Patrick Mullaney <pmullaney@novell.com>
Subject: [PATCH 1/2] venet-macvlan: correctly remove newline from lower device
	name
To: alacrityvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 02 Dec 2009 16:10:26 -0500
Message-ID: <20091202211026.5116.67536.stgit@mimic.site>
In-Reply-To: <20091202204722.5116.33183.stgit@mimic.site>
References: <20091202204722.5116.33183.stgit@mimic.site>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Patrick Mullaney <pmullaney@novell.com>
---

 kernel/vbus/devices/venet/macvlan.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/vbus/devices/venet/macvlan.c b/kernel/vbus/devices/venet/macvlan.c
index 8724e26..432ff5d 100644
--- a/kernel/vbus/devices/venet/macvlan.c
+++ b/kernel/vbus/devices/venet/macvlan.c
@@ -350,7 +350,11 @@ ll_ifname_store(struct vbus_device *dev, struct vbus_device_attribute *attr,
 	if (priv->dev.vbus.opened)
 		return -EINVAL;
 
-	strncpy(priv->ll_ifname, buf, count-1);
+	memcpy(priv->ll_ifname, buf, count);
+
+	/* remove trailing newline if present */
+	if (priv->ll_ifname[count-1] == '\n')
+		priv->ll_ifname[count-1] = '\0';
 
 	if (priv->mdev.lowerdev) {
 		dev_put(priv->mdev.lowerdev);

