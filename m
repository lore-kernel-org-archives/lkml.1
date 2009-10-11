Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbZJKWS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbZJKWS6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 18:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbZJKWS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 18:18:56 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:42301 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbZJKWSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 18:18:55 -0400
Date: Mon, 12 Oct 2009 00:18:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: [GIT PULL] kbuild fixes
Message-ID: <20091011221818.GA2833@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

A few kbuild related fixes.

- revert of "save ARCH & CROSS_COMPILE ..." commit
  It has caused issues for several people, and now it is better
  to revert it rather than trying to fix it.
  I would expext any fix to surface addition issues.

- Fix use of echo -ne. Is caused issues for ubuntu (IIRC) users

- Warn when people try to build userspace using non-exported
  headers.
  This is not a strict fix but is a nice way to catch when
  people uses the kernel headers in the wrong way.
  This patch may prevent some confusion.

- binrpm-pkg now works with KBUILD_OUTPUT set

The patches has been rebased very recently as I had to kill
a few patches that was not -fixes relevant for -rc3.

	Sam

The following changes since commit f144c78e525542c94e0dcb171b41cc5ef7b341b3:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git390.marist.edu/pub/scm/linux-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git master

Alek Du (1):
      kbuild: Fix size_append issue for bzip2/lzma kernel

Amerigo Wang (1):
      kbuild,scripts: use non-builtin echo for '-e'

Arnd Bergmann (1):
      warn about use of uninstalled kernel headers

Felipe Contreras (2):
      kbuild: fix warning when domainname is not available
      kbuild: mkcompile_h: trivial cleanups

Frans Pop (1):
      kbuild: fix the binrpm-pkg target to work with KBUILD_OUTPUT set

Sam Ravnborg (1):
      kbuild: revert "save ARCH & CROSS_COMPILE ..."

 Makefile                       |   46 +--------------------------------------
 include/linux/kernel.h         |    6 +++++
 scripts/Kbuild.include         |    2 +-
 scripts/Makefile.lib           |    2 +-
 scripts/checkkconfigsymbols.sh |    4 +-
 scripts/headers_install.pl     |    2 +-
 scripts/mkcompile_h            |   12 +++++++--
 scripts/package/Makefile       |   11 ++++++++-
 scripts/package/mkspec         |    2 +-
 9 files changed, 33 insertions(+), 54 deletions(-)
