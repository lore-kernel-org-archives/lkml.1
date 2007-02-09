Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbXBIVdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbXBIVdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 16:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbXBIVdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 16:33:19 -0500
Received: from raven.upol.cz ([158.194.120.4]:46266 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbXBIVdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 16:33:18 -0500
Date: Fri, 9 Feb 2007 22:42:03 +0100
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: The who needs reviews anyways [PATCH]
Message-ID: <20070209214203.GE28386@flower.upol.cz>
References: <Pine.LNX.4.64.0702082227020.14457@scrub.home> <20070209052245.GC28386@flower.upol.cz> <Pine.LNX.4.64.0702091215440.14457@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702091215440.14457@scrub.home>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 09, 2007 at 12:35:04PM +0100, Roman Zippel wrote:
[]
> > > +$(error bash is required to build the kernel)
> > > +endif
> > > +SHELL := $(CONFIG_SHELL)
> > 
> > here is policy to have `bash' introduced, so due to original
> > issue, where `root' users ended with removed /dev/null, may policy to have
> > `non root' user to build kernel be added? Thus
> 
> I doubt gentoo user will like you for that and above is more a de facto 
> requirement that bash is needed for kbuild. The alternative is to 
> introduce a new policy that everything is POSIX clean.

Bad thing is, that `man bash' has no clean line between `sh' and
bash-specific features. POSIX it or `common practice' doesn't matter,
one just must try to test shell scripts with `busybox' or any other `sh'
compatible shell.

> > this:
> > > +	rm -f "$$TMP")
> > 
> > may be removed, and to make TMP=/dev/null? And to forget currently about
> > my silly symlinks, and this crappy sets of output files?
> 
> This still wouldn't work, as these tests are also done when running 'make 
> install'.

and/or "make modules_install", and this must be fixed: to have only one
configuration-run. And then to use its results.

> > > -as-instr = $(call checker-shell,\
> > > -   printf "$(1)" | $(CC) $(AFLAGS) -c -xassembler -o $$OUT -,$(2),$(3))
> > 
> > `printf $(1)' is pretty enough.
> 
> As Andreas suggested 'printf "%b" "$(1)"' would be the other alternative.

It will not help against single double quote in $(1)

____
