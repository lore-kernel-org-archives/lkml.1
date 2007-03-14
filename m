Return-Path: <linux-kernel-owner+w=401wt.eu-S1030714AbXCNJFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030714AbXCNJFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030726AbXCNJFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:05:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57606 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030714AbXCNJFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:05:02 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 5/13] zatm __init abuse
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HRPPp-0001v3-Oq@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:05:01 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


zatm_init() and zatm_start() should be __devinit (the former is
not module init, despite the name - it's a helper for PCI ->probe())

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/atm/zatm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/atm/zatm.c b/drivers/atm/zatm.c
index 0d7091e..2ad2527 100644
--- a/drivers/atm/zatm.c
+++ b/drivers/atm/zatm.c
@@ -1177,7 +1177,7 @@ static void __devinit eprom_get_esi(struct atm_dev *dev)
 /*--------------------------------- entries ---------------------------------*/
 
 
-static int __init zatm_init(struct atm_dev *dev)
+static int __devinit zatm_init(struct atm_dev *dev)
 {
 	struct zatm_dev *zatm_dev;
 	struct pci_dev *pci_dev;
@@ -1256,7 +1256,7 @@ static int __init zatm_init(struct atm_dev *dev)
 }
 
 
-static int __init zatm_start(struct atm_dev *dev)
+static int __devinit zatm_start(struct atm_dev *dev)
 {
 	struct zatm_dev *zatm_dev = ZATM_DEV(dev);
 	struct pci_dev *pdev = zatm_dev->pci_dev;
-- 
1.5.0-rc2.GIT


