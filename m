Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbYKMOJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbYKMOJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 09:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbYKMOJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 09:09:45 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:47691 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750986AbYKMOJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 09:09:44 -0500
Date: Thu, 13 Nov 2008 22:09:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>,
       linux-crypto@vger.kernel.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, davem@davemloft.net
Subject: Re: [PATCH linux-next] : Tree for November 12 (libcrc32c)
Message-ID: <20081113140928.GC31608@gondor.apana.org.au>
References: <20081112182818.6e259488.sfr@canb.auug.org.au> <20081112130105.430c47e4.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112130105.430c47e4.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 01:01:05PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> libcrc32c uses CRYPTO interfaces so it should depend on CRYPTO.
> 
> crypto/built-in.o: In function `crc32c_mod_init':
> crc32c.c:(.init.text+0xc): undefined reference to `crypto_register_shash'
> crypto/built-in.o: In function `crc32c_mod_fini':
> crc32c.c:(.exit.text+0xc): undefined reference to `crypto_unregister_shash'
> lib/built-in.o: In function `crc32c':
> (.text+0xfcf9): undefined reference to `crypto_shash_update'
> lib/built-in.o: In function `libcrc32c_mod_init':
> libcrc32c.c:(.init.text+0x666): undefined reference to `crypto_alloc_shash'
> lib/built-in.o: In function `libcrc32c_mod_fini':
> libcrc32c.c:(.exit.text+0xc): undefined reference to `crypto_free_tfm'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks, I've fixed it as follows:

commit d9cc217c79df50f9a9f7937aeaa54d89ae198686
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu Nov 13 22:05:13 2008 +0800

    libcrc32c: Select CRYPTO in Kconfig
    
    Selecting CRYPTO_CRC32C is not enough as CRYPTO which CRYPTO_CRC32C
    depends on may be disabled.  This patch adds the select on CRYPTO.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/lib/Kconfig b/lib/Kconfig
index d09edb7..963009a 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -64,6 +64,7 @@ config CRC7
 
 config LIBCRC32C
 	tristate "CRC32c (Castagnoli, et al) Cyclic Redundancy-Check"
+	select CRYPTO
 	select CRYPTO_CRC32C
 	help
 	  This option is provided for the case where no in-kernel-tree

-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
