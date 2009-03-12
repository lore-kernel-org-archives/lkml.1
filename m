Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbZCLBXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbZCLBXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 21:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZCLBXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 21:23:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55338 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbZCLBXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 21:23:00 -0400
Message-ID: <49B863F5.2060400@cn.fujitsu.com>
Date: Thu, 12 Mar 2009 09:23:01 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] cpuacct: reduce one NULL check in fast-path
References: <49B71EB5.1030608@cn.fujitsu.com> <20090311094744.GB13543@elte.hu>
In-Reply-To: <20090311094744.GB13543@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In cpuacct_charge(), task_ca() will never return NULL, so change
for(...) to do{}while(...) to save one NULL check.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

rebased on tip tree

---
 kernel/sched.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d40964b..c167f38 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9867,10 +9867,11 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 	cpu = task_cpu(tsk);
 	ca = task_ca(tsk);
 
-	for (; ca; ca = ca->parent) {
+	do {
 		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
 		*cpuusage += cputime;
-	}
+		ca = ca->parent;
+	} while (ca);
 }
 
 struct cgroup_subsys cpuacct_subsys = {
-- 
1.5.4.rc3


