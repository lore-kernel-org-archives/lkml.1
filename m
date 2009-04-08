Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbZDHHSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbZDHHSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbZDHHSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:18:14 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60281 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbZDHHSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:18:13 -0400
Date: Wed, 8 Apr 2009 12:48:17 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] memcg: Fix documentation
Message-ID: <20090408071817.GD4069@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memcg: Fix documentation.

The description about various statistics from memory.stat is not accurate
and confusing at times.

Correct this along with a few other minor cleanups.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 Documentation/cgroups/memory.txt |   50 +++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 22 deletions(-)

--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -6,15 +6,14 @@ used here with the memory controller tha
 
 Salient features
 
-a. Enable control of both RSS (mapped) and Page Cache (unmapped) pages
+a. Enable control of RSS (mapped), Page Cache (unmapped) and Swap cache
+   (unmapped) pages.
 b. The infrastructure allows easy addition of other types of memory to control
 c. Provides *zero overhead* for non memory controller users
 d. Provides a double LRU: global memory pressure causes reclaim from the
    global LRU; a cgroup on hitting a limit, reclaims from the per
    cgroup LRU
 
-NOTE: Swap Cache (unmapped) is not accounted now.
-
 Benefits and Purpose of the memory controller
 
 The memory controller isolates the memory behaviour of a group of tasks
@@ -290,34 +289,41 @@ will be charged as a new owner of it.
   moved to the parent. If you want to avoid that, force_empty will be useful.
 
 5.2 stat file
-  memory.stat file includes following statistics (now)
-	cache			- # of pages from page-cache and shmem.
-	rss			- # of pages from anonymous memory.
-	pgpgin			- # of event of charging
-	pgpgout			- # of event of uncharging
-	active_anon		- # of pages on active lru of anon, shmem.
-	inactive_anon 		- # of pages on active lru of anon, shmem
-	active_file		- # of pages on active lru of file-cache
-	inactive_file		- # of pages on inactive lru of file cache
-	unevictable		- # of pages cannot be reclaimed.(mlocked etc)
-
-	Below is depend on CONFIG_DEBUG_VM.
-	inactive_ratio		- VM inernal parameter. (see mm/page_alloc.c)
-	recent_rotated_anon	- VM internal parameter. (see mm/vmscan.c)
-	recent_rotated_file	- VM internal parameter. (see mm/vmscan.c)
-	recent_scanned_anon 	- VM internal parameter. (see mm/vmscan.c)
-	recent_scanned_file 	- VM internal parameter. (see mm/vmscan.c)
 
-  Memo:
+memory.stat file includes following statistics
+
+cache		- # of bytes of page-cache memory.
+rss		- # of bytes of anonymous memory.
+pgpgin		- # of pages paged in (equivalent to # of charging events).
+pgpgout		- # of pages paged out (equivalent to # of uncharging events).
+active_anon	- # of bytes of anonymous memory on active lru list.
+inactive_anon	- # of bytes of anonymous memory on inactive lru list.
+active_file	- # of bytes of file-backed memory on active lru list.
+inactive_file	- # of bytes of file-backed memory on inactive lru list.
+unevictable	- # of bytes of memory that cannot be reclaimed (mlocked etc).
+
+The following additional stats are dependent on CONFIG_DEBUG_VM.
+
+inactive_ratio		- VM inernal parameter. (see mm/page_alloc.c)
+recent_rotated_anon	- VM internal parameter. (see mm/vmscan.c)
+recent_rotated_file	- VM internal parameter. (see mm/vmscan.c)
+recent_scanned_anon	- VM internal parameter. (see mm/vmscan.c)
+recent_scanned_file	- VM internal parameter. (see mm/vmscan.c)
+
+Memo:
 	recent_rotated means recent frequency of lru rotation.
 	recent_scanned means recent # of scans to lru.
 	showing for better debug please see the code for meanings.
 
+Note:
+	Only anonymous memory is listed as part of 'rss' stat. This should
+	not be confused with the true 'resident set size' or the amount of
+	physical memory used by the cgroup.
 
 5.3 swappiness
   Similar to /proc/sys/vm/swappiness, but affecting a hierarchy of groups only.
 
-  Following cgroup's swapiness can't be changed.
+  Following cgroups' swapiness can't be changed.
   - root cgroup (uses /proc/sys/vm/swappiness).
   - a cgroup which uses hierarchy and it has child cgroup.
   - a cgroup which uses hierarchy and not the root of hierarchy.
