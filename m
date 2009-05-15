Return-Path: <linux-kernel-owner+w=401wt.eu-S1756522AbZEOD0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbZEOD0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 23:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbZEOD0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 23:26:05 -0400
Received: from mail.windriver.com ([147.11.1.11]:44758 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165AbZEOD0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 23:26:04 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: norsk5@yahoo.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       bluesmoke-devel@lists.sourceforge.net
Subject: [v1 PATCH 1/2] EDAC: AMD8111 & AMD8131 use dev_name()
Date: Fri, 15 May 2009 11:26:45 +0800
Message-Id: <1242358006-28339-2-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1242358006-28339-1-git-send-email-qingtao.cao@windriver.com>
References: <1242358006-28339-1-git-send-email-qingtao.cao@windriver.com>
X-OriginalArrivalTime: 15 May 2009 03:25:46.0661 (UTC) FILETIME=[D630B550:01C9D50C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "bus_id" member in the device structure has been obsolete,
use dev_name() instead.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
---
 drivers/edac/amd8111_edac.c |    4 ++--
 drivers/edac/amd8131_edac.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/amd8111_edac.c b/drivers/edac/amd8111_edac.c
index 6146921..2cb58ef 100644
--- a/drivers/edac/amd8111_edac.c
+++ b/drivers/edac/amd8111_edac.c
@@ -389,7 +389,7 @@ static int amd8111_dev_probe(struct pci_dev *dev,
 	dev_info->edac_dev->dev = &dev_info->dev->dev;
 	dev_info->edac_dev->mod_name = AMD8111_EDAC_MOD_STR;
 	dev_info->edac_dev->ctl_name = dev_info->ctl_name;
-	dev_info->edac_dev->dev_name = dev_info->dev->dev.bus_id;
+	dev_info->edac_dev->dev_name = dev_name(&dev_info->dev->dev);
 
 	if (edac_op_state == EDAC_OPSTATE_POLL)
 		dev_info->edac_dev->edac_check = dev_info->check;
@@ -473,7 +473,7 @@ static int amd8111_pci_probe(struct pci_dev *dev,
 	pci_info->edac_dev->dev = &pci_info->dev->dev;
 	pci_info->edac_dev->mod_name = AMD8111_EDAC_MOD_STR;
 	pci_info->edac_dev->ctl_name = pci_info->ctl_name;
-	pci_info->edac_dev->dev_name = pci_info->dev->dev.bus_id;
+	pci_info->edac_dev->dev_name = dev_name(&pci_info->dev->dev);
 
 	if (edac_op_state == EDAC_OPSTATE_POLL)
 		pci_info->edac_dev->edac_check = pci_info->check;
diff --git a/drivers/edac/amd8131_edac.c b/drivers/edac/amd8131_edac.c
index c083b31..b432d60 100644
--- a/drivers/edac/amd8131_edac.c
+++ b/drivers/edac/amd8131_edac.c
@@ -287,7 +287,7 @@ static int amd8131_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	dev_info->edac_dev->dev = &dev_info->dev->dev;
 	dev_info->edac_dev->mod_name = AMD8131_EDAC_MOD_STR;
 	dev_info->edac_dev->ctl_name = dev_info->ctl_name;
-	dev_info->edac_dev->dev_name = dev_info->dev->dev.bus_id;
+	dev_info->edac_dev->dev_name = dev_name(&dev_info->dev->dev);
 
 	if (edac_op_state == EDAC_OPSTATE_POLL)
 		dev_info->edac_dev->edac_check = amd8131_chipset.check;
-- 
1.5.6.2

