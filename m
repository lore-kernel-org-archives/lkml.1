Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbYFEGEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbYFEGEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 02:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYFEGES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 02:04:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50453 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbYFEGER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 02:04:17 -0400
Message-ID: <48478187.7080204@cn.fujitsu.com>
Date: Thu, 05 Jun 2008 14:02:47 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Paul Menage <menage@google.com>
Subject: [PATCH] cgroup: anotate two variables with __read_mostly
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- need_forkexit_callback will be read only after system boot.
- use_task_css_set_links will be read only after it's set.

And these 2 variables are checked when a new process is forked.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 15ac0e1..f5a1273 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -118,7 +118,7 @@ static int root_count;
  * extra work in the fork/exit path if none of the subsystems need to
  * be called.
  */
-static int need_forkexit_callback;
+static int need_forkexit_callback __read_mostly;
 static int need_mm_owner_callback __read_mostly;
 
 /* convenient tests for these bits */
@@ -220,7 +220,7 @@ static struct hlist_head *css_set_hash(struct cgroup_subsys_state *css[])
  * task until after the first call to cgroup_iter_start(). This
  * reduces the fork()/exit() overhead for people who have cgroups
  * compiled into their kernel but not actually in use */
-static int use_task_css_set_links;
+static int use_task_css_set_links __read_mostly;
 
 /* When we create or destroy a css_set, the operation simply
  * takes/releases a reference count on all the cgroups referenced
-- 
1.5.4.rc3
