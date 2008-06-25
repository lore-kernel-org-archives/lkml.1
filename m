Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbYFYEky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbYFYEky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755187AbYFYEhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:20 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37442 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753860AbYFYEhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:14 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 09 of 36] x86_64: Use __pgd() on mk_kernel_pgd()
X-Mercurial-Node: a5eca93b284774807ea6558bf5ce09cbad118b7a
Message-Id: <a5eca93b284774807ea6.1214367545@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:05 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Habkost <ehabkost@redhat.com>

Use __pgd() on mk_kernel_pgd()

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 include/asm-x86/pgtable_64.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -201,7 +201,7 @@
 #define pgd_offset_k(address) (init_level4_pgt + pgd_index((address)))
 #define pgd_present(pgd) (pgd_val(pgd) & _PAGE_PRESENT)
 static inline int pgd_large(pgd_t pgd) { return 0; }
-#define mk_kernel_pgd(address) ((pgd_t){ (address) | _KERNPG_TABLE })
+#define mk_kernel_pgd(address) __pgd((address) | _KERNPG_TABLE)
 
 /* PUD - Level3 access */
 /* to find an entry in a page-table-directory. */


