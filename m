Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbZHGKKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbZHGKKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 06:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755917AbZHGKKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 06:10:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:58439 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755668AbZHGKKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 06:10:42 -0400
Date: Fri, 7 Aug 2009 10:09:52 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4A7BE7B6.10904@cn.fujitsu.com>
References: <4A7BE7B6.10904@cn.fujitsu.com>
Subject: [tip:core/urgent] lockdep: Fix file mode of lock_stat
Message-ID: <tip-9795447f71324d8f14c19ed68b43c883135c3f59@git.kernel.org>
Git-Commit-ID: 9795447f71324d8f14c19ed68b43c883135c3f59
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 07 Aug 2009 10:09:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9795447f71324d8f14c19ed68b43c883135c3f59
Gitweb:     http://git.kernel.org/tip/9795447f71324d8f14c19ed68b43c883135c3f59
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 7 Aug 2009 16:37:10 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 Aug 2009 11:58:38 +0200

lockdep: Fix file mode of lock_stat

/proc/lock_stat is writable.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <4A7BE7B6.10904@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/lockdep_proc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index d7135aa..e94caa6 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -758,7 +758,8 @@ static int __init lockdep_proc_init(void)
 		    &proc_lockdep_stats_operations);
 
 #ifdef CONFIG_LOCK_STAT
-	proc_create("lock_stat", S_IRUSR, NULL, &proc_lock_stat_operations);
+	proc_create("lock_stat", S_IRUSR | S_IWUSR, NULL,
+		    &proc_lock_stat_operations);
 #endif
 
 	return 0;
