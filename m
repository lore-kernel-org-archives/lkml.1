Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbZCELyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbZCELyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 06:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbZCELyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 06:54:10 -0500
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:39036 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750810AbZCELyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 06:54:09 -0500
Date: Thu, 5 Mar 2009 12:54:02 +0100
From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
To: Huang Ying <ying.huang@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] crypto: Add fpu template, a wrapper for blkcipher
	touching FPU
Message-ID: <20090305115402.GA4101@Chamillionaire.breakpoint.cc>
Reply-To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
References: <1236219941.24215.38.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1236219941.24215.38.camel@yhuang-dev.sh.intel.com>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Huang Ying | 2009-03-05 10:25:41 [+0800]:

>Blkcipher touching FPU need to be enclosed by kernel_fpu_begin() and
>kernel_fpu_end(). If they are invoked in cipher algorithm
>implementation, they will be invoked for each block, so that
>performance will be hurt, because they are "slow" operations. This
>patch implements "fpu" template, which makes these operations to be
>invoked for each request.
>
>Signed-off-by: Huang Ying <ying.huang@intel.com>
>
>---
> crypto/Kconfig  |    7 ++
> crypto/Makefile |    1 
> crypto/fpu.c    |  166 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> 3 files changed, 174 insertions(+)
>
>--- a/crypto/Kconfig
>+++ b/crypto/Kconfig
>@@ -236,6 +236,13 @@ config CRYPTO_XTS
> 	  key size 256, 384 or 512 bits. This implementation currently
> 	  can't handle a sectorsize which is not a multiple of 16 bytes.
> 
>+config CRYPTO_FPU
>+	tristate "FPU wrapper"
>+	select CRYPTO_BLKCIPHER
>+	select CRYPTO_MANAGER
>+	help
>+	  FPU: Wrapper for blkcipher touching FPU.
I as an end-user have to clue what this could be about. I suggest you
don't make it visible since the explanation won't be helpfull either :)

>+
> comment "Hash modes"
> 
> config CRYPTO_HMAC

Sebastian
