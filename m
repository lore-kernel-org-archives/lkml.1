Return-Path: <linux-kernel-owner+w=401wt.eu-S1751326AbZL1To1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326AbZL1To1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 14:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbZL1To0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 14:44:26 -0500
Received: from khc.piap.pl ([195.187.100.11]:47918 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbZL1ToZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 14:44:25 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: linux-crypto@vger.kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Crypto test results unused?
References: <m3ws07q865.fsf@intrepid.localdomain>
Date: Mon, 28 Dec 2009 20:44:20 +0100
In-Reply-To: <m3ws07q865.fsf@intrepid.localdomain> (Krzysztof Halasa's message
	of "Mon, 28 Dec 2009 19:12:50 +0100")
Message-ID: <m3eimerii3.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> int crypto_register_alg(struct crypto_alg *alg)
> {
> 	struct crypto_larval *larval;
> 	int err;
>
> 	err = crypto_check_alg(alg);
> 	if (err)
> 		return err;
>
> 	down_write(&crypto_alg_sem);
> 	larval = __crypto_register_alg(alg);
> 	up_write(&crypto_alg_sem);
>
> 	if (IS_ERR(larval))
> 		return PTR_ERR(larval);
>
> 	crypto_wait_for_test(larval);
>
> At this point alg->cra_flags includes CRYPTO_ALG_DEAD (due to failed
> test), but larval->alg.cra_flags has only the original flags (0x85).

Actually it seems all alg->cra_flags are CRYPTO_ALG_DEAD at this point,
not only these which failed tests. Will look at it soon.
-- 
Krzysztof Halasa
