Return-Path: <linux-kernel-owner+w=401wt.eu-S934712AbZDIPX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934712AbZDIPX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765042AbZDIPXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:23:18 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:47002 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759142AbZDIPXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:23:17 -0400
Message-ID: <49DE12DD.1040802@us.ibm.com>
Date: Thu, 09 Apr 2009 08:23:09 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, davem@davemloft.net, tglx@linutronix.de,
       sfr@canb.auug.org.au, mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/futexes] sparc64: extend TI_RESTART_BLOCK space by
 8 bytes
References: <20090409151722.c8eabb56.sfr@canb.auug.org.au> <tip-d2de688891909b148efe83a6fc9520a9cd6015f0@git.kernel.org>
In-Reply-To: <tip-d2de688891909b148efe83a6fc9520a9cd6015f0@git.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Commit-ID:  d2de688891909b148efe83a6fc9520a9cd6015f0
> Gitweb:     http://git.kernel.org/tip/d2de688891909b148efe83a6fc9520a9cd6015f0
> Author:     Stephen Rothwell <sfr@canb.auug.org.au>
> AuthorDate: Thu, 9 Apr 2009 15:17:22 +1000
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 9 Apr 2009 08:09:50 +0200
> 
> sparc64: extend TI_RESTART_BLOCK space by 8 bytes
> 
> Impact: build fix
> 
> Today's linux-next build (sparc64 defconfig) failed like this:
> 
>   arch/sparc/kernel/built-in.o: In function `trap_init':
>   (.init.text+0x4): undefined reference to `thread_info_offsets_are_bolixed_dave'
> 
> Caused by commit 52400ba946759af28442dee6265c5c0180ac7122 ("futex: add
> requeue_pi functionality") (from the tip-core tree) which changed the
> size of struct restart_block.
> 

In order to avoid such situations in the future, perhaps it would make 
sense to add a comment in thread_info.h stating spar64's dependency on 
the size of the restart_block?

Also, I noticed the following embedded in the definition of the 
structure, does enabling this option also break sparc64 builds?

#ifdef CONFIG_COMPAT
			struct compat_timespec __user *compat_rmtp;
#endif

Thanks,

Darren Hart

> Shift TI_KUNA_REGS and TI_KUNA_INSN up by 8 bytes to make space for the
> larger restart block.
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Acked-by: "David S. Miller" <davem@davemloft.net>
> Cc: Darren Hart <dvhltc@us.ibm.com>
> LKML-Reference: <20090409151722.c8eabb56.sfr@canb.auug.org.au>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  arch/sparc/include/asm/thread_info_64.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/sparc/include/asm/thread_info_64.h b/arch/sparc/include/asm/thread_info_64.h
> index 639ac80..6586572 100644
> --- a/arch/sparc/include/asm/thread_info_64.h
> +++ b/arch/sparc/include/asm/thread_info_64.h
> @@ -102,8 +102,8 @@ struct thread_info {
>  #define TI_KERN_CNTD1	0x00000488
>  #define TI_PCR		0x00000490
>  #define TI_RESTART_BLOCK 0x00000498
> -#define TI_KUNA_REGS	0x000004c0
> -#define TI_KUNA_INSN	0x000004c8
> +#define TI_KUNA_REGS	0x000004c8
> +#define TI_KUNA_INSN	0x000004d0
>  #define TI_FPREGS	0x00000500
> 
>  /* We embed this in the uppermost byte of thread_info->flags */


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
