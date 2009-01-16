Return-Path: <linux-kernel-owner+w=401wt.eu-S937381AbZAPUmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937381AbZAPUmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 15:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762737AbZAPUmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 15:42:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761866AbZAPUmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 15:42:12 -0500
Date: Fri, 16 Jan 2009 12:41:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch] uml: fix a link error
Message-Id: <20090116124158.4364e269.akpm@linux-foundation.org>
In-Reply-To: <20090115194033.GA10926@hack.private>
References: <20090115194033.GA10926@hack.private>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009 19:40:33 +0000
Am__rico Wang <xiyou.wangcong@gmail.com> wrote:

> 
> This patch fixes the following link error:
> 
>   LD      .tmp_vmlinux1                                             
>   arch/um/sys-i386/built-in.o: In function sys_call_table':          
>   (.rodata+0x308): undefined reference to sys_sigprocmask'           
>   collect2: ld returned 1 exit status                                 
>    KSYM    .tmp_kallsyms1.S                                          
>    nm: '.tmp_vmlinux1': No such file                                   
>    AS      .tmp_kallsyms1.o                                          
>    LD      .tmp_vmlinux2 
>    arch/um/sys-i386/built-in.o: In function sys_call_table':  
>   (.rodata+0x308): undefined reference to sys_sigprocmask'  
>   collect2: ld returned 1 exit status   
>   make[1]: *** [.tmp_vmlinux2] Error 1   
>   make: *** [sub-make] Error 2                               
> 
> 
> Signed-off-by: WANG Cong <wangcong@zeuux.org>
> Cc: Jeff Dike <jdike@addtoit.com>
> 
> ---
> diff --git a/arch/um/sys-i386/sys_call_table.S b/arch/um/sys-i386/sys_call_table.S
> index 00e5f52..04147dc 100644
> --- a/arch/um/sys-i386/sys_call_table.S
> +++ b/arch/um/sys-i386/sys_call_table.S
> @@ -6,6 +6,7 @@
>  
>  #define sys_vm86old sys_ni_syscall
>  #define sys_vm86 sys_ni_syscall
> +#define sys_sigprocmask sigprocmask
>  
>  #define old_mmap old_mmap_i386
>  

For how long has this problem been present?

Why aren't lots of other people reporting it?


