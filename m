Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab0BITuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 14:50:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751667Ab0BITuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 14:50:50 -0500
Date: Tue, 9 Feb 2010 11:49:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 28/35] radix: move radix init early
Message-Id: <20100209114916.ba38f57f.akpm@linux-foundation.org>
In-Reply-To: <1265743966-17065-29-git-send-email-yinghai@kernel.org>
References: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
	<1265743966-17065-29-git-send-email-yinghai@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Feb 2010 11:32:39 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> prepare to use it in early_irq_init()
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  init/main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/init/main.c b/init/main.c
> index 4cb47a1..8451878 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -584,6 +584,7 @@ asmlinkage void __init start_kernel(void)
>  		local_irq_disable();
>  	}
>  	rcu_init();
> +	radix_tree_init();
>  	/* init some links before init_ISA_irqs() */
>  	early_irq_init();
>  	init_IRQ();
> @@ -657,7 +658,6 @@ asmlinkage void __init start_kernel(void)
>  	proc_caches_init();
>  	buffer_init();
>  	key_init();
> -	radix_tree_init();
>  	security_init();
>  	vfs_caches_init(totalram_pages);
>  	signals_init();

Probably OK.  Note that radix_tree_init() uses slab, and it is now being
called before the kernel has run kmem_cache_init_late().  So please
ensure that this code was tested with CONFIG_SLAB=y.

