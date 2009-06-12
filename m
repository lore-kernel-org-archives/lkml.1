Return-Path: <linux-kernel-owner+w=401wt.eu-S1754953AbZFLMgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953AbZFLMgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbZFLMf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:35:58 -0400
Received: from ozlabs.org ([203.10.76.45]:41303 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbZFLMf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:35:58 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] module and parameter
Date: Fri, 12 Jun 2009 22:05:56 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Amerigo Wang <amwang@redhat.com>,
       alex@shark-linux.de, David Miller <davem@davemloft.net>,
       "Luck, Tony" <tony.luck@intel.com>, rth@twiddle.net
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906122205.57362.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 8ebf975608aaebd7feb33d77f07ba21a6380e086:
  Randy Dunlap (1):
        block: fix kernel-doc in recent block/ changes

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-module-and-param.git master

Amerigo Wang (4):
      x86 module: merge the same functions in module_32.c and module_64.c
      x86 module: merge the rest functions with macros
      uml module: fix uml build process due to this merge
      module: merge module_alloc() finally

Rusty Russell (8):
      cyber2000fb.c: use proper method for stopping unload if CONFIG_ARCH_SHARK
      module_param: invbool should take a 'bool', not an 'int'
      module_param: split perm field into flags and perm
      module_param: add __same_type convenience wrapper for __builtin_types_compatible_p
      module_param: allow 'bool' module_params to be bool, not just int.
      uvesafb: improve parameter handling.
      module: trim exception table on init free.
      module: cleanup FIXME comments about trimming exception table entries.

 arch/alpha/mm/extable.c                   |   21 ++++
 arch/avr32/kernel/module.c                |    2 -
 arch/cris/kernel/module.c                 |    2 -
 arch/frv/kernel/module.c                  |    2 -
 arch/h8300/kernel/module.c                |    2 -
 arch/ia64/mm/extable.c                    |   26 +++++
 arch/m32r/kernel/module.c                 |    2 -
 arch/m68k/kernel/module.c                 |    2 -
 arch/m68knommu/kernel/module.c            |    2 -
 arch/mips/kernel/module.c                 |    2 -
 arch/mn10300/kernel/module.c              |    2 -
 arch/parisc/kernel/module.c               |    2 -
 arch/powerpc/kernel/module.c              |    2 -
 arch/s390/kernel/module.c                 |    2 -
 arch/sh/kernel/module.c                   |    2 -
 arch/sparc/include/asm/uaccess_32.h       |    3 +
 arch/sparc/kernel/module.c                |    2 -
 arch/sparc/mm/extable.c                   |   29 ++++++
 arch/um/include/asm/pgtable.h             |    7 +-
 arch/um/sys-i386/Makefile                 |    2 +-
 arch/um/sys-x86_64/Makefile               |    4 +-
 arch/um/sys-x86_64/um_module.c            |   21 ----
 arch/x86/include/asm/pgtable_32_types.h   |    4 +
 arch/x86/kernel/Makefile                  |    2 +-
 arch/x86/kernel/{module_64.c => module.c} |   82 +++++++++++++---
 arch/x86/kernel/module_32.c               |  152 -----------------------------
 arch/xtensa/kernel/module.c               |    2 -
 drivers/video/aty/aty128fb.c              |    2 +-
 drivers/video/cyber2000fb.c               |    9 +-
 drivers/video/uvesafb.c                   |   10 +-
 include/linux/compiler.h                  |    5 +
 include/linux/module.h                    |    1 +
 include/linux/moduleparam.h               |   40 ++++++--
 kernel/module.c                           |    1 +
 kernel/params.c                           |   46 ++++++---
 lib/extable.c                             |   21 ++++-
 36 files changed, 256 insertions(+), 262 deletions(-)
 delete mode 100644 arch/um/sys-x86_64/um_module.c
 rename arch/x86/kernel/{module_64.c => module.c} (74%)
 delete mode 100644 arch/x86/kernel/module_32.c

