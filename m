Return-Path: <linux-kernel-owner+w=401wt.eu-S1760785AbYBGKu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760785AbYBGKu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 05:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755716AbYBGKun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 05:50:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:42562 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315AbYBGKug convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 05:50:36 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PATCH] ACPI patches for 2.6.25-rc0
Date: Thu, 7 Feb 2008 04:50:08 -0500
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802070450.09098.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

Hmmm, where to begin...
The standard platform specific driver updates, thinkpad, sony, asus
Thermal extensions to support Intel's new Menlo platform.
INITRAMFS DSDT override, a patch I resisted for years, but finally was convinced.
/sys/firmware/acpi/interrupts/ to see where your ACPI interrutps come from...
Initial WMI support -- Windows can run, but it can't hide...
video/brightness continues to mature...
cpuidle is now default enabled on ACPI configs
a bunch of bug fixes

This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.24/acpi-release-20070126-2.6.24.diff.gz

 Documentation/00-INDEX                        |    3 
 Documentation/ABI/testing/sysfs-firmware-acpi |   99 
 Documentation/acpi/dsdt-override.txt          |   15 
 Documentation/acpi/initramfs-add-dsdt.sh      |   43 
 Documentation/acpi/method-tracing.txt         |   26 
 Documentation/kernel-parameters.txt           |    9 
 Documentation/power/swsusp.txt                |    5 
 Documentation/thermal/sysfs-api.txt           |  246 +
 Documentation/thinkpad-acpi.txt               |  116 
 MAINTAINERS                                   |   19 
 arch/ia64/kernel/acpi-processor.c             |    6 
 arch/ia64/kernel/acpi.c                       |   32 
 arch/x86/Kconfig                              |    3 
 arch/x86/kernel/acpi/boot.c                   |   47 
 arch/x86/kernel/acpi/processor.c              |    6 
 arch/x86/kernel/cpu/cpufreq/speedstep-lib.c   |    5 
 arch/x86/kernel/srat_32.c                     |    2 
 drivers/Kconfig                               |    2 
 drivers/Makefile                              |    1 
 drivers/acpi/Kconfig                          |   40 
 drivers/acpi/Makefile                         |    1 
 drivers/acpi/asus_acpi.c                      |   55 
 drivers/acpi/battery.c                        |    5 
 drivers/acpi/bay.c                            |   10 
 drivers/acpi/blacklist.c                      |   58 
 drivers/acpi/bus.c                            |   26 
 drivers/acpi/debug.c                          |   57 
 drivers/acpi/dispatcher/dsopcode.c            |    4 
 drivers/acpi/dock.c                           |   14 
 drivers/acpi/ec.c                             |   19 
 drivers/acpi/event.c                          |   28 
 drivers/acpi/events/evevent.c                 |    2 
 drivers/acpi/events/evgpe.c                   |   27 
 drivers/acpi/fan.c                            |   92 
 drivers/acpi/glue.c                           |    4 
 drivers/acpi/hardware/hwsleep.c               |    2 
 drivers/acpi/namespace/nsxfeval.c             |   10 
 drivers/acpi/numa.c                           |    3 
 drivers/acpi/osl.c                            |  372 +
 drivers/acpi/pci_bind.c                       |    4 
 drivers/acpi/pci_irq.c                        |    7 
 drivers/acpi/pci_link.c                       |    2 
 drivers/acpi/power.c                          |    6 
 drivers/acpi/processor_core.c                 |   42 
 drivers/acpi/processor_idle.c                 |   47 
 drivers/acpi/processor_perflib.c              |   16 
 drivers/acpi/processor_thermal.c              |  134 
 drivers/acpi/processor_throttling.c           |  346 +
 drivers/acpi/sbs.c                            |    2 
 drivers/acpi/sbshc.c                          |    4 
 drivers/acpi/scan.c                           |  110 
 drivers/acpi/sleep/main.c                     |   17 
 drivers/acpi/sleep/proc.c                     |   46 
 drivers/acpi/system.c                         |  208 
 drivers/acpi/tables/Makefile                  |    2 
 drivers/acpi/tables/tbxfroot.c                |    4 
 drivers/acpi/thermal.c                        |  663 ++
 drivers/acpi/utilities/utglobal.c             |    2 
 drivers/acpi/video.c                          |  262 -
 drivers/acpi/wmi.c                            |  710 +++
 drivers/cpuidle/Kconfig                       |    4 
 drivers/cpuidle/cpuidle.c                     |   41 
 drivers/firmware/dmi_scan.c                   |    9 
 drivers/misc/Kconfig                          |   53 
 drivers/misc/Makefile                         |    3 
 drivers/misc/acer-wmi.c                       | 1109 ++++
 drivers/misc/asus-laptop.c                    |   26 
 drivers/misc/intel_menlow.c                   |  526 ++
 drivers/misc/sony-laptop.c                    |  445 +
 drivers/misc/tc1100-wmi.c                     |  290 +
 drivers/misc/thinkpad_acpi.c                  | 3256 +++++++++-----
 drivers/misc/thinkpad_acpi.h                  |  606 --
 drivers/pnp/pnpacpi/core.c                    |    2 
 drivers/power/power_supply_sysfs.c            |    1 
 drivers/thermal/Kconfig                       |   15 
 drivers/thermal/Makefile                      |    5 
 drivers/thermal/thermal.c                     |  714 +++
 include/acpi/acglobal.h                       |    4 
 include/acpi/acmacros.h                       |    6 
 include/acpi/acpi_bus.h                       |    5 
 include/acpi/acpi_drivers.h                   |    2 
 include/acpi/acpi_numa.h                      |    1 
 include/acpi/acpiosxf.h                       |    7 
 include/acpi/processor.h                      |   13 
 include/linux/acpi.h                          |   62 
 include/linux/cpuidle.h                       |   13 
 include/linux/dmi.h                           |    2 
 include/linux/kernel.h                        |    1 
 include/linux/power_supply.h                  |    1 
 include/linux/sonypi.h                        |    2 
 include/linux/thermal.h                       |   94 
 init/initramfs.c                              |    8 
 init/main.c                                   |    7 
 kernel/panic.c                                |    5 
 kernel/power/Kconfig                          |    9 
 95 files changed, 9009 insertions(+), 2486 deletions(-)

through these commits:

Adrian Bunk (3):
      ACPI: make acpi_dmi_dump() static
      ACPI: make struct osi_linux static
      ACPI: misc cleanups

Alan Cox (1):
      ACPI: its a directory not a folder....

Alexey Starikovskiy (3):
      ACPI: Defer enabling of level GPE until all pending notifies done
      ACPI: EC: Do the byte access with a fast path
      ACPI: EC: Some hardware requires burst mode to operate properly

Andrew Patterson (1):
      ACPI: Check for any matching CID when walking namespace.

Carlos Corbacho (3):
      ACPI: WMI: Add ACPI-WMI mapping driver
      acer-wmi: Add driver for newer Acer laptops
      tc1100-wmi: Add driver for HP Compaq TC1100 Tablets

Corentin CHARY (1):
      asus-laptop new write_acpi_int

Dave Jones (1):
      ACPI: remove P2B-S from blacklist.

Frank Seidel (2):
      ACPI: Fix autloading of dock, video, bay and all linux specific HID drivers
      ACPI: Add autoload info to dock driver

Henrique de Moraes Holschuh (20):
      ACPI: thinkpad-acpi: document keymap gotcha's (v2)
      ACPI: thinkpad-acpi: refactor hotkey_get and hotkey_set (v2)
      ACPI: thinkpad-acpi: prepare for NVRAM polling support
      ACPI: thinkpad-acpi: add CMOS NVRAM polling for hot keys (v9)
      ACPI: thinkpad-acpi: bump up version to 0.18
      ACPI: thinkpad-acpi: spring cleanup part 1
      ACPI: thinkpad-acpi: spring cleanup part 2
      ACPI: thinkpad-acpi: spring cleanup part 3
      ACPI: thinkpad-acpi: spring cleanup part 4
      ACPI: thinkpad-acpi: module glue cleanups
      ACPI: thinkpad-acpi: rename IBM in defines
      ACPI: thinkpad-acpi: some checkpatch.pl fluff
      ACPI: thinkpad-acpi: add suspend handler
      ACPI: thinkpad-acpi: cleanup hotkey_notify and HKEY log messages
      ACPI: thinkpad-acpi: wakeup on hotunplug reporting
      ACPI: thinkpad-acpi: add X61t HKEY events
      ACPI: thinkpad-acpi: silence _sta warning
      ACPI: thinkpad-acpi: add poll() support to some sysfs attributes
      ACPI: thinkpad-acpi: update copyright dates to 2008
      ACPI: thinkpad-acpi: bump up version to 0.19

Jan Beulich (1):
      acpi: make __acpi_map_table() and __init function

Jean Delvare (1):
      ACPI: cleanup acpi.h

Kevin Hilman (1):
      cpuidle: build fix for non-x86

Len Brown (17):
      ACPI: document method tracing hooks
      cpuidle: create processor.latency_factor tunable
      cpuidle: default processor.latency_factor=2
      ACPI: tables: complete searching upon RSDP w/ bad checksum.
      ACPI: throttling: fix build warning
      ACPI: fan: build fix for CONFIG_ACPI_PROCFS=n
      ACPI: remove redundant Acer blacklist entry
      DMI: remove duplicate helper routine
      ACPI: update blacklist comments
      ACPI: blacklist update
      ACPI: create /sys/firmware/acpi/interrupts
      ACPICA: fix CONFIG_ACPI_DEBUG_FUNC_TRACE build
      ACPI: add missing prink prefix strings
      ACPI: update DSDT override documentation
      ACPI: update intrd DSDT override console messages
      Revert "cpuidle: build fix for non-x86"
      ACPI: fix build warning

Luca Tettamanti (1):
      asus_acpi: add support for F3Sa

Markus Gaugusch (1):
      ACPI: basic initramfs DSDT override support

Matthew Garrett (4):
      ACPI: video: Rationalise ACPI backlight implementation
      ACPI: video: Ignore devices that aren't present in hardware
      ACPI: video: reset brightness on resume
      ACPI: video: Ignore ACPI video devices that aren't present in hardware

Matthias Kaehlcke (1):
      ACPI: acpi_pci_irq_find_prt_entry(): use list_for_each_entry() instead of list_for_each()

Mattia Dongili (6):
      sony-laptop: printk more info in sony_pic_call[123]
      sony-laptop: Add Vaio N series to the special init sequence to enable Fn keys
      sony-laptop: refactor model types
      sony-laptop: bump version to 0.6
      sony-laptop: add Type4 model
      sony-laptop: fix scancode decode

Miguel Botón (1):
      ACPI: remove duplicated warning message

Pavel Machek (1):
      PM: documentation cleanups

Rafael J. Wysocki (1):
      ACPI: Fix acpi_pm_device_sleep_state()

Roel Kluin (2):
      asus-laptop: add parentheses
      ACPI: thinkpad-acpi: second TP_EC_FAN_FULLSPEED should be TP_EC_FAN_AUTO

Shaohua Li (1):
      pnp: Failed to activate device 00:0a - Samsung P35 XVM 1600 III

Signed-off by Yi Yang (1):
      ACPI: detect invalid argument written to /proc/acpi/alarm

Thomas Renninger (4):
      ACPI: Also autoload the bay driver, was forgotten...
      ACPI: add "processor.ignore_ppc" hook to workaround BIOS _PPC weirdness
      ACPI: track opregion names to avoid driver resource conflicts.
      ACPI: Export acpi_check_resource_conflict

Thomas Sujith (1):
      intel_menlo: introduce new platform specific driver

Yi Yang (1):
      ACPI: /proc/acpi/alarm parsing: handle large numbers properly

Zhang Rui (17):
      ACPI: add control method tracing support
      ACPI: disable stray GPE, prevent ACPI interrupt storm
      export thermal notification to userspace when nocrt is set
      ACPI: ACPI Exception (): AE_NOT_FOUND, Processor Device is not present
      the generic thermal sysfs driver
      ACPI: register ACPI thermal zone as generic thermal zone devices
      ACPI: ACPI thermal zone handle notification correctly
      ACPI: register ACPI Fan as generic thermal cooling device
      ACPI: register ACPI Processor as generic thermal cooling device
      ACPI: register ACPI Video LCD as generic thermal cooling device
      ACPI: attach thermal zone info
      ACPI: CELSIUS_TO_KELVIN fixup
      ACPI: thermal fixup
      ACPI: video: create "brightness_switch_enabled" modparam
      ACPI: video: delete unused display switch on hotkey event code
      ACPI: create notifier chain to get hotkey events to graphics driver
      ACPI: video: call ACPI notifier chain for ACPI video notifications

Zhao Yakui (6):
      Revert "speedstep-lib.c: fix frequency multiplier for Pentium4 models 0&1"
      ACPI: Set _PSD ACPI_PDC_SMP_T_SWCOORD
      ACPI : Check parameter when calling acpi_processor_get/set_throttling
      ACPI : Update T-state coordination after getting _TSD info
      ACPI : Add T-state event notifier function
      ACPI: Update the t-state for every affected cpu when t-state is changed

len.brown@intel.com (1):
      ACPI: CONFIG_CPU_IDLE=ACPI by default

maximilian attems (1):
      ACPI: battery: add sysfs serial number

venkatesh.pallipadi@intel.com (4):
      ACPI: idle: Fix acpi_safe_halt usages and interrupt enabling/disabling
      ACPI: enable MWAIT for C1 idle
      ACPI: cpuidle: Support C1 idle time accounting
      cpuidle: Add a poll_idle method

Éric Piel (2):
      ACPI: Taint kernel on ACPI table override (format corrected)
      ACPI: Add "acpi_no_initrd_override" kernel parameter

with this log:

commit b7143156c9ceee1a072c57aac8729d2dec5b3bf1
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 7 04:24:01 2008 -0500

    ACPI: fix build warning
    
    drivers/acpi/system.c:360: warning: ignoring return value of ‘sysfs_create_group’, declared with attribute warn_unused_result
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9b7131542178f5f948e4bb6bea6e1c545e697b06
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 7 04:16:34 2008 -0500

    Revert "cpuidle: build fix for non-x86"
    
    This reverts commit f757397097d0713c949af76dccabb65a2785782e.
    which ironically broke the ia64 build

commit 81e242d0efafb319938d511b115088a5c4523c91
Merge: a733a5d... 04d9488...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 7 04:01:53 2008 -0500

    Merge branches 'release' and 'dsdt-override' into release

commit 04d94886b47b5133915021dcfb1108a8576f6ea7
Author: Len Brown <len.brown@intel.com>
Date:   Wed Feb 6 19:49:54 2008 -0500

    ACPI: update intrd DSDT override console messages
    
    also, address some checkpatch.pl violations
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d89e9d6b4930c6505ac3ed35f57ab7f4311d6cf6
Author: Len Brown <len.brown@intel.com>
Date:   Wed Feb 6 19:28:02 2008 -0500

    ACPI: update DSDT override documentation
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9cbc7960288d28aec95257af59854e1d14ba23b8
Author: Éric Piel <Eric.Piel@tremplin-utc.net>
Date:   Tue Feb 5 00:04:58 2008 +0100

    ACPI: Add "acpi_no_initrd_override" kernel parameter
    
    The acpi_no_initrd_override parameter permits to disable the load of an ACPI
    table from the initramfs.
    
    Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a733a5da97b238e3e3167d3d0aee8fe1e8d04e97
Merge: 299cfe3... 299cfe3... 9e52797...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 7 03:38:22 2008 -0500

    Merge branches 'release' and 'fluff' into release
    
    Conflicts:
    
    	drivers/acpi/scan.c
    	include/linux/acpi.h
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9e52797131e83688f66fbca6d4cd25b83f33c48f
Author: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date:   Thu Jan 3 16:31:42 2008 +0000

    ACPI: its a directory not a folder....
    
    The kernel help consistently uses 'directory'
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e5685b9d35c2cc0a98425b05df30cb837dd1e632
Author: Adrian Bunk <bunk@kernel.org>
Date:   Wed Oct 24 18:24:42 2007 +0200

    ACPI: misc cleanups
    
        This patch contains the following possible cleanups:
        - make the following needlessly global code static:
          - drivers/acpi/bay.c:dev_attr_eject
          - drivers/acpi/bay.c:dev_attr_present
          - drivers/acpi/dock.c:dev_attr_docked
          - drivers/acpi/dock.c:dev_attr_flags
          - drivers/acpi/dock.c:dev_attr_uid
          - drivers/acpi/dock.c:dev_attr_undock
          - drivers/acpi/pci_bind.c:acpi_pci_unbind()
          - drivers/acpi/pci_link.c:acpi_link_lock
          - drivers/acpi/sbs.c:acpi_sbs_callback()
          - drivers/acpi/sbshc.c:acpi_smbus_transaction()
          - drivers/acpi/sleep/main.c:acpi_sleep_prepare()
        - #if 0 the following unused global functions:
          - drivers/acpi/numa.c:acpi_unmap_pxm_to_node()
        - remove the following unused EXPORT_SYMBOL's:
          - acpi_register_gsi
          - acpi_unregister_gsi
          - acpi_strict
          - acpi_bus_receive_event
          - register_acpi_bus_type
          - unregister_acpi_bus_type
          - acpi_os_printf
          - acpi_os_sleep
          - acpi_os_stall
          - acpi_os_read_pci_configuration
          - acpi_os_create_semaphore
          - acpi_os_delete_semaphore
          - acpi_os_wait_semaphore
          - acpi_os_signal_semaphore
          - acpi_os_signal
          - acpi_pci_irq_enable
          - acpi_get_pxm
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 87ecd5cddaa37f057d8d8c2813e1b748b1804423
Author: Len Brown <len.brown@intel.com>
Date:   Tue Jan 1 14:00:00 2008 -0500

    ACPI: add missing prink prefix strings
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ee1ce6fcb383ba1da9d16e1ba902f592211aa508
Author: Jean Delvare <jdelvare@suse.de>
Date:   Thu Dec 6 22:00:36 2007 -0500

    ACPI: cleanup acpi.h
    
    Two cleanups to <linux/acpi.h>:
    * Stop defining acpi_mp_config, it isn't used anywhere.
    * Discard nested "#ifdef CONFIG_ACPI", they are useless and
      error-prone.
    
    Signed-off-by: Jean Delvare <jdelvare@suse.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4e83dd95b343a4ecfdb236aa046a5366a29e6f1e
Author: Len Brown <len.brown@intel.com>
Date:   Fri Nov 23 18:33:11 2007 -0500

    ACPICA: fix CONFIG_ACPI_DEBUG_FUNC_TRACE build
    
    798d91039849486c7a4f1a458a5680cb55a65408
    (ACPI: create CONFIG_ACPI_DEBUG_FUNC_TRACE)
    
    failed to associate the new tracing config option with the tracing code.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 299cfe38081bea6dcd8b882375f6f65a980bccf9
Merge: 8976b6f... 443dea7...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 7 03:31:17 2008 -0500

    Merge branches 'release' and 'hwmon-conflicts' into release

commit 8976b6fd7a0060f72e20d5cec833c03d50874cd1
Merge: 52b097f... 3391a76...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 7 03:30:48 2008 -0500

    Merge branches 'release' and 'throttling-domains' into release

commit 52b097fff89b14c0b8b7a7deef1d274889b1886d
Merge: 0601955... 0601955... 3fa2cdc...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 7 03:25:48 2008 -0500

    Merge branches 'release' and 'video' into release
    
    Conflicts:
    
    	include/acpi/acpi_bus.h
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3fa2cdcc45a0176de15cac9dbf4ed2834ebf8932
Author: Matthew Garrett <mjg59@srcf.ucam.org>
Date:   Thu Feb 7 01:44:06 2008 +0000

    ACPI: video: Ignore ACPI video devices that aren't present in hardware
    
    Vendors often ship machines with a choice of integrated or discrete
    graphics, and use the same DSDT for both. As a result, the ACPI video
    module will locate devices that may not exist on this specific platform.
    
    Attempt to determine whether the device exists or not, and abort the
    device creation if it do not exist.
    
    Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 863c1490e512db40dab61e44b694a493a9e68b3f
Author: Matthew Garrett <mjg59@srcf.ucam.org>
Date:   Mon Feb 4 23:31:24 2008 -0800

    ACPI: video: reset brightness on resume
    
    Some machines seem to need the backlight brightness to be reset on resume.
    Add support for doing so to the video module.
    
    [akpm@linux-foundation.org: coding-style fixes]
    Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
    Cc: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7761f638f6e0f276fe8612ba306d09c40d1b553c
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Fri Jan 25 14:48:12 2008 +0800

    ACPI: video: call ACPI notifier chain for ACPI video notifications
    
    Call notifier chain for display/brightness switch events.
    The kernel mode graphics driver is interested in this.
    
    Sign-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9ee85241fdaab358dff1d8647f20a478cfa512a1
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Fri Jan 25 14:48:06 2008 +0800

    ACPI: create notifier chain to get hotkey events to graphics driver
    
    Kernel mode graphics drivers need this ACPI notifier chaine
    so that they can get notified upon hotkey events.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ba5e1223422368fd2f4dbb0745f5fbb5fe9a65f1
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Fri Jan 25 14:47:57 2008 +0800

    ACPI: video: delete unused display switch on hotkey event code
    
    Display switching via ACPI control methods are
    not known to work on any platforms.
    
    Further, the X community wants to control the display
    switching all by themselves without BIOS/AML involvement.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8a681a4dee07ea09aedaadc6a2da28d2131dc414
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Fri Jan 25 14:47:49 2008 +0800

    ACPI: video: create "brightness_switch_enabled" modparam
    
    Introduce new module parameter for brightness control.
    "brightness_switch_enabled" is set by default which means
    nothing changes upon brightness switch events.
    
    When "brightness_switch_enabled" is cleared via
    "echo 0 > /sys/module/video/parameters/brightness_switch_enabled",
    ACPI will not try to change the brightness level any more.
    
    Either X will take charge of this or users can change the brightness level
    by poking /sys/class/backlight/acpi_videoX/...
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 060195500e0347a6ba8ea89739a9898961eb6f2b
Merge: 26b6f22... dd8cd77...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 7 03:19:43 2008 -0500

    Merge branches 'release' and 'wmi-2.6.25' into release

commit 26b6f2236615649a0ae6a0de2e9e71a2f9ffeba7
Merge: e5e54bc... e5e54bc... 3c60284...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 7 03:18:04 2008 -0500

    Merge branches 'release' and 'menlo' into release
    
    Conflicts:
    
    	drivers/acpi/video.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e5e54bc86a1fed9849b22fd736c30b23c4719046
Merge: 70ec75c... 5229e87...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 7 03:13:36 2008 -0500

    Merge branches 'release' and 'stats' into release

commit 70ec75c5b8e0bda7a16fb387f91e08545f379a0e
Merge: 4f4ae0d... 2fdf074... 23b168d...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 7 03:13:13 2008 -0500

    Merge branches 'release', 'misc' and 'misc-2.6.25' into release

commit 4f4ae0d42680889c62db4e1f3e6b4aa7787a7257
Merge: d870ec7... 623b78c...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 7 03:12:17 2008 -0500

    Merge branches 'release' and 'ppc-workaround' into release

commit d870ec7281d8429ab17d2e0324f4d8ca3f3de62d
Merge: 7924e4f... 02f8a85...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 7 03:11:56 2008 -0500

    Merge branches 'release' and 'hp-cid' into release

commit 7924e4f6519dd5b349ed146fe9fe35206730be67
Merge: 5531d28... 17bc54e...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 7 03:11:47 2008 -0500

    Merge branches 'release' and 'gpe-ack' into release

commit 5531d28504461c4e96c6fbd80655a2bfd6481583
Merge: acf6386... a64217b...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 7 03:11:31 2008 -0500

    Merge branches 'release' and 'dmi' into release

commit acf63867ae06ef95eea7bf445ded2f05528a81b1
Merge: c64768a... f757397... 9a0b841...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 7 03:11:05 2008 -0500

    Merge branches 'release', 'cpuidle-2.6.25' and 'idle' into release

commit c64768a7d671bcde80bca2aed93f9e07edc069c3
Merge: 8f85901... a7f9b1f... b4d2730... 37748eb... ed9cbcd... 856608e... cfaf374... 223630f... 38531e6... b3b233c... 239665a... 0119509... 975c302... 0879802...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 7 03:09:43 2008 -0500

    Merge branches 'release', 'bugzilla-6217', 'bugzilla-6629', 'bugzilla-6933', 'bugzilla-7186', 'bugzilla-8269', 'bugzilla-8570', 'bugzilla-9139', 'bugzilla-9277', 'bugzilla-9341', 'bugzilla-9444', 'bugzilla-9614', 'bugzilla-9643' and 'bugzilla-9644' into release

commit 8f859016ea49cd8d7c743533bd1ab3db9a813ffa
Merge: dd07a8d... 17196d6...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 7 03:07:55 2008 -0500

    Merge branches 'release' and 'autoload' into release

commit dd07a8db7283f52f347aee468007556944b5b393
Merge: 877c357... 31e0729... fccd5d0... 547266e...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 7 03:07:35 2008 -0500

    Merge branches 'release', 'asus', 'sony-laptop' and 'thinkpad' into release

commit 877c357e7511395bc923ec9efc2e8b021a17ed79
Merge: 488b5ec... ad3399c... 7c2670b...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 7 03:07:03 2008 -0500

    Merge branches 'release', 'acpi_pm_device_sleep_state' and 'battery' into release

commit 9a0b841586c3c6c846effdbe75885c2ebc0031b0
Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
Date:   Thu Jan 31 17:35:06 2008 -0800

    cpuidle: Add a poll_idle method
    
    Add a default poll idle state with 0 latency. Provides an option to users
    to use poll_idle by using 0 as the latency requirement.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9b12e18cdc1553de62d931e73443c806347cd974
Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
Date:   Thu Jan 31 17:35:05 2008 -0800

    ACPI: cpuidle: Support C1 idle time accounting
    
    Show C1 idle time in /sysfs cpuidle interface. C1 idle time may not
    be entirely accurate in all cases. It includes the time spent
    in the interrupt handler after wakeup with "hlt" based C1. But, it will
    be accurate with "mwait" based C1.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bc71bec91f9875ef825d12104acf3bf4ca215fa4
Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
Date:   Thu Jan 31 17:35:04 2008 -0800

    ACPI: enable MWAIT for C1 idle
    
    Add MWAIT idle for C1 state instead of halt, on platforms that support
    C1 state with MWAIT.
    
    Renames cx->space_id to something more appropriate.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2e906655baf1c6f6fccd212fc9e6499dc6928b80
Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
Date:   Thu Jan 31 17:35:03 2008 -0800

    ACPI: idle: Fix acpi_safe_halt usages and interrupt enabling/disabling
    
    acpi_safe_halt() needs interrupts to be disabled for atomic
    need_resched check and safe halt. Otherwise we may miss an
    interrupt and go into halt.
    
    acpi_safe_halt() also does not enable interrupts on all return paths.
    
    So the callers should handle enable and disable interrupts around it.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 23b168d425ca0ca25257ff8205a39f1c2d1b0f27
Author: Pavel Machek <pavel@ucw.cz>
Date:   Tue Feb 5 19:27:12 2008 +0100

    PM: documentation cleanups
    
    Signed-off-by: Pavel Machek <pavel@suse.cz>
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 547266e46cc0b35ce51bd1f37f261d831927431f
Author: Roel Kluin <12o3l@tiscali.nl>
Date:   Tue Feb 5 00:24:56 2008 +0100

    ACPI: thinkpad-acpi: second TP_EC_FAN_FULLSPEED should be TP_EC_FAN_AUTO
    
    fix bug in safety net for TPEC fan control mode
    eaa7571b2d1a08873e4bdd8e6db3431df61cd9ad
    
    Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
    Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 443dea72d5f428170de6d6e3c4c1a1e2b7632b65
Author: Thomas Renninger <trenn@suse.de>
Date:   Mon Feb 4 23:31:23 2008 -0800

    ACPI: Export acpi_check_resource_conflict
    
    Export acpi_check_resource_conflict(), sometimes drivers already have
    a struct resource at hand so no need to use the wrappers to build a new
    one.
    
    Signed-off-by: Jean Delvare <jdelvare@suse.de>
    Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
    Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit df92e695998e1bc6e426a840eb86d6d1ee87e2a5
Author: Thomas Renninger <trenn@suse.de>
Date:   Mon Feb 4 23:31:22 2008 -0800

    ACPI: track opregion names to avoid driver resource conflicts.
    
    Small ACPICA extension to be able to store the name of operation regions in osl.c later
    
    In ACPI, AML can define accesses to IO ports and System Memory by Operation
    Regions.  Those are not registered as done by PNPACPI using resource templates
    (and _CRS/_SRS methods).
    
    The IO ports and System Memory regions may get accessed by arbitrary AML code.
     When native drivers are accessing the same resources bad things can happen
    (e.g.  a critical shutdown temperature of 3000 C every 2 months or so).
    
    It is not really possible to register the operation regions via
    request_resource, as they often overlap with pnp or other resources (e.g.
    statically setup IO resources below 0x100).
    
    This approach stores all Operation Region declarations (IO and System Memory
    only) at ACPI table parse time.  It offers a similar functionality like
    request_region and let drivers which are known to possibly use the same IO
    ports and Memory which are also often used by ACPI (hwmon and i2c) check for
    ACPI interference.
    
    A boot parameter acpi_enforce_resources=strict/lax/no is provided, which
    is default set to lax:
      - strict: let conflicting drivers fail to load with an error message
      - lax:    let conflicting driver work normal with a warning message
      - no:     no functional change at all
    Depending on the feedback and the kind of interferences we see, this
    should be set to strict at later time.
    
    Goal of this patch set is:
      - Identify ACPI interferences in bug reports (very hard to reproduce
        and to identify)
      - Find BIOSes for that an ACPI driver should exist for specific HW
        instead of a native one.
      - stability in general
    
    Provide acpi_check_{mem_}region.
    
    Drivers can additionally check against possible ACPI interference by also
    invoking this shortly before they call request_region.
    If -EBUSY is returned, the driver must not load.
    Use acpi_enforce_resources=strict/lax/no options to:
      - strict: let conflicting drivers fail to load with an error message
      - lax:    let conflicting driver work normal with a warning message
      - no:     no functional change at all
    
    Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
    Cc: Jean Delvare <khali@linux-fr.org>
    Cc: Len Brown <lenb@kernel.org>
    Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1a3b77ae60f19fa85f4cdc34b6c09efb1a18372c
Author: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Date:   Mon Feb 4 23:31:20 2008 -0800

    ACPI: acpi_pci_irq_find_prt_entry(): use list_for_each_entry() instead of list_for_each()
    
    Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e76d5f7e831a3f33dd6fa8eb94533b0b4cb22b6f
Author: Miguel Botón <mboton@gmail.com>
Date:   Mon Feb 4 23:31:19 2008 -0800

    ACPI: remove duplicated warning message
    
    Remove duplicated warning message in acpi_power_transition()
    
    ACPI: Transitioning device [%s] to D%d\n
    
    This warning message is printed by acpi_bus_set_power() so we don't
    need to print it again.
    
    Signed-off-by: Miguel Botón <mboton@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 31e0729a85c1e8ffaf4d14b4c201c28b5d1c9585
Author: Luca Tettamanti <kronos.it@gmail.com>
Date:   Mon Feb 4 23:31:18 2008 -0800

    asus_acpi: add support for F3Sa
    
    Add support for ASUS F3Sa notebook. Features:
    - LCD on/off
    - Brightness
    - Wifi kill
    - Bluetooth kill
    
    Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
    Cc: Corentin Chary <corentincj@iksaif.net>
    Cc: Karol Kozimor <sziwan@users.sourceforge.net>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e1af14e4b3d5f2a348987e3069ec835b782782b0
Author: Roel Kluin <12o3l@tiscali.nl>
Date:   Sat Feb 2 21:07:38 2008 +0100

    asus-laptop: add parentheses
    
    '!' has a higher priority than '&': bitanding has no effect.
    
    Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f8d1c94b346b62747322728e00e11f552cd90902
Author: Corentin CHARY <corentincj@iksaif.net>
Date:   Wed Jan 16 16:56:42 2008 +0100

    asus-laptop new write_acpi_int
    
    Just a little modification of write_acpi_int
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5229e87d59cef33539322948bd8e3b5a537f7c97
Author: Len Brown <len.brown@intel.com>
Date:   Wed Feb 6 01:26:55 2008 -0500

    ACPI: create /sys/firmware/acpi/interrupts
    
    See Documentation/ABI/testing/sysfs-firmware-acpi
    
    Based-on-original-patch-by: Luming Yu <luming.yu@intel.com>
    Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6ed31e92e94830c138fbd470486383380710069a
Author: Éric Piel <Eric.Piel@tremplin-utc.net>
Date:   Tue Feb 5 00:04:50 2008 +0100

    ACPI: Taint kernel on ACPI table override (format corrected)
    
    When an ACPI table is overridden (for now this can happen only for DSDT)
    display a big warning and taint the kernel with flag A.
    
    Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 71fc47a9adf8ee89e5c96a47222915c5485ac437
Author: Markus Gaugusch <dsdt@gaugusch.at>
Date:   Tue Feb 5 00:04:06 2008 +0100

    ACPI: basic initramfs DSDT override support
    
    The basics of DSDT from initramfs. In case this option is selected,
    populate_rootfs() is called a bit earlier to have the initramfs content
    available during ACPI initialization.
    
    This is a very similar path to the one available at
    http://gaugusch.at/kernel.shtml but with some update in the
    documentation, default set to No and the change of populate_rootfs() the
    "Jeff Mahony way" (which avoids reading the initramfs twice).
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7c2670bbb53820d0a4fab8d74593eeccd1eef225
Author: maximilian attems <max@stro.at>
Date:   Tue Jan 22 18:46:50 2008 +0100

    ACPI: battery: add sysfs serial number
    
    egrep serial /proc/acpi/battery/BAT0/info
    serial number:           32090
    
    serial number can tell you from the imminent danger
    of beeing set on fire.
    
    Signed-off-by: maximilian attems <max@stro.at>
    Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit dd8cd7793781c87be47bbfee65efa3fb5110f898
Author: Carlos Corbacho <carlos@strangeworlds.co.uk>
Date:   Tue Feb 5 02:17:15 2008 +0000

    tc1100-wmi: Add driver for HP Compaq TC1100 Tablets
    
    This is based on the 2004 out-of-tree work of Jamey Hicks, to add
    support via WMI for controlling the jog dial and wireless on these
    tablets.
    
    v1:
    
    Original release
    
    v2:
    
    As per Joshua Wise's comments, change bluetooth to jogdial (an error from
    the original driver).
    
    Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    CC: Matthew Garrett <mjg59@srcf.ucam.org>
    CC: Jamey Hicks <jamey.hicks@nokia.com>
    CC: Joshua Wise <joshua@joshuawise.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 745a5d2126926808295742932d0e36d485efa485
Author: Carlos Corbacho <carlos@strangeworlds.co.uk>
Date:   Tue Feb 5 02:17:10 2008 +0000

    acer-wmi: Add driver for newer Acer laptops
    
    This is a driver for newer Acer (and Wistron) laptops. It adds wireless
    radio and bluetooth control, and on some laptops, exposes the mail LED and
    LCD backlight.
    
    v1:
    
    * Initial release
    
    v2:
    
    * Replace left over ACPI references with WMI
    * Add GUID based autoloading (depends on future work to WMI)
    * Add DMI based autoloading (backup solution until WMI sysfs/ class
      work is available)
    * Checkpatch fixes
    
    v3:
    
    * Add new EC quirks for Aspire 3100 & 5100, and Extensa 5220
    
    v4:
    
    * Simplified internal handling of WMID and AMW0 devices
    * Add autodetection for bluetooth and maximum brightness on AMW0 V2 and
      WMID laptops.
    
    v5:
    
    * Add EC quirk for Medion MD 98000
    * Add autodetection for AMW0, and mail LED on AMW0 and AMW0 V2.
    * Improve error handling
    * Fix AMW0 V2 bluetooth and wireless, by using both WMID and AMW0 methods
      to ensure that the correct value is always set.
    
    v6:
    
    * Fix 'use before initialisation' bug with quirks.
    
    v7
    
    * Fix bug on AMW0 where acer-wmi would exit if a mail LED was not
      detected.
    * Add Acer Aspire 9110 mail LED support
    * Fix section mismatch warnings
    
    Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    CC: Matthew Garrett <mjg59@srcf.ucam.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bff431e49ff531a343fbb2b4426e313000844f32
Author: Carlos Corbacho <carlos@strangeworlds.co.uk>
Date:   Tue Feb 5 02:17:04 2008 +0000

    ACPI: WMI: Add ACPI-WMI mapping driver
    
    The following is an implementation of the Windows Management
    Instrumentation (WMI) ACPI interface mapper (PNP0C14).
    
    What it does:
    
    Parses the _WDG method and exports functions to process WMI method calls,
    data block query/ set commands (both based on GUID) and does basic event
    handling.
    
    How: WMI presents an in kernel interface here (essentially, a minimal
    wrapper around ACPI)
    
    (const char *guid assume the 36 character ASCII representation of
    a GUID - e.g. 67C3371D-95A3-4C37-BB61-DD47B491DAAB)
    
    wmi_evaluate_method(const char *guid, u8 instance, u32 method_id,
    const struct acpi_buffer *in, struct acpi_buffer *out)
    
    wmi_query_block(const char *guid, u8 instance,
    struct acpi_buffer *out)
    
    wmi_set_block(const char *guid, u38 instance,
    const struct acpi_buffer *in)
    
    wmi_install_notify_handler(acpi_notify_handler handler);
    
    wmi_remove_notify_handler(void);
    
    wmi_get_event_data(u32 event, struct acpi_buffer *out)
    
    wmi_has_guid(const char guid*)
    
    wmi_has_guid() is a helper function to find if a GUID exists or not on the
    system (a quick and easy way for WMI dependant drivers to see if the
    the method/ block they want exists, since GUIDs are supposed to be unique).
    
    Event handling - allow a WMI based driver to register a notifier handler
    for each GUID with WMI. When a notification is sent to a GUID in WMI, the
    handler registered with WMI is then called (it is left to the caller to
    ask for the WMI event data associated with the GUID, if needed).
    
    What it won't do:
    
    Unicode - The MS article[1] calls for converting between ASCII and Unicode (or
    vice versa) if a GUID is marked as "string". This is left up to the calling
    driver.
    
    Handle a MOF[1] - the WMI mapper just exports methods, data and events to
    userspace. MOF handling is down to userspace.
    
    Userspace interface - this will be added later.
    
    [1] http://www.microsoft.com/whdc/system/pnppwr/wmi/wmi-acpi.mspx
    
    ===
    ChangeLog
    ==
    
    v1 (2007-10-02):
    
    * Initial release
    
    v2 (2007-10-05):
    
    * Cleaned up code - split up super "wmi_evaluate_block" -> each external
      symbol now handles its own ACPI calls, rather than handing off to
      a "super" method (and in turn, is a lot simpler to read)
    * Added a find_guid() symbol - return true if a given GUID exists on
      the system
    * wmi_* functions now return type acpi_status (since they are just
      fancy wrappers around acpi_evaluate_object())
    * Removed extra debug code
    
    v3 (2007-10-27)
    
    * More code clean up - now passes checkpatch.pl
    * Change data block calls - ref MS spec, method ID is not required for
      them, so drop it from the function parameters.
    * Const'ify guid in the function call parameters.
    * Fix _WDG buffer handling - copy the data to our own private structure.
    * Change WMI from tristate to bool - otherwise the external functions are
      not exported in linux/acpi.h if you try to build WMI as a module.
    * Fix more flag comparisons.
    * Add a maintainers entry - since I wrote this, I should take the blame
      for it.
    
    v4 (2007-10-30)
    
    * Add missing brace from after fixing checkpatch errors.
    * Rewrote event handling - allow external drivers to register with WMI to
      handle WMI events
    * Clean up flags and sanitise flag handling
    
    v5 (2007-11-03)
    
    * Add sysfs interface for userspace. Export events over netlink again.
    * Remove module left overs, fully convert to built-in driver.
    * Tweak in-kernel API to use u8 for instance, since this is what the GUID
      blocks use (so instance cannot be greater than u8).
    * Export wmi_get_event_data() for in kernel WMI drivers.
    
    v6 (2007-11-07)
    
    * Split out userspace into a different patch
    
    v7 (2007-11-20)
    
    * Fix driver to handle multiple PNP0C14 devices - store all GUIDs using
      the kernel's built in list functions, and just keep adding to the list
      every time we handle a PNP0C14 devices - GUIDs will always be unique,
      and WMI callers do not know or care about different devices.
    * Change WMI event handler registration to use its' own event handling
      struct; we should not pass an acpi_handle down to any WMI based drivers
      - they should be able to function with only the calls provided in WMI.
    * Update my e-mail address
    
    v8 (2007-11-28)
    
    * Convert back to a module.
    * Update Kconfig to default to building as a module.
    * Remove an erroneous printk.
    * Simply comments for string flag (since we now leave the handling to the
      caller).
    
    v9 (2007-12-07)
    
    * Add back missing MODULE_DEVICE_TABLE for autoloading
    * Checkpatch fixes
    
    v10 (2007-12-12)
    
    * Workaround broken GUIDs declared expensive without a WCxx method.
    * Minor cleanups
    
    v11 (2007-12-17)
    
    * More fixing for broken GUIDs declared expensive without a WCxx method.
    * Add basic EmbeddedControl region handling.
    
    v12 (2007-12-18)
    
    * Changed EC region handling code, as per Alexey's comments.
    
    v13 (2007-12-27)
    
    * Changed event handling so that we can have one event handler registered
      per GUID, as per Matthew Garrett's suggestion.
    
    v14 (2008-01-12)
    
    * Remove ACPI debug statements
    
    v15 (2008-02-01)
    
    * Replace two remaining 'x == NULL' type tests with '!x'
    
    v16 (2008-02-05)
    
    * Change MAINTAINERS entry, as I am not, and never have been, paid to work
      on WMI
    * Remove 'default' line from Kconfig
    
    Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    CC: Matthew Garrett <mjg59@srcf.ucam.org>
    CC: Alexey Starikovskiy <aystarik@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a64217b922e5a06f328e3962ff903ce829aff3d6
Author: Len Brown <len.brown@intel.com>
Date:   Mon Feb 4 00:57:33 2008 -0500

    ACPI: blacklist update
    
    move some OSI(Linux) to "disable" from "unknown"
    to reduce dmesg lines that we don't really need.
    
    update Acer 5315 comment
    update Dell entries, add R200 entry
    update Apple entries
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1d15d84e8b443971cafd885d18f091814ba32cb7
Author: Adrian Bunk <bunk@kernel.org>
Date:   Tue Jan 29 00:10:15 2008 +0200

    ACPI: make struct osi_linux static
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 12d3931c1007a7ad47364a4884e5a6c6e25aa5e1
Author: Adrian Bunk <bunk@kernel.org>
Date:   Tue Jan 29 00:10:12 2008 +0200

    ACPI: make acpi_dmi_dump() static
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d0280a02f7412f3fdd45fbd2f51f59d7d8a03fe8
Author: Len Brown <len.brown@intel.com>
Date:   Sun Feb 3 17:32:31 2008 -0500

    ACPI: update blacklist comments
    
    ...based on additional feedback -- no code change.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e6298c6d60838495978cdbe5555dc290785bb961
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 25 15:40:02 2008 -0500

    DMI: remove duplicate helper routine
    
    Use existing dmi_get_system_info(),
    Delete duplicate dmi_get_slot()
    
    Spotted-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8964ebb8c35533f4084cc667079a0ce620356104
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 25 15:39:50 2008 -0500

    ACPI: remove redundant Acer blacklist entry
    
    dmi_check_system() does sub-string matching using strstr(),
    rather than exact string compares with !strcmp().
    
    So delete the longer of the Acer blacklist entries, as its
    function is just a redundant console message.
    
    Spotted-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3c602840528cf1aa835e6e32d76a0a45936b8e4c
Author: Len Brown <len.brown@intel.com>
Date:   Sat Feb 2 04:05:54 2008 -0500

    ACPI: fan: build fix for CONFIG_ACPI_PROCFS=n
    
    drivers/acpi/fan.c:340: error: ‘acpi_fan_dir’ undeclared (first use in this function)
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3391a76f2bbb74e42b9ba44c05a7366ffd388753
Author: Len Brown <len.brown@intel.com>
Date:   Sat Feb 2 03:56:18 2008 -0500

    ACPI: throttling: fix build warning
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 33a2a529f7a2fb481812b99737176628fda457b0
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Mon Jan 28 13:55:56 2008 +0800

    ACPI: Update the t-state for every affected cpu when t-state is changed
    
    According to ACPI spec, the _TSD object provides T-state control cross
    logical processor dependency information to OSPM. So the t-state
    coordination should be considered when T-state for one cpu is changed.
    
    According to ACPI spec, three types of coordination are defined.
    SW_ALL, SW_ANY and HW_ALL.
    
    SW_ALL: it means that OSPM needs to initiate T-state transition on
    all processors in the domain. It is necessary to call throttling set function
    for all affected cpus.
    
    SW_ANY: it means that OSPM may initiate T-state transition on any processor in
    the domain.
    
    HW_ALL: Spec only says that hardware will perform the coordination and doesn't
    recommend how OSPM coordinate T-state among the affected cpus. So it is treated
    as the type of SW_ALL. It means that OSPM needs to initiate t-state transition
    on all the processors in the domain.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e4aa5cb2138e7423a6edef6a76a3837b94c2f107
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Mon Jan 28 13:54:46 2008 +0800

    ACPI : Add T-state event notifier function
    
    The t-state coordination should be considered when T-state for one cpu
    is changed.It means that OSPM should select one proper target T-state for
    the all affected cpus before updating T-state.
    
    So the function of acpi_processor_throttling_notifier is added.
    Before updating T-state it can be called for all  the affected cpus to get
    the proper target T-state, which can meet the requirement of thermal, user and
    _TPC. After updating T-state, it can be called to update T-state flag.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1180509f6b3ec3ac2505375a78ccd72d270f2169
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Mon Jan 28 13:53:42 2008 +0800

    ACPI : Update T-state coordination after getting _TSD info
    
    Accordint to ACPI spec, the _TSD object provides T-state control cross
    logical processor dependency information to OSPM.
    After the _TSD data for all cpus are obtained, OSPM will set up
    the T-state coordination between CPUs.
    
    Of course if the _TSD doesn't exist or _TSD data is incorrect , it is
    assumed that there is no T-state coordination and T-state is changed
    independently.
    
    Now there is no proper solution to update T-state coordination after
    one cpu is hotplugged. So this patch won't support hotplugged cpu very well.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 87654273ef63213f90c4243913987436495824f0
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Mon Jan 28 13:53:30 2008 +0800

    ACPI : Check parameter when calling acpi_processor_get/set_throttling
    
    It is necessary to check the parameter when calling the function of
    acpi_processor_get/set_throttling function so as to avoid the NULL
    pointer reference in pr or throttling.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9747
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3abbd337c60591305cbfeb984ff2922c175be37f
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Mon Jan 28 13:53:21 2008 +0800

    ACPI: Set _PSD ACPI_PDC_SMP_T_SWCOORD
    
    The ACPI_PDC_SMP_T_SWCOORD bit is set by and OS that is capable of
    native ACPI throttling software coordination for mutli-processors
    using the _TSD information.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0119509c4fbc9adcef1472817fda295334612976
Author: Matthew Garrett <mjg59@srcf.ucam.org>
Date:   Thu Jan 17 03:39:36 2008 +0000

    ACPI: video: Ignore devices that aren't present in hardware
    
    Vendors often ship machines with a choice of integrated or discrete
    graphics, and use the same DSDT for both. As a result, the ACPI video
    module will locate devices that may not exist on this specific platform.
    Attempt to determine whether the device exists or not, and abort the
    device creation if it doesn't.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9614
    
    Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 653a00c9662304ef72a3eb4e681c91720960e0b4
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Jan 17 15:51:18 2008 +0800

    ACPI: thermal fixup
    
    The alias name may be used in _PSL, _ALx and _TZD,
    so we bind the cooling device only if the acpi_device node matches.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cc0573b3250214034062ddf8c64359596d8af521
Author: Thomas Sujith <sujith.thomas@intel.com>
Date:   Fri Jan 25 11:45:44 2008 +0800

    intel_menlo: introduce new platform specific driver
    
    Intel menlow platform specific driver for thermal management extension.
    
    Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 041d4bbf128f645fe53bb22309efb9db14dbf5b5
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Jan 17 15:51:19 2008 +0800

    ACPI: CELSIUS_TO_KELVIN fixup
    
    Fix an imprecision in CELSIUS_TO_KELVIN and move these
    two macroes to a proper place.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 207339398ecb0835331c748612898dad2a09fdec
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Jan 17 15:51:21 2008 +0800

    ACPI: attach thermal zone info
    
    Intel menlow driver needs to get the pointer of themal_zone_device
    structure of an ACPI thermal zone.
    Attach this to each ACPI thermal zone device object.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 702ed512de9c8a67a69a981c73b7337c2131f198
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Jan 17 15:51:22 2008 +0800

    ACPI: register ACPI Video LCD as generic thermal cooling device
    
    Register ACPI video device as thermal cooling devices as they may be listed
    in _TZD method and the backlight control can be used for throttling.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d9460fd227ed2ce52941b6a12ad4de05c195f6aa
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Jan 17 15:51:23 2008 +0800

    ACPI: register ACPI Processor as generic thermal cooling device
    
    Register ACPI processor as thermal cooling devices.
    A combination of processor T-state and P-state are used for thermal throttling.
    the processor will reduce the frequency first and then set the T-state.
    
    we use cpufreq_thermal_reduction_pctg to calculate the cpufreq limit,
    and call cpufreq_verify_with_limit to set the cpufreq limit.
    if cpufreq driver is loaded, then we have four cooling state for cpufreq control.
    cooling state 0: cpufreq limit == max_freq
    cooling state 1: cpufreq limit == max_freq * 80%
    cooling state 2: cpufreq limit == max_freq * 60%
    cooling state 3: cpufreq limit == max_freq * 40%
    
    after the cpufreq limit is set to 40 percentage of the max_freq,
    we use T-state for cooling.
    
    eg. a processor has P-state support, and it has 8 T-state (T0-T7),
    the max_state of the proceesor is 10:
    
    state	cpufreq-limit  T-state
    0:	max_freq	T0
    1:	max_freq * 80%	T0
    2:	max_freq * 60%	T0
    3:	max_freq * 40%	T0
    4:	max_freq * 40%	T1
    5:	max_freq * 40%	T2
    6:	max_freq * 40%	T3
    7:	max_freq * 40%	T4
    8:	max_freq * 40%	T5
    9:	max_freq * 40%	T6
    10:	max_freq * 40%	T7
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 05a83d972293f39a66bc2aa409a5e7996bba585d
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Jan 17 15:51:24 2008 +0800

    ACPI: register ACPI Fan as generic thermal cooling device
    
    Register ACPI Fan as thermal cooling device.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ce44e19701ac1de004815c225585ff617c5948b4
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Jan 17 15:51:25 2008 +0800

    ACPI: ACPI thermal zone handle notification correctly
    
    Change the ACPI thermal action upon notification 0x81 and 0x82.
    
    According to the ACPI spec, we should:
    re-evaluate _PSV and _ACx methods upon notification 0x81
    re-evaluate _PSL and _ALx and _TZD upon notificaiton 0x82.
    But the current code re-evaluates all the trip points for 0x81 while
    only re-evaluates _TZD for 0x82.
    
    Fix this violation of ACPI spec.
    
    TODO: devices in _PSL, _ALx and _TZD may change after a notification 0x82.
          At this time, we need to re-bind the cooling devices with the thermal zone.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3f655ef8c439e0775ffb7d1ead5d1d4f060e1f8b
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Jan 17 15:51:11 2008 +0800

    ACPI: register ACPI thermal zone as generic thermal zone devices
    
    Register ACPI thermal zone as thermal zone device.
    
    the new sys I/F for ACPI thermal zone will be like this:
    
    /sys/class/thermal:
    |thermal_zone1:
    	|-----type:			"ACPI thermal zone". RO
    	|-----temp:			the current temperature. RO
    	|-----mode:			the current working mode. RW.
    					the default value is "kernel"  which means  thermal
    					management is done by ACPI thermal driver.
    					"echo user > mode" prevents all the ACPI thermal driver
    					actions upon any trip points.
    	|-----trip_point_0_temp:	the threshold of trip point 0. RO.
    	|-----trip_point_0_type:	"critical". RO.
    					the type of trip point 0
    					This may be one of critical/hot/passive/active[x]
    					for an ACPI thermal zone.
    	...
    	|-----trip_point_3_temp:
    	|-----trip_point_3_type:	"active[1]"
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 203d3d4aa482339b4816f131f713e1b8ee37f6dd
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Jan 17 15:51:08 2008 +0800

    the generic thermal sysfs driver
    
    The Generic Thermal sysfs driver for thermal management.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 38531e6fe51ad5c7dfe72e0e066b5f54bc1921cd
Author: Matthew Garrett <mjg59@srcf.ucam.org>
Date:   Wed Dec 26 02:03:26 2007 +0000

    ACPI: video: Rationalise ACPI backlight implementation
    
    The sysfs backlight class provides no mechanism for querying the
    acceptable brightness for a backlight. The ACPI spec states that values
    are only valid if they are reported as available by the firmware. Since
    we can't provide that information to userspace, instead collapse the
    range to the number of actual values that can be set.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9277
    
    Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1cee5cce9776d88778b6c00e3f72fffbcbec40d4
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Jan 8 13:02:57 2008 -0200

    ACPI: thinkpad-acpi: bump up version to 0.19
    
    The major code reorganization and cleanups, and new HKEY events, plus
    poll()/select() support are good reasons to checkpoint a new version...
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6a2e293c34a41446c091cb18758cf64117021b72
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Jan 8 13:02:56 2008 -0200

    ACPI: thinkpad-acpi: update copyright dates to 2008
    
    Update the copyright headers to include 2008.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 50ebec09f1a79df27afeceb14a3059944f327e1d
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Jan 8 13:02:55 2008 -0200

    ACPI: thinkpad-acpi: add poll() support to some sysfs attributes
    
    Implement poll()/select() support through sysfs_notify() for some key
    attributes which userspace might want to poll() or select() on.
    
    In order to let userspace know poll()/select() support is available for an
    attribute, the thinkpad-acpi sysfs interface version is also bumped up.
    Further changes that add poll()/select() capabilities to any pre-existing
    attributes will also increment the sysfs interface version.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 013c40e457ac573b29daa0e369c2ba6729c23557
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Jan 8 13:02:54 2008 -0200

    ACPI: thinkpad-acpi: silence _sta warning
    
    When both CONFIG_THINKPAD_ACPI_DOCK and CONFIG_THINKPAD_ACPI_BAY are
    undefined, _sta is not used and that causes a gcc warning.  Fix it
    (and I think this is a regression, I am pretty sure I fixed this once
    before, sorry about that).
    
    Issue reported by: Pritt Laes.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Pritt Laes <plaes@plaes.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d1edb2b5f1d016d679600cccf2716e0134fff917
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Jan 8 13:02:53 2008 -0200

    ACPI: thinkpad-acpi: add X61t HKEY events
    
    Tomas Carnecky reports that events 0x5009 and 0x500a are swivel events, and
    that 0x500b/0x500c are tablet pen storage bay events.
    
    Document these events, and avoid nasty messages when they happen.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a713b4d7bca51e56cdb5357507f46674111d032c
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Jan 8 13:02:52 2008 -0200

    ACPI: thinkpad-acpi: wakeup on hotunplug reporting
    
    Handle some HKEY events that the firmware uses to report the reason for a
    wake up, and to also notify that the system could go back to sleep (if it
    woke up just to eject something from the bay, or to undock).
    
    The driver will report the reason of the last wake up in the sysfs
    attribute "wakeup_reason": 0 for "none, unknown, or standard ACPI wake up
    event", 1 for "bay ejection request" and 2 for "undock request".
    
    The firmware will also report if the operation that triggered the wake up
    has been completed, by issuing an HKEY 0x3003 or 0x4003 event.  If the
    operation fails, no event is sent.  When such a hotunplug sucessfull
    notification is issued, the driver sets the attribute
    "wakeup_hotunplug_complete" to 1.
    
    While the firmware does tell us whether we are waking from a suspend or
    hibernation scenario, the Linux way of hibernating makes this information
    not reliable, and therefore it is not reported.
    
    The idea is that if any of these attributes are non-zero, userspace might
    want to do something at the end of the "wake up from sleep" procedures,
    such as offering to send the machine back into sleep as soon as it is safe
    to do so.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3b64b51d20d9b633bb2efe63af785a49f8092898
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Jan 8 13:02:51 2008 -0200

    ACPI: thinkpad-acpi: cleanup hotkey_notify and HKEY log messages
    
    Use a generic message on hotkey_notify to log unknown and unhandled events,
    and cleanup hotkey_notify a little.
    
    Also, document event 0x5010 (brightness changed notification) and do not
    log it as an unknown event (even if we do not use it for anything right
    now).
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 083f17606f624c79555e313d87cf37ac1486b073
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Jan 8 13:02:50 2008 -0200

    ACPI: thinkpad-acpi: add suspend handler
    
    Add a handler for suspend events.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 35ff8b9fa90d97f3a19ea3e2311385927535ebc9
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Jan 8 13:02:49 2008 -0200

    ACPI: thinkpad-acpi: some checkpatch.pl fluff
    
    Fix some of the crap reported by checkpatch.pl.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e0c7dfe70170ccee2b538494f92e61de8edab990
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Jan 8 13:02:48 2008 -0200

    ACPI: thinkpad-acpi: rename IBM in defines
    
    Rename defines with IBM in their name that are related to the older
    driver name (ibm-acpi) to TPACPI, unless they are specific to IBM
    ThinkPads.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f68080f86d8b43bf3ff4c309f1bc9aa4d3fdf735
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Jan 8 13:02:47 2008 -0200

    ACPI: thinkpad-acpi: module glue cleanups
    
    General cleanup of module glue: Do some code reordering, and add
    missing parameter help text.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4b45cc076bc1964352f4a603a18c511ac182b98f
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Jan 8 13:02:46 2008 -0200

    ACPI: thinkpad-acpi: spring cleanup part 4
    
    Remove dead code, and anything in the old changelog that is not a thank
    you credit, or a key point to track down history.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b21a15f6d065e837076cf417720afe1c3d6ed10d
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Jan 8 13:02:45 2008 -0200

    ACPI: thinkpad-acpi: spring cleanup part 3
    
    Reorder code in the file to get rid of more of the forward declarations,
    and to make things cleaner and more organized.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f74a27d4bda42ee779940adaa34c5c196dda5d32
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Jan 8 13:02:44 2008 -0200

    ACPI: thinkpad-acpi: spring cleanup part 2
    
    Move most subdriver-related stuff imported from the header file closer to
    their subdriver code.  Also, delete unneeded forward declarations.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0c78039fcdb0806fafcc40400ace7fb7e81c65a5
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Jan 8 13:02:43 2008 -0200

    ACPI: thinkpad-acpi: spring cleanup part 1
    
    Remove the header file.  Private header files used by a single .c file are
    in bad taste, and I know better now.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 50efd8310f4f532231b15c6bcb9007c99ac05466
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Jan 8 13:02:42 2008 -0200

    ACPI: thinkpad-acpi: bump up version to 0.18
    
    The NVRAM polling support for hot keys is reason enough to
    bump up the version string.  Do it.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 01e88f25985d8ea5866c9a73d56b3a9a9145066f
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Jan 8 13:02:41 2008 -0200

    ACPI: thinkpad-acpi: add CMOS NVRAM polling for hot keys (v9)
    
    Older ThinkPad models do not export some of the hot keys over the
    event-based ACPI hot key interface.  For these models, one has to poll
    the CMOS NVRAM to check the key state at a rate faster than the expected
    rate at which the user might repeatedly press the same hot key.
    
    This patch implements this functionality for many of the hotkeys in a
    transparent way: hot keys will now Just Work, and the driver knows the
    best approach (events or NVRAM polling) to employ, based on the
    HKEY.MHKA ACPI method.
    
    Also, the driver can turn off the polling when there are no users for
    the hot keys that need such polling.
    
    The NVRAM-based hot keys of the A3x series that have never been
    implemented by later models are not supported, to avoid changes in the
    keymap of the input devices that could cause headaches in the future.
    
    There is a Kconfig option to avoid compiling the NVRAM polling code, as
    it is not very small, and unlikely to be useful on any ThinkPad newer
    than a T40, X31 or R52.
    
    This feature is based on a previous effort by Richard Hughes.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Richard Hughes <hughsient@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b7c8c200bfbf523ea0a72fd8a5e39089c74da371
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Jan 8 13:02:40 2008 -0200

    ACPI: thinkpad-acpi: prepare for NVRAM polling support
    
    Make some small internal thinkpad-acpi changes to the hotkey subdriver code
    that will make it easier to add NVRAM polling support.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b2c985e7eba858a1765db6d56bdd4df775f53633
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Jan 8 13:02:39 2008 -0200

    ACPI: thinkpad-acpi: refactor hotkey_get and hotkey_set (v2)
    
    Refactor and organize the code a bit for the NVRAM polling support:
    
    1. Split hotkey_get/set into hotkey_status_get/set and hotkey_mask_get/set;
    2. Cache the status of hot key mask for later driver use;
    3. Make sure the cache of hot key mask is refreshed when needed;
    4. log a printk notice when the firmware doesn't set the hot key
       mask to exactly what we asked it to;
    5. Add proper locking to the data structures.
    
    Only (4) should be user-noticeable, but there is a chance (5) fixes
    some unknown/unreported race conditions.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0f089147e620e083f58a0e641f701bd4244b455b
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Jan 8 13:02:38 2008 -0200

    ACPI: thinkpad-acpi: document keymap gotcha's (v2)
    
    Publish the requirements for keymap changes.  This is a documentation
    change, only.
    
    Currently, people look at the thinkpad-acpi default keymaps, and think:
    "modifying this is a trivial thing, it can't break systems, and there are
    keys defined for foo and bar, but the driver has them as KEY_RESERVED.
    Must have been an oversight, let me change it."
    
    And since they never get to see the bug reports, because they are not
    really a part of the Linux ThinkPad users community (linux-thinkpad
    mailinglist, thinkwiki wiki, thinkpad forums) and laptop users are slow
    to complain to distros about any breakages...
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f757397097d0713c949af76dccabb65a2785782e
Author: Kevin Hilman <khilman@mvista.com>
Date:   Thu Jan 31 17:28:18 2008 -0800

    cpuidle: build fix for non-x86
    
    Convert cpu_idle_wait() to cpuidle_kick_cpus() macro which is
    SMP-only, and gives error on non supported CPU.
    
    Signed-off-by: Kevin Hilman <khilman@mvista.com>
    Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fccd5d00ba68455425a35f905fd92538429c310d
Author: Mattia Dongili <malattia@linux.it>
Date:   Mon Jan 14 18:05:46 2008 +0900

    sony-laptop: fix scancode decode
    
    compare against the sony_laptop specific event list index
    to decode the input scancode to send.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3eb8749a37990b505ab94466038c067444bbd7eb
Author: Mattia Dongili <malattia@linux.it>
Date:   Mon Jan 14 18:05:45 2008 +0900

    sony-laptop: add Type4 model
    
    Recent Vaio models (UX, SZ and presumably TZ and others) add more
    events and a slightly different handling of Fn key events for
    additional hotkeys (s1, s2, zoom-in/out, etc.).
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 425ef5d75de25c53b6dc79008fe3678d2fe7e8ed
Author: Mattia Dongili <malattia@linux.it>
Date:   Mon Jan 14 18:05:44 2008 +0900

    sony-laptop: bump version to 0.6
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit de9204300112dea10ca3d3cc76858cee61043e47
Author: Mattia Dongili <malattia@linux.it>
Date:   Mon Jan 14 18:05:43 2008 +0900

    sony-laptop: refactor model types
    
    Create mini drivers and allow callbacks for each model
    to be specified.
    Following patches will make use of this feature to handle
    specific cases instead of just executing code and hope
    not to break other models.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 88877c2a2ebd0e554496efb23e7dc8ade661d289
Author: Mattia Dongili <malattia@linux.it>
Date:   Mon Jan 14 18:05:42 2008 +0900

    sony-laptop: Add Vaio N series to the special init sequence to enable Fn keys
    
    Also the recent Vaio N series need some more calls into the DSDT
    to enable reporting of FN key events to be delivered to the SNC device.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 75a1f9ce8f422fd32774a0674ed4386d07628d5e
Author: Mattia Dongili <malattia@linux.it>
Date:   Mon Jan 14 18:05:41 2008 +0900

    sony-laptop: printk more info in sony_pic_call[123]
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 02f8a8586574350a1f3c2cee79cbc0faf630961d
Author: Andrew Patterson <andrew.patterson@hp.com>
Date:   Tue Jan 22 17:18:22 2008 -0700

    ACPI: Check for any matching CID when walking namespace.
    
    The callback function acpi_ns_get_device_callback called from
    acpi_get_devices() will check CID's if the HID does not match.  This code
    has a bug where it requires that all CIDs match the HID. Changed the code
    so that any CID match will do.
    
    Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 856608ee5e1ea37b8976ce01ddbd19a45da88921
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Sat Jan 12 19:37:49 2008 -0500

    pnp: Failed to activate device 00:0a - Samsung P35 XVM 1600 III
    
    PNP_WRITE requires protocol supports .set. If ACPI doesn't support _SRS, .set ismeanless, so PNP_WRITE.
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 37748ebf8888aef6a252016d7c3cdc84514df051
Author: Dave Jones <davej@redhat.com>
Date:   Wed Jun 6 03:34:07 2007 -0400

    ACPI: remove P2B-S from blacklist.
    
    According to http://bugzilla.kernel.org/show_bug.cgi?id=6933
    The latest BIOS for the P2B-S works fine.
    Remove it from the blacklist.
    
    Signed-off-by: Dave Jones <davej@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ad3399c378993152f12c23304ee56d7f9108e758
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Jan 11 00:10:38 2008 +0100

    ACPI: Fix acpi_pm_device_sleep_state()
    
    Fix acpi_pm_device_sleep_state() to return the value returned
    by _SxD if the device is supposed to wake up the system from
    given sleep state and the evaluation of _SxW fails (e.g. _SxW
    is not present).
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b3b233c7d948a5f55185fb5a1b248157b948a1e5
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Fri Jan 11 02:42:57 2008 +0300

    ACPI: EC: Some hardware requires burst mode to operate properly
    
    Burst mode temporary (50 ms) locks EC to do only transactions with
    driver, without it some hardware returns abstract garbage.
    
    Reference: http://bugzilla.kernel.org/show_bug.cgi?id=9341
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3e71a87d03055de0b8c8e42aba758ee6494af083
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Fri Jan 11 02:42:51 2008 +0300

    ACPI: EC: Do the byte access with a fast path
    
    Specification allows only byte access for EC region, so
    make it separate from bug-compatible multi-byte access.
    Also do not allow return of garbage in supplied *value.
    
    Reference: http://bugzilla.kernel.org/show_bug.cgi?id=9341
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cfaf3747ff3d431fba33f75083b7f50f58ae22ff
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Wed Jan 9 02:17:47 2008 -0500

    ACPI: ACPI Exception (): AE_NOT_FOUND, Processor Device is not present
    
    ACPI Exception (acpi_processor-0677): AE_NOT_FOUND, Processor Device is not
    present [20060707]
    
    According to the ACPI spec 6.3.7,
    "If a device object (including the processor object) does not have an
    _STA object, then OSPM assumes that all of the above bits are set,
    (in other words, the device is present, enabled, shown in the UI
    and funtioning)".
    
    is_processor_present shoud return 1 if the processor device object exists
    while it doesn't have an _STA object.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=8570
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 623b78c39c4525731f852072edd742cc4fba6786
Author: Thomas Renninger <trenn@suse.de>
Date:   Fri May 18 21:59:28 2007 -0500

    ACPI: add "processor.ignore_ppc" hook to workaround BIOS _PPC weirdness
    
    There have been fixes using _PPC, which seem to unhide a problem
    on HP nx6125 (double cpufreq switch freezes the machine for
    several seconds).
    
    This one should provide a workaround for the nx6125 and for
    possible other machines that show any weird _PPC behaviour.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 975c30257e75c3d067d4858f60963b80fc6bd0e4
Author: Signed-off by Yi Yang <yi.y.yang@intel.com>
Date:   Thu Dec 27 21:50:42 2007 -0500

    ACPI: detect invalid argument written to /proc/acpi/alarm
    
    /proc/acpi/alarm can't be set correctly, here is a sample:
    
    [root@localhost /]# echo "2006 09" > /proc/acpi/alarm
    [root@localhost /]# cat /proc/acpi/alarm
    2007-12-09 09:09:09
    [root@localhost /]# echo "2006 04" > /proc/acpi/alarm
    [root@localhost /]# cat /proc/acpi/alarm
    2007-12-04 04:04:04
    [root@localhost /]#
    
    Obviously, it is wrong, it should consider it as an invalid input.
    
    after this patch:
    
    [root@localhost /]# echo "2008 09" > /proc/acpi/alarm
    -bash: echo: write error: Invalid argument
    [root@localhost /]#
    
    Signed-off-by: Yi Yang <yi.y.yang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 087980295082ccaa816330bc69c29a2ff53a244c
Author: Yi Yang <yi.y.yang@intel.com>
Date:   Thu Dec 27 22:04:26 2007 -0500

    ACPI: /proc/acpi/alarm parsing: handle large numbers properly
    
    In function acpi_system_write_alarm in file drivers/acpi/sleep/proc.c,
    big sec, min, hr, mo, day and yr are counted twice to get reasonable
    values, that is very superfluous, we can do that only once.
    
    In additon, /proc/acpi/alarm can set a related value which can be
    specified as YYYY years MM months DD days HH hours MM minutes SS
    senconds, it isn't a date, so you can specify as +0000-00-00 96:00:00
    , that means 3 days later, current code can't handle such a case.
    
    This patch removes unnecessary code and does with the aforementioned
    situation.
    
    Before applying this patch:
    
    [root@localhost /]# cat /proc/acpi/alarm
    2007-12-00 00:00:00
    [root@localhost /]# echo "0000-00-00 96:180:180" > /proc/acpi/alarm
    [root@localhost /]# cat /proc/acpi/alarm
    0007-12-02 **:**:**
    [root@localhost /]#
    
    After applying this patch:
    
    [root@localhost ~]# echo "2007-12-00 00:00:00" > /proc/acpi/alarm
    [root@localhost ~]# cat /proc/acpi/alarm
    2007-12-00 00:00:00
    [root@localhost ~]# echo "0000-00-00 96:180:180" > /proc/acpi/alarm
    [root@localhost ~]# cat /proc/acpi/alarm
    0007-12-04 03:03:00
    [root@localhost ~]#
    
    Signed-off-by: Yi Yang <yi.y.yang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 239665a3bb0a2234980f918913add31bc536cfd1
Author: Len Brown <len.brown@intel.com>
Date:   Fri Nov 23 20:08:02 2007 -0500

    ACPI: tables: complete searching upon RSDP w/ bad checksum.
    
    ACPI tables follow a tree structure in memory.
    The root of the tree is the RSDP (Root System Description Pointer).
    
    To find the RSDP, the OS searches for the signature "RSD PTR "
    in well known physical memory locations.  Then the OS computes
    a table checksum to verify that the signature is really part
    of a valid table header.
    
    Some systems have a proper signature but an invalid checksum;
    followed elsewhere by a proper signature with valid checksum.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9444
    
    The Linux RSDP scanning code bailed out on those systems
    and as a result they booted with ACPI disabled.
    
    Fix this by deleting the Linux RSDP scanning code and
    plugging in the ACPICA RSDP scanning code.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 25de5718356e264820625600a9edca1df5ff26f8
Author: Len Brown <len.brown@intel.com>
Date:   Fri Dec 14 00:24:15 2007 -0500

    cpuidle: default processor.latency_factor=2
    
    More aggressively request deep C-states.
    
    Note that the job of the OS is to minimize latency
    impact to expected break events such as interrupts.
    
    It is not the job of the OS to try to calculate if
    the C-state will reach energy break-even.
    The platform doesn't give the OS enough information
    for it to make that calculation.  Thus, it is up
    to the platform to decide if it is worth it to
    go as deep as the OS requested it to, or if it
    should internally demote to a more shallow C-state.
    
    But the converse is not true.  The platform can not
    promote into a deeper C-state than the OS requested
    else it may violate latency constraints.  So it is
    important that the OS be aggressive in giving the
    platform permission to enter deep C-states.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4963f62045b64f93c45fbcb6f8f0baf1e3e7a127
Author: Len Brown <len.brown@intel.com>
Date:   Thu Dec 13 23:50:45 2007 -0500

    cpuidle: create processor.latency_factor tunable
    
    Start with default value of 6, so by default,
    there is no functional change in this patch.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2fdf07417e57136cf6baedf9508e2169a059ebea
Author: Jan Beulich <jbeulich@novell.com>
Date:   Thu Dec 13 08:33:59 2007 +0000

    acpi: make __acpi_map_table() and __init function
    
    .. as it it used only during early boot.
    
    Signed-off-by: Jan Beulich <jbeulich@novell.com>
    
     arch/ia64/kernel/acpi.c     |    2 +-
     arch/x86/kernel/acpi/boot.c |    4 ++--
     drivers/acpi/osl.c          |    3 ++-
     3 files changed, 5 insertions(+), 4 deletions(-)
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 17196d6e533a5c09ca57bf398099ffa3c13248b1
Author: Thomas Renninger <trenn@suse.de>
Date:   Fri Dec 7 13:20:43 2007 +0100

    ACPI: Also autoload the bay driver, was forgotten...
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a340af14b4c08a53c5f7d821d8bd910e17403384
Author: Frank Seidel <fseidel@suse.de>
Date:   Fri Dec 7 13:20:42 2007 +0100

    ACPI: Add autoload info to dock driver
    
    References: https://bugzilla.novell.com/show_bug.cgi?id=302482
    
    Signed-off-by: Thomas Renninger <trenn@novell.com>
    Signed-off-by: Kay Sievers <kasievers@novell.com>
    Signed-off-by: Frank Seidel <fseidel@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3620f2f2f39e7870cf1a4fb2e34063a142f28716
Author: Frank Seidel <fseidel@suse.de>
Date:   Fri Dec 7 13:20:34 2007 +0100

    ACPI: Fix autloading of dock, video, bay and all linux specific HID drivers
    
    References: https://bugzilla.novell.com/show_bug.cgi?id=302482
    
    Due to the new autloading of acpi drivers, the dock driver
    wasn't loaded anymore as there is no HID to identify it with
    (dock is needed if ACPI has a  _DCK method).
    This patch is a workaround for this, original by Thomas Renninger,
    revised first by Kay Sievers and last by Frank Seidel.
    V2 of this patch fixed problems on systems without a defined _CID for
    the docking devices.
    
    Signed-off-by: Thomas Renninger <trenn@novell.com>
    Signed-off-by: Kay Sievers <kasievers@novell.com>
    Signed-off-by: Frank Seidel <fseidel@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 223630fe3dc564b94e51ff4eb839828c9083f2f6
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Dec 6 23:36:35 2007 -0500

    export thermal notification to userspace when nocrt is set
    
    module parameter is used to prevent the thermal_zone action upon
    critical trip points.
    But exporting this notification to userspace is still useful.
    By setting nocrt with this patch applied, ACPI will take no action
    but exporting the events to userspace upon critical/hot trip points.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9139
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 17bc54eef91df29f0a22e8a1562a404cf7a68e74
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Tue Nov 13 13:05:45 2007 +0300

    ACPI: Defer enabling of level GPE until all pending notifies done
    
    Level GPE should not be enabled until all work caused by it is done,
    e.g. all Notify() methods are completed.
    This can be accomplished by appending enable_gpe function to the end
    of notify queue.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Acked-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ed9cbcd40004904dbe61ccc16d6106a7de38c998
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Tue Nov 20 14:20:21 2007 -0500

    Revert "speedstep-lib.c: fix frequency multiplier for Pentium4 models 0&1"
    
    For P4 model < 2, The MSR_FBC_REGISTER_ID ratio is undefined.
    Revert the commit that was added to handle that case,
    as it results in random MHz displayed.  Something else will
    have to be done to properly handle model < 2.
    
    //commit 3e4159ab35c88aef5e063ba78796b277b762a30a
    //Author: matthias.christian <matthias.christian>
    //Date:   Sat Feb 5 23:09:38 2005 +0000
    //
    //    [PATCH] speedstep-lib.c: fix frequency multiplier for Pentium4 models 0&1
    //
    //    The Pentium4 models 0&1 have a longer MSR_EBC_FREQUENCY_ID register as the
    //    models 2&3, so the bit shift must be bigger.
    //
    //    Signed-off-by: Matthias-Christian Ott <matthias.christian@tiscali.de>
    //    Signed-off-by: Dominik Brodowski <linux@brodo.de>
    //    Signed-off-by: Andrew Morton <akpm@osdl.org>
    //    Signed-off-by: Linus Torvalds <torvalds@osdl.org>
    //
    //    BKrev: 42055232eWM-NgjhZVir44mp5GXktQ
    
    http://bugzilla.kernel.org/show_bug.cgi?id=7186
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a7f9b1f24974da287771e2d70b30d9ca7bd66684
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Tue Nov 20 13:38:59 2007 -0500

    ACPI: disable stray GPE, prevent ACPI interrupt storm
    
    GPEs are disabled depending on their type --
    WAKE, WAKE_RUN, and RUNTIME.  An error is returned
    if we are asked to disable a GPE that has no type.
    
    But at least one system exists that enables a GPE from AML
    that is not the EC GPE, and has no _Lxx/_Exx AML handler,
    and is thus never initialized.
    
    In this case, when an external CRT is plugged in,
    the GPE fires, we attempt to disable the GPE,
    but instead just return an error.
    So the GPE stays asserted and an ACPI interrupt storm follows.
    
    The fix is to disable a firing GPE,
    even if it comes from outer space.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=6217
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 60555e371d56a1e410d9fb6fc68f4e953f8f4109
Author: len.brown@intel.com <len.brown@intel.com>
Date:   Mon Nov 19 22:22:37 2007 -0500

    ACPI: CONFIG_CPU_IDLE=ACPI by default
    
    In Linux-2.6.24, CPU_IDLE went upstream, default =n.
    For Linux-2.6.25, enable it by default on ACPI systems.
    For Linux-2.6.26, we plan to enable it always on ACPI systems.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b4d2730a0dda91a43c81a02f5225f5d536cabb09
Author: Len Brown <len.brown@intel.com>
Date:   Wed Nov 14 19:53:21 2007 -0500

    ACPI: document method tracing hooks
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4169c45f179e285feac6bcf25f4bd0db6b109bab
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Wed Nov 14 19:38:40 2007 -0500

    ACPI: add control method tracing support
    
    Add debug tracing support during certain AML method execution.
    
    Four more module parameters are created under /sys/module/acpi/parameters/:
    trace_method_name:	the AML method name that user wants to trace
    
    trace_debug_layer:	the temporary debug_layer used when tracing the method.
    			Using 0xffffffff by default if it is 0.
    
    trace_debug_level:	the temporary debug_level used when tracing the method.
    			Using 0x00ffffff by default if it is 0.
    
    trace_state:		The status of the tracing feature.
    			"enabled" means this feature is enabled
    			and the AML method is traced every time it's executed.
    			"1" means this feature is enabled and the AML method
    			will only be traced during the next execution.
    			"disabled" means this feature is disabled.
    			Users can enable/disable this debug tracing feature by
    			"echo string > /sys/module/acpi/parameters/trace_state".
    			"string" should be one of "enable", "disable" and "1".
    
    http://bugzilla.kernel.org/show_bug.cgi?id=6629
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
