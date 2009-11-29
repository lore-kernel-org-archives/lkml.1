Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbZK2Pzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbZK2Pzg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 10:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbZK2Pzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 10:55:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbZK2Pzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 10:55:35 -0500
Date: Sun, 29 Nov 2009 17:52:01 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
       "Michael S. Tsirkin" <mst@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org,
       Anthony Liguori <anthony@codemonkey.ws>, kvm@vger.kernel.org,
       Yan Vugenfirer <yvugenfi@redhat.com>
Subject: [PATCH] virtio: set pci bus master enable bit
Message-ID: <20091129155200.GA6667@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As all virtio devices perform DMA, we
must enable bus mastering for them to be
spec compliant.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_pci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 28d9cf7..717bae1 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -648,6 +648,7 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
 		goto out_req_regions;
 
 	pci_set_drvdata(pci_dev, vp_dev);
+	pci_set_master(pci_dev);
 
 	/* we use the subsystem vendor/device id as the virtio vendor/device
 	 * id.  this allows us to use the same PCI vendor/device id for all
-- 
1.6.5.2.143.g8cc62
