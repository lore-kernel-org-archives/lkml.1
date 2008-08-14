Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbYHNCNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbYHNCNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 22:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbYHNCNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 22:13:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968AbYHNCNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 22:13:32 -0400
Date: Wed, 13 Aug 2008 19:05:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Oruba <peter.oruba@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: [patch 2/2] [PATCH 2/2] x86: Fixed NULL function pointer
 dereference in AMD microcode patch loader.
Message-Id: <20080813190557.d22fee8c.akpm@linux-foundation.org>
In-Reply-To: <20080801104754.604840263@amd.com>
References: <20080801104644.788786464@amd.com>
	<20080801104754.604840263@amd.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Aug 2008 12:46:46 +0200 Peter Oruba <peter.oruba@amd.com> wrote:

> Dereference took place in code part responsible for manual installation
> of microcode patches through /dev/cpu/microcode.
> 

That's a bit too terse.

> ---
>  arch/x86/kernel/microcode.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
> index 39961bb..ad136ad 100644
> --- a/arch/x86/kernel/microcode.c
> +++ b/arch/x86/kernel/microcode.c
> @@ -127,7 +127,8 @@ static int do_microcode_update(void)
>  	old = current->cpus_allowed;
>  
>  	while ((cursor = microcode_ops->get_next_ucode(&new_mc, cursor)) > 0) {
> -		error = microcode_ops->microcode_sanity_check(new_mc);
> +		if (microcode_ops->microcode_sanity_check != NULL)
> +			error = microcode_ops->microcode_sanity_check(new_mc);
>  		if (error)
>  			goto out;
>  		/*

The patch is no longer applicable to current sources.

If the bug is sufficiently serious to warrant fixing in 2.6.25.x and in
2.6.26.x then please prepare patches against those kernels, including
sufficient description to enable the -stable maintainers to understand
why they need to merge it.  Cc those patches to stable@kernel.org.

Thanks.

