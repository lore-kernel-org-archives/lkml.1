Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbYFMMxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbYFMMxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 08:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbYFMMxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 08:53:23 -0400
Received: from mail14.svc.cra.dublin.eircom.net ([159.134.118.30]:30831 "HELO
	mail14.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754618AbYFMMxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 08:53:23 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jun 2008 08:53:22 EDT
From: Mark McLoughlin <markmc@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 2/2] virtio: Complete feature negotation before updating status
Date: Fri, 13 Jun 2008 13:46:41 +0100
Message-Id: <1213361201-10854-2-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1213361201-10854-1-git-send-email-markmc@redhat.com>
References: <1213361201-10854-1-git-send-email-markmc@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lguest (in rusty's use-tun-ringfd patch) assumes that the
guest has updated its feature bits before setting its status
to VIRTIO_CONFIG_S_DRIVER_OK.

That's pretty reasonable, so let's make it so.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/virtio/virtio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index ab0aca7..fc85cba 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -117,9 +117,9 @@ static int virtio_dev_probe(struct device *_d)
 	if (err)
 		add_status(dev, VIRTIO_CONFIG_S_FAILED);
 	else {
-		add_status(dev, VIRTIO_CONFIG_S_DRIVER_OK);
 		/* They should never have set feature bits beyond 32 */
 		dev->config->set_features(dev, dev->features[0]);
+		add_status(dev, VIRTIO_CONFIG_S_DRIVER_OK);
 	}
 	return err;
 }
-- 
1.5.4.1

