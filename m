Return-Path: <linux-kernel-owner+w=401wt.eu-S1750966AbZHREBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750966AbZHREBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 00:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbZHREBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 00:01:51 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:39270 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbZHREBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 00:01:50 -0400
Message-ID: <4A8A277D.4090304@ct.jp.nec.com>
Date: Tue, 18 Aug 2009 13:01:01 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] sched: use for_each_class macro in move_one_task()
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Replace for loop with the macro for_each_class to cleanup.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 kernel/sched.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 5184580..d559fa7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3461,9 +3461,10 @@ static int move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
 {
 	const struct sched_class *class;
 
-	for (class = sched_class_highest; class; class = class->next)
+	for_each_class(class) {
 		if (class->move_one_task(this_rq, this_cpu, busiest, sd, idle))
 			return 1;
+	}
 
 	return 0;
 }
-- 
1.6.3.3

