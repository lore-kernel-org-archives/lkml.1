Return-Path: <linux-kernel-owner+w=401wt.eu-S1763597AbYBUI5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763597AbYBUI5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 03:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755924AbYBUI52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 03:57:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:48524 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbYBUI50 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 03:57:26 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PATCH] ACPI patches for 2.6.25-rc2
Date: Thu, 21 Feb 2008 03:57:07 -0500
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802210357.08197.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

Fixes a pair of a boot regressions, and some churn mostly related
to some of the new thermal and thinkpad code that went into -rc1.

This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.25/acpi-release-20070126-2.6.25-rc2.diff.gz

 Documentation/laptops/thinkpad-acpi.txt |   63 ++++++++++------
 arch/x86/mm/pageattr.c                  |   19 +++++-
 drivers/acpi/ec.c                       |    6 +-
 drivers/acpi/executer/exregion.c        |    5 +-
 drivers/acpi/fan.c                      |   30 +++++---
 drivers/acpi/processor_core.c           |   39 ++++++----
 drivers/acpi/processor_idle.c           |   10 +-
 drivers/acpi/utils.c                    |   18 +++--
 drivers/acpi/video.c                    |    3 +
 drivers/base/power/main.c               |    2 +-
 drivers/misc/Kconfig                    |   17 ++++
 drivers/misc/acer-wmi.c                 |    9 ++
 drivers/misc/intel_menlow.c             |   11 ++-
 drivers/misc/thinkpad_acpi.c            |  123 ++++++++++++++++++++++++++-----
 drivers/pci/pci-acpi.c                  |    3 +-
 drivers/thermal/thermal.c               |   39 ++++++----
 include/linux/mm.h                      |    6 ++
 kernel/power/snapshot.c                 |   42 +++++++---
 18 files changed, 322 insertions(+), 123 deletions(-)

through these commits:

Adrian Bunk (1):
      PM: Make suspend_device() static

Alexey Starikovskiy (1):
      ACPI: EC: Use proper handle for boot EC

Carlos Corbacho (1):
      acer-wmi: Add DMI match for mail LED on Acer TravelMate 4200 series

Glauber Costa (1):
      ACPI: remove is_processor_present prototype

Harvey Harrison (1):
      ACPI: sparse fix, replace macro with static function

Henrique de Moraes Holschuh (9):
      ACPI: thinkpad-acpi: trivial fix to module_desc typo
      ACPI: thinkpad-acpi: trivial fix to documentation
      ACPI: thinkpad-acpi: always track input device open/close
      ACPI: thinkpad-acpi: synchronize input device switches
      ACPI: thinkpad-acpi: make the video output feature optional
      ACPI: thinkpad-acpi: issue input events for tablet swivel events
      ACPI: thinkpad-acpi: improve thinkpad-acpi input device documentation
      ACPI: thinkpad-acpi: minor hotkey_radio_sw fixes
      ACPI: thinkpad-acpi: add tablet-mode reporting

Ming Lin (1):
      ACPI: fix build warning

Pavel Machek (1):
      ACPI: TSC breaks atkbd suspend

Rafael J. Wysocki (2):
      Hibernation: Handle DEBUG_PAGEALLOC on x86
      PCI ACPI: Fix comment describing acpi_pci_choose_state

Randy Dunlap (1):
      kernel-doc: fix pci-acpi warning

Thomas Sujith (6):
      thermal: validate input parameters
      thermal: use ERR_PTR for returning error
      ACPI fan: extract return values using PTR_ERR
      ACPI thermal: extract return values using PTR_ERR
      ACPI video: check for error from thermal_cooling_device_register
      intel_menlo: extract return values using PTR_ERR

Zhao Yakui (1):
      ACPI: thermal: Check whether cooling device exists before unregistering

with this log:

commit 1f1519ef597ae4628dbd47244f0f68d700231523
Merge: 208c70a... f28bb45... 1186974... e85ff4b... 19e20c9... 69f6b8d... 6c231bd... 6133116...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 21 02:41:58 2008 -0500

    Merge branches 'release', 'bugzilla-9916', 'bugzilla-9982', 'bugzilla-9989', 'misc', 'suspend', 'thermal', 'thinkpad' and 'tsc' into release

commit 19e20c913bae2dd458b9fc42afab0c53f16562d1
Author: Adrian Bunk <bunk@kernel.org>
Date:   Sun Feb 3 22:55:18 2008 +0100

    PM: Make suspend_device() static
    
    suspend_device() can become static.
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c6868ea00bdebe5762fa59e54b74b4cd4e3b4e6e
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sun Feb 3 22:53:31 2008 +0100

    PCI ACPI: Fix comment describing acpi_pci_choose_state
    
    The last line of the comment preceding the definition of
    acpi_pci_choose_state() is incorrect.  Remove it.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8a235efad548abd2ab5ebea45a9ffa750c814375
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Wed Feb 20 01:47:44 2008 +0100

    Hibernation: Handle DEBUG_PAGEALLOC on x86
    
    Make hibernation work with CONFIG_DEBUG_PAGEALLOC set on x86, by
    checking if the pages to be copied are marked as present in the
    kernel mapping and temporarily marking them as present if that's not
    the case.  No functional modifications are introduced if
    CONFIG_DEBUG_PAGEALLOC is unset.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1186974f3ffe3c1796e5efce7afffefcfda9a6f0
Author: Ming Lin <ming.m.lin@intel.com>
Date:   Thu Feb 21 02:01:30 2008 -0500

    ACPI: fix build warning
    
    CC      drivers/acpi/executer/exregion.o
    drivers/acpi/executer/exregion.c: In function
    ‘acpi_ex_pci_config_space_handler’:
    drivers/acpi/executer/exregion.c:369: attention : passing argument 3 of
    ‘acpi_os_read_pci_configuration’ from incompatible pointer type
    
    exposed by 10270d4838bdc493781f5a1cf2e90e9c34c9142f
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9989
    
    Signed-off-by: Ming Lin <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6133116849219f4e657ead39c7ac3922583f5a6e
Author: Pavel Machek <pavel@ucw.cz>
Date:   Tue Feb 19 11:00:29 2008 +0100

    ACPI: TSC breaks atkbd suspend
    
    TSC is used even on machines when CONFIG_X86_TSC is not set (X86_TSC
    means _require_ TSC), but it is not properly disabled when it is
    unusable, because ACPI code understood the config switch as "may use
    TSC".
    
    This actually fixes suspend problems on my x60.
    
    Signed-off-by: Pavel Machek <pavel@suse.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e85ff4b53eb4252d967922bd75cb6d10863955f3
Author: Glauber Costa <gcosta@redhat.com>
Date:   Sat Feb 16 01:01:13 2008 -0500

    ACPI: remove is_processor_present prototype
    
    The function itself is defined just below, so this prototype is not really
    useful.
    
    Signed-off-by: Glauber Costa <gcosta@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 262ee35be6a3aae9b4a7aafafc2dba901fc36620
Author: Carlos Corbacho <carlos@strangeworlds.co.uk>
Date:   Sat Feb 16 00:02:56 2008 +0000

    acer-wmi: Add DMI match for mail LED on Acer TravelMate 4200 series
    
    The TM4200 series use the same method as the TM2490 series to control the
    mail LED, so add a DMI based quirk for these laptops.
    
    Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4fd7f5188c377c1e9aa8f224f6edf96d170a7d32
Author: Harvey Harrison <harvey.harrison@gmail.com>
Date:   Fri Feb 15 17:07:19 2008 -0800

    ACPI: sparse fix, replace macro with static function
    
    replace acpi_util_eval_error macro with static function.
    
    Avoid these sparse warnings due to using buffer within the macro.
    drivers/acpi/utils.c:273:3: warning: symbol 'buffer' shadows an earlier one
    drivers/acpi/utils.c:259:21: originally declared here
    drivers/acpi/utils.c:279:3: warning: symbol 'buffer' shadows an earlier one
    drivers/acpi/utils.c:259:21: originally declared here
    drivers/acpi/utils.c:368:3: warning: symbol 'buffer' shadows an earlier one
    drivers/acpi/utils.c:348:21: originally declared here
    drivers/acpi/utils.c:375:3: warning: symbol 'buffer' shadows an earlier one
    drivers/acpi/utils.c:348:21: originally declared here
    drivers/acpi/utils.c:382:3: warning: symbol 'buffer' shadows an earlier one
    drivers/acpi/utils.c:348:21: originally declared here
    drivers/acpi/utils.c:402:4: warning: symbol 'buffer' shadows an earlier one
    drivers/acpi/utils.c:348:21: originally declared here
    
    Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6c231bd5eb07ce546517019f334652b9ecfc329a
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Feb 16 02:17:58 2008 -0200

    ACPI: thinkpad-acpi: add tablet-mode reporting
    
    A quick study of the 0x5009/0x500A HKEY event on the X61t DSDT revealed the
    existence of the EC HTAB register (EC 0x0f, bit 7), and a compare with the
    X41t DSDT shows that HKEY.MHKG can be used to verify if the ThinkPad is
    tablet-capable (MHKG present), and in tablet mode (bit 3 of MHKG return is
    set).
    
    Add an attribute to report this information, "hotkey_tablet_mode".  This
    attribute has poll()/select() support, and can be used along with EV_SW
    SW_TABLET_MODE to hook userspace to tablet events.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d147da73c9a3f617e4685c6a7762961fe19833e7
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Feb 16 02:17:57 2008 -0200

    ACPI: thinkpad-acpi: minor hotkey_radio_sw fixes
    
    Fixes some minor points in the radio switch code and docs.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d0788cfbae0eddf13d5f2591acb1b407ba041d71
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Feb 16 02:17:56 2008 -0200

    ACPI: thinkpad-acpi: improve thinkpad-acpi input device documentation
    
    Fix a few spelling errors, and also document the EV_SW events thinkpad-acpi
    can issue.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b3ec6f911a681f38e4630ef8bf20b3d3cb0f63c2
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Feb 16 02:17:55 2008 -0200

    ACPI: thinkpad-acpi: issue input events for tablet swivel events
    
    Issue EV_SW SW_TABLET_MODE events for HKEY events 0x5009 and 0x500A on the
    X41t/X60t/X61t.  As usual, we suppress the HKEY events on the netlink
    interface to avoid sending duplicate events to userspace.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d7c1d17dfed996e84212fc1ce617b2586dd70ec2
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Feb 16 02:17:54 2008 -0200

    ACPI: thinkpad-acpi: make the video output feature optional
    
    The video output port control feature is not very useful on many ThinkPads
    (especially when a X server is running), and lately userspace is getting
    better and better at it, so it makes sense to allow users to stripe out the
    thinkpad-acpi video feature from their kernels and save at least 2KB.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7526696a013f33d4926fdc080c26fe6af07ba30f
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Feb 16 02:17:53 2008 -0200

    ACPI: thinkpad-acpi: synchronize input device switches
    
    Issue EV_SW events at module init time to synchronize the input device with
    the current state of the switch, otherwise we might lose the first event.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1bc6b9cdd5e608f0b7e6160a823c9dcd51820410
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Feb 16 02:17:52 2008 -0200

    ACPI: thinkpad-acpi: always track input device open/close
    
    The open() and close() hooks for the input device are useful even when
    hotkey NVRAM polling support is not in use, so it is better to always have
    them around.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5f24927f48c63e79ff8e286fc8530f4525b4182a
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Feb 16 02:17:51 2008 -0200

    ACPI: thinkpad-acpi: trivial fix to documentation
    
    Fix a stray ibm-acpi that should have been replaced with thinkpad-acpi.
    Thanks to Damjan <gdamjan@mail.net.mk> for noticing this one.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cbb14842137ff78df10038da8ca8a97917a5a926
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Feb 16 02:17:50 2008 -0200

    ACPI: thinkpad-acpi: trivial fix to module_desc typo
    
    Thanks to Damjan <gdamjan@mail.net.mk> for noticing this one.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 69f6b8dd6b94ac594b6920b4530a3390fb1d3fd6
Author: Thomas Sujith <sujith.thomas@intel.com>
Date:   Fri Feb 15 01:05:23 2008 -0500

    intel_menlo: extract return values using PTR_ERR
    
    Need to extract errors using PTR_ERR macro and
    process accordingly.thermal_cooling_device_register
    returning NULL means that CONFIG_THERMAL=n and in that
    case no need to create symbolic links.
    
    Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 43ff39f2f6450fa2e9a566f8bf007a26d76f2c9d
Author: Thomas Sujith <sujith.thomas@intel.com>
Date:   Fri Feb 15 18:29:18 2008 -0500

    ACPI video: check for error from thermal_cooling_device_register
    
    Need to check whether thermal_cooling_device_register
    returned ERROR or not.
    
    Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d76628c67cdeebf84766a19c67c821c2e518baa4
Author: Thomas Sujith <sujith.thomas@intel.com>
Date:   Fri Feb 15 18:26:54 2008 -0500

    ACPI thermal: extract return values using PTR_ERR
    
    Need to extract errors using PTR_ERR macro and
    process accordingly.thermal_cooling_device_register
    returning NULL means that CONFIG_THERMAL=n and in that
    case no need to create symbolic links.
    
    Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f28bb45e2863173a7464d98907677e903f42c68b
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Fri Feb 15 08:34:37 2008 +0800

    ACPI: thermal: Check whether cooling device exists before unregistering
    
    OS should check whether the cooling device exists before it is unregistered.
    If it doesn't exists, it is unnecessary to remove the sysfs link
    and call the function of thermal_cooling_device_unregister.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9982
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Tested-by    : Dhaval Giani <dhaval@linux.vnet.ibm.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 19b36780ee7ddeb5080e3f1f858a83c4824f1fdc
Author: Thomas Sujith <sujith.thomas@intel.com>
Date:   Fri Feb 15 01:01:52 2008 -0500

    ACPI fan: extract return values using PTR_ERR
    
    Need to extract errors using PTR_ERR macro and
    process accordingly.  thermal_cooling_device_register
    returning NULL means that CONFIG_THERMAL=n and in that
    case no need to create symbolic links.
    
    Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3e6fda5c1159823fc02463eceb564c8bfc0e7a0e
Author: Thomas Sujith <sujith.thomas@intel.com>
Date:   Fri Feb 15 00:59:50 2008 -0500

    thermal: use ERR_PTR for returning error
    
    Need to return using ERR_PTR instead of NULL
    in case of errors.
    
    Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c751670902c3dd9abbed279170a832e6a1e6cf94
Author: Thomas Sujith <sujith.thomas@intel.com>
Date:   Fri Feb 15 00:58:50 2008 -0500

    thermal: validate input parameters
    
    Added sanity check to make sure that thermal zone
    and cooling device exists.
    
    Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5958f1a4da39581074bab50cabd0a582e651b90f
Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Sun Feb 3 15:06:25 2008 -0800

    kernel-doc: fix pci-acpi warning
    
    Fix PCI kernel-doc warning:
    Warning(linux-2.6.24-git12//drivers/pci/pci-acpi.c:166): No description found for parameter 'hid'
    
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 208c70a45624400fafd7511b96bc426bf01f8f5e
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Thu Feb 14 15:58:47 2008 -0500

    ACPI: EC: Use proper handle for boot EC
    
    Fall back to ACPI_ROOT_HANDLE only in case of error.
    
    ACPI: EC: EC description table is found, configuring boot EC
    ACPI Error (evregion-0316): No handler for Region [ECOR] (ffff81007a651620) [EmbeddedControl] [20070126]
    ACPI Error (exfldio-0289): Region EmbeddedControl(3) has no handler [20070126]
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9916
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>
