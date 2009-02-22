Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbZBVWO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbZBVWO3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 17:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbZBVWOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 17:14:21 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23207 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbZBVWOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 17:14:20 -0500
Date: Sun, 22 Feb 2009 23:13:39 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernel building procedure changed?
In-Reply-To: <20090222220747.GB7279@localhost>
Message-ID: <alpine.LNX.2.00.0902222311210.4496@swampdragon.chaosbits.net>
References: <20090222220747.GB7279@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009, Cyrill Gorcunov wrote:

> Hi all,
> 
> I found a bit strange thing happens now --
> plain
> 
> 	make arch/x86/kernel/head64.o
> 
> doesn't work anymore. Instead of compiling
> _just_ this file I've got the following:
> 
> ---
> cyrill@lenovo linux-2.6.git $ make arch/x86/kernel/head64.o
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   SYMLINK include/asm -> include/asm-x86
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   AS      arch/x86/kernel/head_64.o
>   VDSOSYM arch/x86/vdso/vdso-syms.lds
>   VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
>   VDSOSYM arch/x86/vdso/vdso32-syscall-syms.lds
>   VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
>   VDSOSYM arch/x86/vdso/vdso32-syms.lds
>   LD      arch/x86/vdso/built-in.o
>   CC      fs/hpfs/dnode.o
> make[2]: *** [fs/hpfs/dnode.o] Interrupt
> make[1]: *** [fs/hpfs] Interrupt
> make: *** [fs] Interrupt
> ---
> 

I get a slightly different result (in case it's any help) : 

jj@swampdragon:~/linux-2.6$ make arch/x86/kernel/head64.o
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  UPD     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    scripts/checksyscalls.sh
  CC      arch/x86/kernel/head64.o
arch/x86/kernel/head64.c: In function 'x86_64_start_kernel':
arch/x86/kernel/head64.c:84: error: 'MODULES_VADDR' undeclared (first use in this function)
arch/x86/kernel/head64.c:84: error: (Each undeclared identifier is reported only once
arch/x86/kernel/head64.c:84: error: for each function it appears in.)
arch/x86/kernel/head64.c:84: error: 'KERNEL_IMAGE_START' undeclared (first use in this function)
arch/x86/kernel/head64.c:85: error: 'KERNEL_IMAGE_SIZE' undeclared (first use in this function)
arch/x86/kernel/head64.c:86: error: 'MODULES_LEN' undeclared (first use in 
this function)arch/x86/kernel/head64.c:89: error: '__START_KERNEL' undeclared (first use in this function)
arch/x86/kernel/head64.c:90: error: 'MODULES_END' undeclared (first use in this function)
arch/x86/kernel/head64.c:101: error: implicit declaration of function 'cleanup_highmap'
arch/x86/kernel/head64.c:117: error: implicit declaration of function 'x86_64_start_reservations'
arch/x86/kernel/head64.c: At top level:
arch/x86/kernel/head64.c:121: warning: conflicting types for 'x86_64_start_reservations'
arch/x86/kernel/head64.c:117: warning: previous implicit declaration of 'x86_64_start_reservations' was here
make[1]: *** [arch/x86/kernel/head64.o] Error 1
make: *** [arch/x86/kernel/head64.o] Error 2


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

