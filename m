Return-Path: <linux-kernel-owner+w=401wt.eu-S1759289AbZDAQDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289AbZDAQDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 12:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbZDAQDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 12:03:04 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:52184 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbZDAQDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 12:03:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=x1yknvi+8ggOkH24nt7HkNqsCm4RcjGFl+ywkhFuRUFoFRuYx/u82wT6yGVyGaOmrt
         BGlnaD2HPxlOKsWVLMnbH2HAcmrlnUpPanLgJ2dKWYeXDNrvMfbRXhFzCzPJpLT32cnj
         /V3BFy97WYDqPMSWBxAZpFkXliD3beV1IS9/U=
Date: Thu, 2 Apr 2009 00:03:49 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: user-mode-linux-devel@lists.sourceforge.net, jdike@addtoit.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] uml: fix link error from prefixing of i386
	syscalls with ptregs_
Message-ID: <20090401160349.GE3848@hack>
References: <E1LoMQ2-0007bB-By@pomaz-ex.szeredi.hu> <E1LoMVs-0007dg-D3@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LoMVs-0007dg-D3@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 08:47:12PM +0200, Miklos Szeredi wrote:
>From: Miklos Szeredi <mszeredi@suse.cz>
>
>Fix the following link error:
>
>arch/um/sys-i386/built-in.o: In function `sys_call_table':
>(.rodata+0x11c): undefined reference to `ptregs_fork'
>arch/um/sys-i386/built-in.o: In function `sys_call_table':
>(.rodata+0x140): undefined reference to `ptregs_execve'
>arch/um/sys-i386/built-in.o: In function `sys_call_table':
>(.rodata+0x2cc): undefined reference to `ptregs_iopl'
>arch/um/sys-i386/built-in.o: In function `sys_call_table':
>(.rodata+0x2d8): undefined reference to `ptregs_vm86old'
>arch/um/sys-i386/built-in.o: In function `sys_call_table':
>(.rodata+0x2f0): undefined reference to `ptregs_sigreturn'
>arch/um/sys-i386/built-in.o: In function `sys_call_table':
>(.rodata+0x2f4): undefined reference to `ptregs_clone'
>arch/um/sys-i386/built-in.o: In function `sys_call_table':
>(.rodata+0x3ac): undefined reference to `ptregs_vm86'
>arch/um/sys-i386/built-in.o: In function `sys_call_table':
>(.rodata+0x3c8): undefined reference to `ptregs_rt_sigreturn'
>arch/um/sys-i386/built-in.o: In function `sys_call_table':
>(.rodata+0x3fc): undefined reference to `ptregs_sigaltstack'
>arch/um/sys-i386/built-in.o: In function `sys_call_table':
>(.rodata+0x40c): undefined reference to `ptregs_vfork'
>
>This was introduced by commit 253f29a4, "x86: pass in pt_regs pointer
>for syscalls that need it"
>
>Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

Looks good.

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>


>---
> arch/um/sys-i386/sys_call_table.S |   11 +++++++++++
> 1 file changed, 11 insertions(+)
>
>Index: linux-2.6/arch/um/sys-i386/sys_call_table.S
>===================================================================
>--- linux-2.6.orig/arch/um/sys-i386/sys_call_table.S	2009-03-27 10:57:38.000000000 +0100
>+++ linux-2.6/arch/um/sys-i386/sys_call_table.S	2009-03-30 19:53:14.000000000 +0200
>@@ -9,6 +9,17 @@
> 
> #define old_mmap old_mmap_i386
> 
>+#define ptregs_fork sys_fork
>+#define ptregs_execve sys_execve
>+#define ptregs_iopl sys_iopl
>+#define ptregs_vm86old sys_vm86old
>+#define ptregs_sigreturn sys_sigreturn
>+#define ptregs_clone sys_clone
>+#define ptregs_vm86 sys_vm86
>+#define ptregs_rt_sigreturn sys_rt_sigreturn
>+#define ptregs_sigaltstack sys_sigaltstack
>+#define ptregs_vfork sys_vfork
>+
> .section .rodata,"a"
> 
> #include "../../x86/kernel/syscall_table_32.S"
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Do what you love, f**k the rest! F**k the regulations!
 
