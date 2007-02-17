Return-Path: <linux-kernel-owner+w=401wt.eu-S1946393AbXBQDR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946393AbXBQDR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 22:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946392AbXBQDR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 22:17:58 -0500
Received: from raven.upol.cz ([158.194.120.4]:52382 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946391AbXBQDRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 22:17:55 -0500
To: Olaf Hering <olaf@aepfle.de>
Cc: Andrew Morton <akpm@osdl.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: exporting LANG=C (Re: [PATCH] override build timestamp)
In-Reply-To: <20070216215213.GA10732@aepfle.de>
References: <20070216215213.GA10732@aepfle.de>
Date: Sat, 17 Feb 2007 04:27:05 +0100
Message-Id: <E1HIGE5-0003WZ-Ew@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Olaf Hering
> Newsgroups: gmane.linux.kernel
> Subject: [PATCH] override build timestamp
> Date: Fri, 16 Feb 2007 22:52:13 +0100

Hallo, Olaf.

> Pass a timestamp to kbuild via an enviroment variable.
>
>     TZ=UTC BUILD_TIMESTAMP=2007-01-01 make -kj O=../O vmlinux
>
> This can be used when the kernel source is in a SCM and uname -v
> is supposed to give the commit date and not the package build time.

While adding this functionality must be decided by kbuild developers,
could you make separate patch with exporting 'LANG=C' on the very
beginning and delete all other occurrences of it? It's a C header file
generation and afaik, it must be ASCII.

Thanks.

> Signed-off-by: Olaf Hering <olaf@aepfle.de>
>
> ---
>  scripts/mkcompile_h |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> Index: linux-2.6/scripts/mkcompile_h
>===================================================================
> --- linux-2.6.orig/scripts/mkcompile_h
> +++ linux-2.6/scripts/mkcompile_h
> @@ -30,7 +30,12 @@ UTS_VERSION="#$VERSION"
>  CONFIG_FLAGS=""
>  if [ -n "$SMP" ] ; then CONFIG_FLAGS="SMP"; fi
>  if [ -n "$PREEMPT" ] ; then CONFIG_FLAGS="$CONFIG_FLAGS PREEMPT"; fi
> -UTS_VERSION="$UTS_VERSION $CONFIG_FLAGS `LC_ALL=C LANG=C date`"
> +if [ -n "$BUILD_TIMESTAMP" ]; then
> +  TIMESTAMP="`LC_ALL=C LANG=C date -d "$BUILD_TIMESTAMP"`"
> +else
> +  TIMESTAMP="`LC_ALL=C LANG=C date`"
> +fi
> +UTS_VERSION="$UTS_VERSION $CONFIG_FLAGS $TIMESTAMP"
>  
>  # Truncate to maximum length
>  
