Return-Path: <linux-kernel-owner+w=401wt.eu-S1762672AbZEHAO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762672AbZEHAO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZEHAKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:10:06 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52711
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754281AbZEHAJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:09:55 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [GIT PULL] Xen core updates
Date: Thu,  7 May 2009 13:24:54 -0700
Message-Id: <1241727902-3176-1-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here's a set of core Xen updates, which is a superset of the bugfix
patches I posted earlier.

The additional patches are:

xen/i386: make sure initial VGA/ISA mappings are not overridden

  Make sure that ISA identity mappings are not overridden by _PAGE_IOMAP
  mappings.

x86: use flush_tlb_others to implement flush_tlb_all

  Paravirtualize flush_tlb_all by implementing it in terms of
  flush_tlb_others.  This avoids some unnecessary IPIs when flushing
  kernel mappings.

xen: cache cr0 value to avoid trap'n'emulate for read_cr0

  read_cr0 is used every context switch to set TS, but Xen has been
  implementing it with a trap'n'emulate of a native "mov cr0".  This
  adds a Xen-specific implementation of the read_cr0 pvop to avoid
  the extra trap.


The following changes since commit e7c064889606aab3569669078c69b87b2c527e72:
  Jeremy Fitzhardinge (1):
        xen: add FIX_TEXT_POKE to fixmap

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git xen-tip/core

Jeremy Fitzhardinge (8):
      xen/x86-64: fix breakpoints and hardware watchpoints
      xen/x86-64: clean up warnings about IST-using traps
      xen: cache cr0 value to avoid trap'n'emulate for read_cr0
      xen: deal with NMI's use of IST too
      xen/i386: make sure initial VGA/ISA mappings are not overridden
      x86: use flush_tlb_others to implement flush_tlb_all
      xen/i386: reserve Xen pagetables
      xen: reserve Xen start_info rather than e820 reserving

 arch/x86/include/asm/traps.h |    2 +
 arch/x86/kernel/entry_64.S   |    4 +++
 arch/x86/mm/tlb.c            |   29 ++++++++++++++--------
 arch/x86/xen/enlighten.c     |   54 ++++++++++++++++++++++++++++++++++++++++-
 arch/x86/xen/mmu.c           |   23 ++++++++++++++++-
 arch/x86/xen/setup.c         |    6 ++--
 6 files changed, 100 insertions(+), 18 deletions(-)

Thanks,
	J
