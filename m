Return-Path: <linux-kernel-owner+w=401wt.eu-S1946041AbXBILfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946041AbXBILfO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 06:35:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946051AbXBILfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 06:35:14 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:36300 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946041AbXBILfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 06:35:12 -0500
Date: Fri, 9 Feb 2007 12:35:04 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Oleg Verych <olecom@flower.upol.cz>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: The who needs reviews anyways [PATCH]
In-Reply-To: <20070209052245.GC28386@flower.upol.cz>
Message-ID: <Pine.LNX.4.64.0702091215440.14457@scrub.home>
References: <Pine.LNX.4.64.0702082227020.14457@scrub.home>
 <20070209052245.GC28386@flower.upol.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 9 Feb 2007, Oleg Verych wrote:

> > -	  else if [ -x /bin/bash ]; then echo /bin/bash; \
> > -	  else echo sh; fi ; fi)
> > +	  else if [ -x /bin/bash ]; then echo /bin/bash; fi; fi)
> > +ifeq ($(CONFIG_SHELL),)
> > +$(error bash is required to build the kernel)
> > +endif
> > +SHELL := $(CONFIG_SHELL)
> 
> here is policy to have `bash' introduced, so due to original
> issue, where `root' users ended with removed /dev/null, may policy to have
> `non root' user to build kernel be added? Thus

I doubt gentoo user will like you for that and above is more a de facto 
requirement that bash is needed for kbuild. The alternative is to 
introduce a new policy that everything is POSIX clean.

> this:
> > +	rm -f "$$TMP")
> 
> may be removed, and to make TMP=/dev/null? And to forget currently about
> my silly symlinks, and this crappy sets of output files?

This still wouldn't work, as these tests are also done when running 'make 
install'.

> > -as-instr = $(call checker-shell,\
> > -   printf "$(1)" | $(CC) $(AFLAGS) -c -xassembler -o $$OUT -,$(2),$(3))
> 
> `printf $(1)' is pretty enough.

As Andreas suggested 'printf "%b" "$(1)"' would be the other alternative.

bye, Roman
