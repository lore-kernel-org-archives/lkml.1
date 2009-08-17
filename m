Return-Path: <linux-kernel-owner+w=401wt.eu-S1757261AbZHQIC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbZHQIC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757229AbZHQIC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:02:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:34295 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757208AbZHQIC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:02:58 -0400
Date: Mon, 17 Aug 2009 08:01:39 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4A88ED15.20800@cn.fujitsu.com>
References: <4A88ED15.20800@cn.fujitsu.com>
Subject: [tip:core/locking] lockdep: Fix missing entry in /proc/lock_stat
Message-ID: <tip-212274347fc4d2a7c56bf6c953b02c809e7e0be1@git.kernel.org>
Git-Commit-ID: 212274347fc4d2a7c56bf6c953b02c809e7e0be1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 17 Aug 2009 08:01:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  212274347fc4d2a7c56bf6c953b02c809e7e0be1
Gitweb:     http://git.kernel.org/tip/212274347fc4d2a7c56bf6c953b02c809e7e0be1
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 17 Aug 2009 13:39:33 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 17 Aug 2009 09:54:39 +0200

lockdep: Fix missing entry in /proc/lock_stat

One entry is missing in the output of /proc/lock_stat.

The cause is, when ls_start() is called the 2nd time, we should
start from stats[@pos-1] but not stats[@pos], because pos == 0
is the header.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <4A88ED15.20800@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/lockdep_proc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index fba81f1..5dbe30b 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -634,7 +634,7 @@ static void *ls_start(struct seq_file *m, loff_t *pos)
 	if (*pos == 0)
 		return SEQ_START_TOKEN;
 
-	data->iter = data->stats + *pos;
+	data->iter = data->stats + (*pos - 1);
 	if (data->iter >= data->iter_end)
 		data->iter = NULL;
 
