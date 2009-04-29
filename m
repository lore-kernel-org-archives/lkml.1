Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbZD2NXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbZD2NXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbZD2NXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:23:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57223 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbZD2NXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:23:02 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: print self-test pass notices in fips mode
Date: Wed, 29 Apr 2009 09:21:53 -0400
User-Agent: KMail/1.11.2 (Linux/2.6.29.1-102.fc11.x86_64; KDE/4.2.2; x86_64; ; )
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>
References: <200904282121.35300.jarod@redhat.com> <20090429131817.GB17254@gondor.apana.org.au>
In-Reply-To: <20090429131817.GB17254@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904290921.54483.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 April 2009 09:18:17 Herbert Xu wrote:
> On Tue, Apr 28, 2009 at 09:21:35PM -0400, Jarod Wilson wrote:
> >
> > diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> > index 39ffa69..d0cc85c 100644
> > --- a/crypto/testmgr.c
> > +++ b/crypto/testmgr.c
> > @@ -2149,6 +2149,10 @@ notest:
> >  test_done:
> >  	if (fips_enabled && rc)
> >  		panic("%s: %s alg self test failed in fips mode!\n", driver, alg);
> > +	/* fips mode requires we print out self-test success notices */
> > +	if (fips_enabled && !rc && strncmp(alg, "ctr(aes", 7))
> > +		printk(KERN_INFO "alg: self-tests for %s (%s) passed\n",
> > +		       driver, alg);
> 
> What is this strncmp crap for?

To avoid claiming we successfully self-tested ctr(aes) when its
not actually directly testable. Was intended to go sort of hand
in hand with the other patch to suppress 'no self test' messages
for ctr(aes) when in fips mode. Of course, since at this point,
we've run ecb(aes), and that's what's suggested as the way to
test ctr(aes)[*], perhaps we don't need to
suppress it.

[*] well, along with the sign-off from the lab that the counter
code is acceptable

-- 
Jarod Wilson
jarod@redhat.com
