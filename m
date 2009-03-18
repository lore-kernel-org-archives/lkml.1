Return-Path: <linux-kernel-owner+w=401wt.eu-S1753643AbZCRUJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbZCRUJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 16:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbZCRUJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 16:09:42 -0400
Received: from adsl-69-107-82-15.dsl.pltn13.pacbell.net ([69.107.82.15]:56293
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751644AbZCRUJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 16:09:41 -0400
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Mar 2009 16:09:41 EDT
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 1/2] x86/32: no need to use set_pte_present in set_pte_vaddr
Date: Wed, 18 Mar 2009 13:03:32 -0700
Message-Id: <1237406613-2929-1-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Impact: cleanup, remove last user of set_pte_present

set_pte_vaddr() is only used to install ptes in fixmaps, and
should never be used to overwrite a present mapping.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/pgtable_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
index f2e477c..46c8834 100644
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -50,7 +50,7 @@ void set_pte_vaddr(unsigned long vaddr, pte_t pteval)
 	}
 	pte = pte_offset_kernel(pmd, vaddr);
 	if (pte_val(pteval))
-		set_pte_present(&init_mm, vaddr, pte, pteval);
+		set_pte_at(&init_mm, vaddr, pte, pteval);
 	else
 		pte_clear(&init_mm, vaddr, pte);
 
-- 
1.6.0.6

