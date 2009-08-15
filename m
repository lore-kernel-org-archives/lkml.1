Return-Path: <linux-kernel-owner+w=401wt.eu-S1751985AbZHOTnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbZHOTnB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 15:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbZHOTnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 15:43:01 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:7420 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbZHOTnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 15:43:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=AJ/Xyk1VH4Uh4UwXh+FTTftdGGj0+xHKd+dgRYYipQ6h7jhj2jCfWVSdJu36t6ejeq
         SOkpza25MO5PGuJ0GVxbCmXGiXsOQ1BNHdRNGYaBH4yPf2rcTmlt9Z/LYwsry8YuPOQT
         +1gOUCmMbsiDPas3knyaBwsJeuGhKnYZnMcJI=
Date: Sat, 15 Aug 2009 12:42:55 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Brian Swetland <swetland@google.com>,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>, Daniel Ribeiro <drwyrm@gmail.com>,
       arve@android.com, Barry Song <21cnbao@gmail.com>
Subject: Re: [RFC patch 1/3] genirq: Add oneshot support
References: <20090815174512.491425246@linutronix.de> <20090815174537.895842412@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090815174537.895842412@linutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090815201354.835D3526EA5@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Sat, Aug 15, 2009 at 05:48:33PM -0000, Thomas Gleixner wrote:
>  
>  /**
> + *	irq_oneshot_primary_handler - Handle oneshot interrupt primary handler
> + *	@irq:		the interrupt number
> + *	@dev_id:	cookie to identify the device
> + *
> + *	For oneshot interrupts which keep the interrupt line masked
> + *	until the threaded handler has been executed, the only
> + *	functionality of the primary handler is to return
> + *	IRQ_WAKE_THREAD. This is the generic implementation which
> + *	avoids lots of duplicates all over the place
> + */
> +irqreturn_t irq_oneshot_primary_handler(int irq, void *dev_id)
> +{
> +	return IRQ_WAKE_THREAD;
> +}
> +EXPORT_SYMBOL_GPL(irq_oneshot_primary_handler);

This kind of handler is useful not only for users of oneshot interrupts
but also other drivers using threaded IRQs. So maybe we should rename it
to default_threaded_irq_handler() and instead of exporting it simply
have it installed automatically when driver requests NULL in place of
IRQ handler in request_threaded_irq()?

Also, if IRQF_ONESHOT definition would make into mainline sooner than
later that would be great - then I'd be able to put all the drivers that
will end up using it into my next branch and not be concerned of
breaking linux-next.

-- 
Dmitry
