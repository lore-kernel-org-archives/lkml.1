Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbYBCVKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbYBCVKr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 16:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYBCVKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 16:10:39 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:47439 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbYBCVKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 16:10:38 -0500
Date: Sun, 3 Feb 2008 22:10:42 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PATCH] Second round of kbuild updates
Message-ID: <20080203211042.GF2648@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Please pull the following changes from kbuild.git:

	ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild.git

The diffstat say that a relative high number of files are touched.
This is due to the set of patches from Mathieu that introduce
an arch common Kconfig file and start utilizing it.
The rest are much simpler.

The most visible change is that I have made all the section mismatch
warning prints go away and in the end of the build modpost simply
report the number of section mismatch warnings and how to see detail.

The typical output is now:

modpost: Found 35 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'

And CONFIG_DEBUG_SECTION_MISMATCH cannot be set
from the config anymore so we are not noisy in typical
allyesconfig builds.

When we are down to an acceptable number of warnings modpost
will start to be vocal again.

The section mismatch logic were changed so we no longer complain
about exported symbols annotated __devinit, __cpuinit, __meminit
as they all seemed to be dealt with properly and the hack needed
to avoid the warnings was not worth the effort.

And I killed the irritating "select of unknown symbol warning".

The scsi change is acked by James and he said OK to get it in via kbuild.git.

Patches has been sent out for review one day ago and comments has been
addressed.
As Andrew has picked up the updated kbuild.git tree I think it is
easiest to get this in before Andrew starts merging his pile of patches.

	Sam

Bryan Wu (1):
      kbuild: add svn revision information to setlocalversion

Geert Uytterhoeven (1):
      kbuild: Spelling/grammar fixes for config DEBUG_SECTION_MISMATCH

Mathieu Desnoyers (5):
      Fix ARM to play nicely with generic Instrumentation menu
      Create arch/Kconfig
      Add HAVE_OPROFILE
      Add HAVE_KPROBES
      Move Kconfig.instrumentation to arch/Kconfig and init/Kconfig

Ralf Baechle (1):
      Remove __INIT_REFOK and __INITDATA_REFOK

Sam Ravnborg (5):
      kbuild: print only total number of section mismatces found
      kconfig: mark config as changed when loading an alternate config
      kconfig: ignore select of unknown symbol
      kbuild: do not warn about __*init/__*exit symbols being exported
      scsi: fix dependency bug in aic7 Makefile

 arch/Kconfig                     |   31 +++++++++++++++++++
 arch/alpha/Kconfig               |    3 +-
 arch/arm/Kconfig                 |   21 +++++++++++-
 arch/arm/Kconfig.instrumentation |   62 --------------------------------------
 arch/avr32/Kconfig               |    5 +--
 arch/blackfin/Kconfig            |    3 +-
 arch/cris/Kconfig                |    2 -
 arch/frv/Kconfig                 |    2 -
 arch/h8300/Kconfig               |    2 -
 arch/ia64/Kconfig                |    4 +-
 arch/m32r/Kconfig                |    3 +-
 arch/m68k/Kconfig                |    2 -
 arch/m68knommu/Kconfig           |    2 -
 arch/mips/Kconfig                |    3 +-
 arch/parisc/Kconfig              |    3 +-
 arch/powerpc/Kconfig             |    4 +-
 arch/ppc/Kconfig                 |    4 +-
 arch/s390/Kconfig                |    4 +-
 arch/sh/Kconfig                  |    3 +-
 arch/sparc/Kconfig               |    3 +-
 arch/sparc64/Kconfig             |    4 +-
 arch/um/Kconfig                  |    2 -
 arch/v850/Kconfig                |    2 -
 arch/x86/Kconfig                 |    8 +----
 arch/xtensa/Kconfig              |    2 -
 drivers/scsi/aic7xxx/Makefile    |    9 +----
 include/linux/init.h             |    3 --
 init/Kconfig                     |   14 ++++++++
 kernel/Kconfig.instrumentation   |   49 ------------------------------
 lib/Kconfig.debug                |   14 ++++----
 scripts/kconfig/mconf.c          |    1 +
 scripts/kconfig/menu.c           |    9 ++----
 scripts/mod/modpost.c            |   17 +++++-----
 scripts/setlocalversion          |   16 ++++++++++
 34 files changed, 122 insertions(+), 194 deletions(-)
