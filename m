Return-Path: <linux-kernel-owner+w=401wt.eu-S1755545AbZCLBCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbZCLBCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 21:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbZCLBCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 21:02:38 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41068 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbZCLBCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 21:02:38 -0400
Date: Thu, 12 Mar 2009 10:01:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: [RFC][PATCH 6/5] softlimit document
Message-Id: <20090312100112.6f010cae.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090312095247.bf338fe8.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090312095247.bf338fe8.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry...6th patch.
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Documentation for softlimit

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 Documentation/cgroups/memory.txt |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

Index: mmotm-2.6.29-Mar10/Documentation/cgroups/memory.txt
===================================================================
--- mmotm-2.6.29-Mar10.orig/Documentation/cgroups/memory.txt
+++ mmotm-2.6.29-Mar10/Documentation/cgroups/memory.txt
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
 

