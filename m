Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYLAMPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYLAMPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbYLAMPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:15:05 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43350 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbYLAMPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:15:03 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: [PATCH 05/11] memcg: add null check to page_cgroup_zoneinfo()
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20081201205810.1CCA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081201205810.1CCA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081201211424.1CD9.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Mon,  1 Dec 2008 21:14:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y, page_cgroup::mem_cgroup can be NULL.
Therefore null checking is better.

latter patch use this function.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/memcontrol.c |    3 +++
 1 file changed, 3 insertions(+)

Index: b/mm/memcontrol.c
===================================================================
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -231,6 +231,9 @@ page_cgroup_zoneinfo(struct page_cgroup 
 	int nid = page_cgroup_nid(pc);
 	int zid = page_cgroup_zid(pc);
 
+	if (!mem)
+		return NULL;
+
 	return mem_cgroup_zoneinfo(mem, nid, zid);
 }
 


