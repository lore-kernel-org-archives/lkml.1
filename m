Return-Path: <linux-kernel-owner+w=401wt.eu-S1033755AbXEIDQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033755AbXEIDQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 23:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1033035AbXEIDNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 23:13:33 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59071 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033011AbXEIDNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 23:13:31 -0400
Date: Wed, 09 May 2007 12:12:12 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: [RFC] memory hotremove patch take 2 [08/10] (memap init alignment)
Cc: Andrew Morton <akpm@osdl.org>, Christoph Lameter <clameter@sgi.com>,
       Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20070509115506.B904.Y-GOTO@jp.fujitsu.com>
References: <20070509115506.B904.Y-GOTO@jp.fujitsu.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070509120814.B916.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


If there is small hole at end of a section, there are not initialized pages.
To find it, messy check is necessary at many place of memory remove code.
But, reserved bit by initialization is enough for most case of them.


Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

 mm/page_alloc.c |    5 +++++
 1 files changed, 5 insertions(+)

Index: current_test/mm/page_alloc.c
===================================================================
--- current_test.orig/mm/page_alloc.c	2007-05-08 15:08:05.000000000 +0900
+++ current_test/mm/page_alloc.c	2007-05-08 15:08:08.000000000 +0900
@@ -2434,6 +2434,11 @@ void __meminit memmap_init_zone(unsigned
 	unsigned long end_pfn = start_pfn + size;
 	unsigned long pfn;
 
+
+#ifdef CONFIG_SPARSEMEM
+	end_pfn = roundup(end_pfn, PAGES_PER_SECTION);
+#endif
+
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 		/*
 		 * There can be holes in boot-time mem_map[]s

-- 
Yasunori Goto 


