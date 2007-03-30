Return-Path: <linux-kernel-owner+w=401wt.eu-S1751212AbXC3Foy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212AbXC3Foy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 01:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbXC3Foy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 01:44:54 -0400
Received: from ozlabs.org ([203.10.76.45]:40778 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbXC3Foy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 01:44:54 -0400
Subject: Re: [PATCH] Cleanup: i386 separate hardware-defined TSS from Linux
	additions
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matt Mackall <mpm@selenic.com>
Cc: Andi Kleen <ak@suse.de>, akpm@linux-foundation.org, bunk@stusta.de,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070330023355.GU10459@waste.org>
References: <200703270607.l2R672de009090@shell0.pdx.osdl.net>
	 <200703291219.47276.ak@suse.de>
	 <1175165905.12230.201.camel@localhost.localdomain>
	 <200703291316.56393.ak@suse.de>
	 <1175222195.12230.363.camel@localhost.localdomain>
	 <20070330023355.GU10459@waste.org>
Content-Type: text/plain
Date: Fri, 30 Mar 2007 15:44:31 +1000
Message-Id: <1175233471.12230.371.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-29 at 21:33 -0500, Matt Mackall wrote:
> >  	unsigned short	gs, __gsh;
> >  	unsigned short	ldt, __ldth;
> >  	unsigned short	trace, io_bitmap_base;
> > +} __attribute__((packed));
> > +
> > +struct tss_struct {
> > +	struct i386_hw_tss x86_tss;
> > +
> >  	/*
> >  	 * The extra 1 is there because the CPU will access an
> >  	 * additional byte beyond the end of the IO permission
> 
> This comment needs to stay in the first struct..?

Hi Matt!

	Actually, it refers to the next field.  To give complete context:

	/*
	 * The extra 1 is there because the CPU will access an
	 * additional byte beyond the end of the IO permission
	 * bitmap. The extra byte must be all 1 bits, and must
	 * be within the limit.
	 */
	unsigned long	io_bitmap[IO_BITMAP_LONGS + 1];

Cheers,
Rusty.

