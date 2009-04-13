Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbZDMGp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbZDMGp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 02:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbZDMGpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 02:45:19 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35077 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbZDMGpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 02:45:19 -0400
Date: Mon, 13 Apr 2009 15:43:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: [BUGFIX][PATCH]  memcg: use rcu_dereference to access mm->owner
Message-Id: <20090413154343.b12e9711.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the patch itself is against mmotm-Apr11.
Maybe it's better to apply 2.6.30-rc series.
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

mm->owner should be accessed with rcu_dereference().

Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: mmotm-2.6.30-Apr11/include/linux/memcontrol.h
===================================================================
--- mmotm-2.6.30-Apr11.orig/include/linux/memcontrol.h
+++ mmotm-2.6.30-Apr11/include/linux/memcontrol.h
@@ -75,7 +75,7 @@ int mm_match_cgroup(const struct mm_stru
 {
 	struct mem_cgroup *mem;
 	rcu_read_lock();
-	mem = mem_cgroup_from_task((mm)->owner);
+	mem = mem_cgroup_from_task(rcu_dereference((mm)->owner));
 	rcu_read_unlock();
 	return cgroup == mem;
 }

