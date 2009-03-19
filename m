Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbZCSAdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbZCSAdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 20:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbZCSAcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 20:32:54 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:44656 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753088AbZCSAcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 20:32:53 -0400
Date: Thu, 19 Mar 2009 10:28:57 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200903190028.n2J0Sv7h002641@localhost.localdomain>
To: torvalds@linux-foundation.org
Subject: [git pull] m68k fix user exported includes
Cc: dwmw2@infradead.org, geert@linux-m68k.org, gerg@uclinux.org,
       linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
       linux-next@vger.kernel.org, rob@landley.net, sam@ravnborg.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

The merge of the m68knommu and m68k includes broke "headers_install"
for these arches. For files with differences on each of m68k and m68knommu
a simple include of either varient was done for many of the user exported
headers. But the specific files that are included are not exported by
"headers_install".

The problem results in errors like:

  build/cross-compiler-m68k/include/asm/param.h:4:22: error: param_mm.h: No
  such file or directory

when building user space libraries.

Files known to be affected are:

  param.h ptrace.h setup.h sigcontext.h siginfo.h signal.h swab.h unistd.h

All of these cases only have minor differences for each of the m68k and
m68knommu varient. The best solution is to merge back into a single file
for these cases (which was always the longer term intention anyway).

Geert Uytterhoeven has checked m68k builds are still ok with this.
Rob Landley has confirmed uClibc now builds (for m68k) with this.
I have checked m68knommu builds are still ok.

Please pull to get a fix for this regresion.

Thanks
Greg



The following changes since commit 5bee17f18b595937e6beafeee5197868a3f74a06:
  Kyle McMartin (1):
        parisc: sba_iommu: fix build bug when CONFIG_PARISC_AGP=y

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git fix-includes

Greg Ungerer (8):
      m68k: merge the non-MMU and MMU versions of param.h
      m68k: merge the non-MMU and MMU versions of swab.h
      m68k: merge the non-MMU and MMU versions of sigcontext.h
      m68k: use MMU version of setup.h for both MMU and non-MMU
      m68k: merge the non-MMU and MMU versions of ptrace.h
      m68k: merge the non-MMU and MMU versions of signal.h
      m68k: use the MMU version of unistd.h for all m68k platforms
      m68k: merge the non-MMU and MMU versions of siginfo.h

 arch/m68k/include/asm/param.h         |   25 ++-
 arch/m68k/include/asm/param_mm.h      |   22 --
 arch/m68k/include/asm/param_no.h      |   22 --
 arch/m68k/include/asm/ptrace.h        |   88 ++++++++-
 arch/m68k/include/asm/ptrace_mm.h     |   80 -------
 arch/m68k/include/asm/ptrace_no.h     |   87 --------
 arch/m68k/include/asm/setup.h         |  377 ++++++++++++++++++++++++++++++++-
 arch/m68k/include/asm/setup_mm.h      |  376 --------------------------------
 arch/m68k/include/asm/setup_no.h      |   10 -
 arch/m68k/include/asm/sigcontext.h    |   25 ++-
 arch/m68k/include/asm/sigcontext_mm.h |   19 --
 arch/m68k/include/asm/sigcontext_no.h |   17 --
 arch/m68k/include/asm/siginfo.h       |   98 +++++++++-
 arch/m68k/include/asm/siginfo_mm.h    |   92 --------
 arch/m68k/include/asm/siginfo_no.h    |    6 -
 arch/m68k/include/asm/signal.h        |  216 ++++++++++++++++++-
 arch/m68k/include/asm/signal_mm.h     |  206 ------------------
 arch/m68k/include/asm/signal_no.h     |  159 --------------
 arch/m68k/include/asm/swab.h          |   30 +++-
 arch/m68k/include/asm/swab_mm.h       |   16 --
 arch/m68k/include/asm/swab_no.h       |   24 --
 arch/m68k/include/asm/unistd.h        |  377 ++++++++++++++++++++++++++++++++-
 arch/m68k/include/asm/unistd_mm.h     |  372 --------------------------------
 arch/m68k/include/asm/unistd_no.h     |  372 --------------------------------
 24 files changed, 1209 insertions(+), 1907 deletions(-)
 delete mode 100644 arch/m68k/include/asm/param_mm.h
 delete mode 100644 arch/m68k/include/asm/param_no.h
 delete mode 100644 arch/m68k/include/asm/ptrace_mm.h
 delete mode 100644 arch/m68k/include/asm/ptrace_no.h
 delete mode 100644 arch/m68k/include/asm/setup_mm.h
 delete mode 100644 arch/m68k/include/asm/setup_no.h
 delete mode 100644 arch/m68k/include/asm/sigcontext_mm.h
 delete mode 100644 arch/m68k/include/asm/sigcontext_no.h
 delete mode 100644 arch/m68k/include/asm/siginfo_mm.h
 delete mode 100644 arch/m68k/include/asm/siginfo_no.h
 delete mode 100644 arch/m68k/include/asm/signal_mm.h
 delete mode 100644 arch/m68k/include/asm/signal_no.h
 delete mode 100644 arch/m68k/include/asm/swab_mm.h
 delete mode 100644 arch/m68k/include/asm/swab_no.h
 delete mode 100644 arch/m68k/include/asm/unistd_mm.h
 delete mode 100644 arch/m68k/include/asm/unistd_no.h

