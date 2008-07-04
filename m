Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbYGDGjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbYGDGjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 02:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYGDGiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 02:38:52 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:50573 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbYGDGiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 02:38:52 -0400
Date: Fri, 4 Jul 2008 08:39:38 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: alphabetic ordering of MAINTAINERS
Message-ID: <20080704063938.GA12894@uranus.ravnborg.org>
References: <20080704063455.GA13999@digi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080704063455.GA13999@digi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2008 at 08:34:55AM +0200, Uwe Kleine-König wrote:
> Hello,
> 
> I wanted to add an entry to MAINTAINERS and while doing it I saw that in
> the corresponding region the alphabetic ordering is broken.  Then I
> inteded to fix that up for a trivial patch.  Next was to check the rest
> of the file and there are so much misorderings that it's not sensible to
> choose the trivial path anymore as there are currently 114 entries out
> of order[1].
> 
> Below is a script that shows the misorderings after applying the
> following patch:
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e6c06fa..e9e36f8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1585,7 +1585,7 @@ S:	Supported
>  EMBEDDED LINUX
>  P:	Paul Gortmaker
>  M:	paul.gortmaker@windriver.com
> -P	David Woodhouse
> +P:	David Woodhouse
>  M:	dwmw2@infradead.org
>  L:	linux-embedded@vger.kernel.org
>  S:	Maintained
> 
> IMHO there are two good ways to continue:
>  - just ignore the misorderings; or
>  - write a more clever script that not only shows the misorderings but
>    fixes them and optimally let Linus directly apply it.
> 
> I will try to come up with a script to prepare the second way.

If you succeed doing so it would be very good to fix up
all mail entries to read:

M: Paul Gortmaker <paul.gortmaker@windriver.com>

so they are copy'n'paste friendly.

	Sam




> 
> Best regards
> Uwe
> 
> #! /bin/sh
> 
> tempfile="$(mktemp)";
> 
> # extract topics from MAINTAINERS
> sed -n -e '1,/^P:/d' -e '/^[0-9a-zA-Z][^:]/p' MAINTAINERS >
> "${tempfile}"
> 
> sort "${tempfile}" | diff -u "${tempfile}" -
> 
> rm "${tempfile}"
> 
> [1] ukleinek@zentaur:~/gsrc/linux-2.6$ order_maintainers | grep ^- | wc -l
> 114
> 
> -- 
> Uwe Kleine-König, Software Engineer
> Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
> Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
