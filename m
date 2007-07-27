Return-Path: <linux-kernel-owner+w=401wt.eu-S936607AbXG0Jsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936607AbXG0Jsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 05:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936066AbXG0JqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 05:46:18 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:35977 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935861AbXG0JqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 05:46:15 -0400
Date: Fri, 27 Jul 2007 11:44:53 +0200 (MEST)
Message-Id: <200707270944.LAA17230@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 09/68] 0 -> NULL, for arch/m68knommu
Cc: gerg@uclinux.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
From: Yoann Padioleau <padator@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When comparing a pointer, it's clearer to compare it to NULL than to 0.

Here is an excerpt of the semantic patch: 

@@
expression *E;
@@

  E ==
- 0
+ NULL

@@
expression *E;
@@

  E !=
- 0
+ NULL

Signed-off-by: Yoann Padioleau <padator@wanadoo.fr>
Cc: gerg@uclinux.org
Cc: akpm@linux-foundation.org
---

 comempci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m68knommu/kernel/comempci.c b/arch/m68knommu/kernel/comempci.c
index 6ee00ef..528517e 100644
--- a/arch/m68knommu/kernel/comempci.c
+++ b/arch/m68knommu/kernel/comempci.c
@@ -736,7 +736,7 @@ #endif
 
 	/* Find a free spot to put this handler */
 	for (i = 0; (i < COMEM_MAXPCI); i++) {
-		if (pci_irqlist[i].handler == 0) {
+		if (pci_irqlist[i].handler == NULL) {
 			pci_irqlist[i].handler = handler;
 			pci_irqlist[i].device = device;
 			pci_irqlist[i].dev_id = dev_id;

