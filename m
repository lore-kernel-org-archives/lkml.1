Return-Path: <linux-kernel-owner+w=401wt.eu-S1757092AbYGOLwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092AbYGOLwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 07:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbYGOLwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 07:52:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37111 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754933AbYGOLwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 07:52:23 -0400
Date: Tue, 15 Jul 2008 13:51:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
	000000000000000e (reset_prng_context)
Message-ID: <20080715115117.GA3300@elte.hu>
References: <487BE071.80101@simon.arlott.org.uk> <20080715020428.GA27463@hmsendeavour.rdu.redhat.com> <20080715113304.GA30565@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715113304.GA30565@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> i have just triggered this crash too. Please, when you know about 
> bootup crashes in your code send a patch to the lkml thread so that 
> people can apply it and have a working system.

here's the band-aid patch i'm using.

	Ingo

-------------->
commit 3fdcd29e5c272c66424ac7616fcd4a9a725bc206
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Jul 15 13:34:15 2008 +0200

    crypto: exclude broken CRYPTO_PRNG code
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 crypto/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index ea50357..2cf66ca 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -670,6 +670,8 @@ comment "Random Number Generation"
 
 config CRYPTO_PRNG
 	tristate "Pseudo Random Number Generation for Cryptographic modules"
+	# causes bootup crashes with config-Tue_Jul_15_10_35_22_CEST_2008.bad
+	depends on 0
 	help
 	  This option enables the generic pseudo random number generator
 	  for cryptographic modules.  Uses the Algorithm specified in
