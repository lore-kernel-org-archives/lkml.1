Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbZGGH1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbZGGH1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 03:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZGGH1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 03:27:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56966 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbZGGH1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 03:27:07 -0400
Subject: [PATCH] virtio-pci: correctly unregister root device on error
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Don Zickus <dzickus@redhat.com>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 08:26:45 +0100
Message-Id: <1246951605.2836.8.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If pci_register_driver() fails we're incorrectly unregistering the root
device with device_unregister() rather than root_device_unregister().

Reported-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/virtio/virtio_pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 330aacb..2cafa62 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -440,7 +440,7 @@ static int __init virtio_pci_init(void)
 
 	err = pci_register_driver(&virtio_pci_driver);
 	if (err)
-		device_unregister(virtio_pci_root);
+		root_device_unregister(virtio_pci_root);
 
 	return err;
 }
-- 
1.6.2.5

