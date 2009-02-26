Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbZBZHkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbZBZHkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 02:40:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbZBZHkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 02:40:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50006 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbZBZHkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 02:40:06 -0500
Message-ID: <49A6475F.4000502@cn.fujitsu.com>
Date: Thu, 26 Feb 2009 15:40:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpuacct: add a branch prediction
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuacct_charge() is in fast-path, and checking of !cpuacct_susys.active
always returns false after cpuacct has been initialized at system boot.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 410eec4..fd2f7fc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9589,7 +9589,7 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 	struct cpuacct *ca;
 	int cpu;
 
-	if (!cpuacct_subsys.active)
+	if (unlikely(!cpuacct_subsys.active))
 		return;
 
 	cpu = task_cpu(tsk);
-- 
1.5.4.rc3

