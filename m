Return-Path: <linux-kernel-owner+w=401wt.eu-S1764045AbYA3S7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764045AbYA3S7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 13:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760440AbYA3S7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 13:59:32 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:36251 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760161AbYA3S7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 13:59:30 -0500
Date: Wed, 30 Jan 2008 21:00:04 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: arch/x86/kernel/test_nx.c compile error
Message-ID: <20080130190004.GG29368@does.not.exist>
References: <20080130182537.GD29368@does.not.exist> <20080130184218.GB27168@elte.hu> <20080130184432.GA31485@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080130184432.GA31485@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 07:44:32PM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > does the patch below help?
> 
> uhm, the one below instead.
> 
> 	Ingo
> 
> ------------>
> Subject: x86: fix arch/x86/kernel/test_nx.c modular build bug
> From: Ingo Molnar <mingo@elte.hu>
> 
> fix this modular build bug:
> 
> >   CC [M]  arch/x86/kernel/test_nx.o
> > {standard input}: Assembler messages:
> > {standard input}:58: Error: cannot represent relocation type BFD_RELOC_64
> > {standard input}:59: Error: cannot represent relocation type BFD_RELOC_64
> > make[2]: *** [arch/x86/kernel/test_nx.o] Error 1
> > make[1]: *** [arch/x86/kernel] Error 2
> 
> Reported-by: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/test_nx.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> Index: linux-x86.q/arch/x86/kernel/test_nx.c
> ===================================================================
> --- linux-x86.q.orig/arch/x86/kernel/test_nx.c
> +++ linux-x86.q/arch/x86/kernel/test_nx.c
> @@ -91,8 +91,13 @@ static noinline int test_address(void *a
>  		".previous\n"
>  		".section __ex_table,\"a\"\n"
>  		"       .align 8\n"
> +#ifdef CONFIG_X86_32
> +		"	.long 0b\n"
> +		"	.long 2b\n"
> +#endif
>  		"	.quad 0b\n"
>  		"	.quad 2b\n"
> +#else
>...

You don't test whether your patches compile?  ;-)

After the obvious fix it compiled.

Why wasn't this issue found before it entered Linus' tree?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

