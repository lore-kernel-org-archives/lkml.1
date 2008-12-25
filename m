Return-Path: <linux-kernel-owner+w=401wt.eu-S1752356AbYLYNOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbYLYNOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 08:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbYLYNOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 08:14:15 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:51428 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbYLYNON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 08:14:13 -0500
Date: Thu, 25 Dec 2008 14:15:45 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] kbuild updates for v2.6.29
Message-ID: <20081225131545.GA30628@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

A few (26) patches has accumulated the last months on the kbuild side.

Highlights:

o Better track of symbol checksum changes (Andreas Gruenbacher)
o Improved stripping of modules (Jan Beulich)
o silent is now really silent (Mike Frysinger)
o improved svn support (Peter Korsgaard)
o detect include looks (new target: headerdep) (Vegard Nossum)

This pull contains a lot of crunch in the top-level Makefile.
This is mostly due to:
- move all tags generation support to a shell script (deletes stuff)
- improved strip support for modules/vmlinux (adds atuff)

Please pull from:

   git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-next.git master

	Sam


Andreas Gruenbacher (2):
      genksyms: track symbol checksum changes
      genksyms: allow to ignore symbol checksum changes

Arjan van de Ven (1):
      scripts: improve the decodecode script

Jan Beulich (2):
      kbuild: strip generated symbols from *.ko
      allow stripping of generated symbols under CONFIG_KALLSYMS_ALL

Jeremy Kerr (1):
      scripts/package: allow custom options to rpm

Jiri Slaby (2):
      kbuild: fix make tags/cscope
      kbuild: fix string equality testing in tags.sh

Mike Frysinger (3):
      kbuild: kill output in silent mode of mkcompile_h
      kbuild: introduce $(kecho) convenience echo
      kbuild: use KECHO convenience echo

Peter Korsgaard (2):
      setlocalversion: print correct subversion revision
      setlocalversion: add git-svn support

Randy Dunlap (1):
      kernel-doc: check for extra kernel-doc notations

Robert P. J. Day (1):
      kbuild: remove TAR_IGNORE

Sally, Gene (1):
      kbuild: gen_init_cpio expands shell variables in file names

Sam Ravnborg (8):
      kbuild: fix -I option expansion with O=... builds
      kbuild: expand -I in KBUILD_CPPFLAGS
      kbuild: teach mkmakfile to be silent
      kconfig: fix options to check-lxdialog.sh
      tags and cscope support really belongs in a shell script
      kbuild: fix make incompatibility
      kbuild: simplify use of genksyms
      kbuild: support switching source directories with O=.. builds

Vegard Nossum (1):
      kbuild: add headerdep used to detect inclusion cycles in header files

Werner Almesberger (1):
      remove bashisms from scripts/extract-ikconfig

 Documentation/kbuild/makefiles.txt         |   14 ++
 Makefile                                   |  209 +++++++--------------
 arch/blackfin/boot/Makefile                |    2 +-
 arch/x86/scripts/strip-symbols             |    1 +
 init/Kconfig                               |    7 +
 kernel/kallsyms.c                          |   16 +-
 scripts/Kbuild.include                     |   22 ++-
 scripts/Makefile.build                     |   67 +++++---
 scripts/Makefile.lib                       |   15 +-
 scripts/Makefile.modinst                   |    3 +-
 scripts/decodecode                         |   32 +++-
 scripts/extract-ikconfig                   |    8 +-
 scripts/genksyms/genksyms.c                |  277 ++++++++++++++++++++++++++--
 scripts/genksyms/genksyms.h                |    7 +
 scripts/genksyms/keywords.c_shipped        |  189 ++++++++++----------
 scripts/genksyms/keywords.gperf            |    2 +
 scripts/headerdep.pl                       |  193 +++++++++++++++++++
 scripts/kallsyms.c                         |   21 +--
 scripts/kconfig/lxdialog/check-lxdialog.sh |    2 +-
 scripts/kernel-doc                         |   67 +++++++-
 scripts/mkcompile_h                        |    6 +-
 scripts/mkmakefile                         |    4 +-
 scripts/mksysmap                           |    7 +-
 scripts/package/Makefile                   |    9 +-
 scripts/setlocalversion                    |    7 +-
 scripts/strip-symbols                      |   22 +++
 scripts/tags.sh                            |  160 ++++++++++++++++
 usr/gen_init_cpio.c                        |   28 +++-
 28 files changed, 1046 insertions(+), 351 deletions(-)
