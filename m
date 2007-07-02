Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbXGBWQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbXGBWQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 18:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756611AbXGBWQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 18:16:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56832 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756573AbXGBWQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 18:16:41 -0400
Date: Mon, 2 Jul 2007 15:15:00 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Jeff Garzik <jeff@garzik.org>, ionut@cs.columbia.edu,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, maximilian attems <max@stro.at>
Subject: Re: [git patches] net driver fixes
Message-ID: <20070702151500.3a1d0843@freepuppy.localdomain.hemminger.net>
In-Reply-To: <20070702221329.GA3492@stusta.de>
References: <20070702145401.GA10000@havoc.gtf.org>
	<20070702221329.GA3492@stusta.de>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.13; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2007 00:13:29 +0200
Adrian Bunk <bunk@stusta.de> wrote:

> On Mon, Jul 02, 2007 at 10:54:01AM -0400, Jeff Garzik wrote:
> >...
> > maximilian attems (1):
> >       starfire list alpha as 64 bit arch
> >...
> > --- a/drivers/net/starfire.c
> > +++ b/drivers/net/starfire.c
> > @@ -152,7 +152,7 @@ static int full_duplex[MAX_UNITS] = {0, };
> >   * This SUCKS.
> >   * We need a much better method to determine if dma_addr_t is 64-bit.
> >   */
> > -#if (defined(__i386__) && defined(CONFIG_HIGHMEM64G)) || defined(__x86_64__) || defined (__ia64__) || defined(__mips64__) || (defined(__mips__) && defined(CONFIG_HIGHMEM) && defined(CONFIG_64BIT_PHYS_ADDR))
> > +#if (defined(__i386__) && defined(CONFIG_HIGHMEM64G)) || defined(__x86_64__) || defined (__ia64__) || defined(__alpha__) || defined(__mips64__) || (defined(__mips__) && defined(CONFIG_HIGHMEM) && defined(CONFIG_64BIT_PHYS_ADDR))
> >  /* 64-bit dma_addr_t */
> >  #define ADDR_64BITS	/* This chip uses 64 bit addresses. */
> >  #define netdrv_addr_t u64
> >...
> 
> The patch is correct and definitely the best solution at this time of 
> the 2.6.22 development cycle.
> 
> But the comment in the context exactly matches what I thought when
> I saw this code...
> 
> Does anyone have a suggestion how to do this better?
> 
> cu
> Adrian
> 

Yeah, write code that handles it in compiler. Like:
	if (sizeof(dma_addr_t) > sizeof(u32)) {
		do something...
	}
That means that it gets checked even if optimizer removes it as
unneeded.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
