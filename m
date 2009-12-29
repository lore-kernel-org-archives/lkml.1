Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbZL2Q2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbZL2Q2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 11:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbZL2Q0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 11:26:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34838 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbZL2Q0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 11:26:39 -0500
X-Authority-Analysis: v=1.0 c=1 a=qqbXX_9Q-7kA:10 a=omOdbC7AAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=vIPEqx8Bn1x_7rCb6okA:9 a=lTvzNt8qlIObHh54_W6FWjE5MsYA:4 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20091229162637.106663301@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 29 Dec 2009 11:22:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 02/10] tracing/syscalls: Fix typo in SYSCALL_DEFINE0
References: <20091229162231.441352392@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-syscalls-Fix-typo-in-SYSCALL_DEFINE0.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

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
-- 
1.6.5


