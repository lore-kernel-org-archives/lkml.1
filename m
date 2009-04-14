Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbZDNAN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbZDNAN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 20:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbZDNANp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 20:13:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:42101 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbZDNANo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 20:13:44 -0400
Date: Tue, 14 Apr 2009 00:13:04 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, srostedt@redhat.com, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, srostedt@redhat.com, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <49D458B1.5000703@cn.fujitsu.com>
References: <49D458B1.5000703@cn.fujitsu.com>
Subject: [tip:sched/urgent] tracing, sched: mark get_parent_ip() notrace
Message-ID: <tip-132380a06b24704fd6c9be55c44d4ef3972cead2@git.kernel.org>
Git-Commit-ID: 132380a06b24704fd6c9be55c44d4ef3972cead2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 00:13:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  132380a06b24704fd6c9be55c44d4ef3972cead2
Gitweb:     http://git.kernel.org/tip/132380a06b24704fd6c9be55c44d4ef3972cead2
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Thu, 2 Apr 2009 14:18:25 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 14 Apr 2009 02:11:05 +0200

tracing, sched: mark get_parent_ip() notrace

Impact: remove overly redundant tracing entries

When tracer is "function" or "function_graph", way too much
"get_parent_ip" entries are recorded in ring_buffer.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Steven Rostedt <srostedt@redhat.com>
LKML-Reference: <49D458B1.5000703@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 5724508..e90e70e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4846,7 +4846,7 @@ void scheduler_tick(void)
 #endif
 }
 
-unsigned long get_parent_ip(unsigned long addr)
+notrace unsigned long get_parent_ip(unsigned long addr)
 {
 	if (in_lock_functions(addr)) {
 		addr = CALLER_ADDR2;
