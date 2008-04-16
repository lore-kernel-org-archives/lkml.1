Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbYDPSke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbYDPSke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbYDPSkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:40:24 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:35730 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751562AbYDPSkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:40:23 -0400
Date: Wed, 16 Apr 2008 20:40:16 +0200
From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "Adam J. Richter" <adam@yggdrasil.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH -mm crypto] AES: x86_64 asm implementation optimization
Message-ID: <20080416184016.GA21365@Chamillionaire.breakpoint.cc>
References: <1207723262.18313.37.camel@caritas-dev.intel.com> <20080416073108.GA13494@Chamillionaire.breakpoint.cc> <1208333949.4322.5.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1208333949.4322.5.camel@caritas-dev.intel.com>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cut Alexander Kjeldaas <astor@fast.no> from CC coz his mails bounce.

* Huang, Ying | 2008-04-16 16:19:09 [+0800]:

>Can you help me to test these patches
>to find out the reason for degradation on AMD CPU.
Sure. 

>> >--- a/include/crypto/aes.h
>> >+++ b/include/crypto/aes.h
>> >@@ -19,6 +19,7 @@
>> > 
>> > struct crypto_aes_ctx {
>> > 	u32 key_length;
>> >+	u32 _pad1;
>> 
>> Why is this pad required? Do you want special alignment of the keys?
>
>Because the key is loaded in 64bit in this patch, I want to align the
>key with 64bit address.

Than this won't work all the time. To make it bulletproof
- set .cra_alignmask in the glue code properly
- use the attribute aligned thing
- retrieve your private struct via crypto_tfm_ctx_aligned()

You might want to take a look on padlock-aes.c. The same thing is done
there but instead of crypto_tfm_ctx_aligned() a private function is
used (to let the compiler optimize most of the code away). Depending on
Herbert's mood you might get away with this as well (what would be
probably the case since you might prefer to do it asm) :)

>> > 	u32 key_enc[AES_MAX_KEYLENGTH_U32];
>> > 	u32 key_dec[AES_MAX_KEYLENGTH_U32];
>> > };
>> >
>
>Best Regards,
>Huang Ying
>

Sebastian
