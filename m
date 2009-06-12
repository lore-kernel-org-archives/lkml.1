Return-Path: <linux-kernel-owner+w=401wt.eu-S1764908AbZFLV1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764908AbZFLV1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 17:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757210AbZFLV1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 17:27:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42757 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760161AbZFLV1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 17:27:07 -0400
Date: Fri, 12 Jun 2009 17:24:40 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, bligh@google.com, roland@redhat.com,
       fche@redhat.com
Message-Id: <bfe6d2004c9878b127449bb20855001e10fb644d.1244837725.git.jbaron@redhat.com>
In-Reply-To: <cover.1244837725.git.jbaron@redhat.com>
References: <cover.1244837725.git.jbaron@redhat.com>
Subject: [PATCH 1/7] add syscall tracepoints
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
index b79c553..30baa5b 100644
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
+			if (!strcmp((syscalls_metadata[i])->name, name))
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

