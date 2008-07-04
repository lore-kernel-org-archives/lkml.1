Return-Path: <linux-kernel-owner+w=401wt.eu-S1759518AbYGDQvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518AbYGDQvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 12:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbYGDQu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:50:59 -0400
Received: from saeurebad.de ([85.214.36.134]:38508 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705AbYGDQu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:50:58 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri Jul  4 18:14:52 2008
Message-Id: <20080704160737.750988999@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 04 Jul 2008 18:07:37 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 00/20] generic show_mem() v5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every arch implements its own show_mem() function.  Most of them share
quite some code, some of them are completely identical.

This series implements a generic version of this function and migrates
almost all architectures to it.

version 5:
	- removed the Kconfig parts and moved generic version to lib/
	  as suggested by Paul Mundt.  We now touch half the files and
	  save even more lines!
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

Compile- and runtime-tested on x86_32.

 arch/alpha/mm/init.c      |   30 ---------------------
 arch/alpha/mm/numa.c      |   35 -------------------------
 arch/avr32/mm/init.c      |   39 ---------------------------
 arch/blackfin/mm/init.c   |   27 -------------------
 arch/cris/mm/init.c       |   30 ---------------------
 arch/frv/mm/init.c        |   31 ----------------------
 arch/h8300/mm/init.c      |   27 -------------------
 arch/m32r/mm/init.c       |   36 -------------------------
 arch/m68k/mm/init.c       |   30 ---------------------
 arch/m68knommu/mm/init.c  |   27 -------------------
 arch/mips/mm/Makefile     |    3 +-
 arch/mips/mm/pgtable.c    |   36 -------------------------
 arch/mn10300/mm/pgtable.c |   27 -------------------
 arch/powerpc/mm/mem.c     |   39 ---------------------------
 arch/s390/mm/init.c       |   32 -----------------------
 arch/sh/mm/init.c         |   41 -----------------------------
 arch/sparc64/mm/init.c    |   45 --------------------------------
 arch/um/kernel/mem.c      |   31 ----------------------
 arch/x86/mm/init_64.c     |   37 --------------------------
 arch/x86/mm/pgtable_32.c  |   47 ---------------------------------
 arch/xtensa/mm/init.c     |   26 ------------------
 lib/Makefile              |    2 +-
 lib/show_mem.c            |   63 +++++++++++++++++++++++++++++++++++++++++++++
 mm/swap_state.c           |    3 +-
 24 files changed, 67 insertions(+), 677 deletions(-)

