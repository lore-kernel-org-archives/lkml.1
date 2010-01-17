Return-Path: <linux-kernel-owner+w=401wt.eu-S1754387Ab0AQSYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab0AQSYe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 13:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349Ab0AQSYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 13:24:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754291Ab0AQSYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 13:24:32 -0500
Date: Sun, 17 Jan 2010 10:24:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: clean up rwsem type system
In-Reply-To: <20100117060517.GA26525@elte.hu>
Message-ID: <alpine.LFD.2.00.1001171023440.13231@localhost.localdomain>
References: <alpine.LFD.2.00.1001121613560.17145@localhost.localdomain> <4B4D1865.5000107@zytor.com> <alpine.LFD.2.00.1001121659220.17145@localhost.localdomain> <alpine.LFD.2.00.1001121708100.17145@localhost.localdomain> <alpine.LFD.2.00.1001121755220.17145@localhost.localdomain>
 <alpine.LFD.2.00.1001121810410.17145@localhost.localdomain> <4B4EC1A5.4010701@zytor.com> <20100117060517.GA26525@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 17 Jan 2010, Ingo Molnar wrote:
> 
> FYI, -tip testing found that these changes break the UML build:
> 
> kernel/built-in.o: In function `__up_read':
> /home/mingo/tip/arch/x86/include/asm/rwsem.h:192: undefined reference to `call_rwsem_wake'
> kernel/built-in.o: In function `__up_write':
> /home/mingo/tip/arch/x86/include/asm/rwsem.h:210: undefined reference to `call_rwsem_wake'
> kernel/built-in.o: In function `__downgrade_write':
> /home/mingo/tip/arch/x86/include/asm/rwsem.h:228: undefined reference to `call_rwsem_downgrade_wake'
> kernel/built-in.o: In function `__down_read':
> /home/mingo/tip/arch/x86/include/asm/rwsem.h:112: undefined reference to `call_rwsem_down_read_failed'
> kernel/built-in.o: In function `__down_write_nested':
> /home/mingo/tip/arch/x86/include/asm/rwsem.h:154: undefined reference to `call_rwsem_down_write_failed'
> collect2: ld returned 1 exit status

I think something like this should fix it.

		Linus

---
 arch/um/sys-x86_64/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/um/sys-x86_64/Makefile b/arch/um/sys-x86_64/Makefile
index 2201e9c..c1ea9eb 100644
--- a/arch/um/sys-x86_64/Makefile
+++ b/arch/um/sys-x86_64/Makefile
@@ -8,7 +8,8 @@ obj-y = bug.o bugs.o delay.o fault.o ldt.o mem.o ptrace.o ptrace_user.o \
 	setjmp.o signal.o stub.o stub_segv.o syscalls.o syscall_table.o \
 	sysrq.o ksyms.o tls.o
 
-subarch-obj-y = lib/csum-partial_64.o lib/memcpy_64.o lib/thunk_64.o
+subarch-obj-y = lib/csum-partial_64.o lib/memcpy_64.o lib/thunk_64.o \
+		lib/rwsem_64.o
 subarch-obj-$(CONFIG_MODULES) += kernel/module.o
 
 ldt-y = ../sys-i386/ldt.o
