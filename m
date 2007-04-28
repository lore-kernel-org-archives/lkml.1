Return-Path: <linux-kernel-owner+w=401wt.eu-S1031190AbXD1TVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031190AbXD1TVE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161232AbXD1TUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:20:49 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37525 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161029AbXD1TUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:20:37 -0400
Date: Sat, 28 Apr 2007 21:20:48 +0200
From: Adrian Bunk <bunk@stusta.de>
To: avi@qumranet.com
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/kvm/mmu.c: fix an if() condition
Message-ID: <20070428192048.GX3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It might have worked in this case since PT_PRESENT_MASK is 1, but let's 
express this correctly.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc7-mm2/drivers/kvm/mmu.c.old	2007-04-28 18:05:13.000000000 +0200
+++ linux-2.6.21-rc7-mm2/drivers/kvm/mmu.c	2007-04-28 18:05:54.000000000 +0200
@@ -1408,7 +1408,7 @@ static void audit_mappings_page(struct k
 	for (i = 0; i < PT64_ENT_PER_PAGE; ++i, va += va_delta) {
 		u64 ent = pt[i];
 
-		if (!ent & PT_PRESENT_MASK)
+		if (!(ent & PT_PRESENT_MASK))
 			continue;
 
 		va = canonicalize(va);
