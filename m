Return-Path: <linux-kernel-owner+w=401wt.eu-S1757059AbYHSBqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059AbYHSBqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 21:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444AbYHSBqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 21:46:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38375 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985AbYHSBqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 21:46:08 -0400
Date: Tue, 19 Aug 2008 11:45:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       <linuxppc-dev@ozlabs.org>, LKML <linux-kernel@vger.kernel.org>,
       Alex Chiang <achiang@hp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, Linda Xie <lxie@us.ibm.com>
Subject: [PATCH] hotplug/rpaphp: remove unused error path code
Message-Id: <20080819114555.c0d2bd50.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f46753c5e354b857b20ab8e0fe7b2579831dc369 ("PCI: introduce pci_slot") removed the need for this error path.  Eliminate this warning:

drivers/pci/hotplug/rpaphp_slot.c: In function 'rpaphp_register_slot':
drivers/pci/hotplug/rpaphp_slot.c:151: warning: label 'sysfs_fail' defined but not used

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/pci/hotplug/rpaphp_slot.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/hotplug/rpaphp_slot.c b/drivers/pci/hotplug/rpaphp_slot.c
index 9b714ea..5088450 100644
--- a/drivers/pci/hotplug/rpaphp_slot.c
+++ b/drivers/pci/hotplug/rpaphp_slot.c
@@ -147,9 +147,5 @@ int rpaphp_register_slot(struct slot *slot)
 	list_add(&slot->rpaphp_slot_list, &rpaphp_slot_head);
 	info("Slot [%s] registered\n", slot->name);
 	return 0;
-
-sysfs_fail:
-	pci_hp_deregister(php_slot);
-	return retval;
 }
 
-- 
1.5.6.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
