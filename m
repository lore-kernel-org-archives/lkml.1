Return-Path: <linux-kernel-owner+w=401wt.eu-S1759548AbXI0WOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbXI0WOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 18:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757284AbXI0WO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 18:14:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56774 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757106AbXI0WO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 18:14:27 -0400
Date: Thu, 27 Sep 2007 15:13:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: apw@shadowen.org, vagabon.xyz@gmail.com, linux-kernel@vger.kernel.org,
       kamalesh@linux.vnet.ibm.com
Subject: Re: 2.6.23-rc8-mm1 -- powerpc link failure
Message-Id: <20070927151317.67cac358.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0709271408170.7567@jikos.suse.cz>
References: <20070925014625.3cd5f896.akpm@linux-foundation.org>
	<20070925134653.GB8447@shadowen.org>
	<Pine.LNX.4.64.0709251715530.7567@jikos.suse.cz>
	<20070927120308.GJ2213@shadowen.org>
	<Pine.LNX.4.64.0709271408170.7567@jikos.suse.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007 14:13:21 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> i386 and x86_64: randomize brk()
> 
> ...
>
> --- a/arch/x86_64/ia32/ia32_binfmt.c
> +++ b/arch/x86_64/ia32/ia32_binfmt.c
> @@ -262,6 +262,7 @@ static void elf32_init(struct pt_regs *);
>  #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
>  #define arch_setup_additional_pages syscall32_setup_pages
>  extern int syscall32_setup_pages(struct linux_binprm *, int exstack);
> +extern void arch_randomize_brk(void);
>  
>  #include "../../../fs/binfmt_elf.c" 

Is this sinful extern-decl-in-C acually needed?
 
> index b4fbe47..5a1adf9 100644
> --- a/include/asm-x86_64/elf.h
> +++ b/include/asm-x86_64/elf.h
> @@ -177,4 +177,6 @@ do if (vdso_enabled) {						\
>  
>  #endif
>  
> +extern void arch_randomize_brk(void);
> +
>  #endif

Because we already have a declaration in the correct place?
