Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbYLVG2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbYLVG2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 01:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbYLVG1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 01:27:52 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51767 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbYLVG1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 01:27:52 -0500
Date: Mon, 22 Dec 2008 15:26:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH][mmotm] memcg use css_tryget fix
Message-Id: <20081222152650.207cf149.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sorry for that I'm still generating new bugs...sigh.
-Kame
=
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

root_mem->last_scanned_child can be NULL here.
This may cause NULL pointer access when hierarchy is used.
This is a fix for memcg-use-css-tryget-in-memcg.patch

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: mmotm-2.6.28-Dec19/mm/memcontrol.c
===================================================================
--- mmotm-2.6.28-Dec19.orig/mm/memcontrol.c
+++ mmotm-2.6.28-Dec19/mm/memcontrol.c
@@ -656,7 +656,7 @@ mem_cgroup_get_first_node(struct mem_cgr
 
 	if (!root_mem->last_scanned_child || obsolete) {
 
-		if (obsolete)
+		if (obsolete && root_mem->last_scanned_child)
 			mem_cgroup_put(root_mem->last_scanned_child);
 
 		cgroup = list_first_entry(&root_mem->css.cgroup->children,

