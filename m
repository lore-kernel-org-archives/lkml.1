Return-Path: <linux-kernel-owner+w=401wt.eu-S934836AbYAaWOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934836AbYAaWOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:14:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934323AbYAaWKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:10:46 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:40301 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934296AbYAaWKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:10:38 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] x86: fix section mismatch warning in kernel/pci-calgary
Date: Thu, 31 Jan 2008 23:10:39 +0100
Message-Id: <1201817440-5081-10-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <20080131220430.GA4874@uranus.ravnborg.org>
References: <20080131220430.GA4874@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning:
WARNING: arch/x86/kernel/built-in.o(.text+0x1eb41): Section mismatch in reference from the function calgary_handle_quirks() to the function .init.text:calgary_set_split_completion_timeout()

calgary_handle_quirks() are only called at
__init time (in calgary_init_one() via handle_quirks ops).
So annotate this function and the sister function __init.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/kernel/pci-calgary_64.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 21f34db..1fe7f04 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1006,7 +1006,7 @@ static void __init calgary_set_split_completion_timeout(void __iomem *bbar,
 	readq(target); /* flush */
 }
 
-static void calioc2_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev)
+static void __init calioc2_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev)
 {
 	unsigned char busnum = dev->bus->number;
 	void __iomem *bbar = tbl->bbar;
@@ -1022,7 +1022,7 @@ static void calioc2_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev)
 	writel(cpu_to_be32(val), target);
 }
 
-static void calgary_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev)
+static void __init calgary_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev)
 {
 	unsigned char busnum = dev->bus->number;
 
-- 
1.5.4.rc3.14.g44397

