Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbXK0C4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbXK0C4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 21:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbXK0C4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 21:56:00 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39742 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbXK0Cz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 21:55:59 -0500
Date: Tue, 27 Nov 2007 11:59:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH][for -mm] per-zone and reclaim enhancements for memory
 controller take 3 [2/10] nid/zid helper function for cgroup
Message-Id: <20071127115914.cf20f5b2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071127115525.e9779108.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071127115525.e9779108.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add macro to get node_id and zone_id of page_cgroup.
Will be used in per-zone-xxx patches and others.

Changelog:
 - returns zone_type instead of int.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


 mm/memcontrol.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6.24-rc3-mm1/mm/memcontrol.c
===================================================================
--- linux-2.6.24-rc3-mm1.orig/mm/memcontrol.c	2007-11-26 15:31:19.000000000 +0900
+++ linux-2.6.24-rc3-mm1/mm/memcontrol.c	2007-11-26 16:39:00.000000000 +0900
@@ -135,6 +135,16 @@
 #define PAGE_CGROUP_FLAG_CACHE	(0x1)	/* charged as cache */
 #define PAGE_CGROUP_FLAG_ACTIVE (0x2)	/* page is active in this cgroup */
 
+static inline int page_cgroup_nid(struct page_cgroup *pc)
+{
+	return page_to_nid(pc->page);
+}
+
+static inline enum zone_type page_cgroup_zid(struct page_cgroup *pc)
+{
+	return page_zonenum(pc->page);
+}
+
 enum {
 	MEM_CGROUP_TYPE_UNSPEC = 0,
 	MEM_CGROUP_TYPE_MAPPED,

