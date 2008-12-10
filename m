Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbYLJRse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbYLJRse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 12:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbYLJRrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 12:47:10 -0500
Received: from mail05.svc.cra.dublin.eircom.net ([159.134.118.21]:31106 "HELO
	mail05.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753023AbYLJRrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 12:47:07 -0500
From: Mark McLoughlin <markmc@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Anthony Liguori <aliguori@us.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
       Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 6/6] lguest: struct device - replace bus_id with dev_name()
Date: Wed, 10 Dec 2008 17:45:39 +0000
Message-Id: <1228931139-12956-6-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1228931139-12956-5-git-send-email-markmc@redhat.com>
References: <1228931096.5384.63.camel@blaa>
 <1228931139-12956-1-git-send-email-markmc@redhat.com>
 <1228931139-12956-2-git-send-email-markmc@redhat.com>
 <1228931139-12956-3-git-send-email-markmc@redhat.com>
 <1228931139-12956-4-git-send-email-markmc@redhat.com>
 <1228931139-12956-5-git-send-email-markmc@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bus_id is gradually being removed, so use dev_name() instead.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/lguest/lguest_device.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/lguest/lguest_device.c b/drivers/lguest/lguest_device.c
index 109b052..81243f1 100644
--- a/drivers/lguest/lguest_device.c
+++ b/drivers/lguest/lguest_device.c
@@ -272,7 +272,7 @@ static struct virtqueue *lg_find_vq(struct virtio_device *vdev,
 	 * the interrupt as a source of randomness: it'd be nice to have that
 	 * back.. */
 	err = request_irq(lvq->config.irq, vring_interrupt, IRQF_SHARED,
-			  vdev->dev.bus_id, vq);
+			  dev_name(&vdev->dev), vq);
 	if (err)
 		goto destroy_vring;
 
-- 
1.5.4.3

