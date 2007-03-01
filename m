Return-Path: <linux-kernel-owner+w=401wt.eu-S932866AbXCABC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866AbXCABC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 20:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932867AbXCABC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 20:02:29 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50105 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932866AbXCABC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 20:02:28 -0500
Date: Wed, 28 Feb 2007 16:59:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] <linux/sysdev.h> needs to include <linux/module.h>
Message-Id: <20070228165911.bb74a714.akpm@linux-foundation.org>
In-Reply-To: <20070224122211.GA17040@linux-mips.org>
References: <20070224122211.GA17040@linux-mips.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Feb 2007 12:22:11 +0000
Ralf Baechle <ralf@linux-mips.org> wrote:

> sysdev.h uses THIS_MODULE so should include <linux/module.h>.
> 
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> 
> diff --git a/include/linux/sysdev.h b/include/linux/sysdev.h
> index 389ccf8..e699ab2 100644
> --- a/include/linux/sysdev.h
> +++ b/include/linux/sysdev.h
> @@ -22,6 +22,7 @@
>  #define _SYSDEV_H_
>  
>  #include <linux/kobject.h>
> +#include <linux/module.h>
>  #include <linux/pm.h>
>  

This causes an x86_64 trainwreck:

akpm2:/usr/src/25> xb arch/x86_64/ia32/ia32_binfmt.o
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CC      arch/x86_64/kernel/asm-offsets.s
  GEN     include/asm-x86_64/asm-offsets.h
  CC      arch/x86_64/ia32/ia32_binfmt.o
arch/x86_64/ia32/ia32_binfmt.c:48:1: warning: "ELF_ET_DYN_BASE" redefined
In file included from include/linux/elf.h:7,
                 from include/linux/module.h:15,
                 from include/linux/sysdev.h:25,
                 from include/linux/sched.h:1645,
                 from arch/x86_64/ia32/ia32_binfmt.c:11:
include/asm/elf.h:93:1: warning: this is the location of the previous definition
arch/x86_64/ia32/ia32_binfmt.c:58:1: warning: "USE_ELF_CORE_DUMP" redefined
include/asm/elf.h:85:1: warning: this is the location of the previous definition
arch/x86_64/ia32/ia32_binfmt.c:62: error: conflicting types for 'elf_greg_t'
include/asm/elf.h:32: error: previous declaration of 'elf_greg_t' was here
arch/x86_64/ia32/ia32_binfmt.c:64:1: warning: "ELF_NGREG" redefined
include/asm/elf.h:34:1: warning: this is the location of the previous definition
arch/x86_64/ia32/ia32_binfmt.c:65: error: conflicting types for 'elf_gregset_t'
include/asm/elf.h:35: error: previous declaration of 'elf_gregset_t' was here
arch/x86_64/ia32/ia32_binfmt.c:118:1: warning: "ELF_CORE_COPY_REGS" redefined
include/asm/elf.h:99:1: warning: this is the location of the previous definition
arch/x86_64/ia32/ia32_binfmt.c:139:1: warning: "__ASM_X86_64_ELF_H" redefined
include/asm/elf.h:2:1: warning: this is the location of the previous definition
arch/x86_64/ia32/ia32_binfmt.c:144: error: conflicting types for 'elf_fpregset_t'
include/asm/elf.h:37: error: previous declaration of 'elf_fpregset_t' was here
