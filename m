Return-Path: <linux-kernel-owner+w=401wt.eu-S1757212AbYCHBZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbYCHBZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 20:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759980AbYCHBZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 20:25:04 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:48931 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759931AbYCHBZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 20:25:01 -0500
Date: Sat, 8 Mar 2008 09:24:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Milan Broz <mbroz@redhat.com>,
       "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>,
       Alasdair G Kergon <agk@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       dm-crypt@saout.de
Subject: Re: 2.6.25-rc[1,2]: failed to setup dm-crypt key mapping
Message-ID: <20080308012438.GA24236@gondor.apana.org.au>
References: <8f53421d0802192343v2267cb66ub579d4503e3b7eb1@mail.gmail.com> <47BC0DA9.1030607@redhat.com> <20080220172449.GD27726@gondor.apana.org.au> <47BC67CE.9070407@redhat.com> <20080220175819.GA28246@gondor.apana.org.au> <20080222123423.GA12678@gondor.apana.org.au> <e9c3a7c20803071014s6388b7b2l12f217bfdff5caa3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9c3a7c20803071014s6388b7b2l12f217bfdff5caa3@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 11:14:07AM -0700, Dan Williams wrote:
> 
> I believe this is in mainline as 76fc60a2 "[CRYPTO] skcipher: Move
> chainiv/seqiv into crypto_blkcipher module".  With a iop13xx_defconfig
>  I get:
> 
> `chainiv_module_exit' referenced in section `.init.text' of
> crypto/built-in.o: defined in discarded section `.exit.text' of
> crypto/built-in.o
> `chainiv_module_exit' referenced in section `__ksymtab_gpl' of
> crypto/built-in.o: defined in discarded section `.exit.text' of
> crypto/built-in.o
> `eseqiv_module_exit' referenced in section `__ksymtab_gpl' of
> crypto/built-in.o: defined in discarded section `.exit.text' of
> crypto/built-in.o
> make: *** [.tmp_vmlinux1] Error 1

Does this help?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/chainiv.c b/crypto/chainiv.c
index 0a7cac6..a23e1ce 100644
--- a/crypto/chainiv.c
+++ b/crypto/chainiv.c
@@ -320,7 +320,7 @@ int __init chainiv_module_init(void)
 }
 EXPORT_SYMBOL_GPL(chainiv_module_init);
 
-void __exit chainiv_module_exit(void)
+void chainiv_module_exit(void)
 {
 	crypto_unregister_template(&chainiv_tmpl);
 }
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index a8f1264..ccc32ba 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -68,7 +68,7 @@ void skcipher_geniv_exit(struct crypto_tfm *tfm);
 int __init eseqiv_module_init(void);
 void __exit eseqiv_module_exit(void);
 int __init chainiv_module_init(void);
-void __exit chainiv_module_exit(void);
+void chainiv_module_exit(void);
 
 static inline struct crypto_ablkcipher *skcipher_geniv_cipher(
 	struct crypto_ablkcipher *geniv)
