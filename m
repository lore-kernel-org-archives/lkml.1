Return-Path: <linux-kernel-owner+w=401wt.eu-S1757705AbZBFDxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705AbZBFDxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 22:53:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbZBFDwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 22:52:53 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:59969 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbZBFDww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 22:52:52 -0500
MBOX-Line: From nobody Thu Feb  5 20:45:12 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 0/3] OMAP3: add ES3.1 support; disable USBTLL SAR < ES3.1
To: linux@arm.linux.org.uk
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, r-woodruff2@ti.com
Date: Thu, 05 Feb 2009 20:45:12 -0700
Message-ID: <20090206033847.31313.45612.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

this series adds OMAP3 ES3.1 support, including boot-time TAP detection and
omap_chip updates.  It also blocks USBTLL hardware save-and-restore (SAR)
support on revisions < ES3.1, due to chip errata.

To do this, the semantics of the omap_chip system had to be altered slightly.
Previously, CHIP_IS_OMAP3430ES2 would also evaluate true on ES3 devices.
Now it will only evaluate to true on ES2.x devices.  Features that are
present on revisions >= ES2 are now marked with CHIP_GE_OMAP3430ES2 ("GE"
meaning "greater than or equal to").

This series obsoletes patch B 06, and is intended to be applied after
all of the previously-sent patches.

Tested on BeagleBoard ES2.1.


- Paul


---

Paul Walmsley (2):
      OMAP3 powerdomains: make USBTLL SAR only available on ES3.1 and beyond
      OMAP3: update ES level flags to discriminate between post-ES2 revisions

Tony Lindgren (1):
      ARM: OMAP: Fix omap34xx revision detection for ES3.1


 arch/arm/mach-omap2/clockdomains.h     |    6 +++---
 arch/arm/mach-omap2/id.c               |   13 +++++++++++--
 arch/arm/mach-omap2/powerdomains.h     |    4 ++--
 arch/arm/mach-omap2/powerdomains34xx.h |   16 +++++++++-------
 arch/arm/plat-omap/include/mach/cpu.h  |   27 +++++++++++++++++++++------
 5 files changed, 46 insertions(+), 20 deletions(-)

  text    data     bss     dec     hex filename
3241338  165504  100880 3507722  35860a vmlinux.beagle.orig
3241342  165504  100880 3507726  35860e vmlinux.beagle

