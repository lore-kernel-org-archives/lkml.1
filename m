Return-Path: <linux-kernel-owner+w=401wt.eu-S1760274AbZBLW43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760274AbZBLW43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 17:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbZBLW4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 17:56:20 -0500
Received: from mu-out-0910.google.com ([209.85.134.185]:38305 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbZBLW4T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 17:56:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qsR/UgP0hZsfXMH5bwkhEc9adUdyeKUCROhMELAZleIadfVxpLtt4Nq6FTTNAgA+gJ
         QsJ6pNVhY+PmJlRRk1WmN6WMMuQ+mwx1JOedcqc6Xjr+gYur6plVw9CZHAjjq664QOSD
         bxNIa/qgFGOag0ERZcRE9cJQjfdIsA0hf4lnA=
MIME-Version: 1.0
In-Reply-To: <1234309293.1064.4.camel@varda>
References: <1234309293.1064.4.camel@varda>
Date: Thu, 12 Feb 2009 14:56:16 -0800
X-Google-Sender-Auth: 858769eafeeada22
Message-ID: <eada2a070902121456n48d886baua8b5da6632348d79@mail.gmail.com>
Subject: Re: Compile error in ipc/shm.c latest git
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
To: alejandro.riveira@gmail.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 3:41 PM, Alejandro Riveira Fernández
<alejandro.riveira@gmail.com> wrote:
>
> v2.6.29-rc4-100-gc36c63c
>
> $ LC_ALL=C make
> make -C /home/alex/kernel/linux-2.6 O=/home/alex/kernel/2.6.29/.
>  Using /home/alex/kernel/linux-2.6 as source for kernel
> ln -fsn /home/alex/kernel/linux-2.6 source
>  GEN     /home/alex/kernel/2.6.29/Makefile
>  CHK     include/linux/version.h
>  CHK     include/linux/utsrelease.h
>  SYMLINK include/asm -> include/asm-x86
>  CALL    /home/alex/kernel/linux-2.6/scripts/checksyscalls.sh
>  CHK     include/linux/compile.h
>  VDSOSYM arch/x86/vdso/vdso-syms.lds
>  VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
>  VDSOSYM arch/x86/vdso/vdso32-syscall-syms.lds
>  VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
>  VDSOSYM arch/x86/vdso/vdso32-syms.lds
>  LD      arch/x86/vdso/built-in.o
>  CC      ipc/shm.o
> /home/alex/kernel/linux-2.6/ipc/shm.c:371:49: error: macro "hugetlb_file_setup" passed 3 arguments, but takes just 2
> /home/alex/kernel/linux-2.6/ipc/shm.c: In function 'newseg':
> /home/alex/kernel/linux-2.6/ipc/shm.c:371: error: 'hugetlb_file_setup' undeclared (first use in this function)
> /home/alex/kernel/linux-2.6/ipc/shm.c:371: error: (Each undeclared identifier is reported only once
> /home/alex/kernel/linux-2.6/ipc/shm.c:371: error: for each function it appears in.)
> make[3]: *** [ipc/shm.o] Error 1
> make[2]: *** [ipc] Error 2
> make[1]: *** [sub-make] Error 2
> make: *** [all] Error 2

Should be fixed by:

commit 1db8508cf483dc1ecf66141f90a7c03659d69512
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Tue Feb 10 23:27:32 2009 +0100

   hugetlbfs: fix build failure with !CONFIG_HUGETLBFS
