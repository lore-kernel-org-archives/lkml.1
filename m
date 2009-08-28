Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875AbZH1M3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbZH1M3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 08:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbZH1M3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 08:29:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:55473 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbZH1M3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 08:29:00 -0400
Date: Fri, 28 Aug 2009 12:28:18 GMT
From: tip-bot for Jason Baron <jbaron@redhat.com>
Cc: brueckner@linux.vnet.ibm.com, mathieu.desnoyers@polymtl.ca,
       mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, heiko.carstens@de.ibm.com, tglx@linutronix.de,
       jbaron@redhat.com, laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, jiayingz@google.com, lizf@cn.fujitsu.com,
       lethal@linux-sh.org, jistone@redhat.com, mingo@elte.hu,
       mbligh@google.com
Reply-To: mingo@redhat.com, mathieu.desnoyers@polymtl.ca,
       brueckner@linux.vnet.ibm.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, heiko.carstens@de.ibm.com, tglx@linutronix.de,
       jbaron@redhat.com, laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, jiayingz@google.com, lizf@cn.fujitsu.com,
       lethal@linux-sh.org, jistone@redhat.com, mingo@elte.hu,
       mbligh@google.com
In-Reply-To: <0f33c0f96d198fccc3ddd9ff7f5334ff5cb42706.1251146513.git.jbaron@redhat.com>
References: <0f33c0f96d198fccc3ddd9ff7f5334ff5cb42706.1251146513.git.jbaron@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Define NR_syscalls for x86 (32)
Message-ID: <tip-dd86dda24cc1dc70031a7d9250dc3c0c430a50e2@git.kernel.org>
Git-Commit-ID: dd86dda24cc1dc70031a7d9250dc3c0c430a50e2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 28 Aug 2009 12:28:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd86dda24cc1dc70031a7d9250dc3c0c430a50e2
Gitweb:     http://git.kernel.org/tip/dd86dda24cc1dc70031a7d9250dc3c0c430a50e2
Author:     Jason Baron <jbaron@redhat.com>
AuthorDate: Mon, 24 Aug 2009 17:40:14 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Wed, 26 Aug 2009 21:29:55 +0200

tracing: Define NR_syscalls for x86 (32)

Add a NR_syscalls #define for x86. This is used in the syscall events
tracing code. Todo: make it dynamic like x86_64.

NR_syscalls is the usual name used to determine the number of syscalls
supported by the current arch. We want to unify the use of this number
across archs that support the syscall tracing. This also prepare to move
some of the arch code to core code in the syscall tracing area.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Josh Stone <jistone@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anwin <hpa@zytor.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
LKML-Reference: <0f33c0f96d198fccc3ddd9ff7f5334ff5cb42706.1251146513.git.jbaron@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>


---
 arch/x86/include/asm/unistd_32.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index 732a307..8deaada 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -345,6 +345,8 @@
 
 #ifdef __KERNEL__
 
+#define NR_syscalls 337
+
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_OLD_STAT
