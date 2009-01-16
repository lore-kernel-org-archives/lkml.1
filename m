Return-Path: <linux-kernel-owner+w=401wt.eu-S937050AbZAPUWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937050AbZAPUWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 15:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758144AbZAPUWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 15:22:34 -0500
Received: from vms173009pub.verizon.net ([206.46.173.9]:57769 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756844AbZAPUWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 15:22:31 -0500
Date: Fri, 16 Jan 2009 15:22:28 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: git pull request for 2.6.29-rc1
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.2.00.0901161520520.5705@localhost.localdomain>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_LQtGNDtYQ4Fars+NIB8MRQ)"
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_LQtGNDtYQ4Fars+NIB8MRQ)
Content-type: TEXT/PLAIN; charset=ISO-8859-15
Content-transfer-encoding: 8BIT

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.29/acpi-release-20081204-2.6.29-rc1.diff.gz

 Documentation/laptops/thinkpad-acpi.txt      |   25 +-
 arch/ia64/kernel/kprobes.c                   |    2 +-
 arch/x86/kernel/kprobes.c                    |    2 +-
 drivers/acpi/Makefile                        |    2 +-
 drivers/acpi/ec.c                            |   73 +--
 drivers/acpi/{main.c => sleep.c}             |    0
 drivers/acpi/thermal.c                       |   16 +-
 drivers/misc/Makefile                        |    1 -
 drivers/pci/hotplug/acpiphp_glue.c           |    2 +
 drivers/platform/x86/Kconfig                 |   23 +
 drivers/platform/x86/Makefile                |    1 +
 drivers/{misc => platform/x86}/dell-laptop.c |    2 +-
 drivers/platform/x86/eeepc-laptop.c          |    4 +-
 drivers/platform/x86/thinkpad_acpi.c         |  910 +++++++++++++++++++++-----
 include/acpi/actbl.h                         |    2 +-
 kernel/kprobes.c                             |    2 +-
 kernel/power/Makefile                        |    3 +-
 17 files changed, 858 insertions(+), 212 deletions(-)
 rename drivers/acpi/{main.c => sleep.c} (100%)
 rename drivers/{misc => platform/x86}/dell-laptop.c (99%)

through these commits:

Alexey Starikovskiy (2):
      ACPI: EC: Limit workaround for ASUS notebooks even more
      ACPI: EC: Don't trust ECDT tables from ASUS

David Brownell (1):
      ACPI: fix ACPI_FADT_S4_RTC_WAKE comment

Henrique de Moraes Holschuh (12):
      ACPI: thinkpad-acpi: update documents for the new location
      ACPI: thinkpad-acpi: debug facility to emulate the rf switches
      ACPI: thinkpad-acpi: resume with radios disabled
      ACPI: thinkpad-acpi: preserve radio state across shutdown
      ACPI: thinkpad-acpi: add UWB radio support
      ACPI: thinkpad-acpi: use killable instead of interruptible mutexes
      ACPI: thinkpad-acpi: clean up hotkey_notify()
      ACPI: thinkpad-acpi: handle HKEY thermal and battery alarms
      ACPI: thinkpad-acpi: start the event hunt season
      ACPI: thinkpad-acpi: clean-up fan subdriver quirk
      ACPI: thinkpad-acpi: handle HKEY event 6030
      ACPI: thinkpad-acpi: bump up version to 0.22

James Bottomley (1):
      ACPI PCI hotplug: harden against panic regression

Jonathan McDowell (1):
      eeepc-laptop: enable Bluetooth ACPI details

Kay Sievers (1):
      ACPI: thinkpad-acpi: struct device - replace bus_id with dev_name(), dev_set_name()

Len Brown (2):
      dell-laptop: move to drivers/platform/x86/ from drivers/misc/
      ACPI: rename main.c to sleep.c

Masami Hiramatsu (1):
      kprobes: check CONFIG_FREEZER instead of CONFIG_PM

Rafael J. Wysocki (1):
      PM: Fix freezer compilation if PM_SLEEP is unset

Zhang Rui (1):
      thermal fixup for broken BIOS which has invalid trip points.

with this log:

commit d45e0855488032ea62ec5638fb1dcd47367f8ddb
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Thu Jan 15 15:12:27 2009 -0500

    ACPI PCI hotplug: harden against panic regression
    
    ACPI hotplug panic with current git head
    http://lkml.org/lkml/2009/1/10/136
    
    Rather than reverting the entire commit that causes the crash:
    e8c331e963c58b83db24b7d0e39e8c07f687dbc6
    "PCI hotplug: introduce functions for ACPI slot detection"
    
    simply harden against it while the changes to
    the hotplug code on this particularl machine are understood.
    
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
    Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 88d998c264722cd6e8fafa42aee191f7d9194960
Merge: 79491ca... d08ca2c...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 16 14:45:34 2009 -0500

    Merge branch 'misc' into release

commit 79491ca416347f9e3c51993db556ba78bef44afa
Merge: f1f055f... aa2fbce...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 16 14:45:24 2009 -0500

    Merge branch 'thinkpad-acpi' into release

commit f1f055f1036a20742608c28ee82139f572dfd031
Merge: 4b48d9d... c6cb0e8... 0e4240d...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 16 14:45:11 2009 -0500

    Merge branches 'bugzilla-11884' and 'bugzilla-8544' into release

commit d08ca2ca743f324eceba59e93188f9439e966bce
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 16 13:52:03 2009 -0500

    ACPI: rename main.c to sleep.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cad73120ab0dfd484682229346de8c16073577e1
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 9 17:23:38 2009 -0500

    dell-laptop: move to drivers/platform/x86/ from drivers/misc/
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3af9bfcb433c110839e4c815a9928377f66bbd0e
Author: Jonathan McDowell <noodles@earth.li>
Date:   Wed Dec 3 20:31:11 2008 +0000

    eeepc-laptop: enable Bluetooth ACPI details
    
    Although rfkill support for the EEE bluetooth device has been added to
    2.6.28-rc the appropriate ACPI accessor definitions were not added, so
    the support was non functional. The patch below adds the get and set
    accessors and has been verified to work on an EEE 901.
    
    Signed-off-by: Jonathan McDowell <noodles@earth.li>
    Acked-by: Matthew Garrett <mjg@redhat.com>
    Acked-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c3407710b76610962a5ebb244172631ef9eeb51a
Author: David Brownell <dbrownell@users.sourceforge.net>
Date:   Fri Jan 9 12:17:08 2009 -0800

    ACPI: fix ACPI_FADT_S4_RTC_WAKE comment
    
    Make the comment for ACPI_FADT_S4_RTC_WAKE match the ACPI spec;
    that bit has nothing to do with status bits.
    
    Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5a4ccaf37ffece09ef33f1cfec67efa8ee56f967
Author: Masami Hiramatsu <mhiramat@redhat.com>
Date:   Tue Jan 6 21:15:32 2009 +0100

    kprobes: check CONFIG_FREEZER instead of CONFIG_PM
    
    Check CONFIG_FREEZER instead of CONFIG_PM because kprobe booster
    depends on freeze_processes() and thaw_processes() when CONFIG_PREEMPT=y.
    
    This fixes a linkage error which occurs when CONFIG_PREEMPT=y, CONFIG_PM=y
    and CONFIG_FREEZER=n.
    
    Reported-by: Cheng Renquan <crquan@gmail.com>
    Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 33f1d7ecc6cffff3c618a02295de969ebbacd95d
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Jan 6 21:14:04 2009 +0100

    PM: Fix freezer compilation if PM_SLEEP is unset
    
    Freezer fails to compile if with the following configuration
    settings:
    
    CONFIG_CGROUPS=y
    CONFIG_CGROUP_FREEZER=y
    CONFIG_MODULES=y
    CONFIG_FREEZER=y
    CONFIG_PM=y
    CONFIG_PM_SLEEP=n
    
    Fix this by making process.o compilation depend on CONFIG_FREEZER.
    
    Reported-by: Cheng Renquan <crquan@gmail.com>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@suse.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0e4240d94628530a912d216cad1e32d2e3827327
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Fri Jan 16 12:53:42 2009 -0500

    thermal fixup for broken BIOS which has invalid trip points.
    
    ACPI thermal driver only re-evaluate VALID trip points.
    
    For the broken BIOS show in
    http://bugzilla.kernel.org/show_bug.cgi?id=8544
    the active[0] is set to invalid at boot time
    and it will not be re-evaluated again.
    We can still get a single warning message at boot time.
    
    http://marc.info/?l=linux-kernel&m=120496222629983&w=2
    
    http://bugzilla.kernel.org/show_bug.cgi?id=12203
    
    Signed-off-by: Zhang Rui<rui.zhang@intel.com>
    Tested-by: Márton Németh <nm127@freemail.hu>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c6cb0e878446c79f42e7833d7bb69ed6bfbb381f
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed Jan 14 02:57:53 2009 +0300

    ACPI: EC: Don't trust ECDT tables from ASUS
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9399
    http://bugzilla.kernel.org/show_bug.cgi?id=11880
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 235c4a59278eb07e61d909f1f0c233733034a8b3
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed Jan 14 02:57:47 2009 +0300

    ACPI: EC: Limit workaround for ASUS notebooks even more
    
    References: http://bugzilla.kernel.org/show_bug.cgi?id=11884
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit aa2fbcec07b0d594808bc3058692395d24eba66e
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Jan 11 03:01:10 2009 -0200

    ACPI: thinkpad-acpi: bump up version to 0.22
    
    It is about time to bump up the version.
    
    Features added since 0.21:  fan suspend/resume support, preserve radio
    state across power off (for some radio types), built-in UWB radio
    rfkill support and thermal alarm events support.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 54926ce8d2db7ebcbc4b80aae2cec571cd793e46
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Jan 11 03:01:09 2009 -0200

    ACPI: thinkpad-acpi: handle HKEY event 6030
    
    HKEY event 0x6030 is a helper for Lenovo's Advanced Thermal Management
    Windows driver, which is, of course, completely undocumented.
    
    Silence any warnings about it being an unknown alarm, and report it
    unmodified for userspace.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1c2ece758a36b48133717e4db060fbe8fa52c5cd
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Jan 11 03:01:08 2009 -0200

    ACPI: thinkpad-acpi: clean-up fan subdriver quirk
    
    Better document the Unitialized HFSP quirk, and modularize it a bit.
    This makes the code flow easier to read and reduces LOC.
    
    Apply the Unitialized HFSP closer to the source (i.e. inside the
    get_fan_status()), this fixes a harmless buglet where at driver init
    with the quirk active, the user could set the hwmon pwm1 attribute and
    switch out of pwm1_mode=2 to pwm1_mode=0 without changing pwm1_mode
    directly.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Tino Keitel <tino.keitel@tikei.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cb4293589855714b6d5079336019bf2af5fc41f8
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Jan 11 03:01:07 2009 -0200

    ACPI: thinkpad-acpi: start the event hunt season
    
    Ask users to tell us about any unhandled events they find.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 106b4e6657e10831f35c32afa26d9c11e6312783
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Jan 11 03:01:06 2009 -0200

    ACPI: thinkpad-acpi: handle HKEY thermal and battery alarms
    
    Handle some HKEY events that are actually firmware alarms.  For
    now, we do the simple thing: log specific messages to the log and let
    the thinkpad-specific event pass to userspace.
    
    In the future, these events will be migrated to generic notifications
    and subsystems.
    
    These alarms are NOT available on all ThinkPads.  E.g. the T43 only
    issues 0x6011 and 0x6012.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3827e7a3fd03718d4d204c66d9e3ab9b125ae552
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Jan 11 03:01:05 2009 -0200

    ACPI: thinkpad-acpi: clean up hotkey_notify()
    
    Clean up the hotkey_notify() handler, which handles the HKEY notifications
    from the ACPI firmware.  It was getting too long and deep.
    
    No functional changes.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7646ea88af80a92f2775e17d4283830d7f09ea2d
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Jan 11 03:01:04 2009 -0200

    ACPI: thinkpad-acpi: use killable instead of interruptible mutexes
    
    Unfortunately, POSIX in all of its braindamage, do not state that userspace has
    to deal with EINTR in read/write and friends... so, lesser code just doesn't.
    
    Switch from *_interruptible to *_killable on the sysfs- and procfs-related
    mutexes.  This closes this possible can of worms.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0045c0aa7d5e787f78938e6a10927b8a516f0b83
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Jan 11 03:01:03 2009 -0200

    ACPI: thinkpad-acpi: add UWB radio support
    
    Add rfkill support for USB UWB radio devices on very recent ThinkPad
    laptop models.
    
    The new subdriver is moslty a trimmed down copy of the wwan subdriver.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Ivo van Doorn <IvDoorn@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 90d9d3c79c44bcf95bc487e9bbceaff2de370310
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Jan 11 03:01:02 2009 -0200

    ACPI: thinkpad-acpi: preserve radio state across shutdown
    
    Store in firmware NVRAM the radio state on machine shutdown for WWAN and
    bluetooth.  Also, try to set the initial boot state of these radios as the
    rfkill default state for their respective classes.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Ivo van Doorn <IvDoorn@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 153f82207c51193e4d6a7e6f0e3f9442eabeba1c
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Jan 11 03:01:01 2009 -0200

    ACPI: thinkpad-acpi: resume with radios disabled
    
    Instruct the firmware to not enable the radios when resuming.  This
    is safer, and the rfkill core will take care to manually enable any
    radios that need to be enabled.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a73f30916ee524437253739eacc682f6fb0f3ea8
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Jan 11 03:01:00 2009 -0200

    ACPI: thinkpad-acpi: debug facility to emulate the rf switches
    
    This code is required to keep the thinkpad-acpi maintainer sane, and
    it is disabled by default.
    
    Add a debug facility to simulate an rfkill hardware rocker switch, a
    bluetooth rfkill soft-switch, a WWAN rfkill soft-switch on thinkpads.
    
    The simulated switches obviously do not kill any radios in hardware or
    firmware (unlike the real one).  They also don't issue deprecated proc
    events.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e0b36fc5efd610a208b6b80e821a49302ca424ab
Author: Kay Sievers <kay.sievers@vrfy.org>
Date:   Sun Jan 11 03:00:59 2009 -0200

    ACPI: thinkpad-acpi: struct device - replace bus_id with dev_name(), dev_set_name()
    
    Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
    Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
    Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9abf0eea877d6107d3a8a5c6913450e961fb7050
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sun Jan 11 03:00:58 2009 -0200

    ACPI: thinkpad-acpi: update documents for the new location
    
    Update documentation to reflect the new location of the
    thinkpad-acpi driver.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

--Boundary_(ID_LQtGNDtYQ4Fars+NIB8MRQ)--
