Return-Path: <linux-kernel-owner+w=401wt.eu-S1758189AbZFRCJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbZFRCJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 22:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756473AbZFRCJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 22:09:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:12667 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979AbZFRCJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 22:09:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,240,1243839600"; 
   d="scan'208";a="155839358"
Subject: Re: [RFC 2/7] crypto: Use GHASH digest algorithm in GCM
From: Huang Ying <ying.huang@intel.com>
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
In-Reply-To: <20090617204736.GC28694@Chamillionaire.breakpoint.cc>
References: <1244704228.5320.125.camel@yhuang-dev.sh.intel.com>
	 <20090617204736.GC28694@Chamillionaire.breakpoint.cc>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 10:09:33 +0800
Message-Id: <1245290973.11965.202.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-18 at 04:47 +0800, Sebastian Andrzej Siewior wrote:
> * Huang Ying | 2009-06-11 15:10:28 [+0800]:
> 
> >Remove the dedicated GHASH implementation in GCM, and uses the GHASH
> >digest algorithm instead. This will make GCM uses hardware accelerated
> >GHASH implementation automatically if available.
> >
> >ahash instead of shash interface is used, because some hardware
> >accelerated GHASH implementation needs asynchronous interface.
> The outside interface is also async so this should work.
> 
> >Signed-off-by: Huang Ying <ying.huang@intel.com>
> >
> >@@ -796,14 +996,15 @@ static int __init crypto_gcm_module_init
> > 	if (err)
> > 		goto out_undo_gcm;
> > 
> >-out:
> >-	return err;
> >+	return 0;
> > 
> > out_undo_gcm:
> > 	crypto_unregister_template(&crypto_gcm_tmpl);
> > out_undo_base:
> > 	crypto_unregister_template(&crypto_gcm_base_tmpl);
> >-	goto out;
> >+out:
> >+	kfree(gcm_zeroes);
> >+	return err;
> > }
> > 
> > static void __exit crypto_gcm_module_exit(void)
> here you are leaking gcm_zeroes

Yes. I will change this. Thank you.

Best Regards,
Huang Ying

