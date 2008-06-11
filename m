Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbYFKTsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbYFKTsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 15:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756045AbYFKTsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 15:48:33 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35219 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763AbYFKTsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 15:48:32 -0400
Date: Wed, 11 Jun 2008 21:49:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild breaks um - fails to find util when linking
Message-ID: <20080611194914.GB12794@uranus.ravnborg.org>
References: <20080610190307.GA15983@uranus.ravnborg.org> <20080611154816.GA8167@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080611154816.GA8167@c2.user-mode-linux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 11:48:16AM -0400, Jeff Dike wrote:
> This patch obviously isn't usable for anyone else, but UML needs a
> hook or something to add libgcc and libc to the ld commands:
> 
> Index: linux-2.6-git/scripts/link-vmlinux.sh
> ===================================================================
> --- linux-2.6-git.orig/scripts/link-vmlinux.sh	2008-06-11 11:26:07.000000000 -0400
> +++ linux-2.6-git/scripts/link-vmlinux.sh	2008-06-11 11:41:04.000000000 -0400
> @@ -122,7 +122,7 @@ fi
>  # First stage of fully linked vmlinux
>  tell LD ${VMLINUX}
>  ${LD} ${LDFLAGS} ${LDFLAGS_vmlinux} -o ${VMLINUX} \
> -      -T ${KBUILD_VMLINUX_LDS} vmlinux.o
> +      -T ${KBUILD_VMLINUX_LDS} vmlinux.o `gcc -print-libgcc-file-name` -lc
>  
>  if [ "${CONFIG_KALLSYMS}" = "y" ]; then
>  
> @@ -133,7 +133,8 @@ if [ "${CONFIG_KALLSYMS}" = "y" ]; then
>          # link in kalll symbols
>  	tell LD vmlinux
>          ${LD} ${LDFLAGS} ${LDFLAGS_vmlinux} -o vmlinux \
> -         -T ${KBUILD_VMLINUX_LDS} vmlinux.o .tmp_kallsyms.o
> +         -T ${KBUILD_VMLINUX_LDS} vmlinux.o .tmp_kallsyms.o \
> +	    `gcc -print-libgcc-file-name` -lc
>  fi
>  
>  tell SYSMAP System.map
> 
> This fixes the flood of undefined symbols, but I still get this on the
> link:
>     ld: warning: Cannot create .note.gnu.build-id section, --build-id ignored.
>     ld: warning: cannot find entry symbol _start; defaulting to 08056320
> 
> And when I run the result, I get this, which I don't understand at
> all:
> 
>     -bash: ./uml/linux: /usr/lib/libc.so.1: bad ELF interpreter: No
> such file or directory

Thanks Jeff.

I will take an additional look tomorrow.

	Sam
