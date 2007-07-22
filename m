Return-Path: <linux-kernel-owner+w=401wt.eu-S1764267AbXGVJgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764267AbXGVJgL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 05:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761593AbXGVJfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 05:35:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:42665 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760935AbXGVJft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 05:35:49 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCH] ACPI patches for 2.6.23
Date: Sun, 22 Jul 2007 05:35:02 -0400
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707220535.05527.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.22/acpi-release-20070126-2.6.22.diff.gz

 Documentation/feature-removal-schedule.txt  |   21 
 Documentation/thinkpad-acpi.txt             |  353 ++++++--
 MAINTAINERS                                 |    6 
 arch/i386/kernel/acpi/boot.c                |    8 
 arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c |    4 
 drivers/acpi/Kconfig                        |   23 
 drivers/acpi/battery.c                      |  673 ++++++++++------
 drivers/acpi/bay.c                          |   19 
 drivers/acpi/bus.c                          |    4 
 drivers/acpi/dock.c                         |  127 ++-
 drivers/acpi/ec.c                           |  247 +++--
 drivers/acpi/event.c                        |  153 +++
 drivers/acpi/events/evgpeblk.c              |    4 
 drivers/acpi/events/evrgnini.c              |    1 
 drivers/acpi/glue.c                         |    2 
 drivers/acpi/osl.c                          |   40 
 drivers/acpi/pci_link.c                     |    2 
 drivers/acpi/processor_core.c               |    6 
 drivers/acpi/processor_idle.c               |   20 
 drivers/acpi/processor_throttling.c         |  410 +++++++++
 drivers/acpi/sbs.c                          |   33 
 drivers/acpi/sleep/main.c                   |    5 
 drivers/acpi/system.c                       |  165 +++
 drivers/acpi/tables/tbfadt.c                |   44 -
 drivers/acpi/utilities/uteval.c             |   17 
 drivers/acpi/video.c                        |  120 +-
 drivers/misc/Kconfig                        |   14 
 drivers/misc/sony-laptop.c                  |  368 +++++++-
 drivers/misc/thinkpad_acpi.c                |  602 ++++++++++++--
 drivers/misc/thinkpad_acpi.h                |   42 
 drivers/video/Kconfig                       |    7 
 drivers/video/Makefile                      |    3 
 include/acpi/acmacros.h                     |   63 +
 include/acpi/acoutput.h                     |    4 
 include/acpi/acpi_bus.h                     |    3 
 include/acpi/platform/acenv.h               |    2 
 include/acpi/platform/aclinux.h             |    3 
 include/acpi/processor.h                    |   47 +
 include/linux/pci_ids.h                     |    2 
 39 files changed, 2818 insertions(+), 849 deletions(-)

through these commits:

Adrian Bunk (2):
      ACPI: static
      ACPI: static

Alexey Starikovskiy (5):
      ACPI: battery: syntax cleanup
      ACPI EC: Re-factor EC space handler to avoid using label/goto for cycle.
      ACPI EC: drop usage of ACPI_DEBUG_PRINT as too heavy weight
      ACPI EC: Add support for non-AML EC query handlers
      ACPI: sbs: probe smart battery vis SMBus controller

Bob Moore (4):
      ACPICA: Update _OSI string list
      ACPICA: Changes for Cygwin compatibility
      ACPICA: Fixed possible corruption of global GPE list
      ACPICA: Clear reserved fields for incoming ACPI 1.0 FADTs

Chuck Ebbert (1):
      ACPI: dock: fix opps after dock driver fails to initialize

Dan Aloni (1):
      ACPI: drivers/acpi/pci_link.c: lower printk severity

Danny Kukawka (1):
      ACPI video: Don't export sysfs backlight interface if query _BCL fail

Dave Jones (1):
      ACPI: fix empty macros found by -Wextra

Dmitry Torokhov (1):
      ACPI: dock: fix oops when _DCK evaluation fails

Henrique de Moraes Holschuh (23):
      ACPI: thinkpad-acpi: add DMI-based modalias
      ACPI: thinkpad-acpi: remove all uneeded initializers
      ACPI: thinkpad-acpi: update information on T43 thermal sensor 0xc1
      ACPI: thinkpad-acpi: enable more hotkeys
      ACPI: thinkpad-acpi: export hotkey maximum masks
      ACPI: thinkpad-acpi: export to sysfs the state of the radio slider switch
      ACPI: thinkpad-acpi: checkpoint sysfs interface version due to hotkey
      ACPI: thinkpad-acpi: update CMOS commands documentation
      ACPI: thinkpad-acpi: register input device
      ACPI: thinkpad-acpi: add input device support to hotkey subdriver
      ACPI: thinkpad-acpi: make the input event mode the default
      ACPI: thinkpad-acpi: add power-management handler capability
      ACPI: thinkpad-acpi: export EV_SW SW_RADIO events
      ACPI: thinkpad-acpi: checkpoint sysfs interface version due to input layer
      ACPI: thinkpad-acpi: rename pci HID constant
      ACPI: thinkpad_acpi: use bool for boolean parameters
      ACPI: thinkpad-acpi: store ThinkPad model information
      ACPI: thinkpad-acpi: allow use of CMOS NVRAM for brightness control
      ACPI: thinkpad-acpi: react to Lenovo ThinkPad differences in hot key
      ACPI: thinkpad-acpi: make sure DSDT TMPx readings don't return +128
      ACPI: thinkpad-acpi: make EC-based thermal readings non-experimental
      ACPI: thinkpad-acpi: bump up version to 0.15
      ACPI: thinkpad-acpi: add locking to brightness subdriver

Jan Engelhardt (1):
      ACPI: Use menuconfig objects

Jesper Juhl (1):
      ACPICA: fix memory leak in acpi_ev_pci_config_region_setup() error path

Kristen Carlson Accardi (7):
      ACPI: dock: cleanup the uid patch
      ACPI: dock: use dynamically allocated platform device
      ACPI: dock: add immediate_undock option
      ACPI: dock: unsuppress uevents
      ACPI: dock: send envp with uevent
      ACPI: bay: unsuppress uevents
      ACPI: bay: send envp with uevent

Len Brown (4):
      ACPI: Lindent processor throttling code
      ACPI: disable _OSI(Linux) by default
      ACPI: update MAINTAINERS for EC and battery
      ACPI: netlink: remove unnecessary EXPORT_SYMBOL

Luming Yu (2):
      ACPI: video: output switch sysfs support
      ACPI: add ACPI 3.0 _TPC _TSS _PTC throttling support

Mattia Dongili (7):
      sony-laptop: add new SNC handlers
      sony-laptop: map wireless switch events to KEY_WLAN
      sony-laptop: Add support for recent Vaios Fn keys (C series for now)
      sony-laptop: Invoke _INI for SNC devices that provide it
      sony-laptop: Make the driver use MSC_SCAN and a setkeycode and getkeycode key table.
      sony-laptop: Add Vaio FE to the special init sequence
      sony-laptop: Fix event reading in sony-laptop

Pavel Machek (1):
      ACPI: suspend: delete toshiba S1 quirk

Stephen Hemminger (1):
      ACPI: delete cmdline documentation for deleted hotkey code

Tear (1):
      ACPI: Remove Dell Optiplex GX240 from the ACPI blacklist

Thomas Renninger (2):
      ACPI: asus_acpi: Do not load if no device has been found
      ACPI: create CONFIG_ACPI_DEBUG_FUNC_TRACE

Venkatesh Pallipadi (1):
      ACPI: Enable C3 even when PM2_control is zero

Vladimir Lebedev (4):
      ACPI: battery: make internal names consistent with battery "state"
      ACPI: Cache battery status instead of re-evaluating AML
      ACPI: battery: Lindent
      process reading battery status hangs

Zhang Rui (6):
      ACPI: Discard invalid elements in _PSS package
      ACPI: Export events via generic netlink
      ACPI: export ACPI events via acpi_mc_group multicast group
      ACPI: update feature-removal-schedule.txt, /sys/firmware/acpi/namespace is gone
      ACPI: update ACPI proc I/F removal schedule
      ACPI: Populate /sys/firmware/acpi/tables/

with this log:

commit 17c50b4102b32842224824b30d9182af9f582b90
Merge: 0d090b6... d4c5f04...
Author: Len Brown <len.brown@intel.com>
Date:   Sun Jul 22 04:14:18 2007 -0400

    Pull tables-in-sysfs into release branch

commit 0d090b6819e3559dabb05773c4a6dacc4fa94d0e
Merge: b4b613f... 9c977a4...
Author: Len Brown <len.brown@intel.com>
Date:   Sun Jul 22 04:14:07 2007 -0400

    Pull netlink into release branch

commit d4c5f047ae2a33296774e41abc2ac5c89283f736
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Jun 14 17:43:07 2007 +0800

    ACPI: Populate /sys/firmware/acpi/tables/
    
    The file name is the signature, such as DSDT,
    and the contents are the binary table image.
    
    Some tables, such as the SSDT, can have multiple instances.
    If just one, the file is SSDT, but if 3 instances,
    for example, it will be SSDT1, SSDT2, SSDT3
    
    All static tables (besides teh RSDP and RSDT themselves
    are exported.  Dynamic tables, such as SSDT op-regions that
    are not declared in the RSDT, will be added in a subsequent patch.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b4b613fd83853f8c688b3de20ab1a42331257975
Merge: 5e16e3f... 3c6394c...
Author: Len Brown <len.brown@intel.com>
Date:   Sun Jul 22 02:29:41 2007 -0400

    Pull osi into release branch

commit 5e16e3f0e24dadb79b96b6134cd3303f0d42f0c5
Merge: dcb76f8... f70ac0e...
Author: Len Brown <len.brown@intel.com>
Date:   Sun Jul 22 02:28:33 2007 -0400

    Pull video into release branch

commit dcb76f88683618ed6ef0df66643dba1285881ee5
Merge: 08e3168... 6c5cf8a...
Author: Len Brown <len.brown@intel.com>
Date:   Sun Jul 22 02:28:18 2007 -0400

    Pull throttle into release branch

commit 08e31686d6d119ba26bf0690f5f872f6f5bd1a97
Merge: d6da5ce... f432255...
Author: Len Brown <len.brown@intel.com>
Date:   Sun Jul 22 02:28:06 2007 -0400

    Pull thinkpad into release branch

commit d6da5ce8cc71a13e2f3671361c5a8bd9b82e014d
Merge: f79e318... 22a1778...
Author: Len Brown <len.brown@intel.com>
Date:   Sun Jul 22 02:27:56 2007 -0400

    Pull sony into release branch

commit f79e3185dd0f8650022518d7624c876d8929061b
Merge: e8b495f... 8b8eb7d...
Author: Len Brown <len.brown@intel.com>
Date:   Sun Jul 22 02:27:40 2007 -0400

    Pull misc into release branch
    
    Conflicts:
    
    	Documentation/feature-removal-schedule.txt

commit e8b495fe09bc793ae26774e7b2667f7f658d56e2
Merge: 22aadf8... 9254bc8...
Author: Len Brown <len.brown@intel.com>
Date:   Sun Jul 22 02:25:18 2007 -0400

    Pull dock-bay into release branch

commit 22aadf8a07067644e101267ed5003043f2ad05bf
Merge: 2e85622... 3cdf552...
Author: Len Brown <len.brown@intel.com>
Date:   Sun Jul 22 02:25:03 2007 -0400

    Pull bugzilla-7880 into release branch

commit 2e85622042cb5fd56a606e884651ffde52f21028
Merge: b43035a... 837012e...
Author: Len Brown <len.brown@intel.com>
Date:   Sun Jul 22 02:24:51 2007 -0400

    Pull ec into release branch

commit b43035a5ec4deecd43019728ab9347df82dd121f
Merge: 8269cc4... addad45...
Author: Len Brown <len.brown@intel.com>
Date:   Sun Jul 22 02:24:42 2007 -0400

    Pull sbs into release branch

commit 8269cc4e2b0ddcdcb9e7f2034c464ef8613737a1
Merge: 939ab20... 78490d8...
Author: Len Brown <len.brown@intel.com>
Date:   Sun Jul 22 02:24:31 2007 -0400

    Pull battery into release branch

commit 939ab20152390c8ccccfa6fac0830405ca91d903
Merge: d9ff963... 798d910...
Author: Len Brown <len.brown@intel.com>
Date:   Sun Jul 22 02:22:55 2007 -0400

    Pull acpi-debug into release branch

commit d9ff963801e4f7648c55a27413a1b1de59480a30
Merge: d7fff6f... e691731...
Author: Len Brown <len.brown@intel.com>
Date:   Sun Jul 22 02:22:43 2007 -0400

    Pull acpica into release branch

commit 798d91039849486c7a4f1a458a5680cb55a65408
Author: Thomas Renninger <trenn@suse.de>
Date:   Thu May 31 17:20:39 2007 +0200

    ACPI: create CONFIG_ACPI_DEBUG_FUNC_TRACE
    
    Split ACPI_DEBUG into function trace enabled and not enabled.
    
    Function trace is most of the ACPI_DEBUG costs, but is
    not much of use for kernel ACPI debugging.
    
    Size of kernel image increased on test compile:
    + 48k  (Full ACPI_DEBUG)
    + 35k  (ACPI_DEBUG with function trace compiled out)
    
    Performance without function trace is also much better.
    
    Also remove ACPI_LV_DEBUG_OBJECT from default debug level as
    a lot vendors let Store (value, debug) in their code and this
    might confuse users when it pops up in syslog.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8b8eb7d8cfc6cd95ed00cd58754e8493322505bd
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Wed Jul 18 17:23:24 2007 +0800

    ACPI: update ACPI proc I/F removal schedule
    
    ACPI sysfs conversion is not finished yet and
    some user space tools still depend on the ACPI proc I/F.
    
    We plan to finish all the sysfs conversion by January 2008
    and remove the ACPI proc I/F in July 2008.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7a9b9068b8c7b526894904c0b9b90354825b8fbd
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Fri Jul 13 13:42:47 2007 +0800

    ACPI: update feature-removal-schedule.txt, /sys/firmware/acpi/namespace is gone
    
    The /sys/firmware/acpi/namespace has already been removed in 2.6.21.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9c977a453ed62396d067b75f3f272b3fb1ea3acc
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Fri Jul 20 16:41:14 2007 +0800

    ACPI: export ACPI events via acpi_mc_group multicast group
    
    This is an incremental patch for the recent genetlink
    multicast changes.
    
    Now ACPI events are exported via generic netlink multicast group.
    
    Thanks for Johannes' help on developing this patch
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4ebf83c8cf89ab13bc23e46b0fcb6178ca23b43c
Author: Dave Jones <davej@redhat.com>
Date:   Mon Jul 9 11:33:14 2007 -0700

    ACPI: fix empty macros found by -Wextra
    
    ACPI has a ton of macros which make a bunch of empty if's when configured
    in non-debug mode.
    
    [lenb: The code it complaines about is functionally correct,
     so this patch is just to make -Wextra happier]
    
    #define DBG()
    
    if(...)
            DBG();
    next_c_statement
    
    which turns into
    if(...) ;
    next_c_statement
    
    Signed-off-by: Dave Jones <davej@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0dc070bb0242481a6100c95e5deaa07b267399a8
Author: Dan Aloni <da-x@monatomic.org>
Date:   Mon Jul 9 11:33:18 2007 -0700

    ACPI: drivers/acpi/pci_link.c: lower printk severity
    
    Signed-off-by: Dan Aloni <da-x@monatomic.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 22a17780584173635dae11bb83884952b00e5181
Author: Mattia Dongili <malattia@linux.it>
Date:   Mon Jul 16 02:34:39 2007 +0900

    sony-laptop: Fix event reading in sony-laptop
    
    The rewritten event reading code from sonypi was absolutely wrong,
    this patche makes things functional for type2 and type1 models.
    
    Cc: Andrei Paskevich <andrei@capet.iut-fbleau.fr>
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 89892d153d0d46018241afc7944910912bcd9688
Author: Mattia Dongili <malattia@linux.it>
Date:   Mon Jul 16 02:34:38 2007 +0900

    sony-laptop: Add Vaio FE to the special init sequence
    
    The Vaio FE series uses the same sequence as Vaio C series
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bc57f865fa2282ad2b7efe02da0a752e602e982e
Author: Mattia Dongili <malattia@linux.it>
Date:   Fri Jul 20 02:01:57 2007 +0900

    sony-laptop: Make the driver use MSC_SCAN and a setkeycode and getkeycode key table.
    
    The following is the only way I could think of to hide some events as
    per Dmitry suggestions while still using the default {set,get}keycode
    implementation.
    
    Make the driver use MSC_SCAN and a setkeycode and getkeycode key table.
    
    Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Signed-off-by: Richard Hughes <richard@hughsie.com>
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b25b732a16e4e035247fa729f931ed173f9fc8e2
Author: Mattia Dongili <malattia@linux.it>
Date:   Mon Jul 16 02:34:36 2007 +0900

    sony-laptop: Invoke _INI for SNC devices that provide it
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6315fd1c9cd6870a253699f07c5ada85cfe8fecb
Author: Mattia Dongili <malattia@linux.it>
Date:   Mon Jul 16 02:34:35 2007 +0900

    sony-laptop: Add support for recent Vaios Fn keys (C series for now)
    
    Recent Vaios (C, AR, N, FE) need some special initialization
    sequence to enable Fn keys interrupts through the Embedded
    Controller. Moreover Fn keys have to be decoded internally
    using ACPI methods to get the key code.
    Thus a new DMI table to add SNC init time callbacks and new
    mappings for model-specific key code to generic sony-laptop
    code have been added.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8538c3686c895f9334a3c22997b51b5a82de7550
Author: Mattia Dongili <malattia@linux.it>
Date:   Mon Jul 16 02:34:34 2007 +0900

    sony-laptop: map wireless switch events to KEY_WLAN
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 044847e02d46c0a9430e19249fd68777bb1d3c98
Author: Mattia Dongili <malattia@linux.it>
Date:   Mon Jul 16 02:34:33 2007 +0900

    sony-laptop: add new SNC handlers
    
    - lid state: GLID
    - indicator lamp: GILS/SILS
    - multimedia bass gain: GMGB/CMGB
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f432255e936a892a6896e5032e2b4897423076f2
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Jul 18 23:45:48 2007 -0300

    ACPI: thinkpad-acpi: add locking to brightness subdriver
    
    The backlight class does all the locking needed for sysfs access, but
    offers no API to interface to that locking without an layer violation.
    
    Since we need to mutex-lock procfs access, implement in-driver locking for
    brightness.  It will go away the day thinkpad-acpi procfs goes away, or the
    backlight class gives us a way to use its locks without a layer violation.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c78d5c96bb65b71a54b7551b404fbaf4763ed6e4
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Jul 18 23:45:47 2007 -0300

    ACPI: thinkpad-acpi: bump up version to 0.15
    
    Name it thinkpad-acpi version 0.15.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3d6f99ca00ccf861305fd8630a21f2e696886708
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Jul 18 23:45:46 2007 -0300

    ACPI: thinkpad-acpi: make EC-based thermal readings non-experimental
    
    Reading the 16 thermal sensors directly from the EC has been stable for
    about one year, in all supported ThinkPad models.  Remove its
    "experimental" label.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a8fba3da3d11d808137be7ebeb3b6938a42f011f
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Jul 18 23:45:45 2007 -0300

    ACPI: thinkpad-acpi: make sure DSDT TMPx readings don't return +128
    
    We get +128 instead of -128 from the DSDT TMPx methods, due to errors when
    converting a EC byte return that is a s8 to an ACPI handler return that is
    an int.
    
    Fix it once and for all, by clamping acceptable temperature readings from
    DSDT TMPx so that anything outside the [-127,+127] range is converted to
    TP_EC_THERMAL_TMP_NA (-128).
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Michael Olbrich <michael.olbrich@gmx.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit edf0e0e56904f794c97ca6c4562d8256e3d8d8e3
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Jul 18 23:45:44 2007 -0300

    ACPI: thinkpad-acpi: react to Lenovo ThinkPad differences in hot key
    
    Lenovo ThinkPads have a slightly different key map layout from IBM
    ThinkPads (fn+f2 and fn+f3 are swapped).  Knowing which one we are dealing
    with, we can properly set a few more hot keys up by default.
    
    Also, export the correct vendor in the input device, as that information
    might be useful to userspace.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 24d3b77467b6aaf59e38dce4aa86d05541858195
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Jul 18 23:45:43 2007 -0300

    ACPI: thinkpad-acpi: allow use of CMOS NVRAM for brightness control
    
    It appears that Lenovo decided to break the EC brightness control interface
    in a weird way in their latest BIOSes.  Fortunately, the old CMOS NVRAM
    interface works just fine in such BIOSes.
    
    Add a module parameter that allows the user to select which strategy to use
    for brightness control: EC, NVRAM, or both.  By default, do both (which is
    the way thinkpad-acpi used to work until now) on IBM ThinkPads, and use
    NVRAM only on Lenovo ThinkPads.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d5a2f2f1d68e2da538ac28540cddd9ccc733b001
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Jul 18 23:45:42 2007 -0300

    ACPI: thinkpad-acpi: store ThinkPad model information
    
    Keep note of ThinkPad model, BIOS and EC firmware information, and log it
    on startup.  Makes for far more readable code in places, too.
    
    This patch also adds Lenovo's PCI ID to the pci ids table.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 86cc9445e86bef9da44f933e3849e6eb43cbf626
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Jul 18 23:45:41 2007 -0300

    ACPI: thinkpad_acpi: use bool for boolean parameters
    
    Some of the module parameters are boolean in nature.  Make it so in fact.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 996fba08db7faf46b1a674957f60cd772ecd29ec
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Jul 18 23:45:40 2007 -0300

    ACPI: thinkpad-acpi: rename pci HID constant
    
    Rename an internal driver constant, on request by Len Brown.  Also,
    document exactly what it is for.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 741553c2d29b4075d636a38792c05cd2fc62bd8a
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Jul 18 23:45:39 2007 -0300

    ACPI: thinkpad-acpi: checkpoint sysfs interface version due to input layer
    
    The change in the way hotkey events are handled by default, and the use of
    the input layer for the hotkey events are important enough features to
    warrant increasing the major field of the sysfs interface version.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5c29d58f471099401513e2e567f6c28001bb0f13
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Jul 18 23:45:38 2007 -0300

    ACPI: thinkpad-acpi: export EV_SW SW_RADIO events
    
    The expected user case for the radio slider switch on a ThinkPad includes
    interfacing to applications, so that the user gets an offer to find and
    associate with a wireless network when the switch is changed from disabled
    to enabled (ThinkVantage suite).
    
    Export the information about the switch state, and switch change events as
    an EV_SW SW_RADIO event over the input layer.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Cc: Ivo van Doorn <ivdoorn@gmail.com>
    Cc: Richard Hughes <hughsient@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e295e8508c1dd56e06c73e78a2f67f2eb563e74f
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Jul 18 23:45:37 2007 -0300

    ACPI: thinkpad-acpi: add power-management handler capability
    
    Some subdrivers could benefit from resume handling, so add the
    infrastructure for simple resume handling.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1a343760b516ca5466d201bec32b1794858b18a5
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Jul 18 23:45:36 2007 -0300

    ACPI: thinkpad-acpi: make the input event mode the default
    
    Make the input layer the default way to deal with thinkpad-acpi hot keys,
    but add a kernel config option to retain the old way of doing things.
    
    This means we map a lot more keys to useful stuff by default, and also that
    we enable hot key handling by default on driver load (like Windows does).
    
    The documentation for proper use of this resource is also updated.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Richard Hughes <hughsient@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6a38abbf2b68e37493f2d5e8702b895a6c23ba0f
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Jul 18 23:45:35 2007 -0300

    ACPI: thinkpad-acpi: add input device support to hotkey subdriver
    
    Add input device support to the hotkey subdriver.
    
    Hot keys that have a valid keycode mapping are reported through the input
    layer if the input device is open.  Otherwise, they will be reported as
    ACPI events, as they were before.
    
    Scan codes are reported (using EV_MSC MSC_SCAN events) along with EV_KEY
    KEY_UNKNOWN events.
    
    For backwards compatibility purposes, hot keys that used to be reported
    through ACPI events are not mapped to anything meaningful by default.
    Userspace is supposed to remap them if it wants to use the input device for
    hot key reporting.
    
    This patch is based on a patch by Richard Hughes <hughsient@gmail.com>.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Richard Hughes <hughsient@gmail.com>
    Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7f5d1cd6287b7b29d210f85e2343207ac4310da2
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Jul 18 23:45:34 2007 -0300

    ACPI: thinkpad-acpi: register input device
    
    Register an input device to send input events to userspace.
    
    This patch is based on a patch by Richard Hughes <hughsient@gmail.com>.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Richard Hughes <hughsient@gmail.com>
    Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d54b7d7f8026300c612dd733d501fcbc22fd0370
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Jul 18 23:45:33 2007 -0300

    ACPI: thinkpad-acpi: update CMOS commands documentation
    
    The CMOS set of commands is often just used to keep the CMOS NVRAM in sync
    with whatever the ACPI BIOS has been doing in modern ThinkPads.  In older
    ThinkPads, it actually carried out real actions.  Document this.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 94b08713186cc47a5c367a866cc0a0a762721455
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Jul 18 23:45:32 2007 -0300

    ACPI: thinkpad-acpi: checkpoint sysfs interface version due to hotkey
    
    The change in the size of the hotkey mask, the hability to report the keys
    that use the higher bits, and the addition of the hotkey_radio_sw attribute
    are important enough features to warrant increasing the minor field of the
    sysfs interface version.
    
    Also, document a bit better how and when the thinkpad-acpi sysfs interface
    version will be updated.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 74941a69afcc06722685d492784414ec042ab492
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Jul 18 23:45:31 2007 -0300

    ACPI: thinkpad-acpi: export to sysfs the state of the radio slider switch
    
    Some ThinkPad models, notably the T60 and X60, have a slider switch to
    enable and disable the radios.  The switch has the capability of
    force-disabling the radios in hardware on most models, and it is supposed
    to affect all radios (WLAN, WWAN, BlueTooth).
    
    Export the switch state as a sysfs attribute, on ThinkPads where it is
    available.
    
    Thanks to Henning Schild for asking for this feature, and for tracking down
    the EC register that holds the radio switch state.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Henning Schild <henning@wh9.tu-dresden.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9b010de59cb6dcab7e167dd2a0fa5d3b31447fea
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Jul 18 23:45:30 2007 -0300

    ACPI: thinkpad-acpi: export hotkey maximum masks
    
    The firmware knows how many hot keys it supports, so export this
    information in a sysfs attribute.
    
    And the driver knows which keys are always handled by the firmware in all
    known ThinkPad models too, so export this information as well in a sysfs
    attribute.  Unless you know which events need to be handled in a passive
    way, do *not* enable hotkeys that are always handled by the firmware.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ae92bd17ff703b3703562148c73b4d6833e6a326
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Jul 18 23:45:29 2007 -0300

    ACPI: thinkpad-acpi: enable more hotkeys
    
    Revise ACPI HKEY functionality to better interface with the firmware, and
    enable up to 32 regular hotkeys, instead of just 16 of them.  Ouch.
    
    This takes care of most keys one used to have to do CMOS NVRAM polling on,
    and should drop the need for tpb, thinkpad-keys, and other such 5Hz NVRAM
    polling power vampires on most modern ThinkPads ;-)
    
    And, just to add insult to injury, this was sort of working since forever
    through the procfs interface, but nobody noticed or tried an echo
    0xffffffff > /proc/acpi/ibm/hotkey and told me it would generate weird
    events. ARGH!
    
    Thanks to Richard Hughes for kicking off the work that ended up with this
    discovery, and to Matthew Garret for calling my attention to the fact that
    newer ThinkPads were indeed generating ACPI GPEs when such hot keys were
    pressed.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Richard Hughes <hughsient@gmail.com>
    Cc: Matthew Garrett <mjg59@srcf.ucam.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b8b26402cb711de5d3bbd4515b91b6d863fea259
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Jul 18 23:45:28 2007 -0300

    ACPI: thinkpad-acpi: update information on T43 thermal sensor 0xc1
    
    Update the documentation with some extra data on the T43 thermal sensor
    @0xc1, thanks to Alexey Fisher.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 94954cc60194796fb257802f6f65d79553c9a8ca
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Jul 18 23:45:27 2007 -0300

    ACPI: thinkpad-acpi: remove all uneeded initializers
    
    Remove all initializers to NULL or zero.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b964b437601a0e7d09896d5d9a85c83643e94f41
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed Jul 18 23:45:26 2007 -0300

    ACPI: thinkpad-acpi: add DMI-based modalias
    
    Add DMI-based aliases to allow module autoloading on select thinkpads.
    
    The aliases will do nothing unless the dmi-based-module-autoloading.patch
    patch from Lennart Poettering <mzxreary@0pointer.de> is applied.  Lennart's
    patch has been accepted by greghk and will be merged eventually.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Lennart Poettering <mzxreary@0pointer.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 18eab8550397f1f3d4b8b2c5257c88dae25d58ed
Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Fri Jun 15 19:37:00 2007 -0400

    ACPI: Enable C3 even when PM2_control is zero
    
    On systems that do not have pm2_control_block, we cannot really use
    ARB_DISABLE before C3. We used to disable C3 totally on such systems.
    
    To be compatible with Windows, we need to enable C3 on such systems now.
    We just skip ARB_DISABLE step before entering the C3-state and assume
    hardware is handling things correctly. Also, ACPI spec is not clear
    about pm2_control is _needed_ for C3 or not.
    
    We have atleast one system that need this to enable C3.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e6917317c0f6a930442c40dc38a6f21710adf961
Author: Jesper Juhl <jesper.juhl@gmail.com>
Date:   Thu Jul 19 00:48:03 2007 +0200

    ACPICA: fix memory leak in acpi_ev_pci_config_region_setup() error path
    
    acpi_ev_pci_config_region_setup() leaks pci_id
    in the error case of "if (!pci_device_node)"
    
    Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9254bc845db90a123cf992e983539d0ee409f22a
Author: Dmitry Torokhov <dtor@insightbb.com>
Date:   Wed Jul 18 01:10:24 2007 -0400

    ACPI: dock: fix oops when _DCK evaluation fails
    
    Data returned by acpi_get_name in acpi_buffer is not acpi_object and
    therefore should not be cast to it, otherwise we'll get an nice oops
    trying to print error message.
    
    Also print name of the ACPI object corresponding to the docking station
    and elevate severity of the message printed when _DCK fails to KERN_ERR.
    
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
    Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b563d6f30d937510e02541930b1558d0f5759413
Author: Len Brown <len.brown@intel.com>
Date:   Tue Jul 3 15:32:23 2007 -0400

    ACPI: netlink: remove unnecessary EXPORT_SYMBOL
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 864bdfb912e372670b5b2541dac9d273a4a7722a
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Tue Jun 19 11:40:03 2007 +0800

    ACPI: Export events via generic netlink
    
    Upon ACPI events, send an "acpi_event" via Generic Netlink.
    This is in addition to /proc/acpi/event, which remains intact for now.
    
    Thanks to Jamal for his great help.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 55f8f3cc4f7c47c7896e2ad08e29eccc292c0c68
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed May 2 15:51:37 2007 -0400

    ACPICA: Clear reserved fields for incoming ACPI 1.0 FADTs
    
    Fixed a problem with the internal FADT conversion where ACPI 1.0
    FADTs that contained invalid non-zero values in reserved fields
    could cause later failures because these fields have meaning in
    later revisions of the FADT. For incoming ACPI 1.0 FADTs, these
    fields are now always zeroed. (Preferred_PM_Profile, PSTATE_CNT,
    CST_CNT, IAPC_BOOT_FLAGS.)
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e0b91050f208ab370fac9269f8e42bc746889422
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Apr 3 20:00:29 2007 -0400

    ACPICA: Fixed possible corruption of global GPE list
    
    Fixed a problem in acpi_ev_delete_gpe_xrupt where the global interrupt
    list could be corrupted if the interrupt being removed was at
    the head of the list. Reported by Linn Crosetto.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a0a3f6c69b45dcafefdce5dbac2221c02aaae871
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Mar 27 20:25:46 2007 -0400

    ACPICA: Changes for Cygwin compatibility
    
    Allow generation of ACPICA apps on Cygwin.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3c6394c5bd04e31d40d007af8b6c2484a08838d0
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon Mar 26 22:10:34 2007 -0400

    ACPICA: Update _OSI string list
    
    Latest update for the Windows strings, with comments. Removed
    unused strings.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 33ce2033433195ccc1fbad00d26ad854b2ab68d0
Author: Pavel Machek <pavel@pavel@suse.cz>
Date:   Tue Jul 3 01:45:44 2007 -0400

    ACPI: suspend: delete toshiba S1 quirk
    
    If we have quirk "init...  after standby", we should not be calling it while
    resuming from hibernation.  And...  that quirk is only ever needed on toshiba
    4030cdt...  and...  noone should be using standby these days, anyway.
    
    That quirk was certainly _not_ meant to be ran after hibernation.
    
    Signed-off-by: Pavel Machek <pavel@suse.cz>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3f2c48c9b48423d1411695da066d525cca2a27db
Author: Jan Engelhardt <jengelh@linux01.gwdg.de>
Date:   Tue Jul 3 01:40:59 2007 -0400

    ACPI: Use menuconfig objects
    
    Use menuconfigs instead of menus, so the whole menu can be disabled at once
    instead of going through all options.
    
    Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f70ac0e9651aa8c07dffe72a44872f92054d42c3
Author: Danny Kukawka <dkukawka@suse.de>
Date:   Tue Jul 3 01:33:53 2007 -0400

    ACPI video: Don't export sysfs backlight interface if query _BCL fail
    
    Currently the acpi video module export the backlight interface to sysfs
    also if acpi_video_device_lcd_query_levels() fails to read _BLC method
    (e.g.  because the method is not available).  In this case the userspace
    don't know which brightness level are supported and can't set a brightness
    level (echo return with: "write error: Invalid Argument").  This happend
    e.g.  on a ASUS RF1 (correct supported by the asus-laptop module).
    
    The video module should not export the backlight interface if query _BLC fail,
    because you can't set anything from userspace and this make it useless.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=8375
    
    Signed-off-by: Danny Kukawka <dkukawka@suse.de>
    Acked-by: Luming Yu <luming.yu@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1c1558ec50618c4a179e0684037d9f7bb0c1a326
Author: Stephen Hemminger <shemminger@linux-foundation.org>
Date:   Tue Jul 3 01:28:49 2007 -0400

    ACPI: delete cmdline documentation for deleted hotkey code
    
    This looks like left over text in the kernel parameters documentation.
    
    Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3312111d1bd1a409892031f7979c57a52b01185c
Author: Adrian Bunk <bunk@stusta.de>
Date:   Tue Jul 3 00:56:05 2007 -0400

    ACPI: static
    
    make the needlessly global osi_linux static.
    
    Signed-off-by: Adrian Bunk <bunk@stusta.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6c5cf8aa5849819958311644ffaf8467e9fcf07e
Author: Adrian Bunk <bunk@stusta.de>
Date:   Tue Jul 3 00:53:12 2007 -0400

    ACPI: static
    
    make 2 needlessly global functions static.
    
    Signed-off-by: Adrian Bunk <bunk@stusta.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit addad45494cb4f9c03470a4e5155f442791b0d7f
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Sat Jun 23 16:24:48 2007 -0400

    ACPI: sbs: probe smart battery vis SMBus controller
    
    http://bugzilla.kernel.org/show_bug.cgi?id=8559
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 837012ede14a8fc088be3682c964da7fc6af026b
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Tue May 29 16:43:02 2007 +0400

    ACPI EC: Add support for non-AML EC query handlers
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4350933a7447591041b51157a6b307be1816415f
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Tue May 29 16:42:57 2007 +0400

    ACPI EC: drop usage of ACPI_DEBUG_PRINT as too heavy weight
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5b7734b440d29dab583a6c3f0ee49ff20f323332
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Tue May 29 16:42:52 2007 +0400

    ACPI EC: Re-factor EC space handler to avoid using label/goto for cycle.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a4146557cdfcd1adf1a8e8c92493c2cebe1088a1
Author: Len Brown <len.brown@intel.com>
Date:   Sat Jun 23 15:54:36 2007 -0400

    ACPI: update MAINTAINERS for EC and battery
    
    Update ACPI Embedded Controller driver maintainer
    with Alexey Starikovskiy's new e-mail address at Novell/SuSE.
    
    Also, Alexey is taking over responsibility for the battery drivers.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e4d49531dcc2f334205d99614164ea900216b1cb
Author: Thomas Renninger <trenn@suse.de>
Date:   Thu Mar 8 17:57:31 2007 +0100

    ACPI: asus_acpi: Do not load if no device has been found
    
    asus_acpi_init() has a hack to prevent the driver from loading
    when asus_hotk_add() fails.  However, it was returning the successful
    return value of acpi_bug_registger_driver() on failure.  This caused
    an oops on unload.  Instead it should return -ENODEV.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3cdf552be228e1ca55f9c53a78f39e8b77d6159c
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Wed Jun 13 21:24:02 2007 -0400

    ACPI: Discard invalid elements in _PSS package
    
    Make sure that the _PSS list is sorted in
    descending order by typical power dissipation.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=7880
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 072971d7d3e70ddac5c5be3436d929470cc2b3fb
Author: Len Brown <len.brown@intel.com>
Date:   Sat Jun 9 01:42:00 2007 -0400

    ACPI: disable _OSI(Linux) by default
    
    In Linux-2.6.22 we expanded the boot parameter osi=
    so that it can enable and !enable an OSI string.
    
    _OSI(Linux) is a special case because we know that there
    are both systems that require it set, and systems
    require that it _not_ to be set.  In the long term it can't
    be set, for the same reason _OS(Linux) can't be enabled --
    it tends to confuse BIOS that are not properly
    validated with Linux.  Further, the semantics and version
    information of _OSI(Linux) were never actually defined.
    
    The kernel prints out a message if it sees _OSI(Linux)
    requested, and there is a DMI workaround to invoke
    "osi=Linux" automatically for existing systems that need it.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=7787
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4d2fafd17a325b3f4f5f9edb1211bc7f4c311269
Author: Tear <tarrqt@yahoo.com>
Date:   Wed May 23 14:12:30 2007 -0700

    ACPI: Remove Dell Optiplex GX240 from the ACPI blacklist
    
    I have a Dell Optiplex GX240 and when I boot Linux, ACPI gets set up by only
    acpi=ht.  dmesg shows the following line:
    
       DELL GX240 detected: force use of acpi=ht
    
    Everything seemed to be fine.  However, I discovered that everything is not
    fine.  The USB controller works so slowly that copying a few (uncached) 1
    megabyte large photos from a USB-enabled digital camera takes many minutes
    instead of a couple of seconds.
    
    I am using Linux 2.6.21.1 on a Debian 4.0 ("Etch") system.
    
    I thought that this might be related to ACPI.  So I tried to boot with _only_
    "acpi=force" appended to the kernel command line.  Voila, the USB controller
    started to work at full speed and copying photos from my digital camera took
    only seconds.
    
    I tested the system with "acpi=force" and could not find anything which did
    not work.
    
    I thought that this might be related to interrupts and APIC as well.  (Note
    that this is APIC, not ACPI.) I tried booting with _only_ "noapic" and
    "nolapic" appended to the command line.  Again, the USB controller started to
    work at full speed.
    
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3f8698d4d3f72252980575fb8d7b4cafeb5dd0a2
Author: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Date:   Wed May 23 14:12:29 2007 -0700

    ACPI: bay: send envp with uevent
    
    Make the bay driver send env information on bay events.
    
    Upon any bay event, we will send the string "BAY_EVENT=%d" along with the
    KOBJ_CHANGE, and report the event number.  What the event number means will
    be platform specific.  Event 3 is always an eject request, but an insert
    may be either event 1, or it may be event 0.  Event 1 may also be a
    remove request.  It would be best if you check the number of your event
    with udevmonitor before writing any udev scripts for inserting and
    removing drive bays.
    
    Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
    Cc: Stephan Berberig <s.berberig@arcor.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ff55a9cebab02403f942121e2f898bb06ecfffbb
Author: Len Brown <len.brown@intel.com>
Date:   Sat Jun 2 00:15:25 2007 -0400

    ACPI: Lindent processor throttling code
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 01854e697a77a434104b2f7e6d7fd463a978af32
Author: Luming Yu <luming.yu@gmail.com>
Date:   Sat May 26 22:49:58 2007 +0800

    ACPI: add ACPI 3.0 _TPC _TSS _PTC throttling support
    
    adds _TPC _TSS _PTC -- Throttling Present Capabilities
    
    Signed-off-by: Luming Yu <luming.yu@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 78490d82129f7331d1366737c8704c1c053221a3
Author: Alexey Starikovskiy <aystarik@gmail.com>
Date:   Fri May 11 13:18:55 2007 -0400

    ACPI: battery: syntax cleanup
    
    In response to review comments from Andrew Morton
    
    Signed-off-by: Alexey Starikovskiy <aystarik@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1f9767df1346c9ce09d6e51b9f34b851e3d94fad
Author: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Date:   Wed May 9 15:55:53 2007 -0700

    ACPI: bay: unsuppress uevents
    
    Since platform devices seem to get uevents suppressed by default,
    manually unsuppress for the bay device since we want to be able
    to send uevents.
    
    Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 79a8f70b4b9127eacfc91dd1436c4a7be05e62ab
Author: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Date:   Wed May 9 15:10:22 2007 -0700

    ACPI: dock: send envp with uevent
    
    Send an env along with our KOBJ_CHANGE uevent so that user space has
    the option of checking for that to see if a dock or undock has occurred.
    
    Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9ef2a9a9f08722998540ed2ff38bccd0c54344c8
Author: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Date:   Wed May 9 15:09:12 2007 -0700

    ACPI: dock: unsuppress uevents
    
    Platform devices may not send uevents by default - override the setting
    so that we can send uevents on dock/undock.
    
    Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a0cd35fdca0bb711854edeaf016cec6cdf82eeca
Author: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Date:   Wed May 9 15:08:15 2007 -0700

    ACPI: dock: add immediate_undock option
    
    Allow the driver to be loaded with an option that will allow userspace to
    control whether the laptop is ejected immediately when the user presses the
    button, or only when the syfs undock file is written.
    
    if immediate_undock == 1, then when the user presses the undock button, the
    laptop will send an event to userspace to notify userspace of the undock, but
    then immediately undock without waiting for userspace.  This is the current
    behavior, and I set this to be the default.
    
    if immediate_undock == 0, then when the user presses the undock button, the
    laptop will send an event to userspace and do nothing.  User space can query
    the "flags" sysfs entry to determine if an undock request has been made by
    the user (if bit 1 is set).  User space will then need to write the undock
    sysfs entry to complete the undocking process.
    
    Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0f6f2804563eee64f0fc7cbcb009b98b6f332af6
Author: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Date:   Wed May 9 15:07:04 2007 -0700

    ACPI: dock: use dynamically allocated platform device
    
    Get rid of no release function warnings by switching to dynamically
    allocating the platform_device and using the platform device release
    routine in the base driver.
    
    Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 22fe4c2114e29477ca6738729c074ee8f60d3b73
Author: Chuck Ebbert <cebbert@redhat.com>
Date:   Wed May 9 15:05:48 2007 -0700

    ACPI: dock: fix opps after dock driver fails to initialize
    
    The driver tests the dock_station pointer for nonnull
    to check whether it has initialized properly. But in
    some cases dock_station will be non-null after being
    freed when driver init fails. Fix by zeroing the
    pointer after freeing.
    
    Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
    Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 38ff4ffc039ba5a5878f2dcbb03d87c3a1f02f1b
Author: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Date:   Wed May 9 15:04:24 2007 -0700

    ACPI: dock: cleanup the uid patch
    
    Make uid sysfs file error path free memory, and cleanup sysfs file
    when removing driver.  Also fix CodingStyle violations.
    
    Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
    Cc: Illya A. Volynets-Evenbakh <ilya@total-knowledge.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 23b0f015bf2c050b8b5399430ca64e1b3398cf76
Author: Luming Yu <luming.yu@gmail.com>
Date:   Wed May 9 21:07:05 2007 +0800

    ACPI: video: output switch sysfs support
    
    Requires CONFIG_VIDEO_OUTPUT_CONTROL and CONFIG_ACPI_VIDEO.
    
    After loading output.ko and video.ko, you would have
    /sys/class/video_output and several device acpi_videoNum there.
    
    For example, I got acpi_video0, acpi_video1,acpi_video2,and acpi_video3
    under /sys/class/video_output on my T40.
    I can query the status of  output device0 by running " cat
    /sys/class/video_output/acpi_video0
    " The return value is defined in ACPI SPEC B.5.5 _DCS(Return the
    Status of Output Device).  Also you can turn off video1 and turn on
    video0  by " echo 0 > acpi_video1; echo 0x80000000 > acpi_video0".
    Please reference ACPI SPEC  B.5.7 _DSS for the parameter definition.
    
    Please note that it may or may NOT works purely depending on if
    your vendor providing correct ACPI video extension support in bios.
    the driver output.ko and video.ko just works like a interface to
    invoke BIOS.
    
    Signed-off-by: Luming Yu <Luming.yu@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6eedeef73e7fff32eb5fa25178c3c77b1db0ec0f
Author: Vladimir Lebedev <vladimir.p.lebedev@gmail.com>
Date:   Sat Apr 21 22:41:48 2007 -0400

    process reading battery status hangs
    
    http://bugzilla.kernel.org/show_bug.cgi?id=8351
    
    Signed-off-by: Vladimir Lebedev <vladimir.p.lebedev@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9ea7d57576f40c6af03c8c9fa7a069f2222b498b
Author: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
Date:   Tue Feb 20 15:48:06 2007 +0300

    ACPI: battery: Lindent
    
    Signed-off-by: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b6ce4083ed8e2a01a3a59301eabe0fc1e68a8a84
Author: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
Date:   Tue Feb 20 15:48:06 2007 +0300

    ACPI: Cache battery status instead of re-evaluating AML
    
    /proc exports _BST in a single file, and _BST is re-evaulated
    whenever that file is read.
    
    Sometimes user-space reads this file frequently, and on some
    systems _BST takes a long time to evaluate due to a slow EC.
    
    Further, when we move to sysfs, the values returned from _BST
    will be in multiple files, and evaluating _BST for each
    file read would make matters worse.
    
    Here code is added to support caching the results of _BST.
    A new module parameter "update_time" tells how many seconds the
    cached _BST should be used before it is re-evaluated.
    Currently, update_time defaults to 0, and so the
    existing behaviour of re-evaluating on each read retained.
    
    Signed-off-by: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a1f0eff21edac1bd87e397f56c4258b9611b5a50
Author: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
Date:   Tue Feb 20 15:48:06 2007 +0300

    ACPI: battery: make internal names consistent with battery "state"
    
    Cleanup -- No functional changes.
    
    Battery state is currently exported in a proc "state" file.
    Update associated #defines and routines to be consistent.
    
    Signed-off-by: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
