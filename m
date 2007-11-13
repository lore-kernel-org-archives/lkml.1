Return-Path: <linux-kernel-owner+w=401wt.eu-S1760530AbXKMUht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760530AbXKMUht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760137AbXKMUhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:37:39 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:45774 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759716AbXKMUhi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:37:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HALqZOUdMROHU/2dsb2JhbACBWw
Date: Tue, 13 Nov 2007 15:37:35 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 4/8] Add asm-compat.h to x86 -> use new asm.h instead
Message-ID: <20071113203735.GA7450@Krystal>
References: <20071113185800.436425570@polymtl.ca> <20071113190040.426268972@polymtl.ca> <4739F564.5080006@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4739F564.5080006@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:35:12 up 10 days,  1:40,  5 users,  load average: 2.02, 2.33,
	1.63
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
>> In assembly code and in gcc inline assembly, we need .long to express a "c 
>> long"
>> type on i386 and a .quad to express the same on x86_64. Use macros similar 
>> to
>> powerpc "PPC_LONG" to express those. Name chosen: ASM_LONG. (didn't feel 
>> like
>> X86_LONG was required)
>
> In the x86 queue I already have a patch which adds <asm/asm.h> for this; I 
> used the namespace _ASM_* and the name _ASM_PTR since in Linux it is what 
> holds a pointer.
>
> 	-hpa
>

Andrew, this asm-compat.h patch should be replaced by the asm.h patch
from Peter. Here it is, straight from the x86 merge git repository :


From: H. Peter Anvin <hpa@zytor.com>
Date: Fri, 2 Nov 2007 20:59:47 +0000 (-0700)
Subject: x86: add <asm/asm.h>
X-Git-Url: http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fhpa%2Flinux-2.6-x86-headermerge.git;a=commitdiff_plain;h=b02f15537b3bf43e347214cf14bad80aeaef1caf;hp=54866f032307063776b4eff7eadb131d47f9f9b4

x86: add <asm/asm.h>

Create <asm/asm.h>, with common definitions suitable for assembly
unification.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---

diff --git a/include/asm-x86/asm.h b/include/asm-x86/asm.h
new file mode 100644
index 0000000..b5006eb
--- /dev/null
+++ b/include/asm-x86/asm.h
@@ -0,0 +1,18 @@
+#ifndef _ASM_X86_ASM_H
+#define _ASM_X86_ASM_H
+
+#ifdef CONFIG_X86_32
+/* 32 bits */
+
+# define _ASM_PTR	" .long "
+# define _ASM_ALIGN	" .balign 4 "
+
+#else
+/* 64 bits */
+
+# define _ASM_PTR	" .quad "
+# define _ASM_ALIGN	" .balign 8 "
+
+#endif /* CONFIG_X86_32 */
+
+#endif /* _ASM_X86_ASM_H */


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
