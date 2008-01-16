Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbYAQC3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbYAQC3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 21:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbYAQC30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 21:29:26 -0500
Received: from gw.goop.org ([64.81.55.164]:46823 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbYAQC30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 21:29:26 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 8] add native_pud_val and _pmd_val for 2 and 3
	level pagetables
X-Mercurial-Node: 056708b03518fa91357c87e26f32d90ea31e619e
Message-Id: <056708b03518fa91357c.1200526039@localhost>
In-Reply-To: <patchbomb.1200526038@localhost>
Date: Wed, 16 Jan 2008 15:27:19 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 include/asm-x86/page.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/asm-x86/page.h b/include/asm-x86/page.h
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -91,6 +91,11 @@ static inline pudval_t native_pud_val(pu
 }
 #else	/* PAGETABLE_LEVELS == 3 */
 #include <asm-generic/pgtable-nopud.h>
+
+static inline pudval_t native_pud_val(pud_t pud)
+{
+	return native_pgd_val(pud.pgd);
+}
 #endif	/* PAGETABLE_LEVELS == 4 */
 
 typedef struct { pmdval_t pmd; } pmd_t;
@@ -106,6 +111,11 @@ static inline pmdval_t native_pmd_val(pm
 }
 #else  /* PAGETABLE_LEVELS == 2 */
 #include <asm-generic/pgtable-nopmd.h>
+
+static inline pmdval_t native_pmd_val(pmd_t pmd)
+{
+	return native_pgd_val(pmd.pud.pgd);
+}
 #endif	/* PAGETABLE_LEVELS >= 3 */
 
 static inline pte_t native_make_pte(pteval_t val)


