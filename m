Return-Path: <linux-kernel-owner+w=401wt.eu-S1761693AbXKQQoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761693AbXKQQoN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 11:44:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbXKQQn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 11:43:59 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:4896 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753377AbXKQQn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 11:43:59 -0500
Date: Sun, 18 Nov 2007 00:43:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andreas Mohr <andi@lisas.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC] eradicate bashisms in scripts/patch-kernel
Message-ID: <20071117164336.GA21658@gondor.apana.org.au>
References: <20071101121133.GA14807@rhlx01.hs-esslingen.de> <20071101082457.ff9a5d67.randy.dunlap@oracle.com> <20071101221606.GA10116@rhlx01.hs-esslingen.de> <20071101160857.6e877307.rdunlap@xenotime.net> <20071102020118.GA13852@gondor.apana.org.au> <20071102200935.GA14153@rhlx01.hs-esslingen.de> <20071102131707.6023a5b7.rdunlap@xenotime.net> <20071105195827.GA24117@rhlx01.hs-esslingen.de> <20071114144627.8628f2dd.rdunlap@xenotime.net> <20071117163327.GA4296@rhlx01.hs-esslingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071117163327.GA4296@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2007 at 05:33:27PM +0100, Andreas Mohr wrote:
>
> # strip EXTRAVERSION to just a number (drop leading '.' and trailing additions)
> EXTRAVER=
> if [ x$EXTRAVERSION != "x" ]
> then
> >>> [l.207]       if [ ${EXTRAVERSION:0:1} == "." ]; then
>                 EXTRAVER=${EXTRAVERSION:1}
>         else
>                 EXTRAVER=$EXTRAVERSION
>         fi
>         EXTRAVER=${EXTRAVER%%[[:punct:]]*}
>         #echo "$PNAME: changing EXTRAVERSION from $EXTRAVERSION to $EXTRAVER"
> fi
> 
> part, which the sed expression (moderately successfully) tried to
> take care of.

You don't need a sed expression for that.  In fact the inner
if clause can be replaced by the following line:

	EXTRAVER=${EXTRAVERSION#.}

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
