Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbYJ0XDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbYJ0XDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 19:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbYJ0XDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 19:03:16 -0400
Received: from mga14.intel.com ([143.182.124.37]:37052 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbYJ0XDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 19:03:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,495,1220252400"; 
   d="scan'208";a="66021712"
Date: Mon, 27 Oct 2008 16:03:13 -0700
Message-Id: <200810272303.m9RN3Dw8032499@agluck-lia64.sc.intel.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cgroup: remove unused variable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

/scratch/sfr/next/kernel/cgroup.c: In function 'cgroup_tasks_start':
/scratch/sfr/next/kernel/cgroup.c:2107: warning: unused variable 'i'

Introduced in commit cc31edceee04a7b87f2be48f9489ebb72d264844 "cgroups:
convert tasks file to use a seq_file with shared pid array".

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Henrik Austad <henrik@austad.us>
Signed-off-by: Tony Luck <tony.luck@intel.com>

---

Linus,  I guess you don't build with CONFIG_CGROUPS=y or you'd
have fixed this, or taken one of the patches that fix it. I'm
tired of seeing the warning in my build log :-)

 kernel/cgroup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 046c160..35eebd5 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2104,7 +2104,7 @@ static void *cgroup_tasks_start(struct seq_file *s, loff_t *pos)
 	down_read(&cgrp->pids_mutex);
 	if (pid) {
 		int end = cgrp->pids_length;
-		int i;
+
 		while (index < end) {
 			int mid = (index + end) / 2;
 			if (cgrp->tasks_pids[mid] == pid) {
-- 
1.5.6.5
