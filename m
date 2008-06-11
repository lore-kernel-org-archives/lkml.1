Return-Path: <linux-kernel-owner+w=401wt.eu-S1759015AbYFKXoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015AbYFKXoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 19:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbYFKXo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 19:44:26 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:63103 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbYFKXoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 19:44:23 -0400
Date: Wed, 11 Jun 2008 19:44:09 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: [GIT PATCH] ACPI patches for 2.6.26-rc5
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org,
       Linux Power Management List <linux-pm@lists.osdl.org>
Message-id: <alpine.LFD.1.10.0806111942510.12191@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.26/acpi-release-20080321-2.6.26-rc5.diff.gz

 Documentation/laptops/thinkpad-acpi.txt |    2 +-
 MAINTAINERS                             |   10 +-
 arch/ia64/kernel/acpi.c                 |    9 ++-
 arch/x86/mm/srat_64.c                   |   27 ------
 drivers/acpi/bay.c                      |   16 ++--
 drivers/acpi/dispatcher/dsfield.c       |    5 +-
 drivers/acpi/dock.c                     |    2 +-
 drivers/acpi/ec.c                       |    2 +-
 drivers/acpi/executer/exconfig.c        |   10 ++-
 drivers/acpi/glue.c                     |    6 ++
 drivers/acpi/hardware/hwsleep.c         |    8 +-
 drivers/acpi/numa.c                     |   31 ++++++-
 drivers/acpi/parser/psargs.c            |    4 +-
 drivers/acpi/processor_core.c           |    1 -
 drivers/acpi/processor_idle.c           |    7 +-
 drivers/acpi/sleep/proc.c               |    6 ++
 drivers/acpi/system.c                   |   15 +---
 drivers/acpi/tables/tbinstal.c          |   25 ++----
 drivers/acpi/tables/tbxface.c           |    2 +-
 drivers/acpi/thermal.c                  |   11 ++-
 drivers/acpi/utilities/utmisc.c         |    2 +-
 drivers/cpuidle/cpuidle.c               |   40 ++++++++-
 drivers/misc/thinkpad_acpi.c            |  140 ++++++++++++++++++-------------
 drivers/pnp/pnpacpi/rsparser.c          |   46 +++++++----
 include/acpi/processor.h                |    1 +
 include/linux/cpuidle.h                 |    1 +
 include/linux/ioport.h                  |    6 +-
 27 files changed, 255 insertions(+), 180 deletions(-)

through these commits:

Adrian Bunk (2):
      MAINTAINERS: update ACPI homepage
      proper prototype for acpi_processor_tstate_has_changed()

Akinobu Mita (1):
      ACPI: use memory_read_from_buffer()

Alexey Starikovskiy (1):
      ACPI: EC: Use msleep instead of udelay while waiting for event.

Alistair John Strachan (1):
      ACPI 2.6.26-rc2: Add missing newline to DSDT/SSDT warning message

Arjan van de Ven (1):
      ACPI: Reject below-freezing temperatures as invalid critical temperatures

Bjorn Helgaas (3):
      pnpacpi: fix IRQ flag decoding
      pnpacpi: fix shareable IRQ encode/decode
      PNPACPI: use _CRS IRQ descriptor length for _SRS

Bob Moore (5):
      ACPICA: Fix to allow zero-length ASL field declarations
      ACPICA: Ignore ACPI table signature for Load() operator
      ACPICA: Fix for Load operator, load table at the namespace root
      ACPICA: Fix to make _SST method optional
      ACPICA: Fix for access to deleted object <regression>

Fenghua Yu (1):
      ACPI: handle invalid ACPI SLIT table

Henrique de Moraes Holschuh (3):
      thinkpad-acpi: SW_RADIO to SW_RFKILL_ALL rename
      thinkpad-acpi: fix initialization error paths
      thinkpad-acpi: fix LED handling on older ThinkPads

Holger Macht (1):
      bay: exit if notify handler cannot be installed

Len Brown (1):
      ACPICA: fix stray va_end() caused by mis-merge

Tim Pepper (1):
      dock.c remove trailing printk whitespace

Venkatesh Pallipadi (1):
      cpuidle acpi driver: fix oops on AC<->DC

Zhao Yakui (1):
      ACPI: Disable Fixed_RTC event when installing RTC handler

with this log:

commit 3549dba2c334e82df90f5e00ff85d2a7a2cdd1af
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jun 6 15:32:39 2008 -0400

    ACPICA: fix stray va_end() caused by mis-merge
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a39a2d7c72b358c6253a2ec28e17b023b7f6f41c
Author: Arjan van de Ven <arjan@linux.intel.com>
Date:   Mon May 19 15:55:15 2008 -0700

    ACPI: Reject below-freezing temperatures as invalid critical temperatures
    
    My laptop thinks that it's a good idea to give -73C as the critical
    CPU temperature.... which isn't the best thing since it causes a shutdown
    right at bootup.
    
    Temperatures below freezing are clearly invalid critical thresholds
    so just reject these as such.
    
    Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8410565f540db87ca938f56f92780d251e4f157d
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Jun 10 14:29:26 2008 +0800

    ACPICA: Fix for access to deleted object <regression>
    
    Fixes problem introduced in 20080123, with fix for Unload operator.
    Parse tree object can be already deleted; must use the opcode
    within the WalkState.
    
    ACPI: kmemcheck: Caught 16-bit read from freed memory
    http://bugzilla.kernel.org/show_bug.cgi?id=10669
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d52c79ace60a2e2b22455fd195ff4bc8e7afa177
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Jun 10 14:26:57 2008 +0800

    ACPICA: Fix to make _SST method optional
    
    Fixes a problem introduced in 20080514 where the status of
    execution of _SST is incorrectly returned to the caller. _SST
    is optional, and if it is AE_NOT_FOUND, the exception should be
    ignored.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=716
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0bda3f2f86e233b00b46d91b07db25dd23ec15bc
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Jun 10 14:14:17 2008 +0800

    ACPICA: Fix for Load operator, load table at the namespace root
    
    This reverts a change introduced in version 20071019. The table
    is now loaded at the namespace root even though this goes against
    the ACPI specification.  This provides compatibility with other
    ACPI implementations.
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bc45b1d39a925b56796bebf8a397a0491489d85c
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Jun 10 14:12:50 2008 +0800

    ACPICA: Ignore ACPI table signature for Load() operator
    
    Only "SSDT" is acceptable to the ACPI spec, but tables are
    seen with OEMx and null sigs. Therefore, signature validation
    is worthless.  Apparently MS ACPI accepts such signatures, ACPICA
    must be compatible.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=10454
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7aa7d4336df34e32195557a1ad422627bd69ef0b
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Jun 10 13:00:32 2008 +0800

    ACPICA: Fix to allow zero-length ASL field declarations
    
    Allows null field list in Field(), BankField(), and IndexField().
    
    2.6.26-rc1 regression: ACPI fails to load SDT. - Dell M1530
    http://bugzilla.kernel.org/show_bug.cgi?id=10606
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 46a21e465e506bcd4dba759a39e7ef79978a705d
Author: Akinobu Mita <akinobu.mita@gmail.com>
Date:   Mon Jun 9 16:22:26 2008 -0700

    ACPI: use memory_read_from_buffer()
    
    Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7efd52a407bed6a2b02015b8ebbff7beba155392
Author: Holger Macht <hmacht@suse.de>
Date:   Mon Jun 9 16:22:24 2008 -0700

    bay: exit if notify handler cannot be installed
    
    If acpi_install_notify_handler() for a bay device fails, the bay driver is
    superfluous.  Most likely, another driver (like libata) is already caring
    about this device anyway.  Furthermore,
    register_hotplug_dock_device(acpi_handle) from the dock driver must not be
    called twice with the same handler.  This would result in an endless loop
    consuming 100% of CPU.  So clean up and exit.
    
    Signed-off-by: Holger Macht <hmacht@suse.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1fdd68608614cd1e951fd93873fe5597374e8c54
Author: Tim Pepper <lnxninja@linux.vnet.ibm.com>
Date:   Mon Jun 9 16:22:25 2008 -0700

    dock.c remove trailing printk whitespace
    
    Signed-off-by: Tim Pepper <lnxninja@linux.vnet.ibm.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a66b34b26fe1b0983c6d91b6381df806cd98886e
Author: Adrian Bunk <bunk@kernel.org>
Date:   Mon Jun 9 16:22:24 2008 -0700

    proper prototype for acpi_processor_tstate_has_changed()
    
    This patch adds a proper prototype for acpi_processor_tstate_has_changed()
    in include/acpi/processor.h
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Cc: Len Brown <lenb@kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 39b8931b5cad9a7cbcd2394a40a088311e783a82
Author: Fenghua Yu <fenghua.yu@intel.com>
Date:   Mon Jun 9 16:48:18 2008 -0700

    ACPI: handle invalid ACPI SLIT table
    
    This is a SLIT sanity checking patch.  It moves slit_valid() function to
    generic ACPI code and does sanity checking for both x86 and ia64.  It sets up
    node_distance with LOCAL_DISTANCE and REMOTE_DISTANCE when hitting invalid
    SLIT table on ia64.  It also cleans up unused variable localities in
    acpi_parse_slit() on x86.
    
    Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 36d872a370d3d10e5a7faa9dcacce744260fb13b
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Jun 9 16:52:06 2008 -0700

    PNPACPI: use _CRS IRQ descriptor length for _SRS
    
    When configuring the resources of an ACPI device, we first evaluate _CRS
    to get a template of resource descriptors, then fill in the specific
    resource values we want, and finally evaluate _SRS to actually configure
    the device.
    
    Some resources have optional fields, so the size of encoded descriptors
    varies depending on the specific values.  For example, IRQ descriptors can
    be either two or three bytes long.  The third byte contains triggering
    information and can be omitted if the IRQ is edge-triggered and active
    high.
    
    The BIOS often assumes that IRQ descriptors in the _SRS buffer use the
    same format as those in the _CRS buffer, so this patch enforces that
    constraint.
    
    The "Start Dependent Function" descriptor also has an optional byte, but
    we don't currently encode those descriptors, so I didn't do anything for
    those.
    
    I have tested this patch on a Toshiba Portege 4000.  Without the patch,
    parport_pc claims the parallel port only if I use "pnpacpi=off".  This
    patch makes it work with PNPACPI.
    
    This is an extension of a patch by Tom Jaeger:
        http://bugzilla.kernel.org/show_bug.cgi?id=9487#c42
    
    References:
        http://bugzilla.kernel.org/show_bug.cgi?id=5832 Enabling ACPI Plug and Play in kernels >2.6.9 kills Parallel support
        http://bugzilla.kernel.org/show_bug.cgi?id=9487 buggy firmware expects four-byte IRQ resource descriptor (was: Serial port disappears after Suspend on Toshiba R25)
        http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=1d5b285da1893b90507b081664ac27f1a8a3dc5b related ACPICA fix
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a993273beae8022390e48fe9205480565ad470ab
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Jun 9 16:52:05 2008 -0700

    pnpacpi: fix shareable IRQ encode/decode
    
    When we encode IRQ resources, we should use the "shareable" flag we got
    from _PRS rather than guessing based on the IRQ trigger mode.
    
    This is based on a patch by Tom Jaeger:
        http://bugzilla.kernel.org/show_bug.cgi?id=9487#c32
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e9fe9e188118a0a34c6200d9b10ea6247f53592d
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Jun 9 16:52:04 2008 -0700

    pnpacpi: fix IRQ flag decoding
    
    When decoding IRQ trigger mode and polarity, it is not enough to mask by
    IORESOURCE_BITS because there are now additional bits defined.  For
    example, if IORESOURCE_IRQ_SHAREABLE was set, we failed to set *triggering
    and *polarity at all.
    
    I can't point to a failure that this patch fixes, but
    bugs in this area have caused problems when resuming after
    suspend, for example:
    
        http://bugzilla.kernel.org/show_bug.cgi?id=6316
        http://bugzilla.kernel.org/show_bug.cgi?id=9487
        https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.22/+bug/152187
    
    This is based on a patch by Tom Jaeger:
        http://bugzilla.kernel.org/show_bug.cgi?id=9487#c32
    
    [rene.herman@keyaccess.nl: fix comment]
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0638bc8dc037d844efe1d4abf44488c037705905
Author: Adrian Bunk <bunk@kernel.org>
Date:   Tue May 20 01:08:23 2008 +0300

    MAINTAINERS: update ACPI homepage
    
    This patch updates the location of the ACPI homepage in MAINTAINERS.
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c21d1e7f53ffd9c0f162c42e7fde07d1c45fa127
Author: Alistair John Strachan <alistair@devzero.co.uk>
Date:   Mon May 12 19:13:09 2008 +0100

    ACPI 2.6.26-rc2: Add missing newline to DSDT/SSDT warning message
    
    As of recently (probably 2.6.26-rc1) I've been getting the following mangling
    in the kernel log:
    
    [4294014.568167] ACPI: DSDT override uses original SSDTs unless "acpi_no_auto_ssdt"<6>CPU0: Intel(R) Pentium(R) Dual  CPU  E2160  @ 1.80GHz stepping 0d
    
    This is due to a missing newline character in the first message. The following
    patch against 2.6.26-rc2 fixes it. Please apply.
    
    Signed-off-by: Alistair John Strachan <alistair@devzero.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1b7fc5aae8867046f8d3d45808309d5b7f2e036a
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Fri Jun 6 11:49:33 2008 -0400

    ACPI: EC: Use msleep instead of udelay while waiting for event.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=10724
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 24e45bbe695719dca8c20e03d386eb6ea86526b5
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Jun 3 23:36:11 2008 -0300

    thinkpad-acpi: fix LED handling on older ThinkPads
    
    The less tested codepaths for LED handling, used on ThinkPads 570, 600e/x,
    770e, 770x, A21e, A2xm/p, T20-22, X20 and maybe a few others, would write
    data to kernel memory it had no business touching, for leds number 3 and
    above.  If one is lucky, that illegal write would cause an OOPS, but
    chances are it would silently corrupt a byte.
    
    The problem was introduced in commit af116101, "ACPI: thinkpad-acpi: add
    sysfs led class support to thinkpad leds (v3.2)".
    
    Fix the bug by refactoring the entire code to be far more obvious on what
    it wants to do.  Also do some defensive "constification".
    
    Issue reported by Karol Lewandowski <lmctlx@gmail.com> (he's an lucky guy
    and got an OOPS instead of silent corruption :-) ).
    
    Root cause of the OOPS identified by Adrian Bunk <bunk@kernel.org>.
    Thanks, Adrian!
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Tested-by: Karol Lewandowski <lmctlx@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9c0a76e16ee6648f4bd19563e9fe12a4f4fabba1
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Jun 3 23:36:10 2008 -0300

    thinkpad-acpi: fix initialization error paths
    
    Rework some subdriver init and exit handlers, in order to fix some
    initialization error paths that were missing, or broken.
    
    Hitting those bugs should be extremely rare in the real world, but should
    that happen, thinkpad-acpi would fail to dealocate some resources and a
    reboot might well be needed to be able to load the driver again.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 197a2cd907e3a5278a1cfd48c86402133f38a9ba
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Jun 3 23:36:09 2008 -0300

    thinkpad-acpi: SW_RADIO to SW_RFKILL_ALL rename
    
    Rename SW_RADIO to SW_RFKILL_ALL in thinkpad-acpi code and docs, following
    5adad0133907790c50283bf03271d920d6897043 "Input: rename SW_RADIO to
    SW_RFKILL_ALL".
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit dcb84f335bee9c9a7781cfc5d74492dccaf066d2
Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Mon May 19 19:09:27 2008 -0400

    cpuidle acpi driver: fix oops on AC<->DC
    
    cpuidle and acpi driver interaction bug with the way cpuidle_register_driver()
    is called. Due to this bug, there will be oops on
    AC<->DC on some systems, where they support C-states in one DC and not in AC.
    
    The current code does
    ON BOOT:
    	Look at CST and other C-state info to see whether more than C1 is
    	supported. If it is, then acpi processor_idle does a
    	cpuidle_register_driver() call, which internally enables the device.
    
    ON CST change notification (AC<->DC) and on suspend-resume:
    	acpi driver temporarily disables device, updates the device with
    	any new C-states, and reenables the device.
    
    The problem is is on boot, there are no C2, C3 states supported and we skip
    the register. Later on AC<->DC, we may get a CST notification and we try
    to reevaluate CST and enabled the device, without actually registering it.
    This causes breakage as we try to create /sys fs sub directory, without the
    parent directory which is created at register time.
    
    Thanks to Sanjeev for reporting the problem here.
    http://bugzilla.kernel.org/show_bug.cgi?id=10394
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e1094bfa26e5e94af2fea79e004614dbce42b008
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Wed May 14 11:32:59 2008 +0800

    ACPI: Disable Fixed_RTC event when installing RTC handler
    
    The Fixed_RTC event should be disabled when installing RTC handler.
    Only when RTC alarm is set will it be enabled again. If it is not
    disabled, maybe some machines will be powered on automatically after
    the system is shutdown even when the RTC alarm is not set.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=10010
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
