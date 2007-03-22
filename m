Return-Path: <linux-kernel-owner+w=401wt.eu-S1751890AbXCVGOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbXCVGOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 02:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbXCVGOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 02:14:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:53652 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbXCVGOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 02:14:43 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PATCH] ACPI patches for 2.6.21-rc4
Date: Thu, 22 Mar 2007 02:13:24 -0400
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703220213.24246.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This batch includes fixes to two visible 2.6.21 regressions -- the immediate suspend wakeup,
and the the acpi_serialize deadlock.  The later is a revert that touches a lot of code,
but should be okay even in -rc4 as it returns the code to how it was in 2.6.20.

This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.21/acpi-release-20070126-2.6.21-rc4.diff.gz

 Documentation/crypto/api-intro.txt  |    2 
 Documentation/kernel-parameters.txt |    6 +
 MAINTAINERS                         |    5 -
 arch/ia64/Kconfig                   |    1 
 arch/ia64/kernel/crash.c            |    2 
 arch/ia64/kernel/setup.c            |   22 +----
 arch/ia64/mm/contig.c               |   30 +++++-
 arch/ia64/mm/discontig.c            |    4 
 arch/ia64/mm/init.c                 |   16 ---
 arch/ia64/sn/kernel/setup.c         |    6 -
 crypto/scatterwalk.c                |    4 
 crypto/tcrypt.c                     |    2 
 drivers/acpi/events/evmisc.c        |    8 +
 drivers/acpi/events/evregion.c      |   15 ++-
 drivers/acpi/events/evxface.c       |    6 -
 drivers/acpi/executer/excreate.c    |    5 -
 drivers/acpi/executer/exsystem.c    |   30 +++++-
 drivers/acpi/executer/exutils.c     |  104 ++++--------------------
 drivers/acpi/hardware/hwsleep.c     |    5 +
 drivers/acpi/ibm_acpi.c             |   19 +++-
 drivers/acpi/namespace/nseval.c     |   11 ++
 drivers/acpi/namespace/nsinit.c     |    7 +
 drivers/acpi/namespace/nsxfeval.c   |   11 +-
 drivers/acpi/processor_idle.c       |   38 ++++++--
 drivers/acpi/tables.c               |   57 ++++++++++++-
 include/acpi/acinterp.h             |    6 -
 include/acpi/actypes.h              |    2 
 include/asm-ia64/meminit.h          |    1 
 28 files changed, 244 insertions(+), 181 deletions(-)

through these commits:

Alexey Starikovskiy (1):
      ACPI: resolve HP nx6125 S3 immediate wakeup regression

Henrique de Moraes Holschuh (1):
      ACPI: ibm-acpi: allow module to load when acpi notifiers can't be set (v2)

Len Brown (5):
      ACPI: Add support to parse 2nd MADT
      ACPICA: revert "acpi_serialize" changes
      ACPI: parse 2nd MADT by default
      ACPI: IA64: fix allnoconfig build
      ACPI: IA64: fix %ll build warnings

Mattia Dongili (1):
      sony-laptop: MAINTAINERS fix entry, add L: and W:

Thomas Renninger (1):
      ACPI: Only use IPI on known broken machines (AMD, Dothan/BaniasPentium M)

with this log:

commit cddece4beccaa72dcb57d64a7f1e496b2e61a16b
Merge: b25e844... 25496ca...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Mar 20 11:06:37 2007 -0400

    Pull c2 into release branch

commit b25e84425ee21c5560fcaec15afcf58fe4a0a414
Merge: f5ea908... 09fe583...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Mar 20 11:06:18 2007 -0400

    Pull bugzilla-7465 into release branch

commit f5ea908c8fca3921c1545e6ac52edbbb353640f5
Merge: 54b8c39... a8f4af6...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Mar 20 11:06:00 2007 -0400

    Pull bugzilla-8171 into release branch

commit 54b8c39fbd76a7341b66e49de677ea366737fce7
Merge: 0a14fe6... 0cd4554...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Mar 20 11:05:41 2007 -0400

    Pull misc-for-upstream into release branch

commit 0cd4554df0c261f7ba74786e471ccaa0e3725fb9
Author: Len Brown <len.brown@intel.com>
Date:   Mon Mar 19 23:51:36 2007 -0400

    ACPI: IA64: fix %ll build warnings
    
    acpi_integer is 64-bits on all platforms, and so was defined as a u64.
    
    i386 and x86_64 define u64 as unsigned long long.
    ia64 defines u64 as long.
    
    While these are all 64-bits, the kernel build warns about formating
    a "long" with %ll:
    
    drivers/ata/libata-acpi.c:176: warning: long long unsigned int format, acpi_integer arg (arg 5)
    
    So skip using "u64" and define acpi_integer as "unsigned long long"
    to make gcc happy with %ll.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8140a90ec180192b202af086e7a582e5937c5580
Author: Len Brown <len.brown@intel.com>
Date:   Fri Mar 16 22:00:43 2007 -0400

    ACPI: IA64: fix allnoconfig build
    
    The evils of Kconfig's select bite us once again...
    ia64/Kconfig selects ACPI, which depends on PM.
    But select ignores dependencies, allnoconfig
    chooses CONFIG_PM=n, and thus the menu of sub-options
    under ACPI vanish, which breaks the build.
    
    Manually select PM along with ACPI for now.
    Some day, we should delete them both, or fix select.
    
    Cc: Tony Luck <tony.luck@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 25496caec111481161e7f06bbfa12a533c43cc6f
Author: Thomas Renninger <trenn@suse.de>
Date:   Tue Feb 27 12:13:00 2007 -0500

    ACPI: Only use IPI on known broken machines (AMD, Dothan/BaniasPentium M)
    
    Use IPI for blacklisted CPUs, add parameter IPI vs LAPIC
    
    Currently, Linux disables lapic timer for all machines with C2 and higher
    C-state support.
    
    According to Intel only specific Intel models (Banias/Dothan) are broken
    in respect of not waking up from C2 with lapic.
    
    However, I am not sure about the naming of the parameter and how it
    could/should get integrated into the dyntick part
    (CONFIG_GENERIC_CLOCKEVENTS). There, a more fine grained check (TSC
    still running?, ..) is needed? Does this make sense (always use
    CLOCK_EVT_NOTIFY_BROADCAST_ON, but use OFF if forced by use_ipi=0:
    clockevents_notify(use_ipi ? CLOCK_EVT_NOTIFY_BROADCAST_ON :
    CLOCK_EVT_NOTIFY_BROADCAST_OFF, &pr->id);
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 96e89afe6da630dc54cfbca33c2c6a7ab9b6c11b
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Thu Mar 15 16:15:06 2007 -0300

    ACPI: ibm-acpi: allow module to load when acpi notifiers can't be set (v2)
    
    This patch allows for ibm-acpi to coexist (with diminished functionality) with
    other drivers like ACPI_BAY.  ibm-acpi will simply disable the functions it is
    not able to register ACPI notifiers for.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Chris Wedgwood <cw@f00f.org>
    Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 09fe58356d148ff66901ddf639e725ca1a48a0af
Author: Len Brown <len.brown@intel.com>
Date:   Sun Mar 11 03:32:00 2007 -0400

    ACPI: parse 2nd MADT by default
    
    http://bugzilla.kernel.org/show_bug.cgi?id=7465
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a8f4af6dc6600980885c594f52eecd60edd62013
Author: Len Brown <len.brown@intel.com>
Date:   Thu Mar 15 04:10:36 2007 -0400

    ACPICA: revert "acpi_serialize" changes
    
    This reverts 977a6226feae3e2c10a4d8227625ff0f04b49239
    and reverts 1ba753acb372c2955a4843302e92e49ce82e2fea
    and updates acpi_ev_queue_notify_request()
    to restore the previous implementation of the
    "acpi_serialize" workaround.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=8171
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5b18167d6b7c63e2787cd9a68f0620a9c363fc85
Author: Mattia Dongili <malattia@linux.it>
Date:   Mon Mar 12 21:43:57 2007 +0100

    sony-laptop: MAINTAINERS fix entry, add L: and W:
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1d99967badac599c0d1db0b45c99e073e8e98cd4
Author: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
Date:   Mon Mar 12 14:49:26 2007 -0400

    ACPI: resolve HP nx6125 S3 immediate wakeup regression
    
    Moving disable GPEs from enter_sleep up into sleep_prepare fixed
    the disabled SCI on S4 on Acer laptops.
    
    However, it caused an immediate S3 resume on the HP nx6125.
    Apparently, on the HP, a GPE was getting re-enabled after
    the prepare, but before the enter.
    
    Close that window by restoring the GPE disable on enter.
    This is redundant in most cases, but closes this window,
    where S3 and S4 paths differ.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
    Acked-by: Ray Lee <ray-lk@madrabbit.org>

commit a1fdcc0d2714b6622e3fd5c00db1635213d6c41a
Author: Len Brown <len.brown@intel.com>
Date:   Sun Mar 11 03:26:14 2007 -0400

    ACPI: Add support to parse 2nd MADT
    
    When a BIOS bug presents multiple APIC/MADTs,
    Linux currently uses the 1st and ignores the 2nd.
    
    But some machines work better if we use the 2nd.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=7465
    
    Add a warning and boot parameter "acpi_apic_instance=2"
    to allow parsing the 2nd.
    
    No change to default behaviour in this patch.
    
    Signed-off-by: Len Brown <len.brown@intel.com>
