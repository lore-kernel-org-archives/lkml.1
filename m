Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823AbZIGNJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbZIGNJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 09:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbZIGNJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 09:09:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36614 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbZIGNJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 09:09:13 -0400
Date: Mon, 7 Sep 2009 15:09:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig CROSS_COMPILE option
Message-ID: <20090907130402.GB1595@ucw.cz>
References: <20090905002947.A4C678BEB1@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090905002947.A4C678BEB1@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This adds CROSS_COMPILE as a kconfig string so you can store it in .config.
> Then you can use plain "make" in the configured kernel build directory to
> do the right cross compilation without setting the command-line or
> environment variable every time.
> 
> With this, you can set up different build directories for different kernel
> configurations, whether native or cross-builds, and then use the simple:
> 	make -C /build/dir M=module-source-dir
> idiom to build modules for any given target kernel, indicating which one
> by nothing but the build directory chosen.
> 
> I tried a version that defaults the string with env="CROSS_COMPILE" so that
> in a "make oldconfig" with CROSS_COMPILE in the environment you can just
> hit return to store the way you're building it.  But the kconfig prompt for
> strings doesn't give you any way to say you want an empty string instead of
> the default, so I punted that.

Yes that would be very nice. Editing Makefile every time I
crosscomppile for arm sucks.

But... do we need an option for subarch, too? And will Kconfig system
handle that?
									Pavel

>  # Alternatively CROSS_COMPILE can be set in the environment.
> +# A third alternative is to store a setting in .config so that plain
> +# "make" in the configured kernel build directory always uses that.
>  # Default value for CROSS_COMPILE is not to prefix executables
>  # Note: Some architectures assign CROSS_COMPILE in their arch/*/Makefile
>  export KBUILD_BUILDHOST := $(SUBARCH)
>  ARCH		?= $(SUBARCH)
> -CROSS_COMPILE	?=
> +CROSS_COMPILE	?= $(CONFIG_CROSS_COMPILE:"%"=%)
>  
>  # Architecture as present in compile.h
>  UTS_MACHINE 	:= $(ARCH)
> diff --git a/init/Kconfig b/init/Kconfig
> index 3f7e609..452080d 100644

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
