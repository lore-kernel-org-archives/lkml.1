Return-Path: <linux-kernel-owner+w=401wt.eu-S933065AbZJLTPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065AbZJLTPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933064AbZJLTO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:14:58 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:46216 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933052AbZJLTO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:14:56 -0400
Subject: [PATCH v2 4/4] PCI: fix memory leak in aer_inject
To: ying.huang@intel.com
From: Andrew Patterson <andrew.patterson@hp.com>
Cc: prarit@redhat.com, linux-pci@vger.kernel.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org
Date: Mon, 12 Oct 2009 13:14:15 -0600
Message-ID: <20091012191415.14959.8772.stgit@bob.kio>
In-Reply-To: <20091012191354.14959.47024.stgit@bob.kio>
References: <20091012191354.14959.47024.stgit@bob.kio>
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

