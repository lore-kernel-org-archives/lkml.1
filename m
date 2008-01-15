Return-Path: <linux-kernel-owner+w=401wt.eu-S1759205AbYAOW1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205AbYAOW1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756638AbYAOW1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:27:13 -0500
Received: from 247.sub-75-209-114.myvzw.com ([75.209.114.247]:38360 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753765AbYAOW1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:27:12 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 4 of 4] x86: mask NX from pte_pfn
X-Mercurial-Node: b27ec2092a01dc15e13948432f65ddd4699cf3ea
Message-Id: <b27ec2092a01dc15e139.1200435429@localhost>
In-Reply-To: <patchbomb.1200435425@localhost>
Date: Tue, 15 Jan 2008 14:17:09 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 32-bit PAE, mask NX from pte_pfn, since it isn't part of the PFN.
This code is due for unification anyway, but this fixes a latent bug.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 include/asm-x86/pgtable-3level.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-x86/pgtable-3level.h b/include/asm-x86/pgtable-3level.h
--- a/include/asm-x86/pgtable-3level.h
+++ b/include/asm-x86/pgtable-3level.h
@@ -139,7 +139,7 @@ static inline int pte_none(pte_t pte)
 
 static inline unsigned long pte_pfn(pte_t pte)
 {
-	return pte_val(pte) >> PAGE_SHIFT;
+	return (pte_val(pte) >> PAGE_SHIFT) & ~_PAGE_NX;
 }
 
 /*


