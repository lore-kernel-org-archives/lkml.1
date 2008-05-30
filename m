Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbYE3Dgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbYE3Dgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 23:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbYE3Dg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 23:36:27 -0400
Received: from ozlabs.org ([203.10.76.45]:48730 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbYE3Dg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 23:36:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [Patch/RFC]: check CONFIG_GENERIC_HARDIRQS for request/free_irq in interrupt.h
Date: Fri, 30 May 2008 13:36:02 +1000
User-Agent: KMail/1.9.9
Cc: schwidefsky@de.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       will schmidt <will_schmidt@vnet.ibm.com>
References: <200805291741.13956.borntraeger@de.ibm.com> <1212080684.16984.30.camel@localhost> <200805292032.58801.borntraeger@de.ibm.com>
In-Reply-To: <200805292032.58801.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805301336.03317.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 May 2008 04:32:58 Christian Borntraeger wrote:
> Am Donnerstag, 29. Mai 2008 schrieb Martin Schwidefsky:
> > On Thu, 2008-05-29 at 17:41 +0200, Christian Borntraeger wrote:
> > > I currently try to evaluate virtio_console for kvm on s390 and got
> > > the following problem:
> > >
> > > virtio_console uses hvc_alloc with irq=0. That means, register_irq
> > > and free_irq are never called by hvc_console.c, but the linker will
> > > still complain about unknown references to free_irq and request_irq.
> > >
> > > As the whole kernel/irq folder depends on CONFIG_GENERIC_HARDIRQS
> > > it seems consistent to declare all functions from kernel/irq only if
> > > CONFIG_GENERIC_HARDIRQS is set. Otherwise we can use empty functions.
> > >
> > > This patch does that for register_irq and free_irq.
> > >
> > > Comments?
> >
> > Please don't. So far whenever the linker complained about the missing
> > register_irq/free_irq functions it has been a bug in a Kconfig file.
> > We should not silently accept code that requires the concept of an
> > irq-line when there is no such thing on a s390.
>
> Ok, convinced.
>
> I will look if I can modify virtio_console to get rid of hvc_console.
> Reading all the comments, it appears that Rusty is not really happy with
> all the dependencies/limitations that hvc_console brings to virtio_console.
>
> Rusty, be prepared.... ;-)
>
> Christian

OK, my plan was to at least allow the hook of notifiers in hvc_console, rather 
than relying on interrupts or nothing.  Then expose "use interrupt to notify" 
and "use a backoff timer to notify" helpers and let the caller hook one up.

But it was a vague plan which may become unrecognisable when meeting 
reality...

Cheers,
Rusty.




