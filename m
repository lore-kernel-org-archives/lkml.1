Return-Path: <linux-kernel-owner+w=401wt.eu-S1763272AbXKIVhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763272AbXKIVhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 16:37:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757764AbXKIVaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 16:30:17 -0500
Received: from ns.suse.de ([195.135.220.2]:46110 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756828AbXKIVaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 16:30:15 -0500
Date: Fri, 9 Nov 2007 22:30:10 +0100
From: Jan Blunck <jblunck@suse.de>
To: Robert Fitzsimons <robfitz@273k.net>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       akpm@linux-foundation.org
Subject: Re: oops in oprofile/dump_trace/X86 with 2.6.24-rcX
Message-ID: <20071109213010.GJ18693@hasse.suse.de>
References: <20071108014527.GA2474@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071108014527.GA2474@localhost>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, Robert Fitzsimons wrote:

> A couple of days ago I tried to use oprofile with a recent build of
> 2.6.24-rc1, this resulted in a oops 'BUG: unable to handle kernel paging
> request at virtual address'.

Sorry,

this only happens 32bit. Somehow I broke this when I introduced
stack_pointer(). Here is a patch that fixes the problem.

Thanks,
Jan

--
Subject: oprofile: Fix oops on x86 32-bit

x86 32-bit isn't saving the stack pointer to pt_regs->esp on when an
interrupt occures.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 include/asm-x86/ptrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/include/asm-x86/ptrace.h
===================================================================
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -60,7 +60,7 @@ static inline int v8086_mode(struct pt_r
 
 #define instruction_pointer(regs) ((regs)->eip)
 #define frame_pointer(regs) ((regs)->ebp)
-#define stack_pointer(regs) ((regs)->esp)
+#define stack_pointer(regs) ((unsigned long)(regs))
 #define regs_return_value(regs) ((regs)->eax)
 
 extern unsigned long profile_pc(struct pt_regs *regs);
