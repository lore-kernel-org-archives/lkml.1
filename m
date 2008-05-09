Return-Path: <linux-kernel-owner+w=401wt.eu-S934666AbYEIFv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934666AbYEIFv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 01:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbYEIFvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 01:51:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40074 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbYEIFvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 01:51:49 -0400
Date: Fri, 9 May 2008 14:56:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>, lizf@cn.fujitsu.com,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
Subject: [PATCH] memcg: make global var to be read_mostly
Message-Id: <20080509145631.408a9a67.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An easy cut out from memcg: performance improvement patch set.
Tested on: x86-64/linux-2.6.26-rc1-git6

Thanks,
-Kame

==
mem_cgroup_subsys and page_cgroup_cache should be read_mostly and
MEM_CGROUP_RECLAIM_RETRIES can be just a fixed number.

Changelog:
  * makes MEM_CGROUP_RECLAIM_RETRIES to be a macro

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



Index: linux-2.6.26-rc1/mm/memcontrol.c
===================================================================
--- linux-2.6.26-rc1.orig/mm/memcontrol.c
+++ linux-2.6.26-rc1/mm/memcontrol.c
@@ -35,9 +35,9 @@
 
 #include <asm/uaccess.h>
 
-struct cgroup_subsys mem_cgroup_subsys;
-static const int MEM_CGROUP_RECLAIM_RETRIES = 5;
-static struct kmem_cache *page_cgroup_cache;
+struct cgroup_subsys mem_cgroup_subsys __read_mostly;
+static struct kmem_cache *page_cgroup_cache __read_mostly;
+#define MEM_CGROUP_RECLAIM_RETRIES	5
 
 /*
  * Statistics for memory cgroup.

