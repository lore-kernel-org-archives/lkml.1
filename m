Return-Path: <linux-kernel-owner+w=401wt.eu-S1763447AbZEHASv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763447AbZEHASv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758779AbZEHAKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:10:20 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52717
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755020AbZEHAJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:09:58 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [GIT PULL] x86: paravirt_ops updates
Date: Thu,  7 May 2009 13:32:48 -0700
Message-Id: <1241728373-3537-1-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This series has a some changes to x86 paravirt_ops:

x86/paravirt: split paravirt definitions into paravirt_types.h

  Move all the type-like definitions into asm/paravirt_types.h

x86: split out core __math_state_restore

  Split out the core of math_state_restore() into __math_state_restore(),
  which just does what's needed for a context switch (ie, assumes
  TS is already clear, and that the fpu context exists).

x86-32: make sure clts is batched during context switch
x86-64: move unlazy_fpu() into lazy cpu state part of context switch
x86-64: move clts into batch cpu state updates when preloading fpu

  Make sure the TS state updates during context switch are performed in
  the lazy CPU update region so that they can be batched when running
  paravirtualized.

The following changes since commit 9ce5424d75e56891905b77d1589924765e62059a:
  Ingo Molnar (1):
        Merge branch 'x86/urgent'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git x86/paravirt

Jeremy Fitzhardinge (5):
      x86/paravirt: split paravirt definitions into paravirt_types.h
      x86: split out core __math_state_restore
      x86-32: make sure clts is batched during context switch
      x86-64: move unlazy_fpu() into lazy cpu state part of context switch
      x86-64: move clts into batch cpu state updates when preloading fpu

 arch/x86/include/asm/i387.h           |    1 +
 arch/x86/include/asm/paravirt.h       |  711 +--------------------------------
 arch/x86/include/asm/paravirt_types.h |  720 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/process_32.c          |   27 +-
 arch/x86/kernel/process_64.c          |   34 +-
 arch/x86/kernel/traps.c               |   33 +-
 6 files changed, 783 insertions(+), 743 deletions(-)
 create mode 100644 arch/x86/include/asm/paravirt_types.h

Thanks,
	J
