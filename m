Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275Ab0CCAB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:01:29 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:45197 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab0CCABY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:01:24 -0500
From: imunsie@au1.ibm.com
To: linux-kernel@vger.kernel.org
Cc: Ian Munsie <imunsie@au1.ibm.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Wilcox <matthew@wil.cx>, Alex Chiang <achiang@hp.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       linux-pci@vger.kernel.org
Subject: [PATCH] Avoid implicit constant truncation
Date: Wed,  3 Mar 2010 11:01:07 +1100
Message-Id: <1267574468-7609-1-git-send-email-imunsie@au.ibm.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au.ibm.com>

When building on 64 bit platforms, the compiler throws the following
warning:

drivers/pci/probe.c:197: warning: large integer implicitly truncated to unsigned type

This patch adds an explicit truncation to silence the compiler warning.

Signed-off-by: Ian Munsie <imunsie@au.ibm.com>
---
 drivers/pci/probe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 2a94309..c5d9668 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -195,7 +195,7 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		res->flags |= pci_calc_resource_flags(l) | IORESOURCE_SIZEALIGN;
 		if (type == pci_bar_io) {
 			l &= PCI_BASE_ADDRESS_IO_MASK;
-			mask = PCI_BASE_ADDRESS_IO_MASK & IO_SPACE_LIMIT;
+			mask = (u32)(PCI_BASE_ADDRESS_IO_MASK & IO_SPACE_LIMIT);
 		} else {
 			l &= PCI_BASE_ADDRESS_MEM_MASK;
 			mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;
-- 
1.6.6.1

