Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbZLWOyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbZLWOyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 09:54:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbZLWOyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 09:54:06 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:56272 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbZLWOyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 09:54:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=CM2Q4G7ht3OIuqzXKAtiEj+3NaiSws8gsp0zi09UjUi44EwsMbe1bWGt+POHh/TL27
         CzSwW4cjHqh51Sq8noSCAQi0+07cNzvzcRpZ48ACzWP9WPKrynXQEV2GoAUM0mbDGYpZ
         ApVudzNWMFwX22nRhQUERUCJQyNYAeamkbiQo=
Date: Wed, 23 Dec 2009 16:53:36 +0200
From: Dan Carpenter <error27@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: double unlock in rng_dev_read()
Message-ID: <20091223145336.GB23721@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
References: <20091223131552.GA17923@bicker> <20091223143658.GA30992@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091223143658.GA30992@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 10:36:58PM +0800, Herbert Xu wrote:
> On Wed, Dec 23, 2009 at 03:15:52PM +0200, Dan Carpenter wrote:
> > It seems like we unlock rng_mutex twice (2.6.33-rc1).
> > 
> > drivers/char/hw_random/core.c
> >    151                  mutex_unlock(&rng_mutex);
> >    152
> >    153                  if (need_resched())
> >    154                          schedule_timeout_interruptible(1);
> >    155
> >    156                  if (signal_pending(current)) {
> >    157                          err = -ERESTARTSYS;
> >    158                          goto out;
> >    159                  }
> >    160          }
> >    161  out_unlock:
> >    162          mutex_unlock(&rng_mutex);
> 
> Hmm, are you sure you didn't mistake out for out_unlock? :)

No no.  I mean when size hits zero we are rng_mutex is unlocked.

regards,
dan carpenter

> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
