Return-Path: <linux-kernel-owner+w=401wt.eu-S1759151AbZFKP60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151AbZFKP60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbZFKP6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:58:18 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:40729 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754179AbZFKP6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:58:18 -0400
Date: Thu, 11 Jun 2009 11:57:43 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, torvalds@linux-foundation.org
Subject: Re: [PATCH] init: introduce mm_init()
In-Reply-To: <Pine.LNX.4.64.0906111846590.16970@melkki.cs.Helsinki.FI>
Message-ID: <alpine.DEB.1.10.0906111157081.24376@gentwo.org>
References: <Pine.LNX.4.64.0906111846590.16970@melkki.cs.Helsinki.FI>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You forgot to move it to mm/mm_init.c

On Thu, 11 Jun 2009, Pekka J Enberg wrote:

> From: Pekka Enberg <penberg@cs.helsinki.fi>
>
> As suggested by Christoph Lameter, introduce mm_init() now that we initialize
> all the kernel memory allocations together.
>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  init/main.c |   17 +++++++++++------
>  1 files changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/init/main.c b/init/main.c
> index 6d38f96..9e4bc82 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -533,6 +533,16 @@ void __init __weak thread_info_cache_init(void)
>  {
>  }
>
> +static void __init mm_init(void)
> +{
> +	/*
> +	 * Set up kernel memory allocators
> +	 */
> +	mem_init();
> +	kmem_cache_init();
> +	vmalloc_init();
> +}
> +
>  asmlinkage void __init start_kernel(void)
>  {
>  	char * command_line;
> @@ -590,12 +600,7 @@ asmlinkage void __init start_kernel(void)
>  	vfs_caches_init_early();
>  	sort_main_extable();
>  	trap_init();
> -	/*
> -	 * Set up kernel memory allocators
> -	 */
> -	mem_init();
> -	kmem_cache_init();
> -	vmalloc_init();
> +	mm_init();
>  	/*
>  	 * Set up the scheduler prior starting any interrupts (such as the
>  	 * timer interrupt). Full topology setup happens at smp_init()
>
