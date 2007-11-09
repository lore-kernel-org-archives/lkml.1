Return-Path: <linux-kernel-owner+w=401wt.eu-S1758039AbXKIXGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039AbXKIXGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbXKIXGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:06:34 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:41237 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbXKIXGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:06:33 -0500
Date: Sat, 10 Nov 2007 00:08:12 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/11 v3] enable "make ARCH=x86"
Message-ID: <20071109230812.GA5176@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With this patchset the former ARCH=i386 / ARCH=x86_64 are
replaced by ARCH=x86.
The rationale behind the patchset are that with a
unified x86 architecture this should be reflected in
the build commands.

With this patch set the 32/64 bit selection is done
at configuration time like we know it from parisc and
powerpc.

Please pull to your cleanup branch:

	ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/x86.git

I leave it to you (x86 maintainers) to decide when to push this to Linus.
But I strongly suggest sooner is better so we finish the build parts
of the x86 unification.

It has been asked: what about "make ARCH=x86_64 allmodconfig"
Here Adrian posted the receipe:

$ cat myconfig
CONFIG_X86_32=n
CONFIG_X86_64=y
$ make allmodconfig KCONFIG_ALLCONFIG=myconfig

Not a simple as before but far more powerfull.

The patchset does not only enable ARCH=x86 but is also
a nice cleanup as the diffstat tells us:

 15 files changed, 579 insertions(+), 1173 deletions(-)

The majority of the changes are due to the unification
the Kconfig files for 32 and 64 bit.


The shortlog is here:

      x86: unification of cfufreq/Kconfig
      x86: start unification of arch/x86/Kconfig.*
      x86: arch/x86/Kconfig.cpu unification
      x86: add X86_32 dependency to i386 specific symbols in Kconfig.i386
      x86: add X86_64 dependency to x86_64 specific symbols in Kconfig.x86_64
      x86: copy x86_64 specific Kconfig symbols to Kconfig.i386
      x86: move all simple arch settings to Kconfig
      x86: move the rest of the menu's to Kconfig

The first 8 patches are just unification of the Kconfig files.
All comments from previous postings has been incorporated.

      x86: enable "make ARCH=x86"

This is the patch that get rid of ARCH=i386 and ARCH=x86_64
and introduce ARCH=x86.
It touches several files but the changes are all one or two-liners.

      x86: drop backward compatibility symlinks to i386/boot and x86_64/boot
      kbuild: sanity check the specified arch

The last two patches are nice bonus patches.
The fist kill the symlinks to bzImage.
Now that we changed everything else to x86 there is no reason to
keep the backward compatibility symlinks
It is now people know we are unifying {i386,x86_64}=>x86 so the
will not be too suprised seeing some breakage.
If we do not kill the symlinks now - then when..

The last patch is a simple sanity check that make sure the
specified ARCH is valid - and hints that x86 is now used.


I have doen a limited number of builds here at home - all with success.
And others have reported success with the previous patchset.

The full diffstat:

 Makefile                                           |    9 +-
 arch/x86/{Kconfig.i386 => Kconfig}                 |  570 ++++++++++---
 arch/x86/Kconfig.cpu                               |  121 ++--
 arch/x86/Kconfig.x86_64                            |  839 --------------------
 arch/x86/Makefile                                  |    6 +-
 arch/x86/Makefile_32                               |    2 -
 arch/x86/Makefile_64                               |    2 -
 arch/x86/boot/Makefile                             |    6 +-
 arch/x86/boot/cpucheck.c                           |    6 -
 arch/x86/kernel/Makefile_32                        |    3 +-
 arch/x86/kernel/Makefile_64                        |    2 +
 .../x86/kernel/cpu/cpufreq/{Kconfig_32 => Kconfig} |   69 ++-
 arch/x86/kernel/cpu/cpufreq/Kconfig_64             |  108 ---
 arch/x86/vdso/Makefile                             |    2 +-
 scripts/kconfig/Makefile                           |    7 +-
 15 files changed, 579 insertions(+), 1173 deletions(-)

Patches follow and will be sent to lkml only.

	Sam

