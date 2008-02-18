Return-Path: <linux-kernel-owner+w=401wt.eu-S1758580AbYBRFws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580AbYBRFws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 00:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbYBRFvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 00:51:44 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52193 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbYBRFvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 00:51:16 -0500
Message-ID: <47B91C82.7010407@cn.fujitsu.com>
Date: Mon, 18 Feb 2008 13:49:54 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org
Subject: [PATCH 5/7] cgroup: fix subsys bitops
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cgroup uses unsigned long for subsys bitops, not unsigned long long.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index aa76bbd..e8c8e58 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -320,7 +320,7 @@ static struct css_set *find_existing_css_set(
 	/* Built the set of subsystem state objects that we want to
 	 * see in the new css_set */
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
-		if (root->subsys_bits & (1ull << i)) {
+		if (root->subsys_bits & (1UL << i)) {
 			/* Subsystem is in this hierarchy. So we want
 			 * the subsystem state from the new
 			 * cgroup */
@@ -696,7 +696,7 @@ static int rebind_subsystems(struct cgroupfs_root *root,
 	added_bits = final_bits & ~root->actual_subsys_bits;
 	/* Check that any added subsystems are currently free */
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
-		unsigned long long bit = 1ull << i;
+		unsigned long bit = 1UL << i;
 		struct cgroup_subsys *ss = subsys[i];
 		if (!(bit & added_bits))
 			continue;
-- 
1.5.4.rc3

