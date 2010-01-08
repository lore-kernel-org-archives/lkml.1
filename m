Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175Ab0AHWBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab0AHWBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 17:01:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123Ab0AHWBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 17:01:46 -0500
Received: from mail2.shareable.org ([80.68.89.115]:36301 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab0AHWBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 17:01:46 -0500
Date: Fri, 8 Jan 2010 22:01:43 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Add __devexit_p around reference to virtio_pci_remove
Message-ID: <20100108220143.GA2133@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed to compile with CONFIG_VIRTIO_PCI=y,
because virtio_pci_remove is marked __devexit.

Signed-off-by: Jamie Lokier <jamie@shareable.org>
---
 drivers/virtio/virtio_pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 28d9cf7..1d5191f 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -702,7 +702,7 @@ static struct pci_driver virtio_pci_driver = {
 	.name		= "virtio-pci",
 	.id_table	= virtio_pci_id_table,
 	.probe		= virtio_pci_probe,
-	.remove		= virtio_pci_remove,
+	.remove		= __devexit_p(virtio_pci_remove),
 #ifdef CONFIG_PM
 	.suspend	= virtio_pci_suspend,
 	.resume		= virtio_pci_resume,
-- 
1.6.3.3

