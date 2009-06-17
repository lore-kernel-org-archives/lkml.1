Return-Path: <linux-kernel-owner+w=401wt.eu-S1762723AbZFQUrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762723AbZFQUrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 16:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbZFQUri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 16:47:38 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46421 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753423AbZFQUrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 16:47:37 -0400
Date: Wed, 17 Jun 2009 22:47:36 +0200
From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
To: Huang Ying <ying.huang@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Subject: Re: [RFC 2/7] crypto: Use GHASH digest algorithm in GCM
Message-ID: <20090617204736.GC28694@Chamillionaire.breakpoint.cc>
Reply-To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
References: <1244704228.5320.125.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1244704228.5320.125.camel@yhuang-dev.sh.intel.com>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Huang Ying | 2009-06-11 15:10:28 [+0800]:

>Remove the dedicated GHASH implementation in GCM, and uses the GHASH
>digest algorithm instead. This will make GCM uses hardware accelerated
>GHASH implementation automatically if available.
>
>ahash instead of shash interface is used, because some hardware
>accelerated GHASH implementation needs asynchronous interface.
The outside interface is also async so this should work.

>Signed-off-by: Huang Ying <ying.huang@intel.com>
>
>@@ -796,14 +996,15 @@ static int __init crypto_gcm_module_init
> 	if (err)
> 		goto out_undo_gcm;
> 
>-out:
>-	return err;
>+	return 0;
> 
> out_undo_gcm:
> 	crypto_unregister_template(&crypto_gcm_tmpl);
> out_undo_base:
> 	crypto_unregister_template(&crypto_gcm_base_tmpl);
>-	goto out;
>+out:
>+	kfree(gcm_zeroes);
>+	return err;
> }
> 
> static void __exit crypto_gcm_module_exit(void)
here you are leaking gcm_zeroes

Sebastian
