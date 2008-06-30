Return-Path: <linux-kernel-owner+w=401wt.eu-S1764279AbYF3VbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764279AbYF3VbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761859AbYF3VbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:31:11 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:36811 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760034AbYF3VbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:31:09 -0400
Date: Mon, 30 Jun 2008 23:31:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: kbuild - pending stuff, and Maintainer news
Message-ID: <20080630213155.GA32479@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following is stuff pending in kbuild-next.git for upcoming
merge window.

Headlines:
- make *config targets are less chatty (and thus faster too)
- support for arch/$ARCH/include
- 3x faster headers_check and much less verbose
- added a diffconfig utility that shows difference between two configs

Most of the kconfig stuff is fresh patches - the rest has been in kbuild-next.git
for a while and thus in -next (which has caught a lot of issues - thanks Stephen!).


Other news
We are moving soon and this will impact both my connectivity and
the time I can use on kbuild stuff.
So if I fail to act on your mails then I am most likely busy
moving, painting, gardening or other practical stuff.
If you really need help then drop by and help me - then
we can always fix the kbuild stuff over a beer.

	Sam

Shortlog (patches follows).

Alexey Dobriyan (2):
      kbuild: make clean removes *.o.* as well
      kbuild: remove Module.markers during mrproper

Geert Uytterhoeven (1):
      kbuild: sparse needs CF not CHECKFLAGS

Jan Beulich (1):
      vmlinux.lds: move __attribute__((__cold__)) functions back into final .text section

Randy Dunlap (1):
      kernel-doc: handle/strip __init

Roman Zippel (1):
      kconfig: set all new symbols automatically

S.Çağlar Onur (1):
      init: fix URL of "The GNU Accounting Utilities"

Sam Ravnborg (16):
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
      kconfig: prefix hex values with 0x in .config
      kconfig: speed up all*config + randconfig
      kconfig: make oldconfig is now less chatty
      kconfig: make defconfig is no longer chatty

Tim Bird (1):
      kconfig: add diffconfig utility

 Documentation/sparse.txt          |    8 +-
 Kbuild                            |    3 +-
 Makefile                          |  116 +++++++++------
 arch/x86/boot/compressed/relocs.c |    2 +-
 include/Kbuild                    |    4 +-
 include/asm-generic/vmlinux.lds.h |    4 +-
 init/Kconfig                      |    2 +-
 scripts/Makefile.headersinst      |  292 +++++++++++++------------------------
 scripts/diffconfig                |  129 ++++++++++++++++
 scripts/hdrcheck.sh               |   10 --
 scripts/headers.sh                |   41 +++++
 scripts/headers_check.pl          |   56 +++++++
 scripts/headers_install.pl        |   45 ++++++
 scripts/kconfig/conf.c            |  161 +++++++++------------
 scripts/kconfig/confdata.c        |   72 +++++++++-
 scripts/kconfig/lkc.h             |    9 +
 scripts/kernel-doc                |    1 +
 17 files changed, 602 insertions(+), 353 deletions(-)
