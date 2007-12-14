Return-Path: <linux-kernel-owner+w=401wt.eu-S932469AbXLNCUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469AbXLNCUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 21:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758384AbXLNCUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 21:20:24 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3272 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754860AbXLNCUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 21:20:23 -0500
Date: Fri, 14 Dec 2007 10:20:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: davem@davemloft.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: aead_geniv_* [crypto/seqiv.ko] undefined! (MMOTM stamp-2007-12-13-15-37)
Message-ID: <20071214022013.GB12426@gondor.apana.org.au>
References: <200712140203.lBE23kF6021203@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712140203.lBE23kF6021203@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 09:03:46PM -0500, Erez Zadok wrote:
> I'm getting undefined symbols while building MMOTM kernel
> stamp-2007-12-13-15-37:
> 
>   MODPOST 32 modules
> ERROR: "aead_geniv_exit" [crypto/seqiv.ko] undefined!
> ERROR: "aead_geniv_alloc" [crypto/seqiv.ko] undefined!
> ERROR: "aead_geniv_init" [crypto/seqiv.ko] undefined!
> ERROR: "aead_geniv_free" [crypto/seqiv.ko] undefined!
> make[1]: *** [__modpost] Error 1

Sorry.  I've added the following patch to fix this.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 304ecc7..237dfa2 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -34,6 +34,7 @@ config CRYPTO_BLKCIPHER
 
 config CRYPTO_SEQIV
 	tristate "Sequence Number IV Generator"
+	select CRYPTO_AEAD
 	select CRYPTO_BLKCIPHER
 	help
 	  This IV generator generates an IV based on a sequence number by
