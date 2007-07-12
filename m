Return-Path: <linux-kernel-owner+w=401wt.eu-S933309AbXGLB6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933309AbXGLB6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 21:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758156AbXGLB54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 21:57:56 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:36466 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729AbXGLB54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 21:57:56 -0400
Date: Wed, 11 Jul 2007 19:00:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kai@germaschewski.name
Subject: Re: [PATCH] mkmakefile: include ARCH on O= builds
Message-Id: <20070711190030.8c259b5c.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.58.0707120331530.28774@be1.lrz>
References: <Pine.LNX.4.58.0707120331530.28774@be1.lrz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007 03:40:04 +0200 (CEST) Bodo Eggert wrote:

> If you build using O=builddir ARCH=bar, you'll currently need to supply
> ARCH= on builds from the builddir, too. With this patch, the generated
> Makefile will do that instead.
> 
> make ARCH= will still override the Makefile default, allowing existing 
> scripts to work correctly.
> 
> Signed-Off-By: Bodo Eggert <7eggert@gmx.de>
> 
> diff -X dontdiff -pruN linux-2.6.22/Makefile linux-2.6.22.changed/Makefile
> --- linux-2.6.22/Makefile	2007-07-11 23:15:33.000000000 +0200
> +++ linux-2.6.22.changed/Makefile	2007-07-12 02:59:39.000000000 +0200
> @@ -357,7 +357,7 @@ PHONY += outputmakefile
>  outputmakefile:
>  ifneq ($(KBUILD_SRC),)
>  	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/mkmakefile \
> -	    $(srctree) $(objtree) $(VERSION) $(PATCHLEVEL)
> +	    $(srctree) $(objtree) $(VERSION) $(PATCHLEVEL) $(ARCH)
>  endif
>  
>  # To make sure we do not include .config for any of the *config targets
> diff -X dontdiff -pruN linux-2.6.22/scripts/mkmakefile linux-2.6.22.changed/scripts/mkmakefile
> --- linux-2.6.22/scripts/mkmakefile	2006-11-29 22:57:37.000000000 +0100
> +++ linux-2.6.22.changed/scripts/mkmakefile	2007-07-12 03:03:49.000000000 +0200
> @@ -8,6 +8,7 @@
>  # $2 - Output directory
>  # $3 - version
>  # $4 - patchlevel
> +# $5 - patchlevel

should that ^^^^^^ be "arch" ?


>  test ! -r $2/Makefile -o -O $2/Makefile || exit 0
> @@ -21,16 +22,17 @@ PATCHLEVEL = $4
>  
>  KERNELSRC    := $1
>  KERNELOUTPUT := $2
> +ARCH         := $5
>  
>  MAKEFLAGS += --no-print-directory
>  
>  .PHONY: all \$(MAKECMDGOALS)
>  
>  all:
> -	\$(MAKE) -C \$(KERNELSRC) O=\$(KERNELOUTPUT)
> +	\$(MAKE) -C \$(KERNELSRC) O=\$(KERNELOUTPUT) ARCH=\$(ARCH)
>  
>  Makefile:;
>  
>  \$(filter-out all Makefile,\$(MAKECMDGOALS)) %/:
> -	\$(MAKE) -C \$(KERNELSRC) O=\$(KERNELOUTPUT) \$@
> +	\$(MAKE) -C \$(KERNELSRC) O=\$(KERNELOUTPUT) ARCH=\$(ARCH) \$@
>  EOF
> -- 
> The tough part about being an officer is that the troops don't know what
> they want, but they know for certain what they DON'T want.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
