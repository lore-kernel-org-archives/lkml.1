Return-Path: <linux-kernel-owner+w=401wt.eu-S1761800AbZFNVHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761800AbZFNVHd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 17:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755118AbZFNVHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 17:07:24 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:40295 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbZFNVHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 17:07:23 -0400
Date: Sun, 14 Jun 2009 23:09:41 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT] kbuild
Message-ID: <20090614210941.GA6403@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Kbuild updated for this merge window.
The highlights:

o rework of deb-pkg from the debian folks
o various kconfig updates - but nothing major
o prepared for start of vmlinux.lds cleanup (no users yet)

The rest is lots of small details here and there.

Most patches has been in -next for a while.

	Sam


The following changes since commit 3af968e066d593bc4dacc021715f3e95ddf0996f:
  Linus Torvalds (1):
        async: Fix lack of boot-time console due to insufficient synchronization

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-next.git master

Adam Lackorzynski (1):
      documentation: make version fix

Amerigo Wang (3):
      kbuild: clean up scripts/headers.sh
      kbuild/headers_check: refine extern check
      kbuild: fix a compile warning

Arne Janbu (1):
      .gitignore: ignore *.lzma files

Cheng Renquan (1):
      kbuild: remove extra ifdef/endif of top Makefile

David VomLehn (1):
      kbuild/Documentation: Incorrect makefile syntax in example

Frans Pop (9):
      kbuild, deb-pkg: minor general improvements in builddeb script
      kbuild, deb-pkg: refactor code to reduce duplication
      kbuild, deb-pkg: fix 'file not found' error when building .deb package for arm
      kbuild, deb-pkg: pass Debian maintainer script parameters to packaging hook scripts
      kbuild, deb-pkg: allow to specify a custom revision for .deb packages
      kbuild, deb-pkg: allow alternative hook scripts directory in .deb packages
      kbuild, deb-pkg: improve changelog entry and package descriptions
      kbuild, deb-pkg: generate debian/copyright file
      kbuild, deb-pkg: improve Source field

Jan Beulich (1):
      initconst adjustments

Jani Nikula (1):
      gitignore: Add GNU GLOBAL files to top .gitignore

Jiri Slaby (1):
      kbuild: allow docproc invocation from external

Manish Katiyar (1):
      kernel/kallsyms.c: replace deprecated __initcall with device_initcall and fix whitespace

Markus Heidelberg (10):
      kconfig: fix typo "mconfig" to "menuconfig" in a comment
      kconfig: add a note about the deps to the 'silentoldconfig' help
      kconfig: resort the documentation of the environment variables
      gitignore: ignore Kconfig i18n files
      kconfig qconf: fix -Wall compiler warnings
      kconfig qconf: fix namespace for Horizontal and Vertical enum values
      kconfig qconf: add namespace for use of Key_ enum values
      kconfig qconf: fix the type of the desktop widget
      kconfig: do not hardcode ".config" filename
      kconfig: do not hardcode "include/config/auto.conf" filename

Michal Marek (3):
      kbuild: handle non-existing options in scripts/config
      kbuild: simplify argument loop in scripts/config
      kbuild: add generic --set-str option to scripts/config

Mike Frysinger (2):
      ignore *.patch files
      kallsyms: generalize text region handling

Nico Schottelius (1):
      kbuild: fix delay in setlocalversion on readonly source

Patrick Ringl (1):
      README: fix misleading pointer to the defconf directory

Peter Korsgaard (1):
      kconfig: handle comment entries within choice/endchoice

Randy Dunlap (2):
      menu: fix embedded menu presentation
      kernel-doc: cleanup perl script

Robert P. J. Day (1):
      scripts/headers_check.pl: correct RE in header CONFIG leak check

Robin Getz (1):
      kallsyms: support kernel symbols in Blackfin on-chip memory

Russell King (1):
      kbuild: fix headers_exports with boolean expression

Sam Ravnborg (3):
      kbuild: add hint about __refdata to modpost
      Improve vmlinux.lds.h support for arch specific linker scripts
      vmlinux.lds.h update

Sergei Poselenov (1):
      kbuild: fix "Argument list too long" error for "make headers_check",

dann frazier (1):
      Remove bashisms from scripts

maximilian attems (5):
      kbuild, deb-pkg: improve maintainer identification
      kbuild, deb-pkg: fix generated package name
      kbuild, deb-pkg: fix Provides field
      kbuild, deb-pkg: fix Section field
      kbuild, deb-pkg: bump standards version

 .gitignore                           |    8 +
 Documentation/Changes                |    4 +-
 Documentation/kbuild/kconfig.txt     |  116 +++++++++--------
 Documentation/kbuild/modules.txt     |    2 +-
 Makefile                             |   26 ++---
 README                               |   11 ++-
 include/asm-generic/vmlinux.lds.h    |  241 ++++++++++++++++++++++++++++++++--
 include/linux/init.h                 |    7 +-
 include/linux/section-names.h        |    6 -
 init/Kconfig                         |   16 +-
 kernel/kallsyms.c                    |  134 +++++++++++--------
 scripts/Makefile.headersinst         |    8 +-
 scripts/basic/docproc.c              |   13 ++-
 scripts/basic/fixdep.c               |    5 +-
 scripts/config                       |   87 ++++++-------
 scripts/gcc-version.sh               |    2 +-
 scripts/headers.sh                   |    7 -
 scripts/headers_check.pl             |   14 +-
 scripts/kallsyms.c                   |   76 +++++++++--
 scripts/kconfig/.gitignore           |    3 +
 scripts/kconfig/Makefile             |    4 +-
 scripts/kconfig/conf.c               |    7 +-
 scripts/kconfig/confdata.c           |   20 ++-
 scripts/kconfig/lkc.h                |    1 +
 scripts/kconfig/lxdialog/checklist.c |    3 +-
 scripts/kconfig/mconf.c              |   10 ++-
 scripts/kconfig/qconf.cc             |   48 ++++---
 scripts/kconfig/util.c               |    6 +-
 scripts/kernel-doc                   |  174 ++++++++++++------------
 scripts/mod/modpost.c                |   50 ++++++--
 scripts/package/builddeb             |  149 ++++++++++++++-------
 scripts/setlocalversion              |    6 +-
 scripts/unifdef.c                    |   48 +++++--
 scripts/ver_linux                    |    2 +-
 34 files changed, 872 insertions(+), 442 deletions(-)
 delete mode 100644 include/linux/section-names.h
