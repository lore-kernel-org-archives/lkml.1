Return-Path: <linux-kernel-owner+w=401wt.eu-S1761506AbYF0MLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761506AbYF0MLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760399AbYF0MFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:05:08 -0400
Received: from saeurebad.de ([85.214.36.134]:38987 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759679AbYF0MFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:05:06 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri Jun 27 14:00:47 2008
Message-Id: <20080627115349.743368154@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:53:49 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 00/20] mm: generic show_mem() v4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every arch implements its own show_mem() function.  Most of them share
quite some code, some of them are completely identical.

This series implements a generic version of this function and migrates
almost all architectures to it.

version 4:
	- rebased against -mmotm
	- remove free swap space display from alpha, m32r, sh, sparc64,
	  um (was in a different series originally, but -mm no longer
	  has them and Linus' tree does not contain them too)
version 3:
	- Fix kbuild logic as suggested by Sam Ravnborg
version 2:
	- Fix kbuild bits as suggested by Heiko Carstens
	- Include quicklist info as suggested by Paul Mundt
	- Extend changelogs by info on removal of redundant output

 arch/alpha/Kconfig        |    1 +
 arch/alpha/mm/init.c      |   30 ------------------------
 arch/alpha/mm/numa.c      |   35 ----------------------------
 arch/avr32/Kconfig        |    1 +
 arch/avr32/mm/init.c      |   39 -------------------------------
 arch/blackfin/Kconfig     |    1 +
 arch/blackfin/mm/init.c   |   27 ----------------------
 arch/cris/Kconfig         |    1 +
 arch/cris/mm/init.c       |   30 ------------------------
 arch/frv/Kconfig          |    1 +
 arch/frv/mm/init.c        |   31 -------------------------
 arch/h8300/Kconfig        |    1 +
 arch/h8300/mm/init.c      |   27 ----------------------
 arch/m32r/Kconfig         |    1 +
 arch/m32r/mm/init.c       |   36 -----------------------------
 arch/m68k/Kconfig         |    1 +
 arch/m68k/mm/init.c       |   30 ------------------------
 arch/m68knommu/Kconfig    |    1 +
 arch/m68knommu/mm/init.c  |   27 ----------------------
 arch/mips/Kconfig         |    1 +
 arch/mips/mm/Makefile     |    3 +-
 arch/mips/mm/pgtable.c    |   36 -----------------------------
 arch/mn10300/Kconfig      |    1 +
 arch/mn10300/mm/pgtable.c |   27 ----------------------
 arch/powerpc/Kconfig      |    1 +
 arch/powerpc/mm/mem.c     |   39 -------------------------------
 arch/s390/Kconfig         |    1 +
 arch/s390/mm/init.c       |   32 --------------------------
 arch/sh/Kconfig           |    1 +
 arch/sh/mm/init.c         |   41 ---------------------------------
 arch/sparc64/Kconfig      |    1 +
 arch/sparc64/mm/init.c    |   45 ------------------------------------
 arch/um/Kconfig           |    1 +
 arch/um/kernel/mem.c      |   31 -------------------------
 arch/x86/Kconfig          |    1 +
 arch/x86/mm/init_64.c     |   37 ------------------------------
 arch/x86/mm/pgtable_32.c  |   47 --------------------------------------
 arch/xtensa/Kconfig       |    1 +
 arch/xtensa/mm/init.c     |   26 ---------------------
 mm/Kconfig                |    3 ++
 mm/page_alloc.c           |   55 +++++++++++++++++++++++++++++++++++++++++++++
 mm/swap_state.c           |    3 +-
 42 files changed, 79 insertions(+), 676 deletions(-)


