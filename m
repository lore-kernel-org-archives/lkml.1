Return-Path: <linux-kernel-owner+w=401wt.eu-S1760323AbYJMUYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760323AbYJMUYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 16:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759986AbYJMUYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 16:24:31 -0400
Received: from iona.labri.fr ([147.210.8.143]:59407 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759965AbYJMUYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 16:24:30 -0400
Message-ID: <48F3AE45.90104@inria.fr>
Date: Mon, 13 Oct 2008 22:23:33 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Andrew Morton <akpm@osdl.org>,
       Nathalie Furmento <nathalie.furmento@labri.fr>
Subject: [PATCH 5/5] mm: move_pages: no need to set pp->page to ZERO_PAGE(0)
 by default
References: <48F3AD47.1050301@inria.fr>
In-Reply-To: <48F3AD47.1050301@inria.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pp->page is never used when not set to the right page, so there is
no need to set it to ZERO_PAGE(0) by default.

Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
---
 mm/migrate.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 175e242..2453444 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -878,12 +878,6 @@ static int do_move_page_to_node_array(struct mm_struct *mm,
 		struct vm_area_struct *vma;
 		struct page *page;
 
-		/*
-		 * A valid page pointer that will not match any of the
-		 * pages that will be moved.
-		 */
-		pp->page = ZERO_PAGE(0);
-
 		err = -EFAULT;
 		vma = find_vma(mm, pp->addr);
 		if (!vma || !vma_migratable(vma))
-- 
1.5.6.5



