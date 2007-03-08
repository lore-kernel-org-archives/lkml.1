Return-Path: <linux-kernel-owner+w=401wt.eu-S933177AbXCHTdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177AbXCHTdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 14:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933185AbXCHTdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 14:33:54 -0500
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168]:36334 "EHLO
	pne-smtpout4-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933187AbXCHTdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 14:33:52 -0500
X-Greylist: delayed 4191 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Mar 2007 14:33:52 EST
Date: Thu, 8 Mar 2007 20:23:57 +0200
From: Sami Farin <7atbggg02@sneakemail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: asm volatile [Was: [RFC] div64_64 support]
Message-ID: <20070308182357.nnpvhqqj5qqk2vsx@m.safari.iki.fi>
Mail-Followup-To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20070223170527.4ca695b2@freekitty> <20070305155714.3abe1b5e@freekitty> <20070306133404.GA864@one.firstfloor.org> <200703061519.20346.dada1@cosmosbay.com> <20070306144529.GA2004@one.firstfloor.org> <84C47260-4B57-4568-8197-58F438A6F737@e18.physik.tu-muenchen.de> <20070306102941.32471d57@freekitty> <20070306215349.hquin7d6pfy2n5d2@m.safari.iki.fi> <20070306222435.cbpv63ltximq6lrf@m.safari.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306222435.cbpv63ltximq6lrf@m.safari.iki.fi>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 00:24:35 +0200, Sami Farin wrote:
> On Tue, Mar 06, 2007 at 23:53:49 +0200, Sami Farin wrote:
> ...
> > And I found bug in gcc-4.1.2, it gave 0 for ncubic results
> > when doing 1000 loops test... gcc-4.0.3 works.
> 
> Found it.
> 
> --- cbrt-test.c~	2007-03-07 00:20:54.735248105 +0200
> +++ cbrt-test.c	2007-03-07 00:21:03.964864343 +0200
> @@ -209,7 +209,7 @@
>  
>  	__asm__("bsrl %1,%0\n\t"
>  		"cmovzl %2,%0"
> -		: "=&r" (r) : "rm" (x), "rm" (-1));
> +		: "=&r" (r) : "rm" (x), "rm" (-1) : "memory");
>  	return r+1;
>  }
>  
> Now Linux 2.6 does not have "memory" in fls, maybe it causes
> some gcc funnies some people are seeing.

It also works without "memory" if I do "__asm__ volatile".

Why some functions have volatile and some have not in include/asm-*/*.h ?

-- 
