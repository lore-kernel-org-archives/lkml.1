Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730AbYGZIUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbYGZIUO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 04:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYGZIT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 04:19:56 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:46125 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbYGZITz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 04:19:55 -0400
X-Greylist: delayed 2324 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Jul 2008 04:17:52 EDT
Date: Sat, 26 Jul 2008 09:43:28 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] kbuild
Message-ID: <20080726074328.GA2161@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Please pull the following kbuild commits from:

   git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-next.git master

The headlines:

o Added a new diffconfig utility that shows the diff between two configs

o Cleaned up headers_* support and increased speed of the same
  It is also much less chatty speeding it up even more

o *config targets are now much less chatty. No one was using the
  output for any same purposes anymore and it just hided the warnings.

o Added support for arch/$ARCH/include
  Not that any arch uses it yet - byt that will soon change

o And a number of bug fixes from various people.


PS. The pull request are late due to me moving and I have been
    on vacation too.

Thanks,

	Sam


Details below.


Alexey Dobriyan (2):
      kbuild: make clean removes *.o.* as well
      kbuild: remove Module.markers during mrproper

Geert Uytterhoeven (1):
      kbuild: sparse needs CF not CHECKFLAGS

Heikki Orsila (1):
      kconfig: fix typos: "Suport" -> "Support"

Jan Beulich (1):
      vmlinux.lds: move __attribute__((__cold__)) functions back into final .text section

Randy Dunlap (1):
      kernel-doc: handle/strip __init

Roman Zippel (1):
      kconfig: set all new symbols automatically

S.Çağlar Onur (1):
      init: fix URL of "The GNU Accounting Utilities"

Sam Ravnborg (15):
      kbuild: refactor headers_* targets in Makefile
      kbuild: always unifdef files in headers_install*
      kbuild: drop support of ALTARCH for headers_*
      kbuild: code refactoring in Makefile.headerinst
      kbuild: error out early in make headers_install
      kbuild: only one call for include/ in make headers_*
      kbuild: optimize headers_* targets
      kbuild: install all headers when arch is changed
      kbuild: prepare headers_* for arch/$ARCH/include
      kbuild: support arch/$ARCH/include for tags, cscope
      kbuild: asm symlink support for arch/$ARCH/include
      kbuild: add arch/$ARCH/include to search path
      kconfig: speed up all*config + randconfig
      kconfig: make oldconfig is now less chatty
      kconfig: make defconfig is no longer chatty

Sebastian Siewior (1):
      setlocalversion: do not describe if there is nothing to describe

Tim Bird (1):
      kconfig: add diffconfig utility

 Documentation/sparse.txt          |    8 +-
 Kbuild                            |    3 +-
 Makefile                          |  115 +++++++++------
 drivers/misc/Kconfig              |    2 +-
 include/Kbuild                    |    5 +-
 include/asm-generic/vmlinux.lds.h |    4 +-
 init/Kconfig                      |    4 +-
 scripts/Makefile.headersinst      |  292 +++++++++++++------------------------
 scripts/diffconfig                |  129 ++++++++++++++++
 scripts/hdrcheck.sh               |   10 --
 scripts/headers.sh                |   41 +++++
 scripts/headers_check.pl          |   56 +++++++
 scripts/headers_install.pl        |   45 ++++++
 scripts/kconfig/conf.c            |  161 +++++++++------------
 scripts/kconfig/confdata.c        |   70 +++++++++
 scripts/kconfig/lkc.h             |    9 +
 scripts/kernel-doc                |    1 +
 scripts/setlocalversion           |    4 +-
 18 files changed, 605 insertions(+), 354 deletions(-)

