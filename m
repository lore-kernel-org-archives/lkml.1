Return-Path: <linux-kernel-owner+w=401wt.eu-S933965AbZGQBvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933965AbZGQBvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 21:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933605AbZGQBvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 21:51:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36906 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933572AbZGQBvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 21:51:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Guanqun Lu <guanqun.lu@intel.com>
Subject: Re: [PATCH 1/3] add flag IRQF_NO_SUSPEND in 'struct irqaction'
Date: Fri, 17 Jul 2009 03:52:11 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc3-rjw; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, jeremy@goop.org
References: <1247834204-3084-1-git-send-email-guanqun.lu@intel.com>
In-Reply-To: <1247834204-3084-1-git-send-email-guanqun.lu@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907170352.11749.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 July 2009, Guanqun Lu wrote:
> We currently only bypass IRQF_TIMER in '__disable_irq',
> but Xen specific IRQs should not be disabled either.
> This commit adds a new flag to accompolish this goal
> without being mixed up with IRQF_TIMER flag.

For some obscure reasons [2/3] didn't reach my inbox.  The other 2 patches
look fine to me.

Best,
Rafael


> Signed-off-by: Guanqun Lu <guanqun.lu@intel.com>
> ---
>  include/linux/interrupt.h |    1 +
>  kernel/irq/manage.c       |    3 ++-
>  2 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index 2721f07..99264c3 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -58,6 +58,7 @@
>  #define IRQF_PERCPU		0x00000400
>  #define IRQF_NOBALANCING	0x00000800
>  #define IRQF_IRQPOLL		0x00001000
> +#define IRQF_NO_SUSPEND		0x00002000
>  
>  /*
>   * Bits used by threaded handlers:
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 50da676..3dc4e74 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -192,7 +192,8 @@ static inline int setup_affinity(unsigned int irq, struct irq_desc *desc)
>  void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
>  {
>  	if (suspend) {
> -		if (!desc->action || (desc->action->flags & IRQF_TIMER))
> +		if (!desc->action ||
> +		    (desc->action->flags & (IRQF_TIMER | IRQF_NO_SUSPEND)))
>  			return;
>  		desc->status |= IRQ_SUSPENDED;
>  	}
