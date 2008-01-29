Return-Path: <linux-kernel-owner+w=401wt.eu-S1764072AbYA2Ntm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764072AbYA2Ntm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 08:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932676AbYA2Nt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 08:49:28 -0500
Received: from relay1.sgi.com ([192.48.171.29]:55053 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932540AbYA2N3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:29:23 -0500
Date: Tue, 29 Jan 2008 07:29:22 -0600
To: linux-kernel@vger.kernel.org
Cc: pj@sgi.com, menage@google.com, akpm@osdl.org
Subject: [PATCH 3/4] cpusets: update_cpumask documentation fix
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080129132922.63C9733B943@attica.americas.sgi.com>
From: cpw@sgi.com (Cliff Wickman)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Update cpuset documentation to match the October 2007
"Fix cpusets update_cpumask" changes that now apply
changes to a cpusets 'cpus' allowed mask immediately
to the cpus_allowed of the tasks in that cpuset.

Signed-off-by: Paul Jackson <pj@sgi.com>
Acked-by: Cliff Wickman <cpw@sgi.com>

---

 Documentation/cpusets.txt |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

Index: linux-2.6/Documentation/cpusets.txt
===================================================================
--- linux-2.6.orig/Documentation/cpusets.txt
+++ linux-2.6/Documentation/cpusets.txt
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
