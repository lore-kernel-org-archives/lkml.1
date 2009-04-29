Return-Path: <linux-kernel-owner+w=401wt.eu-S1760295AbZD2NZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295AbZD2NZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757643AbZD2NZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:25:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57281 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063AbZD2NZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:25:00 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: print self-test pass notices in fips mode
Date: Wed, 29 Apr 2009 09:24:10 -0400
User-Agent: KMail/1.11.2 (Linux/2.6.29.1-102.fc11.x86_64; KDE/4.2.2; x86_64; ; )
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>
References: <200904282121.35300.jarod@redhat.com> <20090429131817.GB17254@gondor.apana.org.au> <200904290921.54483.jarod@redhat.com>
In-Reply-To: <200904290921.54483.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904290924.11005.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 April 2009 09:21:53 Jarod Wilson wrote:
> On Wednesday 29 April 2009 09:18:17 Herbert Xu wrote:
> > On Tue, Apr 28, 2009 at 09:21:35PM -0400, Jarod Wilson wrote:
> > >
> > > diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> > > index 39ffa69..d0cc85c 100644
> > > --- a/crypto/testmgr.c
> > > +++ b/crypto/testmgr.c
> > > @@ -2149,6 +2149,10 @@ notest:
> > >  test_done:
> > >  	if (fips_enabled && rc)
> > >  		panic("%s: %s alg self test failed in fips mode!\n", driver, alg);
> > > +	/* fips mode requires we print out self-test success notices */
> > > +	if (fips_enabled && !rc && strncmp(alg, "ctr(aes", 7))
> > > +		printk(KERN_INFO "alg: self-tests for %s (%s) passed\n",
> > > +		       driver, alg);
> > 
> > What is this strncmp crap for?
> 
> To avoid claiming we successfully self-tested ctr(aes) when its
> not actually directly testable. Was intended to go sort of hand
> in hand with the other patch to suppress 'no self test' messages
> for ctr(aes) when in fips mode. Of course, since at this point,
> we've run ecb(aes), and that's what's suggested as the way to
> test ctr(aes)[*], perhaps we don't need to
> suppress it.
> 
> [*] well, along with the sign-off from the lab that the counter
> code is acceptable

So this might actually be another argument in favor of adding a "this
algo isn't really testable" flag as Neil suggested...

-- 
Jarod Wilson
jarod@redhat.com
