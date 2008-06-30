Return-Path: <linux-kernel-owner+w=401wt.eu-S1762637AbYF3Sgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762637AbYF3Sgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbYF3Sge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:36:34 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:10782 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbYF3Sgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:36:33 -0400
Date: Mon, 30 Jun 2008 11:35:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Cc: mb@bu3sch.de, jbarnes@virtuousgeek.org,
       jejb <James.Bottomley@HansenPartnership.com>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH] PCI: add stub for pci_set_consistent_dma_mask()
Message-Id: <20080630113553.c133307f.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

When CONFIG_PCI=n, there is no stub for pci_set_consistent_dma_mask(),
so add one like other similar stubs.  Otherwise there can be build errors,
as here:

linux-next-20080630/drivers/ssb/main.c:1175: error: implicit declaration of function 'pci_set_consistent_dma_mask'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/pci.h |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-next-20080630.orig/include/linux/pci.h
+++ linux-next-20080630/include/linux/pci.h
@@ -854,6 +854,11 @@ static inline int pci_set_dma_mask(struc
 	return -EIO;
 }
 
+static inline int pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
+{
+	return -EIO;
+}
+
 static inline int pci_set_dma_max_seg_size(struct pci_dev *dev,
 					unsigned int size)
 {


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
