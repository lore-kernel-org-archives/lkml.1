Return-Path: <linux-kernel-owner+w=401wt.eu-S2992762AbXDDIvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992762AbXDDIvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 04:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992773AbXDDIvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 04:51:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43266 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992762AbXDDIvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 04:51:37 -0400
Date: Wed, 4 Apr 2007 10:51:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: real time hang w/ latency tracing
Message-ID: <20070404085133.GC2521@elte.hu>
References: <1175626625.10738.21.camel@imap.mvista.com> <1175650887.3722.2.camel@dwalker1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175650887.3722.2.camel@dwalker1>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> Index: linux-2.6.20/include/linux/serial_core.h
> ===================================================================
> --- linux-2.6.20.orig/include/linux/serial_core.h
> +++ linux-2.6.20/include/linux/serial_core.h
> @@ -213,7 +213,11 @@ struct uart_icount {
>  typedef unsigned int __bitwise__ upf_t;
>  
>  struct uart_port {
> +#ifdef CONFIG_LATENCY_TIMING
> +	raw_spinlock_t		lock;			/* port lock */
> +#else
>  	spinlock_t		lock;			/* port lock */
> +#endif

ugh - this will only cause other problems if anyone else is trying to 
use the serial code. This needs a cleaner fix - such as not doing that 
printk from atomic context.

	Ingo
