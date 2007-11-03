Return-Path: <linux-kernel-owner+w=401wt.eu-S1760177AbXKCXq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177AbXKCXq7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 19:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbXKCXqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 19:46:51 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:58809 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbXKCXqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 19:46:50 -0400
Date: Sun, 4 Nov 2007 00:48:26 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] replace "make ARCH=i386/x86_64 with make ARCH=x86"
Message-ID: <20071103234826.GA26654@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset unify the i386 and x86_64 Kconfig
files for x86.
In addition it replaces the use of ARCH=i386 and
ARCH=x86_64 with the more intuitive ARCH=x86.

The primary purpose of this patch serie is to 
enable make ARCH=x86 and let the config decide
if we are building for 32 or 64 bit.

But we will break quite a high number of
scripts with this change.
What is the desired behaviour when specifying:
make ARCH=i386
and
make ARCH=x86_64
??

For now it just error out like this:
$ make ARCH=i386
Makefile:503: /home/sam/kernel/x86.git/arch/i386/Makefile: No such file or directory
make: *** No rule to make target `/home/sam/kernel/x86.git/arch/i386/Makefile'.  Stop.


What is the required functionality here?
Note - only patch 9 and 10 are changing any behaviour.
So if we decide to keep current functionality then
the first 8 patches still makes a lot of sense.


The patch serie contains:
Sam Ravnborg (10):
      x86: unification of cfufreq/Kconfig
      x86: start unification of arch/x86/Kconfig.*
      x86: arch/x86/Kconfig.cpu unification
      x86: add X86_32 dependency to i386 specific symbols in Kconfig.i386
      x86: add X86_64 dependency to x86_64 specific symbols in Kconig.x86_64
      x86: copy x86_64 specific Kconfig symbols to Kconifg.i386
      x86: add remaning bits from x86_64 to Kconfig.i386
      x86: combine all config options with prompts in Kconfig
      x86: select i386 or x86_64 at config time
      x86: enable make ARCH=x86

The diffstat looks promising:
 9 files changed, 975 insertions(+), 2639 deletions(-)

A patch that makes the kernel more than 1500 line smaller
is a good patch!

Full diffstat (as git can show it):

$ git diff --stat -C -M -B HEAD~10..HEAD
 Makefile                                           |    5 +-
 arch/x86/{Kconfig.i386 => Kconfig}                 |  600 ++++----
 arch/x86/Kconfig.cpu                               |   83 +-
 arch/x86/Kconfig.i386                              | 1609 ++++----------------
 arch/x86/Kconfig.x86_64                            | 1132 ++++----------
 arch/x86/Makefile                                  |    2 +-
 .../x86/kernel/cpu/cpufreq/{Kconfig_32 => Kconfig} |   68 +-
 arch/x86/kernel/cpu/cpufreq/Kconfig_64             |  108 --
 scripts/kconfig/Makefile                           |    7 +-
 9 files changed, 975 insertions(+), 2639 deletions(-)

The serie can be pulled from:

	ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/x86.git


Patches will follow in seperate thread.
This serie replaces the single patch I posted the other day.
This serie are made to ease review and to do so a few of the patches
does not change functionality but are just preparing for later steps.

	Sam

