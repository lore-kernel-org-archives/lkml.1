Return-Path: <linux-kernel-owner+w=401wt.eu-S1756371AbXGQOFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbXGQOFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbXGQOFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:05:11 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35317 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbXGQOFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:05:09 -0400
Date: Tue, 17 Jul 2007 16:06:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: sam@ravnborg.org
Subject: [GIT PATCES] kbuild updates for merge window
Message-ID: <20070717140622.GA25846@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

First kbuild push for the merge window. A bit late since I have been on vacation.
The most noteworthy are quite some refactoring to produce better section
mismatch warnings.
The rest is basically just small changes with no major impact.

The optimised header-check was not ready - it will be pushed later.

Half of this or more has been in -mm but there is also a few
patches that did not appear in -mm due to me being late.

	Sam

Please pull from:
	git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild.git



Adrian Bunk (1):
      kbuild: use -fno-optimize-sibling-calls unconditionally

Aneesh Kumar K.V (1):
      kbuild: fix the warning when running make tags

Atsushi Nemoto (1):
      kbuild: make better section mismatch reports on i386 and mips

Bernhard Walle (1):
      kconfig: strip 'CONFIG_' automatically in kernel configuration search

H. Peter Anvin (1):
      scripts: Make cleanfile/cleanpatch warn about long lines

Jan Beulich (1):
      modpost white list pattern adjustment

Jeremy Fitzhardinge (1):
      kbuild: .paravirtprobe section is obsolete, so modpost doesn't need to handle it

Mathieu Desnoyers (3):
      cris: use DATA_DATA in cris
      powerpc: add missing DATA_DATA to powerpc
      xtensa: use DATA_DATA in xtensa

Mike Frysinger (4):
      kconfig: use POSIX equality test in check-lxdialog.sh
      kbuild: add support for reading stdin with gen_init_cpio
      kbuild: add support for squashing uid/gid in gen_initramfs_list.sh
      kbuild: use POSIX BRE in headers install target

Paulo Marques (1):
      kallsyms: remove usage of memmem and _GNU_SOURCE from scripts/kallsyms.c

Ralf Baechle (1):
      Whitelist references from __dbe_table to .init

Roman Zippel (1):
      kconfig: reset generated values only if Kconfig and .config agree.

Sam Ravnborg (13):
      kbuild: asm-offsets.h is now cleaned with O=.. builds
      kbuild: document cc-fullversion
      kbuild: avoid environment to set variables used by kbuild
      kconfig: fix update-po-config
      kbuild: make better section mismatch reports on arm
      kbuild: ignore section mismatch warnings originating from .note section
      kbuild: refactor code in modpost to improve maintainability
      kbuild: consolidate section checks
      kbuild: warn about references from .init.text to .exit.text
      kbuild: remove hardcoded apic_es7000 from modpost
      kbuild: remove hardcoded _logo names from modpost
      kbuild: whitelist references from variables named _timer to .init.text
      kbuild: do section mismatch check on full vmlinux

Segher Boessenkool (2):
      kbuild: New 'cc-fullversion' macro
      powerpc: Refuse to build 64-bit with GCC-4.2.0 and CONFIG_MODULES

Stephen Rothwell (1):
      kbuild: suppress modpost warnings for references from the .toc section as used by powerpc

 Documentation/kbuild/makefiles.txt         |   14 ++
 Kbuild                                     |    1 +
 Makefile                                   |   26 ++-
 arch/cris/arch-v10/vmlinux.lds.S           |    2 +-
 arch/cris/arch-v32/vmlinux.lds.S           |    2 +-
 arch/i386/mach-generic/es7000.c            |    2 +-
 arch/powerpc/Makefile                      |    8 +
 arch/powerpc/kernel/vmlinux.lds.S          |    4 +-
 arch/xtensa/kernel/vmlinux.lds.S           |    3 +-
 drivers/video/logo/logo.c                  |    7 +-
 scripts/Kbuild.include                     |    7 +-
 scripts/Makefile.build                     |   16 ++
 scripts/Makefile.headersinst               |   14 +-
 scripts/Makefile.modpost                   |    4 +-
 scripts/cleanfile                          |   54 +++++-
 scripts/cleanpatch                         |   58 +++++-
 scripts/gcc-version.sh                     |   15 +-
 scripts/gen_initramfs_list.sh              |   12 +-
 scripts/kallsyms.c                         |   17 ++-
 scripts/kconfig/Makefile                   |   35 ++--
 scripts/kconfig/confdata.c                 |   37 +++-
 scripts/kconfig/kxgettext.c                |    4 +-
 scripts/kconfig/lxdialog/check-lxdialog.sh |    2 +-
 scripts/kconfig/mconf.c                    |   11 +-
 scripts/mod/modpost.c                      |  312 ++++++++++++++++-----------
 scripts/mod/modpost.h                      |    3 +
 usr/gen_init_cpio.c                        |    4 +-
 27 files changed, 474 insertions(+), 200 deletions(-)
