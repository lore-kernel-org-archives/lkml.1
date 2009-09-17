Return-Path: <linux-kernel-owner+w=401wt.eu-S1757019AbZIQLpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbZIQLpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 07:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756868AbZIQLpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 07:45:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60600 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829AbZIQLpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 07:45:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Caveh Jalali <ecaveh@gmail.com>
Subject: Re: [patch] Makefile: can't build modules outside the kernel tree if it was built using O=
Date: Thu, 17 Sep 2009 13:45:30 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-9-generic; KDE/4.3.1; x86_64; ; )
Cc: sam@ravnborg.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <830a8fa70909161930r518a9644ja954ced2ae5814b4@mail.gmail.com>
In-Reply-To: <830a8fa70909161930r518a9644ja954ced2ae5814b4@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909171345.30988.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+WV7YiTeFIXFc5903MiEKw7FdctsKtdJTFp6B
 a+iVwQbYQAPg0DdsvjlN+Rcs0j8AXn6FCwFm8jN4cXPoy1/1sY
 ovwGVmhksT6phrCUqoGmA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 September 2009, Caveh Jalali wrote:

> when the platform specific include directories were shuffled around
> without updating the
> top level Makefile.  however, i think this FAIL is generic, and not
> limited to powerpc.
> here's a patch to the top level Makefile to teach it about the shuffled files:
> 
> 
> --- /local/caveh/linux/linux-2.6.31/Makefile    2009-09-09
> 15:13:59.000000000 -0700
> +++ Makefile    2009-09-16 12:23:05.000000000 -0700
> @@ -958,9 +958,9 @@ ifneq ($(KBUILD_SRC),)
>                 echo "  in the '$(srctree)' directory.";\
>                 /bin/false; \
>         fi;
> -       $(Q)if [ ! -d include2 ]; then                                  \
> -           mkdir -p include2;                                          \
> -           ln -fsn $(srctree)/include/asm-$(SRCARCH) include2/asm;     \
> +       $(Q)if [ ! -d include2 ]; then                                   \
> +           mkdir -p include2;                                           \
> +           ln -fsn $(srctree)/arch/$(SRCARCH)/include/asm include2/asm; \
>         fi
>  endif

I think we should no longer have the include2 directory at all with new kernels.

LINUXINCLUDE already contains the right path in theory:

LINUXINCLUDE    := -Iinclude \
                   $(if $(KBUILD_SRC),-Iinclude2 -I$(srctree)/include) \
                   -I$(srctree)/arch/$(hdr-arch)/include               \
                   -include include/linux/autoconf.h

I'm not sure what goes wrong here. What is the gcc command line you see?

	Arnd <><
