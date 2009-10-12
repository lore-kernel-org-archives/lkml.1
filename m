Return-Path: <linux-kernel-owner+w=401wt.eu-S1754395AbZJLHDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbZJLHDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 03:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbZJLHDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 03:03:51 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:41894 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbZJLHDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 03:03:51 -0400
Subject: [PATCH 5/5] PCI: fix memory leak in aer_inject
To: ying.huang@intel.com
From: Andrew Patterson <andrew.patterson@hp.com>
Cc: prarit@redhat.com, andi@firstfloor.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, pci-linux@vger.kernel.org
Date: Mon, 12 Oct 2009 01:03:14 -0600
Message-ID: <20091012070314.27029.35077.stgit@bob.kio>
In-Reply-To: <20091012070248.27029.78378.stgit@bob.kio>
References: <20091012070248.27029.78378.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI: fix memory leak in aer_inject

Fixed probable typo in aer_inject cleanup code resulting in a memory
leak.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
---

diff --git a/drivers/pci/pcie/aer/aer_inject.c b/drivers/pci/pcie/aer/aer_inject.c
index da2ad6e..2246bf7 100644
--- a/drivers/pci/pcie/aer/aer_inject.c
+++ b/drivers/pci/pcie/aer/aer_inject.c
@@ -474,7 +474,7 @@ static void __exit aer_inject_exit(void)
 	}
 
 	spin_lock_irqsave(&inject_lock, flags);
-	list_for_each_entry_safe(err, err_next, &pci_bus_ops_list, list) {
+	list_for_each_entry_safe(err, err_next, &einjected, list) {
 		list_del(&err->list);
 		kfree(err);
 	}

