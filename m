Return-Path: <linux-kernel-owner+w=401wt.eu-S1759577AbYDAX65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577AbYDAX65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 19:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756739AbYDAX6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 19:58:49 -0400
Received: from smtp03.mtu.ru ([62.5.255.50]:64022 "EHLO smtp03.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756450AbYDAX6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 19:58:48 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] [MIPS] unexport copy_user_highpage()
Date: Wed,  2 Apr 2008 03:58:34 +0400
Message-Id: <1207094318-21748-2-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1207094318-21748-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1207094318-21748-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp03.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The copy_user_highpage() routine has no users outside of the
core kernel code, so exporting this symbol is pointless.
This patch removes EXPORT_SYMBOL(copy_user_highpage).

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/mips/mm/init.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index c7aed13..71e5962 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -229,8 +229,6 @@ void copy_user_highpage(struct page *to, struct page *from,
 	smp_wmb();
 }
 
-EXPORT_SYMBOL(copy_user_highpage);
-
 void copy_to_user_page(struct vm_area_struct *vma,
 	struct page *page, unsigned long vaddr, void *dst, const void *src,
 	unsigned long len)
-- 
1.5.3

