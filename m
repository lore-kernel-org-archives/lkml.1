Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757642AbYLQB0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642AbYLQB0i (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 20:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYLQB02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 20:26:28 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:50907 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751619AbYLQB01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 20:26:27 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: ying.huang@intel.com (Huang Ying)
Subject: Re: [RFC PATCH crypto] AES: Add support to Intel	AES-NI	instructions
Cc: herbert@gondor.apana.org.au, suresh.b.siddha@intel.com,
        linux-crypto@ml.breakpoint.cc, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        mingo@elte.hu, tglx@linutronix.de
Organization: Core
In-Reply-To: <1229476462.5936.314.camel@yhuang-dev.sh.intel.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1LClB3-0006WP-9J@gondolin.me.apana.org.au>
Date: Wed, 17 Dec 2008 12:26:17 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying <ying.huang@intel.com> wrote:
>
> f. if TS is clear, then use x86_64 implementation. Otherwise if
> user-space has touched the FPU, we save the state, if not then simply
> clear TS.

Well I'd rather avoid using the x86_64 implementation ever because
unless the chip guys have really screwed up we should be looking at
a difference of at least a factor of 10.

BTW I wasn't very clear in the original email.  You'd only do the
asynchronous operation for CBC/ECB.  For the simple AES case I
suppose we'll just have to stick to the x86_64 fallback.  This'll
really suck for disk encryption but I guess you could always add
an LRW/XTS mode to your code.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
