Return-Path: <linux-kernel-owner+w=401wt.eu-S1755663AbZCFKj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbZCFKj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 05:39:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbZCFKjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 05:39:45 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59158 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbZCFKjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 05:39:44 -0500
Date: Fri, 6 Mar 2009 19:38:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Bharata B Rao <bharata@in.ibm.com>, Paul Menage <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH 3/3] memcg documenation soft limit (Yet Another One)
Message-Id: <20090306193821.ca2fb628.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090306193438.8084837d.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090306092323.21063.93169.sendpatchset@localhost.localdomain>
	<20090306185440.66b92ca3.kamezawa.hiroyu@jp.fujitsu.com>
	<20090306193438.8084837d.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Documentation for softlimit (3/3)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 Documentation/cgroups/memory.txt |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

Index: mmotm-2.6.29-Mar3/Documentation/cgroups/memory.txt
===================================================================
--- mmotm-2.6.29-Mar3.orig/Documentation/cgroups/memory.txt
+++ mmotm-2.6.29-Mar3/Documentation/cgroups/memory.txt
@@ -322,6 +322,25 @@ will be charged as a new owner of it.
   - a cgroup which uses hierarchy and it has child cgroup.
   - a cgroup which uses hierarchy and not the root of hierarchy.
 
+5.4 softlimit
+  Memory cgroup supports softlimit and has 2 params for control.
+    - memory.softlimit_in_bytes
+	- softlimit to this cgroup.
+    - memory.softlimit_priority.
+	- priority of this cgroup at softlimit reclaim.
+	  Allowed priority level is 3-0 and 3 is the lowest.
+	  If 0, this cgroup will not be target of softlimit.
+
+  At memory shortage of the system (or local node/zone), softlimit helps
+  kswapd(), a global memory recalim kernel thread, and inform victim cgroup
+  to be shrinked to kswapd.
+
+  Victim selection logic:
+  The kernel searches from the lowest priroty(3) up to the highest(1).
+  If it find a cgroup witch has memory larger than softlimit, steal memory
+  from it.
+  If multiple cgroups are on the same priority, each cgroup wil be a
+  victim in turn.
 
 6. Hierarchy support
 

