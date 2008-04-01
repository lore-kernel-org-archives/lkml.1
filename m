Return-Path: <linux-kernel-owner+w=401wt.eu-S1757756AbYDAX7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756AbYDAX7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 19:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756793AbYDAX6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 19:58:50 -0400
Received: from smtp03.mtu.ru ([62.5.255.50]:64026 "EHLO smtp03.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756600AbYDAX6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 19:58:48 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] [MIPS] unexport copy_to_user_page()
Date: Wed,  2 Apr 2008 03:58:35 +0400
Message-Id: <1207094318-21748-3-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1207094318-21748-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1207094318-21748-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp03.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The copy_to_user_page() function is called only in the core kernel
code. Therefore, there is no need to export it. This patch removes
EXPORT_SYMBOL(copy_to_user_page).

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/mips/mm/init.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index 71e5962..6b9d54b 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -247,8 +247,6 @@ void copy_to_user_page(struct vm_area_struct *vma,
 		flush_cache_page(vma, vaddr, page_to_pfn(page));
 }
 
-EXPORT_SYMBOL(copy_to_user_page);
-
 void copy_from_user_page(struct vm_area_struct *vma,
 	struct page *page, unsigned long vaddr, void *dst, const void *src,
 	unsigned long len)
-- 
1.5.3

