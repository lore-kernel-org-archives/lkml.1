Return-Path: <linux-kernel-owner+w=401wt.eu-S1760836AbXKBUJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760836AbXKBUJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 16:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756950AbXKBUJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 16:09:37 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:54962 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbXKBUJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 16:09:36 -0400
Date: Fri, 2 Nov 2007 21:09:35 +0100
From: Andreas Mohr <andi@lisas.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Andreas Mohr <andi@lisas.de>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC] eradicate bashisms in scripts/patch-kernel
Message-ID: <20071102200935.GA14153@rhlx01.hs-esslingen.de>
References: <20071031211321.GA8363@rhlx01.hs-esslingen.de> <47290096.7080207@oracle.com> <20071101121133.GA14807@rhlx01.hs-esslingen.de> <20071101082457.ff9a5d67.randy.dunlap@oracle.com> <20071101221606.GA10116@rhlx01.hs-esslingen.de> <20071101160857.6e877307.rdunlap@xenotime.net> <20071102020118.GA13852@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071102020118.GA13852@gondor.apana.org.au>
X-Priority: none
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Nov 02, 2007 at 10:01:18AM +0800, Herbert Xu wrote:
> On Thu, Nov 01, 2007 at 04:08:57PM -0700, Randy Dunlap wrote:
> > I think that this is the part that bothers me.  I can't find
> > anything at
> > http://www.opengroup.org/onlinepubs/000095399/utilities/xcu_chap02.html
> > that says that this:
> > 	EXTRAVER=${EXTRAVER%%[[:punct:]]*}
> > 
> > is invalid or even optional syntax.  OTOH, it does list such syntax,
> 
> This is POSIX-compliant and has worked with dash from the very
> start.

True (just verified again). But then I didn't actually say that this line
is problematic. Since I had to replace the leading . replacement part already
I decided to simply fold everything into one sed expression.

> Using variables without dollar signs in arithmetic expansion was
> only added to dash very recently.  So please please talk to your
> distribution maker to update their dash packages and it will work
> correctly.

"Debian stable.", aka "Update not an option.". Right?

Since the specs list both possibilities I'd simply go with the safe one,
the one that works on older dash versions, too.
Unless adding a $ sign happens to break other equally important
shells...

> This usage is compliant with the most recent revision of POSIX
> while earlier ones did not specifically require this (due to
> the fact that assignment support was not required either).

This is where I'd think the problem is. If dash once upon a time
decided to support the $ variant only and the specs didn't list both
at that time, well...

The dash version on my system is 0.5.3-5, BTW. Even Debian testing
has 0.5.3-7 only.
I'm now quite certain on which side to tweak things ;)

Thanks a lot for your review,

Andreas Mohr
