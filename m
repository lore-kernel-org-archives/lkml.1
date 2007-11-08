Return-Path: <linux-kernel-owner+w=401wt.eu-S1760647AbXKHCrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760647AbXKHCrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 21:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbXKHCqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 21:46:40 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:56657 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbXKHCqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 21:46:38 -0500
From: Anthony Liguori <aliguori@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Anthony Liguori <aliguori@us.ibm.com>,
       Rusty Russell <rusty@rusycorp.com.au>, virtualization@lists.osdl.org,
       kvm-devel@lists.sourceforge.net
Subject: [PATCH 1/3] Export vring functions for modules to use
Date: Wed,  7 Nov 2007 20:46:30 -0600
Message-Id: <11944900141678-git-send-email-aliguori@us.ibm.com>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <11944899922822-git-send-email-aliguori@us.ibm.com>
References: <11944899922822-git-send-email-aliguori@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for the virtio PCI device to be compiled as a module.

Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 0e1bf05..3f28b47 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -260,6 +260,8 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
 	return IRQ_HANDLED;
 }
 
+EXPORT_SYMBOL_GPL(vring_interrupt);
+
 static struct virtqueue_ops vring_vq_ops = {
 	.add_buf = vring_add_buf,
 	.get_buf = vring_get_buf,
@@ -306,8 +308,12 @@ struct virtqueue *vring_new_virtqueue(unsigned int num,
 	return &vq->vq;
 }
 
+EXPORT_SYMBOL_GPL(vring_new_virtqueue);
+
 void vring_del_virtqueue(struct virtqueue *vq)
 {
 	kfree(to_vvq(vq));
 }
 
+EXPORT_SYMBOL_GPL(vring_del_virtqueue);
+
