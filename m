Return-Path: <linux-kernel-owner+w=401wt.eu-S932174AbXGNBSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbXGNBSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760854AbXGNBSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:18:15 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:51617 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760283AbXGNBSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:18:15 -0400
Date: Fri, 13 Jul 2007 21:18:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] i386 CPA fix - do not free reserved pages
Message-ID: <20070714011813.GA31649@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:16:35 up 6 days, 15:21,  2 users,  load average: 0.18, 0.17, 0.18
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i386 CPA fix - do not free reserved pages

We have to use the same conditions found in change_page_attr in
global_tlb_flush regarding the conditions that leads to free the page.

It applies to 2.6.22-rc6-mm1 (as it been applied for the next one ?)

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>
---
 arch/i386/mm/pageattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-lttng/arch/i386/mm/pageattr.c
===================================================================
--- linux-2.6-lttng.orig/arch/i386/mm/pageattr.c	2007-07-03 13:25:48.000000000 -0400
+++ linux-2.6-lttng/arch/i386/mm/pageattr.c	2007-07-03 13:28:34.000000000 -0400
@@ -247,7 +247,7 @@
 	list_for_each_entry_safe(pg, next, &l, lru) {
 		clear_bit(PG_arch_1, &pg->flags);
 		list_del(&pg->lru);
-		if (page_private(pg) != 0)
+		if (PageReserved(pg) || !cpu_has_pse || page_private(pg) != 0)
 			continue;
 		ClearPagePrivate(pg);
 		__free_page(pg);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
