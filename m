Return-Path: <linux-kernel-owner+w=401wt.eu-S1752786AbZGCIF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbZGCIF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbZGCIFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:05:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63398 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbZGCIFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:05:41 -0400
Message-ID: <4A4DBBC2.8010805@cn.fujitsu.com>
Date: Fri, 03 Jul 2009 16:05:22 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] cgroup: Fix indent for /proc/cgroups
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, /proc/cgroups outputs is fairly ugly as following,
#subsys_name    hierarchy       num_cgroups     enabled
cpuset  0       1       1
debug   0       1       1
ns      0       1       1

indent it in a good-looking way.
#subsys_name    hierarchy       num_cgroups     enabled
cpuset          0               1               1
debug           0               1               1
ns              0               1               1


Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 kernel/cgroup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3737a68..99fc160 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2963,7 +2963,7 @@ static int proc_cgroupstats_show(struct seq_file *m, void *v)
 	mutex_lock(&cgroup_mutex);
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 		struct cgroup_subsys *ss = subsys[i];
-		seq_printf(m, "%s\t%lu\t%d\t%d\n",
+		seq_printf(m, "%s\t\t%lu\t\t%d\t\t%d\n",
 			   ss->name, ss->root->subsys_bits,
 			   ss->root->number_of_cgroups, !ss->disabled);
 	}
-- 
1.5.4.rc3

