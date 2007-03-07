Return-Path: <linux-kernel-owner+w=401wt.eu-S1030747AbXCGACS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030747AbXCGACS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 19:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030748AbXCGACS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 19:02:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:54954 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030747AbXCGACQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 19:02:16 -0500
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [RFC] div64_64 support
Date: Tue, 6 Mar 2007 16:00:55 -0800
Organization: OSDL
Message-ID: <20070306160055.48b201a4@freekitty>
References: <20070223170527.4ca695b2@freekitty>
	<20070305155714.3abe1b5e@freekitty>
	<20070306133404.GA864@one.firstfloor.org>
	<200703061519.20346.dada1@cosmosbay.com>
	<20070306144529.GA2004@one.firstfloor.org>
	<84C47260-4B57-4568-8197-58F438A6F737@e18.physik.tu-muenchen.de>
	<20070306102941.32471d57@freekitty>
	<20070306215349.hquin7d6pfy2n5d2@m.safari.iki.fi>
	<20070306222435.cbpv63ltximq6lrf@m.safari.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Trace: build.pdx.osdl.net 1173225655 31559 10.8.0.54 (7 Mar 2007 00:00:55 GMT)
X-Complaints-To: abuse@osdl.org
NNTP-Posting-Date: Wed, 7 Mar 2007 00:00:55 +0000 (UTC)
X-Newsreader: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007 00:24:35 +0200
Sami Farin <7atbggg02@sneakemail.com> wrote:

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
> 

That code was copy-paste from:
	include/asm-x86_64/bitops.h

So shouldn't both fls() and ffs() be fixed there as well?

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
