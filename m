Return-Path: <linux-kernel-owner+w=401wt.eu-S1761793AbZFQUmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761793AbZFQUmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 16:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761172AbZFQUmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 16:42:00 -0400
Received: from ottawa-hs-64-26-170-27.d-ip.magma.ca ([64.26.170.27]:59300 "EHLO
	gonzo.int.wil.cx" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756686AbZFQUl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 16:41:57 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: torvalds@linux-foundation.org, jbarnes@virtuousgeek.org
Cc: andrew.patterson@hp.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: 
Date: Wed, 17 Jun 2009 16:33:32 -0400
Message-Id: <1245270816-11755-1-git-send-email-willy@linux.intel.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This series of four patches are a result of the resource problem Andrew
Patterson ran into on the HP rx6600.  First, I fix pci_claim_resource(),
then I get rid of the now-unused pcibios_select_root().  The third patch
changes x86 to use pci_claim_resource (since it's now essentially equivalent).
The fourth patch actually fixes Andrew's problem by changing where ia64
sets up the resource pointers in the root pci_bus.

If you don't want to take all this, only patches 1 and 4 are bug-fixes.
Patch 2 might have a problem if someone chooses to start using
pcibios_select_root (I can't imagine they will ...), and patch 3 is the
most risky.

Diffstat:

 arch/alpha/include/asm/pci.h    |   13 -------------
 arch/arm/include/asm/pci.h      |   13 -------------
 arch/ia64/include/asm/pci.h     |   13 -------------
 arch/ia64/pci/pci.c             |    4 ++--
 arch/mips/include/asm/pci.h     |   13 -------------
 arch/mn10300/include/asm/pci.h  |   13 -------------
 arch/parisc/include/asm/pci.h   |   13 -------------
 arch/powerpc/include/asm/pci.h  |   13 -------------
 arch/sh/include/asm/pci.h       |   13 -------------
 arch/sparc/include/asm/pci_64.h |    2 --
 arch/sparc/kernel/pci.c         |   13 -------------
 arch/x86/pci/i386.c             |   17 +++++++----------
 drivers/pci/setup-res.c         |    4 ++--
 include/asm-generic/pci.h       |   13 -------------
 14 files changed, 11 insertions(+), 146 deletions(-)

