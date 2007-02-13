Return-Path: <linux-kernel-owner+w=401wt.eu-S1751201AbXBMIlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201AbXBMIlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 03:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbXBMIlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 03:41:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:36079 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbXBMIld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 03:41:33 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PATCH] ACPI patches for 2.6.21 - part II
Date: Tue, 13 Feb 2007 03:38:59 -0500
User-Agent: KMail/1.9.5
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702130339.20001.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This...

adds the sony-laptop driver, which controls brightness on akpm's vaio...
removes the experimental hotkey driver, per schedule.
adds the ACPI support needed by the upcoming rtc driver
fixes a suspend regression caused by part I
fixes an IA64 processor driver regression caused by part I
fixes some battery-related bugs

... and updates the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.20/acpi-release-20070126-2.6.20.diff.gz

 Documentation/acpi-hotkey.txt              |   38 
 Documentation/feature-removal-schedule.txt |   23 
 Documentation/sony-laptop.txt              |  106 +
 MAINTAINERS                                |    9 
 arch/i386/kernel/acpi/boot.c               |    5 
 arch/x86_64/kernel/early-quirks.c          |    4 
 arch/x86_64/pci/mmconfig.c                 |    4 
 drivers/acpi/Makefile                      |    1 
 drivers/acpi/ac.c                          |    9 
 drivers/acpi/acpi_memhotplug.c             |    9 
 drivers/acpi/asus_acpi.c                   |   20 
 drivers/acpi/battery.c                     |   24 
 drivers/acpi/bay.c                         |  105 -
 drivers/acpi/bus.c                         |   15 
 drivers/acpi/button.c                      |    7 
 drivers/acpi/cm_sbs.c                      |    2 
 drivers/acpi/container.c                   |    9 
 drivers/acpi/debug.c                       |    2 
 drivers/acpi/dock.c                        |    8 
 drivers/acpi/ec.c                          |    5 
 drivers/acpi/event.c                       |    2 
 drivers/acpi/events/evgpe.c                |   11 
 drivers/acpi/fan.c                         |    9 
 drivers/acpi/glue.c                        |   89 +
 drivers/acpi/hardware/hwsleep.c            |   13 
 drivers/acpi/hotkey.c                      | 1042 -----------------
 drivers/acpi/i2c_ec.c                      |    5 
 drivers/acpi/ibm_acpi.c                    |   18 
 drivers/acpi/numa.c                        |   18 
 drivers/acpi/osl.c                         |   13 
 drivers/acpi/pci_bind.c                    |    2 
 drivers/acpi/pci_irq.c                     |    2 
 drivers/acpi/pci_link.c                    |    5 
 drivers/acpi/pci_root.c                    |    5 
 drivers/acpi/power.c                       |    5 
 drivers/acpi/processor_core.c              |   11 
 drivers/acpi/processor_idle.c              |    3 
 drivers/acpi/processor_perflib.c           |    3 
 drivers/acpi/processor_thermal.c           |    3 
 drivers/acpi/processor_throttling.c        |    3 
 drivers/acpi/sbs.c                         |   25 
 drivers/acpi/scan.c                        |    3 
 drivers/acpi/sleep/main.c                  |    3 
 drivers/acpi/system.c                      |    3 
 drivers/acpi/tables.c                      |   41 
 drivers/acpi/thermal.c                     |    7 
 drivers/acpi/toshiba_acpi.c                |    6 
 drivers/acpi/utils.c                       |    2 
 drivers/acpi/video.c                       |    9 
 drivers/misc/Kconfig                       |   15 
 drivers/misc/Makefile                      |    1 
 drivers/misc/asus-laptop.c                 |    5 
 drivers/misc/sony-laptop.c                 |  562 +++++++++
 drivers/usb/misc/appledisplay.c            |    4 
 include/acpi/acpi_drivers.h                |   40 
 include/asm-i386/acpi.h                    |    1 
 include/linux/acpi.h                       |    8 
 57 files changed, 992 insertions(+), 1410 deletions(-)

through these commits:

Ahmed S. Darwish (1):
      ACPI: toshiba_acpi: Use ARRAY_SIZE macro when appropriate

Al Viro (1):
      ACPI: bay: fix wrong order of kzalloc arguments

Alessandro Guido (2):
      sony_acpi: Add backlight support to the sony_acpi
      sony_acpi: Add backlight support to the sony_acpi v2

Alexey Starikovskiy (4):
      ACPI: Disable GPEs in preparation for sleep.
      ACPI: invoke acpi_sleep_init() earlier
      ACPI: IA64: fix calculation of apic_id
      ACPI: Disable wake GPEs only once.

Andrew Morton (4):
      ACPI: bay: fix build warning
      sony_acpi: Avoid dimness on resume.
      sony_acpi: Fix sony_acpi_resume call
      sony_acpi: Video sysfs support take 2

David Brownell (1):
      ACPI: updates rtc-cmos device platform_data

Henrique de Moraes Holschuh (1):
      ACPI: ibm-acpi: cleanup init and exit paths

Kristen Carlson Accardi (1):
      ACPI: bay: remove ACPI driver struct

Len Brown (9):
      ACPI: add video driver MAINTAINER
      ACPI: clean up ACPI_MODULE_NAME() use
      ACPI: fix acpi_driver.name usage
      ACPI: delete extra #defines in /drivers/acpi/ drivers
      ACPI: hotkey: remove driver, per feature-removal-schedule.txt
      ACPI: acpi_table_parse() now returns success/fail, not count
      ACPI: acpi_madt_entry_handler() is not MADT specific
      ACPI: acpi_table_parse_madt_family() is not MADT specific
      sony-laptop: Lindent

Matthew C Campbell (1):
      ACPI: asus_acpi: Add support for Asus Z81SP

Mattia Dongili (11):
      sony_acpi: Allow easier debugging for the unknown SNC methods.
      sony_acpi: Add lanpower and audiopower controls
      sony_acpi: Allow multiple sony_acpi_values for the same .name
      sony_acpi: Fix sony_acpi backlight registration and unregistration
      sony-laptop: create from sony_acpi
      sony-laptop: Remove /proc/acpi/sony interface and implement platform_device.
      sony-laptop: Small update to the Kconfig help to make people believe this driver is useful.
      sony-laptop: Group functions and structures to better draw subsytems usage
      sony-laptop: Update docs
      sony-laptop: add to MAINTAINERS
      sony-laptop: allow complex per-value input/output validation

Michael Hanselmann (1):
      ACPI: video: Fix null pointer in appledisplay driver

Rusty Russell (1):
      ACPI: cleanup: make disable_acpi() valid w/o CONFIG_ACPI

Stelian Pop (2):
      sony_acpi: SNC device support for Sony Vaios
      sony_acpi: Add acpi_bus_generate event

Vladimir Lebedev (2):
      ACPI: battery: check for battery present on /proc/battery access
      ACPI: sbs: fix present rate

with this log:

commit d9810b54a7949d89f41a05a24365f17ee8152c75
Merge: 8bae188... 2b8923d...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Feb 13 03:17:43 2007 -0500

    Merge branch 'remove-hotkey' into release

commit 8bae188852cbde59ad33a3f0edf30d671ccfbe43
Merge: 5a7b2fa... 156c221...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Feb 13 03:17:21 2007 -0500

    Merge branch 'sony' into release

commit 5a7b2faa11703f26c4fb91d42f5d8056cb7b3a38
Merge: 13d20c2... 6eb87fe...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Feb 13 03:17:06 2007 -0500

    Merge branch 'fluff' into release
    
    Conflicts:
    
    	drivers/acpi/bay.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 13d20c2a68113ab7466c30e54d3ce24a7fb72da6
Merge: 30095b7... 4bd35cd... aafbcd1... e6d0f56...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Feb 13 03:11:32 2007 -0500

    Merge branches 'bugzilla-7200', 'bugzilla-7887' and 'bugzilla-7897' into release

commit 30095b751bb09fc15ea9abf2d180e3fa5fecf60a
Merge: ec2f9d1... f3ccb06...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Feb 13 03:11:09 2007 -0500

    Merge branch 'misc-for-upstream' into release
    
    Conflicts:
    
    	drivers/usb/misc/appledisplay.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 156c221b728ccd4657c359cd25428946856beca8
Author: Mattia Dongili <malattia@linux.it>
Date:   Mon Feb 12 22:01:07 2007 +0100

    sony-laptop: allow complex per-value input/output validation
    
    Replace sony_acpi_value.{min,max} with a callback function that allows
    more complex reasoning in accepting input and presenting output.
    
    This allows consistency between the sony-laptop specific 'brightness_default'
    and the backlight subsystem 0-based 'brightness'.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0d477faca3a661908378b602c3d12df73c922c9f
Author: Mattia Dongili <malattia@linux.it>
Date:   Thu Feb 8 20:16:40 2007 +0100

    sony-laptop: add to MAINTAINERS
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ab5bd20696485a3f8c2f27058ace1cc1d6b580b3
Author: Mattia Dongili <malattia@linux.it>
Date:   Thu Feb 8 20:16:41 2007 +0100

    sony-laptop: Update docs
    
    Update documentation to be consistent with current implementation
    (backlight subsys and platform_device).
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a02d1c1d2aa8ad4b2ed8da25e234c8962973f1b8
Author: Len Brown <len.brown@intel.com>
Date:   Wed Feb 7 15:34:02 2007 -0500

    sony-laptop: Lindent
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d78865cdb096781382074943c1b7781696b178a6
Author: Mattia Dongili <malattia@linux.it>
Date:   Wed Feb 7 20:01:56 2007 +0100

    sony-laptop: Group functions and structures to better draw subsytems usage
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 287ddfd522097257dadf37deb21969ad4dbc8148
Author: Mattia Dongili <malattia@linux.it>
Date:   Wed Feb 7 20:01:55 2007 +0100

    sony-laptop: Small update to the Kconfig help to make people believe this driver is useful.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ed3aa4b729478978f117269b5266a2d18948912c
Author: Mattia Dongili <malattia@linux.it>
Date:   Wed Feb 7 20:01:54 2007 +0100

    sony-laptop: Remove /proc/acpi/sony interface and implement platform_device.
    
    Rework method names list to allow an easier management of multiple
    values.
    Add myself as author/maintainer and bump the version number.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 91fbc1d311c1b8b71203b96f1a0629da7360eb4c
Author: Mattia Dongili <malattia@linux.it>
Date:   Wed Feb 7 20:01:53 2007 +0100

    sony-laptop: create from sony_acpi
    
    Move drivers/acpi/sony_acpi.c to drivers/misc/sony-laptop.c with all the
    necessary configuration.
    The SONY_LAPTOP config option substitutes the old ACPI_SONY and is 'default n'
    now.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7df03b82ed081777d2393ff8a5fb9d4a3a560f26
Author: Mattia Dongili <malattia@linux.it>
Date:   Sat Jan 13 23:04:41 2007 +0100

    sony_acpi: Fix sony_acpi backlight registration and unregistration
    
    Initialize the current brightness if the driver registration
    was successful and unregister the driver in the error exit path.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 57ede701af3bc0c153070133e7831332ffa1d761
Author: Mattia Dongili <malattia@linux.it>
Date:   Sat Jan 13 23:04:40 2007 +0100

    sony_acpi: Allow multiple sony_acpi_values for the same .name
    
    The acpi handles are kept _only_ if both the requested .acpiget and .acpiset
    are available in the DSDT.
    Currently only the SCDP/CDPW dualism is known.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4465857d5f99079bae00621626adf74ed8256296
Author: Mattia Dongili <malattia@linux.it>
Date:   Sat Jan 13 23:04:39 2007 +0100

    sony_acpi: Add lanpower and audiopower controls
    
    audiopower works well on my SZ72B so it's not marked has "debug" while lanpower
    has at least one report of not resuming power happily so morked as "debug"
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 05e2d8274ef4504db9941f7c515f340ab6c0b2e1
Author: Mattia Dongili <malattia@linux.it>
Date:   Sat Jan 13 23:04:38 2007 +0100

    sony_acpi: Allow easier debugging for the unknown SNC methods.
    
    Allow the existence of a setter method without a getter and viceversa,
    additionaly set /proc file permissions reflecting it.
    Fix also the error exit path.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c561162f10b9f35c9aa5c25eb8dbeb446f0c5201
Author: Stelian Pop <stelian@popies.net>
Date:   Sat Jan 13 23:04:37 2007 +0100

    sony_acpi: Add acpi_bus_generate event
    
    Added acpi_bus_generate event for forwarding Fn-keys pressed to acpi subsystem,
    and made correspondent necessary changes for this to work.
    
    Signed-off-by: Nilton Volpato <nilton.volpato@gmail.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 82c47731f77e7615f5a952c662d873b55e71f3b9
Author: Andrew Morton <akpm@osdl.org>
Date:   Sat Jan 13 23:04:36 2007 +0100

    sony_acpi: Video sysfs support take 2
    
    add dev argument for backlight_device_register
    
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 243e8b191df4e9c11e62ea11fa298351997e98c3
Author: Alessandro Guido <alessandro.guido@gmail.com>
Date:   Sat Jan 13 23:04:35 2007 +0100

    sony_acpi: Add backlight support to the sony_acpi v2
    
    Enable the sony_acpi driver to use the backlight subsysyem for adjusting
    the monitor brightness.  Old way of changing the brightness will be still
    available for compatibility with existing tools.
    
    Signed-off-by: Alessandro Guido <alessandro.guido@gmail.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 50f62afb114ffcf052cf07d4b49b2d148b749955
Author: Alessandro Guido <alessandro.guido@gmail.com>
Date:   Sat Jan 13 23:04:34 2007 +0100

    sony_acpi: Add backlight support to the sony_acpi
    
    Make the sony_acpi use the backlight subsystem to adjust brightness value
    instead of using the /proc/sony/brightness file.  (Other settings will
    still have a /proc/sony/...  entry)
    
    Signed-off-by: Alessandro Guido <alessandro.guido@gmail.com>
    Cc: Stelian Pop <stelian@popies.net>
    Cc: Richard Purdie <rpurdie@rpsys.net>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fac3506100c19391bc5474084dd838f0fb87bf26
Author: Andrew Morton <akpm@osdl.org>
Date:   Sat Jan 13 23:04:33 2007 +0100

    sony_acpi: Fix sony_acpi_resume call
    
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3f4f461fa816815b9338047a29cf2521f23f1783
Author: Andrew Morton <akpm@osdl.org>
Date:   Sat Jan 13 23:04:32 2007 +0100

    sony_acpi: Avoid dimness on resume.
    
    Doesn't work.
    
    Cc: Stelian Pop <stelian@popies.net>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7f09c432bed80cecfba634933ddc06735e64da00
Author: Stelian Pop <stelian@popies.net>
Date:   Sat Jan 13 23:04:31 2007 +0100

    sony_acpi: SNC device support for Sony Vaios
    
    From: Bjorn Helgaas <bjorn.helgaas@hp.com>
    
      Even though the devices claimed by sony_acpi.c can not be hot-plugged, the
      driver registration infrastructure allows the .add() and .remove() methods
      to be called at any time while the driver is registered.  So remove __init
      and __exit from them.
    
    From: Matthew Garrett <mjg59@srcf.ucam.org>
    
    [UBUNTU:acpi/sony] Add FN hotkey support
    Source URL of Patch:
    http://www.kernel.org/git/?p=linux/kernel/git/bcollins/ubuntu-dapper.git;a=commitdiff;h=7a9b49cba4919e8506604629db03add8e0b85767
    
    Signed-off-by: Ben Collins <bcollins@ubuntu.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6eb87fed52b7f6ac200eaa649cc3221e239d0113
Author: Len Brown <len.brown@intel.com>
Date:   Sat Feb 10 22:17:07 2007 -0500

    ACPI: acpi_table_parse_madt_family() is not MADT specific
    
    acpi_table_parse_madt_family() is also used to parse SRAT entries.
    So re-name it to acpi_table_parse_entries(), and re-name the
    madt-specific variables within it accordingly.
    
    cosmetic only.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5a8765a84c31ea51baf1f6c78116cd877bd8cd64
Author: Len Brown <len.brown@intel.com>
Date:   Sat Feb 10 21:35:47 2007 -0500

    ACPI: acpi_madt_entry_handler() is not MADT specific
    
    acpi_madt_entry_handler() is also used for the SRAT,
    so re-name it acpi_table_entry_handler().
    
    cosmetic only.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7f8f97c3cc75d5783d0b45cf323dedf17684be19
Author: Len Brown <len.brown@intel.com>
Date:   Sat Feb 10 21:28:03 2007 -0500

    ACPI: acpi_table_parse() now returns success/fail, not count
    
    Returning count for tables that are supposed to be unique
    was useless and confusing.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f3ccb06f3b8e0cf42b579db21f3ca7f17fcc3f38
Author: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
Date:   Tue Feb 13 02:35:50 2007 -0500

    ACPI: Disable wake GPEs only once.
    
    fixes Suspend/Resume regressions due to recent ACPICA update.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2b8923d9eb27fea3f2f56e3cf93be5917e4f536e
Author: Len Brown <len.brown@intel.com>
Date:   Sat Feb 10 01:18:25 2007 -0500

    ACPI: hotkey: remove driver, per feature-removal-schedule.txt
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a795ca5852fb944f21bd71c1230fcc5456e7d5ef
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Feb 12 14:39:38 2007 +1100

    ACPI: cleanup: make disable_acpi() valid w/o CONFIG_ACPI
    
    Len Brown <lenb@kernel.org> said:
    > Okay, but better to use disable_acpi()
    > indeed, since this would be the first code not already inside CONFIG_ACPI
    > to invoke disable_acpi(), we could define the inline as empty and you could
    > then scratch the #ifdef too.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7cda93e008e1a477970adbf82dba81a5d4f0ae40
Author: Len Brown <len.brown@intel.com>
Date:   Mon Feb 12 23:50:02 2007 -0500

    ACPI: delete extra #defines in /drivers/acpi/ drivers
    
    Cosmetic only.
    
    Except in a single case, #define ACPI_*_DRIVER_NAME
    were invoked 0 or 1 times.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c2b6705b75d9c7aff98a4602a32230639e10891c
Author: Len Brown <len.brown@intel.com>
Date:   Mon Feb 12 23:33:40 2007 -0500

    ACPI: fix acpi_driver.name usage
    
    It was erroneously used as a description rather than a name.
    
    ie. turn this:
    
    lenb@se7525gp2:/sys> ls bus/acpi/drivers
    ACPI AC Adapter Driver  ACPI Embedded Controller Driver  ACPI Power Resource Driver
    ACPI Battery Driver     ACPI Fan Driver                  ACPI Processor Driver
    ACPI Button Driver      ACPI PCI Interrupt Link Driver   ACPI Thermal Zone Driver
    ACPI container driver   ACPI PCI Root Bridge Driver      hpet
    
    into this:
    
    lenb@se7525gp2:~> ls /sys/bus/acpi/drivers
    ac  battery  button  container  ec  fan  hpet  pci_link  pci_root  power  processor  thermal
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f52fd66d2ea794010c2d7536cf8e6abed0ac4947
Author: Len Brown <len.brown@intel.com>
Date:   Mon Feb 12 22:42:12 2007 -0500

    ACPI: clean up ACPI_MODULE_NAME() use
    
    cosmetic only
    
    Make "module name" actually match the file name.
    Invoke with ';' as leaving it off confuses Lindent and gcc doesn't care.
    Fix indentation where Lindent did get confused.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 615d5f235b6c402ca01098a828c3d67e79e57cb6
Author: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
Date:   Mon Feb 12 10:51:23 2007 -0500

    ACPI: IA64: fix calculation of apic_id
    
    fix regression from recent table re-write
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 359acec8cd78d35e64147565e28b516599066e08
Author: Len Brown <len.brown@intel.com>
Date:   Sat Feb 10 01:59:24 2007 -0500

    ACPI: add video driver MAINTAINER
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e6d0f5622d30a3b98fb0ba6264d5006a18270890
Author: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
Date:   Sat Feb 10 01:51:13 2007 -0500

    ACPI: sbs: fix present rate
    
    http://bugzilla.kernel.org/show_bug.cgi?id=7897
    
    Signed-off-by: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4bd35cdb1e2d1a1bbbe4b75132718e79b80519ab
Author: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
Date:   Sat Feb 10 01:43:48 2007 -0500

    ACPI: battery: check for battery present on /proc/battery access
    
    http://bugzilla.kernel.org/show_bug.cgi?id=7200
    
    Signed-off-by: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit aafbcd165a2a02e6dff173f66772b3148229ace8
Author: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
Date:   Sat Feb 10 01:32:16 2007 -0500

    ACPI: invoke acpi_sleep_init() earlier
    
    late_initcall() is too late for acpi_sleep_init().
    Call it directly from acpi_init code.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=7887
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
    Signed-off-by: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ed41dab90eb40ac4911e60406bc653661f0e4ce1
Author: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
Date:   Sat Feb 10 01:30:35 2007 -0500

    ACPI: Disable GPEs in preparation for sleep.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=7887
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
    Signed-off-by: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d78112e1f1da2a8be1ac0d7b583dcc25aa4f079c
Author: Michael Hanselmann <linux-kernel@hansmi.ch>
Date:   Sat Feb 10 00:47:44 2007 -0500

    ACPI: video: Fix null pointer in appledisplay driver
    
    commit "ACPI: video: Add dev argument for backlight_device_register"
    519ab5f2be65b72cf12ae99c89752bbe79b44df6
    broke the apple display driver.
    
    Signed-off-by: Michael Hanselmann <linux-kernel@hansmi.ch>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3945ac36af3da6014cde9836c5acc5b3adaaa379
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Feb 6 19:13:44 2007 -0200

    ACPI: ibm-acpi: cleanup init and exit paths
    
    Fix a small memory leak on module removal, and other
    assorted minor cleanups on the module init codepath.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a3c94e5c5921b0fd75b33042ca598aee52f1f7b9
Author: Al Viro <viro@ftp.linux.org.uk>
Date:   Fri Feb 9 16:05:07 2007 +0000

    ACPI: bay: fix wrong order of kzalloc arguments
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b2b7910d5d3cb6e53b40a435bbc3f1de60f4464a
Author: Ahmed S. Darwish <darwish.07@gmail.com>
Date:   Tue Feb 6 16:14:43 2007 -0800

    ACPI: toshiba_acpi: Use ARRAY_SIZE macro when appropriate
    
    Use ARRAY_SIZE macro already defined in kernel.h
    
    Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d94d3dff0d5da3bdfcbb424ba5c08534521fd690
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Wed Feb 7 16:51:46 2007 -0800

    ACPI: bay: fix build warning
    
    drivers/acpi/bay.c: In function 'bay_add':
    drivers/acpi/bay.c:310: warning: statement with no effect
    
    Fix it by rewriting those macros in C.  Much nicer.
    
    Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a74388e21ef2adbba4450f7b3f05ffe88df630d5
Author: David Brownell <david-b@pacbell.net>
Date:   Mon Feb 5 16:09:11 2007 -0800

    ACPI: updates rtc-cmos device platform_data
    
    Update ACPI to export its RTC extension information through platform_data
    to the PNPACPI or platform bus device node used on the system being set up.
    
    This will need to be updated later to provide a firmware hook to handle
    system suspend with an alarm pending.
    
    Len notes that "Eventually we may bundle ACPI/PNP/PNPACPI..." but if/when
    that happens, ACPI can simplify this without my help.
    
    And until it does, the separate patch creating a platform_device (on all
    X86_PC systems, even without ACPI) will be needed.
    
    Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
    Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1c0f0575fd02a3996f09cac2ef29c4cc5c2d279d
Author: Matthew C Campbell <calvinmc@gmail.com>
Date:   Mon Feb 5 16:09:09 2007 -0800

    ACPI: asus_acpi: Add support for Asus Z81SP
    
    Adds support in asus_acpi for the Asus Z81SP laptop.  This preserves all
    old functionality when improperly detected as well as enabling Bluetooth
    support.
    
    Signed-off-by: Matthew C Campbell <calvinmc@gmail.com>
    Acked-by: Corentin Chary <corentincj@iksaif.net>
    Cc: Karol Kozimor <sziwan@users.sourceforge.net>
    Cc: <acpi4asus-user@lists.sourceforge.net>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c41458aca0defd5b16239ffd65630d1b87672ee5
Author: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Date:   Mon Feb 5 16:09:07 2007 -0800

    ACPI: bay: remove ACPI driver struct
    
    The bay driver is a platform driver, and doesn't need to also be an acpi
    driver.  Remove the acpi driver related structures and callbacks, they didn't
    do anything anyway.  Switch to uevent for user space event notification.
    
    Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>
