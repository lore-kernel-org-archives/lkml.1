Return-Path: <linux-kernel-owner+w=401wt.eu-S1757234AbYDGPtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234AbYDGPtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 11:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbYDGPtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 11:49:11 -0400
Received: from saeurebad.de ([85.214.36.134]:44720 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbYDGPtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 11:49:10 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Mon Apr  7 16:42:39 2008
Message-Id: <20080407144008.124362640@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Mon, 07 Apr 2008 16:40:08 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 00/22 -v3] Generic show_mem()
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every arch implements its own show_mem() function.  Most of them share
quite some code, some of them are completely identical.

This series implements a generic version of this function and migrates
almost all architectures to it.

---
version 3:
	- Fix kbuild logic as suggested by Sam Ravnborg

version 2:
	- Fix kbuild bits as suggested by Heiko Carstens
	- Include quicklist info as suggested by Paul Mundt
	- Extend changelogs by info on removal of redundant output

Note: This patchset is based on the `Remove redundant display of free
swap space from show_mem()' series. 

 arch/alpha/Kconfig        |    1 +
 arch/alpha/mm/init.c      |   29 -----------------------
 arch/alpha/mm/numa.c      |   34 ---------------------------
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
 arch/m32r/mm/init.c       |   35 ----------------------------
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
 arch/ppc/Kconfig          |    1 +
 arch/ppc/mm/init.c        |   30 ------------------------
 arch/s390/Kconfig         |    1 +
 arch/s390/mm/init.c       |   35 ----------------------------
 arch/sh/Kconfig           |    1 +
 arch/sh/mm/init.c         |   40 --------------------------------
 arch/sparc64/Kconfig      |    1 +
 arch/sparc64/mm/init.c    |   43 -----------------------------------
 arch/um/Kconfig           |    1 +
 arch/um/kernel/mem.c      |   29 -----------------------
 arch/v850/Kconfig         |    1 +
 arch/v850/kernel/setup.c  |   30 ------------------------
 arch/x86/Kconfig          |    1 +
 arch/x86/mm/init_64.c     |   37 ------------------------------
 arch/x86/mm/pgtable_32.c  |   47 --------------------------------------
 arch/xtensa/Kconfig       |    1 +
 arch/xtensa/mm/init.c     |   26 ---------------------
 mm/Kconfig                |    3 ++
 mm/page_alloc.c           |   55 +++++++++++++++++++++++++++++++++++++++++++++
 mm/swap_state.c           |    3 +-
 46 files changed, 81 insertions(+), 731 deletions(-)

