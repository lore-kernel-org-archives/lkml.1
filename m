Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbZHJUwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbZHJUwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 16:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbZHJUwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 16:52:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45355 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbZHJUwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 16:52:41 -0400
Date: Mon, 10 Aug 2009 16:52:13 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com
Message-Id: <669b9962677c0f5096684b54216b32175721fe57.1249932670.git.jbaron@redhat.com>
In-Reply-To: <cover.1249932670.git.jbaron@redhat.com>
References: <cover.1249932670.git.jbaron@redhat.com>
Subject: [PATCH 01/12] map syscall name to number
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new function to support translating a syscall name to number at runtime.
This allows the syscall event tracer to map syscall names to number.

Signed-off-by: Jason Baron <jbaron@redhat.com>

---
 arch/x86/kernel/ftrace.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 8e96634..afb31d7 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -500,6 +500,22 @@ struct syscall_metadata *syscall_nr_to_meta(int nr)
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
1.6.2.5

