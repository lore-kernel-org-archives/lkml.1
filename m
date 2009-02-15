Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbZBOK7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbZBOK7I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 05:59:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbZBOK6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 05:58:53 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42860 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbZBOK6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 05:58:52 -0500
Date: Sun, 15 Feb 2009 12:16:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KBUILD: Create the source symlink earlier in the objdir
Message-ID: <20090215111608.GE26292@one.firstfloor.org>
References: <20090110035613.GA7225@basil.nowhere.org> <20090215103659.GC31088@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090215103659.GC31088@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/Makefile b/Makefile
> index 22d7584..76ee131 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -388,6 +388,7 @@ PHONY += outputmakefile
>  # separate output directory. This allows convenient use of make in the
>  # output directory.
>  outputmakefile:
> +	$(Q)ln -fsn $(srctree) source
>  ifneq ($(KBUILD_SRC),)

Haven't tried it, but
doesn't that create the symlink in the non separate objdir case too
because it's outside the ifneq?

>  	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/mkmakefile \
>  	    $(srctree) $(objtree) $(VERSION) $(PATCHLEVEL)
> @@ -946,7 +947,6 @@ ifneq ($(KBUILD_SRC),)
>  	    mkdir -p include2;                                          \
>  	    ln -fsn $(srctree)/include/asm-$(SRCARCH) include2/asm;     \
>  	fi
> -	ln -fsn $(srctree) source
>  endif

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
