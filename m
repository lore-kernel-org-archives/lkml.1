Return-Path: <linux-kernel-owner+w=401wt.eu-S1757709AbYDSJ1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709AbYDSJ1H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 05:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbYDSJ04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 05:26:56 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51730 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbYDSJ0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 05:26:55 -0400
Date: Sat, 19 Apr 2008 18:26:28 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH][trivial] mm/pagewalk.c break const constraint.
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20080419181759.A8EB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

patch against 2.6.25

when compile 2.6.25, following warnings was outputed.

  CC      mm/pagewalk.o
mm/pagewalk.c: In function 'walk_page_range':
mm/pagewalk.c:111: warning: passing argument 1 of 'pgd_offset' discards qualifiers from p\
ointer target type

mm argument of walk_page_range() is unnecessary const restriction. 
this patch is no functional change. it's only remove warning.

Thanks!


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Matt Mackall <mpm@selenic.com>

---
 include/linux/mm.h |    2 +-
 mm/pagewalk.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: b/mm/pagewalk.c
===================================================================
--- a/mm/pagewalk.c     2008-04-19 17:46:34.000000000 +0900
+++ b/mm/pagewalk.c     2008-04-19 18:43:58.000000000 +0900
@@ -97,7 +97,7 @@ static int walk_pud_range(pgd_t *pgd, un
  * If any callback returns a non-zero value, the walk is aborted and
  * the return value is propagated back to the caller. Otherwise 0 is returned.
  */
-int walk_page_range(const struct mm_struct *mm,
+int walk_page_range(struct mm_struct *mm,
                    unsigned long addr, unsigned long end,
                    const struct mm_walk *walk, void *private)
 {
Index: b/include/linux/mm.h
===================================================================
--- a/include/linux/mm.h        2008-04-19 17:46:12.000000000 +0900
+++ b/include/linux/mm.h        2008-04-19 18:44:14.000000000 +0900
@@ -746,7 +746,7 @@ struct mm_walk {
        int (*pte_hole)(unsigned long, unsigned long, void *);
 };

-int walk_page_range(const struct mm_struct *, unsigned long addr,
+int walk_page_range(struct mm_struct *, unsigned long addr,
                    unsigned long end, const struct mm_walk *walk,
                    void *private);
 void free_pgd_range(struct mmu_gather **tlb, unsigned long addr,





