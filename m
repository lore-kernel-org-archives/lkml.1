Return-Path: <linux-kernel-owner+w=401wt.eu-S1764595AbZANQzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764595AbZANQzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 11:55:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757986AbZANQyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 11:54:55 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:37927 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754152AbZANQyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 11:54:54 -0500
Date: Wed, 14 Jan 2009 17:54:49 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: compress - Add pcomp interface
In-Reply-To: <3f9a31f40901140845r6a0cd136ha27304c76001d1c7@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0901141753090.31703@vixen.sonytel.be>
References: <1231862386-11128-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1231862386-11128-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <3f9a31f40901140845r6a0cd136ha27304c76001d1c7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009, Jaswinder Singh Rajput wrote:
> On Tue, Jan 13, 2009 at 9:29 PM, Geert Uytterhoeven
> <Geert.Uytterhoeven@sonycom.com> wrote:
> > +static inline struct pcomp_alg *crypto_pcomp_alg(struct crypto_pcomp *tfm)
> > +{
> > +       return __crypto_pcomp_alg(crypto_pcomp_tfm(tfm)->__crt_alg);
> > +}
> > +
> > +static inline int crypto_pcomp_setup(struct crypto_pcomp *tfm,
> > +                                    const void *params)
> > +{
> > +       return crypto_pcomp_alg(tfm)->setup(crypto_pcomp_tfm(tfm), params);
> > +}
> > +
> > +static inline int crypto_pcomp_compress_init(struct crypto_pcomp *tfm)
> > +{
> > +       return crypto_pcomp_alg(tfm)->compress_init(crypto_pcomp_tfm(tfm));
> > +}
> > +
> > +static inline int crypto_pcomp_compress_update(struct crypto_pcomp *tfm,
> > +                                              struct comp_request *req)
> > +{
> > +       return crypto_pcomp_alg(tfm)->compress_update(crypto_pcomp_tfm(tfm),
> > +                                                     req);
> > +}
> > +
> > +static inline int crypto_pcomp_compress_final(struct crypto_pcomp *tfm,
> > +                                             struct comp_request *req)
> > +{
> > +       return crypto_pcomp_alg(tfm)->compress_final(crypto_pcomp_tfm(tfm),
> > +                                                    req);
> > +}
> > +
> > +static inline int crypto_pcomp_decompress_init(struct crypto_pcomp *tfm)
> > +{
> > +       return crypto_pcomp_alg(tfm)->decompress_init(crypto_pcomp_tfm(tfm));
> > +}
> > +
> > +static inline int crypto_pcomp_decompress_update(struct crypto_pcomp *tfm,
> > +                                                struct comp_request *req)
> > +{
> > +       return crypto_pcomp_alg(tfm)->decompress_update(crypto_pcomp_tfm(tfm),
> > +                                                       req);
> > +}
> > +
> > +static inline int crypto_pcomp_decompress_final(struct crypto_pcomp *tfm,
> > +                                               struct comp_request *req)
> > +{
> > +       return crypto_pcomp_alg(tfm)->decompress_final(crypto_pcomp_tfm(tfm),
> > +                                                      req);
> > +}
> 
> Can you please use expressive but short names ?

I admit they're quite long. But they're similar to the ones in use for the
already existing crypto modules.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
