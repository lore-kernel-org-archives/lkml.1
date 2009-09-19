Return-Path: <linux-kernel-owner+w=401wt.eu-S1754971AbZISGvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbZISGvn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 02:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbZISGvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 02:51:42 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:54071 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbZISGvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 02:51:41 -0400
Date: Sat, 19 Sep 2009 02:51:26 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sfi-devel@simplefirmware.org, x86@kernel.org
Subject: [git pull request] SFI for Linux
Message-id: <alpine.LFD.2.00.0909190242310.22030@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-sfi-2.6.git sfi-release

This tree supports the Simple Firmware Interface for Linux
http://simplefirmware.org/ which is required in order to boot Linux
on Intel's upcoming Moorestown platform.

The x86 maintainers have acked the bits that touch x86, though
I didn't re-base the patches to note that because the commits
are shared by multiple trees.

Also, if you pull this tree before pulling the ACPI tree,
you'll pull along a few preceeding ACPI patches that were
necessary to add SFI support.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on sfi-devel@simplefirmware.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/sfi/patches/2.6.31/acpi-sfi-release-20090521-2.6.31.diff.gz

 MAINTAINERS                    |   12 ++
 arch/x86/Kconfig               |    4 +-
 arch/x86/kernel/Makefile       |    1 +
 arch/x86/kernel/setup.c        |    3 +
 arch/x86/kernel/sfi.c          |  122 ++++++++++++
 arch/x86/pci/mmconfig-shared.c |    6 +-
 arch/x86/pci/mmconfig_32.c     |    2 +-
 drivers/Makefile               |    1 +
 drivers/sfi/Kconfig            |   17 ++
 drivers/sfi/Makefile           |    3 +
 drivers/sfi/sfi_acpi.c         |  175 +++++++++++++++++
 drivers/sfi/sfi_core.c         |  407 ++++++++++++++++++++++++++++++++++++++++
 drivers/sfi/sfi_core.h         |   70 +++++++
 include/linux/sfi.h            |  206 ++++++++++++++++++++
 include/linux/sfi_acpi.h       |   93 +++++++++
 init/main.c                    |    2 +
 16 files changed, 1120 insertions(+), 4 deletions(-)
 create mode 100644 arch/x86/kernel/sfi.c
 create mode 100644 drivers/sfi/Kconfig
 create mode 100644 drivers/sfi/Makefile
 create mode 100644 drivers/sfi/sfi_acpi.c
 create mode 100644 drivers/sfi/sfi_core.c
 create mode 100644 drivers/sfi/sfi_core.h
 create mode 100644 include/linux/sfi.h
 create mode 100644 include/linux/sfi_acpi.h

through these commits:

Feng Tang (6):
      SFI: create linux/sfi.h
      SFI: add platform-independent core support
      SFI: add capability to parse ACPI tables
      x86: add arch-specific SFI support
      SFI: Hook PCI MMCONFIG
      SFI: remove unneeded includes

Len Brown (1):
      SFI: Simple Firmware Interface - MAINTAINERS, Kconfig

Thomas Gleixner (1):
      sfi: Remove unused code

with this log:

commit c602c65b2f81d14456771d1e3f15d1381f4b7efa
Merge: 3834f47 78f28b7
Author: Len Brown <len.brown@intel.com>
Date:   Sat Sep 19 00:11:26 2009 -0400

    Merge branch 'linus' into sfi-release
    
    Conflicts:
    	arch/x86/kernel/setup.c
    	drivers/acpi/power.c
    	init/main.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3834f47291df475be3f0f0fb7ccaa098967cc054
Author: Feng Tang <feng.tang@intel.com>
Date:   Mon Sep 14 13:01:53 2009 +0800

    SFI: remove unneeded includes
    
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8079ce34f2c3f5bfedcea8d4fb7290ce46ac5b56
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Mon Aug 31 16:49:19 2009 +0200

    sfi: Remove unused code
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5f0db7a2fb78895a197f64e548333b3bbd433996
Author: Feng Tang <feng.tang@intel.com>
Date:   Fri Aug 14 15:37:50 2009 -0400

    SFI: Hook PCI MMCONFIG
    
    First check ACPI, and if that fails, ask SFI to find the MCFG.
    
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
    Cc: Jesse Barnes <jbarnes@virtuousgeek.org>

commit efafc8b213e67ed148a5b53ade29ee7b48af907d
Author: Feng Tang <feng.tang@intel.com>
Date:   Fri Aug 14 15:23:29 2009 -0400

    x86: add arch-specific SFI support
    
    arch/x86/kernel/sfi.c serves the dual-purpose of supporting the
    SFI core with arch specific code, as well as a home for the
    arch-specific code that uses SFI.
    
    analogous to ACPI, drivers/sfi/Kconfig is pulled in by arch/x86/Kconfig
    
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
    Cc: x86@kernel.org

commit 13e82d023c4c3f13ab1e665cbb917a7ebba8935c
Author: Feng Tang <feng.tang@intel.com>
Date:   Fri Aug 14 15:17:53 2009 -0400

    SFI: add capability to parse ACPI tables
    
    Extend SFI to access standard ACPI tables.
    (eg. the PCI MCFG) using sfi_acpi_table_parse().
    
    Note that this is _not_ a hybrid ACPI + SFI mode.
    The platform boots in either ACPI mode or SFI mode.
    
    SFI runs only with acpi_disabled=1, which can be set
    at build-time via CONFIG_ACPI=n, or at boot time by
    the failure to find ACPI platform support.
    
    So this extension simply allows SFI-platforms to
    re-use existing standard table formats that happen to
    be defined to live in ACPI envelopes.
    
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6ae6996a466e14bcf41618cde641a74ae03dc285
Author: Feng Tang <feng.tang@intel.com>
Date:   Fri Aug 14 15:13:46 2009 -0400

    SFI: add platform-independent core support
    
    drivers/sfi/sfi_core.c contains the generic SFI implementation.
    It has a private header, sfi_core.h, for its own use and the
    private use of future files in drivers/sfi/
    
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 117a9ac777f8034d4675b821172d2ff71f6ec47a
Author: Feng Tang <feng.tang@intel.com>
Date:   Fri Aug 14 15:10:24 2009 -0400

    SFI: create linux/sfi.h
    
    include/linux/include/sfi.h defines everything that customers
    of SFI need to know in order to use the SFI suport in the kernel.
    
    The primary API is sfi_table_parse(), where a driver or another part
    of the kernel can supply a handler to parse the named table.
    
    sfi.h also includes the currently defined table signatures and table
    formats.
    
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6349d9979beba240fe7182872cb547250264b865
Author: Len Brown <len.brown@intel.com>
Date:   Fri Aug 14 15:07:14 2009 -0400

    SFI: Simple Firmware Interface - MAINTAINERS, Kconfig
    
    CONFIG_SFI=y enables the kernel to boot and run optimally
    on platforms that support the Simple Firmware Interface.
    
    Thanks to Jacob Pan for prototyping the initial Linux SFI support,
    and to Feng Tang for Linux bring-up and debug both in emulation
    and on Moorestown hardware.
    
    See http://simplefirmware.org for more information on SFI.
    
    Signed-off-by: Len Brown <len.brown@intel.com>
