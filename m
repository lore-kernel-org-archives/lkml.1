Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918AbZEGBsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbZEGBsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 21:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756559AbZEGBs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 21:48:27 -0400
Received: from mail.windriver.com ([147.11.1.11]:35224 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357AbZEGBs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 21:48:26 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: norsk5@yahoo.com, bluesmoke-devel@lists.sourceforge.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [v0 PATCH 1/1] Use dev_name() for AMD8111/AMD8131 EDAC driver
Date: Thu,  7 May 2009 09:47:38 +0800
Message-Id: <1241660858-21105-2-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1241660858-21105-1-git-send-email-qingtao.cao@windriver.com>
References: <1241660858-21105-1-git-send-email-qingtao.cao@windriver.com>
X-OriginalArrivalTime: 07 May 2009 01:47:10.0749 (UTC) FILETIME=[BCBA2CD0:01C9CEB5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device structure no longer has bus_id member, dev_name() should
be used for AMD8111 & AMD8131 EDAC driver instead. Also, their Makefile 
entries are lost, add them.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
---
 drivers/edac/Makefile       |    2 ++
 drivers/edac/amd8111_edac.c |    4 ++--
 drivers/edac/amd8131_edac.c |    2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index a5fdcf0..5907681 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -35,3 +35,5 @@ obj-$(CONFIG_EDAC_MPC85XX)		+= mpc85xx_edac.o
 obj-$(CONFIG_EDAC_MV64X60)		+= mv64x60_edac.o
 obj-$(CONFIG_EDAC_CELL)			+= cell_edac.o
 obj-$(CONFIG_EDAC_PPC4XX)		+= ppc4xx_edac.o
+obj-$(CONFIG_EDAC_AMD8111)		+= amd8111_edac.o
+obj-$(CONFIG_EDAC_AMD8131)		+= amd8131_edac.o
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

