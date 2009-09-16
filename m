Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbZIPH1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbZIPH1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 03:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbZIPH1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 03:27:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56792 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbZIPH1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 03:27:41 -0400
Message-ID: <4AB0933E.8020901@cn.fujitsu.com>
Date: Wed, 16 Sep 2009 15:26:54 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] stop_machine: disable preempt in stop machine path
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can disable preempt in stop_cpu(), It can reduce the cpu's waiting time
and make stop_machine path faster.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 kernel/stop_machine.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 912823e..feaa947 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -68,7 +68,7 @@ static void stop_cpu(struct work_struct *unused)
 {
 	enum stopmachine_state curstate = STOPMACHINE_NONE;
 	struct stop_machine_data *smdata = &idle;
-	int cpu = smp_processor_id();
+	int cpu = get_cpu();
 	int err;
 
 	if (!active_cpus) {
@@ -103,6 +103,7 @@ static void stop_cpu(struct work_struct *unused)
 		}
 	} while (curstate != STOPMACHINE_EXIT);
 
+	put_cpu();
 	local_irq_enable();
 }
 
-- 
1.6.1.2

