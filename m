Return-Path: <linux-kernel-owner+w=401wt.eu-S1759222AbZE0QZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222AbZE0QZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 12:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbZE0QZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 12:25:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:50761 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491AbZE0QZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 12:25:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,260,1241420400"; 
   d="scan'208";a="519307765"
From: Yu Zhao <yu.zhao@intel.com>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, marc.c.dionne@gmail.com,
       linux-kernel@vger.kernel.org, Yu Zhao <yu.zhao@intel.com>
Subject: [PATCH] PCI: use fixed-up device class when configuring device
Date: Thu, 28 May 2009 00:25:05 +0800
Message-Id: <1243441505-5477-1-git-send-email-yu.zhao@intel.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device class may be changed after the early fixup. Need to
re-read the class value from pci_dev when configuring the device.
Otherwise some devices such as JMicron SATA controller won't work.

Tested-by: Marc Dionne <marc.c.dionne@gmail.com>
Signed-off-by: Yu Zhao <yu.zhao@intel.com>
---
 drivers/pci/probe.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index e3c3e08..f1ae247 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -745,6 +745,8 @@ int pci_setup_device(struct pci_dev *dev)
 
 	/* Early fixups, before probing the BARs */
 	pci_fixup_device(pci_fixup_early, dev);
+	/* device class may be changed after fixup */
+	class = dev->class >> 8;
 
 	switch (dev->hdr_type) {		    /* header type */
 	case PCI_HEADER_TYPE_NORMAL:		    /* standard header */
-- 
1.6.1

