Return-Path: <linux-kernel-owner+w=401wt.eu-S1758557AbXERGpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbXERGpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 02:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754977AbXERGpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:45:40 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:4120 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754922AbXERGpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:45:40 -0400
Date: Fri, 18 May 2007 16:45:00 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       michal@logix.cz, ioe-lkml@rameria.de
Subject: Re: [PATCH (v2)] crypto: Remove pointless padlock module
Message-ID: <20070518064500.GA16394@gondor.apana.org.au>
References: <4633DB56.6070000@simon.arlott.org.uk> <4633FBFF.7050202@oracle.com> <463450C6.5060103@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463450C6.5060103@simon.arlott.org.uk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 09:01:10AM +0100, Simon Arlott wrote:
> When this is compiled in it is run too early to do anything useful:
> [    6.052000] padlock: No VIA PadLock drivers have been loaded.
> [    6.052000] padlock: Using VIA PadLock ACE for AES algorithm.
> [    6.052000] padlock: Using VIA PadLock ACE for SHA1/SHA256 algorithms.
> 
> When it's a module it isn't doing anything special, the same functionality 
> can be provided in userspace by "probeall padlock padlock-aes padlock-sha" 
> in modules.conf if it is required.

BTW, I noticed that this prevented CRYPTO_ALGAPI from being marked as m
since it was selected by CRYPTO_DEV_PADLOCK.  So I'm turning it into a
tristate again.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
d158325e407864793c5b0fbc85c74702753333b9
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index e678a33..bb90cbd 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -1,10 +1,10 @@
 menu "Hardware crypto devices"
 
 config CRYPTO_DEV_PADLOCK
-	bool "Support for VIA PadLock ACE"
+	tristate "Support for VIA PadLock ACE"
 	depends on X86_32
 	select CRYPTO_ALGAPI
-	default y
+	default m
 	help
 	  Some VIA processors come with an integrated crypto engine
 	  (so called VIA PadLock ACE, Advanced Cryptography Engine)
