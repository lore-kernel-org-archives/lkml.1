Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbZBJTcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbZBJTcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:32:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbZBJTby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:31:54 -0500
Received: from gw.goop.org ([64.81.55.164]:51323 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640AbZBJTbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:31:53 -0500
Message-ID: <4991D626.5040009@goop.org>
Date: Tue, 10 Feb 2009 11:31:50 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] x86: more header untangling
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I updated my x86/untangle branch with a merge of tip/x86/headers, which 
needed a couple of little conflict resolutions.  Basically this series 
splits out all the simple definitions into -defs.h headers, which in 
turn only have very simple dependencies (either on other -defs.h 
headers, or core generic headers like linux/types.h).  It should go some 
way to making it easier to simplify other header's dependencies.

BTW, I've been trying to work out what the real distinction between 
asm/page*.h and asm/pgtable*.h is.  pgtable*.h obviously has stuff that 
specifically relates to the details of the page table structures, entry 
formats, bits, and so on, whereas page*.h has more general things like 
page sizes, the layout of the kernel's physical and virtual address 
spaces, etc.  So it seems like an anomaly that its page*.h which ends up 
defining all the pte_t/pteval_t/etc types and their associated 
functions.  We could move all those into pgtable*.h, but pgtable*.h 
would still depend on page*.h for things like PTE_PFN_MASK, etc, so I 
don't think it would make any practical difference.

Thanks,
    J

The following changes since commit c47c1b1f3a9d6973108020df1dcab7604f7774dd:
  Ingo Molnar (1):
        x86, pgtable.h: fix 2-level 32-bit build

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git x86/untangle

Jeremy Fitzhardinge (12):
      Include linux/mmzone to avoid cyclic dependency
      Revert "Include linux/mmzone to avoid cyclic dependency"
      Split pgtable.h into pgtable-defs.h and pgtable.h
      Split pgtable_32.h into pgtable_32.h and pgtable_32-defs.h
      Split pgtable_64.h into pgtable_64-defs.h and pgtable_64.h
      Include pgtable_32|64-defs.h in pgtable-defs.h
      create -defs.h counterparts for page*.h
      x86: move 2 and 3 level asm-generic defs into page-defs
      x86: move defs around to allow paravirt.h to just include page-defs.h
      define pud_flags and pud_large properly to allow non-PAE builds
      Merge remote branch 'tip/x86/headers' into x86/untangle
      x86: reinstate lost pud_large()

 arch/x86/include/asm/page-defs.h       |  155 ++++++++++++++++++++++
 arch/x86/include/asm/page.h            |  146 +--------------------
 arch/x86/include/asm/page_32-defs.h    |   92 +++++++++++++
 arch/x86/include/asm/page_32.h         |   89 +------------
 arch/x86/include/asm/page_64-defs.h    |  105 +++++++++++++++
 arch/x86/include/asm/page_64.h         |  101 +--------------
 arch/x86/include/asm/paravirt.h        |    2 +-
 arch/x86/include/asm/pgtable-defs.h    |  227 +++++++++++++++++++++++++++++++
 arch/x86/include/asm/pgtable.h         |  228 +-------------------------------
 arch/x86/include/asm/pgtable_32-defs.h |   46 +++++++
 arch/x86/include/asm/pgtable_32.h      |   42 +------
 arch/x86/include/asm/pgtable_64-defs.h |   46 +++++++
 arch/x86/include/asm/pgtable_64.h      |   48 +-------
 13 files changed, 688 insertions(+), 639 deletions(-)
 create mode 100644 arch/x86/include/asm/page-defs.h
 create mode 100644 arch/x86/include/asm/page_32-defs.h
 create mode 100644 arch/x86/include/asm/page_64-defs.h
 create mode 100644 arch/x86/include/asm/pgtable-defs.h
 create mode 100644 arch/x86/include/asm/pgtable_32-defs.h
 create mode 100644 arch/x86/include/asm/pgtable_64-defs.h


