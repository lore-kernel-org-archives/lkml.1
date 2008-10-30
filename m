Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbYJ3EjC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbYJ3EjC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 00:39:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbYJ3Eiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 00:38:54 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:55735 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbYJ3Eix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 00:38:53 -0400
Subject: [PATCH] memcg: do not recalculate section unnecessarily in
	init_section_page_cgroup
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Thu, 30 Oct 2008 13:38:50 +0900
Message-Id: <1225341530.3135.26.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.28-rc2-mm1-orig/mm/page_cgroup.c linux-2.6.28-rc2-mm1/mm/page_cgroup.c
--- linux-2.6.28-rc2-mm1-orig/mm/page_cgroup.c	2008-10-30 12:49:27.000000000 +0900
+++ linux-2.6.28-rc2-mm1/mm/page_cgroup.c	2008-10-30 12:52:41.000000000 +0900
@@ -99,13 +99,11 @@ struct page_cgroup *lookup_page_cgroup(s
 
 int __meminit init_section_page_cgroup(unsigned long pfn)
 {
-	struct mem_section *section;
+	struct mem_section *section = __pfn_to_section(pfn);
 	struct page_cgroup *base, *pc;
 	unsigned long table_size;
 	int nid, index;
 
-	section = __pfn_to_section(pfn);
-
 	if (section->page_cgroup)
 		return 0;
 
@@ -131,7 +129,6 @@ int __meminit init_section_page_cgroup(u
 		__init_page_cgroup(pc, pfn + index);
 	}
 
-	section = __pfn_to_section(pfn);
 	section->page_cgroup = base - pfn;
 	total_usage += table_size;
 	return 0;


