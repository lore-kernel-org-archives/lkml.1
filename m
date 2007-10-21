Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbXJURcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbXJURcm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 13:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbXJURcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 13:32:35 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:46678 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbXJURce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 13:32:34 -0400
Date: Sun, 21 Oct 2007 19:34:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Bryan Wu <bryan.wu@analog.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [GIT-PULL Part #2] Blackfin arch fixing and updates for 2.6.24 merge windows
Message-ID: <20071021173401.GA5550@uranus.ravnborg.org>
References: <1192985586.6234.11.camel@roc-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192985586.6234.11.camel@roc-laptop>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan.

> diff --git a/arch/blackfin/Makefile b/arch/blackfin/Makefile
> index 3689337..3c87291 100644
> --- a/arch/blackfin/Makefile
> +++ b/arch/blackfin/Makefile
> @@ -12,12 +12,17 @@ LDFLAGS_vmlinux  := -X
>  OBJCOPYFLAGS     := -O binary -R .note -R .comment -S
>  GZFLAGS          := -9
>  
> +CFLAGS           += $(call cc-option,-mno-fdpic)
> +AFLAGS           += $(call cc-option,-mno-fdpic)
>  CFLAGS_MODULE    += -mlong-calls
>  KALLSYMS         += --symbol-prefix=_

During the merge window kbuild shifted to use KBUILD_CFLAGS
and KBUILD_AFLAGS so you need to update the above two assignments.

I think it works as is but then you cannot pass additional CFLAGS
from the commandline.

	Sam
