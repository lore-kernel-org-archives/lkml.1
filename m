Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab0BBVWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 16:22:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756601Ab0BBVWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 16:22:02 -0500
Date: Tue, 2 Feb 2010 16:21:34 -0500
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       rostedt@goodmis.org, fweisbec@gmail.com, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, mhiramat@redhat.com
Message-Id: <cover.1265142153.git.jbaron@redhat.com>
Subject: [PATCH 0/6] tracing: add compat syscall support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series adds 'compat' syscall tracing support, and updates x86_64 to use
this new functionality. Other arches still need to be implemented.

To provide arch support 3 interfaces need to be defined:
1) int is_compat_task(void);
  - most arches seem to have this already
2) unsigned long arch_compat_syscall_addr(int nr); 
  - returns a pointer to the compat syscall entry corresponding to syscall 'nr'
3) int NR_syscalls_compat;
  - number of entries in the compat syscall table.

Patches #1 and #2 in the series, implement the "NR_syscalls_compat" and the
"arch_compat_syscall_addr()" for x86.

Patches #3 and #4 add the necessary 'core' support for compat syscalls to the
event tracing code.

Finally, patches #5 and #6 convert 28 x86 compat syscalls to use the 
'DEFINE_SYSCALL' macros, which is necessary for syscall tracing.

thanks,

-Jason


Jason Baron (6):
  -x86: add NR_syscalls_compat, make ia32 syscall table visible
  -x86: add arch_compat_syscall_addr()
  -tracing: remove syscall bitmaps in preparation for compat support
  -tracing: add tracing support for compat syscalls
  -syscalls: add define syscall prefix macro
  -x86: convert compat syscalls to use 'DEFINE_SYSCALL()' macros

 arch/x86/ia32/ia32entry.S     |    3 +
 arch/x86/ia32/sys_ia32.c      |  106 ++++++++++++++++++++--------------------
 arch/x86/include/asm/compat.h |    2 +
 arch/x86/kernel/ftrace.c      |    9 ++++
 include/linux/compat.h        |    8 +++
 include/linux/syscalls.h      |   16 ++++++
 include/trace/syscall.h       |    8 +++
 kernel/trace/trace.h          |    2 +
 kernel/trace/trace_syscalls.c |  101 ++++++++++++++++++++++++++++-----------
 9 files changed, 174 insertions(+), 81 deletions(-)

