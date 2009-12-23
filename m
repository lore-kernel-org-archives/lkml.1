Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbZLWOhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbZLWOhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 09:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756048AbZLWOhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 09:37:10 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:55894 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753740AbZLWOhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 09:37:09 -0500
Date: Wed, 23 Dec 2009 22:36:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dan Carpenter <error27@gmail.com>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: double unlock in rng_dev_read()
Message-ID: <20091223143658.GA30992@gondor.apana.org.au>
References: <20091223131552.GA17923@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091223131552.GA17923@bicker>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 03:15:52PM +0200, Dan Carpenter wrote:
> It seems like we unlock rng_mutex twice (2.6.33-rc1).
> 
> drivers/char/hw_random/core.c
>    151                  mutex_unlock(&rng_mutex);
>    152
>    153                  if (need_resched())
>    154                          schedule_timeout_interruptible(1);
>    155
>    156                  if (signal_pending(current)) {
>    157                          err = -ERESTARTSYS;
>    158                          goto out;
>    159                  }
>    160          }
>    161  out_unlock:
>    162          mutex_unlock(&rng_mutex);

Hmm, are you sure you didn't mistake out for out_unlock? :)
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
