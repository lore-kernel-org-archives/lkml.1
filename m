Return-Path: <linux-kernel-owner+w=401wt.eu-S1755661AbZFWSbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbZFWSbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 14:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbZFWSbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 14:31:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39322 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755502AbZFWSbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 14:31:24 -0400
Date: Tue, 23 Jun 2009 14:28:57 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com, lizf@cn.fujitsu.com
Message-Id: <d389a88671a791f328c98e79f2110e8af32fd698.1245770664.git.jbaron@redhat.com>
In-Reply-To: <cover.1245770664.git.jbaron@redhat.com>
References: <cover.1245770664.git.jbaron@redhat.com>
Subject: [PATCH 1/7] V2 add syscall tracepoints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Add a new function to support translating a syscall name to number at runtime.
This allows the syscall event tracer to map syscall names to number.


Signed-off-by: Jason Baron <jbaron@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


---
 arch/x86/kernel/ftrace.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index b79c553..b2374db 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -502,6 +502,22 @@ struct syscall_metadata *syscall_nr_to_meta(int nr)
 	return syscalls_metadata[nr];
 }
 
+int syscall_name_to_nr(char *name)
+{
+	int i;
+
+	if (!syscalls_metadata)
+		return -1;
+
+	for (i = 0; i < FTRACE_SYSCALL_MAX; i++) {
+		if (syscalls_metadata[i]) {
+			if (!strcmp(syscalls_metadata[i]->name, name))
+				return i;
+		}
+	}
+	return -1;
+}
+
 void arch_init_ftrace_syscalls(void)
 {
 	int i;
-- 
1.6.0.6

