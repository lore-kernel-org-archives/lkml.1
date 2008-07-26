Return-Path: <linux-kernel-owner+w=401wt.eu-S1757006AbYGZQub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbYGZQub (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 12:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756785AbYGZQuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 12:50:15 -0400
Received: from mail.tut.by ([195.137.160.40]:39603 "EHLO speedy.tutby.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756782AbYGZQuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 12:50:14 -0400
Subject: [PATCH] fix warning in arch/x86/mm/pgtable.c
From: Michael Borisov <niro@tut.by>
To: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Sat, 26 Jul 2008 19:50:07 +0300
Message-Id: <1217091007.6107.8.camel@inlin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile warning:

arch/x86/mm/pgtable.c: In function ‘pgd_mop_up_pmds’:
arch/x86/mm/pgtable.c:194: warning: unused variable ‘pmd’

Signed-off-by: Michael Borisov <niro@tut.by>
---
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 557b2ab..2d57735 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -163,7 +163,8 @@ static int preallocate_pmds(pmd_t *pmds[])
        bool failed = false;
 
        for(i = 0; i < PREALLOCATED_PMDS; i++) {
-               pmd_t *pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL|
__GFP_REPEAT);
+               pmd_t *pmd;
+               pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
                if (pmd == NULL)
                        failed = true;
                pmds[i] = pmd;


