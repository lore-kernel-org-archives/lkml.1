Return-Path: <linux-kernel-owner+w=401wt.eu-S1753262AbZHITyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbZHITyX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 15:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbZHITyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 15:54:20 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:14430 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbZHITyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 15:54:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XuCihCdpdY+FMpO1rCVzqF9XnLH7oHQsi598EgE/nIx2nWDRAQwmsbmVGZ+xYumoEh
         yURAZu+Lhuo7frtGJlZBhxuzPK/GAVVUiyWMw+alFdwEF64vRMhchSU0W7vy2e1G1Onm
         VU0pIllIZ4MpkPKJEh1uYAT6CFWBfgRevLBBc=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-alpha@vger.kernel.org
Subject: [PATCH 01/14] alpha: use printk_once
Date: Sun,  9 Aug 2009 21:53:56 +0200
Message-Id: <1249847649-11631-2-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-alpha@vger.kernel.org
---
 arch/alpha/kernel/pci_iommu.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index bfb880a..d15aedf 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -268,11 +268,7 @@ pci_map_single_1(struct pci_dev *pdev, void *cpu_addr, size_t size,
 	   assume it doesn't support sg mapping, and, since we tried to
 	   use direct_map above, it now must be considered an error. */
 	if (! alpha_mv.mv_pci_tbi) {
-		static int been_here = 0; /* Only print the message once. */
-		if (!been_here) {
-		    printk(KERN_WARNING "pci_map_single: no HW sg\n");
-		    been_here = 1;
-		}
+		printk_once(KERN_WARNING "pci_map_single: no HW sg\n");
 		return 0;
 	}
 
-- 
1.6.3.3

