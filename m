Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbYDGUdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbYDGUdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 16:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbYDGUdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 16:33:32 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:49886 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbYDGUdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 16:33:19 -0400
From: Anthony Liguori <aliguori@us.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
       Anthony Liguori <aliguori@us.ibm.com>
Subject: [PATCH] virtio_net: remove overzealous printk
Date: Mon,  7 Apr 2008 15:33:16 -0500
Message-Id: <1207600396-28454-1-git-send-email-aliguori@us.ibm.com>
X-Mailer: git-send-email 1.5.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'disable_cb' is really just a hint and as such, it's possible for more
work to get queued up while callbacks are disabled.  Under stress with an
SMP guest, this printk triggers very frequently.  There is no race here, this
is how things are designed to work so let's just remove the printk.

Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index b58472c..d1a200f 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -284,7 +284,6 @@ again:
 		/* Activate callback for using skbs: if this returns false it
 		 * means some were used in the meantime. */
 		if (unlikely(!vi->svq->vq_ops->enable_cb(vi->svq))) {
-			printk("Unlikely: restart svq race\n");
 			vi->svq->vq_ops->disable_cb(vi->svq);
 			netif_start_queue(dev);
 			goto again;
