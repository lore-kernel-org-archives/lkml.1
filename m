Return-Path: <linux-kernel-owner+w=401wt.eu-S1760289AbZBMTkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289AbZBMTkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 14:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbZBMTkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 14:40:35 -0500
Received: from gw.goop.org ([64.81.55.164]:54281 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbZBMTkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 14:40:35 -0500
Message-ID: <4995CCB1.9070404@goop.org>
Date: Fri, 13 Feb 2009 11:40:33 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: more untangling
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've done the asm _types.h and page->pgtable moves.  One hiccup is 
kernel/head_64.S uses pgd_index(), which is defined as an asm-compatible 
macro in pgtable.h.  Its a bit warty because it also needs pud_index(), 
which it defines locally (which is an inline in pgtable.h).  Need to 
think about that one...

    J

The following changes since commit beb6943d8df7ce9278282101af4e0f6f7b648451:
  Ingo Molnar (1):
        x86 headers: protect page_32.h via __ASSEMBLY__

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git x86/untangle2

Jeremy Fitzhardinge (2):
      x86: use _types.h headers in asm where available
      x86: move more pagetable-related definitions into pgtable*.h

 arch/x86/boot/compressed/head_32.S          |    2 +-
 arch/x86/boot/compressed/head_64.S          |    4 ++--
 arch/x86/boot/header.S                      |    2 +-
 arch/x86/include/asm/page_32_types.h        |    2 --
 arch/x86/include/asm/page_64_types.h        |    2 --
 arch/x86/include/asm/page_types.h           |    6 ------
 arch/x86/include/asm/pgtable-2level_types.h |    2 ++
 arch/x86/include/asm/pgtable-3level_types.h |    2 ++
 arch/x86/include/asm/pgtable_64_types.h     |    1 +
 arch/x86/include/asm/pgtable_types.h        |    6 ++++++
 arch/x86/kernel/acpi/realmode/wakeup.S      |    4 ++--
 arch/x86/kernel/acpi/wakeup_32.S            |    2 +-
 arch/x86/kernel/acpi/wakeup_64.S            |    4 ++--
 arch/x86/kernel/efi_stub_32.S               |    2 +-
 arch/x86/kernel/entry_32.S                  |    2 +-
 arch/x86/kernel/entry_64.S                  |    2 +-
 arch/x86/kernel/head_32.S                   |    4 ++--
 arch/x86/kernel/relocate_kernel_32.S        |    2 +-
 arch/x86/kernel/relocate_kernel_64.S        |    4 ++--
 arch/x86/kernel/trampoline_32.S             |    2 +-
 arch/x86/kernel/trampoline_64.S             |    4 ++--
 arch/x86/kernel/vmlinux_32.lds.S            |    2 +-
 arch/x86/kernel/vmlinux_64.lds.S            |    2 +-
 arch/x86/lib/getuser.S                      |    2 +-
 arch/x86/power/hibernate_asm_32.S           |    2 +-
 arch/x86/power/hibernate_asm_64.S           |    2 +-
 arch/x86/xen/xen-head.S                     |    2 +-
 27 files changed, 37 insertions(+), 36 deletions(-)


