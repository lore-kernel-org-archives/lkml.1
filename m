Return-Path: <linux-kernel-owner+w=401wt.eu-S1758966AbXJLIep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966AbXJLIep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 04:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbXJLIei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 04:34:38 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:58920 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731AbXJLIeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 04:34:37 -0400
Date: Fri, 12 Oct 2007 10:36:08 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-mm1
Message-ID: <20071012083608.GA18235@uranus.ravnborg.org>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <20071012140328.f82af8e8.kamezawa.hiroyu@jp.fujitsu.com> <20071011234202.2f15bb76.akpm@linux-foundation.org> <20071012162546.d70f2309.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071012162546.d70f2309.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > 
> > > $(ARCH) cannot be detected automatically...
> > 
> > So you need to set $ARCH by hand?  I always do that so I didn't notice this.
> > 
> Yes, I need to set it by hand.
> 
> This is a quick fix for me......
> Maybe $(ARCH) should be undefined until following .kbuild check.
> 
> ifneq ($(wildcard .kbuild),)
>   ...
> else
>   ARCH ?= $(SUBARCH)
> endif
> 
> -Kame
> 
> --
> Index: ref-2.6.23-mm1/Makefile
> ===================================================================
> --- ref-2.6.23-mm1.orig/Makefile
> +++ ref-2.6.23-mm1/Makefile
> @@ -191,7 +191,6 @@ SUBARCH := $(shell uname -m | sed -e s/i
>  
>  # The empty ARCH and CROSS_COMPILE statements exist so it is easy to
>  # patch in hardcoded values for ARCH and CROSS_COMPILE
> -ARCH		?=
>  CROSS_COMPILE	?=
>  
>  # Kbuild save the ARCH and CROSS_COMPILE setting in .kbuild

That line came in on request from Andi/Novell.
And I tested it regioursly with several of my cross compile setups.
But never with native - silly me.

But that patch has other issues too so I will withdraw it
until I have fixed the other annoying issues.
We are simply to gcc happy in the top-lvel makefile and
we run it several times for no good reasons when we for example do
maouldes_install or headers_isntall.

	Sam
