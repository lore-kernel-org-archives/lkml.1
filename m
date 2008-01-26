Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbYAZKol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbYAZKol (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 05:44:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbYAZKoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 05:44:34 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:33876 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbYAZKod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 05:44:33 -0500
Date: Sat, 26 Jan 2008 13:43:43 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [build bug] ./drivers/crypto/hifn_795x.c
Message-ID: <20080126104342.GB26275@2ka.mipt.ru>
References: <20080125222150.GA22401@elte.hu> <20080125224545.GA1757@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125224545.GA1757@gondor.apana.org.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sat, Jan 26, 2008 at 09:45:45AM +1100, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> On Fri, Jan 25, 2008 at 11:21:50PM +0100, Ingo Molnar wrote:
> > 
> > randconfig testing found this (post-v2.6.24) build bug:
> > 
> >  drivers/built-in.o: In function `hifn_unregister_rng':
> >  hifn_795x.c:(.text+0x17bbd9): undefined reference to `hwrng_unregister'
> >  drivers/built-in.o: In function `hifn_probe':
> >  hifn_795x.c:(.text+0x17df70): undefined reference to `hwrng_register'
> > 
> > config attached.
> 
> Thanks for the report.  This is casued by
> 
> > CONFIG_HW_RANDOM=m
> > CONFIG_CRYPTO_DEV_HIFN_795X=y
> 
> I'll fix it with the following patch.

Thanks for fixing that up, if people who do not like select will
complain, we can make hifn rng depend on hw_random.

-- 
	Evgeniy Polyakov
