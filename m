Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbZCLBro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbZCLBro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 21:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbZCLBrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 21:47:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61683 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbZCLBrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 21:47:32 -0400
Message-ID: <49B869B7.1090108@cn.fujitsu.com>
Date: Thu, 12 Mar 2009 09:47:35 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] debug cgroup: remove unneeded cgroup_lock
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we are in cgroup write handler, so the cgrp is valid, so we
don't have to hold cgroup_mutex when calling cgroup_task_count().
One similar example is in cgroup_tasks_open().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup_debug.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup_debug.c b/kernel/cgroup_debug.c
index daca620..0c92d79 100644
--- a/kernel/cgroup_debug.c
+++ b/kernel/cgroup_debug.c
@@ -40,9 +40,7 @@ static u64 taskcount_read(struct cgroup *cont, struct cftype *cft)
 {
 	u64 count;
 
-	cgroup_lock();
 	count = cgroup_task_count(cont);
-	cgroup_unlock();
 	return count;
 }
 
-- 
1.5.4.rc3

