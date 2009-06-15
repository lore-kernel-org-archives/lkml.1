Return-Path: <linux-kernel-owner+w=401wt.eu-S1764054AbZFOP7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764054AbZFOP7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763800AbZFOP7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:59:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49122 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764011AbZFOP7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:59:38 -0400
Subject: Re: [PATCH] asm-generic: drop HARDIRQ_BITS definition from
	hardirq.h
From: Steven Rostedt <srostedt@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mike Frysinger <vapier.adi@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200906142243.32409.arnd@arndb.de>
References: <1244903447-23579-1-git-send-email-vapier@gentoo.org>
	 <200906132318.19208.arnd@arndb.de>
	 <8bd0f97a0906131725l214007fcpfa90e72b03cad2ac@mail.gmail.com>
	 <200906142243.32409.arnd@arndb.de>
Content-Type: text/plain
Organization: Red Hat
Date: Mon, 15 Jun 2009 11:59:34 -0400
Message-Id: <1245081574.5195.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2009-06-14 at 22:43 +0200, Arnd Bergmann wrote:
> linux/hardirq.h contains a fallback for HARDIRQ_BITS to 10
> if it's not defined, so it is pointless to define a default
> of 8 in asm/hardirq.h. There does not seem to be a good
> reason why an architecture would want to limit the number
> of hardirqs this way.
> 
> Reported-by: Mike Frysinger <vapier@gentoo.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  include/asm-generic/hardirq.h |   13 -------------
>  1 files changed, 0 insertions(+), 13 deletions(-)
> On Sunday 14 June 2009, Mike Frysinger wrote:
> 
> Mike Frysinger wrote:
> > is there any downsides to using a "too large" value ?  i.e. if my
> > system has less than 256, does it make any difference at all if it's
> > set to 10 ?
> > -mike
> 
> None that I know of. I'm queuing this patch in my asm-generic tree now,
> unless Steven or someone else has a better idea.

ARGH!!! I guess the best patch would be to comment this better. That
"HARDIRQ_BITS" has nothing to do with the number of interrupts a machine
may have. It is the number of nested interrupts a machine may do.

If you plan on having more than 256 interrupts nesting, I suggest you
need to fix the stack problems first ;-)

Please, we only have a few bits in the preempt count (on 32 bit
machines) and this is the number of bits used to record the nesting of
interrupts.

-- Steve


> 
> 	Arnd <><
> 
> diff --git a/include/asm-generic/hardirq.h b/include/asm-generic/hardirq.h
> index 3d5d2c9..23bb4da 100644
> --- a/include/asm-generic/hardirq.h
> +++ b/include/asm-generic/hardirq.h
> @@ -11,19 +11,6 @@ typedef struct {
>  
>  #include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
>  
> -#ifndef HARDIRQ_BITS
> -#define HARDIRQ_BITS	8
> -#endif
> -
> -/*
> - * The hardirq mask has to be large enough to have
> - * space for potentially all IRQ sources in the system
> - * nesting on a single CPU:
> - */
> -#if (1 << HARDIRQ_BITS) < NR_IRQS
> -# error HARDIRQ_BITS is too low!
> -#endif
> -
>  #ifndef ack_bad_irq
>  static inline void ack_bad_irq(unsigned int irq)
>  {

