Return-Path: <linux-kernel-owner+w=401wt.eu-S2992960AbXDDPhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992960AbXDDPhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 11:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992963AbXDDPhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 11:37:42 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:21839 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992960AbXDDPhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 11:37:41 -0400
Subject: Re: real time hang w/ latency tracing
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070404085133.GC2521@elte.hu>
References: <1175626625.10738.21.camel@imap.mvista.com>
	 <1175650887.3722.2.camel@dwalker1>  <20070404085133.GC2521@elte.hu>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 08:36:53 -0700
Message-Id: <1175701013.15973.8.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 10:51 +0200, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > Index: linux-2.6.20/include/linux/serial_core.h
> > ===================================================================
> > --- linux-2.6.20.orig/include/linux/serial_core.h
> > +++ linux-2.6.20/include/linux/serial_core.h
> > @@ -213,7 +213,11 @@ struct uart_icount {
> >  typedef unsigned int __bitwise__ upf_t;
> >  
> >  struct uart_port {
> > +#ifdef CONFIG_LATENCY_TIMING
> > +	raw_spinlock_t		lock;			/* port lock */
> > +#else
> >  	spinlock_t		lock;			/* port lock */
> > +#endif
> 
> ugh - this will only cause other problems if anyone else is trying to 
> use the serial code. This needs a cleaner fix - such as not doing that 
> printk from atomic context.

I assumed this fix wasn't totally right .. Interrupts could be enabled
just before printing , after any critical stuff has happened then
disabled again after printing .. Or are you thinking of something more
complex?

Daniel

