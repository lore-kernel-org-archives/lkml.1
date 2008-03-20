Return-Path: <linux-kernel-owner+w=401wt.eu-S1759026AbYCTBfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026AbYCTBfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 21:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYCTBfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 21:35:24 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:49822 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbYCTBfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 21:35:22 -0400
From: Anthony Liguori <aliguori@us.ibm.com>
To: virtualization@lists.linux-foundation.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Marcelo Tosatti <mtosatti@redhat.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Anthony Liguori <aliguori@us.ibm.com>
Subject: [PATCH] virtio_pci: unregister virtio device at device remove
Date: Wed, 19 Mar 2008 20:35:04 -0500
Message-Id: <1205976904-19592-1-git-send-email-aliguori@us.ibm.com>
X-Mailer: git-send-email 1.5.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure to call unregister_virtio_device() when a virtio device is removed.
Otherwise, virtio_pci.ko cannot be rmmod'd.

This was spotted by Marcelo Tosatti.

Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 59a8f73..6c8ecde 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -388,6 +388,7 @@ static void __devexit virtio_pci_remove(struct pci_dev *pci_dev)
 {
 	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
 
+	unregister_virtio_device(&vp_dev->vdev);
 	free_irq(pci_dev->irq, vp_dev);
 	pci_set_drvdata(pci_dev, NULL);
 	pci_iounmap(pci_dev, vp_dev->ioaddr);
