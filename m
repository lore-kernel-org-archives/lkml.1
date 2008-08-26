Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbYHZWBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbYHZWBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 18:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYHZWBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 18:01:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbYHZWBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 18:01:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] utrace
X-Fcc: ~/Mail/linus
X-Zippy-Says: CONGRATULATIONS!  Now should I make thinly veiled comments about
    DIGNITY, self-esteem and finding TRUE FUN in your RIGHT
    VENTRICLE??
Message-Id: <20080826220102.89635154233@magilla.localdomain>
Date: Tue, 26 Aug 2008 15:01:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

utrace is a new kernel-side API for kernel modules, intended to make it
tractable to work on novel ways to trace and debug user-mode tasks.

A previous utrace prototype was in all Fedora kernels since Fedora Core 6.
Some substantial implementation and API details in the current code are
different from those past versions.  Please look freshly at these patches.

The current utrace code here is now included in Fedora Rawhide kernels.

People interested in this code are on the utrace-devel@redhat.com mailing list.
(See https://www.redhat.com/mailman/listinfo/utrace-devel for list info.)
There is a wiki for this work at http://sourceware.org/systemtap/wiki/utrace
(with not much content, feel free to add some).  Current copies of these
patches are at kept at http://people.redhat.com/roland/utrace/ as well as
in the GIT tree shown below.

This code cannot be enabled without CONFIG_HAVE_ARCH_TRACEHOOK and the arch
details it indicates.  In Linus's tree as of v2.6.27-rc4, only powerpc and
sparc64 have that support.  The x86 support is available by merging in the
tip/x86/tracehook branch.  For working on other arch support, there are some
more details at http://sourceware.org/systemtap/wiki/utrace/arch/HowTo and
these are mentioned in the comments in arch/Kconfig too (in v2.6.27-rc4).

The first patch adds the utrace kernel API (if CONFIG_UTRACE=y is set).
There is no change at all without the config option, and with it there is
no effect on anything at all until a kernel module using the utrace API is
loaded.  There is detailed documentation on the API in DocBook form.

The second patch adds the CONFIG_UTRACE_PTRACE option.  When set, this
makes ptrace use the utrace API as much as is necessary so that using both
ptrace and utrace to debug the same threads at the same time won't become
confused.  The ptrace changes are somewhat kludgey.  They're intended to be
the simplest, non-regressing thing that suffices to enable hacking on new
utrace modules while also doing normal ptrace-based debugging.  The ptrace
implementation can still use many more cleanups later on.


The following changes since commit 1941246dd98089dd637f44d3bd4f6cc1c61aa9e4:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../tiwai/sound-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-utrace.git utrace

Roland McGrath (2):
      utrace core
      utrace: ptrace cooperation

 Documentation/DocBook/Makefile    |    2 +-
 Documentation/DocBook/utrace.tmpl |  566 +++++++++
 fs/proc/array.c                   |    3 +
 include/linux/ptrace.h            |   21 +
 include/linux/sched.h             |    6 +
 include/linux/tracehook.h         |   65 +-
 include/linux/utrace.h            |  711 +++++++++++
 init/Kconfig                      |   27 +
 kernel/Makefile                   |    1 +
 kernel/ptrace.c                   |  604 +++++++++-
 kernel/signal.c                   |   14 +-
 kernel/utrace.c                   | 2511 +++++++++++++++++++++++++++++++++++++
 12 files changed, 4523 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/DocBook/utrace.tmpl
 create mode 100644 include/linux/utrace.h
 create mode 100644 kernel/utrace.c


Thanks,
Roland
