Return-Path: <linux-kernel-owner+w=401wt.eu-S1764015AbXLRSWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764015AbXLRSWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 13:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763242AbXLRSVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 13:21:01 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:56386 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763207AbXLRSVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 13:21:00 -0500
Date: Tue, 18 Dec 2007 19:22:51 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: unify module_{32|64}.h
Message-ID: <20071218182251.GA17602@uranus.ravnborg.org>
References: <1197979470.7734.34.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197979470.7734.34.camel@brick>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 04:04:30AM -0800, Harvey Harrison wrote:
> This adds one case to the MODULE_PROC_FAMILY block testing
> for X86_64.  There are no new things defined on X86_64 than
> there were before.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  include/asm-x86/module.h    |   83 +++++++++++++++++++++++++++++++++++++++++-
>  include/asm-x86/module_32.h |   75 --------------------------------------
>  include/asm-x86/module_64.h |   10 -----
>  3 files changed, 81 insertions(+), 87 deletions(-)
> 
> diff --git a/include/asm-x86/module.h b/include/asm-x86/module.h
> index 2b2f18d..994837c 100644
> --- a/include/asm-x86/module.h
> +++ b/include/asm-x86/module.h
> @@ -1,5 +1,84 @@
> +#ifndef _ASM_MODULE_H
> +#define _ASM_MODULE_H
> +
> +/* x86_32/64 are simple */
> +struct mod_arch_specific
> +{
> +};
> +
>  #ifdef CONFIG_X86_32
> -# include "module_32.h"
> +# define Elf_Shdr Elf32_Shdr
> +# define Elf_Sym Elf32_Sym
> +# define Elf_Ehdr Elf32_Ehdr
>  #else
> -# include "module_64.h"
> +# define Elf_Shdr Elf64_Shdr
> +# define Elf_Sym Elf64_Sym
> +# define Elf_Ehdr Elf64_Ehdr
>  #endif
> +
> +#ifdef CONFIG_X86_64
> +/* X86_64 does not define MODULE_PROC_FAMILY */

Why is MODULE_PROC_FAMILY not relevant for 64 bit x86?

Introducing it does not belong to a unification patch,
but a follow-up patch. But I guess we would like to distingush
on te selected processor when testing module compatibility
also for 64 bit x86.

	Sam
