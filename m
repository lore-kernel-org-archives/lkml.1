Return-Path: <linux-kernel-owner+w=401wt.eu-S1756349AbYJWGwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbYJWGwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 02:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755045AbYJWGwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 02:52:06 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:58842 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbYJWGv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 02:51:58 -0400
Date: Thu, 23 Oct 2008 02:51:54 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: [GIT PATCH] ACPI patches for 2.6.28-rc0
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linux Power Management List <linux-pm@lists.osdl.org>
Message-id: <alpine.LFD.1.10.0810230247500.16793@localhost.localdomain>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_44NyDOeALODibCElguMcZQ)"
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_44NyDOeALODibCElguMcZQ)
Content-type: TEXT/PLAIN; charset=ISO-8859-7
Content-transfer-encoding: 8BIT

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

i7300_idle driver is new to upstream
panasonic-laptop driver is new to upstream
bay driver is deleted, now handled by dock
ACPICA core updated to 20080926 release
ec driver includes a promising fix for multiple sightings
various bugfixes, including some that will also go into .27-stable etc.

I've merged your latest tree with this branch,
so this pull should be conflict-free.

This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.27/acpi-release-20080926-2.6.27.diff.gz

 Documentation/kernel-parameters.txt        |   61 ++-
 Documentation/laptops/acer-wmi.txt         |   28 +-
 MAINTAINERS                                |   15 +-
 arch/ia64/sn/kernel/io_acpi_init.c         |   10 +-
 arch/x86/Kconfig                           |    5 +
 arch/x86/kernel/acpi/boot.c                |    5 +-
 arch/x86/kernel/acpi/sleep.c               |    4 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    3 +
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c  |   42 +-
 arch/x86/kernel/early-quirks.c             |   55 ++-
 arch/x86/kernel/process_64.c               |    7 +
 drivers/Makefile                           |    1 +
 drivers/acpi/Kconfig                       |   13 +-
 drivers/acpi/Makefile                      |    3 +-
 drivers/acpi/ac.c                          |    4 +-
 drivers/acpi/acpi_memhotplug.c             |   11 +-
 drivers/acpi/asus_acpi.c                   |  227 ++++----
 drivers/acpi/battery.c                     |    2 +-
 drivers/acpi/bay.c                         |  411 -------------
 drivers/acpi/bus.c                         |   78 ++-
 drivers/acpi/button.c                      |    6 +-
 drivers/acpi/cm_sbs.c                      |    8 +-
 drivers/acpi/container.c                   |    4 +-
 drivers/acpi/debug.c                       |    2 -
 drivers/acpi/dispatcher/dsmethod.c         |    3 +
 drivers/acpi/dispatcher/dsmthdat.c         |   83 ++--
 drivers/acpi/dispatcher/dsobject.c         |   62 ++-
 drivers/acpi/dispatcher/dsopcode.c         |    2 +-
 drivers/acpi/dispatcher/dswexec.c          |   12 +-
 drivers/acpi/dock.c                        |  388 +++++++++---
 drivers/acpi/ec.c                          |  400 +++++++------
 drivers/acpi/executer/exconfig.c           |  123 +++--
 drivers/acpi/executer/exconvrt.c           |   32 +-
 drivers/acpi/executer/exdump.c             |   87 ++--
 drivers/acpi/executer/exmisc.c             |   14 +-
 drivers/acpi/executer/exoparg1.c           |   26 +-
 drivers/acpi/executer/exoparg2.c           |    4 +-
 drivers/acpi/executer/exresnte.c           |   16 +-
 drivers/acpi/executer/exresolv.c           |   60 +-
 drivers/acpi/executer/exresop.c            |   50 +-
 drivers/acpi/executer/exstore.c            |   61 +-
 drivers/acpi/executer/exstoren.c           |    3 +-
 drivers/acpi/fan.c                         |    6 +-
 drivers/acpi/hardware/hwsleep.c            |   44 +-
 drivers/acpi/namespace/Makefile            |    2 +-
 drivers/acpi/namespace/nsdump.c            |    5 +-
 drivers/acpi/namespace/nseval.c            |   73 ++-
 drivers/acpi/namespace/nsnames.c           |    7 +-
 drivers/acpi/namespace/nspredef.c          |  900 ++++++++++++++++++++++++++++
 drivers/acpi/namespace/nssearch.c          |    2 +-
 drivers/acpi/namespace/nsxfeval.c          |   78 +++
 drivers/acpi/namespace/nsxfname.c          |    5 +
 drivers/acpi/numa.c                        |    2 +-
 drivers/acpi/osl.c                         |   55 ++-
 drivers/acpi/parser/psloop.c               |    2 +
 drivers/acpi/parser/psparse.c              |   32 +-
 drivers/acpi/pci_link.c                    |    6 +-
 drivers/acpi/pci_root.c                    |    4 +-
 drivers/acpi/pci_slot.c                    |   10 +-
 drivers/acpi/power.c                       |   74 ++-
 drivers/acpi/processor_core.c              |    6 +-
 drivers/acpi/processor_idle.c              |    1 +
 drivers/acpi/processor_perflib.c           |   30 +-
 drivers/acpi/processor_throttling.c        |   12 +-
 drivers/acpi/reboot.c                      |   25 +-
 drivers/acpi/resources/rscalc.c            |    5 +-
 drivers/acpi/resources/rscreate.c          |   10 +-
 drivers/acpi/sbs.c                         |    2 +-
 drivers/acpi/sbshc.c                       |    6 +-
 drivers/acpi/scan.c                        |   90 ++--
 drivers/acpi/sleep/main.c                  |   66 ++-
 drivers/acpi/system.c                      |    4 +-
 drivers/acpi/tables/tbfadt.c               |   32 +-
 drivers/acpi/tables/tbinstal.c             |   61 ++-
 drivers/acpi/thermal.c                     |   57 ++-
 drivers/acpi/toshiba_acpi.c                |    2 +-
 drivers/acpi/utilities/utalloc.c           |   53 +-
 drivers/acpi/utilities/utcopy.c            |   29 +-
 drivers/acpi/utilities/utdelete.c          |   12 +-
 drivers/acpi/utilities/utglobal.c          |   52 ++-
 drivers/acpi/utilities/utmisc.c            |    9 +
 drivers/acpi/utilities/utobject.c          |   15 +-
 drivers/acpi/utilities/utxface.c           |    7 +-
 drivers/acpi/utils.c                       |    4 +-
 drivers/acpi/video.c                       |   60 +-
 drivers/acpi/wmi.c                         |   49 ++-
 drivers/ata/libata-acpi.c                  |  135 ++---
 drivers/cpuidle/cpuidle.c                  |    9 +-
 drivers/dma/ioat_dma.c                     |    3 +
 drivers/idle/Kconfig                       |   16 +
 drivers/idle/Makefile                      |    2 +
 drivers/idle/i7300_idle.c                  |  674 +++++++++++++++++++++
 drivers/misc/Kconfig                       |   12 +
 drivers/misc/Makefile                      |    1 +
 drivers/misc/acer-wmi.c                    |  225 +++++---
 drivers/misc/asus-laptop.c                 |   17 +-
 drivers/misc/eeepc-laptop.c                |  232 +++++++-
 drivers/misc/fujitsu-laptop.c              |  135 +++--
 drivers/misc/intel_menlow.c                |   31 +-
 drivers/misc/panasonic-laptop.c            |  767 ++++++++++++++++++++++++
 drivers/misc/sony-laptop.c                 |    2 +-
 drivers/misc/thinkpad_acpi.c               |   65 ++-
 drivers/pci/hotplug/acpiphp_glue.c         |   20 +-
 drivers/pci/hotplug/acpiphp_ibm.c          |    2 +-
 drivers/pci/hotplug/sgi_hotplug.c          |    4 +-
 drivers/pnp/Kconfig                        |   20 +-
 drivers/pnp/Makefile                       |    4 -
 drivers/pnp/base.h                         |   10 +
 drivers/pnp/core.c                         |   29 +-
 drivers/pnp/driver.c                       |    4 -
 drivers/pnp/isapnp/Makefile                |    4 -
 drivers/pnp/isapnp/core.c                  |   12 +-
 drivers/pnp/manager.c                      |   34 +-
 drivers/pnp/pnpacpi/Makefile               |    4 -
 drivers/pnp/pnpacpi/core.c                 |   16 +-
 drivers/pnp/pnpacpi/rsparser.c             |   43 +-
 drivers/pnp/pnpbios/Makefile               |    4 -
 drivers/pnp/pnpbios/core.c                 |    4 +-
 drivers/pnp/pnpbios/rsparser.c             |   18 +-
 drivers/pnp/quirks.c                       |    5 +-
 drivers/pnp/resource.c                     |   12 +-
 drivers/pnp/support.c                      |   14 +-
 include/acpi/acconfig.h                    |    2 +-
 include/acpi/acdebug.h                     |    8 +
 include/acpi/acdisasm.h                    |    4 +
 include/acpi/acdispat.h                    |    6 +-
 include/acpi/acexcep.h                     |  128 ++---
 include/acpi/aclocal.h                     |   77 +++
 include/acpi/acmacros.h                    |  253 ++++----
 include/acpi/acnamesp.h                    |   16 +
 include/acpi/acobject.h                    |   37 +-
 include/acpi/acoutput.h                    |   32 +-
 include/acpi/acpi_bus.h                    |   11 +-
 include/acpi/acpi_drivers.h                |   11 +-
 include/acpi/acpiosxf.h                    |    3 +
 include/acpi/acpredef.h                    |  371 ++++++++++++
 include/acpi/actbl1.h                      |   51 ++-
 include/acpi/actypes.h                     |   37 +-
 include/acpi/acutils.h                     |    4 +-
 include/acpi/platform/aclinux.h            |    6 +
 include/asm-x86/idle.h                     |    1 +
 include/linux/acpi.h                       |    8 -
 include/linux/kernel.h                     |   24 +
 include/linux/pci_ids.h                    |    1 +
 include/linux/pnp.h                        |   10 -
 145 files changed, 5916 insertions(+), 2211 deletions(-)
 delete mode 100644 drivers/acpi/bay.c
 create mode 100644 drivers/acpi/namespace/nspredef.c
 create mode 100644 drivers/idle/Kconfig
 create mode 100644 drivers/idle/Makefile
 create mode 100644 drivers/idle/i7300_idle.c
 create mode 100644 drivers/misc/panasonic-laptop.c
 create mode 100644 include/acpi/acpredef.h

through these commits:

Adam Jackson (1):
      sony-laptop: newline-terminate the printk for backlight change failure

Alexey Starikovskiy (5):
      ACPI: EC: do transaction from interrupt context
      ACPI: EC: Rename some variables
      ACPI: acpi_driver_data could only be applied to acpi_device
      ACPI: EC: Check for IBF=0 periodically if not in GPE mode
      ACPICA: add preemption point after each opcode parse

Andreas Herrmann (1):
      x86: SB600: skip ACPI IRQ0 override if it is not routed to INT2 of IOAPIC

Andy Henroid (1):
      i7300_idle driver v1.55

Bjorn Helgaas (8):
      PNP: fix debug formatting (cosmetic)
      PNPACPI: use dev_printk when possible
      PNP: convert the last few pnp_info() uses to printk()
      PNP: use new vsprintf symbolic function pointer format
      PNP: remove some uses of DEBUG ifdef
      PNP: add CONFIG_PNP_DEBUG_MESSAGES and pnp_dbg()
      PNP: convert to using pnp_dbg()
      PNP: remove old CONFIG_PNP_DEBUG option

Bob Moore (24):
      ACPICA: Allow same ACPI table to be loaded/unloaded more than once
      ACPICA: Fix wrong resource descriptor length for 64-bit build
      ACPICA: Fix table compare code, length then data
      ACPICA: Fix warning for 64-bit build
      ACPICA: Cleanup macro definition file.
      ACPICA: Return method arg count from acpi_get_object_info
      ACPICA: Update version to 20080701
      ACPICA: Add function to decode reference obj types to strings
      ACPICA: Improve object conversion error messages
      ACPICA: x2APIC support: changes for MADT and SRAT ACPI tables
      ACPICA: Update version to 20080729
      ACPICA: Remove obsolete debug levels (WARN and ERROR)
      ACPICA: Add namespace node to operand object union
      ACPICA: Remove obsolete exception codes
      ACPICA: Disallow evaluation of named object types with no value
      ACPICA: Update for Reference ACPI_OPERAND_OBJECT
      ACPICA: Update comments - no functional changes
      ACPICA: Cleanup for internal Reference Object
      ACPICA: Fix possible memory leak in acpi_ns_get_external_pathname
      ACPICA: Update version to 20080829
      ACPICA: Optimize buffer allocation procedure
      ACPICA: New: Validation for predefined ACPI methods/objects
      ACPICA: Add support for zero-length buffer-to-string conversions
      ACPICA: Update version to 20080926

Carlos Corbacho (3):
      acer-wmi: Add rfkill support for wireless and bluetooth
      acer-wmi: Remove wireless and bluetooth sysfs entries
      acer-wmi: Remove private workqueue

Corentin Chary (1):
      asus-laptop: Fix the led behavior with value > 1

Dennis Noordsij (1):
      ACPICA: Copy dynamically loaded tables to local buffer

Fiodor Suietov (1):
      ACPICA: Add check for invalid handle in acpi_get_object_info

Harald Welte (1):
      panasonic-laptop: add Panasonic Let's Note laptop extras driver v0.94

Harvey Harrison (1):
      ACPI: toshiba_acpi.c fix sparse signedness mismatch warnings

Henrique de Moraes Holschuh (2):
      ACPI: thinkpad-acpi: attempt to preserve fan state on resume
      ACPI: thinkpad-acpi: Remove firmware backlight delays for Intel ACPI IGD OpRegion

Jan Beulich (1):
      ACPI: fix FADT parsing

Jonathan Woithe (1):
      fujitsu-laptop: better handling of P8010 hotkey

Len Brown (6):
      dock: Shaohua Li is new maintainer
      ACPI: remove unused acpi_is_child_device()
      panasonic-laptop: fix build
      intel_menlo: fix build warning
      ACPI suspend: fix build warning when CONFIG_ACPI_SLEEP=n
      ACPI: fix ia64 build warning

Lin Ming (9):
      ACPI: replace AE_BAD_ADDRESS exception code with AE_ERROR
      ACPICA: Add function to dereference returned reference objects
      ACPI: replace ACPI_DEBUG_PRINT((ACPI_DB_ERROR, ...) with printk
      ACPICA: Reduce error to warning for incorrect method arg count
      ACPICA: Remove unused ACPI register bit definition
      ACPICA: Fix fault after mem allocation failure in AML parser
      ACPICA: Fix possible memory leak, error exit path
      ACPICA: Fixed a couple memory leaks associated with "implicit return"
      ACPICA: Fix for implicit return compatibility

Mariusz Kozlowski (1):
      ACPI: thinkpad-acpi: trivial fix of error message

Matt Mackall (2):
      x86: remove magic number from ACPI sleep stack buffer
      x86: trim ACPI sleep stack buffer

Matthew Garrett (3):
      ACPI: WMI: Enable event methods when registering notifiers
      eeepc-laptop: Use standard interfaces
      ACPI: Clear WAK_STS on resume

Matthew Wilcox (1):
      ACPI: Change acpi_evaluate_integer to support 64-bit on 32-bit kernels

Mike Dahlgren (1):
      asus_acpi: whitespace and comment cleanup

Pascal Terjan (1):
      ACPI: thinkpad-acpi: Remove duplicate line

Pavel Machek (1):
      ACPI: catch calls of acpi_driver_data on pointer of wrong type

Pavel Vasilyev (1):
      fix CONFIG_MMCONFIG=n build warning

Rafael J. Wysocki (4):
      ACPI suspend: Always use the 32-bit waking vector
      ACPI Suspend: Enable ACPI during resume if SCI_EN is not set
      ACPI suspend: Blacklist HP xw4600 Workstation for old code ordering
      ACPI suspend: Fix CONFIG_ACPI_SLEEP dependence and some compilation warnings

Randy Dunlap (2):
      toshiba_acpi: depends on INPUT
      panasonic-laptop: depends on ACPI

Shaohua Li (10):
      ACPI: dock: avoid check _STA method
      dock: fix eject request process (2.6.27-rc1 regression)
      dock: add _LCK support
      dock: add bay and battery hotplug support
      ACPI: introduce notifier change to avoid duplicates
      libata: remove functions now handed by ACPI dock driver
      dock: introduce .uevent for devices in dock, eg libata
      bay: remove driver, all functions now handled by dock driver
      dock: fix for ATA bay in a dock station
      dock: add 'type' sysfs file

Thomas Renninger (5):
      Introduce FW_BUG, FW_WARN and FW_INFO to consistenly tell users about BIOS bugs
      ACPI: cpufreq, processor: Detect old BIOS, not supporting CPU freq on a recent CPU.
      CPUFREQ: powernow-k8: Try to detect old BIOS, not supporting CPU freq on a recent AMD CPUs.
      Subject: ACPI dock: Use ACPI_EXCEPTION instead of printk(KERN_ERR
      ACPI: Add expand acpi.debug_layer in kernel-parameters.txt

Torsten Krah (1):
      asus-laptop: Add support for P30/P35

Venkatesh Pallipadi (4):
      cpuidle: use last_state which can reflect the actual state entered
      cpuidle: update the last_state acpi cpuidle reflecting actual state entered
      cpuidle: upon BIOS bug, default to default_idle rather than polling
      x86 allow modules to register idle notifiers

Yi Yang (1):
      ACPICA: Return status from global init function

Yinghai Lu (2):
      ACPI: don't load acpi_cpufreq if acpi=off
      ACPI: remove unused have_arch_parse_srat

Zhang Rui (4):
      ACPI: fix hotplug race
      ACPI: don't enable control method power button as wakeup device when Fixed Power button is used
      don't load asus-acpi if model is not supported
      ACPI: Allow overriding to higher critical trip point.

Zhao Yakui (10):
      ACPI: Enable EC device immediately after ACPI full initialization
      ACPI: Add the support for _TTS object
      ACPI: Ignore AE_NOT_FOUND error of EC _REG method and continue to initialize EC
      ACPI: Ingore the RESET_REG_SUP bit when using ACPI reset mechanism
      ACPI: Get the device power state in the course of scanning device
      ACPI: Attach the ACPI device to the ACPI handle as early as possible
      ACPI: Add "acpi.power_nocheck=1" to disable power state check in power transition
      ACPI: Add DMI check to disable power state check in power transition
      ACPI : Load device driver according to the status of acpi device
      ACPI: hack around sysfs warning with link order

donald.d.dugger@intel.com (1):
      ACPI: Fix possible null ptr dereference

with this log:

commit 3262a8f2bf686ced3a6ce8dee013ddf85511fbb6
Author: Len Brown <len.brown@intel.com>
Date:   Thu Oct 23 01:47:29 2008 -0400

    ACPI: fix ia64 build warning
    
    arch/ia64/sn/kernel/io_acpi_init.c:361: warning: format ¡%lx¢ expects type ¡long unsigned int¢, but argument 3 has type ¡long long unsigned int¢
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1ca2cc728d8060d58518096e5c79f12e3775c33a
Merge: 5eaff72... 26adcfb...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Oct 23 01:28:19 2008 -0400

    Merge branch 'bugzilla-11715' into test

commit 5eaff72218b9c2cb7ca7aa284cf0271870c7a7b1
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Fri Oct 17 16:33:57 2008 +0800

    ACPI: hack around sysfs warning with link order
    
        There exists the following warning message will appear after the
    following commit is merged.
       >commit f2e969acd6d5981e6b1272810002558650d0736e
       >Author: Zhao Yakui <yakui.zhao@intel.com>
       >Date:   Mon Aug 11 14:57:50 2008 +0800
        >ACPI: Add "acpi.power_nocheck=1" to disable power state check in
    power transition:
    
       >WARNING: at linux-2.6/fs/sysfs/dir.c:463  sysfs_add_one+0x33/0x39()
       >sysfs: duplicate filename 'acpi' can not be created
       >kobject_add_internal failed for acpi with -EEXIST, don't try to register
                things with the same name in the same directory
    
       In the above commit the "acpi.power_nocheck" module parameter is defined
    in drivers/acpi/power.c file. As several module parameters using the same ACPI
    prefix are defined in the different files(for example: power_nocheck is
    defined in drivers/acpi/power.c,debug_layer/debug_level are defined in
    drivers/acpi/debug.c) and there exists another module between them, the
    warning message will be printed when using the current generic param code.
    (In the function of param_sysfs_init).
    
       In fact when ACPI is selected, the drivers/acpi/power will also be compiled
    as built-in kernel.So this issue can be fixed by the following approach.
       workaround it by adjusting the module link order in drivers/acpi/Makefile.
    In such case the module parameter using the same prefix(ACPI) are put together
    in the param data section.
    
       Of course the better solution is to fix it in generic param code related
    with sysfs.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b849075c0e08ea43400c1341c78eeca76ab08d8a
Author: Len Brown <len.brown@intel.com>
Date:   Thu Oct 23 00:45:18 2008 -0400

    ACPI suspend: fix build warning when CONFIG_ACPI_SLEEP=n
    
    drivers/acpi/sleep/main.c:27: warning: ¡acpi_target_sleep_state¢ defined but not used
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit eb83f493ab9f8bd09fb7a99ae6ae565e92470491
Author: Len Brown <len.brown@intel.com>
Date:   Thu Oct 23 00:43:47 2008 -0400

    intel_menlo: fix build warning
    
    drivers/misc/intel_menlow.c:107: warning: format ¡%ld¢ expects type ¡long int¢, but argument 3 has type ¡long long unsigned int¢
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 057316cc6a5b521b332a1d7ccc871cd60c904c74
Merge: 3e2dab9... 2515ddc...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 22 23:57:26 2008 -0400

    Merge branch 'linus' into test
    
    Conflicts:
    	MAINTAINERS
    	arch/x86/kernel/acpi/boot.c
    	arch/x86/kernel/acpi/sleep.c
    	drivers/acpi/Kconfig
    	drivers/pnp/Makefile
    	drivers/pnp/quirks.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3e2dab9a1c2deb03c311eb3f83466009147ed4d3
Author: Len Brown <len.brown@intel.com>
Date:   Sat Oct 11 02:30:14 2008 -0400

    panasonic-laptop: fix build
    
    sync with acpi_driver_data(device)
    and acpi_evaluate_integer(..., long long)
    changes that happened since this driver
    was checked in.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f1e6d3173ece6d60b4d5aeacd3b91a33ff8ec9d3
Merge: 1b79b27... 7ba427c...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 22 23:36:06 2008 -0400

    Merge branch 'panasonic' into test

commit 1b79b27da172d6c868746135feeb71de4ddd0646
Merge: 7674416... fa89b60...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 22 23:35:56 2008 -0400

    Merge branch 'yinghai' into test

commit 7674416db4ee3d43813dddb650364ca994755256
Merge: 0ca9413... 27663c5...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 22 23:33:29 2008 -0400

    Merge branch 'ull' into test
    
    Conflicts:
    	drivers/acpi/bay.c
    	drivers/acpi/dock.c
    	drivers/ata/libata-acpi.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0ca9413c234aa5a49ffaf80e46b50721a752e45a
Merge: acd41d3... d64c81c...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 22 23:28:48 2008 -0400

    Merge branch 'thinkpad' into test

commit acd41d36e5a813501da92156f325ce15ddcd58ff
Merge: 4dff4e7... 4fb507b...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 22 23:28:46 2008 -0400

    Merge branch 'suspend' into test

commit 4dff4e7f6cbcd2722b02dbb394ba87c4e05f8841
Merge: 5f50ef4... ac88a8f...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 22 23:28:43 2008 -0400

    Merge branch 'pnp-debug' into test

commit 5f50ef453dcb05115fc98f244b8f10bfacd4b8b7
Merge: 530bc23... e3deda9...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 22 23:28:38 2008 -0400

    Merge branch 'misc' into test

commit 530bc23bfeaa9156003afbeb9708fd03a5f1c73c
Merge: ead9039... 27471fd...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 22 23:28:36 2008 -0400

    Merge branch 'i7300_idle' into test

commit ead90393438e0100763c6afd58eaae6a8418c6df
Merge: b815d7b... 0e6a66e...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 22 23:28:33 2008 -0400

    Merge branch 'fujitsu' into test

commit b815d7b3255e455bd83b19b912ef7b0041fe0865
Merge: 3156d1e... fcea94b...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 22 23:28:03 2008 -0400

    Merge branch 'fadt-test' into test

commit 3156d1ed68ff387a4f0b86c505ed76368f576c54
Merge: 0fbb372... a195dcd...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 22 23:28:01 2008 -0400

    Merge branch 'eeepc' into test

commit 0fbb3726f246aadd1bebc01114100b6e69afa5b9
Merge: 47bf31a... c0ff177...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 22 23:27:59 2008 -0400

    Merge branch 'ec' into test

commit 47bf31adc541bef0c20de15e800e0011f1ae70c7
Merge: 4538fad... 0a918a9...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 22 23:25:26 2008 -0400

    Merge branch 'dock' into test
    
    Conflicts:
    	drivers/acpi/osl.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4538fad56ee1c16bce0294b5647d2551f0e03164
Merge: ebd7e45... 89cedfe...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 22 23:20:05 2008 -0400

    Merge branch 'cpuidle' into test

commit ebd7e45f6d27556c94216024212a462aaf899ecb
Merge: 462af43... 8fd1459...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 22 23:20:02 2008 -0400

    Merge branch 'bugzilla-11481' into test

commit 462af435b3d8c682eb86e79d6a42ed62d183c317
Merge: 63e065e... faee816...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 22 23:20:01 2008 -0400

    Merge branch 'bugzilla-10503' into test

commit 63e065e5d35b7ca1ba2c71a042dfb602820409b8
Merge: 2285bc3... 20edd74...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 22 23:19:59 2008 -0400

    Merge branch 'bugzilla-10237' into test

commit 2285bc3d3d6780ecb786d37ed96d014b289a2902
Merge: bcb631f... c6c38ba...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 22 23:19:57 2008 -0400

    Merge branch 'asus-cleanup' into test

commit bcb631f31839cb7c7dd56ab534b6eb4867e9161b
Merge: 955ba39... ed37a71...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 22 23:19:51 2008 -0400

    Merge branch 'acpica' into test

commit 955ba395616a78780e70dc3f3b0b56ca4db52e5c
Merge: aa58329... 383d7a1...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 22 23:19:50 2008 -0400

    Merge branch 'bugfixes' into test

commit aa58329fc8ec50b379388fcad55f62c3493730d3
Merge: 6b3c4f8... ae3a1b4...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 22 23:19:47 2008 -0400

    Merge branch 'acer-wmi' into test

commit 6b3c4f8b9c417541c561155bf6b2150a81b5d5eb
Merge: 3fa8749... 2fd4709...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Oct 22 23:19:45 2008 -0400

    Merge branch 'FW_BUG' into test

commit ed37a71eac8ba375d85ab10ed5f5e8bdf1cd72e0
Author: Bob Moore <robert.moore@intel.com>
Date:   Sat Sep 27 13:39:20 2008 +0800

    ACPICA: Update version to 20080926
    
    Update version to 20080926.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4ca846e9270f305ad19e61f6654664f31459f332
Author: Bob Moore <robert.moore@intel.com>
Date:   Sat Sep 27 13:27:51 2008 +0800

    ACPICA: Add support for zero-length buffer-to-string conversions
    
    Allow zero length strings during interpreter buffer-to-string
    conversions. For example, during the ToDecimalString and
    ToHexString operaters, as well as implicit conversions. Fiodor
    Suietov.  ACPICA BZ 585.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=585
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e8707b340fb5b6313cde784b944a568dfd770ddd
Author: Bob Moore <robert.moore@intel.com>
Date:   Sun Sep 28 15:26:17 2008 +0800

    ACPICA: New: Validation for predefined ACPI methods/objects
    
    Validates predefined ACPI objects that appear in the namespace,
    at the time they are evaluated. The argument count and the type of
    the returned object are validated. The purpose of this validation
    is to detect problems with the BIOS-exposed predefined ACPI objects
    before the results are returned to the ACPI-related drivers.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b9d1312ad4246e467f333dfe2ac4dc7a79608d59
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Sat Sep 27 12:01:12 2008 +0800

    ACPICA: Fix for implicit return compatibility
    
    Predicate can be used for an implicit return value.
    This change improves the implicit return mechanism to be more
    compatible with the MS interpreter.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=349
    
    Below AML code from http://bugzilla.kernel.org/show_bug.cgi?id=10686
    
    	Store(0x07D6, OSYS)
    	Method (_CRT, 0, Serialized)
    	{
    	    If (LLess (OSYS, 0x07D6))
    	    {
    		If (LEqual (\_SB.TJ85, Zero))
    		{
    		    Return (Add (0x0AAC, Multiply (TPC, 0x0A)))
    		}
    		Else
    		{
    		    Return (Add (0x0AAC, Multiply (TP85, 0x0A)))
    		}
    	    }
    	}
    
    Previously _CRT returns 0x07D6, now it returns 0 (predicate value of LLess)
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d8a0ec914afa1a994d2f6184ac4c6668b5f8068f
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Sat Sep 27 11:50:24 2008 +0800

    ACPICA: Fixed a couple memory leaks associated with "implicit return"
    
    Fixed a couple memory leaks associated with "implicit return" objects
    when the AML Interpreter slack mode is enabled.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=349
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 68e125c40597802b9789bc696775bf0246e7667d
Author: Bob Moore <robert.moore@intel.com>
Date:   Sat Sep 27 11:34:48 2008 +0800

    ACPICA: Optimize buffer allocation procedure
    
    Eliminate duplicate code.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cf058bd1c84df9921ecc517d8a8a413f4d6b5b45
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Sat Sep 27 11:29:57 2008 +0800

    ACPICA: Fix possible memory leak, error exit path
    
    Fixed two possible memory leaks in the error exit paths of
    acpi_ut_update_objerct_reference() and
    acpi_ut_walk_package_tree()
    These functions are similar in that they use a stack of state objects in
    order to eliminate recursion. The stack must be fully deallocated
    if an error occurs.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=383
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c35def2118d3d7cceb0f69d6707f613a7473df15
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Sat Sep 27 11:28:46 2008 +0800

    ACPICA: Fix fault after mem allocation failure in AML parser
    
    Fixes a crash if a memory allocation fails during the Op completion
    routine acpi_ps_complete_this_op().
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=492
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bbbbeb8e31af97f11b84294b2e7e5607125829d2
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Sat Sep 27 11:26:59 2008 +0800

    ACPICA: Remove unused ACPI register bit definition
    
    Removed the ACPI_BITREG_WAKE_ENABLE definition and entry in the
    global register table. This bit does not exist and is unused.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=442
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 51f52819bd02112a1f61f0741231f14bdb0cae7b
Author: Bob Moore <robert.moore@intel.com>
Date:   Sat Sep 27 11:14:04 2008 +0800

    ACPICA: Update version to 20080829
    
    Update version to 20080829.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 393a75d6b7bae59221b2122634eb4cb905e84208
Author: Bob Moore <robert.moore@intel.com>
Date:   Sat Sep 27 11:12:36 2008 +0800

    ACPICA: Fix possible memory leak in acpi_ns_get_external_pathname
    
    Fixes a memory leak in the error exit path.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1044f1f65b7df2aae979e397904c4985eeb99ba2
Author: Bob Moore <robert.moore@intel.com>
Date:   Sat Sep 27 11:08:41 2008 +0800

    ACPICA: Cleanup for internal Reference Object
    
    Fix some sloppiness in the Reference object. No longer use AML
    opcodes to differentiate the types, introduce new reference
    Class. Cleanup the debug output code.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2425a0967f29b196fad5d4f726c9502679284656
Author: Bob Moore <robert.moore@intel.com>
Date:   Sat Sep 27 10:42:02 2008 +0800

    ACPICA: Update comments - no functional changes
    
    Some formatting and spelling fixes.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 57e664cfd968ec8e4b0bfd80a5e8f903307e598b
Author: Bob Moore <robert.moore@intel.com>
Date:   Sat Sep 27 10:40:39 2008 +0800

    ACPICA: Update for Reference ACPI_OPERAND_OBJECT
    
    1) Add new field for use by DdbHandle (Value)
    2) Use ACPI_CAST_INDIRECT_PTR to eliminate strict type warnings
    3) Cleanup debug output
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 93851b4d13de48753eaae76ed190eef7355e2c19
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Sat Sep 27 10:38:07 2008 +0800

    ACPICA: Reduce error to warning for incorrect method arg count
    
    Previously aborted with error if too few arguments were passed to
    a control method via the external ACPICA interface. Now issue a
    warning instead and continue. Handles the case where the method
    inadvertently declares too many arguments, but does not actually
    use the extra ones.  Applies mainly to the predefined methods.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=11032
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b68bacf225e5e9758472e99505d76125ced3ea88
Author: Bob Moore <robert.moore@intel.com>
Date:   Sat Sep 27 10:29:31 2008 +0800

    ACPICA: Disallow evaluation of named object types with no value
    
    Return AE_TYPE for objects that have no value and therefore
    evaluation is undefined: Device, Event, Mutex, Region, Thermal,
    and Scope.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 65f4692c5220330e1ea044796c4cfa603e349c84
Author: Bob Moore <robert.moore@intel.com>
Date:   Sat Sep 27 10:28:07 2008 +0800

    ACPICA: Remove obsolete exception codes
    
    Removed 10 exception codes (and corresponding name strings)
    that were obsolete for various reasons.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8d5c54b65b20bf81fa9841a27143e2f71f3a7756
Author: Bob Moore <robert.moore@intel.com>
Date:   Sat Sep 27 10:22:09 2008 +0800

    ACPICA: Add namespace node to operand object union
    
    Add ACPI_NAMESPACE_NODE to the ACPI_OPERAND_OBJECT in order to
    simplify code that accepts both of these objects. A common type
    field is used to differentiate them.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 23d3e055beb12db2a3b91dfeee474c4d5ecc13b9
Author: Bob Moore <robert.moore@intel.com>
Date:   Sun Sep 28 15:00:47 2008 +0800

    ACPICA: Remove obsolete debug levels (WARN and ERROR)
    
    Removed ACPI_DB_WARN and ACPI_DB_ERROR. These debug levels were
    made obsolete by the ACPI_WARNING and ACPI_ERROR/ACPI_EXCEPTION
    interfaces.  Also added ACPI_DB_EVENTS to correspond with the
    existing ACPI_LV_EVENTS.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 55ac9a018f83e4f42f3c6ce98a8dbda73b985935
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Sun Sep 28 14:51:56 2008 +0800

    ACPI: replace ACPI_DEBUG_PRINT((ACPI_DB_ERROR, ...) with printk
    
    ACPI_DB_ERROR and ACPI_DB_WARN were removed from ACPICA core.
    So replace ACPI_DEBUG_PRINT((ACPI_DB_ERROR, ...) with printk(KERN_ERR PREFIX ...)
    and ACPI_DEBUG_PRINT((ACPI_DB_WARN, ...) with printk(KERN_WARNING PREFIX ...)
    
    We do not use ACPI_ERROR/ACPI_WARNING since they're not exported, see
    -------------------------------------------------------------
    commit 6468463abd7051fcc29f3ee7c931f9bbbb26f5a4
    Author: Len Brown <len.brown@intel.com>
    Date:   Mon Jun 26 23:41:38 2006 -0400
    
        ACPI: un-export ACPI_ERROR() -- use printk(KERN_ERR...)
    
        Signed-off-by: Len Brown <len.brown@intel.com>
    -------------------------------------------------------------
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8bd108d14604d9c95000751e6c6ecbd11ea6ed40
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Thu Sep 25 21:40:30 2008 +0400

    ACPICA: add preemption point after each opcode parse
    
    Reference: http://marc.info/?l=linux-acpi&m=122236382701062&w=2
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit eec935490172dbfa1a32647f9deb2b66a66f2741
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon Aug 4 11:15:11 2008 +0800

    ACPICA: Update version to 20080729
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1d7cc03049f7c9c5cced9208a39316c5245ef314
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon Aug 4 10:42:47 2008 +0800

    ACPICA: x2APIC support: changes for MADT and SRAT ACPI tables
    
    Support for the x2APIC. There are 2 new subtables for the MADT and
    one new subtable for the SRAT. Includes disassembler and acpisrc
    support. Data from the Intel 64 Architecture x2APIC Specification,
    June 2008.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c2de3a49454cdc9ca42bbd5d742913421d049f59
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon Aug 4 10:41:29 2008 +0800

    ACPICA: Improve object conversion error messages
    
    Better error messages during object conversion from internal
    to the external ACPI_OBJECT. Used for external calls to
    acpi_evaluate_object.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f02a99ac66748f8b62477c86f6df04d3ec6169fd
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon Aug 4 10:40:09 2008 +0800

    ACPICA: Add function to decode reference obj types to strings
    
    Created for improved error messages.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d00d23651d17a2848f6923f3b1ec4efe19f5f2f1
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon Aug 4 10:12:31 2008 +0800

    ACPICA: Update version to 20080701
    
    Update version to 20080701.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0a1fbf2db0d275f0f8160bb9c3e51c4df5bafdc2
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Jul 4 10:53:58 2008 +0800

    ACPICA: Return method arg count from acpi_get_object_info
    
    Also update the debugger so that the correct number of arguments is
    passed to the method. Prevents a warning message from the debugger.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c9bdd8057d706a972d804d2d8614a283641a5660
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon Aug 4 09:54:17 2008 +0800

    ACPICA: Cleanup macro definition file.
    
    Removed unused macros. Ensure that multiple parameters always have a space
    after a comma. Cleanup some comments.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b7906e324532c1616546f6d4a1306894ba7c0a3d
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Aug 15 04:32:59 2008 +0200

    ACPICA: Fix warning for 64-bit build
    
    Fixes warning from exconfig.c on 64-bit build.
    
    AK: This actually was fixed earlier in Linux, this just syncs with
    AK: the version of the fix that went into the ACPCA codebase
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bbc241340681557a16982f4d1840f00963bc05b4
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Mon Aug 4 13:22:10 2008 +0800

    ACPICA: Add function to dereference returned reference objects
    
    Examines the return object from a call to acpi_evaluate_object.
    Any Index or RefOf references are automatically dereferenced in
    an attempt to return something useful (these reference types
    cannot be converted into an external ACPI_OBJECT.)
    Lin Ming, Bob Moore.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=11105
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b417d40b9a850f12f69aa9d785d2af39c9463bb8
Author: Yi Yang <yi.y.yang@intel.com>
Date:   Mon Aug 4 10:30:09 2008 +0800

    ACPICA: Return status from global init function
    
    Return status from acpi_ut_init_globals. This is used by both
    the kernel subsystem and the utilities such as iASL compiler.
    The function could possibly fail when the caches are initialized.
    Yang Yi.
    
    Signed-off-by: Yi Yang <yi.y.yang@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a6f30539f31a8129288b0e5640d3eb1174848c15
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Jul 4 10:57:51 2008 +0800

    ACPICA: Fix table compare code, length then data
    
    Split the ACPI table compare. First check that the lengths match
    exactly. Then compare the data.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9db4fcd99f7ef886ded97cd26a8642c70fbe34df
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Jul 4 10:56:13 2008 +0800

    ACPICA: Fix wrong resource descriptor length for 64-bit build
    
    The "minimal" descriptors such as EndTag are calculated as 12
    bytes long, but the actual length in the internal descriptor is
    16 because of the round-up to 8 on 64-bit build.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=728
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e56f561736e340a4e923b0db65f65dabf5d94823
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Jul 4 10:48:43 2008 +0800

    ACPICA: Allow same ACPI table to be loaded/unloaded more than once
    
    Without this change, a table cannot be loaded again once it has
    been loaded/unloaded one time. The current mechanism does not
    unregister a table upon an unload. During a load, if the same
    table is found, this no longer returns an exception.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=722
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 237a927682a63f02adb542dbdaafe8a81566451d
Author: Fiodor Suietov <fiodor.f.suietov@intel.com>
Date:   Fri Jul 4 10:18:34 2008 +0800

    ACPICA: Add check for invalid handle in acpi_get_object_info
    
    Return AE_BAD_PARAMETER if input handle is invalid.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=474
    
    Signed-off-by: Fiodor Suietov <fiodor.f.suietov@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f0e0da8a6cca44396c7a711e308d58084e881617
Author: Dennis Noordsij <dennis.noordsij@helsinki.fi>
Date:   Fri Aug 15 09:37:58 2008 +0800

    ACPICA: Copy dynamically loaded tables to local buffer
    
    Previously, dynamically loaded tables were simply mapped, but on some machines
    this memory is corrupted after suspend. Now copy the table to a local buffer.
    For OpRegion case, added checksum verify. Use the table length from the table header,
    not the region length. For Buffer case, use the table length also.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=10734
    
    Signed-off-by: Dennis Noordsij <dennis.noordsij@helsinki.fi>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7ba427c2363d91d4221843a9ae601f90f8d928b9
Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Fri Oct 17 13:46:08 2008 -0700

    panasonic-laptop: depends on ACPI
    
    panasonic-laptop uses many acpi_*() functions so it should
    depend on ACPI; otherwise there are approximately 70
    warnings/errors generated.
    
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    Acked-by: Harald Welte <laforge@gnumonks.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d64c81c4cea0a14e88fc76e2c845e4885e491754
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Oct 18 14:23:55 2008 -0300

    ACPI: thinkpad-acpi: Remove firmware backlight delays for Intel ACPI IGD OpRegion
    
    Based on analysis and a patch from Matthew Garrett <mjg59@srcf.ucam.org>.
    
    Instruct the ThinkPad ACPI firmware to remove delays on the processing of
    backlight brightness changes.  This method is present on ThinkPad
    Vista-compatible BIOSes with standard ACPI backlight level control.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Matthew Garrett <mjg59@srcf.ucam.org>
    Cc: Yves-Alexis Perez <corsac@debian.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 396293237cbc964fcedd4208cbc0d0f4880a98bb
Author: Pascal Terjan <pterjan@mandriva.com>
Date:   Sat Oct 18 14:23:54 2008 -0300

    ACPI: thinkpad-acpi: Remove duplicate line
    
    Signed-off-by: Pascal Terjan <pterjan@mandriva.com>
    Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4f778b92c9d8d87c670fc063c66edf1aa46f6f1c
Author: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Date:   Sat Oct 18 14:23:53 2008 -0300

    ACPI: thinkpad-acpi: trivial fix of error message
    
    Trivial fix makes the error message match the code before it (ibm->driver
    vs ibm->acpi-driver) better.
    
    Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
    Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 75700e53cd14ccc7a5a42547497dff11fe209186
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Oct 18 14:23:52 2008 -0300

    ACPI: thinkpad-acpi: attempt to preserve fan state on resume
    
    Attempt to preserve fan state across sleep and hibernation if the fan
    control mode is enabled.
    
    For safety reasons, only the PWM OFF (fan at 100%) or maximum
    closed-loop level (level 7) are preserved.  If the fan state was set
    to anything else, it will not be restored.
    
    Also, should the fan be at PWM OFF mode at resume, it will be left at
    that state (but this is extremely unlikely, no ThinkPad firmware was
    ever reported to do this).
    
    For reference, the known states used for fan control upon resume by
    the firmware  are either "auto" or "level 7" depending on whether the
    laptop wakes due to normal conditions or a thermal emergency.
    
    Fixes: http://bugzilla.kernel.org/show_bug.cgi?id=11331
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Richard Hartmann <richih.mailinglist@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 383d7a11c9989205db44c7f1be339e5097062f03
Author: donald.d.dugger@intel.com <donald.d.dugger@intel.com>
Date:   Fri Oct 17 07:49:50 2008 -0700

    ACPI: Fix possible null ptr dereference
    
    Code in `pci_link.c' is calling the internal routine `acpi_ut_evaluate_object'
    which is dangerous given that it is passing a NULL pointer when it should
    be passing a pointer to a real object.  The patch corrects the issue by
    having the code call the external routine `acpi_evaluate_object', which
    correctly handles a NULL pointer.
    
    Signed-off-by: Don Dugger <donald.d.dugger@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ea5c8af9b1241a10dc4ba6cd2d2362c179884b74
Author: Len Brown <len.brown@intel.com>
Date:   Sat Oct 11 01:13:12 2008 -0400

    ACPI: remove unused acpi_is_child_device()
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 39a0ad871000d2a016a4fa113a6e53d22aabf25d
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Mon Aug 11 13:40:22 2008 +0800

    ACPI : Load device driver according to the status of acpi device
    
    According to ACPI spec when the status of some device is not present
    but functional, the device is valid and the children of this device
    should be enumerated. It means that the device should be added to
    linux acpi device tree. But the device driver for this device should not
    be loaded.
        The detailed info can be found in the section 6.3.7 of ACPI 3.0b spec.
        _STA may return bit 0 clear (not present) with bit 3 set (device is
    functional). This case is used to indicate a valid device for which no
    device driver should be loaded (for example, a bridge device.).
    Children of this device may be present and valid. OS should continue
    enumeration below a device whose _STA returns this bit combination
    
    http://bugzilla.kernel.org/show_bug.cgi?id=3358
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Li Shaohua <shaohua.li@intel.com>
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6415e12ba0f92a54f02d9c4ecaa3c82f35f3d335
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Mon Aug 11 14:59:59 2008 +0800

    ACPI: Add DMI check to disable power state check in power transition
    
    Add the DMI check to disable power check in the course of device power
    transistion.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=11000
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Li Shaohua <shaohua.li@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f5adfaa372c76423b6e8e4727a9701330374f364
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Mon Aug 11 14:57:50 2008 +0800

    ACPI: Add "acpi.power_nocheck=1" to disable power state check in power transition
    
       Maybe the incorrect power state is returned on the bogus bios, which
    is different with the real power state. For example: the bios returns D0
    state and the real power state is D3. OS expects to set the device to D0
    state. In  such case if OS uses the power state returned by the BIOS and
    checks the device power state very strictly in power transition, the device
    can't be transited to the correct power state.
    
       So the boot option of "acpi.power_nocheck=1" is added to avoid checking
    the device power in the course of device power transition.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=8049
    http://bugzilla.kernel.org/show_bug.cgi?id=11000
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Li Shaohua <shaohua.li@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit eab4b645769fa2f8703f5a3cb0cc4ac090d347af
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Mon Aug 11 14:54:16 2008 +0800

    ACPI: Attach the ACPI device to the ACPI handle as early as possible
    
    Attach the ACPI device to the ACPI handle as early as possible so that OS
    can get the corresponding ACPI device by the acpi handle in the course
    of getting the power/wakeup/performance flags.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=8049
    http://bugzilla.kernel.org/show_bug.cgi?id=11000
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a51e145f379ae48003129610922595893e8efde0
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Mon Aug 11 14:55:05 2008 +0800

    ACPI: Get the device power state in the course of scanning device
    
    Get the device power state in the course of scanning device if the device
    power flag is power_managable. i.e. The device has the _PSx/_PRx object.
    
    At the same time before the drivers/acpi/power module is loaded, there is no
    relation between acpi_power_resource and acpi device. So the first parameter
    of acpi_power_get_state is changed to acpi_handle.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=8049
    http://bugzilla.kernel.org/show_bug.cgi?id=11000
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Li Shaohua <shaohua.li@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 08237974af22a97da59869979ef1a515524d5cc3
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Fri Aug 8 11:57:11 2008 +0800

    ACPI: replace AE_BAD_ADDRESS exception code with AE_ERROR
    
    The AE_BAD_ADDRESS exception code is now unused in ACPICA.
    For linux, it's only used at wmi.c and acer-wmi.c.
    I checked both wmi.c and acer-wmi.c, the AE_BAD_ADDRESS exception code
    has no special meaning. The parent functions just call AE_SUCCESS() or
    AE_FAILURE() to check the return status.
    So it's safe to replace AE_BAD_ADDRESS with AE_ERROR.
    
    Signed-off-by Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 36eec5e29cf31011a7fbe121badfed7efb2a4ebb
Author: Thomas Renninger <trenn@suse.de>
Date:   Mon Aug 11 15:03:20 2008 +0200

    ACPI: Add expand acpi.debug_layer in kernel-parameters.txt
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e3deda9c87ac5eef2b5d18cd0b5511370979ca26
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Wed Sep 24 10:35:55 2008 +0200

    asus-laptop: Fix the led behavior with value > 1
    
    Fix http://bugzilla.kernel.org/show_bug.cgi?id=11613 .
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5d1e072b6b9cffebefa681faca1c6d608310d4b2
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Wed Oct 22 14:58:43 2008 -0400

    ACPI suspend: Fix CONFIG_ACPI_SLEEP dependence and some compilation warnings
    
    Initially CONFIG_PM_SLEEP was defined as
    CONFIG_SUSPEND || CONFIG_HIBERNATION and some ACPI code, most
    importantly the code in drivers/acpi/main.c, was written with this
    assumption.  Currently, however, CONFIG_PM_SLEEP is also set when
    CONFIG_XEN_SAVE_RESTORE is set.
    
    This causes some compilation warnings to appear in
    drivers/acpi/main.c if both CONFIG_SUSPEND and CONFIG_HIBERNATION
    are unset and CONFIG_PM_SLEEP is set (this was impossible before).
    To fix this problem, redefine CONFIG_ACPI_SLEEP do depend directly
    on CONFIG_SUSPEND || CONFIG_HIBERNATION, as originally intended, and
    use it instead of CONFIG_PM_SLEEP in drivers/acpi/main.c, wherever
    appropriate.
    
    Additionally, move the acpi_target_sleep_state definition from under
    the #ifdef to prevent compilation from failing in some cases.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 27471fdb32e77ecb92f09d4ac5757785b4dc33bc
Author: Andy Henroid <andrew.d.henroid@intel.com>
Date:   Thu Oct 9 11:45:22 2008 -0700

    i7300_idle driver v1.55
    
    The Intel 7300 Memory Controller supports dynamic throttling of memory which can
    be used to save power when system is idle. This driver does the memory
    throttling when all CPUs are idle on such a system.
    
    Refer to "Intel 7300 Memory Controller Hub (MCH)" datasheet
    for the config space description.
    
    Signed-off-by: Andy Henroid <andrew.d.henroid@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

commit c7d87d79d14cecab7a34dedf1b133377cf5a0203
Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Thu Oct 16 16:34:43 2008 -0400

    x86 allow modules to register idle notifiers
    
    needed if the i7300_idle driver is to be modular.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Acked-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8fd145917fb62368a9b80db59562c20576238f5a
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Fri Oct 17 14:22:27 2008 -0400

    ACPI: Ingore the RESET_REG_SUP bit when using ACPI reset mechanism
    
    According to ACPI 3.0, FADT.flags.RESET_REG_SUP indicates
    whether the ACPI reboot mechanism is supported.
    
    However, some boxes have this bit clear, have a valid
    ACPI_RESET_REG & RESET_VALUE, and ACPI reboot is the only
    mechanism that works for them after S3.
    
    This suggests that other operating systems may not be checking
    the RESET_REG_SUP bit, and are using other means to decide
    whether to use the ACPI reboot mechanism or not.
    
    Here we stop checking RESET_REG_SUP.
    Instead, When acpi reboot is requested,
    only the reset_register is checked. If the following
    conditions are met, it indicates that the reset register is supported.
    	a. reset_register is not zero
    	b. the access width is eight
    	c. the bit_offset is zero
    
    http://bugzilla.kernel.org/show_bug.cgi?id=7299
    http://bugzilla.kernel.org/show_bug.cgi?id=1148
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c6c38bac2608b0f439b9ede72394780fe7fe1951
Author: Mike Dahlgren <dahlgren@gmail.com>
Date:   Fri Oct 17 14:35:14 2008 -0400

    asus_acpi: whitespace and comment cleanup
    
    Signed-off-by: Mike Dahlgren <dahlgren@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4d0b856ef7eea5c03f4c1fa57793286ac068f4cd
Author: Torsten Krah <tkrah@fachschaft.imn.htwk-leipzig.de>
Date:   Fri Oct 17 09:47:57 2008 +0200

    asus-laptop: Add support for P30/P35
    
    Add support for P30/P35.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=10848
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 22a94d79a34bf010d11996d30eed8ee3fc1a4fbf
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Fri Oct 17 02:41:20 2008 -0400

    ACPI: Allow overriding to higher critical trip point.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9129
    
    lenb: Note that overriding a critical trip point
    may simply fool the user into thinking that they
    have control that they do not actually have.
    For it is EC firmware that decides when the EC
    sends Linux temperature change events, and the
    EC may or may not decide to send Linux these events
    anywhere in the neighborhood of the fake
    override trip points.  Beware.
    
    note also that thermal.nocrt is already available
    to disable crtical trip point actios,
    and thermal.crt=-1 is already available to
    disabled critical trip points entirely.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 20edd74fcf9ad02c19efba0c13670a7b6b045099
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Fri Oct 17 02:02:44 2008 -0400

    ACPI: Ignore AE_NOT_FOUND error of EC _REG method and continue to initialize EC
    
    On some broken BIOS the ACPI object in EC _REG method can't be found in
    ACPI namespace, which causes that the status code of AE_NOT_FOUND is returned by
    the EC _REG object. In such case the EC device can't be initialized correctly,
    which causes that battery/AC adapter can't work normally. As the EC address
    space handler is not removed and the memory pointed by its input argument is
    already free, sometimes the kernel will also be panic when EC internal register
    is still accessed. But the windows can work well on such broken BIOS.
    
    Maybe it will be reasonable that OS ignores the AE_NOT_FOUND error
    returned by the EC _REG object and continues to initialize EC device
    on some broken BIOS.
    For example: the ACPI object in EC _REG method can't be found and status error
    code is AE_NOT_FOUND.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=8953
    http://bugzilla.kernel.org/show_bug.cgi?id=10237
    
    lenb: we may find a more general solution to this in the future.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7745384080ef70f7710530afa3e45477b126e056
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Fri Oct 17 01:42:41 2008 -0400

    don't load asus-acpi if model is not supported
    
    asus_hotk_get_info should return -ENODEV if the model is not supported.
    http://bugzilla.kernel.org/show_bug.cgi?id=10389
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4fb507b6b764195bb7821cf2baa988f6eb677d30
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Oct 14 22:54:06 2008 +0200

    ACPI suspend: Blacklist HP xw4600 Workstation for old code ordering
    
    HP xw4600 Workstation is known to require the "old" (ie. compatible
    with ACPI 1.0) suspend code ordering, so blacklist it for this
    purpose.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Tested-by: John Brown <john.brown3@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d0c71fe7ebc180f1b7bc7da1d39a07fc19eec768
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sat Oct 4 00:05:05 2008 +0200

    ACPI Suspend: Enable ACPI during resume if SCI_EN is not set
    
    On some machines, like for example MSI Wind U100, the BIOS doesn't
    enable ACPI before returning control to the OS, which sometimes
    causes resume to fail.  This is against the ACPI specification,
    which clearly states that "When the platform is waking from an S1, S2
    or S3 state, OSPM assumes the hardware is already in the ACPI mode
    and will not issue an ACPI_ENABLE", but it won't hurt to check the
    SCI_EN bit and enable ACPI during resume from S3 if this bit is not
    set.
    
    Fortunately, we already have acpi_enable() for that, so use it in the
    resume code path, before executing _BFS, in analogy with the
    resume-from-hibernation code path.
    
    NOTE: We aren't supposed to set SCI_EN directly, because it's owned
    by the hardware.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Pavel Machek <pavel@suse.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a6629105dd03d370fcb31e97bddf223fa4bb651e
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sat Sep 6 13:13:01 2008 +0200

    ACPI suspend: Always use the 32-bit waking vector
    
    According to the ACPI specification 2.0c and later, the 64-bit waking vector
    should be cleared and the 32-bit waking vector should be used, unless we want
    the wake-up code to be called by the BIOS in Protected Mode.  Moreover, some
    systems (for example HP dv5-1004nr) are known to fail to resume if the 64-bit
    waking vector is used.  Therefore, modify the code to clear the 64-bit waking
    vector, for FACS version 1 or greater, and set the 32-bit one before suspend.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=11368
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e49f711cc8f3bf8d719a9f5c86e79ecc0a72bf70
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Tue Aug 12 10:20:22 2008 +0800

    ACPI: Add the support for _TTS object
    
        The _TTS object is defined in the section 7.3 of acpi 3.0b spec.
        The _TTS control method is executed by the OSPM at the beginning of
    the sleep transition process for S1,S2, S3, S4, and orderly S5 shutdown.
    OS will invoke _TTS before it has notified any native mode device drivers
    of the sleep state transition. The target sleeping state value is passed to
    the _TTS control method.
    
        The _TTS control method is also executed by the OSPM at the end of
    any sleep transition process when the system transitions to S0 from
    S1, S2, S3, or S4. The _TTS object should be evaluated after it has
    notified any native mode device drivers of the end of the sleep state
    transition. The working state value (0) is passed to the _TTS control method.
    
        So it is necessary to add the support for _TTS object. The _TTS object
    will be evaluated if it exists.
        At the same time a block notifier is added to the reboot notifier list so
    that the _TTS object will also be evaluated when the system shutdown.
    
    lenb: note that as of Sep 2008, I've not yet seen _TTS in any shipping BIOS.
    So this patch is to future-proof Linux, rather than fix the installed base.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=11132
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Li Shaohua <shaohua.li@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 89cedfefca1d446ee2598fd3bcbb23ee3802e26a
Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Thu Oct 16 19:00:08 2008 -0400

    cpuidle: upon BIOS bug, default to default_idle rather than polling
    
    http://bugzilla.kernel.org/show_bug.cgi?id=11345
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c0ff17720ec5f42205b3d2ca03a18da0a8272976
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Thu Oct 16 02:02:33 2008 +0400

    ACPI: EC: Check for IBF=0 periodically if not in GPE mode
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Tested-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit addbad46ed0906cd584784423b9d0babc7476446
Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Mon Sep 29 15:24:28 2008 -0700

    cpuidle: update the last_state acpi cpuidle reflecting actual state entered
    
    reflect the actual state entered in dev->last_state, when actaul state entered
    is different from intended one.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 887e301aa1105326f1412a98749024263b1031c7
Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Mon Sep 29 15:24:27 2008 -0700

    cpuidle: use last_state which can reflect the actual state entered
    
    cpuidle accounts the idle time for the C-state it was trying to enter and
    not to the actual state that the driver eventually entered. The driver may
    select a different state than the one chosen by cpuidle due to
    constraints like bus-mastering, etc.
    
    Change the time acounting code to look at the dev->last_state after
    returning from target_state->enter(). Driver can modify dev->last_state
    internally, inside the enter routine to reflect the actual C-state
    entered.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Tested-by: Kevin Hilman <khilman@deeprootsystems.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 26adcfbf00e0726b4469070aa2f530dcf963f484
Author: Andreas Herrmann <andreas.herrmann3@amd.com>
Date:   Tue Oct 14 21:01:15 2008 +0200

    x86: SB600: skip ACPI IRQ0 override if it is not routed to INT2 of IOAPIC
    
    On some more HP laptops BIOS reports an IRQ0 override
    but the SB600 chipset is configured such that timer
    interrupts go to INT0 of IOAPIC.
    
    Check IRQ0 routing and if it is routed to INT0 of IOAPIC skip the
    timer override.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=11715
    http://bugzilla.kernel.org/show_bug.cgi?id=11516
    
    Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0ef9cff15d47b296d4a7feecf36e7989cebf9a33
Author: Adam Jackson <ajax@redhat.com>
Date:   Thu Oct 16 15:15:35 2008 -0400

    sony-laptop: newline-terminate the printk for backlight change failure
    
    Signed-off-by: Adam Jackson <ajax@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a68823ee5285e65b51ceb96f8b13a5b4f99a6888
Author: Matthew Garrett <mjg59@srcf.ucam.org>
Date:   Wed Aug 6 19:12:04 2008 +0100

    ACPI: Clear WAK_STS on resume
    
    The leading other brand OS appears to clear the WAK_STS flag on resume.
    When rebooted, certain BIOSes assume that the system is actually
    resuming if it's still set and so fail to reboot correctly. Make sure
    that it's cleared at resume time.
    
    Comment clarified as suggested by Bob Moore
    
    http://bugzilla.kernel.org/show_bug.cgi?id=11634
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
    Tested-by: Romano Giannetti <romano.giannetti@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1339c367a842a9fc34b8fcfa1abadb07b11848ad
Author: Pavel Vasilyev <linuxoid@tochka.ru>
Date:   Wed Oct 15 17:33:48 2008 -0400

    fix CONFIG_MMCONFIG=n build warning
    
    arch/x86/kernel/acpi/boot.c:100: warning: 'acpi_mcfg_64bit_base_addr' defined
    but not used
    
    http://bugzilla.kernel.org/show_bug.cgi?id=11743
    
    Signed-off-by: Pavel Vasilyev <linuxoid@tochka.ru>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 27663c5855b10af9ec67bc7dfba001426ba21222
Author: Matthew Wilcox <willy@linux.intel.com>
Date:   Fri Oct 10 02:22:59 2008 -0400

    ACPI: Change acpi_evaluate_integer to support 64-bit on 32-bit kernels
    
    As of version 2.0, ACPI can return 64-bit integers.  The current
    acpi_evaluate_integer only supports 64-bit integers on 64-bit platforms.
    Change the argument to take a pointer to an acpi_integer so we support
    64-bit integers on all platforms.
    
    lenb: replaced use of "acpi_integer" with "unsigned long long"
    lenb: fixed bug in acpi_thermal_trips_update()
    
    Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 455c8793d2c49eaecad038c8de83dade9fc3759f
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Mon Oct 6 10:31:36 2008 +0800

    ACPI: Enable EC device immediately after ACPI full initialization
    
    when there is no ECDT table and no _INI object for EC device, it will be
    enabled before scanning ACPI device. But it is too late after the following
    the commit is merged.
        >commit 7752d5cfe3d11ca0bb9c673ec38bd78ba6578f8e
        > Author: Robert Hancock <hancockr@shaw.ca>
        > Date:   Fri Feb 15 01:27:20 2008 -0800
           >x86: validate against acpi motherboard resources
    
       After the above commit is merged, OS will check whether MCFG area is
    reserved in ACPI motherboard resources by calling the function of
    acpi_get_devices when there exists MCFG table. In the acpi_get_devices the _STA
    object will be evaluated to check the status of the ACPI device. On some broken
    BIOS the MYEC object of EC device is initialized as one, which indicates that
    EC operation region is already accessible before enabling EC device.So on these
    broken BIOS the EC operation region will be accessed in course of evaluating
    the _STA object before enabling EC device, which causes that OS will print the
    following warning messages:
        >ACPI Error (evregion-0315): No handler for Region [EC__] (ffff88007f8145e8)
    [EmbeddedControl] [20080609]
        >ACPI Error (exfldio-0290): Region EmbeddedControl(3) has no handler [20080321]
        >ACPI Error (psparse-0530): Method parse/execution failed [\_SB_.PCI0.SBRG.
             EC__.BAT1._STA] (Node ffff81013fc17a00), AE_NOT_EXIST
        >ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.SBRG.EC__.BAT1.
             _STA] (Node ffff81013fc17a00), AE_NOT_EXIST
    
    Although the above warning message is harmless, it looks confusing.
    So it is necessary to enable EC device as early as possible.Maybe it is
    appropriate to enable it immediately after ACPI full initialization.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=11255
    http://bugzilla.kernel.org/show_bug.cgi?id=11374
    http://bugzilla.kernel.org/show_bug.cgi?id=11660
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0a918a9432cc30aede10f904253b66ea6ab485ac
Author: Thomas Renninger <trenn@suse.de>
Date:   Sat Oct 11 00:15:04 2008 -0400

    Subject: ACPI dock: Use ACPI_EXCEPTION instead of printk(KERN_ERR
    
    lenb: stripped patch down to what still applied to new dock.c
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ae3a1b46099aa87f1662621580c985432ca1c9d9
Author: Carlos Corbacho <carlos@strangeworlds.co.uk>
Date:   Fri Oct 10 17:33:35 2008 +0100

    acer-wmi: Remove private workqueue
    
    As per Dmitry Torokhov's suggestion, acer-wmi doesn't need a private
    workqueue, so remove it.
    
    Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fa89b6089b5f4c7a5244b642caaca3e72b06ebe4
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Wed Sep 24 19:04:32 2008 -0700

    ACPI: remove unused have_arch_parse_srat
    
    This was a workaround for 32bit numa SRAT processing, and we removed those
    workarounds, making 32 bit more like 64 bit.  HAVE_ARCH_PARSE_SRAT is no
    longer defined anywhere.
    
    Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ee297533279a802eac8b1cbea8e65b24b36a1aac
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Wed Sep 24 19:04:31 2008 -0700

    ACPI: don't load acpi_cpufreq if acpi=off
    
    Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ac88a8f3f7df04774b386ddaf586040adb819b58
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Tue Aug 19 16:53:52 2008 -0600

    PNP: remove old CONFIG_PNP_DEBUG option
    
    CONFIG_PNP_DEBUG is no longer used to turn on dev_dbg() in PNP,
    since we have pnp_dbg() which can be enabled at boot-time, so
    this patch removes the config option.
    
    Note that pnp_dock_event() checks "#ifdef DEBUG".  But there's
    never been a clear path for enabling that via configgery.  It
    happened that CONFIG_PNP_DEBUG enabled it after 1bd17e63a068db6,
    but that was accidental and only in 2.6.26.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2f53432c2aedbe79020e44525eb069d9138a01dd
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Tue Aug 19 16:53:47 2008 -0600

    PNP: convert to using pnp_dbg()
    
    pnp_dbg() is equivalent to dev_dbg() except that we can turn it
    on at boot-time with the "pnp.debug" kernel parameter, so we don't
    have to build a new kernel image.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 97ef062bbe08f46903f29ecdf432be302c977f3b
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Tue Aug 19 16:53:41 2008 -0600

    PNP: add CONFIG_PNP_DEBUG_MESSAGES and pnp_dbg()
    
    This adds the core function pnp_dbg() and a new config option to
    enable it.
    
    The PNP core debugging messages can be enabled at boot-time with the
    "pnp.debug" kernel parameter.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2663f60d434139298835af690f4891cec5c1e501
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Tue Aug 19 16:53:36 2008 -0600

    PNP: remove some uses of DEBUG ifdef
    
    Use scnprintf() to build up a buffer of PNP IDs to print.  This
    makes the printk atomic and helps get rid of an #ifdef.
    
    Also remove an "#ifdef DEBUG" from some debug functions.  The
    functions only produce debug output, so it's OK to run the
    function and just have the output be dropped at the end.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 668b21de141edcba3fb13a4f810641eea4740fd7
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Tue Aug 19 16:53:31 2008 -0600

    PNP: use new vsprintf symbolic function pointer format
    
    Use the '%pF' format to get rid of an "#ifdef DEBUG".
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c865d2f6eb160c15b74245b4891c8e945d67d96c
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Tue Aug 19 16:53:26 2008 -0600

    PNP: convert the last few pnp_info() uses to printk()
    
    There are only a few remaining uses of pnp_info(), so I just
    converted them to printk and removed the pnp_err(), pnp_info(),
    pnp_warn(), and pnp_dbg() wrappers.
    
    I also removed a couple debug messages that don't seem useful any
    more ("driver registered", "driver unregistered", "driver attached").
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 958a1fdd3904b009c926cb840be48ce3c5f2389e
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Tue Aug 19 16:53:21 2008 -0600

    PNPACPI: use dev_printk when possible
    
    Use dev_printk() when possible for more informative error messages.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6a0b93bae96f292b6c091cce5abfb9a644e649e9
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Tue Aug 19 16:53:16 2008 -0600

    PNP: fix debug formatting (cosmetic)
    
    This patch just fixes indentation of a couple debug messages.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b3cef8f6eba47a10b80aa3e7a99e27110e34f3df
Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Fri Sep 19 14:06:59 2008 -0700

    toshiba_acpi: depends on INPUT
    
    CONFIG_ACPI_TOSHIBA can =y when CONFIG_INPUT=m, so prevent that
    combination and its subsequent build errors:
    
    toshiba_acpi.c:(.text+0x3e877): undefined reference to `input_event'
    toshiba_acpi.c:(.text+0x3e98a): undefined reference to `input_unregister_polled_device'
    toshiba_acpi.c:(.text+0x3e994): undefined reference to `input_free_polled_device'
    toshiba_acpi.c:(.init.text+0x21b4): undefined reference to `input_allocate_polled_device'
    toshiba_acpi.c:(.init.text+0x2263): undefined reference to `input_register_polled_device'
    make[1]: *** [.tmp_vmlinux1] Error 1
    
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit db89b4f0dbab837d0f3de2c3e9427a8d5393afa3
Author: Pavel Machek <pavel@suse.cz>
Date:   Mon Sep 22 14:37:34 2008 -0700

    ACPI: catch calls of acpi_driver_data on pointer of wrong type
    
    Catch attempts to use of acpi_driver_data on pointers of wrong type.
    
    akpm: rewritten to use proper C typechecking and remove the
    "function"-used-as-lvalue thing.
    
    Signed-off-by: Pavel Machek <pavel@suse.cz>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9e113e0014204bfb44a2baa29b2a141ede41b074
Author: Harvey Harrison <harvey.harrison@gmail.com>
Date:   Mon Sep 22 14:37:29 2008 -0700

    ACPI: toshiba_acpi.c fix sparse signedness mismatch warnings
    
    set_bit expects unsigned int, and we start with a u32 anyway.
    drivers/acpi/toshiba_acpi.c:397:14: warning: incorrect type in argument 1 (different signedness)
    drivers/acpi/toshiba_acpi.c:397:14:    expected unsigned int [usertype] *word
    drivers/acpi/toshiba_acpi.c:397:14:    got int *<noident>
    drivers/acpi/toshiba_acpi.c:399:14: warning: incorrect type in argument 1 (different signedness)
    drivers/acpi/toshiba_acpi.c:399:14:    expected unsigned int [usertype] *word
    drivers/acpi/toshiba_acpi.c:399:14:    got int *<noident>
    drivers/acpi/toshiba_acpi.c:401:14: warning: incorrect type in argument 1 (different signedness)
    drivers/acpi/toshiba_acpi.c:401:14:    expected unsigned int [usertype] *word
    drivers/acpi/toshiba_acpi.c:401:14:    got int *<noident>
    
    Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4b5fcb353ba46adfa2f98546e3d34e7dc65221cb
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed Sep 10 14:33:43 2008 +0400

    ACPI: acpi_driver_data could only be applied to acpi_device
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    CC: Hannes Reinecke <hare@suse.de>
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5000cadcf3188e935dae28c4fc7e24639704ea55
Author: Matt Mackall <mpm@selenic.com>
Date:   Thu Oct 9 11:56:21 2008 -0500

    x86: trim ACPI sleep stack buffer
    
    x86_64 SMP suspend to RAM uses a 10k temporary stack for saving the
    kernel state, but only 4k of it is used. Shrink it to 4k.
    
    Signed-off-by: Matt Mackall <mpm@selenic.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d0d0f7432c9cbd52cb2f31d499f8292b13a7ecac
Author: Matt Mackall <mpm@selenic.com>
Date:   Thu Oct 9 12:41:50 2008 -0500

    x86: remove magic number from ACPI sleep stack buffer
    
    x86_64 SMP suspend to RAM uses a 10k temporary stack for saving the
    kernel state, but only 4k of it is used. Shrink it to 4k.
    
    Signed-off-by: Matt Mackall <mpm@selenic.com>
    Acked-by: Pavel Machek <pavel@suse.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a195dcdcff33b8ef01a23cbc489fdfcdfa28c88e
Author: Matthew Garrett <mjg59@srcf.ucam.org>
Date:   Tue Aug 19 12:13:20 2008 +0100

    eeepc-laptop: Use standard interfaces
    
    eeepc-laptop currently only sends key events via ACPI and has
    non-standard rfkill control. Add an input device and use the rfkill
    infrastructure.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0e6a66e9cf231140d2e49064d48162728edb7746
Author: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Date:   Thu Oct 9 13:44:40 2008 +0930

    fujitsu-laptop: better handling of P8010 hotkey
    
    This patch (mostly from Peter Gruber) improves the handling of the hotkeys
    for P8010 laptops by passing more accurate input events back to userspace.
    This is needed because the P8010 labels these buttons quite differently to
    earlier laptops.  As part of this, a P8010-specific DMI callback check has
    been implemented.  Finally there's some minor whitespace cleanups from
    running the source through Lindent.
    
    Signed-off-by: Peter Gruber <nokos@gmx.net>
    Signed-off-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fcea94ba0773a4bf78d109f2acd72d003f0621f6
Author: Jan Beulich <jbeulich@novell.com>
Date:   Fri Sep 19 15:50:32 2008 -0700

    ACPI: fix FADT parsing
    
    The (1.0 inherited) separate length fields in the FADT are byte granular.
    Further, PM1a/b may have distinct lengths (if using the v2 fields was
    okay) and may live in distinct address spaces.  acpi_tb_convert_fadt()
    should account for all of these conditions.
    
    Apart from these changes I'm puzzled by the fact that, not just for
    acpi_gbl_xpm1{a,b}_enable, acpi_hw_low_level_{read,write}() get an
    explicit size passed rather than using the size found in the passed GAS.
    What happens on a platform that defines PM1{a,b} wider than 16 bits?  Of
    course, acpi_hw_low_level_{read,write}() at present are entirely
    un-prepared to deal with sizes other than 8, 16, or 32, not to speak of a
    non-zero bit_offset or access_width...
    
    Signed-off-by: Jan Beulich <jbeulich@novell.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a66bfa7a4726e9cbdc985133af728a4bd9925d96
Author: Matthew Garrett <mjg@redhat.com>
Date:   Wed Oct 8 21:40:32 2008 +0100

    ACPI: WMI: Enable event methods when registering notifiers
    
    According to the ACPI-WMI spec, event blocks may provide a function call
    for enabling/disabling them. This patch adds support for making these
    calls when registering or removing notifications. Without this, my Dell
    firmware provides no data in the event notification.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7d9a06de616f69374dab00396f27cf00962a72c9
Author: Carlos Corbacho <carlos@strangeworlds.co.uk>
Date:   Wed Oct 8 21:40:26 2008 +0100

    acer-wmi: Remove wireless and bluetooth sysfs entries
    
    These are now replaced by the rfkill interface.
    
    Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0606e1abfcb66c3a29722162f5d2c7ad8b638237
Author: Carlos Corbacho <carlos@strangeworlds.co.uk>
Date:   Wed Oct 8 21:40:21 2008 +0100

    acer-wmi: Add rfkill support for wireless and bluetooth
    
    This patch implements rfkill support for the wireless and bluetooth devices
    commonly found on Acer laptops.
    
    For now, we will always poll these devices once a second to guarantee we
    can catch state changes. On newer Acer laptops, it may be possible to rely
    on WMI events to do this instead, and experimental support for this will be
    added in a later patch.
    
    3G has been deliberately left off for now, as we still have no way to
    detect it, (nor, AFAIK, has any Linux user tried the code) and on laptops
    that don't support 3G, trying to poll for the status will leave the logs
    full of ACPI tracebacks.
    
    The old sysfs interface for wireless and bluetooth will be removed in a
    later patch.
    
    (Thanks to Henrique de Moraes Holschuh and Dmitry Torokhov for reviewing
    this patch).
    
    Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit faee816b1502385dc9bc5abf2960d1cc645844d1
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Fri Sep 12 11:12:25 2008 +0800

    ACPI: don't enable control method power button as wakeup device when Fixed Power button is used
    
    don't enable control method power button as wakeup device
    when Fixed Power button is used.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=10503
    
    Tested-by: walken@zoy.org <walken@zoy.org>
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8463200a00fe2aea938b40173198a0983f2929ef
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Fri Sep 26 00:54:28 2008 +0400

    ACPI: EC: Rename some variables
    
    No functional changes.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Acked-by: Rafael J. Wysocki <rjw@suse.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7c6db4e050601f359081fde418ca6dc4fc2d0011
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Thu Sep 25 21:00:31 2008 +0400

    ACPI: EC: do transaction from interrupt context
    
    It is easier and faster to do transaction directly from interrupt context
    rather than waking control thread.
    Also, cleaner GPE storm avoidance is implemented.
    References: 	http://bugzilla.kernel.org/show_bug.cgi?id=9998
    		http://bugzilla.kernel.org/show_bug.cgi?id=10724
    		http://bugzilla.kernel.org/show_bug.cgi?id=10919
    		http://bugzilla.kernel.org/show_bug.cgi?id=11309
    		http://bugzilla.kernel.org/show_bug.cgi?id=11549
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 709ee531c153038d81b30649b9eeed3c44a4d5cc
Author: Harald Welte <laforge@gnumonks.org>
Date:   Tue Sep 23 17:46:57 2008 +0200

    panasonic-laptop: add Panasonic Let's Note laptop extras driver v0.94
    
    This is a driver for ACPI extras such as hotkeys and backlight
    brightness control on various Panasonic "Let's Note" series laptop
    computers.
    
    It exports the backlight via the backlight class device API,
    and the hotkeys as input event device.  Some more esoteric
    items like number of installed batteries are exported via sysfs
    device attributes.
    
    Hotkey events also generate old-style ACPI enents through
    /proc/acpi/event to interoperate with current versions of acpid.
    
    Signed-off-by: Harald Welte <laforge@gnumonks.org>
    Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Acked-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c5d191b8e531e33b823242f3d2c6b81d765e96dd
Author: Len Brown <len.brown@intel.com>
Date:   Wed Sep 24 02:53:25 2008 -0400

    dock: Shaohua Li is new maintainer
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8652b00fd6416773f113dab3dfa0d4509def825b
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Thu Aug 28 10:07:45 2008 +0800

    dock: add 'type' sysfs file
    
    add a sysfs file to present dock type. Suggested by Holger.
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 61b836958371c717d1e6d4fea1d2c512969ad20b
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Thu Aug 28 10:07:14 2008 +0800

    dock: fix for ATA bay in a dock station
    
    an ATA bay can be in a dock and itself can be ejected separately.
    This patch handles such eject bay. Found by Holger.
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4be9309d15e88e4a1e4a78deb52eb88c7da38c99
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Thu Aug 28 10:06:44 2008 +0800

    bay: remove driver, all functions now handled by dock driver
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1253f7aabfebc51446dbec5c8895c5c8846dfe06
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Thu Aug 28 10:06:16 2008 +0800

    dock: introduce .uevent for devices in dock, eg libata
    
    dock's uevent reported itself, not ata. It might be difficult to find an
    ata device just according to a dock. This patch introduces docking ops
    for each device in a dock. when docking, dock driver can send device
    specific uevent. This should help dock station too (not just bay)
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Acked-by: Tejun Heo <htejun@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f730ae1838635a02aa60834762c61566911d004c
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Thu Aug 28 10:05:45 2008 +0800

    libata: remove functions now handed by ACPI dock driver
    
    dock driver can handle ata(bay) hotplug now. dock driver already handles
    _EJ0 and _STA, so remove them. Also libata doesn't need register
    notification handler anymore.
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Acked-by: Tejun Heo <htejun@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 19cd847ab24fefe9e50101ec94479e0400a08650
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Aug 28 10:05:06 2008 +0800

    ACPI: fix hotplug race
    
    The hotplug notification handler and drivers' notification handler all
    run in one workqueue.  Before hotplug removes an acpi device, the
    device driver's notification handler is already be recorded to run just
    after global notification handler.  After hotplug notification handler
    runs, acpica will notice a NULL notification handler and crash.
    
    So now we run run hotplug in another workqueue and wait
    for all acpi notication handlers finish.
    This was found in battery hotplug, but actually all
    hotplug can be affected.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6bd00a61ab63d4ceb635ae0316353c11c900b8d8
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Thu Aug 28 10:04:29 2008 +0800

    ACPI: introduce notifier change to avoid duplicates
    
    The battery driver already registers notification handler.
    To avoid registering notification handler again,
    introduce a notifier chain in global system notifier handler
    and use it in dock driver.
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit db350b084dc2cf816288643861ce07b0562dd723
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Thu Aug 28 10:03:58 2008 +0800

    dock: add bay and battery hotplug support
    
    Make the dock driver support bay and battery hotplug.
    They are all regarded as dock, so handling can be unified.
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 406f692d0803d73acd3984c1e11719d3a913fd5e
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Thu Aug 28 10:03:26 2008 +0800

    dock: add _LCK support
    
    support _LCK method, which is a optional method for hotplug
    
    lenb: we have not seen _LCK used in the field yet
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 82545394e0690aaef446cb262aa5dac0f9c7156e
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Thu Aug 28 10:02:41 2008 +0800

    dock: fix eject request process (2.6.27-rc1 regression)
    
    commit 2a7feab28d3fc060d320eaba192e49dad1079b7e introduces a bug.
    My thinkpad actually will send an eject_request and we should follow the
    eject process to finish the eject, otherwise system still thinks the bay
    is present.
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8b59560a3baf2e7c24e0fb92ea5d09eca92805db
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Thu Aug 28 10:02:03 2008 +0800

    ACPI: dock: avoid check _STA method
    
    In some BIOSes, every _STA method call will send a notification again,
    this cause freeze. And in some BIOSes, it appears _STA should be called
    after _DCK. This tries to avoid calls _STA, and still keep the device
    present check.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=10431
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2fd47094f92fa2bdbf99be33294a7b6b97785a70
Author: Thomas Renninger <trenn@suse.de>
Date:   Mon Sep 1 14:27:03 2008 +0200

    CPUFREQ: powernow-k8: Try to detect old BIOS, not supporting CPU freq on a recent AMD CPUs.
    
    Make use of FW_BUG interface to give vendors and users the ability to
    automatically check for powernow-k8 related BIOS bugs by:
    dmesg |grep "Firmware Bug"
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 910dfae298f7b3dae0e9a52736182a3b0559ca35
Author: Thomas Renninger <trenn@suse.de>
Date:   Mon Sep 1 14:27:04 2008 +0200

    ACPI: cpufreq, processor: Detect old BIOS, not supporting CPU freq on a recent CPU.
    
    On Intel CPUs it is rather common and a good hint that BIOSes which do provide
    _PPC func, but not the frequencies itself in _PSS function, are old and need
    to be updated for CPU freq support.
    
    Tell the user/vendor he has a BIOS/firmware problem.
    Make use of FW_BUG interface to give vendors and users the ability to
    automatically check with (or let linuxfirmwarekit do that):
    dmesg |grep "Firmware Bug"
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a0ad05c75aa362c91f4d9cd91ff375a739574dd8
Author: Thomas Renninger <trenn@suse.de>
Date:   Mon Sep 1 14:27:02 2008 +0200

    Introduce FW_BUG, FW_WARN and FW_INFO to consistenly tell users about BIOS bugs
    
    The idea is to add this to printk after the severity:
    printk(KERN_ERR FW_BUG "This is not our fault, BIOS developer: fix it by
    simply add ...\n");
    
    If a Firmware issue should be hidden, because it is
    work-arounded, but you still want to see something popping up e.g.
    for info only:
    printk(KERN_INFO FW_INFO "This is done stupid, we can handle it,
    but it should better be avoided in future\n");
    
    or on the Linuxfirmwarekit to tell vendors that they did something
    stupid or wrong without bothering the user:
    printk(KERN_INFO FW_BUG "This is done stupid, we can handle it,
    but it should better be avoided in future\n");
    
    Some use cases:
      - If a user sees a [Firmware Bug] message in the kernel
        he should first update the BIOS before wasting time with
        debugging and submiting on old firmware code to mailing
        lists.
    
      - The linuxfirmwarekit (http://www.linuxfirmwarekit.org)
        tries to detect firmware bugs. It currently is doing that
        in userspace which results in:
            - Huge test scripts that could be a one liner in the kernel
            - A lot of BIOS bugs are already absorbed by the kernel
    
    What do we need such a stupid linuxfirmwarekit for?
    
      - Vendors: Can test their BIOSes for Linux compatibility.
        There will be the time when vendors realize that the test utils
        on Linux are more strict and using them increases the qualitity
        and stability of their products.
    
      - Vendors: Can easily fix up their BIOSes and be more Linux
        compatible by:
        dmesg |grep "Firmware Bug"
        and send the result to their BIOS developer colleagues who should
        know what the messages are about and how to fix them, without
        the need of studying kernel code.
    
      - Distributions: can do a first automated HW/BIOS checks.
        This can then be done without the need of asking kernel developers
        who need to dig down the code and explain the details.
        Certification can/will just be rejected until
        dmesg |grep "Firmware Bug" is empty.
    
      - Thus this can be used as an instrument to enforce cleaner BIOS
        code. Currently every stupid Windows ACPI bug is
        re-implemented in Linux which is a rather unfortunate situation.
        We already have the power to avoid this in e.g. memory
        or cpu hot-plug ACPI implementations, because Linux certification
        is a must for most vendors in the server area.
        Working towards being able to do that in the laptop area
        (vendors are starting to look at Linux here also and will use this tool)
        is the goal. At least provide them a tool to make it as easy
        for this guys (e.g. not needing to browse kernel code) as possible.
    
      - The ordinary Linux user: can go into the next shop, boots the
        firmwarekit on his most preferred machines. He chooses one without
        BIOS bugs. Unsupported HW is ok, he likes to try out latest projects
        which might support them or likes to dig on it on his own, but he
        hates to workaround broken BIOSes like hell.
    
    I double checked with the firmwarekit.
    There they have:
    So the mapping generally is (also depending on how likely the BIOS is
    to blame, this could sometimes be difficult):
    FW_INFO  = INFO
    FW_WARN  = WARN
    FW_BUG   = FAIL
    
    For more info about the linuxfirmwarekit and why this is needed
    can be found here:
    http://www.linuxfirmwarekit.org
    
    While severity matches with the firmwarekit, it might be tricky
    to hide messages from the user.
    E.g. we recently found out that on HP BIOSes negative temperatures
    are returned, which seem to indicate that the thermal zone is
    invalid.
    We can work around that gracefully by ignoring the thermal zone
    and we do not want to bother the ordinary user with a frightening
    message: Firmware Bug: thermal management absolutely broken
    but want to hide it from the user.
    
    But in the linuxfirmwarekit this should be shown as a real
    show stopper (the temperatures could really be wrong,
    broken thermal management is one of the worst things
    that can happen and the BIOS guys of the machine must
    implement this properly).
    
    It is intended to do that (hide it from the user with
    KERN_INFO msg, but still print it as a BIOS bug) by:
    printk(KERN_INFO FW_BUG "Negativ temperature values detected.
    Try to workarounded, BIOS must get fixed\n");
    Hope that works out..., no idea how to better hide it
    as printk is the only way to easily provide this functionality.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

--Boundary_(ID_44NyDOeALODibCElguMcZQ)--
