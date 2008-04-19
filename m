Return-Path: <linux-kernel-owner+w=401wt.eu-S1761299AbYDSKJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761299AbYDSKJd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 06:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYDSKJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 06:09:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52431 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbYDSKJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 06:09:25 -0400
Date: Sat, 19 Apr 2008 19:09:25 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Matt Mackall" <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>, dev-etrax@axis.com,
       Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [PATCH][trivial][2/2] cris: add constfy to pgd_offset()
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20080419190442.A8F4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080419185723.A8F1.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080419190442.A8F4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080419190710.A8F7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add constfy to pgd_offset() for avoid following warnings.
 
  CC      mm/pagewalk.o
mm/pagewalk.c: In function 'walk_page_range':
mm/pagewalk.c:111: warning: passing argument 1 of 'pgd_offset' discards qualifiers from p\
ointer target type

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Matt Mackall <mpm@selenic.com>
CC: "Vegard Nossum" <vegard.nossum@gmail.com>
CC: Mikael Starvik <starvik@axis.com>
CC: Jesper Nilsson <jesper.nilsson@axis.com>

---
 include/asm-cris/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/include/asm-cris/pgtable.h
===================================================================
--- a/include/asm-cris/pgtable.h        2008-04-19 19:25:50.000000000 +0900
+++ b/include/asm-cris/pgtable.h        2008-04-19 19:27:31.000000000 +0900
@@ -229,7 +229,7 @@ static inline void pmd_set(pmd_t * pmdp,
 #define pgd_index(address) (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))

 /* to find an entry in a page-table-directory */
-static inline pgd_t * pgd_offset(struct mm_struct * mm, unsigned long address)
+static inline pgd_t * pgd_offset(const struct mm_struct * mm, unsigned long address)
 {
        return mm->pgd + pgd_index(address);
 }



