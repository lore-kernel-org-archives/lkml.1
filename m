Return-Path: <linux-kernel-owner+w=401wt.eu-S1759171AbZC2QzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171AbZC2QzT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758800AbZC2Qyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:54:46 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:37439 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758877AbZC2Qyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:54:45 -0400
Subject: [PATCH 1/3] PCI: allow PCI core hotplug to remove PCI root bus
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 29 Mar 2009 10:54:44 -0600
Message-ID: <20090329165444.29073.36246.stgit@bob.kio>
In-Reply-To: <20090329165352.29073.5159.stgit@bob.kio>
References: <20090329165352.29073.5159.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason to prevent root bus removal. We never actually
remove the node from the pci_root_buses list, so a rescan will correctly
rediscover the root bus.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/pci-sysfs.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index e9a8706..7b2cb27 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -277,14 +277,10 @@ remove_store(struct device *dev, struct device_attribute *dummy,
 {
 	int ret = 0;
 	unsigned long val;
-	struct pci_dev *pdev = to_pci_dev(dev);
 
 	if (strict_strtoul(buf, 0, &val) < 0)
 		return -EINVAL;
 
-	if (pci_is_root_bus(pdev->bus))
-		return -EBUSY;
-
 	/* An attribute cannot be unregistered by one of its own methods,
 	 * so we have to use this roundabout approach.
 	 */

