Return-Path: <linux-kernel-owner+w=401wt.eu-S1751617AbZH0Rnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617AbZH0Rnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbZH0Rnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:43:39 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:51769 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbZH0Rnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:43:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Mhpo4pu73HruTTms1FmOwQxr0HstfxsfGRnhN5ffoFYmWvqBMbQ65rMJyIt+pFbl8z
         6D0Ls6IC4EfcGwM4hG+aO4nSSvDi6hLyhOsypKHi3mAxFECS3gubBxD8ht84QRJ0CzyZ
         oKObbZrLNGDDJqWdNpu+NtkRdhbthTxNnuZjE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Subject: [GIT PULL] tracing/syscalls: The next bunch
Date: Thu, 27 Aug 2009 19:43:28 +0200
Message-Id: <1251395015-6329-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Here is another bunch of syscalls tracing patches.

- fixes against unwanted kernel threads syscalls tracing
  (it's not that we don't want to trace them, but they would
   need a specific treatement)

- synchronize s390 with latest changes

- use NR_syscalls which seems to be a better standard to define
  the number of syscalls across archs. This unification also have
  brought enough common code in arch that we are now ready to
  move most of the arch syscalls tracing bits to the core.

Thanks,

Frederic.


The following changes since commit 35dce1a99d010f3d738af4ce1b9b77302fdfe69c:
  Ingo Molnar (1):
        Merge branch 'tracing/core' of git://git.kernel.org/.../frederic/random-tracing into tracing/core

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/core

Hendrik Brueckner (3):
      tracing: Add syscall tracepoints - s390 arch update
      tracing: Check invalid syscall nr while tracing syscalls
      tracing: Don't trace kernel thread syscalls

Jason Baron (4):
      tracing: Define NR_syscalls for x86 (32)
      tracing: Define NR_syscalls for x86_64
      tracing: Convert event tracing code to use NR_syscalls
      tracing: Remove FTRACE_SYSCALL_MAX definitions

 arch/s390/kernel/ftrace.c        |   36 +++++++++++++++++++++++++++---------
 arch/x86/include/asm/ftrace.h    |    7 -------
 arch/x86/include/asm/unistd_32.h |    2 ++
 arch/x86/include/asm/unistd_64.h |    6 ++++++
 arch/x86/kernel/asm-offsets_64.c |    1 +
 arch/x86/kernel/ftrace.c         |    8 ++++----
 kernel/trace/trace_syscalls.c    |   28 ++++++++++++++++------------
 kernel/tracepoint.c              |    4 +++-
 8 files changed, 59 insertions(+), 33 deletions(-)
