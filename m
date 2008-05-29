Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbYE2Sdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbYE2Sdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbYE2Sdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:33:47 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:1292 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbYE2Sdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:33:47 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: schwidefsky@de.ibm.com
Subject: Re: [Patch/RFC]: check CONFIG_GENERIC_HARDIRQS for request/free_irq in interrupt.h
Date: Thu, 29 May 2008 20:32:58 +0200
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>
References: <200805291741.13956.borntraeger@de.ibm.com> <1212080684.16984.30.camel@localhost>
In-Reply-To: <1212080684.16984.30.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805292032.58801.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 29. Mai 2008 schrieb Martin Schwidefsky:
> On Thu, 2008-05-29 at 17:41 +0200, Christian Borntraeger wrote:
> > I currently try to evaluate virtio_console for kvm on s390 and got
> > the following problem:
> > 
> > virtio_console uses hvc_alloc with irq=0. That means, register_irq
> > and free_irq are never called by hvc_console.c, but the linker will
> > still complain about unknown references to free_irq and request_irq.
> > 
> > As the whole kernel/irq folder depends on CONFIG_GENERIC_HARDIRQS 
> > it seems consistent to declare all functions from kernel/irq only if
> > CONFIG_GENERIC_HARDIRQS is set. Otherwise we can use empty functions.
> > 
> > This patch does that for register_irq and free_irq. 
> > 
> > Comments?
> 
> Please don't. So far whenever the linker complained about the missing
> register_irq/free_irq functions it has been a bug in a Kconfig file.
> We should not silently accept code that requires the concept of an
> irq-line when there is no such thing on a s390.

Ok, convinced.

I will look if I can modify virtio_console to get rid of hvc_console. Reading
all the comments, it appears that Rusty is not really happy with all the 
dependencies/limitations that hvc_console brings to virtio_console.

Rusty, be prepared.... ;-)

Christian
