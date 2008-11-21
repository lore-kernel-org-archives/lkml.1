Return-Path: <linux-kernel-owner+w=401wt.eu-S1756384AbYKUD7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbYKUD7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 22:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbYKUD66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 22:58:58 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57293 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbYKUD65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 22:58:57 -0500
Message-ID: <492631F7.8000502@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 11:58:47 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cgroups: documentation updates
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove 'releasable' since it has been moved to the debug subsys.
- update lock requirements of subsys callbacks.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 Documentation/cgroups/cgroups.txt |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index d9014aa..60287e9 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -227,7 +227,6 @@ Each cgroup is represented by a directory in the cgroup file system
 containing the following files describing that cgroup:
 
  - tasks: list of tasks (by pid) attached to that cgroup
- - releasable flag: cgroup currently removeable?
  - notify_on_release flag: run the release agent on exit?
  - release_agent: the path to use for release notifications (this file
    exists in the top cgroup only)
@@ -360,7 +359,7 @@ Now you want to do something with this cgroup.
 
 In this directory you can find several files:
 # ls
-notify_on_release releasable tasks
+notify_on_release tasks
 (plus whatever files added by the attached subsystems)
 
 Now attach your shell to this cgroup:
@@ -479,7 +478,6 @@ newly-created cgroup if an error occurs after this subsystem's
 create() method has been called for the new cgroup).
 
 void pre_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp);
-(cgroup_mutex held by caller)
 
 Called before checking the reference count on each subsystem. This may
 be useful for subsystems which have some extra references even if
@@ -498,6 +496,7 @@ remain valid while the caller holds cgroup_mutex.
 
 void attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
 	    struct cgroup *old_cgrp, struct task_struct *task)
+(cgroup_mutex held by caller)
 
 Called after the task has been attached to the cgroup, to allow any
 post-attachment activity that requires memory allocations or blocking.
@@ -511,6 +510,7 @@ void exit(struct cgroup_subsys *ss, struct task_struct *task)
 Called during task exit.
 
 int populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
+(cgroup_mutex held by caller)
 
 Called after creation of a cgroup to allow a subsystem to populate
 the cgroup directory with file entries.  The subsystem should make
@@ -520,6 +520,7 @@ method can return an error code, the error code is currently not
 always handled well.
 
 void post_clone(struct cgroup_subsys *ss, struct cgroup *cgrp)
+(cgroup_mutex held by caller)
 
 Called at the end of cgroup_clone() to do any paramater
 initialization which might be required before a task could attach.  For
-- 
1.5.4.rc3
