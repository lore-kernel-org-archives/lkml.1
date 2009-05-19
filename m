Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbZESBC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbZESBC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 21:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756548AbZESBCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 21:02:39 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:38255 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581AbZESBCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 21:02:37 -0400
Subject: [PATCH] PCI: eliminate redundant pci_stop_dev() call from
	pci_destroy_dev()
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 18 May 2009 19:02:38 -0600
Message-ID: <20090519010222.12679.74898.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We always call pci_stop_bus_device before calling pci_destroy_dev.

Since pci_stop_bus_device calls pci_stop_dev, there is no need
for pci_destroy_dev to repeat the call.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/remove.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 86503c1..176615e 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -32,8 +32,6 @@ static void pci_stop_dev(struct pci_dev *dev)
 
 static void pci_destroy_dev(struct pci_dev *dev)
 {
-	pci_stop_dev(dev);
-
 	/* Remove the device from the device lists, and prevent any further
 	 * list accesses from this device */
 	down_write(&pci_bus_sem);

