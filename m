Return-Path: <linux-kernel-owner+w=401wt.eu-S1757542AbZC3Qyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbZC3Qyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 12:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756605AbZC3QuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 12:50:13 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:10240 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576AbZC3QuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 12:50:10 -0400
Subject: [PATCH v2 1/3] PCI: allow PCI core hotplug to remove PCI root bus
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 30 Mar 2009 10:50:09 -0600
Message-ID: <20090330165009.18855.43672.stgit@bob.kio>
In-Reply-To: <20090330164737.18855.7137.stgit@bob.kio>
References: <20090330164737.18855.7137.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason to prevent removal of root bus devices. A subsequent
rescan will find them just fine.

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

