Return-Path: <linux-kernel-owner+w=401wt.eu-S1760942AbXKBCCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760942AbXKBCCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 22:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755393AbXKBCCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 22:02:12 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:2930 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755130AbXKBCCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 22:02:11 -0400
Date: Fri, 2 Nov 2007 10:01:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andreas Mohr <andi@lisas.de>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC] eradicate bashisms in scripts/patch-kernel
Message-ID: <20071102020118.GA13852@gondor.apana.org.au>
References: <20071031211321.GA8363@rhlx01.hs-esslingen.de> <47290096.7080207@oracle.com> <20071101121133.GA14807@rhlx01.hs-esslingen.de> <20071101082457.ff9a5d67.randy.dunlap@oracle.com> <20071101221606.GA10116@rhlx01.hs-esslingen.de> <20071101160857.6e877307.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071101160857.6e877307.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 04:08:57PM -0700, Randy Dunlap wrote:
>
> > - replace non-standard bash string parsing by sed expression
> >   (is the sed syntax ok? correct? strict enough?)
> 
> I think that this is the part that bothers me.  I can't find
> anything at
> http://www.opengroup.org/onlinepubs/000095399/utilities/xcu_chap02.html
> that says that this:
> 	EXTRAVER=${EXTRAVER%%[[:punct:]]*}
> 
> is invalid or even optional syntax.  OTOH, it does list such syntax,

This is POSIX-compliant and has worked with dash from the very
start.

> > About the missing $ signs:
> > http://www.opengroup.org/onlinepubs/009695399/utilities/xcu_chap02.html#tag_02_14
> > says:
> > "If the shell variable x contains a value that forms a valid integer
> > constant, then the arithmetic expansions
> >  "$((x))" and "$(($x))" shall return the same value."
> > 
> > Hmm, well, seems dash doesn't... (syntax error).
> > Thus I still needed to add the $ signs despite opengroup.org specifying
> > it differently.
> 
> Herbert?

Using variables without dollar signs in arithmetic expansion was
only added to dash very recently.  So please please talk to your
distribution maker to update their dash packages and it will work
correctly.

This usage is compliant with the most recent revision of POSIX
while earlier ones did not specifically require this (due to
the fact that assignment support was not required either).

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
