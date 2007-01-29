Return-Path: <linux-kernel-owner+w=401wt.eu-S1751569AbXA2Oag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbXA2Oag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 09:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbXA2Oag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 09:30:36 -0500
Received: from main.gmane.org ([80.91.229.2]:60042 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbXA2Oag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 09:30:36 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: [PATCH] `make help' in build tree doesn't show headers_* targets
Date: Mon, 29 Jan 2007 14:30:17 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrners1o9.f71.olecom@flower.upol.cz>
References: <Pine.LNX.4.62.0701291346210.17426@pademelon.sonytel.be>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: flower.upol.cz
Mail-Followup-To: LKML <linux-kernel@vger.kernel.org>, Oleg Verych <olecom@flower.upol.cz>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@linux-foundation.org>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, Sam Ravnborg <sam@ravnborg.org>
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Geert Uytterhoeven
> Newsgroups: gmane.linux.kernel
> Subject: [PATCH] `make help' in build tree doesn't show headers_* targets
> Date: Mon, 29 Jan 2007 13:47:01 +0100 (CET)

> `make help' in the build tree doesn't show the help texts about the
> `headers_install' and `headers_check' targets because it looks for
> include/asm-$(ARCH)/Kbuild in the wrong place.
> Add the missing `$(srctree)' prefixes to fix this.
> Also move the printing of the default install path for the headers inside the
> `if/fi', where it belongs.
>
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> ---
>  Makefile |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)

Acked-by: Oleg Verych <olecom@flower.upol.cz>


> --- ps3-linux-src-2.6.20-rc6.orig/Makefile
> +++ ps3-linux-src-2.6.20-rc6/Makefile
> @@ -1116,15 +1116,15 @@ help:
>  	@echo  '  cscope	  - Generate cscope index'
>  	@echo  '  kernelrelease	  - Output the release version string'
>  	@echo  '  kernelversion	  - Output the version stored in Makefile'
> -	@if [ -r include/asm-$(ARCH)/Kbuild ]; then \
> +	@if [ -r $(srctree)/include/asm-$(ARCH)/Kbuild ]; then \
>  	 echo  '  headers_install - Install sanitised kernel headers to INSTALL_HDR_PATH'; \
> +	 echo  '                    (default: $(INSTALL_HDR_PATH))'; \
>  	 fi
> -	@echo  '                    (default: $(INSTALL_HDR_PATH))'
>  	@echo  ''
>  	@echo  'Static analysers'
>  	@echo  '  checkstack      - Generate a list of stack hogs'
>  	@echo  '  namespacecheck  - Name space analysis on compiled kernel'
> -	@if [ -r include/asm-$(ARCH)/Kbuild ]; then \
> +	@if [ -r $(srctree)/include/asm-$(ARCH)/Kbuild ]; then \
>  	 echo  '  headers_check   - Sanity check on exported headers'; \
>  	 fi
>  	@echo  ''
>
> Gr{oetje,eeting}s,
>
> 						Geert
>
> --
> Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
> Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
> Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium

