Return-Path: <linux-kernel-owner+w=401wt.eu-S1762777AbYAKXpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762777AbYAKXpN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 18:45:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757148AbYAKXo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 18:44:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:60217 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbYAKXo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 18:44:58 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@osdl.org>
Subject: [GIT PATCH] ACPI patches for 2.6.24-rc7
Date: Fri, 11 Jan 2008 18:44:38 -0500
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@osdl.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801111844.38882.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

before 2.6.24-final, please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

These are all regression fixes.
A couple will apply to 2.6.23.stable too.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.24/acpi-release-20070126-2.6.24-rc7.diff.gz

 arch/x86/kernel/apm_32.c       |   10 ++-------
 drivers/acpi/Kconfig           |    9 +++++---
 drivers/acpi/ac.c              |   16 +++++++++++++-
 drivers/acpi/battery.c         |   31 +++++++++++++++++++++++------
 drivers/acpi/bus.c             |    7 +-----
 drivers/acpi/ec.c              |   14 ++++++++++++-
 drivers/acpi/events/evregion.c |    8 +++----
 drivers/acpi/pci_irq.c         |    9 ++++++++
 drivers/acpi/processor_idle.c  |    4 +++
 drivers/acpi/sbs.c             |   23 ++++++++++++++++++++-
 drivers/acpi/scan.c            |    6 +++++
 drivers/pci/quirks.c           |    6 +++++
 include/linux/pci_ids.h        |    2 +
 include/linux/pm.h             |    9 ++++++++
 include/linux/pm_legacy.h      |    6 -----
 include/linux/pnp.h            |    2 -
 kernel/power/main.c            |    3 ++
 kernel/power/pm.c              |    4 ---
 18 files changed, 129 insertions(+), 40 deletions(-)

through these commits:

Alan Cox (1):
      ACPI : Not register gsi for PCI IDE controller in legacy mode

Alexey Starikovskiy (2):
      ACPI: EC: Enable boot EC before bus_scan
      ACPI: Make sysfs interface in ACPI power optional.

Bob Moore (1):
      ACPICA: fix acpi_serialize hang regression

Len Brown (2):
      increase PNP_MAX_PORT to 40 from 24
      PM: ACPI and APM must not be enabled at the same time

Venki Pallipadi (1):
      ACPI: Reintroduce run time configurable max_cstate for !CPU_IDLE case

Zhao Yakui (1):
      ACPI: apply quirk_ich6_lpc_acpi to more ICH8 and ICH9

with this log:

commit 8df042e85c4462f97be286ef0fd82a627f27e9c8
Merge: 4562120... 5b3f0e6...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 11 12:28:38 2008 -0500

    Pull bugzilla-9683 into release branch

commit 456212017bf21f6bbdf972a5eafab987600956b2
Merge: 6b74c92... c04209a...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 11 12:28:22 2008 -0500

    Pull bugzilla-9627 into release branch

commit 6b74c92521de123b6b3b01a8be432722121d9e8e
Merge: 4e1b83a... 2c83819...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 11 12:27:50 2008 -0500

    Pull bugzilla-9535 into release branch

commit 4e1b83ad61b5db143281bb54e88ff420cc6b79d0
Merge: 02d5bcc... 97749cd...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 11 12:27:32 2008 -0500

    Pull bugzilla-9494 into release branch

commit 02d5bccf8ea3f9b8de21bfe19db77fbc50d92e04
Merge: eba6860... 9f9adec...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 11 12:27:13 2008 -0500

    Pull bugzilla-9194 into release branch

commit 9f9adecd2d0e4f88fa0e8cb06c6ec207748df70a
Author: Len Brown <len.brown@intel.com>
Date:   Thu Dec 13 17:38:03 2007 -0500

    PM: ACPI and APM must not be enabled at the same time
    
    ACPI and APM used "pm_active" to guarantee that
    they would not be simultaneously active.
    
    But pm_active was recently moved under CONFIG_PM_LEGACY,
    so that without CONFIG_PM_LEGACY, pm_active became a NOP --
    allowing ACPI and APM to both be simultaneously enabled.
    This caused unpredictable results, including boot hangs.
    
    Further, the code under CONFIG_PM_LEGACY is scheduled
    for removal.
    
    So replace pm_active with pm_flags.
    pm_flags depends only on CONFIG_PM,
    which is present for both CONFIG_APM and CONFIG_ACPI.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9194
    
    Signed-off-by: Len Brown <len.brown@intel.com>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

commit eba6860ac5f9578e3ba6d0f9900cfc72599c5d66
Merge: aa7f007... d1ec729...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 11 12:23:14 2008 -0500

    Pull bugzilla-8973 into release branch

commit aa7f00741da5e2adeca3e03103d14b9141040e49
Merge: e63501d... 014d433...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 11 12:22:57 2008 -0500

    Pull bugzilla-8171 into release branch

commit e63501d51d6a1a897470be2684e9c55a46d0d6d5
Merge: 88fb61e... 96c2a87...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 11 12:20:18 2008 -0500

    Pull bugzilla-5637 into release branch

commit d1ec7298fcefd7e4d1ca612da402ce9e5d5e2c13
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Fri Jan 11 00:24:55 2008 -0500

    ACPI: apply quirk_ich6_lpc_acpi to more ICH8 and ICH9
    
    It is important that these resources be reserved
    to avoid conflicts with well known ACPI registers.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 014d433f35d7f34b55dcc7b57c7635aaefc3757f
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Jan 10 23:04:10 2008 -0500

    ACPICA: fix acpi_serialize hang regression
    
    http://bugzilla.kernel.org/show_bug.cgi?id=8171
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 96c2a8766bf4fe91abac863749c11637fabcc64f
Author: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date:   Thu Jan 10 22:49:58 2008 -0500

    ACPI : Not register gsi for PCI IDE controller in legacy mode
    
    When PCI IDE controller works in legacy mode and no PRT entry is found
    in ACPI PRT table, OSPM will neither read the irq number from the IDE
    PCI configuration space nor call the function of acpi_register_gsi to
    register gsi.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=5637
    
    Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5b3f0e6c1c9638b11a1063bf93c60a0766550b02
Author: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Mon Jan 7 17:50:10 2008 -0500

    ACPI: Reintroduce run time configurable max_cstate for !CPU_IDLE case
    
    This was writeable in 2.6.23 but the cpuidle merge made it read-only.  But
    some people's scripts (ie: Mark's) were writing to it.
    
    As an unhappy compromise, make max_cstate writeable again if the kernel was
    configured without CONFIG_CPU_IDLE.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9683
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Cc: Mark Lord <lkml@rtr.ca>
    Cc: Arjan van de Ven <arjan@infradead.org>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 97749cd9adbb2985e4b2aee1a59d6b970fe9c3a7
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Tue Jan 1 14:27:24 2008 -0500

    ACPI: Make sysfs interface in ACPI power optional.
    
    Reference: http://bugzilla.kernel.org/show_bug.cgi?id=9494
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c04209a7948b95e8c52084e8595e74e9428653d3
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Tue Jan 1 14:12:55 2008 -0500

    ACPI: EC: Enable boot EC before bus_scan
    
    Some _STA methods called during bus_scan() might require EC region handler,
    which might be enabled later in the scan.
    Enable it explicitly before scan to avoid errors.
    
    Reference: http://bugzilla.kernel.org/show_bug.cgi?id=9627
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2c838197751db19d08a00e633e33dce23a69fb0c
Author: Len Brown <len.brown@intel.com>
Date:   Thu Dec 27 23:55:13 2007 -0500

    increase PNP_MAX_PORT to 40 from 24
    
    a7839e960675b549f06209d18283d5cee2ce9261
    (PNP: increase the maximum number of resources)
    increased PNP_MAX_PORT to 24 from 8.
    It also added a test and a complaint when a
    machine exceeded the limit, causing:
    
    pnpacpi: exceeded the max number of IO resources: 24
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9535
    
    We should have been squawking about this all along,
    as this is a potentially serious issue.
    
    For now, simply burn some dynamic bytes and
    increase the limit by another 16 to 40.
    There is no guarantee that this will satisfy
    every system on Earth.  It probably will not,
    but it should be an improvement.
    
    In the future, PNPACPI should allocate resource
    structures as needed, rather than max-sized arrays.
    
    Signed-off-by: Len Brown <len.brown@intel.com>
