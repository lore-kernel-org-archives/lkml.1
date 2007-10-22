Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbXJVJNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbXJVJNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 05:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbXJVJNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 05:13:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:52953 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbXJVJNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 05:13:37 -0400
From: Andreas Schwab <schwab@suse.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH] m68k: Use cc-cross-prefix (was: Re: [GI:wqT PULL] kbuild updates - second round)
References: <20071019204415.GA623@uranus.ravnborg.org>
	<Pine.LNX.4.64.0710211956280.6155@anakin>
	<20071021182245.GA5840@uranus.ravnborg.org>
	<Pine.LNX.4.64.0710212028560.6155@anakin>
X-Yow: LOOK!!  Sullen American teens wearing MADRAS shorts and
 ``Flock of Seagulls'' HAIRCUTS!
Date: Mon, 22 Oct 2007 11:13:28 +0200
In-Reply-To: <Pine.LNX.4.64.0710212028560.6155@anakin> (Geert Uytterhoeven's
	message of "Sun\, 21 Oct 2007 20\:29\:29 +0200 \(CEST\)")
Message-ID: <jetzoj1phj.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

>> Did you mean to use $(SUBARCH) here?
                         ^^^^^^^

> Oops, indeed. Sorry, here's a new one...
>
> m68k: Use cc-cross-prefix
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  arch/m68k/Makefile |   10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> --- a/arch/m68k/Makefile
> +++ b/arch/m68k/Makefile
> @@ -13,16 +13,14 @@
>  # Copyright (C) 1994 by Hamish Macdonald
>  #
>  
> -# test for cross compiling
> -COMPILE_ARCH = $(shell uname -m)
> -
>  # override top level makefile
>  AS += -m68020
>  LDFLAGS := -m m68kelf
>  LDFLAGS_MODULE += -T $(srctree)/arch/m68k/kernel/module.lds
> -ifneq ($(COMPILE_ARCH),$(ARCH))
> -	# prefix for cross-compiling binaries
> -	CROSS_COMPILE = m68k-linux-gnu-
> +ifneq ($(SUB_ARCH),$(ARCH))
            ^^^^^^^^

You did test it, didn't you?

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
