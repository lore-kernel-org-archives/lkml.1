Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbYB0Hik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbYB0Hik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 02:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbYB0Hic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 02:38:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58082 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbYB0Hib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 02:38:31 -0500
Message-ID: <47C5131A.80508@cn.fujitsu.com>
Date: Wed, 27 Feb 2008 15:36:58 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Jackson <pj@sgi.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpuset: fix return value of cpuset_populate()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- no need to check err == 0
- the last return value of cgroup_add_file() is ignored

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cpuset.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 3e296ed..1c5b2d2 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1482,10 +1482,10 @@ static int cpuset_populate(struct cgroup_subsys *ss, struct cgroup *cont)
 	if ((err = cgroup_add_file(cont, ss, &cft_spread_slab)) < 0)
 		return err;
 	/* memory_pressure_enabled is in root cpuset only */
-	if (err == 0 && !cont->parent)
+	if (!cont->parent)
 		err = cgroup_add_file(cont, ss,
 					 &cft_memory_pressure_enabled);
-	return 0;
+	return err;
 }
 
 /*
-- 
1.5.4.rc3

