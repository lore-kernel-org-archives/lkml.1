Return-Path: <linux-kernel-owner+w=401wt.eu-S932975AbYBNNdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975AbYBNNdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 08:33:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYBNNd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 08:33:28 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:54992 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755022AbYBNNcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 08:32:54 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FABfSs0dMQWYv/2dsb2JhbACBWZA7nFs
Date: Thu, 14 Feb 2008 08:27:52 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Sam Ravnborg <sam@ravnborg.org>, Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] samples: build fix
Message-ID: <20080214132752.GA27478@Krystal>
References: <20080214034541.EF1BD270192@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080214034541.EF1BD270192@magilla.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:24:48 up 3 days,  9:25,  3 users,  load average: 0.07, 0.15,
	0.25
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roland McGrath (roland@redhat.com) wrote:
> 
> The samples/ subdirectory contains only modules.
> But the only make run done there is in commands for vmlinux.
> I can't see why this was ever done in this nonstandard fashion.
> As things stand, the modules don't get built by 'make modules'.
> 
> I didn't make the addition of the directory use core-$(CONFIG_SAMPLES)
> because there is no other conditional like that in the top-level Makefile
> and samples/Makefile already uses obj-$(CONFIG_SAMPLES) as if it expects
> always to be included.
> 

Sam, is this ok with the samples intent ? I think as long as we do not
include them with the kernel image and have a "make samples" to build
them, it's ok. Having them built upon make modules seems like a good
idea to me.

Mathieu

> Signed-off-by: Roland McGrath <roland@redhat.com>
> ---
>  Makefile |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index c162370..9e9ce33 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -602,7 +602,7 @@ export mod_strip_cmd
>  
>  
>  ifeq ($(KBUILD_EXTMOD),)
> -core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
> +core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/ samples/
>  
>  vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
>  		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
> @@ -802,9 +802,6 @@ vmlinux: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o $(kallsyms.o)
>  ifdef CONFIG_HEADERS_CHECK
>  	$(Q)$(MAKE) -f $(srctree)/Makefile headers_check
>  endif
> -ifdef CONFIG_SAMPLES
> -	$(Q)$(MAKE) $(build)=samples
> -endif
>  	$(call vmlinux-modpost)
>  	$(call if_changed_rule,vmlinux__)
>  	$(Q)rm -f .old_version

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
