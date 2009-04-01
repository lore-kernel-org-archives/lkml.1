Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbZDAKR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbZDAKR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 06:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbZDAKOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 06:14:45 -0400
Received: from www.tglx.de ([62.245.132.106]:57633 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739AbZDAKOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 06:14:43 -0400
Date: Wed, 1 Apr 2009 12:14:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Luis Henriques <henrix@sapo.pt>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] irq: DEBUG_SHIRQ executed on irq setup failure
In-Reply-To: <20090331171449.GA4993@hades.domain.com>
Message-ID: <alpine.LFD.2.00.0904010830580.12916@localhost.localdomain>
References: <20090331171449.GA4993@hades.domain.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009, Luis Henriques wrote:

> When requesting an IRQ, the DEBUG_SHIRQ code executes a fake IRQ just to make
> sure the driver is ready to receive an IRQ immediately.  The problem was that
> this fake IRQ was being executed even if interrupt line failed to be allocated
> by __setup_irq.

Good point !

> Signed-off-by: Luis Henriques <henrix@sapo.pt>
> ---
>  kernel/irq/manage.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index a3eb7ba..8e1be16 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -914,7 +914,7 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
>  		kfree(action);
>  
>  #ifdef CONFIG_DEBUG_SHIRQ
> -	if (irqflags & IRQF_SHARED) {
> +	if (retval && (irqflags & IRQF_SHARED)) {

  !retval might actually prevent the situation you described above :)

Thanks,

	tglx
