Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbZAFXnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbZAFXnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbZAFXnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:43:37 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44788 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbZAFXng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:43:36 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: irqnr fallout in gpiolib on sparc32
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       sparclinux <sparclinux@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20090105134832.GA14460@uranus.ravnborg.org>
References: <20090105133819.GE6014@elte.hu> <20090105134832.GA14460@uranus.ravnborg.org>
Message-Id: <20090107084238.0E6D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed,  7 Jan 2009 08:43:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  #ifndef CONFIG_GENERIC_HARDIRQS
> >  #include <asm/irq.h>
> > -# define nr_irqs		NR_IRQS
> > +
> > +/*
> > + * Wrappers for non-genirq architectures:
> > + */
> > +#define nr_irqs			NR_IRQS
> > +#define irq_to_desc(irq)	irq_desc[irq]
> 
> irq_to_desc(irq) return a pointer to a struct irq_desc
> so we need to take the address.
> 
> > +#define irq_to_desc(irq)	&irq_desc[irq]
>                                 ^
> With this small fix the build continues.

maybe my fault.
very thanks.



