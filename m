Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbXD2FEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbXD2FEQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 01:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbXD2FEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 01:04:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:53983 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580AbXD2FEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 01:04:09 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCH] ACPI patches for 2.6.22
Date: Sun, 29 Apr 2007 01:02:33 -0400
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704290102.33533.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This batch mostly updates the platform-specific drivers that use ACPI.
The EC and sbs changes are primarily cleanups.
There are no changes to the ACPICA core, except a single bugfix
that was related to a 2.6.21 boot regression on some older machines.
And then the usual mix of random tweaks.

This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.21/acpi-release-20070126-2.6.21.diff.gz

 Documentation/ibm-acpi.txt          |  728 ----
 Documentation/kernel-parameters.txt |   32 
 Documentation/sony-laptop.txt       |   25 
 Documentation/thinkpad-acpi.txt     |  981 +++++
 Documentation/video4linux/meye.txt  |    7 
 MAINTAINERS                         |   18 
 arch/i386/kernel/acpi/earlyquirk.c  |    5 
 drivers/acpi/Kconfig                |   44 
 drivers/acpi/Makefile               |   10 
 drivers/acpi/acpi_memhotplug.c      |   13 
 drivers/acpi/bus.c                  |    4 
 drivers/acpi/container.c            |    6 
 drivers/acpi/dock.c                 |   25 
 drivers/acpi/ec.c                   |  495 --
 drivers/acpi/i2c_ec.c               |  403 --
 drivers/acpi/i2c_ec.h               |   23 
 drivers/acpi/ibm_acpi.c             | 2798 ---------------
 drivers/acpi/processor_core.c       |    4 
 drivers/acpi/processor_idle.c       |    8 
 drivers/acpi/sbs.c                  | 1291 +++----
 drivers/acpi/scan.c                 |    4 
 drivers/acpi/sleep/proc.c           |   16 
 drivers/acpi/tables/tbfadt.c        |   12 
 drivers/char/sonypi.c               |   53 
 drivers/clocksource/acpi_pm.c       |    2 
 drivers/media/video/Kconfig         |    6 
 drivers/media/video/meye.c          |   62 
 drivers/media/video/meye.h          |    2 
 drivers/misc/Kconfig                |   66 
 drivers/misc/Makefile               |    1 
 drivers/misc/asus-laptop.c          |  151 
 drivers/misc/sony-laptop.c          | 2131 ++++++++++-
 drivers/misc/thinkpad_acpi.c        | 4312 ++++++++++++++++++++++++
 drivers/misc/thinkpad_acpi.h        |  572 +++
 drivers/pci/pci-acpi.c              |    4 
 include/acpi/actbl.h                |    1 
 include/linux/sony-laptop.h         |   34 
 37 files changed, 9058 insertions(+), 5291 deletions(-)

through these commits:

Adrian Bunk (1):
      thinkpad-acpi: make drivers/misc/thinkpad_acpi:fan_mutex static

Alexey Starikovskiy (11):
      ACPI: EC: Don't use Global Lock if not asked to do so
      ACPI: EC: Make EC to initialize first in ACPI
      ACPI: EC: "Fake ECDT" workaround is not needed any longer.
      ACPI: EC: enable burst functionality in EC.
      ACPI: EC: Remove casts to/from void* from ec.c
      ACPI: EC: Put install handlers into separate function.
      ACPI: EC: Clean ECDT and namespace parsing.
      ACPI: EC: Rename ec_ecdt to more informative boot_ec
      ACPI: EC: first_ec is better to be acpi_ec than acpi_device.
      ACPI: EC: Cleanup of EC initialization
      ACPI: EC: Block queries until EC is fully initialized

Bjorn Helgaas (2):
      ACPI: Remove duplicate definitions for _STA bits
      ACPI: use _STA bit names rather than 0x0F

Bob Moore (1):
      ACPICA: clear fields reserved before FADT r3

Borislav Petkov (1):
      ACPI: word-smith kconfig help

Corentin Chary (5):
      asus-laptop: use acpi_evaluate_integer instead of read_acpi_int
      asus-laptop: clean write_status
      asus-laptop: add GLED
      asus-laptop: add wapf param
      asus-laptop: version bump

Daniel Walker (1):
      ACPI: correct pathname in comment

David Brownell (1):
      ACPI: make /proc/acpi/wakeup more useful

Henrique de Moraes Holschuh (50):
      ACPI: ibm-acpi: kill trailing whitespace
      ACPI: ibm-acpi: rename some identifiers
      ACPI: ibm-acpi: add header file
      ACPI: ibm-acpi: organize code
      ACPI: ibm-acpi: update copyright notice
      ACPI: ibm-acpi: update documentation
      ACPI: ibm-acpi: move driver to drivers/misc hierarchy
      ACPI: ibm-acpi: rename driver to thinkpad-acpi
      ACPI: thinkpad-acpi: cleanup Kconfig for thinkpad-acpi
      ACPI: thinkpad-acpi: add compatibility MODULE_ALIAS entry
      ACPI: thinkpad-acpi: cleanup after rename
      ACPI: thinkpad-acpi: update MAINTAINERS
      ACPI: thinkpad-acpi: rename register_ibmacpi_subdriver
      ACPI: thinkpad-acpi: rename one stray use of ibm-acpi in a comment
      ACPI: thinkpad-acpi: rename module glue
      ACPI: thinkpad-acpi: rename thinkpad constants
      ACPI: thinkpad-acpi: update fan firmware documentation
      ACPI: thinkpad-acpi: add debug mode
      ACPI: thinkpad-acpi: clean up probing and move init to subdrivers
      ACPI: thinkpad-acpi: add subdriver debug statements
      ACPI: thinkpad-acpi: uncouple subdriver init from ibms struct
      ACPI: thinkpad-acpi: improve thinkpad detection
      ACPI: thinkpad-acpi: use bitfields to hold subdriver flags
      ACPI: thinkpad-acpi: use bitfields for module flags
      ACPI: thinkpad-acpi: prepare for device model conversion
      ACPI: thinkpad-acpi: mark acpi helper functions __must_check
      ACPI: thinkpad-acpi: clean up hotkey subdriver
      ACPI: thinkpad-acpi: cleanup bluetooth and wan for sysfs conversion
      ACPI: thinkpad-acpi: cleanup video subdriver
      ACPI: thinkpad-acpi: clean up CMOS commands subdriver
      ACPI: thinkpad-acpi: cleanup thermal subdriver for sysfs conversion
      ACPI: thinkpad-acpi: improve fan watchdog messages
      ACPI: thinkpad-acpi: register with the device model
      ACPI: thinkpad-acpi: driver sysfs conversion
      ACPI: thinkpad-acpi: add infrastructure for the sysfs device attributes
      ACPI: thinkpad-acpi: protect fan and hotkey data structures
      ACPI: thinkpad-acpi: add sysfs support to the thermal subdriver
      ACPI: thinkpad-acpi: add sysfs support to fan subdriver
      ACPI: thinkpad-acpi: add a safety net for TPEC fan control mode
      ACPI: thinkpad-acpi: add sysfs support to the cmos command subdriver
      ACPI: thinkpad-acpi: update brightness sysfs interface support
      ACPI: thinkpad-acpi: add a fan-control feature master toggle
      ACPI: thinkpad-acpi: do not arm fan watchdog if it would not work
      ACPI: thinkpad-acpi: fix a fan watchdog invocation
      ACPI: thinkpad-acpi: map ENXIO to EINVAL for fan sysfs
      ACPI: thinkpad-acpi: improve fan control documentation
      ACPI: thinkpad-acpi: improve debugging for acpi helpers
      ACPI: thinkpad-acpi: improve dock subdriver initialization
      ACPI: thinkpad-acpi: add sysfs support to hotkey subdriver
      ACPI: thinkpad-acpi: add sysfs support to wan and bluetooth subdrivers

Ilya A. Volynets-Evenbakh (1):
      ACPI: dock: add access to ACPI docking station UID

Len Brown (1):
      ACPI: sbs: remove i2c_ec.[ch]

Matthias Kaehlcke (1):
      sonypi: use mutex instead of semaphore

Randy Dunlap (1):
      ACPI: dock: use NULL for pointer

Ray Lee (1):
      ACPI: remove duplicate include

Shaohua Li (1):
      ACPI: Disable MSI on request of FADT

Thierry Vignaud (1):
      ACPI: prevent ACPI quirk warning mass spamming in logs

Vladimir Lebedev (5):
      ACPI: sbs: use EC rather than I2C
      ACPI: sbs: remove I2C Kconfig dependency
      ACPI: sbs: remove I2C Makefile hooks
      ACPI: sbs: Debug messages correction/improvement
      ACPI: sbs: Common interface with CM battery

Zachary Amsden (1):
      ACPI: Remove a warning about unused variable in !CONFIG_ACPI compilation.

Zhang Rui (1):
      ACPI: Improve acpi debug documentation

malattia@linux.it (18):
      sony-laptop: Remove ACPI references from variable and function names.
      sony-laptop: Prepare the platform driver for multiple users.
      sony-laptop: Add debug macros also used by the sonypi reimplementation
      sony-laptop: Add SNY6001 device handling (sonypi reimplementation)
      sony-laptop: Unify the input subsystem event forwarding
      sony-laptop: additional platform attributes coming from SNY6001
      sony-laptop: sanitize printks
      sony-laptop: update documentation and Kconfig help
      sony-laptop: sonypi backward compatibility code
      sony-laptop: add camera enable/disable parameter, better handle possible infinite loop
      sony-laptop: add locking on accesses to the ioport and global vars
      sony-laptop: add edge modem support (also called WWAN)
      sonypi: suggest sonypi users to try sony-laptop instead
      sonypi: try to detect if sony-laptop has already taken one of the known ioports
      sony-laptop: complete the motion eye camera support in sony-laptop
      sony-laptop: add a meye-usable include file for camera ops
      meye: make meye use sony-laptop instead of sonypi
      sony-laptop: remove user visible camera controls as platform attributes

with this log:

commit aac60c11132d7ab0776cf036ac9fd6113a210859
Merge: 12a5a71... 79fff27...
Author: Len Brown <len.brown@intel.com>
Date:   Sat Apr 28 23:19:25 2007 -0400

    Pull bugzilla-8346 into release branch

commit 12a5a712123b81a8ba0bc486e2384a375c00f095
Merge: 14d2178... 439a888...
Author: Len Brown <len.brown@intel.com>
Date:   Sat Apr 28 23:16:59 2007 -0400

    Pull sbs into release branch

commit 14d21785885c018611efd8aa75a5c11eaea29087
Merge: 03feb05... 62a6d7f...
Author: Len Brown <len.brown@intel.com>
Date:   Sat Apr 28 23:13:03 2007 -0400

    Pull dock into release branch

commit 03feb0524660bcd890674d11d29a1873ca14d13c
Merge: fb16596... 9fd9f8e...
Author: Len Brown <len.brown@intel.com>
Date:   Sat Apr 28 23:12:56 2007 -0400

    Pull ec into release branch

commit fb16596997ded3e70d308bec58e32c1e2c5cf9b0
Merge: f188291... afd3810...
Author: Len Brown <len.brown@intel.com>
Date:   Sat Apr 28 23:12:03 2007 -0400

    Pull misc-for-upstream into release branch

commit f188291aec9b17ef7cec01db66b9cdb6fae26372
Merge: cfaae3e... 836a53f...
Author: Len Brown <len.brown@intel.com>
Date:   Sat Apr 28 23:11:19 2007 -0400

    Pull thinkpad into release branch
    
    Conflicts:
    
    	drivers/misc/Kconfig
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cfaae3ee4a0d00c6b22780057e958d625499e90c
Merge: eaf60d6... c6c6010...
Author: Len Brown <len.brown@intel.com>
Date:   Sat Apr 28 23:09:57 2007 -0400

    Pull sony into release branch

commit eaf60d6924759eb2a249c0b568533a90c238061b
Merge: de46c33... 8ec555c...
Author: Len Brown <len.brown@intel.com>
Date:   Sat Apr 28 22:18:21 2007 -0400

    Pull asus into release branch

commit c6c60106b9584f17c55e4c5e0ce9b905a1a6cdb6
Author: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Date:   Tue Apr 24 22:02:35 2007 +0200

    sonypi: use mutex instead of semaphore
    
    the Sony Programmable I/O Control driver uses a semaphore as
    mutex. use the mutex API instead of the (binary) semaphore
    
    Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
    Acked-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1b20d34406775369d50fc2ffe27a64a0d6fd313e
Author: malattia@linux.it <malattia@linux.it>
Date:   Sat Apr 28 23:36:40 2007 +0900

    sony-laptop: remove user visible camera controls as platform attributes
    
    Avoid giving the user the possibility to shoot his own foot and let
    the meye driver enable/disable the camera wisely (PCI_ID based).
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cbefb762b67fa6d3eb2a48ae3380358a940e8c9d
Author: malattia@linux.it <malattia@linux.it>
Date:   Sat Apr 28 23:36:26 2007 +0900

    meye: make meye use sony-laptop instead of sonypi
    
    Change sonypi_camera_command() calls to sony_pic_camera_command() and use
    the renamed macros.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1ce82c14d06ff68380d7c647f768858e077930c5
Author: malattia@linux.it <malattia@linux.it>
Date:   Sat Apr 28 23:34:36 2007 +0900

    sony-laptop: add a meye-usable include file for camera ops
    
    Copy and rename (for easier co-existence) the MEYE-wise exported interface.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e364632e740fe9fcb401e5ece3be69e4d81c5a80
Author: malattia@linux.it <malattia@linux.it>
Date:   Sat Apr 28 23:34:22 2007 +0900

    sony-laptop: complete the motion eye camera support in sony-laptop
    
    Add the exported sony_pic_camera_command() function to make the MEYE
    driver happy.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1a3e323907dc5991cba2d715d5db3ae2eac78280
Author: malattia@linux.it <malattia@linux.it>
Date:   Sat Apr 28 23:34:10 2007 +0900

    sonypi: try to detect if sony-laptop has already taken one of the known ioports
    
    Get the IO resources list in sony-laptop in the same order as listed
    in sonypi and make sonypi check if one of those is already busy.
    The sonypi check can be disabled by a module parameter in case the user
    thinks we are plainly wrong (check_ioport=0).
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 74a882e4857414a98ca5904b3be90fb6aba2f25e
Author: malattia@linux.it <malattia@linux.it>
Date:   Sat Apr 28 23:22:11 2007 +0900

    sonypi: suggest sonypi users to try sony-laptop instead
    
    Try to migrate sonypi users to sony-laptop gracefully.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9476cdfae61a3c3fa61d06c18dd002b03671ca9f
Author: malattia@linux.it <malattia@linux.it>
Date:   Sat Apr 28 23:21:42 2007 +0900

    sony-laptop: add edge modem support (also called WWAN)
    
    Some SZ Vaios have a gsm built-in modem. Allow powering on/off this device.
    Thanks to Joshua Wise for the base code.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9f9f0761712928768198278c6cbc5cafe5502d38
Author: malattia@linux.it <malattia@linux.it>
Date:   Sat Apr 28 23:19:36 2007 +0900

    sony-laptop: add locking on accesses to the ioport and global vars
    
    Better avoid having ioport commands mixing and global variables reading/writing.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5f3d2898d79520bc8d8706ed3859060f9cbb969e
Author: malattia@linux.it <malattia@linux.it>
Date:   Sat Apr 28 23:18:45 2007 +0900

    sony-laptop: add camera enable/disable parameter, better handle possible infinite loop
    
    Use a parameter to enable/disable motion eye camera (for C1VE/C1VN models)
    controls and avoid entering an infinite loop if the camera is not present
    and the HW doesn't answer as we expect on io commands.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 836a53f42f3b5d5cb3a0751587ea33801e4b120d
Author: Adrian Bunk <bunk@stusta.de>
Date:   Sat Apr 28 21:19:38 2007 +0200

    thinkpad-acpi: make drivers/misc/thinkpad_acpi:fan_mutex static
    
    This patch makes the needlessly global fan_mutex static.
    
    Signed-off-by: Adrian Bunk <bunk@stusta.de>
    Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d3a6ade4f84416d774c3e5db5faae1840d55bd97
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Fri Apr 27 22:00:17 2007 -0300

    ACPI: thinkpad-acpi: add sysfs support to wan and bluetooth subdrivers
    
    Add support to sysfs to the wan and bluetooth subdrivers.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a0416420e2c6244792d6f308183ad57c40532078
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Fri Apr 27 22:00:16 2007 -0300

    ACPI: thinkpad-acpi: add sysfs support to hotkey subdriver
    
    Add the hotkey sysfs support.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d94a7f16cad7700f8d2b142cc13cfba5387af3db
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Fri Apr 27 22:00:15 2007 -0300

    ACPI: thinkpad-acpi: improve dock subdriver initialization
    
    The dock sub-driver has split-personality (two subdrivers), and it was
    doing some unoptimal things on init because of that.  Fix it so that the
    second half of it will only init when necessary, and only if the first half
    initialized sucessfully in the first place.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5ae930e685018e2dc6d4139362213e4b283e5700
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Fri Apr 27 22:00:14 2007 -0300

    ACPI: thinkpad-acpi: improve debugging for acpi helpers
    
    Some issues with the dock subdriver proved that a slightly improved
    debugging setup for ACPI notifiers and handler helpers would be useful.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b39fe582eb9252dca9a62f7135bcad2e486083e5
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Fri Apr 27 22:00:13 2007 -0300

    ACPI: thinkpad-acpi: improve fan control documentation
    
    Improve fan control documentation and fix one mistake.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c573ddb998456a89a5ccb83a922d2c8ba18484a6
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Fri Apr 27 22:00:12 2007 -0300

    ACPI: thinkpad-acpi: map ENXIO to EINVAL for fan sysfs
    
    Currently, all fan control operations return ENXIO if unsupported
    operations are requested, but return EINVAL if invalid fan modes are
    requested on a given ThinkPad.
    
    This is not strictly correct for sysfs, so map ENXIO to EINVAL in the sysfs
    attribute store handlers, as we do benefit from the ENXIO in other parts of
    the driver code.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ca4ac2f48a4502bbbfcb47b86312273c28194f53
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Fri Apr 27 22:00:11 2007 -0300

    ACPI: thinkpad-acpi: fix a fan watchdog invocation
    
    The fan control watchdog was being called in one place even when the fan
    control operation had failed.  Fix it.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4985cd0a63b0713b6469ef01aae6a0e63ea72f83
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Fri Apr 27 22:00:10 2007 -0300

    ACPI: thinkpad-acpi: do not arm fan watchdog if it would not work
    
    Do not enable/rearm the fan control safety watchdog if we would not be able
    to do anything to the fan anyway.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ecf2a80a97b3d38ae008fa8a3cb98cd540ac1eae
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Fri Apr 27 22:00:09 2007 -0300

    ACPI: thinkpad-acpi: add a fan-control feature master toggle
    
    Len Brown considers that an active by default fan control interface in
    laptops may be too close to giving users enough rope.  There is a good
    chance he is quite correct on this, especially if someone decides to use
    that interface in applets and users are not aware of its risks.
    
    This patch adds a master switch to thinkpad-acpi that enables or disables
    the entire fan-control feature as a module parameter: "fan_control".  It
    defaults to disabled.  Set it to non-zero to enable fan control.
    
    Also, the patch removes the expermiental status from fan control, since it
    is stable enough to not be called experimental, and the master switch makes
    it safe enough to do so.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 79fff270026dc46634563a29b99e4034028ee919
Author: Bob Moore <robert.moore@intel.com>
Date:   Sat Apr 28 20:53:50 2007 -0400

    ACPICA: clear fields reserved before FADT r3
    
    Linux-2.6.21 stopped booting on a P4/HT because Linux
    wrote the FADT.CST_CNT value to the SMI_CMD.
    Apparently this stumbled over some SMM instability,
    such as confusing SMM when invoking it from cpu1.
    
    Linux did this because even though the r2 FADT reserves
    the CST_CNT field, this BIOS set that field and Linux
    used it.
    
    Turns out that up through 2.6.20 we explicitly cleared
    cst_control for r2 FADTs.  So here we go back to doing that,
    plus also clear some additional fields that are reserved
    until FADT r3.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=8346
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit afd3810d9b6b0d446a34e1d4e94f0cc020b00a14
Author: Zachary Amsden <zach@vmware.com>
Date:   Wed Apr 25 15:32:23 2007 -0400

    ACPI: Remove a warning about unused variable in !CONFIG_ACPI compilation.
    
    Signed-off-by: Zachary Amsden <zach@vmware.com>
    Cc: Andi Kleen <ak@suse.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b2983f10f87423fab92326bbe1e92e2256573d4f
Author: Thierry Vignaud <tvignaud@mandriva.com>
Date:   Wed Apr 25 15:31:30 2007 -0400

    ACPI: prevent ACPI quirk warning mass spamming in logs
    
    The following patch prevent this warning to be displayed again & again (eg:
    nine times on my NForce2 motherboard) and thus improve signal to noise
    ratio in logs.
    
    The ATI quirk below probably needs a similar "fix" but I don't have
    the hardware to test.
    
    Btw arch/x86_64/kernel/early-quirks.c::nvidia_bugs() would probably need to
    be synced (but I don't have an x86_64 NVidia motherboard to boot test it).
    Still it shows the usefullity of the recent x86 merge thread.
    
    [akpm@linux-foundation.org: cleanup]
    Signed-off-by: Thierry Vignaud <tvignaud@mandriva.com>
    Signed-off-by: Andi Kleen <ak@suse.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8aa55591bfea25c441117e82711cbfd7c274250a
Author: David Brownell <david-b@pacbell.net>
Date:   Wed Apr 25 15:20:10 2007 -0400

    ACPI: make /proc/acpi/wakeup more useful
    
    This updates /proc/acpi/wakeup to be more informative, primarily by showing
    the sysfs node associated with each wakeup-enabled device.  Example:
    
    	Device	S-state	  Status   Sysfs node
    	PCI0	  S4	 disabled  no-bus:pci0000:00
    	PS2M	  S4	 disabled  pnp:00:05
    	PS2K	  S4	 disabled  pnp:00:06
    	UAR1	  S4	 disabled  pnp:00:08
    	USB1	  S3	 disabled  pci:0000:00:03.0
    	USB2	  S3	 disabled  pci:0000:00:03.1
    	USB3	  S3	 disabled
    	USB4	  S3	 disabled  pci:0000:00:03.3
    	S139	  S4	 disabled
    	LAN	  S4	 disabled  pci:0000:00:04.0
    	MDM	  S4	 disabled
    	AUD	  S4	 disabled  pci:0000:00:02.7
    	SLPB	  S4	*enabled
    
    Eventually this file should be removed, but until then it's almost the only
    way we have to tell how the relevant ACPI tables are broken (and cope).  In
    that example, two devices don't actually exist (USB3, S139), one can't issue
    wakeup events (PCI0), and two seem harmlessly (?) confused (MDM and AUD are
    the same PCI device, but it's the _modem_ that does wake-on-ring).
    
    In particular, we need to be sure driver model nodes are properly hooked
    up before we can get rid of this ACPI-only interface for wakeup events.
    
    Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cf6c6045a06aed2ccd8ebd0a3128ce0f2f8a11aa
Author: Borislav Petkov <bbpetkov@yahoo.de>
Date:   Wed Apr 25 14:29:50 2007 -0400

    ACPI: word-smith kconfig help
    
    Signed-off-by: <bbpetkov@yahoo.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8ce8e2f99a973c39c4aeddbe0966038196a8e71a
Author: Daniel Walker <dwalker@mvista.com>
Date:   Wed Apr 25 14:27:06 2007 -0400

    ACPI: correct pathname in comment
    
    Signed-off-by: Daniel Walker <dwalker@mvista.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0c0e8921018dbb4fe189a1034f80ac32553bc7bc
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Wed Apr 25 14:20:58 2007 -0400

    ACPI: use _STA bit names rather than 0x0F
    
    Be explicit about what "device->status = 0x0F" really means.
    
    syntax only.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a0bd4ac498acfe60f7533d15ba60d5efdd4e9ca5
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Wed Apr 25 14:17:39 2007 -0400

    ACPI: Remove duplicate definitions for _STA bits
    
    No need to duplicate the existing definitions in include/acpi/actypes.h.
    
    syntax only -- no functional change.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d8938801d10945ac2fbe0f41ded43f6276660a17
Author: Ray Lee <ray-lk@madrabbit.org>
Date:   Wed Apr 25 14:12:00 2007 -0400

    ACPI: remove duplicate include
    
    Thomas's patch for including <asm/apic.h> for x86 UP builds came into
    Linus's tree from two different directions, both of which were merged.
    This reverts the latter, yanking out the duplicate #include and comment.
    
    Signed-off-by: Ray Lee <ray-lk@madrabbit.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7d5a015eece8be9186d3613d595643a520555e33
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Apr 24 11:48:20 2007 -0300

    ACPI: thinkpad-acpi: update brightness sysfs interface support
    
    Update the brightness sysfs interface (done through the backlight class) to
    be in line with the rest of the thinkpad-acpi driver.
    
    This renames the incorrect, un-obvious, and clash-prone name of "ibm" for
    the backlight device to a much more fitting and descriptive
    "thinkpad_screen".  This is something I wanted to do for quite a while...
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b616004c70dd7f60a1477c3e9d6fddd00ee1fa37
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Apr 24 11:48:19 2007 -0300

    ACPI: thinkpad-acpi: add sysfs support to the cmos command subdriver
    
    Add sysfs attributes to send ThinkPad CMOS commands.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit eaa7571b2d1a08873e4bdd8e6db3431df61cd9ad
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Apr 24 11:48:18 2007 -0300

    ACPI: thinkpad-acpi: add a safety net for TPEC fan control mode
    
    The Linux ThinkPad community is not positive that all ThinkPads that do
    HFSP EC fan control do implement full-speed and auto modes, some of the
    earlier ones supporting HFSP might not.
    
    If the EC ignores the AUTO or FULL-SPEED bits, it will pay attention to the
    lower three bits that set the fan level.  And as thinkpad-acpi was leaving
    these set to zero, it would stop(!) the fan, which is Not A Good Thing.
    
    So, as a safety net, we now make sure to also set the fan level part of the
    HFSP register to speed 7 for full-speed, and a minimum of speed 4 for auto
    mode.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fe98a52ce7540fb3a19d57488a08864110cf4d5c
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Apr 24 11:48:17 2007 -0300

    ACPI: thinkpad-acpi: add sysfs support to fan subdriver
    
    Export sysfs attributes to monitor and control the internal thinkpad fan
    (some thinkpads have more than one fan, but thinkpad-acpi doesn't support
    the second fan yet).  The sysfs interface follows the hwmon design guide
    for fan devices.
    
    Also, fix some stray "thermal" files in the fan procfs description that
    have been there forever, and officially support "full-speed" as the name
    for the PWM-disabled state of the fan controller to keep it in line with
    the hwmon interface.  It is much better a name for that mode than the
    unobvious "disengaged" anyway.  Change the procfs interface to also accept
    full-speed as a fan level, but still report it as disengaged for backwards
    compatibility.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2c37aa4e22dd55070c608290c5031f2ee93e69ce
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Apr 24 11:48:16 2007 -0300

    ACPI: thinkpad-acpi: add sysfs support to the thermal subdriver
    
    Export thinkpad thermal sensors to sysfs, following the hwmon
    specification for thermal monitoring sensors.
    
    ThinkPad thermal monitoring is done by the EC.  Sensors can show up or
    disappear at runtime when they are inside hotswappable hardware, such as
    batteries.  Sensors that are not available return -ENXIO when accessed.
    
    Up to 16 thermal sensors are supported on new firmware (but nobody has
    reported a ThinkPad with more than 12 sensors so far), and 8 sensors are
    supported on older firmware.  Thermal sensor mapping is model-specific.
    Precision varies, it is 1 degree Celcius on new ThinkPads, but higher on
    some older models.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 40ca9fdf8aa7d929e2b8939be1e6380d107381e1
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Apr 24 11:48:15 2007 -0300

    ACPI: thinkpad-acpi: protect fan and hotkey data structures
    
    Add proper mutex locking to some data structures access subject to races
    due to concurrent access of driver functions on the hotkey and fan
    subdrivers.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7252374a39d794879f5e47bcfa0a16e7599b27b5
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Apr 24 11:48:14 2007 -0300

    ACPI: thinkpad-acpi: add infrastructure for the sysfs device attributes
    
    Add infrastructure to deal with sysfs attributes and grouping, and helpers
    for common sysfs parsing.  Switch driver attributes to use them.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 176750d68801bfa4a88d1cf54174aa0347d7e5d8
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Apr 24 11:48:13 2007 -0300

    ACPI: thinkpad-acpi: driver sysfs conversion
    
    Add the sysfs attributes for the platform driver.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 54ae15014c306b3d7ad32c996fea9a5ac8560b60
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Apr 24 11:48:12 2007 -0300

    ACPI: thinkpad-acpi: register with the device model
    
    Register thinkpad-acpi platform driver and platform device for the device
    model.  Also register the platform device with the hwmon class.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f989106cac719f8fe91da7734e73b3ca09146ecc
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Tue Apr 24 13:53:22 2007 +0800

    ACPI: Improve acpi debug documentation
    
    Now we use acpi.debug_level and acpi.debug_layer as kernel boot
    parameters instead of acpi_dbg_level and acpi_dbg_layer.
    Thanks to Andi Kleen for pointing it out.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f8993aff8b4de0317c6e081802ca5c86c449fef2
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Wed Apr 25 11:05:12 2007 +0800

    ACPI: Disable MSI on request of FADT
    
    The ACPI spec defines the bit and Microsoft uses it,
    so Linux must use it too.
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 99fba3f8177956170f3d86f83c2cf2f70747105f
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 21 11:08:44 2007 -0300

    ACPI: thinkpad-acpi: improve fan watchdog messages
    
    Improve some of the fan watchdog error messages to be a little more
    helpful.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 04cc862c1893a055ab1117fa6f3aa0886c0ba032
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 21 11:08:43 2007 -0300

    ACPI: thinkpad-acpi: cleanup thermal subdriver for sysfs conversion
    
    Clean-up the thermal subdriver for sysfs conversion.  Make thermal_get_*
    reentrancy-safe while at it, and add the missing thermal_read_mode variable
    to the header file.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c9bea99c1a712548db3437cbca52b0da8f30069c
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 21 11:08:42 2007 -0300

    ACPI: thinkpad-acpi: clean up CMOS commands subdriver
    
    Some ThinkPad CMOS commands subdriver cleanups, and also rename/promote
    cmos_eval to a ACPI helper function, as it is used by many other
    subdrivers.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 83f34724643a3b0ec9322490b9ad9f1b60170a6c
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 21 11:08:41 2007 -0300

    ACPI: thinkpad-acpi: cleanup video subdriver
    
    Cleanup video subdriver for sysfs conversion, and properly check
    result status of acpi_evalf.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d6fdd1e91a8a4cd852dc1d945165e3a69ac9e257
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 21 11:08:40 2007 -0300

    ACPI: thinkpad-acpi: cleanup bluetooth and wan for sysfs conversion
    
    Prepare bluetooth and wan driver code to be more easily hooked into sysfs
    helpers, by separating the procfs logic from the device attribute handling.
    
    These changes also remove the entries from procfs on notebooks without the
    bluetooth/wan hardware installed.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b86c4722de62f336b82dff3c47ef59ba2a587ec1
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 21 11:08:39 2007 -0300

    ACPI: thinkpad-acpi: clean up hotkey subdriver
    
    Cleanup hotkey subdriver code.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d01320e606d334a0cd35d781a58f9f3c254829ab
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 21 11:08:38 2007 -0300

    ACPI: thinkpad-acpi: mark acpi helper functions __must_check
    
    Mark acpi_evalf and friends __must_check.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8d376cd6543d57ef10799be02ba5f19aa6678032
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 21 11:08:37 2007 -0300

    ACPI: thinkpad-acpi: prepare for device model conversion
    
    Prepare the thinkpad-acpi driver for the conversion to the device
    model, by renaming variables and doing other glue work that shall
    make the later patches much cleaner.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d8fd94d9f08237ffda7e44e6825b057bf20a90e3
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 21 11:08:36 2007 -0300

    ACPI: thinkpad-acpi: use bitfields for module flags
    
    Use a bitfield to hold boolean module-wide flags, to conserve some memory.
    It is easy and it is clean, so we do it just for the heck of it even if it
    saves very little space.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 926411779287ad4f7013c9d80aa44fd131b70cd9
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 21 11:08:35 2007 -0300

    ACPI: thinkpad-acpi: use bitfields to hold subdriver flags
    
    Save some memory by using bitfields to hold boolean flags for the
    subdrivers.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0dcef77c5b889338811d35e786b42046259fe433
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 21 11:08:34 2007 -0300

    ACPI: thinkpad-acpi: improve thinkpad detection
    
    Improve the detection of ThinkPads, so as to reduce the chances of false
    positives.
    
    Since this could potentially add false negatives on the very old models,
    add a module parameter to force the detection of a thinkpad.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a5763f2223ce3fdbc75923f8c948fc7b59ed2f96
Author: Henrique de Moraes Holschuh <hmh@debian.org>
Date:   Sat Apr 21 11:08:33 2007 -0300

    ACPI: thinkpad-acpi: uncouple subdriver init from ibms struct
    
    Move the .init method from ibms struct to another struct, and use a list
    head to control which subdrivers have been activated.
    
    This allows us to have the subdriver init methods marked __init, saving
    quite a lot of .text size, and even a bit of .data size as some data can
    now be made __initdata.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fe08bc4b4fd1371fad111675a564e4d2ebbf39ea
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 21 11:08:32 2007 -0300

    ACPI: thinkpad-acpi: add subdriver debug statements
    
    Add debug messages to the subdriver initialization and exit code.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5fba344cfdbaa79e6320da26c3db34dfb219a845
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 21 11:08:31 2007 -0300

    ACPI: thinkpad-acpi: clean up probing and move init to subdrivers
    
    Move most of the probing code to its own function, and most of the
    subdriver-specific init code into subdriver init functions.
    
    This allows us to not define pci_handle unless the dock subdriver is
    enabled, as well.
    
    This patch causes a minor userland interface change: if a subdriver doesn't
    detect a capability, /proc entries for it are not created anymore (as
    opposed to a /proc entry that just returned "unsupported").
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 132ce09123755ec5e3d3a8ae22f4f753c3baac97
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 21 11:08:30 2007 -0300

    ACPI: thinkpad-acpi: add debug mode
    
    Add a debug mode parameter and verbose debug mode Kconfig option.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f51d1a39840ae5e8678d702ab57377c611fc3826
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 21 11:08:29 2007 -0300

    ACPI: thinkpad-acpi: update fan firmware documentation
    
    Update some stuff in the in-code text describing the ThinkPad fan
    firmware.  This patch has no code changes.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit efa27145df34eacf2569bd45f68dbe00003d3616
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 21 11:08:28 2007 -0300

    ACPI: thinkpad-acpi: rename thinkpad constants
    
    Rename all IBMACPI_ constants, now that we are not called ibm-acpi anymore.
    Driver-specific constants are now prefixed TPACPI_, ThinkPad firmware
    specific ones are now prefixed TP_CMOS_, TP_ACPI_, or TP_EC_.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1def7115f0277ce9d2a54efd0ae187aa88d5c7fa
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 21 11:08:27 2007 -0300

    ACPI: thinkpad-acpi: rename module glue
    
    Rename module init and exit functions, now that we are not called ibm-acpi
    anymore.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 142cfc90f026b0b8fd1a14ba11ae29eb7b1b6ca1
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 21 11:08:26 2007 -0300

    ACPI: thinkpad-acpi: rename one stray use of ibm-acpi in a comment
    
    Rename a stray use of ibm-acpi on a comment, no functional changes.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6700121b535fa16fe1c8aaac03559b2f12909726
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat Apr 21 11:08:25 2007 -0300

    ACPI: thinkpad-acpi: rename register_ibmacpi_subdriver
    
    Rename register_ibmacpi_subdriver to register_tpacpi_subdriver, as
    we are not called ibmacpi anymore.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7b153f366867a3b70daeaf3c6074e4a0594057a7
Author: malattia@linux.it <malattia@linux.it>
Date:   Mon Apr 9 19:31:25 2007 +0200

    sony-laptop: sonypi backward compatibility code
    
    Compatibility code to allow old sonypi bound userspace apps to still work.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3d2b8a9f2c26bc0fe03b3545d07245798b1b81b9
Author: malattia@linux.it <malattia@linux.it>
Date:   Mon Apr 9 19:31:16 2007 +0200

    sony-laptop: update documentation and Kconfig help
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f6119b027578c21b544a98fd67e5f0b7e4fbea7d
Author: malattia@linux.it <malattia@linux.it>
Date:   Mon Apr 9 19:31:06 2007 +0200

    sony-laptop: sanitize printks
    
    Unify printks to resemble a unique driver.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 49a11deade3c1d9e2d7c88d25899b3a9174d048e
Author: malattia@linux.it <malattia@linux.it>
Date:   Mon Apr 9 19:28:56 2007 +0200

    sony-laptop: additional platform attributes coming from SNY6001
    
    Register additional platform attributes coming from the SPIC (sonypi) driver.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1549ee6fb122400c0767b5f3da2c42abbc4f750a
Author: malattia@linux.it <malattia@linux.it>
Date:   Mon Apr 9 10:19:08 2007 +0200

    sony-laptop: Unify the input subsystem event forwarding
    
    SNC and SPIC events are forwarded to the same input devices
    and are thus handled together.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 33a04454527edd33d4a6332a2944d2b4f46fbb18
Author: malattia@linux.it <malattia@linux.it>
Date:   Mon Apr 9 19:26:03 2007 +0200

    sony-laptop: Add SNY6001 device handling (sonypi reimplementation)
    
    Reimplement sonypi using ACPI only functions.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b9a218b738c5c2387f666731b81a4376021d681e
Author: malattia@linux.it <malattia@linux.it>
Date:   Mon Apr 9 10:19:06 2007 +0200

    sony-laptop: Add debug macros also used by the sonypi reimplementation
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 56b8756b3bc8812837a21f3e066dba1b489e071e
Author: malattia@linux.it <malattia@linux.it>
Date:   Mon Apr 9 10:19:05 2007 +0200

    sony-laptop: Prepare the platform driver for multiple users.
    
    Both the SNC and SPIC device drivers will create attributes and thus
    there's the need to have an internal usage count to avoid
    re-registering or de-registering at the wrong time.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 59b19106f3f20487093ea06c8220426147cf7835
Author: malattia@linux.it <malattia@linux.it>
Date:   Mon Apr 9 10:19:04 2007 +0200

    sony-laptop: Remove ACPI references from variable and function names.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 756970ad4bb93027a60da2de9b43d094b7f387a2
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Thu Mar 29 01:58:44 2007 -0300

    ACPI: thinkpad-acpi: update MAINTAINERS
    
    Update MAINTAINERS file for the ibm-acpi -> thinkpad-acpi renaming.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 643f12dbb660e139fbaea268f3e3ce4d7d594b8f
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Thu Mar 29 01:58:43 2007 -0300

    ACPI: thinkpad-acpi: cleanup after rename
    
    Cleanup documentation, driver strings and other misc stuff, now that the
    driver is named "thinkpad-acpi".
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d903ac5455102b13d0e28d6a39f640175fb4cd4d
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Thu Mar 29 01:58:42 2007 -0300

    ACPI: thinkpad-acpi: add compatibility MODULE_ALIAS entry
    
    Add a ibm_acpi module alias for userpace, so that modprobe ibm_acpi will
    still load the correct driver.  This alias can be removed in the future,
    probably two years from now if nothing warrants removing it sooner.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 85998248b2e8c6ae7d3ad1fa7b059aed22205ec4
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Thu Mar 29 01:58:41 2007 -0300

    ACPI: thinkpad-acpi: cleanup Kconfig for thinkpad-acpi
    
    Since ibm-acpi was renamed to thinkpad-acpi, rename and update its Kconfig
    entries and Kconfig-related symbols accordingly.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f21f85de4b3b9ad4a671fb19a889c16db2ea38b2
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Thu Mar 29 01:58:40 2007 -0300

    ACPI: ibm-acpi: rename driver to thinkpad-acpi
    
    Rename the ibm-acpi driver to thinkpad-acpi.  ThinkPads are not even made
    by IBM anymore, so it is high time to rename the driver...
    
    The name thinkpad-acpi was used sometime ago by a thinkpad-specific hotkey
    driver by Erik Rigtorp, around the 2.6.8-2.6.10 time frame.  The driver
    apparently never got merged into mainline (it did make some trips through
    -mm).  ibm-acpi was merged soon after, making its debut in 2.6.10.
    
    The reuse of the thinkpad-acpi name shouldn't be a problem as far as user
    confusion goes, as Erik's thinkpad-acpi apparently didn't get widespread
    use in the Linux ThinkPad community and most hits for thinkpad-acpi in
    google point to ibm-acpi anyway.
    
    Erik, if you read this, please consider the reuse of the thinkpad-acpi name
    as a compliment to your effort to make ThinkPads more useful to all of us.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 62a6d7fd9bc1d85f9aae734c46234e88fa839db0
Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Mon Mar 26 21:38:49 2007 -0800

    ACPI: dock: use NULL for pointer
    
    Use NULL instead of 0 for pointers:
    drivers/acpi/dock.c:677:75: warning: Using plain integer as NULL pointer
    
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3ede41c718c7845905231019e42d05a3ed329515
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Fri Mar 23 17:34:00 2007 -0300

    ACPI: ibm-acpi: move driver to drivers/misc hierarchy
    
    ibm-acpi is not an ACPICA driver, so move it to drivers/misc as per Len
    Brown's request.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 38f996ed21089fa4ae40526a5f428e3c792ea561
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Fri Mar 23 17:33:59 2007 -0300

    ACPI: ibm-acpi: update documentation
    
    Update documentation header, and relocate a hunk of text that was missplaced.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a62bc916cf48caaf9efa2fed20440fd617647c6c
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Fri Mar 23 17:33:58 2007 -0300

    ACPI: ibm-acpi: update copyright notice
    
    Update copyright and license info on the source code comments.  No
    functional changes.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 56b6aeb05890f219895197f5166637b3d7a6f679
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Fri Mar 23 17:33:57 2007 -0300

    ACPI: ibm-acpi: organize code
    
    Shuffle code around to better organize the driver code inside the
    ibm-acpi.c file.
    
    This patch adds no functional changes.  It is pure fluff that will make me
    a bit more productive.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1406cdd1760743106278c1f02a0f445159c8f400
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Fri Mar 23 17:33:56 2007 -0300

    ACPI: ibm-acpi: add header file
    
    Add a (private) header file for ibm-acpi, and move type definitions and
    ThinkPad driver constants to the new header file.
    
    This patch has no functional changes.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e062e0343871a41e8ec408f1c1e8ac3b0310da9d
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Fri Mar 23 17:33:55 2007 -0300

    ACPI: ibm-acpi: rename some identifiers
    
    Rename some identifiers so that they are more in tune with the rest of the
    driver code, or less generic.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 837ca6ddb440c186eaa8e01b69486581d3457f2c
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Fri Mar 23 17:33:54 2007 -0300

    ACPI: ibm-acpi: kill trailing whitespace
    
    I shall protect the ibm-acpi city against the invasion of the barbarian
    blanks!  To the unforgiving jaws of sed s/[[:blank:]]\+$// they go!
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 439a888885c584f7ac8536a43be80475f9eaed71
Author: Len Brown <len.brown@intel.com>
Date:   Thu Mar 22 01:21:05 2007 -0400

    ACPI: sbs: remove i2c_ec.[ch]
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 722062334b972c31a3b83dbf7e9b5a58bb2707dd
Author: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
Date:   Mon Mar 19 17:45:50 2007 +0300

    ACPI: sbs: Common interface with CM battery
    
    The SBS driver has tne features as CM battery:
    SBS update_time variable has tne same definition as CM battery 'update_time' variable.
    
    Signed-off-by: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6845118b3b7a9cc2ba14dc665370217bc3ba8057
Author: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
Date:   Mon Mar 19 17:45:50 2007 +0300

    ACPI: sbs: Debug messages correction/improvement
    
    Debug messages correction/improvement:
    Use ACPI_EXCEPTION instead of ACPI_DEBUG_PRINT.
    
    Signed-off-by: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 84cb55987236ffea062a35fbe1441768b6bb2722
Author: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
Date:   Mon Mar 19 17:45:50 2007 +0300

    ACPI: sbs: remove I2C Makefile hooks
    
    SBS does not depend on I2C.
    i2c_ec.h and i2c_ec.c are not needed
    
    Signed-off-by: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b4150fc4ae20621edf2f8e1ea5ce13eb2c803e7a
Author: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
Date:   Mon Mar 19 17:45:50 2007 +0300

    ACPI: sbs: remove I2C Kconfig dependency
    
    SBS does not depend on I2C.
    
    Signed-off-by: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6d15702cc07503b74494dc4f1ddb15f354987b14
Author: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
Date:   Mon Mar 19 17:45:50 2007 +0300

    ACPI: sbs: use EC rather than I2C
    
    SBS is based on EC function(ec_read/ec_write).
    Not needed using of I2C structures/functions ... is removed.
    SBS does not depend on I2C now.
    
    Signed-off-by: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8ec555c2c4c6c33759a1dbb13fa8f3b14fc77e10
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Sun Mar 11 10:28:03 2007 +0100

    asus-laptop: version bump
    
    Version and copyright bump.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 185e5af98b1e09b1e0f859332243223776b2ad57
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Sun Mar 11 10:27:33 2007 +0100

    asus-laptop: add wapf param
    
    Add the "wapf" param. This param allows to define the behavior
    of  the Fn F2 key (wlan switch).
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fdd8d08084663242b42e27f7d71739f3f9009286
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Sun Mar 11 10:26:48 2007 +0100

    asus-laptop: add GLED
    
    Add support for "gaming" led.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 935ffeeca84fe5d48d0cc9f35c58db42b384229f
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Sun Mar 11 10:26:12 2007 +0100

    asus-laptop: clean write_status
    
    Clean the write_status function, and implement special case with
    a switch inside write_status. It also make sure bt and wl status
    are right when booting with the hardware switch off.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9a8168500674b1062afe438d34d0c8216d38dc31
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Sun Mar 11 10:25:38 2007 +0100

    asus-laptop: use acpi_evaluate_integer instead of read_acpi_int
    
    Use acpi_evaluate_integer() instead of read_acpi_int()
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9fd9f8e8bdcfc9aa309dae5bccc55d02804337d0
Author: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
Date:   Wed Mar 7 22:28:00 2007 +0300

    ACPI: EC: Block queries until EC is fully initialized
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 01f2246269639f6aa93086719a8dbec26cb68e98
Author: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
Date:   Wed Mar 7 22:28:00 2007 +0300

    ACPI: EC: Cleanup of EC initialization
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d033879c9838b960014e861d0eb3bdf11d3b9d9d
Author: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
Date:   Wed Mar 7 22:28:00 2007 +0300

    ACPI: EC: first_ec is better to be acpi_ec than acpi_device.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d66d969df88c742494736ed06eeaf3229d3a7259
Author: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
Date:   Wed Mar 7 22:28:00 2007 +0300

    ACPI: EC: Rename ec_ecdt to more informative boot_ec
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c0900c3512dc8fd0b37f8fbcebc7853ed9efff10
Author: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
Date:   Wed Mar 7 22:28:00 2007 +0300

    ACPI: EC: Clean ECDT and namespace parsing.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e8284321048aac7be307b3ec5e0631f5c514935a
Author: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
Date:   Wed Mar 7 22:28:00 2007 +0300

    ACPI: EC: Put install handlers into separate function.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3d02b90be2c7bc7ffbc5e502a135c13838d23ef4
Author: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
Date:   Wed Mar 7 22:28:00 2007 +0300

    ACPI: EC: Remove casts to/from void* from ec.c
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c45aac43fec2d6ca8d0be8408f94e8176c8110ef
Author: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
Date:   Wed Mar 7 22:28:00 2007 +0300

    ACPI: EC: enable burst functionality in EC.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 33c7a0738c5f753a7d94fd3b2ec7d84e79a141a8
Author: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
Date:   Wed Mar 7 22:28:00 2007 +0300

    ACPI: EC: "Fake ECDT" workaround is not needed any longer.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 33d20b6100d05a0b14883e7dc8ab41e4531fcf59
Author: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
Date:   Wed Mar 7 22:28:00 2007 +0300

    ACPI: EC: Make EC to initialize first in ACPI
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a5f8dee2d367e69fd57f5ea107072bb72eb15327
Author: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
Date:   Wed Mar 7 22:27:59 2007 +0300

    ACPI: EC: Don't use Global Lock if not asked to do so
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ac122bb64b0d51f0512185d3522a75f3f3a80bc9
Author: Ilya A. Volynets-Evenbakh <ilya@total-knowledge.com>
Date:   Mon Feb 19 15:19:31 2007 -0800

    ACPI: dock: add access to ACPI docking station UID
    
    It is useful to know whether your laptop is docked or not,
    but it is even more useful to know which docking station it's
    docked to. Attached patch adds "uid" file to sysfs.
    Tested on Dell Latitude D600 with D/Dock.
    Patch is against official 2.6.20 release.
    
    Signed-off-by: Len Brown <len.brown@intel.com>
