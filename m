Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbZL3ShX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbZL3ShX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 13:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbZL3ShU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 13:37:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:35623 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbZL3ShR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 13:37:17 -0500
Date: Wed, 30 Dec 2009 18:36:47 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com
In-Reply-To: <4B273D2E.1010807@cn.fujitsu.com>
References: <4B273D2E.1010807@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing/syscalls: Fix typo in SYSCALL_DEFINE0
Message-ID: <tip-e96dc9674cb597de4fee757ed005c8465072d13f@git.kernel.org>
Git-Commit-ID: e96dc9674cb597de4fee757ed005c8465072d13f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e96dc9674cb597de4fee757ed005c8465072d13f
Gitweb:     http://git.kernel.org/tip/e96dc9674cb597de4fee757ed005c8465072d13f
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Tue, 15 Dec 2009 15:39:26 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 30 Dec 2009 10:27:04 -0500

tracing/syscalls: Fix typo in SYSCALL_DEFINE0

The struct syscall_metadata variable name in SYSCALL_DEFINE0
should be __syscall_meta__##sname instead of __syscall_meta_##sname
to match the name that is in SYSCALL_DEFINE1/2/3/4/5/6.

This error causes event_enter_##sname->data to point to the wrong
location, which causes syscalls which are defined by SYSCALL_DEFINE0()
not to be traced.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4B273D2E.1010807@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/syscalls.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 65793e9..207466a 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -195,7 +195,7 @@ struct perf_event_attr;
 	static const struct syscall_metadata __used		\
 	  __attribute__((__aligned__(4)))			\
 	  __attribute__((section("__syscalls_metadata")))	\
-	  __syscall_meta_##sname = {				\
+	  __syscall_meta__##sname = {				\
 		.name 		= "sys_"#sname,			\
 		.nb_args 	= 0,				\
 		.enter_event	= &event_enter__##sname,	\
