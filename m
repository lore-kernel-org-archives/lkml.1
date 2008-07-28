Return-Path: <linux-kernel-owner+w=401wt.eu-S1760464AbYG1RYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760464AbYG1RYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 13:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757941AbYG1RX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 13:23:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:60020 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607AbYG1RX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 13:23:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=Qxlflm7X+HxP1ULIizDASi/tFzUlJQ+uNfEUhwABaDfbCfxLoxZvhpCMpeyjO5UjNO
         NxCZiJFOE+EsosPCytqh2dxfDqUcXFsomo+O75VcAP33/ri4Uu5FUqk0ffw5pxzGmS6p
         wvEK9EOtmdb1qP1MngHcoX7bDZnqtDcyWV6Sw=
From: Andrea Righi <righi.andrea@gmail.com>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrea Righi <righi.andrea@gmail.com>
Subject: [PATCH 1/1] x86: remove unused variable pmd warning
Date: Mon, 28 Jul 2008 19:23:52 +0200
Message-Id: <1217265832-19686-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the following warning on x86 when CONFIG_X86_PAE is not set:

    arch/x86/mm/pgtable.c: In function ‘pgd_mop_up_pmds’:
    arch/x86/mm/pgtable.c:194: warning: unused variable ‘pmd’

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 include/asm-generic/pgtable-nopmd.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index 087325e..fe9c96b 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -54,7 +54,10 @@ static inline pmd_t * pmd_offset(pud_t * pud, unsigned long address)
  * inside the pud, so has no extra memory associated with it.
  */
 #define pmd_alloc_one(mm, address)		NULL
-#define pmd_free(mm, x)				do { } while (0)
+struct mm_struct;
+static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
+{
+}
 #define __pmd_free_tlb(tlb, x)			do { } while (0)
 
 #undef  pmd_addr_end
-- 
1.5.4.3

