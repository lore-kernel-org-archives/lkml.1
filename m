Return-Path: <linux-kernel-owner+w=401wt.eu-S1754963AbXGIH0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbXGIH0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 03:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbXGIHZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 03:25:49 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:46119 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbXGIHZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 03:25:47 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] Use kcalloc() in drivers/video/aty/atyfb_base.c
Date: Sun, 8 Jul 2007 17:56:06 +0200
User-Agent: KMail/1.9.7
Cc: akpm@linux-foundation.org
References: <200707081754.03824.eike-kernel@sf-tec.de>
In-Reply-To: <200707081754.03824.eike-kernel@sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707081756.06660.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

---
commit cc4a7b5dfee25083a6a5741b5b640ae2a1d3aa12
tree a4763216a61fa1501bf9b5dbb60f8860d1620b99
parent dcd9673a1ca36cb084de58f443edf42fd64b186b
author Rolf Eike Beer <eike-kernel@sf-tec.de> Mon, 07 Aug 2006 13:36:24 +0200
committer Rolf Eike Beer <eike-kernel@sf-tec.de> Mon, 07 Aug 2006 13:36:24 +0200

 drivers/video/aty/atyfb_base.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index 053ff63..6bc51bb 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -2995,12 +2995,11 @@ static int __devinit atyfb_setup_sparc(struct pci_dev *pdev,
 		/* nothing */ ;
 	j = i + 4;
 
-	par->mmap_map = kmalloc(j * sizeof(*par->mmap_map), GFP_ATOMIC);
+	par->mmap_map = kcalloc(j, sizeof(*par->mmap_map), GFP_ATOMIC);
 	if (!par->mmap_map) {
 		PRINTKE("atyfb_setup_sparc() can't alloc mmap_map\n");
 		return -ENOMEM;
 	}
-	memset(par->mmap_map, 0, j * sizeof(*par->mmap_map));
 
 	for (i = 0, j = 2; i < 6 && pdev->resource[i].start; i++) {
 		struct resource *rp = &pdev->resource[i];
