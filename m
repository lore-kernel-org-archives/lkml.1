Return-Path: <linux-kernel-owner+w=401wt.eu-S932164AbZISIHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164AbZISIHI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 04:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbZISIHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 04:07:05 -0400
Received: from [195.41.46.236] ([195.41.46.236]:38687 "EHLO pfepb.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbZISIHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 04:07:03 -0400
Date: Sat, 19 Sep 2009 10:07:00 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/2] kbuild: Add a really-ld-option macro
Message-ID: <20090919080700.GA25811@merkur.ravnborg.org>
References: <200909161036.346507799@firstfloor.org> <20090916203654.6AF88B1755@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090916203654.6AF88B1755@basil.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 10:36:54PM +0200, Andi Kleen wrote:
> 
> Different from the existing ld macro by checking $(LD)
> 
> Needed for the next patch
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  scripts/Kbuild.include |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.31-ak/scripts/Kbuild.include
> ===================================================================
> --- linux-2.6.31-ak.orig/scripts/Kbuild.include
> +++ linux-2.6.31-ak/scripts/Kbuild.include
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
> @@ -135,6 +136,12 @@ cc-ifversion = $(shell [ $(call cc-versi
>  ld-option = $(call try-run,\
>  	$(CC) $(1) -nostdlib -xc /dev/null -o "$$TMP",$(1),$(2))
>  
> +# really-ld-option
> +# checks $(LD) unlike ld-option
> +# Usage: LDFLAGS += $(call really-ld-option, -X)
> +really-ld-option = $(call try-run,\
> +	$(CC) /dev/null -c -o "$$TMPO" ; $(LD) $(1) "$$TMPO" -o "$$TMP",$(1),$(2))
> +

kbuild has some strange marcro names - but adding more is no good.
I will:
1) rename ld-option to cc-ldoption
2) add ld-option, and _document_ it in makefiles.txt
3) use ld-option for the -X option

I had preferred your patchset did so.

	Sam
