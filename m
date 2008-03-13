Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362AbYCMGQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbYCMGQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 02:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbYCMGP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 02:15:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:45040 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbYCMGPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 02:15:54 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: [GIT PATCH] ACPI patches for 2.6.25-rc5
Date: Thu, 13 Mar 2008 02:14:36 -0400
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803130214.36861.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

A bunch of small regression fixes, bug fixes, and a couple of minor cleanups.

FYI, some notes on the larger text changes:

Documentation/* moves some files around to complete a change
we started earlier in 2.6.25.

thermal.c updates the I/F we added in 2.6.25-rc1 to look how hwmon wants it.

pci_irq.c provides some DMI workarounds for interrupt related BIOS bugs.

snapshot.c fixes a hibernation regression (though it broke back in 2.6.22)

acer-wmi.c tweaks a driver that is new in 2.6.25-rc1 with some DMI hooks.

This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.25/acpi-release-20070126-2.6.25-rc5.diff.gz

 Documentation/00-INDEX                           |    6 -
 Documentation/filesystems/proc.txt               |    4 +-
 Documentation/kernel-parameters.txt              |    2 +-
 Documentation/laptops/00-INDEX                   |    2 +
 Documentation/laptops/acer-wmi.txt               |    4 +-
 Documentation/{ => laptops}/laptop-mode.txt      |    0 
 Documentation/power/00-INDEX                     |    6 +
 Documentation/{ => power}/pm.txt                 |    2 +-
 Documentation/{ => power}/pm_qos_interface.txt   |    0 
 Documentation/{ => power}/power_supply_class.txt |    0 
 Documentation/thermal/sysfs-api.txt              |   22 ++--
 arch/x86/Kconfig                                 |    2 +-
 drivers/acpi/Kconfig                             |   19 ++--
 drivers/acpi/bus.c                               |    2 +-
 drivers/acpi/button.c                            |    1 +
 drivers/acpi/ec.c                                |   17 ++-
 drivers/acpi/osl.c                               |    2 +-
 drivers/acpi/pci_irq.c                           |   98 +++++++++++++
 drivers/acpi/pci_root.c                          |    2 +-
 drivers/acpi/processor_core.c                    |   25 ++--
 drivers/acpi/scan.c                              |    5 +-
 drivers/acpi/sleep/main.c                        |    2 +-
 drivers/acpi/system.c                            |    2 +-
 drivers/acpi/thermal.c                           |   12 +-
 drivers/acpi/toshiba_acpi.c                      |    7 +
 drivers/acpi/utilities/utdebug.c                 |    2 +-
 drivers/acpi/utilities/utobject.c                |    2 +-
 drivers/acpi/utils.c                             |    6 +
 drivers/acpi/video.c                             |    4 +-
 drivers/acpi/wmi.c                               |   10 +-
 drivers/misc/Kconfig                             |    1 +
 drivers/misc/acer-wmi.c                          |   44 ++++--
 drivers/misc/sony-laptop.c                       |    2 +-
 drivers/pci/pci-acpi.c                           |   24 ++-
 drivers/thermal/Kconfig                          |    1 +
 drivers/thermal/thermal.c                        |  169 ++++++++++++++++++----
 kernel/power/Kconfig                             |    2 +-
 kernel/power/snapshot.c                          |   41 +++++-
 38 files changed, 426 insertions(+), 126 deletions(-)
 rename Documentation/{ => laptops}/laptop-mode.txt (100%)
 rename Documentation/{ => power}/pm.txt (99%)
 rename Documentation/{ => power}/pm_qos_interface.txt (100%)
 rename Documentation/{ => power}/power_supply_class.txt (100%)

through these commits:

Adrian Bunk (1):
      sony-laptop.c: fix off-by-one

Alexey Starikovskiy (1):
      ACPI: EC: Handle IRQ storm on Acer laptops

Andrey Borzenkov (1):
      ACPI: button: make real parent for input devices in device tree

Bjorn Helgaas (1):
      ACPI: add _PRT quirks to work around broken firmware

Carlos Corbacho (6):
      acer-wmi: Rename mail LED correctly & remove hardcoded colour
      acer-wmi: Don't warn if mail LED cannot be detected
      ACPI: WMI: Clean up handling of spec violating data blocks
      acer-wmi: Make device detection error messages more descriptive
      acer-wmi: Fix DSDT path in documentation
      acer-wmi: Add DMI quirk for mail LED support on Acer Aspire 3610/ 5610

David Brownell (1):
      ACPI: acpi_pci_set_power_state() cleanups

Glauber Costa (1):
      ACPI: use ACPI_DEBUG_PRINT instead of printk in acpi_processor_hotplug_notify()

Harvey Harrison (1):
      ACPI: replace remaining __FUNCTION__ occurrences

Holger Macht (1):
      ACPI: Do not pass NULL to acpi_get_handle() when looking for _EJD

Jean Delvare (1):
      ACPI: Fix a duplicate log level

Jiri Kosina (1):
      acer-wmi: build depends on i8042

Johann Felix Soden (1):
      ACPI: buffer array too short in drivers/acpi/system.c

Len Brown (1):
      Revert "ACPI: EC: Use proper handle for boot EC"

Lin Ming (1):
      ACPI: fix boot oops regression in thermal

Rafael J. Wysocki (1):
      Hibernation: Fix mark_nosave_pages()

Randy Dunlap (3):
      ACPI: prevent randconfig build failure on empty ACPI_CUSTOM_DSDT_FILE
      laptops: move laptop-mode.txt to Documentation/laptops/
      documentation:  Move power-related files to Documentation/power/

Sam Ravnborg (3):
      ACPI: fix section mismatch in processor_core.c:acpi_processor_hotplug_notify
      acer-wmi: fix section mismatch warnings
      ACPI: fix section mismatch in acpi_pci_root_add

Thomas Renninger (1):
      ACPICA: Warn if packages with invalid references are evaluated

Zhang Rui (1):
      ACPI Exception (): AE_NOT_FOUND, Processor Device is not present (update)

Zhang, Rui (2):
      thermal: fix generic thermal I/F for hwmon
      ACPI: thermal: show temperature in millidegree Celsius

Zhao Yakui (1):
      ACPI: Ignore _BQC object when registering backlight device

arvidjaar@mail.ru (1):
      toshiba_acpi: Enable autoloading

with this log:

commit 29ea5171cbd08a7ef37e543cbf02447033f0e289
Merge: b4de123... 5347112...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Mar 13 01:59:53 2008 -0400

    Merge branches 'release' and 'doc' into release

commit b4de123a0bc4a3f0c90899864d51299628729952
Merge: c523aef... 3b5fee5... d399d13... 07d31ee...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Mar 13 01:59:52 2008 -0400

    Merge branches 'release', 'ejd', 'sony' and 'wmi' into release

commit c523aef0f7284970463ebd77a54bca9069711d4a
Merge: 160ff06... 3b34e52... c8dc9de... b5678a3... 7ce9573... 4db42c5...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Mar 13 01:59:49 2008 -0400

    Merge branches 'release', 'button-sysfs', 'misc', 'mismatch', 'randconfig' and 'toshiba' into release

commit 160ff06b1848a01913611950b05963e3315f759b
Merge: 1ca721c... 5e01276...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Mar 13 01:59:46 2008 -0400

    Merge branches 'release' and 'thermal' into release

commit 1ca721cdb748ba72c47e9c661d54696db3cde796
Merge: 93d7446... d0ce46f... a82f711... 2c81ce4... 4af8e10... c8d16e2... 391df5d... 7c0ea45...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Mar 13 01:59:45 2008 -0400

    Merge branches 'release', 'bugzilla-8570', 'bugzilla-9966', 'bugzilla-9998', 'bugzilla-10100', 'bugzilla-10132', 'bugzilla-10138' and 'bugzilla-10206' into release

commit 5e012760dfd5ec24c41b9eab9e654a88360bb026
Author: Zhang, Rui <rui.zhang@intel.com>
Date:   Thu Feb 28 07:51:30 2008 +0800

    ACPI: thermal: show temperature in millidegree Celsius
    
    as now required by the generic thermal I/F
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Acked-by: Jean Delvare <khali@linux-fr.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3152fb9f11cdd2fd8688c2c5cb805e5c09b53dd9
Author: Zhang, Rui <rui.zhang@intel.com>
Date:   Wed Feb 27 08:37:50 2008 +0800

    thermal: fix generic thermal I/F for hwmon
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 07d31ee5597dadfd621840e2404b086fa94ef0c6
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Mon Mar 10 22:29:37 2008 +0100

    acer-wmi: build depends on i8042
    
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>
    Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 53471121a8aad3f0b590bfce7c95a1f5f52150f3
Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Wed Mar 12 18:10:51 2008 -0400

    documentation:  Move power-related files to Documentation/power/
    
    Move 00-INDEX entries to power/00-INDEX (and add entry for
    pm_qos_interface.txt).
    
    Update references to moved filenames.
    
    Fix some trailing whitespace.
    
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c8dc9de10951609492f0d0282a61e2b2eec385c8
Author: Johann Felix Soden <johfel@gmx.de>
Date:   Tue Mar 11 16:44:26 2008 +0100

    ACPI: buffer array too short in drivers/acpi/system.c
    
    Since "ff_gbl_lock" has a length of 11 chars and is copied with sprintf
    to char buffer[10], there is a problem. We need char buffer[12] because
    of the closing zero byte.
    
    Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ed9cfe98050be635ff780678d166e7c7bf578818
Author: Carlos Corbacho <carlos@strangeworlds.co.uk>
Date:   Wed Mar 12 20:13:00 2008 +0000

    acer-wmi: Add DMI quirk for mail LED support on Acer Aspire 3610/ 5610
    
    Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 08816465894f46fc559301c22686939c3c9c138b
Author: Carlos Corbacho <carlos@strangeworlds.co.uk>
Date:   Wed Mar 12 20:12:55 2008 +0000

    acer-wmi: Fix DSDT path in documentation
    
    Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8d039bc7f3d2330787eaa7a392f5e6489f1544d5
Author: Carlos Corbacho <carlos@strangeworlds.co.uk>
Date:   Wed Mar 12 20:12:50 2008 +0000

    acer-wmi: Make device detection error messages more descriptive
    
    The current device detection error messages are all copy & pasted - make
    them more descriptive so it's easier to see where in the code a problem
    occurs.
    
    Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a09a20b526fde0611b49b76521e3c546a47216a5
Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Tue Mar 4 13:41:26 2008 -0800

    laptops: move laptop-mode.txt to Documentation/laptops/
    
    Move laptop-mode.txt into the laptops/ sub-directory to consolidate
    laptop doc files there.
    
    Update references to the file's location.
    
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b6a163875935ce8e8e85901a7f2b68f7a314d914
Author: Thomas Renninger <trenn@suse.de>
Date:   Wed Mar 12 01:06:24 2008 +0100

    ACPICA: Warn if packages with invalid references are evaluated
    
    And return an error to avoid NULL pointer access by the caller
    Lin Ming's patch avoids corrupted mem access when
    BIOS has invalid references included, the handle is now zero
    instead of corrupted.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 391df5dce30a5aab477b9e55ea65a3e83bae96b1
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Tue Mar 11 13:45:15 2008 -0700

    ACPI: add _PRT quirks to work around broken firmware
    
    This patch works around incorrect _PRT (PCI interrupt routing)
    information from firmware.  This does not fix any regressions
    and can wait for the next kernel release.
    
    On the Medion MD9580-F laptop, the BIOS says the builtin RTL8139
    NIC interrupt at 00:09.0[A] is connected to \_SB.PCI0.ISA.LNKA, but
    it's really connected to \_SB.PCI0.ISA.LNKB.  Before this patch,
    the workaround was to use "pci=routeirq".  More details at
    http://bugzilla.kernel.org/show_bug.cgi?id=4773.
    
    On the Dell OptiPlex GX1, the BIOS says the PCI slot interrupt
    00:0d[A] is connected to LNKB, but it's really connected to LNKA.
    Before this patch, the workaround was to use "pci=routeirq".
    Pierre Ossman tested a previous version of this patch and confirmed
    that it fixed the problem.  More details at
    http://bugzilla.kernel.org/show_bug.cgi?id=5044.
    
    On the HP t5710 thin client, the BIOS says the builtin Radeon
    video interrupt at 01:00[A] is connected to LNK1, but it's really
    connected to LNK3.  The previous workaround was to use a custom
    DSDT.  I tested this patch and verified that it fixes the problem.
    More details at http://bugzilla.kernel.org/show_bug.cgi?id=10138.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a82f7119fd940c1505fc9fdf93d835fa52bc075d
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Wed Mar 12 00:34:57 2008 +0100

    Hibernation: Fix mark_nosave_pages()
    
    There is a problem in the hibernation code that triggers on some NUMA
    systems on which pfn_valid() returns 'true' for some PFNs that don't
    belong to any zone.  Namely, there is a BUG_ON() in
    memory_bm_find_bit() that triggers for PFNs not belonging to any
    zone and passing the pfn_valid() test.  On the affected systems it
    triggers when we mark PFNs reported by the platform as not saveable,
    because the PFNs in question belong to a region mapped directly using
    iorepam() (i.e. the ACPI data area) and they pass the pfn_valid()
    test.
    
    Modify memory_bm_find_bit() so that it returns an error if given PFN
    doesn't belong to any zone instead of crashing the kernel and ignore
    the result returned by it in mark_nosave_pages(), while marking the
    "nosave" memory regions.
    
    This doesn't affect the hibernation functionality, as we won't touch
    the PFNs in question anyway.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9966 .
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7c0ea45be4f114d85ee35caeead8e1660699c46f
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Tue Mar 11 16:56:47 2008 +0800

    ACPI: Ignore _BQC object when registering backlight device
    
    According to acpi spec , the objects of  _BCL and _BCM are required if
    integrated LCD is present and supports brightness level .The _BQC is
    the optional object. So the _BQC object is ignored when the backlight device
    is registered in ACPI video driver.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=10206
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Zhang Rui  <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a527f2d7fe58ce95bfec998f3dc6f658c777a2f2
Author: Carlos Corbacho <carlos@strangeworlds.co.uk>
Date:   Sun Feb 24 13:34:34 2008 +0000

    ACPI: WMI: Clean up handling of spec violating data blocks
    
    Acer violate the ACPI-WMI spec by declaring some of their data blocks as
    expensive, but with no corresponding WCxx method. There is already some
    workaround code in to handle the initial WCxx call (we just ignore a
    failure here); but we need to properly check if the second, "clean up",
    WCxx call is actually needed or not, rather than fail simply because it
    isn't there.
    
    Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9b963c40306ba6967650dce99f4e823f1da49a60
Author: Carlos Corbacho <carlos@strangeworlds.co.uk>
Date:   Sun Feb 24 13:34:29 2008 +0000

    acer-wmi: Don't warn if mail LED cannot be detected
    
    This warning confuses users, who think it is an error. Not detecting the
    mail LED simply means it isn't there, so let's not unduly panic users.
    
    Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 343c00422d3296838927016750b18ead8aa8bf9a
Author: Carlos Corbacho <carlos@strangeworlds.co.uk>
Date:   Sun Feb 24 13:34:18 2008 +0000

    acer-wmi: Rename mail LED correctly & remove hardcoded colour
    
    The mail LED name for acer-wmi currently hardcodes in the colour as green.
    This is wrong, since many of the newer laptops now come with an orange
    LED, and we have no way of telling what colour is used on a given system.
    
    Also, rename the mail LED to be inline with the current recommendations of
    the LED class documentation.
    
    Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d6f882e10442c1ea6ed5f93365f48be4cb520be7
Author: Glauber Costa <gcosta@redhat.com>
Date:   Tue Mar 4 15:06:36 2008 -0800

    ACPI: use ACPI_DEBUG_PRINT instead of printk in acpi_processor_hotplug_notify()
    
    For consistency, use ACPI_DEBUG_PRINT instead of printk in
    acpi_processor_hotplug_notify() for BUS_CHECK and DEVICE_CHECK events
    
    Signed-off-by: Glauber Costa <gcosta@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3b34e5232fa9776e9a4b3f539cd9fee7609c900e
Author: Andrey Borzenkov <arvidjaar@mail.ru>
Date:   Tue Mar 4 15:06:35 2008 -0800

    ACPI: button: make real parent for input devices in device tree
    
    Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
    Cc: Dmitry Torokhov <dtor@mail.ru>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4db42c51ce0033f409fc3a2742e7aa2efa03f7c3
Author: arvidjaar@mail.ru <arvidjaar@mail.ru>
Date:   Tue Mar 4 15:06:34 2008 -0800

    toshiba_acpi: Enable autoloading
    
    This adds aliases to enable autoloading of toishiba_acpi.  Two aliases are
    defined - TOS6200 (for \\_SB_.VALD.GHCI) and TSO1900 (for \\_SB_.VALZ.GHCI).
    This allows toishiba_acpi to be autoloaded on systems that provide those
    devices.
    
    Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
    Cc: Olivier Blin <blino@mandriva.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2c81ce4c9c37b910210f2640c28e98a0c398dc26
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Tue Mar 11 13:30:00 2008 -0400

    ACPI: EC: Handle IRQ storm on Acer laptops
    
    On some Acer systems, the HW fails to clear the GPE source,
    causing an interrupt storm.
    
    So in EC interrupt mode, we count how many interrupts we
    receive when waiting.  If we get more than 5, we give
    up on interrupt mode and revert to polling mode.
    
    Also, for polling mode to work on Acers, we need
    to insert a delay.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 96b2dd1f1fdb9a131b7f2e79e5c7b2e4282cfcbf
Author: Harvey Harrison <harvey.harrison@gmail.com>
Date:   Wed Mar 5 18:24:51 2008 -0800

    ACPI: replace remaining __FUNCTION__ occurrences
    
    __FUNCTION__ is gcc-specific, use __func__
    
    Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bd12935f04066df31903eaf74b1cec03319ecd2e
Author: Jean Delvare <khali@linux-fr.org>
Date:   Wed Feb 27 20:56:01 2008 +0100

    ACPI: Fix a duplicate log level
    
    Signed-off-by: Jean Delvare <khali@linux-fr.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4af8e10a6c57e7292862bd1703712f0565c7e429
Author: Len Brown <len.brown@intel.com>
Date:   Tue Mar 11 00:27:16 2008 -0400

    Revert "ACPI: EC: Use proper handle for boot EC"
    
    This reverts commit 208c70a45624400fafd7511b96bc426bf01f8f5e.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=10100
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c8d16e27a3601d1cbcdfe657eb4ff5e762019e8d
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Fri Feb 29 07:38:54 2008 +0800

    ACPI: fix boot oops regression in thermal
    
    Fix a memory overflow bug when copying
    NULL internal package element object to external.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=10132
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d0ce46f550ebbd765881e8c48f43b66285d798b0
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Sat Feb 23 01:53:09 2008 -0500

    ACPI Exception (): AE_NOT_FOUND, Processor Device is not present (update)
    
    update cfaf3747ff3d431fba33f75083b7f50f58ae22ff
    ACPI: ACPI Exception (): AE_NOT_FOUND, Processor Device is not present
    
    is_processor_present is only called in the processor hotplug case,
    and _STA method is mandatory at this time.
    
    We should ignore those processors that are disabled in the MADT
    and don't have _STA methods.
    Because they will never exist in this system.
    For the processors that don't physically exist but can be
    hot plugged later, we still need this debug info.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=8570
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 583c377f1d58e705f75d8d5648ab41722be1ebca
Author: David Brownell <david-b@pacbell.net>
Date:   Fri Feb 22 21:41:51 2008 -0800

    ACPI: acpi_pci_set_power_state() cleanups
    
    Minor cleanups to acpi_pci_set_power_state():  use the ACPI and PCI
    state symbols to make clear that a mapping is being done between PCI
    and ACPI states, instead of using magic numbers.  For paranoia's sake,
    report any errors.  Save five bytes (x86_64) too.
    
    Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7ce9573e093891f5807e6e50f3bd2012f1e5d0fe
Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Fri Feb 22 11:25:04 2008 -0800

    ACPI: prevent randconfig build failure on empty ACPI_CUSTOM_DSDT_FILE
    
    Make ACPI_CUSTOM_DSDT boolean config symbol a hidden and derived
    value, based on the value of ACPI_CUSTOM_DSDT_FILE (string).
    Only the latter is presented to the user as a config option.
    
    This fixes problems with "make randconfig" setting ACPI_CUSTOM_DSDT
    but leaving ACPI_CUSTOM_DSDT_FILE empty/blank.
    
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3b5fee5952ff7eb6ff7a64247a01040b8b331b74
Author: Holger Macht <hmacht@suse.de>
Date:   Thu Feb 14 13:40:34 2008 +0100

    ACPI: Do not pass NULL to acpi_get_handle() when looking for _EJD
    
    When trying to get the acpi_handle from an acpi_buffer, pass
    ACPI_ROOT_OBJECT instead of NULL to acpi_get_handle(). This fixes the
    detection of dock dependent bays.
    
    Signed-off-by: Holger Macht <hmacht@suse.de>
    Tested-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d399d130c82a1e1751b7770944f487fbd8b6272a
Author: Adrian Bunk <bunk@kernel.org>
Date:   Wed Feb 20 00:59:03 2008 +0200

    sony-laptop.c: fix off-by-one
    
    This patch fixes an off-by-one spotted by the Coverity checker.
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Acked-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b5678a34762edf2c8de1c60c125fea42a8c17e63
Author: Sam Ravnborg <sam@ravnborg.org>
Date:   Sun Feb 17 13:23:03 2008 +0100

    ACPI: fix section mismatch in acpi_pci_root_add
    
    Fix following warning:
    WARNING: vmlinux.o(.text+0x550e85): Section mismatch in reference from the function acpi_pci_root_add() to the function .devinit.text:pci_acpi_scan_root()
    
    acpi_pci_root_add uses a __devinit annotated function and
    it looks like annotating it __devinit too is the correct fix.
    
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7560e385651c60e5ffdf07cb94fa7d1658ab0b7a
Author: Sam Ravnborg <sam@ravnborg.org>
Date:   Sun Feb 17 13:22:54 2008 +0100

    acer-wmi: fix section mismatch warnings
    
    Fix following warnings:
    WARNING: vmlinux.o(.text+0x672615): Section mismatch in reference from the function acer_platform_remove() to the function .exit.text:acer_backlight_exit()
    WARNING: vmlinux.o(.devinit.text+0x1e859): Section mismatch in reference from the function acer_platform_probe() to the function .init.text:acer_led_init()
    WARNING: vmlinux.o(.devinit.text+0x1e878): Section mismatch in reference from the function acer_platform_probe() to the function .init.text:acer_backlight_init()
    
    Remove __exit annotation from acer_backlight_exit(). We cannot reference
    a __exit annotated function from non __exit functions.
    
    acer_led_init() and acer_backlight_init() where both annotated __init but
    used from a __devinit function. This would result in an oops should
    gcc drop their inlining and the module are hot plugged.
    
    Fix by annotating acer_led_init() and acer_backlight_init() __devinit.
    
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
    Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b95e9e8d94484c2823be67416f25e9756db149dc
Author: Sam Ravnborg <sam@ravnborg.org>
Date:   Sun Feb 17 13:22:48 2008 +0100

    ACPI: fix section mismatch in processor_core.c:acpi_processor_hotplug_notify
    
    Fix following warning:
    WARNING: vmlinux.o(.text+0x55586c): Section mismatch in reference from the function acpi_processor_hotplug_notify() to the function .cpuinit.text:acpi_processor_start()
    
    acpi_processor_hotplug_notify() may safely reference __cpuinit
    stuff as it ids defined inside an ACPI_HOTPLUG_CPU block.
    So annotate it __ref to silence the warning.
    
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
    Signed-off-by: Len Brown <len.brown@intel.com>
