Return-Path: <linux-kernel-owner+w=401wt.eu-S1758877AbYAOW2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877AbYAOW2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757202AbYAOW1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:27:14 -0500
Received: from 247.sub-75-209-114.myvzw.com ([75.209.114.247]:38363 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754829AbYAOW1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:27:12 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 4] x86: clean up pte_modify
X-Mercurial-Node: ddff52ae92d4f33bcba199b68c1d27635d4430c9
Message-Id: <ddff52ae92d4f33bcba1.1200435428@localhost>
In-Reply-To: <patchbomb.1200435425@localhost>
Date: Tue, 15 Jan 2008 14:17:08 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pte_modify() got mushed in an apparent mismerge.  Fix it up.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 include/asm-x86/pgtable.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -176,14 +176,11 @@ static inline pte_t pte_modify(pte_t pte
 {
 	pteval_t val = pte_val(pte);
 
-	val &= _PAGE_CHG_MASK;
-	val |= pgprot_val(newprot);
-
 	/*
 	 * Chop off the NX bit (if present), and add the NX portion of
 	 * the newprot (if present):
 	 */
-	val &= ~_PAGE_NX;
+	val &= _PAGE_CHG_MASK & ~_PAGE_NX;
 	val |= pgprot_val(newprot) & __supported_pte_mask;
 
 	return __pte(val);


