Return-Path: <linux-kernel-owner+w=401wt.eu-S1761361AbZAGVAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761361AbZAGVAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 16:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757596AbZAGVAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 16:00:35 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:54770 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576AbZAGVAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 16:00:34 -0500
Date: Wed, 7 Jan 2009 22:02:12 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT] kbuild stuff
Message-ID: <20090107210212.GA8735@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

First set of kbuild related fixes and other stuff.

o Anders fixed up qnx and I took this patch via my tree
  as it is a general include header issue.

o Andi added a new script 'config' to manipulate the configuration
  It needs some polishing but is usefull as is

o Arjan improved bootchart - and I took his word for that it is an improvement

o Jike added back ALLSOURCE_ARCHS to tags as it is actually used

o Wolfram fixed some documentation typos

o And I fixed a modules_install regression

All in all only small details.

Outstanding things at the moments:

- The patches to strip modules and vmlinux causes troubles:
  o With MODVERSIONS enabled ccache and distcc does no longer improve things
  o sparc build is br0ken

- Alan's reported issue with broken 32 bit build is not solved - awaiting feedback from Alan

I dunno what to do to make people start looking at all the warnings our
exported headers generates. Maybe I should let headers_check error ou if
there is more than 10 warnings in a directory..

Please pull from:

   git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git master

	Sam


Anders Larsen (1):
      qnx: include <linux/types.h> for definitions of __[us]{8,16,32,64} types

Andi Kleen (2):
      kconfig: add script to manipulate .config files on the command line
      kbuild: add a symlink to the source for separate objdirs

Arjan van de Ven (1):
      bootchart: improve output based on Dave Jones' feedback

Jike Song (1):
      kbuild: reintroduce ALLSOURCE_ARCHS support for tags/cscope

Sam Ravnborg (1):
      fix modules_install via NFS

Wolfram Sang (1):
      kbuild: fix typos (s/bin_shipped/bin.o_shipped/) in Documentation

 Documentation/kbuild/kbuild.txt  |    7 ++
 Documentation/kbuild/modules.txt |    4 +-
 Makefile                         |    1 +
 firmware/.gitignore              |    1 -
 firmware/Makefile                |   10 +--
 include/linux/qnx4_fs.h          |    4 +-
 include/linux/qnxtypes.h         |    5 +-
 scripts/.gitignore               |    1 +
 scripts/Makefile                 |    3 +-
 scripts/bootgraph.pl             |   16 +++-
 scripts/config                   |  150 ++++++++++++++++++++++++++++++++++++++
 {firmware => scripts}/ihex2fw.c  |    0
 scripts/tags.sh                  |   18 +++-
 13 files changed, 194 insertions(+), 26 deletions(-)
