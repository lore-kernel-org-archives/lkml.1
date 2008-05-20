Return-Path: <linux-kernel-owner+w=401wt.eu-S1761784AbYETJAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761784AbYETJAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757635AbYETJAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:00:32 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39747 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbYETJAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:00:31 -0400
Date: Tue, 20 May 2008 18:05:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "menage@google.com" <menage@google.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
Subject: [RFC][PATCH 1/3] memcg: documentation for controll file
Message-Id: <20080520180552.601da567.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add a documentation for memory resource controller's files.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


Index: mm-2.6.26-rc2-mm1/Documentation/controllers/memory_files.txt
===================================================================
--- /dev/null
+++ mm-2.6.26-rc2-mm1/Documentation/controllers/memory_files.txt
@@ -0,0 +1,76 @@
+Files under memory resource controller and its resource counter.
+(See controllers/memory.txt about memory resource controller)
+
+* memory.usage_in_bytes
+  (read)
+  Currently accounted memory usage under memory controller in bytes.
+  multiple of PAGE_SIZE.
+
+  Even if there is no tasks under controller, some page caches and
+  swap caches are still accounted. (See memory.force_empty below.)
+
+  (write)
+  no write operation
+
+* memory.limit_in_bytes
+  (read)
+  Current limit of usage to this memory resource controller in bytes.
+  (write)
+  Set limit to this memory resource controller.
+  A user can use "K', 'M', 'G' to specify the limit.
+
+  (Example) You can set limit of 400M by following.
+  % echo 400M > /path to cgroup/memory.limit_in_bytes
+
+* memory.max_usage_in_bytes
+  (read)
+  Recorded maximum memory usage under this memory controller.
+
+  (write)
+  Reset the record to 0.
+
+  (example usage)
+  1. create a cgroup
+  % mkdir /path_to_cgroup/my_cgroup.
+
+  2. enter the cgroup
+  % echo $$ > /path_to_cgroup/my_cgroup/tasks.
+
+  3. Run your program
+  % Run......
+
+  4. See how much you used.
+  % cat /path_to_cgroup/my_cgroup/memory.max_usage_in_bytes.
+
+  Now you know how much your application will use. Maybe this
+  can be a good to set  limits_in_bytes to some proper value.
+
+* memory.force_empty
+  (read)
+  not allowed.
+  (write)
+  Drop all charges under cgroup. This can be called only when
+  there is no task under this cgroup. This is here for debug purpose.
+
+* memory.stat
+  (read)
+  show 6 values. (will change in future)
+  cache          .... usage accounted as File-Cache.
+  anon/swapcache .... usage accounted as anonymous memory or swapcache.
+  pgpgin         .... # of page-in under this cgroup.
+  pgpgout        .... # of page-out under this cgroup
+  active         .... amounts of memory which is treated as 'active' 
+  inactive       .... amounts of memory which is treated as 'inactive'
+  (write)
+  not allowed 
+
+* memory.failcnt
+  (read)
+  The number of blocked memory allocation.
+  Until the usage reaches the limit, memory allocation is not blocked.
+  When it reaches, memory allocation is blocked and try to reclaim memory
+  from LRU.
+
+  (write)
+  Reset to 0.
+

