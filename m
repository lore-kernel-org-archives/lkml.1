Return-Path: <linux-kernel-owner+w=401wt.eu-S1752397AbYI1FIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbYI1FIq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 01:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbYI1FIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 01:08:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:53021 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbYI1FIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 01:08:38 -0400
From: qingtao.cao@windriver.com
To: linux-kernel@vger.kernel.org
Cc: yanmin.zhang@intel.com
Subject: [PATCH] PCIE: use PCI_EXT_CAP_NEXT to traverse PCIE extended capability list.
Date: Sun, 28 Sep 2008 13:07:56 +0800
Message-Id: <1222578476-25691-1-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
X-OriginalArrivalTime: 28 Sep 2008 05:08:34.0679 (UTC) FILETIME=[4204D070:01C92128]
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
