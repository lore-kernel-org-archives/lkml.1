Return-Path: <linux-kernel-owner+w=401wt.eu-S934244AbXC0WbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934244AbXC0WbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 18:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934230AbXC0WbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 18:31:20 -0400
Received: from mail.screens.ru ([213.234.233.54]:44629 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934238AbXC0Wal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 18:30:41 -0400
Date: Wed, 28 Mar 2007 02:28:56 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       davej@codemonkey.org.uk, johnstul@us.ibm.com, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: [PATCH] Add support for deferrable timers (respun)
Message-ID: <20070327222856.GA302@tv-sign.ru>
References: <200703212353.l2LNrNOj007453@shell0.pdx.osdl.net> <20070322140532.GA120@tv-sign.ru> <20070322151817.GA29840@linux-os.sc.intel.com> <20070322161355.GA160@tv-sign.ru> <20070327204344.GA21529@linux-os.sc.intel.com> <20070327211145.GB216@tv-sign.ru> <20070327215542.GA27408@linux-os.sc.intel.com> <20070327222227.GA279@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070327222227.GA279@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28, Oleg Nesterov wrote:
>
> looks a little bit ugly, but may be this is just me. How about
> 
> 	void timer_set_base(struct timer_list *timer, struct tvec_t_base_s *new_base)
> 	{
> 		timer->base = (struct tvec_t_base_s *)
> 			((unsigned long)(new_base) | tbase_get_deferrable(timer->base));
> 	}
> 
> __mod_timer:
> 	-	tvec_base_t *old_base = timer->base;
> 	-	timer->base = NULL;
> 	+	timer_set_base(timer, NULL);
> 
> ?

Damn, forgot to say. With this change timer_get_deferrable(timer) always works,
even if changing the timer's base in progress.

Oleg.

