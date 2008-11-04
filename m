Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbYKDIXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbYKDIXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 03:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbYKDIXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 03:23:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51086 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753522AbYKDIXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 03:23:12 -0500
Message-ID: <491005C7.2080608@cn.fujitsu.com>
Date: Tue, 04 Nov 2008 16:20:23 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] sched: add sanity check in partition_sched_domains()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's wrong to make dattr_new = NULL if doms_new == NULL, it introduces
memory leak if dattr_new != NULL. Fortunately dattr_new is always NULL
in this case. So remove the code and add a sanity check.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index baa7e4b..0dcda75 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7787,7 +7787,7 @@ match1:
 		ndoms_cur = 0;
 		doms_new = &fallback_doms;
 		cpus_andnot(doms_new[0], cpu_online_map, cpu_isolated_map);
-		dattr_new = NULL;
+		BUG_ON(dattr_new);
 	}
 
 	/* Build new domains */
-- 
1.5.4.rc3
