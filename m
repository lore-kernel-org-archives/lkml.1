Return-Path: <linux-kernel-owner+w=401wt.eu-S1754327AbYJQKWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbYJQKWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 06:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbYJQKV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 06:21:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60506 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbYJQKV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 06:21:56 -0400
Message-ID: <48F8664A.2000205@cn.fujitsu.com>
Date: Fri, 17 Oct 2008 18:17:46 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: fix the wrong mask_len
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the NR_CPUS isn't a multiple of 32, we get a truncated string of sched
domains by catting /proc/schedstat. This is caused by the wrong mask_len.

This patch fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

---
 kernel/sched_stats.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 8385d43..81365b3 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -9,7 +9,7 @@
 static int show_schedstat(struct seq_file *seq, void *v)
 {
 	int cpu;
-	int mask_len = NR_CPUS/32 * 9;
+	int mask_len = (NR_CPUS/32 + 1) * 9;
 	char *mask_str = kmalloc(mask_len, GFP_KERNEL);
 
 	if (mask_str == NULL)
-- 
1.5.4.rc3

