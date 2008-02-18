Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbYBRMXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbYBRMXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 07:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758286AbYBRMXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 07:23:13 -0500
Received: from elvis.franken.de ([193.175.24.41]:56086 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbYBRMXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 07:23:11 -0500
Date: Mon, 18 Feb 2008 13:18:08 +0100
To: Adrian Bunk <bunk@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.25 patch] mips: fix SNI_RM EISA=n compilation
Message-ID: <20080218121807.GA13080@alpha.franken.de>
References: <20080217215948.GL1403@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217215948.GL1403@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 11:59:48PM +0200, Adrian Bunk wrote:
> This patch fixes the following build error with CONFIG_EISA=n caused by 
> commit 231a35d37293ab88d325a9cb94e5474c156282c0:
> 
> <--  snip -->
> 
> ...
>   LD      .tmp_vmlinux1
> arch/mips/sni/built-in.o: In function `snirm_a20r_setup_devinit':
> a20r.c:(.init.text+0x42c): undefined reference to `sni_eisa_root_init'
> a20r.c:(.init.text+0x42c): relocation truncated to fit: R_MIPS_26 against `sni_eisa_root_init'
> arch/mips/sni/built-in.o: In function `snirm_setup_devinit':
> rm200.c:(.init.text+0x52c): undefined reference to `sni_eisa_root_init'
> rm200.c:(.init.text+0x52c): relocation truncated to fit: R_MIPS_26 against `sni_eisa_root_init'
> make[1]: *** [.tmp_vmlinux1] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>


Thanks for your fix, Adrian.

Ralf, please apply.

Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

> 
> ---
> f6a6c34454cbe463e2d8d567d9e0659161a82a72 diff --git a/include/asm-mips/sni.h b/include/asm-mips/sni.h
> index e716447..8c1eb02 100644
> --- a/include/asm-mips/sni.h
> +++ b/include/asm-mips/sni.h
> @@ -228,7 +228,14 @@ extern void sni_pcimt_irq_init(void);
>  extern void sni_cpu_time_init(void);
>  
>  /* eisa init for RM200/400 */
> +#ifdef CONFIG_EISA
>  extern int sni_eisa_root_init(void);
> +#else
> +static inline int sni_eisa_root_init(void)
> +{
> +	return 0;
> +}
> +#endif
>  
>  /* common irq stuff */
>  extern void (*sni_hwint)(void);

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
