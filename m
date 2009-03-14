Return-Path: <linux-kernel-owner+w=401wt.eu-S1752769AbZCNIam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbZCNIam (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 04:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbZCNIa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 04:30:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:58098 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbZCNIaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 04:30:25 -0400
Subject: Re: [tip:tracing/syscalls] x86: entry_32.S fix compile warnings -
 fix work mask bit width
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinderrajput@gmail.com, fweisbec@gmail.com, hpa@kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20090314081359.GA7405@localhost>
References: <1237012693.18733.3.camel@ht.satnam>
	 <tip-95baa1a17ff80183317d815189fe1f12fdb653bc@git.kernel.org>
	 <20090314081359.GA7405@localhost>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 13:59:29 +0530
Message-Id: <1237019369.4135.1.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-14 at 11:13 +0300, Cyrill Gorcunov wrote:
> [Jaswinder Singh Rajput - Sat, Mar 14, 2009 at 07:18:32AM +0000]
> | Commit-ID:  95baa1a17ff80183317d815189fe1f12fdb653bc
> | Gitweb:     http://git.kernel.org/tip/95baa1a17ff80183317d815189fe1f12fdb653bc
> | Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
> | AuthorDate: Sat, 14 Mar 2009 12:08:13 +0530
> | Commit:     Ingo Molnar <mingo@elte.hu>
> | CommitDate: Sat, 14 Mar 2009 08:16:01 +0100
> | 
> | x86: entry_32.S fix compile warnings - fix work mask bit width
> | 
> | Fix:
> | 
> |  arch/x86/kernel/entry_32.S:446: Warning: 00000000080001d1 shortened to 00000000000001d1
> |  arch/x86/kernel/entry_32.S:457: Warning: 000000000800feff shortened to 000000000000feff
> |  arch/x86/kernel/entry_32.S:527: Warning: 00000000080001d1 shortened to 00000000000001d1
> |  arch/x86/kernel/entry_32.S:541: Warning: 000000000800feff shortened to 000000000000feff
> |  arch/x86/kernel/entry_32.S:676: Warning: 0000000008000091 shortened to 0000000000000091
> | 
> | TIF_SYSCALL_FTRACE is 0x08000000 and until now we checked the
> | first 16 bits of the work mask - bit 27 falls outside of that.
> | 
> | Update the entry_32.S code to check the full 32-bit mask.
> | 
> | Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> | Cc: Frederic Weisbecker <fweisbec@gmail.com>
> | Cc: Steven Rostedt <rostedt@goodmis.org>
> | Cc: "H. Peter Anvin" <hpa@kernel.org>
> | LKML-Reference: <1237012693.18733.3.camel@ht.satnam>
> | Signed-off-by: Ingo Molnar <mingo@elte.hu>
> | 
> | 
> | ---
> |  arch/x86/kernel/entry_32.S |   18 ++++++++----------
> |  1 files changed, 8 insertions(+), 10 deletions(-)
> | 
> ...  
> |  sysexit_audit:
> | -	testw $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT), %cx
> | +	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT), %cx
> 							^^^^^
> Better to point ecx here? :)
> 

Thanks Cyrill :-)

Subject: [PATCH] x86: entry_32.S fix compile warnings - fix work mask bit width - v2

Replace cx with ecx

Reported-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/entry_32.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 82cf555..c929add 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -484,7 +484,7 @@ sysenter_audit:
 	jmp sysenter_do_call
 
 sysexit_audit:
-	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT), %cx
+	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT), %ecx
 	jne syscall_exit_work
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_ANY)
-- 
1.6.0.6



