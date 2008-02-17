Return-Path: <linux-kernel-owner+w=401wt.eu-S1757745AbYBQN4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745AbYBQN4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 08:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755096AbYBQN4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 08:56:10 -0500
Received: from www.tglx.de ([62.245.132.106]:55996 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996AbYBQN4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 08:56:07 -0500
Date: Sun, 17 Feb 2008 14:55:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Adrian Bunk <bunk@kernel.org>
cc: Roland McGrath <roland@redhat.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86: make mxcsr_feature_mask static again
In-Reply-To: <20080213212933.GE3383@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.00.0802171454560.7583@apollo.tec.linutronix.de>
References: <20080213212933.GE3383@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Adrian Bunk wrote:

> mxcsr_feature_mask needlessly became global.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied along with the other x86 ones.

Thanks,
	tglx
 
> ---
> 
>  arch/x86/kernel/i387.c |    2 +-
>  include/asm-x86/i387.h |    1 -
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> 76adc866d04ed20a5b2eb548920f93ad87268cbd 
> diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
> index 26719bd..763dfc4 100644
> --- a/arch/x86/kernel/i387.c
> +++ b/arch/x86/kernel/i387.c
> @@ -39,7 +39,7 @@
>  #define HAVE_HWFP 1
>  #endif
>  
> -unsigned int mxcsr_feature_mask __read_mostly = 0xffffffffu;
> +static unsigned int mxcsr_feature_mask __read_mostly = 0xffffffffu;
>  
>  void mxcsr_feature_mask_init(void)
>  {
> diff --git a/include/asm-x86/i387.h b/include/asm-x86/i387.h
> index ba8105c..4c7706a 100644
> --- a/include/asm-x86/i387.h
> +++ b/include/asm-x86/i387.h
> @@ -19,7 +19,6 @@
>  #include <asm/uaccess.h>
>  
>  extern void fpu_init(void);
> -extern unsigned int mxcsr_feature_mask;
>  extern void mxcsr_feature_mask_init(void);
>  extern void init_fpu(struct task_struct *child);
>  extern asmlinkage void math_state_restore(void);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
