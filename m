Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbYKJJj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbYKJJj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 04:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754081AbYKJJjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 04:39:18 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60524 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbYKJJjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 04:39:17 -0500
Date: Mon, 10 Nov 2008 18:38:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, pbadari@us.ibm.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [BUGFIX][PATCH] memcg: memory hotplug fix
Message-Id: <20081110183839.e551a52e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a bug fix reported against 2.6.28-rc3 from Badari.
Badari, could you give me Ack or Tested-by ?

Thanks,
-Kame
==
start pfn calculation of page_cgroup's memory hotplug notifier chain
is wrong.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


 mm/page_cgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: mmotm-2.6.28-Oct30/mm/page_cgroup.c
===================================================================
--- mmotm-2.6.28-Oct30.orig/mm/page_cgroup.c
+++ mmotm-2.6.28-Oct30/mm/page_cgroup.c
@@ -165,7 +165,7 @@ int online_page_cgroup(unsigned long sta
 	unsigned long start, end, pfn;
 	int fail = 0;
 
-	start = start_pfn & (PAGES_PER_SECTION - 1);
+	start = start_pfn & ~(PAGES_PER_SECTION - 1);
 	end = ALIGN(start_pfn + nr_pages, PAGES_PER_SECTION);
 
 	for (pfn = start; !fail && pfn < end; pfn += PAGES_PER_SECTION) {
@@ -188,7 +188,7 @@ int offline_page_cgroup(unsigned long st
 {
 	unsigned long start, end, pfn;
 
-	start = start_pfn & (PAGES_PER_SECTION - 1);
+	start = start_pfn & ~(PAGES_PER_SECTION - 1);
 	end = ALIGN(start_pfn + nr_pages, PAGES_PER_SECTION);
 
 	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION)

