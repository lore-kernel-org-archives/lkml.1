Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbYLTOXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbYLTOXz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 09:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbYLTOXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 09:23:49 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:40028 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbYLTOXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 09:23:47 -0500
Date: Sat, 20 Dec 2008 15:25:18 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: kbuild-next content
Message-ID: <20081220142518.GA19390@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following is the collected patched in kbuild-next for
the upcoming merge window.

Highlights:

o Better track of symbol checksum changes (Andreas Gruenbacher)
o Improved strinning of modules (Jan Beulich)
o silent is now really silent (Mike Frysinger)
o improved svn support (Peter Korsgaard)
o detect include looks (new target: headerdep) (Vegard Nossum)

And a lot of smaller things. Shortlog + diffstat below.

I have still stuff pending but the queue is getting smaller.

Bugzilla say that I have 5 bugs assigned. But I guess
in reality there is a few more.

It will all be part of -next and some of the patches is there already.
Patches will follow.

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
