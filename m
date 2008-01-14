Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbYANGmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbYANGmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 01:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbYANGly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 01:41:54 -0500
Received: from relay1.sgi.com ([192.48.171.29]:41584 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754939AbYANGlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 01:41:51 -0500
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Paul Menage <menage@google.com>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 13 Jan 2008 22:41:50 -0800
Message-Id: <20080114064150.2782.40271.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH 3/3] cpusets: update_cpumask documentation fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Update cpuset documentation to match the October 2007
"Fix cpusets update_cpumask" changes that now apply
changes to a cpusets 'cpus' allowed mask immediately
to the cpus_allowed of the tasks in that cpuset.

Signed-off-by: Paul Jackson <pj@sgi.com>
Cc: Paul Menage <menage@google.com>

---

 Documentation/cpusets.txt |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

--- 2.6.24-rc6-mm1.orig/Documentation/cpusets.txt	2008-01-12 18:52:43.312404390 -0800
+++ 2.6.24-rc6-mm1/Documentation/cpusets.txt	2008-01-12 23:02:38.166224878 -0800
@@ -523,21 +523,14 @@ from one cpuset to another, then the ker
 memory placement, as above, the next time that the kernel attempts
 to allocate a page of memory for that task.
 
-If a cpuset has its CPUs modified, then each task using that
-cpuset does _not_ change its behavior automatically.  In order to
-minimize the impact on the critical scheduling code in the kernel,
-tasks will continue to use their prior CPU placement until they
-are rebound to their cpuset, by rewriting their pid to the 'tasks'
-file of their cpuset.  If a task had been bound to some subset of its
-cpuset using the sched_setaffinity() call, and if any of that subset
-is still allowed in its new cpuset settings, then the task will be
-restricted to the intersection of the CPUs it was allowed on before,
-and its new cpuset CPU placement.  If, on the other hand, there is
-no overlap between a tasks prior placement and its new cpuset CPU
-placement, then the task will be allowed to run on any CPU allowed
-in its new cpuset.  If a task is moved from one cpuset to another,
-its CPU placement is updated in the same way as if the tasks pid is
-rewritten to the 'tasks' file of its current cpuset.
+If a cpuset has its 'cpus' modified, then each task in that cpuset
+will have its allowed CPU placement changed immediately.  Similarly,
+if a tasks pid is written to a cpusets 'tasks' file, in either its
+current cpuset or another cpuset, then its allowed CPU placement is
+changed immediately.  If such a task had been bound to some subset
+of its cpuset using the sched_setaffinity() call, the task will be
+allowed to run on any CPU allowed in its new cpuset, negating the
+affect of the prior sched_setaffinity() call.
 
 In summary, the memory placement of a task whose cpuset is changed is
 updated by the kernel, on the next allocation of a page for that task,

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
