Return-Path: <linux-kernel-owner+w=401wt.eu-S1759066AbZCMQLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066AbZCMQLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758767AbZCMQKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:10:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:41511 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758643AbZCMQKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:10:51 -0400
Date: Fri, 13 Mar 2009 16:09:52 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <1236401580-5758-3-git-send-email-fweisbec@gmail.com>
References: <1236401580-5758-3-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/syscalls] tracing/syscalls: support for syscalls tracing on x86, fix
Message-ID: <tip-ccd50dfd92ea2c4ba9e39531ac55db53393e783e@git.kernel.org>
Git-Commit-ID: ccd50dfd92ea2c4ba9e39531ac55db53393e783e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 16:10:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ccd50dfd92ea2c4ba9e39531ac55db53393e783e
Gitweb:     http://git.kernel.org/tip/ccd50dfd92ea2c4ba9e39531ac55db53393e783e
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 13 Mar 2009 17:02:17 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 17:02:17 +0100

tracing/syscalls: support for syscalls tracing on x86, fix

Impact: build fix

 kernel/built-in.o: In function `ftrace_syscall_exit':
 (.text+0x76667): undefined reference to `syscall_nr_to_meta'

ftrace.o is built:

obj-$(CONFIG_DYNAMIC_FTRACE)    += ftrace.o
obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += ftrace.o

But now a CONFIG_FTRACE_SYSCALLS dependency is needed too.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <1236401580-5758-3-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 339ce35..84000eb 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -66,7 +66,8 @@ obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
 obj-y				+= apic/
 obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
-obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o
+obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += ftrace.o
+obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
 obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
