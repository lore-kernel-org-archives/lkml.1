Return-Path: <linux-kernel-owner+w=401wt.eu-S1762153AbYAYXv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762153AbYAYXv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 18:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbYAYXvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 18:51:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57964 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381AbYAYXvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 18:51:47 -0500
Date: Sat, 26 Jan 2008 00:51:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [build bug] ./drivers/crypto/hifn_795x.c
Message-ID: <20080125235131.GA19980@elte.hu>
References: <20080125222150.GA22401@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125222150.GA22401@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> randconfig testing found this (post-v2.6.24) build bug:
> 
>  drivers/built-in.o: In function `hifn_unregister_rng':
>  hifn_795x.c:(.text+0x17bbd9): undefined reference to `hwrng_unregister'
>  drivers/built-in.o: In function `hifn_probe':
>  hifn_795x.c:(.text+0x17df70): undefined reference to `hwrng_register'
> 
> config attached.

find a workaround below - but i'm not sure it's the right one.

	Ingo

Index: linux/drivers/crypto/Kconfig
===================================================================
--- linux.orig/drivers/crypto/Kconfig
+++ linux/drivers/crypto/Kconfig
@@ -89,6 +89,7 @@ config CRYPTO_DEV_HIFN_795X
 	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
 	depends on PCI
+	depends on DEV_HIFN_795X = HW_RANDOM
 	help
 	  This option allows you to have support for HIFN 795x crypto adapters.
 
