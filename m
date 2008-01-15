Return-Path: <linux-kernel-owner+w=401wt.eu-S1759376AbYAOW1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376AbYAOW1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756918AbYAOW1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:27:13 -0500
Received: from 247.sub-75-209-114.myvzw.com ([75.209.114.247]:38361 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754750AbYAOW1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:27:12 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 4] x86: fix warning
X-Mercurial-Node: 6daf33ca0cdec3fd69ef1fc434112cdad22f1873
Message-Id: <6daf33ca0cdec3fd69ef.1200435427@localhost>
In-Reply-To: <patchbomb.1200435425@localhost>
Date: Tue, 15 Jan 2008 14:17:07 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

&ptep->pte isn't always an unsigned long *, so cast it to avoid a warning.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 include/asm-x86/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -340,7 +340,7 @@ static inline pte_t ptep_get_and_clear_f
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
-	clear_bit(_PAGE_BIT_RW, &ptep->pte);
+	clear_bit(_PAGE_BIT_RW, (unsigned long *)&ptep->pte);
 	pte_update(mm, addr, ptep);
 }
 


