Return-Path: <linux-kernel-owner+w=401wt.eu-S932840AbZHZBjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840AbZHZBjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 21:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932780AbZHZBjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 21:39:07 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:53554 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932564AbZHZBjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 21:39:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=FtQZMFfcAPoIeGLVNI2zkju7mXENdlEHjYl6zOeETb1yOkA4iYTkvYRNm0kUThq6fo
         oO7x0eGc+X68/9iZciOrij/wwMe+oByuSOYIXuDp+F1QangpRTB+7buI4nkSKDvhSxAj
         ekhHeQkY5bBREf5dgQEAx5Dusd+/7msb9Twkk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Arch <linux-arch@vger.kernel.org>,
       Jason Baron <jbaron@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Paul Mundt <lethal@linux-sh.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] tracing/syscall for 2.6.32
Date: Wed, 26 Aug 2009 03:38:58 +0200
Message-Id: <1251250742-6458-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Please pull the latest syscall tracing patches from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git \
	tracing/core

The tree gathers fixes, renamings and adds a new pair of tracepoints
for generic sysenter/sysexit tracing.

Some other patches are pending, beeing discussed. So there are probably
more to come soon.

Josh Stone (4):
      tracing: Rename FTRACE_SYSCALLS for tracepoints
      tracing: Make syscall tracepoints conditional
      tracing: Move tracepoint callbacks from declaration to definition
      tracing: Create generic syscall TRACE_EVENTs

 arch/s390/Kconfig                   |    2 +-
 arch/s390/defconfig                 |    2 +-
 arch/s390/include/asm/thread_info.h |    4 +-
 arch/s390/kernel/entry.S            |    2 +-
 arch/s390/kernel/entry64.S          |    2 +-
 arch/s390/kernel/ptrace.c           |   12 +++---
 arch/x86/Kconfig                    |    2 +-
 arch/x86/configs/i386_defconfig     |    2 +-
 arch/x86/configs/x86_64_defconfig   |    2 +-
 arch/x86/include/asm/thread_info.h  |   13 +++---
 arch/x86/kernel/ptrace.c            |   16 +++----
 include/linux/tracepoint.h          |   46 +++++++++--------------
 include/trace/define_trace.h        |    5 ++
 include/trace/events/syscalls.h     |   70 +++++++++++++++++++++++++++++++++++
 include/trace/ftrace.h              |    9 ++++
 include/trace/syscall.h             |   17 --------
 kernel/trace/Kconfig                |    4 +-
 kernel/trace/trace_syscalls.c       |   17 ++++----
 kernel/tracepoint.c                 |   20 ++++++----
 19 files changed, 154 insertions(+), 93 deletions(-)
 create mode 100644 include/trace/events/syscalls.h
