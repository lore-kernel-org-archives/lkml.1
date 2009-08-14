Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbZHNKRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbZHNKRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 06:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbZHNKRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 06:17:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55799 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbZHNKRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 06:17:49 -0400
Date: Fri, 14 Aug 2009 12:17:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>,
       Brian Swetland <swetland@google.com>,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>, Daniel Ribeiro <drwyrm@gmail.com>,
       arve@android.com, Barry Song <21cnbao@gmail.com>
Subject: Re: [RFC patch 2/3] genirq: Add buslock support for irq chips on
	slow busses
Message-ID: <20090814101739.GA32418@elf.ucw.cz>
References: <20090813191535.945521006@linutronix.de> <20090813193116.509070851@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090813193116.509070851@linutronix.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Index: linux-2.6-tip/include/linux/interrupt.h
> ===================================================================
> --- linux-2.6-tip.orig/include/linux/interrupt.h
> +++ linux-2.6-tip/include/linux/interrupt.h
> @@ -113,6 +113,11 @@ request_threaded_irq(unsigned int irq, i
>  		     irq_handler_t thread_fn,
>  		     unsigned long flags, const char *name, void *dev);
>  
> +extern int __must_check
> +request_threaded_slowbus_irq(unsigned int irq, irq_handler_t handler,
> +			     irq_handler_t thread_fn,
> +			     unsigned long flags, const char *name, void *dev);
> +
>  static inline int __must_check
>  request_irq(unsigned int irq, irq_handler_t handler, unsigned long flags,
>  	    const char *name, void *dev)
> @@ -145,6 +150,7 @@ static inline void exit_irq_thread(void)
>  #endif
>  
>  extern void free_irq(unsigned int, void *);
> +extern void free_slowbus_irq(unsigned int irq, void *dev_id);
>  
>  struct device;
>  
> @@ -186,6 +192,9 @@ extern void disable_irq_nosync(unsigned 
>  extern void disable_irq(unsigned int irq);
>  extern void enable_irq(unsigned int irq);
>  
> +extern void disable_slowbus_irq(unsigned int irq);
> +extern void enable_slowbus_irq(unsigned int irq);
> +

AFAICT this means that driver would need to know what kind of IRQ it
is hooked to, right? That will lead to some ugly code in drivers that
can handle both normal and slowbus irqs, right?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
