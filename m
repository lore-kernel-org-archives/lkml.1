Return-Path: <linux-kernel-owner+w=401wt.eu-S1759381AbYDCAdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381AbYDCAdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 20:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbYDCAdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 20:33:39 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:39551 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbYDCAdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 20:33:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BVYBAwJ0LmaQ+NqH8Miwci8g9+TBaYxcloz/TEJ84nPjyiRuzLAfZWi4N0xWT41fJ92GhDYYhNz1m9UZh4LbqYOWY1Vf9UNdQP4P/z44/P/nMR+IN7ZwyCn1bo0Dqx6HSYJOBvfw5AhEJvTeCgKf73DTRn+6z55D5kpCcmdtMww=
Subject: [PATCH 1/7] virtio: fix sparse return void-valued expression
	warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 17:33:34 -0700
Message-Id: <1207182814.5740.20.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/virtio/virtio_pci.c:148:2: warning: returning void-valued expression
drivers/virtio/virtio_pci.c:155:2: warning: returning void-valued expression

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/virtio/virtio_pci.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index c0df924..de102a6 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -145,14 +145,14 @@ static void vp_set_status(struct virtio_device *vdev, u8 status)
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	/* We should never be setting status to 0. */
 	BUG_ON(status == 0);
-	return iowrite8(status, vp_dev->ioaddr + VIRTIO_PCI_STATUS);
+	iowrite8(status, vp_dev->ioaddr + VIRTIO_PCI_STATUS);
 }
 
 static void vp_reset(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	/* 0 status means a reset. */
-	return iowrite8(0, vp_dev->ioaddr + VIRTIO_PCI_STATUS);
+	iowrite8(0, vp_dev->ioaddr + VIRTIO_PCI_STATUS);
 }
 
 /* the notify function used when creating a virt queue */
-- 
1.5.5.rc1.135.g8527


