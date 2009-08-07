Return-Path: <linux-kernel-owner+w=401wt.eu-S1757136AbZHGIij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbZHGIij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 04:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757057AbZHGIii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 04:38:38 -0400
Received: from [222.73.24.84] ([222.73.24.84]:63861 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754982AbZHGIii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 04:38:38 -0400
Message-ID: <4A7BE7B6.10904@cn.fujitsu.com>
Date: Fri, 07 Aug 2009 16:37:10 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] lockdep: Fix file mode of lock_stat
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/lock_stat is writable.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/lockdep_proc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index fba81f1..98cc796 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -762,7 +762,8 @@ static int __init lockdep_proc_init(void)
 		    &proc_lockdep_stats_operations);
 
 #ifdef CONFIG_LOCK_STAT
-	proc_create("lock_stat", S_IRUSR, NULL, &proc_lock_stat_operations);
+	proc_create("lock_stat", S_IRUSR | S_IWUSR, NULL,
+		    &proc_lock_stat_operations);
 #endif
 
 	return 0;
-- 
1.6.3

