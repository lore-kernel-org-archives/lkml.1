Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbZCRWkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbZCRWkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 18:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756784AbZCRWje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 18:39:34 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:32535 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113AbZCRWjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 18:39:32 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v4 01/12] PCI: pci_is_root_bus helper
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>
Date: Wed, 18 Mar 2009 16:39:30 -0600
Message-ID: <20090318223930.887.45421.stgit@bob.kio>
In-Reply-To: <20090318222426.887.1008.stgit@bob.kio>
References: <20090318222426.887.1008.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Introduce pci_is_root_bus helper function. This will help make code
more consistent, as well as prevent incorrect assumptions (such as
pci_bus->self == NULL on a root bus, which is not always true).

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 include/linux/pci.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 7baf2a5..a31f935 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -341,6 +341,15 @@ struct pci_bus {
 #define pci_bus_b(n)	list_entry(n, struct pci_bus, node)
 #define to_pci_bus(n)	container_of(n, struct pci_bus, dev)
 
+/*
+ * Returns true if the pci bus is root (behind host-pci bridge),
+ * false otherwise
+ */
+static inline bool pci_is_root_bus(struct pci_bus *pbus)
+{
+	return !(pbus->parent);
+}
+
 #ifdef CONFIG_PCI_MSI
 static inline bool pci_dev_msi_enabled(struct pci_dev *pci_dev)
 {

