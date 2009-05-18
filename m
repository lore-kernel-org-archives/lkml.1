Return-Path: <linux-kernel-owner+w=401wt.eu-S1751822AbZERJH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbZERJH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbZERJHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:07:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:59130 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbZERJHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:07:10 -0400
Date: Mon, 18 May 2009 09:06:34 GMT
From: tip-bot for Ming Lei <tom.leiming@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, tglx@linutronix.de,
       tom.leiming@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, tglx@linutronix.de,
       tom.leiming@gmail.com, mingo@elte.hu
In-Reply-To: <1242545498-7285-1-git-send-email-tom.leiming@gmail.com>
References: <1242545498-7285-1-git-send-email-tom.leiming@gmail.com>
Subject: [tip:tracing/core] tracing: fix check for return value of register_module_notifier
Message-ID: <tip-24ed0c4bfc7d2d7507bb9d50f7f3bbdcd85d76dd@git.kernel.org>
Git-Commit-ID: 24ed0c4bfc7d2d7507bb9d50f7f3bbdcd85d76dd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 18 May 2009 09:06:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  24ed0c4bfc7d2d7507bb9d50f7f3bbdcd85d76dd
Gitweb:     http://git.kernel.org/tip/24ed0c4bfc7d2d7507bb9d50f7f3bbdcd85d76dd
Author:     Ming Lei <tom.leiming@gmail.com>
AuthorDate: Sun, 17 May 2009 15:31:38 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 May 2009 10:24:13 +0200

tracing: fix check for return value of register_module_notifier

return zero should be correct, so fix it.

[ Impact: eliminate incorrect syslog message ]

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: rostedt@goodmis.org
LKML-Reference: <1242545498-7285-1-git-send-email-tom.leiming@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/ftrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5b606f4..140699a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2826,7 +2826,7 @@ void __init ftrace_init(void)
 				  __stop_mcount_loc);
 
 	ret = register_module_notifier(&ftrace_module_nb);
-	if (!ret)
+	if (ret)
 		pr_warning("Failed to register trace ftrace module notifier\n");
 
 	return;
