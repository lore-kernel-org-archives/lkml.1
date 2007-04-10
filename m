Return-Path: <linux-kernel-owner+w=401wt.eu-S1031161AbXDJRDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031161AbXDJRDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 13:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031163AbXDJRDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 13:03:15 -0400
Received: from gw.goop.org ([64.81.55.164]:49666 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031161AbXDJRDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 13:03:14 -0400
Message-ID: <461BC350.4040403@goop.org>
Date: Tue, 10 Apr 2007 10:03:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Virtualization <virtualization@lists.linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Clean up x86 control register and MSR macros
References: <200704101648.l3AGmT5e027601@tazenda.hos.anvin.org>
In-Reply-To: <200704101648.l3AGmT5e027601@tazenda.hos.anvin.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> [PATCH] Clean up x86 control register and MSR macros
>
> This patch is based on Rusty's recent cleanup of the EFLAGS-related
> macros; it extends the same kind of cleanup to control registers and
> MSRs.
>
> It also unifies these between i386 and x86-64; at least with regards
> to MSRs, the two had definitely gotten out of sync.
>
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
>
> diff -urN --exclude='o.*' stock/linux-2.6.21-rc6-mm1/include/asm-i386/Kbuild linux-2.6.21-rc6-mm1/include/asm-i386/Kbuild
> --- stock/linux-2.6.21-rc6-mm1/include/asm-i386/Kbuild	2007-04-05 19:36:56.000000000 -0700
> +++ linux-2.6.21-rc6-mm1/include/asm-i386/Kbuild	2007-04-09 23:28:36.000000000 -0700
> @@ -3,8 +3,10 @@
>  header-y += boot.h
>  header-y += debugreg.h
>  header-y += ldt.h
> +header-y += msr-index.h
>  header-y += ptrace-abi.h
>  header-y += ucontext.h
>  
> +unifdef-y += msr.h
>  unifdef-y += mtrr.h
>  unifdef-y += vm86.h
> diff -urN --exclude='o.*' stock/linux-2.6.21-rc6-mm1/include/asm-i386/msr-index.h linux-2.6.21-rc6-mm1/include/asm-i386/msr-index.h
> --- stock/linux-2.6.21-rc6-mm1/include/asm-i386/msr-index.h	1969-12-31 16:00:00.000000000 -0800
> +++ linux-2.6.21-rc6-mm1/include/asm-i386/msr-index.h	2007-04-09 18:14:04.000000000 -0700
> @@ -0,0 +1,270 @@
> +#ifndef __ASM_MSR_INDEX_H
> +#define __ASM_MSR_INDEX_ H
>   

Extra space.

> +
> +/* x86-64 specific MSRs */
> +#define MSR_EFER		0xc0000080 /* extended feature register */
> +#define MSR_STAR		0xc0000081 /* legacy mode SYSCALL target */
> +#define MSR_LSTAR		0xc0000082 /* long mode SYSCALL target */
> +#define MSR_CSTAR		0xc0000083 /* compat mode SYSCALL target */
> +#define MSR_SYSCALL_MASK	0xc0000084 /* EFLAGS mask for syscall */
> +#define MSR_FS_BASE		0xc0000100 /* 64bit FS base */
> +#define MSR_GS_BASE		0xc0000101 /* 64bit GS base */
> +#define MSR_KERNEL_GS_BASE	0xc0000102 /* SwapGS GS shadow */
> +
> +/* EFER bits: */
> +#define _EFER_SCE		0x00000000 /* SYSCALL/SYSRET */
> +#define _EFER_LME		0x00000008 /* Long mode enable */
> +#define _EFER_LMA		0x0000000a /* Long mode active (read-only) */
> +#define _EFER_NX		0x0000000b /* No execute enable */
> +
> +#define EFER_SCE		(1<<_EFER_SCE)
> +#define EFER_LME		(1<<_EFER_LME)
> +#define EFER_LMA		(1<<_EFER_LMA)
> +#define EFER_NX			(1<<_EFER_NX)
>   

Is having separate bit numbers and masks useful?  If so, is it worth
doing for the others?

Looks OK.  Ack.

    J
