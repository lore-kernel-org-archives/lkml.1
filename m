Return-Path: <linux-kernel-owner+w=401wt.eu-S932072AbZEEDpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072AbZEEDpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 23:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756007AbZEEDpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 23:45:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47605 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbZEEDpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 23:45:16 -0400
Message-ID: <49FFB644.5030201@redhat.com>
Date: Mon, 04 May 2009 23:45:08 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090324 Fedora/3.0-2.1.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] crypto: don't raise alarm for no ctr(aes*) tests in	fips
 mode
References: <200904282118.22823.jarod@redhat.com> <20090504111010.GA4991@gondor.apana.org.au> <200905041456.59427.jarod@redhat.com> <20090505010847.GA13071@gondor.apana.org.au>
In-Reply-To: <20090505010847.GA13071@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2009 09:08 PM, Herbert Xu wrote:
> On Mon, May 04, 2009 at 02:56:58PM -0400, Jarod Wilson wrote:
>> Ah... Now I think I see... We can provide an initial counter w/o a
>> problem, but counter incrementation is implementation-specific, so
> 
> Not in Linux.  If you're going to provide ctr you'd better increment
> in the way the current implementation does it.  Otherwise anything
> that wraps around it, such as RFC3686 will fail.
> 
> Another way to put it, only the counter mode as used in RFC 3686,
> CCM and GCM is what we call ctr.

Yeah, no, I didn't mean within Linux we'd have different implementations,
I meant e.g. Linux vs. Windows vs. a Cisco router or what have you as far
as the base counter increment routine being implementation-specific.

Can't keep all the RFCs and SPs and whatnot straight in my head, and they
aren't in front of me, but I thought I read that the basic counter increment
routine wasn't mandated to be any specific way, the only mandate was to
ensure unique values. Suggestions for how to do so were made though.

That all seems to coincide with the AESAVS's assertion that automated
testing of ctr(aes) isn't possible, if one considers that Monte Carlo tests
are typically a standard part of all the other ciphers/modes full
validation test suites. I just initially read that to mean that self-tests
weren't possible, while I now believe its only referring to exhaustive
CAVS testing (i.e. w/MCT) not being possible, due to potential differences
from one counter inc routine to another.

Its also possible I'm losing my mind though.

-- 
Jarod Wilson
jarod@redhat.com

