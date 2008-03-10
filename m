Return-Path: <linux-kernel-owner+w=401wt.eu-S1752065AbYCJHba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbYCJHba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 03:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbYCJHbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 03:31:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49020 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbYCJHbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 03:31:22 -0400
Message-ID: <47D4E3AC.2020600@cn.fujitsu.com>
Date: Mon, 10 Mar 2008 16:30:52 +0900
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] cgroup: switch to proc_create()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race between create_proc_entry() and the assignment
of file ops. proc_create() is invented to fix it.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 8d833b6..8d45126 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2489,7 +2489,6 @@ int __init cgroup_init(void)
 {
 	int err;
 	int i;
-	struct proc_dir_entry *entry;
 
 	err = bdi_init(&cgroup_backing_dev_info);
 	if (err)
@@ -2505,9 +2504,7 @@ int __init cgroup_init(void)
 	if (err < 0)
 		goto out;
 
-	entry = create_proc_entry("cgroups", 0, NULL);
-	if (entry)
-		entry->proc_fops = &proc_cgroupstats_operations;
+	proc_create("cgroups", 0, NULL, &proc_cgroupstats_operations);
 
 out:
 	if (err)
-- 
1.5.4.rc3
