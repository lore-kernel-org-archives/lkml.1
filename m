Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbXJJTnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbXJJTnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 15:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbXJJTnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 15:43:11 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:54707 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755046AbXJJTnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 15:43:10 -0400
Date: Wed, 10 Oct 2007 21:44:34 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] kbuild updates
Message-ID: <20071010194434.GA2791@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

This set of commits are the kbuild stuff that does not
conflict with the pending x86 merge. I have a few commits
awaiting the x86 merge and the pending X86_64 patches.
When both sets are in I will rebase the remaining commits
and drop you another mail.

In headlines:
o Moved Kai Germaschewski to CREDITS with his approval
o Removed some almost unused kconfig keywords and updated the users
o modpost complains if device id lists are unterminated
o Fixes so we can now build on cygwin (but not without a few issues)
o Save ARCH & CROSS_COMPILE

Other than that several small kbuild related things that the
shortlog explains.

Most of these commits has been in -mm. And the rest works for me
and has been on lkml.

Note: 2 commits adds trailing whitespaces - this is generated files
and I did not want to hand-edit generated files. (flex/bison stuff).

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild.git


	Sam



 CREDITS                              |    6 +
 Documentation/kbuild/makefiles.txt   |    9 +-
 MAINTAINERS                          |    4 -
 Makefile                             |   71 +-
 arch/blackfin/Kconfig                |    2 +-
 arch/ia64/sn/kernel/Makefile         |    2 +-
 arch/ia64/sn/kernel/sn2/Makefile     |    2 +-
 arch/ia64/sn/pci/Makefile            |    2 +-
 arch/ia64/sn/pci/pcibr/Makefile      |    2 +-
 arch/powerpc/Kconfig.debug           |    6 +-
 arch/powerpc/platforms/Kconfig       |    2 +-
 drivers/input/misc/Kconfig           |    2 +-
 drivers/leds/Kconfig                 |    2 +-
 drivers/telephony/Kconfig            |    2 +-
 include/linux/Kbuild                 |    3 -
 scripts/Makefile.build               |   27 +-
 scripts/Makefile.clean               |    2 +-
 scripts/Makefile.lib                 |   10 +-
 scripts/basic/Makefile               |    8 +-
 scripts/basic/docproc.c              |   34 +-
 scripts/checkkconfigsymbols.sh       |   59 +
 scripts/export_report.pl             |   10 +-
 scripts/gcc-version.sh               |    8 +-
 scripts/genksyms/Makefile            |    8 +-
 scripts/genksyms/keywords.c_shipped  |  180 ++--
 scripts/genksyms/keywords.gperf      |    1 +
 scripts/genksyms/lex.c_shipped       | 1802 +++++++++++++++++++-----------
 scripts/genksyms/parse.c_shipped     | 2088 +++++++++++++++++++---------------
 scripts/genksyms/parse.h_shipped     |  159 ++--
 scripts/genksyms/parse.y             |    5 +-
 scripts/kconfig/Makefile             |   10 +-
 scripts/kconfig/check.sh             |   14 +
 scripts/kconfig/lex.zconf.c_shipped  |   25 +-
 scripts/kconfig/mconf.c              |   36 +-
 scripts/kconfig/menu.c               |   35 +-
 scripts/kconfig/util.c               |   13 +-
 scripts/kconfig/zconf.gperf          |    2 -
 scripts/kconfig/zconf.hash.c_shipped |  220 ++--
 scripts/kconfig/zconf.tab.c_shipped  | 1406 +++++++++++++-----------
 scripts/kconfig/zconf.y              |   11 -
 scripts/mkmakefile                   |    8 +-
 scripts/mod/file2alias.c             |   40 +-
 scripts/mod/modpost.c                |    6 +
 scripts/mod/modpost.h                |    4 +-
 scripts/ver_linux                    |    9 +-
 45 files changed, 3739 insertions(+), 2618 deletions(-)

Adrian Bunk (4):
      kbuild: fix export_report.pl
      kbuild: call export_report from the Makefile
      kconfig: syntax cleanup - drop support for "depends/requires/def_boolean"
      include/linux/Kbuild: remove duplicate entries

Jan Beulich (1):
      kconfig: tristate choices with mixed tristate and boolean values

Jesper Juhl (3):
      kbuild: improve scripts/gcc-version.sh output a bit when called without args
      kbuild: ver_linux fix glibc version print
      kbuild: scripts/ver_linux : correct printing of binutils version

Kees Cook (1):
      kbuild: make modpost detect unterminated device id lists

Matej Laitl (1):
      kconfig/menuconfig: distinguish between selected-by-another options and comments

Mike Frysinger (1):
      kbuild: clean Modules.symvers in external module dirs

Milton Miller (1):
      kbuild: call make once for all targets when O=.. is used

Paolo 'Blaisorblade' Giarrusso (1):
      kbuild: script to check for undefined Kconfig symbols

Petr Stetiar (1):
      kbuild: fix segfault in modpost

Ram Pai (1):
      kbuild: fix perl usage in export_report.pl

Randy Dunlap (1):
      docproc: style & typo cleanups

Roland McGrath (1):
      kbuild: pass -g to assembler under CONFIG_DEBUG_INFO

Sam Ravnborg (16):
      kbuild: Use Elfnn_Half as replacement for Elfnn_Section
      kbuild: check if we can link gettext not just compile
      kbuild: fix genksyms Makefile
      kbuild: __extension__ support in genksyms (fix unknown CRC warning)
      kbuild: apply genksyms changes
      ia64: fix sn to add include files using EXTRA_CFLAGS
      kbuild: fix directory traversal bug
      kconfig: make comments stand out in menuconfig
      kconfig: fix segv fault in menuconfig
      kbuild: fix infinite make recursion
      kbuild: update _shipped files
      kbuild: fix documentation in makefiles.txt
      kbuild: kill EXTRA_ARFLAGS
      kbuild: kill backward compatibility checks
      kbuild: move Kai Germaschewski to CREDITS
      kbuild: save ARCH & CROSS_COMPILE when building a kernel

