Return-Path: <linux-kernel-owner+w=401wt.eu-S1765454AbYCGBjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765454AbYCGBjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 20:39:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759270AbYCGBi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 20:38:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55793 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758184AbYCGBiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 20:38:55 -0500
Message-ID: <47D09BCA.9050504@cn.fujitsu.com>
Date: Fri, 07 Mar 2008 09:35:06 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] sched: fix the wrong time slice value for SCHED_FIFO tasks
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function sys_sched_rr_get_interval returns wrong time slice value for
SCHED_FIFO tasks. The time slice for SCHED_FIFO tasks should be 0.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index dcd553c..870044d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5100,7 +5100,7 @@ long sys_sched_rr_get_interval(pid_t pid, struct timespec __user *interval)
 	time_slice = 0;
 	if (p->policy == SCHED_RR) {
 		time_slice = DEF_TIMESLICE;
-	} else {
+	} else if (p->policy != SCHED_FIFO) {
 		struct sched_entity *se = &p->se;
 		unsigned long flags;
 		struct rq *rq;
-- 
1.5.4.rc3


