Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbYKGGuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbYKGGuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 01:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbYKGGuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 01:50:06 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59820 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbYKGGuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 01:50:05 -0500
Message-ID: <4913E479.8050505@cn.fujitsu.com>
Date: Fri, 07 Nov 2008 14:47:21 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: fix memory leak in a failing path
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the failing path, rd is not attached to a sched domain,
so it causes a leak.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/sched.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e8819bc..24a70d5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7672,6 +7672,7 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 error:
 	free_sched_groups(cpu_map, tmpmask);
 	SCHED_CPUMASK_FREE((void *)allmasks);
+	kfree(rd);
 	return -ENOMEM;
 #endif
 }
-- 
1.5.4.rc3

