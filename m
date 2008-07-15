Return-Path: <linux-kernel-owner+w=401wt.eu-S1761677AbYGOCgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761677AbYGOCgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbYGOCeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:34:13 -0400
Received: from mail.crca.org.au ([67.207.131.56]:37713 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757613AbYGOCeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:34:10 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: Latest git compile error: arch/x86/lib/csum-copy_64.S:48:
	Error: Macro `ignore' was already defined
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Kevin Winchester <kjwinchester@gmail.com>,
       Roland Dreier <rdreier@cisco.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <487BF0FD.60200@gmail.com>
References: <487BF0FD.60200@gmail.com>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Tue, 15 Jul 2008 12:34:06 +1000
Message-Id: <1216089246.25534.47.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2008-07-14 at 21:36 -0300, Kevin Winchester wrote:
> Hi Ingo, Thomas,
> 
> I get the following when trying to compile the latest source from
> Linus' 
> tree:
> 
>    AS      arch/x86/lib/csum-copy_64.o
> arch/x86/lib/csum-copy_64.S: Assembler messages:
> arch/x86/lib/csum-copy_64.S:48: Error: Macro `ignore' was already
> defined
> make[1]: *** [arch/x86/lib/csum-copy_64.o] Error 1
> make: *** [arch/x86/lib] Error 2
> 
> 
> It appears that csum-copy_64.S and dwarf2.h both define an ignore
> macro. 
>   I would expect one of them can be renamed quite easily, unless they 
> are references elsewhere.  Something like (whitespace damaged I know, 
> it's just for example):
> 
> diff --git a/include/asm-x86/dwarf2.h b/include/asm-x86/dwarf2.h
> index 0bfe250..738bb9f 100644
> --- a/include/asm-x86/dwarf2.h
> +++ b/include/asm-x86/dwarf2.h
> @@ -38,23 +38,23 @@
> 
>   /* Due to the structure of pre-exisiting code, don't use assembler
> line
>      comment character # to ignore the arguments. Instead, use a
> dummy 
> macro. */
> -.macro ignore a=0, b=0, c=0, d=0
> +.macro cfi_ignore a=0, b=0, c=0, d=0
>   .endm
> 
> -#define CFI_STARTPROC  ignore
> -#define CFI_ENDPROC    ignore
> -#define CFI_DEF_CFA    ignore
> -#define CFI_DEF_CFA_REGISTER   ignore
> -#define CFI_DEF_CFA_OFFSET     ignore
> -#define CFI_ADJUST_CFA_OFFSET  ignore
> -#define CFI_OFFSET     ignore
> -#define CFI_REL_OFFSET ignore
> -#define CFI_REGISTER   ignore
> -#define CFI_RESTORE    ignore
> -#define CFI_REMEMBER_STATE ignore
> -#define CFI_RESTORE_STATE ignore
> -#define CFI_UNDEFINED ignore
> -#define CFI_SIGNAL_FRAME ignore
> +#define CFI_STARTPROC  cfi_ignore
> +#define CFI_ENDPROC    cfi_ignore
> +#define CFI_DEF_CFA    cfi_ignore
> +#define CFI_DEF_CFA_REGISTER   cfi_ignore
> +#define CFI_DEF_CFA_OFFSET     cfi_ignore
> +#define CFI_ADJUST_CFA_OFFSET  cfi_ignore
> +#define CFI_OFFSET     cfi_ignore
> +#define CFI_REL_OFFSET cfi_ignore
> +#define CFI_REGISTER   cfi_ignore
> +#define CFI_RESTORE    cfi_ignore
> +#define CFI_REMEMBER_STATE cfi_ignore
> +#define CFI_RESTORE_STATE cfi_ignore
> +#define CFI_UNDEFINED cfi_ignore
> +#define CFI_SIGNAL_FRAME cfi_ignore
> 
>   #endif

Compiles okay here and boots okay under VMware.

Tested-by: Nigel Cunningham <nigel@tuxonice.net>

Regards,

Nigel

