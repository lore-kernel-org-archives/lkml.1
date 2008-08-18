Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbYHRVje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbYHRVje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbYHRVjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:39:23 -0400
Received: from gw.goop.org ([64.81.55.164]:54752 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754823AbYHRVjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:39:22 -0400
Message-ID: <48A9EC07.8000707@goop.org>
Date: Mon, 18 Aug 2008 14:39:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alex Nixon <alex.nixon@citrix.com>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Xen: Fix memory access violation bug when CONFIG_HAVE_SPARSE_IRQ
 is enabled
References: <48A976F7.8060808@citrix.com>
In-Reply-To: <48A976F7.8060808@citrix.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Nixon wrote:
> From: Alex Nixon <alex.nixon@citrix.com>
> Date: Mon, 18 Aug 2008 14:15:11 +0100
> Subject: [PATCH] Xen: Fix memory access violation bug when CONFIG_HAVE_SPARSE_IRQ is enabled
>
> When sparse IRQs are enabled, it is not safe to assume an IRQ descriptor exists for every possible IRQ.  This patch causes init_evtchn_cpu_bindings to skip initialisation of IRQ descriptors which don't exist.
>
> Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
>   

Thanks again, Alex.

Ingo, please apply.

Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

> ---
>  drivers/xen/events.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index 74dca12..6e7e765 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -141,6 +141,8 @@ static void init_evtchn_cpu_bindings(void)
>  	/* By default all event channels notify CPU#0. */
>  	for (i = 0; i < nr_irqs; i++) {
>  		struct irq_desc *desc = to_irq_desc(i);
> +		if (!desc)
> +			continue;
>  		desc->affinity = cpumask_of_cpu(0);
>  	}
>  #endif
>   

