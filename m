Return-Path: <linux-kernel-owner+w=401wt.eu-S1030720AbXAZHZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030720AbXAZHZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 02:25:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030730AbXAZHZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 02:25:07 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:51439 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030720AbXAZHZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 02:25:05 -0500
X-Originating-Ip: 74.109.98.130
Date: Fri, 26 Jan 2007 02:24:35 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Andrew Morton <akpm@osdl.org>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       dhowells@redhat.com
Subject: Re: [PATCH] Add a rounddown_pow_of_two() macro to log2.h.
In-Reply-To: <20070125192044.c9c2a093.akpm@osdl.org>
Message-ID: <Pine.LNX.4.64.0701260219040.17773@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0701250426400.7715@CPE00045a9c397f-CM001225dbafb6>
 <20070125192044.c9c2a093.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jan 2007, Andrew Morton wrote:

> On Thu, 25 Jan 2007 04:32:12 -0500 (EST)
> "Robert P. J. Day" <rpjday@mindspring.com> wrote:

> > +/*
> > + * round down to nearest power of two
> > + */
> > +static inline __attribute__((const))
> > +unsigned long __rounddown_pow_of_two(unsigned long n)
> > +{
> > +	return 1UL << (fls_long(n) - 1);
> > +}
>
> So __rounddown_pow_of_two(16) returns 8?

it does?  but if that was true, so would 17, and 18, and 19 ...  i
didn't actually test this since it seemed so straightforward.
doesn't fls_long() return the most significant bit?  oh, wait ...
reading further ...
 >
> >  /**
> >   * ilog2 - log of base 2 of 32-bit or a 64-bit unsigned value
> >   * @n - parameter
> > @@ -154,4 +174,20 @@ unsigned long __roundup_pow_of_two(unsigned long n)
> >  	__roundup_pow_of_two(n)			\
> >   )
> >
> > +/**
> > + * rounddown_pow_of_two - round the given value down to nearest power of two
> > + * @n - parameter
> > + *
> > + * round the given value down to the nearest power of two
> > + * - the result is undefined when n == 0
> > + * - this can be used to initialise global variables from constant data
> > + */
> > +#define rounddown_pow_of_two(n)			\
> > +(						\
> > +	__builtin_constant_p(n) ? (		\
> > +		(n == 1) ? 0 :			\
> > +		(1UL << ilog2(n)) :		\
> > +	__rounddown_pow_of_two(n)		\
> > + )
>
> But (1UL << ilog2(16)) returns 16?
>
>
> And, afiact, your __rounddown_pow_of_two() is basically equivalent to (1UL
> << ilog2(n)) anyway.  So a suitable (and less buggy) implementation might be
>
> static inline unsigned long rounddown_pow_of_two(unsigned long n)
> {
> 	return (n == 1) ? 0 : (1UL << ilog2(n));
> }

i think you're right.  it's been a long day so give me a few minutes
to convince myself.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
