Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbYGARc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbYGARc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 13:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbYGARcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 13:32:52 -0400
Received: from relay1.sgi.com ([192.48.171.29]:34102 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751207AbYGARcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 13:32:51 -0400
Message-ID: <486A6A42.5050606@sgi.com>
Date: Tue, 01 Jul 2008 10:32:50 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] sched: Reduce stack size in isolated_cpu_setup()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sched: Reduce stack size in isolated_cpu_setup()

  * Remove 16k stack requirements in isolated_cpu_setup when NR_CPUS=4096.

(Somehow this patch was misplaced from some months back.)

Based on linux-2.6.tip/master

Signed-off-by: Mike Travis <travis@sgi.com>
---
 kernel/sched.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.tip.orig/kernel/sched.c
+++ linux-2.6.tip/kernel/sched.c
@@ -6739,7 +6739,8 @@ static cpumask_t cpu_isolated_map = CPU_
 /* Setup the mask of cpus configured for isolated domains */
 static int __init isolated_cpu_setup(char *str)
 {
-	int ints[NR_CPUS], i;
+	static int __initdata ints[NR_CPUS];
+	int i;
 
 	str = get_options(str, ARRAY_SIZE(ints), ints);
 	cpus_clear(cpu_isolated_map);
