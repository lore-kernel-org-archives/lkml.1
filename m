Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbYHRVi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbYHRVi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYHRViN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:38:13 -0400
Received: from gw.goop.org ([64.81.55.164]:54730 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbYHRViM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:38:12 -0400
Message-ID: <48A9EBBD.5010509@goop.org>
Date: Mon, 18 Aug 2008 14:38:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alex Nixon <alex.nixon@citrix.com>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Xen: Fix bug `do_IRQ: cannot handle IRQ -1 vector
 0x6 cpu 1'
References: <48A976E6.40906@citrix.com>
In-Reply-To: <48A976E6.40906@citrix.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Nixon wrote:
> From: Alex Nixon <alex.nixon@citrix.com>
> Date: Mon, 18 Aug 2008 12:56:48 +0100
> Subject: [PATCH] Xen: Fix bug `do_IRQ: cannot handle IRQ -1 vector 0x6 cpu 1'
>
> Following commit 9c3f2468d8339866d9ef6a25aae31a8909c6be0d, do_IRQ() looks up the IRQ number in the per-cpu variable vector_irq.
>
> This commit makes Xen initialise an identity vector_irq map for both X86_32 and X86_64.
>   

Thanks Alex.

Ingo, please apply.

Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

> Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
> ---
>  arch/x86/xen/irq.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
> index 28b85ab..bb04260 100644
> --- a/arch/x86/xen/irq.c
> +++ b/arch/x86/xen/irq.c
> @@ -21,7 +21,6 @@ void xen_force_evtchn_callback(void)
>  
>  static void __init __xen_init_IRQ(void)
>  {
> -#ifdef CONFIG_X86_64
>  	int i;
>  
>  	/* Create identity vector->irq map */
> @@ -31,7 +30,6 @@ static void __init __xen_init_IRQ(void)
>  		for_each_possible_cpu(cpu)
>  			per_cpu(vector_irq, cpu)[i] = i;
>  	}
> -#endif	/* CONFIG_X86_64 */
>  
>  	xen_init_IRQ();
>  }
>   

