Return-Path: <linux-kernel-owner+w=401wt.eu-S1752549AbZCIFtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbZCIFtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 01:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbZCIFso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 01:48:44 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:46819 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbZCIFsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 01:48:43 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v3 01/11] PCI: pci_is_root_bus helper
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>
Date: Sun, 08 Mar 2009 23:48:40 -0600
Message-ID: <20090309054840.3918.16089.stgit@bob.kio>
In-Reply-To: <20090309052933.3918.86601.stgit@bob.kio>
References: <20090309052933.3918.86601.stgit@bob.kio>
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
pci_bus->self == NULL on a root bus, which is _not_ always true).

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

