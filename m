Return-Path: <linux-kernel-owner+w=401wt.eu-S1423020AbXBHNhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423020AbXBHNhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 08:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423027AbXBHNhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 08:37:24 -0500
Received: from raven.upol.cz ([158.194.120.4]:38030 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423020AbXBHNhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 08:37:23 -0500
Date: Thu, 8 Feb 2007 14:45:34 +0100
To: David Miller <davem@davemloft.net>
Cc: paulus@samba.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: final (Re: Kbuild change breaks the ppc64 build)
Message-ID: <20070208134534.GV22699@flower.upol.cz>
References: <17867.1342.763881.188430@cargo.ozlabs.ibm.com> <20070208124756.GU22699@flower.upol.cz> <20070208.051706.112290704.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070208.051706.112290704.davem@davemloft.net>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Feb 08, 2007 at 05:17:06AM -0800
From: David Miller

> From: Oleg Verych <olecom@flower.upol.cz>
> Date: Thu, 8 Feb 2007 13:47:56 +0100
> 
[]
> > As i have refactored some CC checking code in Kbuild.include, it
> > turned, that some versions of `make' after calling nested functions,
> > add (or leave) prefix whitespace to result, thus ifeq[0] fails:
> 
> That's not it, did you see my fix for this problem posted
> already?

Yes, i did. Thanks, David, for fix and for comprehencive approach.

Kudos to everyone, who was forced to deal with this cr@p. Sorry for my
confusion, that fast commit was a bit of stress.

> The issue is the leading spaces on the first line of the define for
> checker-shell.  Those propagate into the callers, although they are
> reduced down to a single space.

Yes, defines leave spaces/tabs as is, it's known thing, but again,
sorry.

> This will give you spaces in the result on any version of
> make.
> 
> Here is my fix again for your reference.
> 
> diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
> index 8d7eabf..a1880e8 100644
> --- a/scripts/Kbuild.include
> +++ b/scripts/Kbuild.include
> @@ -60,16 +60,15 @@ endef
>  # Usage: option = $(call checker-shell,$(CC)...-o $$OUT,option-ok,otherwise)
>  # Exit code chooses option. $$OUT is safe location for needless output.
>  define checker-shell
> - $(strip
   ^
Roland had no space here in his patch ;)

> -  $(shell set -e; \
> -    DIR=$(KBUILD_EXTMOD); \
> -    cd $${DIR:-$(objtree)}; \
> -    OUT=$$PWD/.$$$$.null; \
> -    if $(1) >/dev/null 2>&1; \
> -      then echo "$(2)"; \
> -      else echo "$(3)"; \
> -    fi; \
> -    rm -f $$OUT))
> +$(shell set -e; \
> +  DIR=$(KBUILD_EXTMOD); \
> +  cd $${DIR:-$(objtree)}; \
> +  OUT=$$PWD/.$$$$.null; \
> +  if $(1) >/dev/null 2>&1; \
> +    then echo "$(2)"; \
> +    else echo "$(3)"; \
> +  fi; \
> +  rm -f $$OUT)
>  endef
>  
>  # as-option
>
> 

Thanks!
____
