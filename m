Return-Path: <linux-kernel-owner+w=401wt.eu-S1762476AbXKQR0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762476AbXKQR0p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 12:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbXKQR0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 12:26:37 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:39233 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233AbXKQR0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 12:26:37 -0500
Date: Sat, 17 Nov 2007 18:28:16 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andreas Mohr <andi@lisas.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
       Herbert Xu <herbert@gondor.apana.org.au>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC] eradicate bashisms in scripts/patch-kernel
Message-ID: <20071117172816.GC7213@uranus.ravnborg.org>
References: <20071101121133.GA14807@rhlx01.hs-esslingen.de> <20071101082457.ff9a5d67.randy.dunlap@oracle.com> <20071101221606.GA10116@rhlx01.hs-esslingen.de> <20071101160857.6e877307.rdunlap@xenotime.net> <20071102020118.GA13852@gondor.apana.org.au> <20071102200935.GA14153@rhlx01.hs-esslingen.de> <20071102131707.6023a5b7.rdunlap@xenotime.net> <20071105195827.GA24117@rhlx01.hs-esslingen.de> <20071114144627.8628f2dd.rdunlap@xenotime.net> <20071117163327.GA4296@rhlx01.hs-esslingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071117163327.GA4296@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2007 at 05:33:27PM +0100, Andreas Mohr wrote:
> Hi,
> 
> On Wed, Nov 14, 2007 at 02:46:27PM -0800, Randy Dunlap wrote:
> > On Mon, 5 Nov 2007 20:58:27 +0100 Andreas Mohr wrote:
> > > Feel free to go ahead, otherwise I'll try another patch sometime soon.
> > > All I care about is that the result works on (at least)
> > > one shell implementation _more_ than the current status ;)
> > 
> > Hi Andreas,
> > 
> > Can you comment on (or test) whether this patch is sufficient
> > for your needs?  And if so, is the Signed-off-by: A.M. OK?
> 
> Sorry, no, using dash (0.5.3-5) there's still a remaining
> 
> $ linux-2.6.22/scripts/patch-kernel linux-2.6.22 /usr/src/patch-2.6
> Current kernel version is 2.6.22 ( Holy Dancing Manatees, Batman!)
> linux-2.6.22/scripts/patch-kernel: 207: Syntax error: Bad substitution
> 
> error in the
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
> 
> The good part of the story is that the current corrected almost fully
> working version still works with bash (3.1dfsg-8), just like the
> original patch-kernel version.

Could you (or Randy) fix it up with the comment from Herbert
and submit the final version to me (with proper changelog and s-o-b).

Thanks,
	Sam
