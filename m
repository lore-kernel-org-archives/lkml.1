Return-Path: <linux-kernel-owner+w=401wt.eu-S1763363AbYHEUG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763363AbYHEUG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761995AbYHEUFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:05:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:56057 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761748AbYHEUFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:05:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=VtHgbDkhIsdEp3h9g4q2XgDxkkX1OIpYb0PtOQfQfxyRft1boRRgnxyX03lhp8DfZE
         VXzd3joNy9McwZJv9yGEJGCgqqMngX2Q9VfS73Z+JJD9km9ge5YfuTfYcIeT3ASTKkFR
         XmWLfqbdOt22xKjHkqn+89SpB4xc+pbovd8Uc=
Date: Wed, 6 Aug 2008 00:05:16 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: dhananjay@netxen.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] netxen_nic_hw.c: fix warnings
Message-ID: <20080805200516.GB17320@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>

netxen_nic_hw.c: fix warnings

drivers/net/netxen/netxen_nic_hw.c:1414: warning: format '%llx' expects	type 'long long unsigned int', but argument 3 has type 'u64'
drivers/net/netxen/netxen_nic_hw.c:1487: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'u64'


Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/net/netxen/netxen_nic_hw.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/netxen/netxen_nic_hw.c b/drivers/net/netxen/netxen_nic_hw.c
index 96a3bc6..06a517b 100644
--- a/drivers/net/netxen/netxen_nic_hw.c
+++ b/drivers/net/netxen/netxen_nic_hw.c
@@ -1411,7 +1411,8 @@ static int netxen_nic_pci_mem_read_direct(struct netxen_adapter *adapter,
 		(netxen_nic_pci_is_same_window(adapter, off+size-1) == 0)) {
 		write_unlock_irqrestore(&adapter->adapter_lock, flags);
 		printk(KERN_ERR "%s out of bound pci memory access. "
-			"offset is 0x%llx\n", netxen_nic_driver_name, off);
+			"offset is 0x%llx\n", netxen_nic_driver_name,
+			(unsigned long long)off);
 		return -1;
 	}
 
@@ -1484,7 +1485,8 @@ netxen_nic_pci_mem_write_direct(struct netxen_adapter *adapter, u64 off,
 		(netxen_nic_pci_is_same_window(adapter, off+size-1) == 0)) {
 		write_unlock_irqrestore(&adapter->adapter_lock, flags);
 		printk(KERN_ERR "%s out of bound pci memory access. "
-			"offset is 0x%llx\n", netxen_nic_driver_name, off);
+			"offset is 0x%llx\n", netxen_nic_driver_name,
+			(unsigned long long)off);
 		return -1;
 	}
 
