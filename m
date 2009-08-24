Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728AbZHXVoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbZHXVoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 17:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbZHXVo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 17:44:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690AbZHXVnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 17:43:55 -0400
Date: Mon, 24 Aug 2009 17:40:07 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Cc: lethal@linux-sh.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com, jistone@redhat.com, tglx@linutronix.de,
       hpa@zytor.com
Message-Id: <cover.1251146512.git.jbaron@redhat.com>
Subject: [PATCH 0/4] use NR_syscalls instead of FTRACE_SYSCALL_MAX
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

This series adds definitions for NR_syscalls for x86 and x86_64 and converts
syscall events tracing to use NR_syscalls instead of FTRACE_SYSCALL_MAX.
Note, the x86_64 NR_syscalls is defined in terms of __NR_syscall_max, and
thus is dynamic (we don't need to update it when new syscalls are added).
However, the x86 implementation adds a static define in unistd.h, at least
for now.

Patches are against the current -tip tree. So the x86 static define will need
to be updated with a patch when integrated in the -next tree (which has
additional syscalls). Also, Paul Mundt has said he will update sh architecture
(to remove the FTRACE_SYSCALL_MAX definition).

thanks,

-Jason


  -add-nrsyscalls-32
  -add-nrsyscalls-x8664
  -convert-ftrace-nrsyscalls
  remove-ftrace-syscall-max

 arch/x86/include/asm/ftrace.h    |    7 -------
 arch/x86/include/asm/unistd_32.h |    2 ++
 arch/x86/kernel/ftrace.c         |    8 ++++----
 include/linux/ftrace.h           |    5 +++++
 kernel/trace/trace_syscalls.c    |   24 ++++++++++++------------
 5 files changed, 23 insertions(+), 23 deletions(-)

