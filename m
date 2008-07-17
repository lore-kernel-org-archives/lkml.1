Return-Path: <linux-kernel-owner+w=401wt.eu-S1758257AbYGQL74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbYGQL74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 07:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbYGQL7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 07:59:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865AbYGQL7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 07:59:48 -0400
Date: Thu, 17 Jul 2008 07:59:35 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@devserv.devel.redhat.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Limit irq nesting
In-Reply-To: <20080717105532.157E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0807170750410.31185@devserv.devel.redhat.com>
References: <Pine.LNX.4.64.0807162128060.24301@devserv.devel.redhat.com>
 <20080717105532.157E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008, KOSAKI Motohiro wrote:

> Hi Mikulas,
> 
> > ---
> >  include/linux/interrupt.h |    7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > Index: linux-2.6.26-rc8/include/linux/interrupt.h
> > ===================================================================
> > --- linux-2.6.26-rc8.orig/include/linux/interrupt.h	2008-06-25 03:58:20.000000000 +0200
> > +++ linux-2.6.26-rc8/include/linux/interrupt.h	2008-07-01 17:42:44.000000000 +0200
> > @@ -16,6 +16,11 @@
> >  #include <asm/system.h>
> >  
> >  /*
> > + * Max number of interrupt handlers on a stack. To prevent stack overflow.
> > + */
> > +#define MAX_NESTED_INTERRUPTS	2
> > +
> > +/*
> >   * These correspond to the IORESOURCE_IRQ_* defines in
> >   * linux/ioport.h to select the interrupt line behaviour.  When
> >   * requesting an interrupt without specifying a IRQF_TRIGGER, the
> 
> I have no objection to your approach.
> but I don't know MAX_NESTED_INTERRUPTS is properly or not.
> 
> Could you explain why MAX_NESTED_INTERRUPTS is two?
> Is it architecture independent properly number?

I assume that there is at most one active bad-behaving device with long 
interrupt processing time. For example IDE disk in PIO mode.

If someone starts whining that he is simultaneously using two disks in PIO 
mode and is losing characters on serial line, we can make an architecture 
override for this (after we check that the architecture has enough stack 
space to hold more interrupts). But PIO mode is dead anyway, so there's no 
need to preemptively care about it.

Mikulas
