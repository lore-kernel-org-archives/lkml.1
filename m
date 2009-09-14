Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbZINVrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbZINVrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 17:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755376AbZINVrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 17:47:11 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:45070 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbZINVrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 17:47:10 -0400
Date: Mon, 14 Sep 2009 23:47:11 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [1/5] kbuild: Fix ld-option Makefile macro to really
	work
Message-ID: <20090914214711.GB7990@merkur.ravnborg.org>
References: <200909141018.915641783@firstfloor.org> <20090914201806.EE6A0B1757@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914201806.EE6A0B1757@basil.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 10:18:06PM +0200, Andi Kleen wrote:
> 
> Needed for the next patch
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  scripts/Kbuild.include |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.31-rc1-ak/scripts/Kbuild.include
> ===================================================================
> --- linux-2.6.31-rc1-ak.orig/scripts/Kbuild.include
> +++ linux-2.6.31-rc1-ak/scripts/Kbuild.include
> @@ -83,11 +83,12 @@ TMPOUT := $(if $(KBUILD_EXTMOD),$(firstw
>  # is automatically cleaned up.
>  try-run = $(shell set -e;		\
>  	TMP="$(TMPOUT).$$$$.tmp";	\
> +	TMPO="$(TMPOUT).$$$$.o";	\
>  	if ($(1)) >/dev/null 2>&1;	\
>  	then echo "$(2)";		\
>  	else echo "$(3)";		\
>  	fi;				\
> -	rm -f "$$TMP")
> +	rm -f "$$TMP" "$$TMPO")
>  
>  # as-option
>  # Usage: cflags-y += $(call as-option,-Wa$(comma)-isa=foo,)
> @@ -133,7 +134,7 @@ cc-ifversion = $(shell [ $(call cc-versi
>  # ld-option
>  # Usage: ldflags += $(call ld-option, -Wl$(comma)--hash-style=both)
>  ld-option = $(call try-run,\
> -	$(CC) $(1) -nostdlib -xc /dev/null -o "$$TMP",$(1),$(2))
> +	$(CC) /dev/null -c -o "$$TMPO" ; $(LD) $(1) "$$TMPO" -o "$$TMP",$(1),$(2))
>  
>  ######

So now we pass the option direct to the linker rather than via gcc -wl.
I assume this breaks the other 8 uses of ld-option in the kernel?

Or does ld understand the -wl,... syntax?

	Sam
