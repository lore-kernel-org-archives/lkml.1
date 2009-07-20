Return-Path: <linux-kernel-owner+w=401wt.eu-S1753688AbZGTVFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbZGTVFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 17:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbZGTVFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 17:05:33 -0400
Received: from mail-yx0-f197.google.com ([209.85.210.197]:61068 "EHLO
	mail-yx0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbZGTVFc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 17:05:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Fe4WqOFCHttorLG3VeyKGqX60UAc9u3I+LNUBzBReupoRz1iAwVYncnu4VW7sXwzmI
         F5veWLtQTjjIyFKBn+Cd4/+FVCK0eIhXxoqN/M5CRjfbEPBFNOC8vcOZ5Gq+arz35PN9
         JJbESca2N+KK+E50euSIwmkGzYd6yp/uJxsjg=
MIME-Version: 1.0
In-Reply-To: <20090720200522.GA6854@merkur.ravnborg.org>
References: <20090720100157.GA6467@merkur.ravnborg.org> <1248086059.15751.8405.camel@twins> 
	<20090720115134.GA6517@merkur.ravnborg.org> <1248091243.15751.8550.camel@twins> 
	<20090720171200.GA6730@merkur.ravnborg.org> <20090720200522.GA6854@merkur.ravnborg.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 20 Jul 2009 17:05:12 -0400
Message-ID: <8bd0f97a0907201405s5d6f79e7me82cd7ca05daaf3a@mail.gmail.com>
Subject: Re: [PATCH] kbuild: save ARCH & CROSS_COMPILE when building a kernel
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 16:05, Sam Ravnborg wrote:
> --- a/arch/blackfin/Makefile
> +++ b/arch/blackfin/Makefile
> @@ -155,7 +155,7 @@ define archhelp
>   echo  '* vmImage.gz      - Kernel-only image for U-Boot (arch/$(ARCH)/boot/vmImage.gz)'
>   echo  '  vmImage.lzma    - Kernel-only image for U-Boot (arch/$(ARCH)/boot/vmImage.lzma)'
>   echo  '  install         - Install kernel using'
> -  echo  '                     (your) ~/bin/$(CROSS_COMPILE)installkernel or'
> -  echo  '                     (distribution) PATH: $(CROSS_COMPILE)installkernel or'
> +  echo  '                     (your) ~/bin/$(INSTALLKERNEL) or'
> +  echo  '                     (distribution) PATH: $(INSTALLKERNEL) or'
>   echo  '                     install to $$(INSTALL_PATH)'
>  endef
> diff --git a/arch/blackfin/boot/install.sh b/arch/blackfin/boot/install.sh
> index 9560a6b..e2c6e40 100644
> --- a/arch/blackfin/boot/install.sh
> +++ b/arch/blackfin/boot/install.sh
> @@ -36,9 +36,9 @@ verify "$3"
>
>  # User may have a custom install script
>
> -if [ -x ~/bin/${CROSS_COMPILE}installkernel ]; then exec ~/bin/${CROSS_COMPILE}installkernel "$@"; fi
> -if which ${CROSS_COMPILE}installkernel >/dev/null 2>&1; then
> -       exec ${CROSS_COMPILE}installkernel "$@"
> +if [ -x ~/bin/${INSTALLKERNEL} ]; then exec ~/bin/${INSTALLKERNEL} "$@"; fi
> +if which ${INSTALLKERNEL} >/dev/null 2>&1; then
> +       exec ${INSTALLKERNEL} "$@"
>  fi
>
>  # Default install - same as make zlilo

np with this, Acked-by-me
-mike
