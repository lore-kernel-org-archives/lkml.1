Return-Path: <linux-kernel-owner+w=401wt.eu-S1764720AbXJSRLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764720AbXJSRLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 13:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758980AbXJSRLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 13:11:14 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39234 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761799AbXJSRLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 13:11:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9] irq-remove: arch non-trivial
References: <20071019075443.GA6407@havoc.gtf.org>
	<20071019075543.GC6407@havoc.gtf.org>
Date: Fri, 19 Oct 2007 11:11:03 -0600
In-Reply-To: <20071019075543.GC6407@havoc.gtf.org> (Jeff Garzik's message of
	"Fri, 19 Oct 2007 03:55:43 -0400")
Message-ID: <m1tzonghco.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> commit 8d45690dd90b18daaa21b981ab20caf393220bf0
> Author: Jeff Garzik <jeff@garzik.org>
> Date:   Fri Oct 19 00:46:23 2007 -0400
>
>     [IRQ ARG REMOVAL] various non-trivial arch updates
>
>  arch/x86/kernel/vm86_32.c     |    3 ++-
>  include/asm-x86/irq_regs_32.h |   25 +++++++++++++++++++++++++
>  2 files changed, 27 insertions(+), 1 deletion(-)
>
> 8d45690dd90b18daaa21b981ab20caf393220bf0
> diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
> index 157e4be..18aae9e 100644
> --- a/arch/x86/kernel/vm86_32.c
> +++ b/arch/x86/kernel/vm86_32.c
> @@ -739,10 +739,11 @@ static int irqbits;
>  	| (1 << SIGUSR1) | (1 << SIGUSR2) | (1 << SIGIO)  | (1 << SIGURG) \
>  	| (1 << SIGUNUSED) )
>  	
> -static irqreturn_t irq_handler(int intno, void *dev_id)
> +static irqreturn_t irq_handler(void *dev_id)
>  {
>  	int irq_bit;
>  	unsigned long flags;
> +	unsigned int intno = get_irqfunc_irq();
>  
>  	spin_lock_irqsave(&irqbits_lock, flags);	
>  	irq_bit = 1 << intno;

In this case we can easily pass the irqno into request_irq, allowing
us to do "unsigned int intno = (unsigned int)dev_id;".

I suspect this is the case for the majority of the non-trivial users
as well.

Eric

