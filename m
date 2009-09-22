Return-Path: <linux-kernel-owner+w=401wt.eu-S1752000AbZIVTi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbZIVTi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbZIVTiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:38:25 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:49576 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbZIVTiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:38:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AmX8jEZzcMqsrzeLvNT/LWMyTlHyYH6cnu6X00whxIbDVhnDwNDG+Dl6D0we0V5t+I
         Vmn1yiQ4LCWjNiT+c7nZPKvs0lZ7sjBRnWExlNZSPjpGT7/tOObW8AspmYGtEX87alH9
         QBNOA6li5GOB2YJKXr37vZYk488TCVFIfkDu4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [GIT PULL] tracing/kprobes: Kprobes core/tracing/profiling updates
Date: Tue, 22 Sep 2009 21:37:58 +0200
Message-Id: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Kprobes has been nicely improved lately.
The x86 instruction decoder has been fixed to support cross builds and
mmx instruction set, besides of a lot of various kprobes core fixes.

The tracing part has evolved too, we can define human names for
arguments and custom subsystem names for dynamic tracepoints.

And also kprobes profiling and raw dynamic tracepoint samples are now
supported through perf. Looks like most of the kernel parts are now
in place for a perf support. Things are going to be focused on a
perf kprobes tool to exploit that.

Concerning this git tree, based on tip:/tracing/kprobes, I had to merge
tracing/core inside few weeks ago because it needed build fixes that were
in tracing/core (the merge commit provides the details). The tree is self
contained but it's already async with recent upstream tracing updates.
It means that merging upstream tree or tracing/core inside may result in
non-trivial conflicts. I can handle them, or rebase the whole, as you prefer.

The tree can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/kprobes

Thanks,
Frederic.

---
Ananth N Mavinakayanahalli (1):
      kprobes: Prevent re-registration of the same kprobe

Frederic Weisbecker (1):
      Merge commit 'tracing/core' into tracing/kprobes

Masami Hiramatsu (23):
      kprobes/x86: Call BUG() when reentering probe into KPROBES_HIT_SS
      kprobes/x86-64: Allow to reenter probe on post_handler
      kprobes/x86: Fix to add __kprobes to in-kernel fault handing functions
      kprobes: Fix to add __kprobes to notify_die
      kprobes/x86-64: Fix to move common_interrupt to .kprobes.text
      kprobes: Prohibit to probe native_get_debugreg
      x86: Allow x86-32 instruction decoder selftest on x86-64
      x86: Remove unused config macros from instruction decoder selftest
      x86: Add MMX support for instruction decoder
      kprobes/x86-32: Move irq-exit functions to kprobes section
      x86/ptrace: Fix regs_get_argument_nth() to add correct offset
      tracing/kprobes: Fix probe offset to be unsigned
      tracing/kprobes: Cleanup kprobe tracer code.
      tracing/kprobes: Add event profiling support
      tracing/kprobes: Add argument name support
      tracing/kprobes: Show event name in trace output
      tracing/kprobes: Support custom subsystem for each kprobe event
      tracing/kprobes: Fix trace_probe registration order
      ftrace: Fix trace_add_event_call() to initialize list
      ftrace: Fix trace_remove_event_call() to lock trace_event_mutex
      tracing/kprobes: Add probe handler dispatcher to support perf and ftrace concurrent use
      tracing/kprobes: Fix profiling alignment for perf_counter buffer
      tracing/kprobes: Disable kprobe events by default after creation


The diffstat looks erroneous. I got it by taking
tip:tracing/kprobes...HEAD  but excluding the tracing/core changes
after the merge commit: ^d28daf923ac5e4a0d7cecebae56f3e339189366b.
And it seems it has taken the diffstat from the beginning of kprobes
tracing development. Anyway, here it is:

 Documentation/trace/kprobetrace.txt  |  152 ++++
 arch/x86/Kconfig.debug               |    9 +
 arch/x86/Makefile                    |    3 +
 arch/x86/include/asm/inat.h          |  188 +++++
 arch/x86/include/asm/inat_types.h    |   29 +
 arch/x86/include/asm/insn.h          |  143 ++++
 arch/x86/include/asm/ptrace.h        |   62 ++
 arch/x86/kernel/entry_32.S           |   24 +
 arch/x86/kernel/entry_64.S           |    8 +
 arch/x86/kernel/kprobes.c            |  234 +++----
 arch/x86/kernel/ptrace.c             |  112 +++
 arch/x86/lib/Makefile                |   13 +
 arch/x86/lib/inat.c                  |   78 ++
 arch/x86/lib/insn.c                  |  464 +++++++++++
 arch/x86/lib/x86-opcode-map.txt      |  812 ++++++++++++++++++++
 arch/x86/mm/fault.c                  |   11 +-
 arch/x86/tools/Makefile              |   15 +
 arch/x86/tools/distill.awk           |   42 +
 arch/x86/tools/gen-insn-attr-x86.awk |  334 ++++++++
 arch/x86/tools/test_get_len.c        |  108 +++
 include/linux/ftrace_event.h         |   19 +-
 include/linux/kprobes.h              |    2 +
 include/linux/syscalls.h             |    4 +-
 include/trace/ftrace.h               |   16 +-
 include/trace/syscall.h              |   11 +-
 kernel/kprobes.c                     |   68 ++-
 kernel/notifier.c                    |    2 +-
 kernel/trace/Kconfig                 |   12 +
 kernel/trace/Makefile                |    1 +
 kernel/trace/trace.h                 |   24 +
 kernel/trace/trace_event_types.h     |    4 +-
 kernel/trace/trace_events.c          |  125 +++-
 kernel/trace/trace_export.c          |   31 +-
 kernel/trace/trace_kprobe.c          | 1392 ++++++++++++++++++++++++++++++++++
 kernel/trace/trace_syscalls.c        |   16 +-
 35 files changed, 4331 insertions(+), 237 deletions(-)
