Return-Path: <linux-kernel-owner+w=401wt.eu-S1752762AbXCEJUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbXCEJUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 04:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932081AbXCEJUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 04:20:10 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:27562 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbXCEJUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 04:20:08 -0500
X-IronPort-AV: i="4.14,248,1170651600"; 
   d="scan'208"; a="29940094:sNHT28492373"
Subject: Re: [PATCH -mm 1/5] Blackfin: blackfin architecture patch update
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: Aubrey Li <aubreylee@gmail.com>, bryan.wu@analog.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200703050947.10379.arnd@arndb.de>
References: <1172722480.5264.75.camel@roc-desktop>
	 <200703032330.50116.arnd@arndb.de>
	 <6d6a94c50703042254r6b0a328cu614f8c26ad0b9656@mail.gmail.com>
	 <200703050947.10379.arnd@arndb.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Mon, 05 Mar 2007 17:19:58 +0800
Message-Id: <1173086398.5264.194.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-05 at 09:47 +0100, Arnd Bergmann wrote:
> On Monday 05 March 2007, Aubrey Li wrote:
> > On 3/4/07, Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > > In general, please put EXPORT_SYMBOL lines below the definition
> > > of the symbol itself. This list of exports should only be used
> > > for symbols that come from assembly files.
> > 
> > What is the right way to export symbol coming from c files?
>  
> As I said, below the symbol definition, like
> 
> int global_var;
> EXPORT_SYMBOL(global_var);
> 
> int global_function(void)
> {
> 	return 3;
> }
> EXPORT_SYMBOL(global_function);
> 

Got it, the rule will be followed.

> > > I'm curious: In your dual-core bf561, don't you actually need to implement
> > > something that maintains atomicity across cores rather than just across
> > > processes?
> > 
> > Yes, bf561 is a dual-core processor, but we are using only one core of
> > bf561 now.
> > IMHO, BF561 architecture was not designed for SMP or NUMA.
> 
> Interesting, so what is the intended use of the other core? Does the
> hardware have any way of supporting concurrency between the cores,
> other than sending interrupts between them?
> 

AFAIK, the dual-core in BF561 have their own L1 memory which can be
configured as cache respectively. So there is no hardware to help cache
coherence management, it is very hard to implement SMP, right?

Maybe NUMA is a solution, but it is not a wonderful solution.

In some application product, BF561 core A is running Linux kernel
+Applications while BF561 core B is just for some complicated
video/audio codec algorithm.

Any Linux multicore solution in BF561 situation is highly welcome.

> > > How does this fit in with the generic SPI code? Does it duplicate stuff
> > > from there, or do you use it?
> > 
> > We use our own. We have dma which can be used for SPI operations.
> 
> I just looked again at your code. My question was more directed at whether
> you use your own SPI abstraction layer instead of drivers/spi, which
> you fortunately don't. The piece I was missing however is the spi_bfin5xx.c
> driver, which was not part of this patch, though you seem to rely on it.
> Is that already part of the -mm kernel?
> 
> 	Arnd <><

I will send out the SPI patch ASAP. and your signature is very
interesting, it looks like a fish -:)

Another question: when is the merge point from -mm to linus mainline, is
it the same as the merge window after 2.6.21 released?

Thanks again
-Bryan Wu
