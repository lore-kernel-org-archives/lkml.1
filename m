Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbXIPJqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbXIPJqY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 05:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbXIPJqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 05:46:15 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:48644 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbXIPJqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 05:46:14 -0400
Date: Sun, 16 Sep 2007 11:47:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: kbuild update
Message-ID: <20070916094739.GA6672@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A summary of what is planned to be submitted in next merge window for kbuild.
The shortlog below have additional details but the headlines are:

o Make the kernel buildable on a cygwin box (but not without a few glitches)
o detect unterminated device id list
o add export_report as a valid top-level make target
o add script to find unused kconfig symbols (try it!)
o allow a user to specify additional flags on the commandline with
  CFLAGS, AFLAGS or CPPFLAGS. The flags will be appended to the kernel defiend flags

The CFLAGS change will conflict with Andi's x86 patches and I fix it
before pushing if Andi's patches are pushed first.
Otherwise no conflicts.

The vmlinux.lds changes that I have sent to a number of arch maintainers
lately are not included.
I expect them to be applied by the respective arch maintainers.

The --gc-section cleanup from Denys Vlasenko will be included in
kbuild after the merge window so we can try it out in -mm before
hitting mainline.

Jan Beulich kconfig patch will most likely be included.
Need to test it first.

Marej menuconfig improvement may also be included.
Last patch looked good but have not made up my mind if it
really help people.

Patched referred below are available at git.kernel.org at kbuild.git
in an hour or so.

	Sam


Adrian Bunk (2):
      kbuild: fix export_report.pl
      kbuild: call export_report from the Makefile

Jesper Juhl (3):
      kbuild: improve scripts/gcc-version.sh output a bit when called without args
      kbuild: ver_linux fix glibc version print
      kbuild: scripts/ver_linux : correct printing of binutils version

Kees Cook (1):
      kbuild: make modpost detect unterminated device id lists

Mike Frysinger (1):
      kbuild: clean Modules.symvers in external module dirs

Paolo 'Blaisorblade' Giarrusso (1):
      kbuild: script to check for undefined Kconfig symbols

Petr Stetiar (1):
      kbuild: fix segfault in modpost

Ram Pai (1):
      kbuild: fix perl usage in export_report.pl

Randy Dunlap (1):
      docproc: style & typo cleanups

Sam Ravnborg (10):
      kbuild: Use Elfnn_Half as replacement for Elfnn_Section
      kbuild: check if we can link gettext not just compile
      kbuild: fix genksyms Makefile
      kbuild: __extension__ support in genksyms (fix unknown CRC warning)
      kbuild: apply genksyms changes
      kbuild: enable 'make CFLAGS=...' to add additional options to CC
      kbuild: enable 'make AFLAGS=...' to add additional options to AS
      ia64: fix sn to add include files using EXTRA_CFLAGS
      kbuild: enable 'make CPPFLAGS=...' to add additional options to CPP
      kbuild: fix directory traversal bug

Shlomi Fish (1):
      kconfig: qconf ("make xconfig") Search Dialog Enhancement

