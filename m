Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbYGOLdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbYGOLdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 07:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYGOLdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 07:33:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56247 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbYGOLde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 07:33:34 -0400
Date: Tue, 15 Jul 2008 13:33:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
	000000000000000e (reset_prng_context)
Message-ID: <20080715113304.GA30565@elte.hu>
References: <487BE071.80101@simon.arlott.org.uk> <20080715020428.GA27463@hmsendeavour.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715020428.GA27463@hmsendeavour.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Neil Horman <nhorman@tuxdriver.com> wrote:

> On Tue, Jul 15, 2008 at 12:25:37AM +0100, Simon Arlott wrote:
> > http://img182.imageshack.us/img182/7205/1005489hh6.jpg
> > 
> > .config attached
> > 
> > -- 
> > Simon Arlott
> 
> Looks like you don't have rfc3686(ctr(aes)) compiled in.  Add 
> CONFIG_CRYPTO_CTR to your config, IIRC.  I'll add a depends directive 
> to Kconfig for that in my next update.

i have just triggered this crash too. Please, when you know about bootup 
crashes in your code send a patch to the lkml thread so that people can 
apply it and have a working system.

Note that the new crypto/prng.c driver has very bad quality:

  total: 45 errors, 21 warnings, 1 checks, 410 lines checked

It has tons of completely unacceptable code mistakes in it.

And the commit log says:

|  commit b8454eebe380677789735fd6bad368af2e6b2d1e
|  Author: Neil Horman <nhorman@tuxdriver.com>
|  AuthorDate: Mon Jul 7 22:41:31 2008 +0800
|  CommitDate: Thu Jul 10 20:35:18 2008 +0800
|
|      crypto: prng - Deterministic CPRNG

i.e. this patch went in just 7 days from development to upstream, with 
insufficient review, with no linux-next presence at all (as of 
linux-next when v2.6.26 was released) and insufficient testing.

That's not how it's supposed to be.

	Ingo
