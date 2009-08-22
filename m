Return-Path: <linux-kernel-owner+w=401wt.eu-S932684AbZHVE6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684AbZHVE6p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 00:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932560AbZHVE6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 00:58:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932538AbZHVE6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 00:58:43 -0400
From: Josh Stone <jistone@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] tracing: tweaks for generic syscall events
Date: Fri, 21 Aug 2009 21:58:41 -0700
Message-Id: <1250917125-6174-1-git-send-email-jistone@redhat.com>
In-Reply-To: <1250795373-32363-1-git-send-email-jistone@redhat.com>
References: <1250795373-32363-1-git-send-email-jistone@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series moves the callbacks for the syscall tracepoints to the
definition site, and adds generic TRACE_EVENTs which capture all syscall
arguments.

New in v3:
- Give the thread flag a more generic name: TIF_SYSCALL_TRACEPOINT.
- Move the regfuncs to arch-specific files, per Jason's suggestion.
- Change _WITH_CALLBACK to just _FN, per Ingo's suggestion.


Sample trace output:
        sendmail-974   [000] 55665.464492: sys_enter: NR 14 (1, 7fff60f3af40, 7fff60f3aec0, 8, 0, 7fb1b6a05161)

        sendmail-974   [000] 55665.464496: sys_exit: NR 14 = 0

        sendmail-974   [000] 55665.464507: sys_enter: NR 23 (5, 7fff60f3b0d0, 0, 0, 7fff60f3b150, 7fff60f3ef01)

            sshd-978   [000] 55667.845359: sys_exit: NR 23 = 1

            sshd-978   [000] 55667.845373: sys_enter: NR 14 (0, 7fffc645ce90, 7fffc645cf10, 8, 0, 101010101010101)

            sshd-978   [000] 55667.845381: sys_exit: NR 14 = 0

            sshd-978   [000] 55667.845383: sys_enter: NR 14 (2, 7fffc645cf10, 0, 8, 0, 101010101010101)

            sshd-978   [000] 55667.845386: sys_exit: NR 14 = 0

            sshd-978   [000] 55667.845395: sys_enter: NR 0 (3, 7fffc6458f80, 4000, 1, 0, 0)

            sshd-978   [000] 55667.845478: sys_exit: NR 0 = 48


---
 arch/s390/include/asm/thread_info.h |    4 +-
 arch/s390/kernel/entry.S            |    2 +-
 arch/s390/kernel/entry64.S          |    2 +-
 arch/s390/kernel/ptrace.c           |   51 +++++++++++++++++++++++---
 arch/x86/include/asm/thread_info.h  |   13 ++++---
 arch/x86/kernel/ptrace.c            |   53 +++++++++++++++++++++++----
 include/linux/tracepoint.h          |   46 +++++++++--------------
 include/trace/define_trace.h        |    5 +++
 include/trace/events/syscalls.h     |   68 +++++++++++++++++++++++++++++++++++
 include/trace/ftrace.h              |    9 +++++
 include/trace/syscall.h             |   17 ---------
 kernel/trace/trace_syscalls.c       |   17 +++++----
 kernel/tracepoint.c                 |   48 ++++--------------------
 13 files changed, 218 insertions(+), 117 deletions(-)


