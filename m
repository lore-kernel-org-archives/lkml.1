Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbZLBEhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbZLBEhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 23:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755425AbZLBEhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 23:37:52 -0500
Received: from mga14.intel.com ([143.182.124.37]:57394 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324AbZLBEha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 23:37:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="217764929"
Message-Id: <20091202043046.420815285@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 02 Dec 2009 11:12:52 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
TO: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Nick Piggin <npiggin@suse.de>
CC: <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 21/24] cgroup: define empty css_put() when !CONFIG_CGROUPS
References: <20091202031231.735876003@intel.com>
Content-Disposition: inline; filename=memcg-css_put.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will be used by the hwpoison inject code for releasing the
css grabbed by try_get_mem_cgroup_from_page().

CC: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Li Zefan <lizf@cn.fujitsu.com>
CC: Paul Menage <menage@google.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/cgroup.h |    3 +++
 1 file changed, 3 insertions(+)

--- linux-mm.orig/include/linux/cgroup.h	2009-11-02 10:18:41.000000000 +0800
+++ linux-mm/include/linux/cgroup.h	2009-11-02 10:26:22.000000000 +0800
@@ -581,6 +581,9 @@ static inline int cgroupstats_build(stru
 	return -EINVAL;
 }
 
+struct cgroup_subsys_state;
+static inline void css_put(struct cgroup_subsys_state *css) {}
+
 #endif /* !CONFIG_CGROUPS */
 
 #endif /* _LINUX_CGROUP_H */


