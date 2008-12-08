Return-Path: <linux-kernel-owner+w=401wt.eu-S1758351AbYLHL4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351AbYLHL4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbYLHLxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:53:11 -0500
Received: from mail26.svc.cra.dublin.eircom.net ([159.134.118.55]:43896 "HELO
	mail26.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753495AbYLHLxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:53:09 -0500
From: Mark McLoughlin <markmc@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, lguest@ozlabs.org,
       Jiri Slaby <jirislaby@gmail.com>, Greg KH <gregkh@suse.de>,
       Mark McLoughlin <markmc@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 2/2] lguest: struct device - replace bus_id with dev_name()
Date: Mon,  8 Dec 2008 11:51:46 +0000
Message-Id: <1228737106-20034-2-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1228737106-20034-1-git-send-email-markmc@redhat.com>
References: <>
 <1228737106-20034-1-git-send-email-markmc@redhat.com>
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
index 40fa973..3a1440a 100644
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

