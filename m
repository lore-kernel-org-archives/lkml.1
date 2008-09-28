Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbYI1D7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbYI1D7T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 23:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbYI1D7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 23:59:10 -0400
Received: from mail.windriver.com ([147.11.1.11]:43058 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbYI1D7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 23:59:09 -0400
From: qingtao.cao@windriver.com
To: linux-kernel@vger.kernel.org
Subject: Subject:[PATCH] PCIE: use PCI_EXT_CAP_NEXT to traverse PCIE extended capability list.
Date: Sun, 28 Sep 2008 11:58:31 +0800
Message-Id: <1222574311-25165-1-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
X-OriginalArrivalTime: 28 Sep 2008 03:59:07.0802 (UTC) FILETIME=[8E5DD7A0:01C9211E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCIE extended capability unit is of 4-byte, so the least 2 bits of the most 
significant 12 bits should be masked off to zero when accessing the extended
capability list.

Signed-off-by: Harry Ciao<qingtao.cao@windriver.com>
---
 drivers/pci/pcie/aer/aerdrv_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -52,7 +52,7 @@
 		if (PCI_EXT_CAP_ID(reg32) == PCI_EXT_CAP_ID_ERR)
 			break;
 
-		pos = reg32 >> 20;
+		pos = PCI_EXT_CAP_NEXT(reg32);
 	}
 
 	return pos;
