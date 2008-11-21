Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669AbYKUTfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbYKUTfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 14:35:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbYKUTfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 14:35:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:42150 "EHLO mga02.intel.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753039AbYKUTfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 14:35:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,645,1220252400"; 
   d="scan'208";a="465873892"
Date: Sat, 22 Nov 2008 02:38:21 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: "achiang@hp.com" <achiang@hp.com>,
       "bjorn.helgaas@hp.com" <bjorn.helgaas@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "greg@kroah.com" <greg@kroah.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "horms@verge.net.au" <horms@verge.net.au>,
       "yinghai@kernel.org" <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: [PATCH 1/13 v7] PCI: enhance pci_ari_enabled()
Message-ID: <20081121183821.GB7810@yzhao12-linux.sh.intel.com>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change parameter of pci_ari_enabled() from 'pci_dev' to 'pci_bus'.

ARI forwarding on the bridge mostly concerns the subordinate devices
rather than the bridge itself. So this change will make the function
easier to use.

Signed-off-by: Yu Zhao <yu.zhao@intel.com>

---
 drivers/pci/pci.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 9de87e9..1449884 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -162,13 +162,13 @@ struct pci_slot_attribute {
 extern void pci_enable_ari(struct pci_dev *dev);
 /**
  * pci_ari_enabled - query ARI forwarding status
- * @dev: the PCI device
+ * @bus: the PCI bus
  *
  * Returns 1 if ARI forwarding is enabled, or 0 if not enabled;
  */
-static inline int pci_ari_enabled(struct pci_dev *dev)
+static inline int pci_ari_enabled(struct pci_bus *bus)
 {
-	return dev->ari_enabled;
+	return bus->self && bus->self->ari_enabled;
 }
 
 #endif /* DRIVERS_PCI_H */
-- 
1.5.6.4

