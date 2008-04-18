Return-Path: <linux-kernel-owner+w=401wt.eu-S1757029AbYDRDK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbYDRDK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 23:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbYDRDKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 23:10:51 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43717 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbYDRDKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 23:10:51 -0400
Date: Fri, 18 Apr 2008 12:10:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, shiwh@cn.fujitsu.com,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>
Subject: [PATCH] fix page_reset_bad_cgroup
Message-Id: <20080418121046.892c44a5.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

page->page_cgroup is unsigned long. Should be cleared by 0UL.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


Index: linux-2.6.25/include/linux/memcontrol.h
===================================================================
--- linux-2.6.25.orig/include/linux/memcontrol.h
+++ linux-2.6.25/include/linux/memcontrol.h
@@ -30,7 +30,7 @@ struct mm_struct;
 extern void mm_init_cgroup(struct mm_struct *mm, struct task_struct *p);
 extern void mm_free_cgroup(struct mm_struct *mm);
 
-#define page_reset_bad_cgroup(page)	((page)->page_cgroup = 0)
+#define page_reset_bad_cgroup(page)	((page)->page_cgroup = 0UL)
 
 extern struct page_cgroup *page_get_page_cgroup(struct page *page);
 extern int mem_cgroup_charge(struct page *page, struct mm_struct *mm,

