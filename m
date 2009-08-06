Return-Path: <linux-kernel-owner+w=401wt.eu-S1754383AbZHFG1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbZHFG1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 02:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbZHFG1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 02:27:53 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:53224 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbZHFG1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 02:27:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QqwdS+bi7TbK+v8QmM5/2dzBF1AeH6HB1O4MtrPpjx0PQJnMfF/h1ykMIHDNdpt+rH
         qi6E6R+b/hBzavKsCJIeRBFrh2kdv74qddww3GRuojVLjnv0oGKYu5eJvrnoT6jHcVcn
         gYIMuHxW2e2TkHuAC/Mk8uTB9blJfMMaWPuy0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3/7] tracing/core: Turn ftrace_cpu_disabled into a global var
Date: Thu,  6 Aug 2009 08:27:34 +0200
Message-Id: <1249540058-5528-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090802195312.GA18598@elte.hu>
References: <20090802195312.GA18598@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to prepare the moving of the function graph tracer insertion
helpers from trace.c to trace_functions_graph.c, we need to export the
ftrace_cpu_disabled variable.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    2 +-
 kernel/trace/trace.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 38a4a3e..b6211d6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -89,7 +89,7 @@ static int dummy_set_flag(u32 old_flags, u32 bit, int set)
  */
 static int tracing_disabled = 1;
 
-static DEFINE_PER_CPU(local_t, ftrace_cpu_disabled);
+DEFINE_PER_CPU(local_t, ftrace_cpu_disabled);
 
 static inline void ftrace_disable_cpu(void)
 {
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 758b0db..c7e9273 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -519,6 +519,7 @@ extern int DYN_FTRACE_TEST_NAME(void);
 
 extern int ring_buffer_expanded;
 extern bool tracing_selftest_disabled;
+DECLARE_PER_CPU(local_t, ftrace_cpu_disabled);
 
 #ifdef CONFIG_FTRACE_STARTUP_TEST
 extern int trace_selftest_startup_function(struct tracer *trace,
-- 
1.6.2.3

