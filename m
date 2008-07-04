Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583AbYGDTJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbYGDTJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 15:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbYGDTJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 15:09:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750894AbYGDTI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 15:08:59 -0400
Date: Fri, 4 Jul 2008 12:08:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] handle failure of irqchip->set_type in setup_irq
Message-Id: <20080704120837.573adc9c.akpm@linux-foundation.org>
In-Reply-To: <20080704184307.GA8076@digi.com>
References: <20080625131101.GA6205@digi.com>
	<20080704104634.GA31634@digi.com>
	<20080704101717.28f6a771.akpm@linux-foundation.org>
	<20080704184307.GA8076@digi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jul 2008 20:43:07 +0200 Uwe Kleine-K__nig <Uwe.Kleine-Koenig@digi.com> wrote:

> >                                            I wonder if we can do better.
> > Let me think about that.
> I was about to suggest something like:
> 
> 	/* WARNING: this returns a static pointer, so you cannot use the
> 	 * returned value after another call to creative_function_name
> 	 */
> 	char *creative_function_name(void *addr)
> 	{
> 		static char buf[SOME_LENGTH];
> 
> 		... format symbol name into buf ...
> 
> 		return buf;
> 	}
> 
> Then I could have used
> 
> 	pr_err("setting flow type for irq %u failed (%s)\n",
> 			irq, creative_function_name(chip->set_type));
> 
> which looks definitely nicer.

Better would be

	char buf[ENOUGH /* rofl */];

	pr_err("setting flow type for irq %u failed (%s)\n",
			irq, render_function_name(buf, chip->set_type));

However I'm presently brewing up a plot to do this:

	printk("function name is %Ss\n", (unsigned long *)chip->set_type);

which I think will work.  We can also do

	printk("IP address is %Si\n", (unsigned long *)ip_address_buffer);

to replace NIPQUAD.  And similar printk extensions.

Am still thinking about it though.
