Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbZKWTyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbZKWTyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 14:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756622AbZKWTys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 14:54:48 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:41446 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580AbZKWTyq (ORCPT
	<rfc822;groupwise-GHaskins@novell.com:0:0>);
	Mon, 23 Nov 2009 14:54:46 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [-next PATCH 4/4] vbus: fix pcibridge busmaster support
To: linux-next@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net
Date: Mon, 23 Nov 2009 14:54:49 -0500
Message-ID: <20091123195449.8184.18927.stgit@dev.haskins.net>
In-Reply-To: <20091123195136.8184.68042.stgit@dev.haskins.net>
References: <20091123195136.8184.68042.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should technically enable the busmaster bit, even though its not
actually used on the host side

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 drivers/vbus/pci-bridge.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/vbus/pci-bridge.c b/drivers/vbus/pci-bridge.c
index ddc3f39..962ef58 100644
--- a/drivers/vbus/pci-bridge.c
+++ b/drivers/vbus/pci-bridge.c
@@ -932,6 +932,8 @@ vbus_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret < 0)
 		return ret;
 
+	pci_set_master(pdev);
+
 	ret = pci_request_regions(pdev, VBUS_PCI_NAME);
 	if (ret < 0) {
 		printk(KERN_ERR "VBUS_PCI: Could not init BARs: %d\n", ret);

