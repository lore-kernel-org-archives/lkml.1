Return-Path: <linux-kernel-owner+w=401wt.eu-S1759987AbZBYHi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987AbZBYHi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 02:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755349AbZBYHis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 02:38:48 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54922 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbZBYHis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 02:38:48 -0500
Date: Wed, 25 Feb 2009 16:37:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
       "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: [PATCH 2/2] cgroup/memcg show correct file mode
Message-Id: <20090225163729.cc43bd5c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090225163555.d2a0b24c.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090225163555.d2a0b24c.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Set correct permission to memcg's file.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: mmotm-2.6.29-Feb24/mm/memcontrol.c
===================================================================
--- mmotm-2.6.29-Feb24.orig/mm/memcontrol.c
+++ mmotm-2.6.29-Feb24/mm/memcontrol.c
@@ -2218,6 +2218,7 @@ static struct cftype mem_cgroup_files[] 
 		.name = "usage_in_bytes",
 		.private = MEMFILE_PRIVATE(_MEM, RES_USAGE),
 		.read_u64 = mem_cgroup_read,
+		.mode = 0444
 	},
 	{
 		.name = "max_usage_in_bytes",
@@ -2240,10 +2241,12 @@ static struct cftype mem_cgroup_files[] 
 	{
 		.name = "stat",
 		.read_map = mem_control_stat_show,
+		.mode = 0444
 	},
 	{
 		.name = "force_empty",
 		.trigger = mem_cgroup_force_empty_write,
+		.mode = 0200
 	},
 	{
 		.name = "use_hierarchy",
@@ -2263,6 +2266,7 @@ static struct cftype memsw_cgroup_files[
 		.name = "memsw.usage_in_bytes",
 		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_USAGE),
 		.read_u64 = mem_cgroup_read,
+		.mode = 0444
 	},
 	{
 		.name = "memsw.max_usage_in_bytes",

