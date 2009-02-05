Return-Path: <linux-kernel-owner+w=401wt.eu-S1762803AbZBETlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762803AbZBETlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760058AbZBETch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:37 -0500
Received: from gw.goop.org ([64.81.55.164]:40053 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759563AbZBETcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:22 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 36 of 36] x86: make the X_bad functions consistent
X-Mercurial-Node: d0b8ae3ef338132ad60d131dcc30dc22b0ce6eac
Message-Id: <d0b8ae3ef338132ad60d.1233862278@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:31:18 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Use the same logic to implement all 3 _bad() functions.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -554,7 +554,7 @@
 
 static inline int pmd_bad(pmd_t pmd)
 {
-	return (pmd_flags(pmd) & ~_PAGE_USER) != _KERNPG_TABLE;
+	return (pmd_flags(pmd) & ~(_KERNPG_TABLE | _PAGE_USER)) != 0;
 }
 
 static inline unsigned long pages_to_mb(unsigned long npg)
@@ -638,7 +638,7 @@
 
 static inline int pgd_bad(pgd_t pgd)
 {
-	return (pgd_flags(pgd) & ~_PAGE_USER) != _KERNPG_TABLE;
+	return (pgd_flags(pgd) & ~(_KERNPG_TABLE | _PAGE_USER)) != 0;
 }
 
 static inline int pgd_none(pgd_t pgd)


