Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbXISU2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbXISU2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 16:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbXISU2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 16:28:09 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:40888 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbXISU2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 16:28:08 -0400
Date: Wed, 19 Sep 2007 10:47:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Philipp Marek <philipp@marek.priv.at>
Cc: Jeff Dike <jdike@addtoit.com>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: Re: UML dead with current -git?
Message-Id: <20070919104703.4c9d432f.randy.dunlap@oracle.com>
In-Reply-To: <200709191817.51921@x5>
References: <200709181714.34035@x5>
	<200709191443.24158@x5>
	<20070919085032.dd5c1732.randy.dunlap@oracle.com>
	<200709191817.51921@x5>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 18:17:51 +0200 Philipp Marek wrote:

> Hello Randy!
> 
> On Wednesday 19 September 2007 Randy Dunlap wrote:
> > Yes, I've tried to coerce the top-level Makefile into honoring/using
> > the include/asm symlink if it exists, i.e., taking ARCH from
> > readlink include/asm && sed -e 's/include-asm//', but sadly my
> > makefile foo was not good enough.
> How about that?
> 	readlink include/asm
> returns
> 	asm-um
> in my case, so I only have to strip the "asm-" part ...
> 
> 
> Regards,
> 
> Phil
> 
> 
> diff --git a/Makefile b/Makefile
> index e0fdf49..c9284ba 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -163,6 +163,9 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
>                                   -e s/s390x/s390/ -e s/parisc64/parisc/ \
>                                   -e s/ppc.*/powerpc/ -e s/mips.*/mips/ )
> 
> +# sadly perl is defined below ... so we can't use it here, can we?
> +ASMARCH        := $(shell test -s include/asm && readlink include/asm | cut -f2 -d-)
> +
>  # Cross compiling and selecting different set of gcc/bin-utils
>  # ---------------------------------------------------------------------------
>  #
> @@ -182,7 +185,7 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
>  # Default value for CROSS_COMPILE is not to prefix executables
>  # Note: Some architectures assign CROSS_COMPILE in their arch/*/Makefile
> 
> -ARCH           ?= $(SUBARCH)
> +ARCH           ?= $(or $(SUBARCH), $(ASMARCH))
>  CROSS_COMPILE  ?=
> 
>  # Architecture as present in compile.h
> 
> 
> -- 

This doesn't work when there is no include/asm symlink.

It also didn't apply cleanly due to tab(s) being converted
to spaces (but of course I fixed that part).

---
~Randy
