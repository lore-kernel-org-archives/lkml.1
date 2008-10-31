Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbYJaJo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbYJaJo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 05:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbYJaJot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 05:44:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62705 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbYJaJot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 05:44:49 -0400
Message-ID: <490AD328.1010603@cn.fujitsu.com>
Date: Fri, 31 Oct 2008 17:43:04 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] Avoid duplicate running of pud_offset and pmd_offset in one_md_table_init()
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If !(pgd_val(*pgd) & _PAGE_PRESENT) in PAE mode, we need not get value of
pmd_table again.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 arch/x86/mm/init_32.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 8396868..7f8a2da 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -102,6 +102,8 @@ static pmd_t * __init one_md_table_init(pgd_t *pgd)
 		set_pgd(pgd, __pgd(__pa(pmd_table) | _PAGE_PRESENT));
 		pud = pud_offset(pgd, 0);
 		BUG_ON(pmd_table != pmd_offset(pud, 0));
+
+		return pmd_table;
 	}
 #endif
 	pud = pud_offset(pgd, 0);
-- 
1.5.5.3

