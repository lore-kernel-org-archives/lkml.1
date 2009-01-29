Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbZA2V6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbZA2V6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 16:58:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbZA2V6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 16:58:25 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:45680 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbZA2V6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 16:58:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QfbDRYsQ5dLXAuEYtyWEM66qYerN1J9Bi2wPppzCDOuUctl1wXAdavW9pOPBdjXCBk
         g5v3H3dZR9+WBTF7Tzhh8UFARHyIDBS0aA0lSAFiobuTiVxEWU3tudpeH7chS/HSDEeG
         6hF51hGYhgv/RJBriQKd3menWjUtLYNMsgKYU=
From: Andrea Righi <righi.andrea@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
       David Howells <dhowells@redhat.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Andrea Righi <righi.andrea@gmail.com>
Subject: [PATCH -mmotm] mm: unify some pmd_*() functions fix for m68k sun3
Date: Thu, 29 Jan 2009 22:58:17 +0100
Message-Id: <1233266297-12995-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sun3_defconfig fails with:

    CC      mm/memory.o
  mm/memory.c: In function 'free_pmd_range':
  mm/memory.c:176: error: implicit declaration of function '__pmd_free_tlb'
  mm/memory.c: In function '__pmd_alloc':
  mm/memory.c:2903: error: implicit declaration of function 'pmd_alloc_one_bug'
  mm/memory.c:2903: warning: initialization makes pointer from integer without a cast
  mm/memory.c:2917: error: implicit declaration of function 'pmd_free'
  make[3]: *** [mm/memory.o] Error 1

Add the missing include.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 include/asm-m68k/sun3_pgalloc.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/asm-m68k/sun3_pgalloc.h b/include/asm-m68k/sun3_pgalloc.h
index 0fe28fc..399d280 100644
--- a/include/asm-m68k/sun3_pgalloc.h
+++ b/include/asm-m68k/sun3_pgalloc.h
@@ -11,6 +11,7 @@
 #define _SUN3_PGALLOC_H
 
 #include <asm/tlb.h>
+#include <asm-generic/pgtable-nopmd.h>
 
 /* FIXME - when we get this compiling */
 /* erm, now that it's compiling, what do we do with it? */
-- 
1.5.6.3

