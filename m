Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbYLCE7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbYLCE7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 23:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbYLCE7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 23:59:34 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48433 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbYLCE7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 23:59:33 -0500
Date: Wed, 3 Dec 2008 13:58:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH  10/21] memcg-add-null-check-to-page_cgroup_zoneinfo.patch
Message-Id: <20081203135842.15ce50c5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081203134718.6b60986f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081203134718.6b60986f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y, page_cgroup::mem_cgroup can be NULL.
Therefore null checking is better.

latter patch use this function.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
 mm/memcontrol.c |    3 +++
 1 file changed, 3 insertions(+)

Index: mmotm-2.6.28-Dec02/mm/memcontrol.c
===================================================================
--- mmotm-2.6.28-Dec02.orig/mm/memcontrol.c
+++ mmotm-2.6.28-Dec02/mm/memcontrol.c
@@ -231,6 +231,9 @@ page_cgroup_zoneinfo(struct page_cgroup 
 	int nid = page_cgroup_nid(pc);
 	int zid = page_cgroup_zid(pc);
 
+	if (!mem)
+		return NULL;
+
 	return mem_cgroup_zoneinfo(mem, nid, zid);
 }
 

