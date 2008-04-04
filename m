Return-Path: <linux-kernel-owner+w=401wt.eu-S1760999AbYDDM6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760999AbYDDM6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 08:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759573AbYDDMzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:55:10 -0400
Received: from saeurebad.de ([85.214.36.134]:44713 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756728AbYDDMyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:54:49 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:52:30 2008
Message-Id: <20080404115137.397502419@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:51:37 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 00/22 -v2] Generic show_mem()
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every arch implements its own show_mem() function.  Most of them share
quite some code, some of them are completely identical.

This series implements a generic version of this function and migrates
almost all architectures to it.

---
version 2:
	- Fix kbuild bits as suggested by Heiko Carstens
	- Include quicklist info as suggested by Paul Mundt
	- Extend changelogs by info on removal of redundant output

Note: This patchset is based on the `Remove redundant display of free
swap space from show_mem()' series. 

 arch/alpha/mm/init.c      |   29 -----------------------
 arch/alpha/mm/numa.c      |   34 ---------------------------
 arch/arm/Kconfig          |    1 +
 arch/avr32/mm/init.c      |   39 -------------------------------
 arch/blackfin/mm/init.c   |   27 ----------------------
 arch/cris/mm/init.c       |   30 ------------------------
 arch/frv/mm/init.c        |   31 -------------------------
 arch/h8300/mm/init.c      |   28 -----------------------
 arch/ia64/Kconfig         |    1 +
 arch/m32r/mm/init.c       |   35 ----------------------------
 arch/m68k/mm/init.c       |   30 ------------------------
 arch/m68knommu/mm/init.c  |   28 -----------------------
 arch/mips/mm/Makefile     |    3 +-
 arch/mips/mm/pgtable.c    |   36 -----------------------------
 arch/mn10300/mm/pgtable.c |   27 ----------------------
 arch/parisc/Kconfig       |    1 +
 arch/powerpc/mm/mem.c     |   39 -------------------------------
 arch/ppc/mm/init.c        |   30 ------------------------
 arch/s390/mm/init.c       |   35 ----------------------------
 arch/sh/mm/init.c         |   40 --------------------------------
 arch/sparc/Kconfig        |    1 +
 arch/sparc64/mm/init.c    |   43 -----------------------------------
 arch/um/kernel/mem.c      |   29 -----------------------
 arch/v850/kernel/setup.c  |   30 ------------------------
 arch/x86/mm/init_64.c     |   37 ------------------------------
 arch/x86/mm/pgtable_32.c  |   47 --------------------------------------
 arch/xtensa/mm/init.c     |   26 ---------------------
 mm/Kconfig                |    3 ++
 mm/page_alloc.c           |   55 +++++++++++++++++++++++++++++++++++++++++++++
 mm/swap_state.c           |    3 +-
 30 files changed, 65 insertions(+), 733 deletions(-)

