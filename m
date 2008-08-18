Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbYHRQoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbYHRQoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbYHRQoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:44:09 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50878 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398AbYHRQoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:44:08 -0400
Message-ID: <48A9A6C0.6070109@linux.vnet.ibm.com>
Date: Mon, 18 Aug 2008 09:43:44 -0700
From: Cordelia <cordsam@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] pci: Changed list_for_each to list_for_each_entry
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cordelia Sam <cordesam@gmail.com>
---
 drivers/pci/probe.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index a04498d..6a7ba36 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1245,13 +1245,11 @@ static int __init pci_sort_bf_cmp(const struct pci_dev *a, const struct pci_dev
  */
 static void __init pci_insertion_sort_klist(struct pci_dev *a, struct list_head *list)
 {
-	struct list_head *pos;
 	struct klist_node *n;
 	struct device *dev;
 	struct pci_dev *b;
 
-	list_for_each(pos, list) {
-		n = container_of(pos, struct klist_node, n_node);
+	list_for_each_entry(n, list, n_node) {
 		dev = container_of(n, struct device, knode_bus);
 		b = to_pci_dev(dev);
 		if (pci_sort_bf_cmp(a, b) <= 0) {
-- 
1.5.4.3
