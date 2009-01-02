Return-Path: <linux-kernel-owner+w=401wt.eu-S932089AbZABTtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089AbZABTtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 14:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbZABTtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 14:49:04 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:57054 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbZABTtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 14:49:01 -0500
Date: Fri, 2 Jan 2009 20:50:39 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT] final batch of kbuild updates 
Message-ID: <20090102195039.GA7343@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Here follows the final batch of kbuild updates for the merge window.

Highlights:

o We no longer let sparse warm about void-valued expressions
o We have implmented additional checks on out user space headers
  We do not fail on these yet - there are to much to be fixed.
o Added some long needed documentation for kconfig and kbuild
  Always room for more - especially on the kbuild parts.

This set includes a fix in the m68k specific Kconfig file - this 
is acked by Gert.

The kconfig changes is mostly adding comments. The actual changes will
wait until next merge window.

Please pull from:

    git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-next.git master

	Sam


Hannes Eder (1):
      kbuild: disable sparse warning "returning void-valued expression"

Mike Frysinger (2):
      headers_check.pl: disallow extern's
      kbuild: in headers_install autoconvert asm/inline/volatile to __xxx__

Randy Dunlap (1):
      kbuild: make *config usage docs

Sam Ravnborg (10):
      m68k: fix recursive dependency in Kconfig
      kconfig: explain symbol value defaults
      kconfig: add comments to symbol flags
      kconfig: struct property commented
      kconfig: improve error messages for bad source statements
      kbuild: check for leaked CONFIG_ symbols to userspace
      kbuild: document environment variables
      kbuild: drop debugging leftover in tags.sh
      kbuild: add checks for include of linux/types in userspace headers
      kbuild: ignore a few files in headers_check

 Documentation/kbuild/00-INDEX       |    6 +-
 Documentation/kbuild/kbuild.txt     |  126 +++++++++++++++++++++++
 Documentation/kbuild/kconfig.txt    |  188 +++++++++++++++++++++++++++++++++++
 Makefile                            |    3 +-
 README                              |   32 ++++---
 arch/m68k/Kconfig                   |    1 -
 scripts/headers_check.pl            |   70 +++++++++++++-
 scripts/headers_install.pl          |    3 +
 scripts/kconfig/expr.h              |   82 ++++++++++-----
 scripts/kconfig/lex.zconf.c_shipped |    7 +-
 scripts/kconfig/zconf.l             |    7 +-
 scripts/tags.sh                     |    1 -
 12 files changed, 476 insertions(+), 50 deletions(-)
