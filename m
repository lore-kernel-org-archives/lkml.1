Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbYLZH1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbYLZH1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 02:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYLZH12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 02:27:28 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:56448 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbYLZH10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 02:27:26 -0500
Date: Fri, 26 Dec 2008 08:27:24 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: lethal@linux-sh.org, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/7] arch/sh/mm: Move a dereference below a NULL test
Message-ID: <Pine.LNX.4.64.0812260826540.25450@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test is necessary, then the dereference should be moved below
the NULL test.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/).

// <smpl>
@disable is_null@
identifier f;
expression E;
identifier fld;
statement S;
@@

+ if (E == NULL) S
  f(...,E->fld,...);
- if (E == NULL) S

@@
identifier f;
expression E;
identifier fld;
statement S;
@@

+ if (!E) S
  f(...,E->fld,...);
- if (!E) S
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/sh/mm/ioremap_64.c             |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sh/mm/ioremap_64.c b/arch/sh/mm/ioremap_64.c
index 6e0be24..fddcab4 100644
--- a/arch/sh/mm/ioremap_64.c
+++ b/arch/sh/mm/ioremap_64.c
@@ -71,9 +71,9 @@ void *__ioremap(unsigned long phys_addr, unsigned long size,
 	 * Ok, go for it..
 	 */
 	area = get_vm_area(size, VM_IOREMAP);
-	pr_debug("Get vm_area returns %p addr %p\n",area,area->addr);
 	if (!area)
 		return NULL;
+	pr_debug("Get vm_area returns %p addr %p\n", area, area->addr);
 	area->phys_addr = phys_addr;
 	addr = area->addr;
 	if (ioremap_page_range((unsigned long)addr, (unsigned long)addr + size,
