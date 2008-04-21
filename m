Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbYDUWcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbYDUWcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 18:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYDUWca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 18:32:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50624
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753040AbYDUWc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 18:32:29 -0400
Date: Mon, 21 Apr 2008 15:32:31 -0700 (PDT)
Message-Id: <20080421.153231.108090227.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This performs the scheduled removal of Solaris and SunOS
system call for sparc, much to the chagrin of Al Viro
and others :-) (in particular, that asm/namei.h crud can
now die)

Note that I also have a set of NUMA support patches pending for
sparc64, but that work depends upon some infrastructure coming in via
the powerpc tree.  So once that's in, I'll send that over too.

Please pull, thanks a lot!

The following changes since commit 3925e6fc1f774048404fdd910b0345b06c699eb4:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../jmorris/security-testing-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (1):
      [SPARC]: Remove SunOS and Solaris binary support.

 Documentation/feature-removal-schedule.txt |   11 -
 Documentation/highuid.txt                  |    2 -
 Documentation/magic-number.txt             |    1 -
 arch/sparc/Kconfig                         |   12 -
 arch/sparc/defconfig                       |  165 ++--
 arch/sparc/kernel/Makefile                 |   10 +-
 arch/sparc/kernel/entry.S                  |  206 +----
 arch/sparc/kernel/errtbls.c                |  144 ---
 arch/sparc/kernel/head.S                   |   37 +-
 arch/sparc/kernel/sclow.S                  |   86 --
 arch/sparc/kernel/signal.c                 |  307 +------
 arch/sparc/kernel/sparc_ksyms.c            |    8 -
 arch/sparc/kernel/sunos_asm.S              |   67 --
 arch/sparc/kernel/sunos_ioctl.c            |  230 -----
 arch/sparc/kernel/sys_solaris.c            |   35 -
 arch/sparc/kernel/sys_sunos.c              | 1210 -------------------------
 arch/sparc/kernel/systbls.S                |  121 ---
 arch/sparc64/Kconfig                       |   47 +-
 arch/sparc64/Makefile                      |    1 -
 arch/sparc64/defconfig                     |   29 +-
 arch/sparc64/kernel/Makefile               |    9 -
 arch/sparc64/kernel/binfmt_aout32.c        |  419 ---------
 arch/sparc64/kernel/entry.S                |   61 +--
 arch/sparc64/kernel/signal.c               |    1 -
 arch/sparc64/kernel/signal32.c             |  300 +------
 arch/sparc64/kernel/sparc64_ksyms.c        |   41 -
 arch/sparc64/kernel/sunos_ioctl32.c        |  275 ------
 arch/sparc64/kernel/sys_sparc.c            |   38 -
 arch/sparc64/kernel/sys_sunos32.c          | 1359 ----------------------------
 arch/sparc64/kernel/systbls.S              |  122 ---
 arch/sparc64/kernel/systbls.h              |    2 -
 arch/sparc64/kernel/ttable.S               |   14 +-
 arch/sparc64/solaris/Makefile              |   10 -
 arch/sparc64/solaris/conv.h                |   38 -
 arch/sparc64/solaris/entry64.S             |  223 -----
 arch/sparc64/solaris/fs.c                  |  745 ---------------
 arch/sparc64/solaris/ioctl.c               |  825 -----------------
 arch/sparc64/solaris/ipc.c                 |  126 ---
 arch/sparc64/solaris/misc.c                |  786 ----------------
 arch/sparc64/solaris/signal.c              |  429 ---------
 arch/sparc64/solaris/signal.h              |  108 ---
 arch/sparc64/solaris/socket.c              |  461 ----------
 arch/sparc64/solaris/socksys.c             |  203 -----
 arch/sparc64/solaris/socksys.h             |  208 -----
 arch/sparc64/solaris/systbl.S              |  285 ------
 arch/sparc64/solaris/timod.c               |  976 --------------------
 fs/Kconfig.binfmt                          |    2 +-
 include/asm-sparc/Kbuild                   |    1 -
 include/asm-sparc/a.out-core.h             |   52 --
 include/asm-sparc/a.out.h                  |   97 --
 include/asm-sparc/head.h                   |   33 -
 include/asm-sparc/ioctls.h                 |    2 -
 include/asm-sparc/mman.h                   |   13 -
 include/asm-sparc/namei.h                  |   15 +-
 include/asm-sparc/pconf.h                  |   25 -
 include/asm-sparc/processor.h              |    3 -
 include/asm-sparc/socket.h                 |    3 -
 include/asm-sparc/solerrno.h               |  132 ---
 include/asm-sparc/svr4.h                   |  119 ---
 include/asm-sparc/termios.h                |    5 -
 include/asm-sparc/user.h                   |   56 +--
 include/asm-sparc64/Kbuild                 |    1 -
 include/asm-sparc64/a.out-core.h           |   31 -
 include/asm-sparc64/a.out.h                |    1 -
 include/asm-sparc64/ioctls.h               |    2 -
 include/asm-sparc64/mman.h                 |   13 -
 include/asm-sparc64/namei.h                |   15 +-
 include/asm-sparc64/pconf.h                |   25 -
 include/asm-sparc64/socket.h               |    3 -
 include/asm-sparc64/solerrno.h             |  132 ---
 include/asm-sparc64/svr4.h                 |  120 ---
 include/asm-sparc64/termios.h              |    5 -
 include/asm-sparc64/ttable.h               |   18 -
 include/asm-sparc64/unistd.h               |   10 -
 include/asm-sparc64/user.h                 |   61 +--
 net/core/sock.c                            |    9 -
 76 files changed, 172 insertions(+), 11625 deletions(-)
 delete mode 100644 arch/sparc/kernel/errtbls.c
 delete mode 100644 arch/sparc/kernel/sclow.S
 delete mode 100644 arch/sparc/kernel/sunos_asm.S
 delete mode 100644 arch/sparc/kernel/sunos_ioctl.c
 delete mode 100644 arch/sparc/kernel/sys_solaris.c
 delete mode 100644 arch/sparc/kernel/sys_sunos.c
 delete mode 100644 arch/sparc64/kernel/binfmt_aout32.c
 delete mode 100644 arch/sparc64/kernel/sunos_ioctl32.c
 delete mode 100644 arch/sparc64/kernel/sys_sunos32.c
 delete mode 100644 arch/sparc64/solaris/Makefile
 delete mode 100644 arch/sparc64/solaris/conv.h
 delete mode 100644 arch/sparc64/solaris/entry64.S
 delete mode 100644 arch/sparc64/solaris/fs.c
 delete mode 100644 arch/sparc64/solaris/ioctl.c
 delete mode 100644 arch/sparc64/solaris/ipc.c
 delete mode 100644 arch/sparc64/solaris/misc.c
 delete mode 100644 arch/sparc64/solaris/signal.c
 delete mode 100644 arch/sparc64/solaris/signal.h
 delete mode 100644 arch/sparc64/solaris/socket.c
 delete mode 100644 arch/sparc64/solaris/socksys.c
 delete mode 100644 arch/sparc64/solaris/socksys.h
 delete mode 100644 arch/sparc64/solaris/systbl.S
 delete mode 100644 arch/sparc64/solaris/timod.c
 delete mode 100644 include/asm-sparc/a.out-core.h
 delete mode 100644 include/asm-sparc/a.out.h
 delete mode 100644 include/asm-sparc/pconf.h
 delete mode 100644 include/asm-sparc/solerrno.h
 delete mode 100644 include/asm-sparc/svr4.h
 delete mode 100644 include/asm-sparc64/a.out-core.h
 delete mode 100644 include/asm-sparc64/a.out.h
 delete mode 100644 include/asm-sparc64/pconf.h
 delete mode 100644 include/asm-sparc64/solerrno.h
 delete mode 100644 include/asm-sparc64/svr4.h
