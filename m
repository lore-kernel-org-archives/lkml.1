Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbZGNI5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbZGNI5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 04:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbZGNI5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 04:57:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53936 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbZGNI5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 04:57:35 -0400
Message-ID: <4A5C488A.90204@cn.fujitsu.com>
Date: Tue, 14 Jul 2009 16:57:46 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove initialization of page_table in one_page_table_init()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only judge if (!page_table) when CONFIG_DEBUG_PAGEALLOC or CONFIG_KMEMCHECK
are defined, then we don't need to set init value for page_table.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 arch/x86/mm/init_32.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 3cd7711..55da09b 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -108,13 +108,13 @@ static pmd_t * __init one_md_table_init(pgd_t *pgd)
 static pte_t * __init one_page_table_init(pmd_t *pmd)
 {
     if (!(pmd_val(*pmd) & _PAGE_PRESENT)) {
-        pte_t *page_table = NULL;
+        pte_t *page_table;
 
         if (after_bootmem) {
 #if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
             page_table = (pte_t *) alloc_bootmem_pages(PAGE_SIZE);
-#endif
             if (!page_table)
+#endif
                 page_table =
                 (pte_t *)alloc_bootmem_low_pages(PAGE_SIZE);
         } else
-- 
1.5.5.3


