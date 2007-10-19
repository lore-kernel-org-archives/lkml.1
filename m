Return-Path: <linux-kernel-owner+w=401wt.eu-S935140AbXJSR2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935140AbXJSR2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 13:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761976AbXJSR2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 13:28:09 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39274 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758773AbXJSR2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 13:28:06 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] irq-remove: core
References: <20071019075443.GA6407@havoc.gtf.org>
	<20071019075508.GB6407@havoc.gtf.org>
Date: Fri, 19 Oct 2007 11:27:59 -0600
In-Reply-To: <20071019075508.GB6407@havoc.gtf.org> (Jeff Garzik's message of
	"Fri, 19 Oct 2007 03:55:08 -0400")
Message-ID: <m1przbggkg.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 80eab7a..92e1456 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -455,7 +455,7 @@ void free_irq(unsigned int irq, void *dev_id)
>  			 */
>  			if (action->flags & IRQF_SHARED) {
>  				local_irq_save(flags);
> -				action->handler(irq, dev_id);
> +				action->handler(dev_id);
>  				local_irq_restore(flags);
>  			}
>  #endif
> @@ -549,7 +549,7 @@ int request_irq(unsigned int irq, irq_handler_t handler,
>  		unsigned long flags;
>  
>  		local_irq_save(flags);
> -		handler(irq, dev_id);
> +		handler(dev_id);
>  		local_irq_restore(flags);
>  	}
>  #endif

The above two hunks need to call set_irqfunc_irq in your model.

Eric
