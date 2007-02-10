Return-Path: <linux-kernel-owner+w=401wt.eu-S933350AbXBJMVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933350AbXBJMVY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 07:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933346AbXBJMVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 07:21:24 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:33801 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933350AbXBJMVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 07:21:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=kdoC3aTidQ8iT7mx6W3RDfo5PEstqDbTR1u++GsqATWbvl9WjWE+Hc3vFi6ReMB6ZPtS4Iwso0lmN7Hyr8FyBhNnbY8ejYweqReN6lrSTeYlboKiMivhj9t9hU5sljP08MtOksgIU67CxJtN/ARfNp8s6luMkOykwJ1FBlcZuI4=
Date: Sat, 10 Feb 2007 14:19:59 +0000
From: Frederik Deweerdt <deweerdt@free.fr>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: -mm merge plans for 2.6.21
Message-ID: <20070210141959.GD7501@slug>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org> <20070209105737.GF5785@slug> <1171020273.8675.150.camel@laptopd505.fenrus.org> <200702101242.42472.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702101242.42472.arnd@arndb.de>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 12:42:41PM +0100, Arnd Bergmann wrote:
> On Friday 09 February 2007 12:24, Arjan van de Ven wrote:
> > 
> > On Fri, 2007-02-09 at 10:57 +0000, Frederik Deweerdt wrote:
> > > +static const int __deprecated SA_INTERRUPT = IRQF_DISABLED;
> > > +static const int __deprecated SA_SAMPLE_RANDOM = IRQF_SAMPLE_RANDOM;
> > > +static const int __deprecated SA_SHIRQ = IRQF_SHARED;
> > > +static const int __deprecated SA_PROBEIRQ = IRQF_PROBE_SHARED;
> > > +static const int __deprecated SA_PERCPU = IRQF_PERCPU;
> > > +
> > > +static const int __deprecated SA_TRIGGER_LOW = IRQF_TRIGGER_LOW;
> > > +static const int __deprecated SA_TRIGGER_HIGH = IRQF_TRIGGER_HIGH;
> > > +static const int __deprecated SA_TRIGGER_FALLING = IRQF_TRIGGER_FALLING;
> > > +static const int __deprecated SA_TRIGGER_RISING = IRQF_TRIGGER_RISING;
> > > +static const int __deprecated SA_TRIGGER_MASK = IRQF_TRIGGER_MASK;
> > 
> > this will include these in every .o file for which the .c file includes
> > the header. NOT GOOD(tm)
> > 
> 
> How about this one instead then:
Well, the warning you get is not that obvious:

test.c: In function 'main':
test.c:11: warning: 'deprecated_irqf' is deprecated

And as far as I could test (gcc 4.1.1 and gcc 3.4.3), Arjan's comment is
not true, the "static const int" don't use extra space, they get
optimized away by the compiler (see http://lkml.org/lkml/2007/2/9/106).

Regards,
Frederik
> 
> Mark SA_* constants as deprecated
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -53,17 +53,19 @@
>   * Migration helpers. Scheduled for removal in 1/2007
>   * Do not use for new code !
>   */
> -#define SA_INTERRUPT		IRQF_DISABLED
> -#define SA_SAMPLE_RANDOM	IRQF_SAMPLE_RANDOM
> -#define SA_SHIRQ		IRQF_SHARED
> -#define SA_PROBEIRQ		IRQF_PROBE_SHARED
> -#define SA_PERCPU		IRQF_PERCPU
> -
> -#define SA_TRIGGER_LOW		IRQF_TRIGGER_LOW
> -#define SA_TRIGGER_HIGH		IRQF_TRIGGER_HIGH
> -#define SA_TRIGGER_FALLING	IRQF_TRIGGER_FALLING
> -#define SA_TRIGGER_RISING	IRQF_TRIGGER_RISING
> -#define SA_TRIGGER_MASK		IRQF_TRIGGER_MASK
> +typedef unsigned int __deprecated deprecated_irqf;
> +
> +#define SA_INTERRUPT		((deprecated_irqf)IRQF_DISABLED)
> +#define SA_SAMPLE_RANDOM	((deprecated_irqf)IRQF_SAMPLE_RANDOM)
> +#define SA_SHIRQ		((deprecated_irqf)IRQF_SHARED)
> +#define SA_PROBEIRQ		((deprecated_irqf)IRQF_PROBE_SHARED)
> +#define SA_PERCPU		((deprecated_irqf)IRQF_PERCPU)
> +
> +#define SA_TRIGGER_LOW		((deprecated_irqf)IRQF_TRIGGER_LOW)
> +#define SA_TRIGGER_HIGH		((deprecated_irqf)IRQF_TRIGGER_HIGH)
> +#define SA_TRIGGER_FALLING	((deprecated_irqf)IRQF_TRIGGER_FALLING)
> +#define SA_TRIGGER_RISING	((deprecated_irqf)IRQF_TRIGGER_RISING)
> +#define SA_TRIGGER_MASK		((deprecated_irqf)IRQF_TRIGGER_MASK)
>  
>  typedef irqreturn_t (*irq_handler_t)(int, void *);
>  
> 
