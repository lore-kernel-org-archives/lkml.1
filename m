Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbZCETQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbZCETQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 14:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757195AbZCETPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 14:15:40 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:39236 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179AbZCETPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 14:15:38 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH v2 07/15] NULL noise: drivers/pci/dmar.c
Date: Thu, 05 Mar 2009 20:15:23 +0100
Message-ID: <20090305191518.30062.96525.stgit@f10box.hanneseder.net>
In-Reply-To: <20090305190954.30062.44759.stgit@f10box.hanneseder.net>
References: <20090305190954.30062.44759.stgit@f10box.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: trivial@kernel.org
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning(s):
  drivers/pci/dmar.c:782:29: warning: Using plain integer as NULL pointer
  drivers/pci/dmar.c:790:29: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
v2: other subject, as suggested by Al Viro

 drivers/pci/dmar.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 5f33340..4b654b2 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -779,7 +779,7 @@ int dmar_enable_qi(struct intel_iommu *iommu)
 	qi->desc = (void *)(get_zeroed_page(GFP_KERNEL));
 	if (!qi->desc) {
 		kfree(qi);
-		iommu->qi = 0;
+		iommu->qi = NULL;
 		return -ENOMEM;
 	}
 
@@ -787,7 +787,7 @@ int dmar_enable_qi(struct intel_iommu *iommu)
 	if (!qi->desc_status) {
 		free_page((unsigned long) qi->desc);
 		kfree(qi);
-		iommu->qi = 0;
+		iommu->qi = NULL;
 		return -ENOMEM;
 	}
 

