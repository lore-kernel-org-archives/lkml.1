Return-Path: <linux-kernel-owner+w=401wt.eu-S1752070AbYLPHHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbYLPHHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 02:07:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbYLPHGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 02:06:50 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46656 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYLPHGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 02:06:48 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Brice Goglin <Brice.Goglin@inria.fr>, Christoph Lameter <clameter@sgi.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Hugh Dickins <hugh@veritas.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH for 2.6.28] mm: Don't touch uninitialized variable in do_pages_stat_array()
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081216160303.DBA8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 16 Dec 2008 16:06:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


80bba1290ab5122c60cdb73332b26d288dc8aedd remove one necessary variable initialization.
Then, following warning happend.

  CC      mm/migrate.o
mm/migrate.c: In function 'sys_move_pages':
mm/migrate.c:1001: warning: 'err' may be used uninitialized in this function

More unfortunately, if find_vma() failed, kernel read uninitialized memory.



Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>
---
 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/mm/migrate.c
===================================================================
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -998,7 +998,7 @@ static void do_pages_stat_array(struct m
 		unsigned long addr = (unsigned long)(*pages);
 		struct vm_area_struct *vma;
 		struct page *page;
-		int err;
+		int err = -EFAULT;
 
 		vma = find_vma(mm, addr);
 		if (!vma)


