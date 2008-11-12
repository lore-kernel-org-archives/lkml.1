Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbYKLC2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbYKLC2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 21:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYKLC1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 21:27:48 -0500
Received: from vms046pub.verizon.net ([206.46.252.46]:52091 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbYKLC1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 21:27:45 -0500
Date: Tue, 11 Nov 2008 21:27:41 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: [GIT PULL] ACPI patches for Linux-2.6.28-rc4
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Message-id: <alpine.LFD.2.00.0811112126430.12712@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

Two .28 regression fixes.
Some video patches shipping in SuSE that I should have included earlier.
Some EC patches to deal with some out of spec hardware
Some processor fixes for HP's big iron
Some misc stuff

This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.28/acpi-release-20080926-2.6.28-rc4.diff.gz

 Documentation/ABI/testing/sysfs-firmware-acpi |   16 +-
 Documentation/acpi/debug.txt                  |  148 ++++++++++++++
 Documentation/kernel-parameters.txt           |   87 ++++-----
 MAINTAINERS                                   |   11 +-
 arch/x86/include/asm/acpi.h                   |    1 -
 arch/x86/kernel/acpi/boot.c                   |    1 -
 drivers/acpi/Kconfig                          |   22 +--
 drivers/acpi/Makefile                         |    8 +-
 drivers/acpi/ac.c                             |    3 +-
 drivers/acpi/acpi_memhotplug.c                |    1 -
 drivers/acpi/battery.c                        |    3 +-
 drivers/acpi/bus.c                            |   11 +-
 drivers/acpi/button.c                         |    3 +-
 drivers/acpi/cm_sbs.c                         |    7 -
 drivers/acpi/container.c                      |    1 -
 drivers/acpi/debug.c                          |   15 ++
 drivers/acpi/ec.c                             |   97 ++++++---
 drivers/acpi/events/evgpe.c                   |    2 -
 drivers/acpi/events/evxfevnt.c                |   41 ++---
 drivers/acpi/fan.c                            |    1 -
 drivers/acpi/glue.c                           |   40 ++++
 drivers/acpi/pci_link.c                       |   11 +-
 drivers/acpi/pci_root.c                       |    6 -
 drivers/acpi/power.c                          |   11 +-
 drivers/acpi/processor_core.c                 |   93 +++++----
 drivers/acpi/processor_idle.c                 |    1 -
 drivers/acpi/processor_perflib.c              |    2 +-
 drivers/acpi/processor_thermal.c              |    1 -
 drivers/acpi/processor_throttling.c           |    2 +-
 drivers/acpi/reboot.c                         |   25 +--
 drivers/acpi/scan.c                           |   42 +----
 drivers/acpi/sleep/proc.c                     |    4 +-
 drivers/acpi/sleep/wakeup.c                   |    8 +-
 drivers/acpi/system.c                         |   48 +++--
 drivers/acpi/tables/tbfadt.c                  |    2 +-
 drivers/acpi/thermal.c                        |    9 +-
 drivers/acpi/video.c                          |   42 ++--
 drivers/acpi/video_detect.c                   |  267 +++++++++++++++++++++++++
 drivers/acpi/wmi.c                            |    2 +-
 drivers/char/sonypi.c                         |    4 +-
 drivers/idle/Kconfig                          |    3 +-
 drivers/misc/Kconfig                          |    4 +-
 drivers/misc/acer-wmi.c                       |    6 +
 drivers/misc/asus-laptop.c                    |   10 +-
 drivers/misc/compal-laptop.c                  |   12 +-
 drivers/misc/eeepc-laptop.c                   |   12 +-
 drivers/misc/fujitsu-laptop.c                 |   43 +++--
 drivers/misc/intel_menlow.c                   |   10 +-
 drivers/misc/msi-laptop.c                     |   16 +-
 drivers/misc/sony-laptop.c                    |    6 +-
 drivers/misc/thinkpad_acpi.c                  |   29 ++-
 include/acpi/acpi_bus.h                       |    2 +
 include/acpi/acpi_drivers.h                   |   22 ++-
 include/acpi/acpixf.h                         |    4 +-
 include/acpi/actypes.h                        |    1 +
 include/linux/acpi.h                          |   48 ++++-
 56 files changed, 937 insertions(+), 390 deletions(-)
 create mode 100644 Documentation/acpi/debug.txt
 create mode 100644 drivers/acpi/video_detect.c

through these commits:

Alan Jenkins (1):
      ACPI: EC: make kernel messages more useful when GPE storm is detected

Alexey Starikovskiy (7):
      ACPI EC: Fix regression due to use of uninitialized variable
      ACPI: EC: revert msleep patch
      ACPI: EC: wait for last write gpe
      ACPI: EC: restart failed command
      ACPICA: Use spinlock for acpi_{en|dis}able_gpe
      ACPI: EC: lower interrupt storm treshold
      ACPI: EC: Don't do transaction from GPE handler in poll mode.

Bjorn Helgaas (11):
      ACPI: remove comments about debug layer/level to use
      ACPI: SBS: remove useless acpi_cm_sbs_init() initcall
      ACPI: remove CONFIG_ACPI_POWER
      ACPI: remove CONFIG_ACPI_EC
      PNP: add Bjorn Helgaas as PNP co-maintainer
      ACPI: consolidate ACPI_*_COMPONENT definitions in acpi_drivers.h
      ACPI: fix conflicting component definitions
      ACPI: add driver component definitions to sysfs debug_layers
      ACPI: turn off all debug output by default
      ACPI: update debug parameter documentation
      ACPI: pci_link: remove acpi_irq_balance_set() interface

Kay Sievers (1):
      ACPI: struct device - replace bus_id with dev_name(), dev_set_name()

Len Brown (1):
      Revert "ACPI: Ingore the RESET_REG_SUP bit when using ACPI reset mechanism"

Lin Ming (1):
      Delete an unwanted return statement at evgpe.c

Matthew Garrett (1):
      sony-laptop: Ignore missing _DIS method on pic device

Myron Stowe (3):
      ACPI: Disambiguate processor declaration type
      ACPI: Behave uniquely based on processor declaration definition type
      ACPI: 80 column adherence and spelling fix (no functional change)

Peter Gruber (1):
      ACPI: avoid empty file name in sysfs

Randy Dunlap (1):
      fujitsu-laptop: fix section mismatch warning

Thomas Renninger (10):
      ACPI: video: Ignore devices that aren't present in hardware
      ACPI video: if no ACPI backlight support, use vendor drivers
      Acer-WMI: fingers off backlight if video.ko is serving this functionality
      asus-acpi: fingers off backlight if video.ko is serving this functionality
      compal: fingers off backlight if video.ko is serving this functionality
      eeepc-laptop: fingers off backlight if video.ko is serving this functionality
      fujitsu-laptop: fingers off backlight if video.ko is serving this functionality
      msi-laptop: fingers off backlight if video.ko is serving this functionality
      sony-laptop: fingers off backlight if video.ko is serving this functionality
      thinkpad_acpi: fingers off backlight if video.ko is serving this functionality

Thomas, Sujith (2):
      intel_menlow: Add comment documenting legal GTHS values
      intel_menlow: MAINTAINERS

Tony Vroon (1):
      fujitsu-laptop: Add DMI callback for Lifebook S6420

Venki Pallipadi (1):
      i7300_idle: Kconfig, show menu only on x86_64

Yinghai Lu (1):
      ACPI: use macro to replace hard number

Zhang Rui (2):
      ACPI: bugfix reporting of event handler status
      intel_menlow: don't set max_state a negative value

Zhao Yakui (2):
      ACPI: fix de-reference bug in power resource driver
      ACPI: fan: Delete the strict check in power transition

with this log:

commit d1876ba4dead6ace7e9fbf16f83397e6486d0dfe
Merge: 547f784... 8517934...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Nov 11 21:17:26 2008 -0500

    Merge branch 'ec' into release

commit 547f7847472c097a54adf38e6576f95ab512e27c
Merge: f398778... 5b53ed6...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Nov 11 21:17:03 2008 -0500

    Merge branch 'processor-256' into release

commit f398778aa336a2919ee04ba45d915007230c6957
Merge: 9b5a56d... 2dba1b5...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Nov 11 21:15:50 2008 -0500

    Merge branch 'video' into release
    
    Conflicts:
    	Documentation/kernel-parameters.txt
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9b5a56ddfd615a27e3a0856ceae1592a24021e42
Merge: a0017f4... 0794469...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Nov 11 21:14:49 2008 -0500

    Merge branch 'sysfs' into release

commit a0017f471054a46379abbc4c96e269deaff5d9d9
Merge: f613984... bd2b064...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Nov 11 21:14:25 2008 -0500

    Merge branch 'sony' into release

commit f613984902b64cfb05599f9ba52c0af39cb4db6b
Merge: 3e0fe36... 676962d...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Nov 11 21:14:15 2008 -0500

    Merge branch 'power' into release

commit 3e0fe364835cecc8560cf32bb9609f4c56c5d9fa
Merge: e911d27... 3283625...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Nov 11 21:14:11 2008 -0500

    Merge branch 'misc' into release

commit e911d27af43e7d28d59a96a4682e8942f0661469
Merge: 50f19e3... d21cf3c...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Nov 11 21:14:01 2008 -0500

    Merge branch 'bugzilla-11917' into release

commit 50f19e37c38e82c4fd2aa50fedbfa3aac7903e5a
Merge: 597e4fa... 4feba70...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Nov 11 21:13:55 2008 -0500

    Merge branch 'bugzilla-11539' into release

commit 597e4fabb0b0c7fdfa7c2d551fd0a797aab7e53b
Merge: 3ad4f59... ed206fa...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Nov 11 21:13:50 2008 -0500

    Merge branch 'bugzilla-11312' into release

commit 32836259ff25ce97010569706cd33ba94de81d62
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Wed Nov 5 16:17:52 2008 -0700

    ACPI: pci_link: remove acpi_irq_balance_set() interface
    
    This removes the acpi_irq_balance_set() interface from the PCI
    interrupt link driver.
    
    x86 used acpi_irq_balance_set() to tell the PCI interrupt link
    driver to configure links to minimize IRQ sharing.  But the link
    driver can easily figure out whether to turn on IRQ balancing
    based on the IRQ model (PIC/IOAPIC/etc), so we can get rid of
    that external interface.
    
    It's better for the driver to figure this out at init-time.  If
    we set it externally via the x86 code, the interface reduces
    modularity, and we depend on the fact that acpi_process_madt()
    happens before we process the kernel command line.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 56960b546a88844a6f5295a9f81aab9e6b81edc9
Author: Tony Vroon <tony@linx.net>
Date:   Sun Nov 9 04:20:05 2008 +0000

    fujitsu-laptop: Add DMI callback for Lifebook S6420
    
    The Lifebook S6420 is the ICH9M-based follow-up to the S6410. The application panel
    contains the following keys: lock, mobility center, eco, info.
    Whilst key 4 might be more appropriate for help then key 2, I've done things the
    S6410 way. I can confirm that backlight control is functional, and that the lock key
    activates the Gnome screensaver as expected.
    
    Signed-off-by: Tony Vroon <tony@linx.net>
    Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8517934ef6aaa28d6e055b98df65b31cedbd1372
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Tue Nov 11 12:54:11 2008 +0300

    ACPI: EC: Don't do transaction from GPE handler in poll mode.
    
    Referencies: http://bugzilla.kernel.org/show_bug.cgi?id=12004
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 06cf7d3c7af902939cd1754abcafb2464060cba8
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Sun Nov 9 19:01:06 2008 +0300

    ACPI: EC: lower interrupt storm treshold
    
    http://bugzilla.kernel.org/show_bug.cgi?id=11892
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0b7084ac67fb84f0cf2f8bc02d7e0dea8521dd2d
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Sat Oct 25 21:48:46 2008 +0400

    ACPICA: Use spinlock for acpi_{en|dis}able_gpe
    
    Disabling gpe might interfere with gpe detection/handling,
    thus producing "interrupt not handled" errors.
    Ironically, disabling of GPE from interrupt context is already
    under spinlock, so only userspace needs to start using it.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a2f93aeadf97e870ff385030633a73e21146815d
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed Nov 12 01:40:19 2008 +0300

    ACPI: EC: restart failed command
    
    Restart current transaction if we recieved unexpected GPEs instead
    of needed ones.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=11896
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit dd15f8c42af09031e27da5b4d697ce925511f2e1
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Sat Nov 8 21:42:30 2008 +0300

    ACPI: EC: wait for last write gpe
    
    There is a possibility that EC might break if next command is
    issued within 1 us after write or burst-disable command.
    
    Suggestd-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f8248434e6a11d7cd314281be3b39bbcf82fc243
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Sat Nov 1 11:05:26 2008 +0000

    ACPI: EC: make kernel messages more useful when GPE storm is detected
    
    Make sure we can tell if the GPE storm workaround gets activated,
    and avoid flooding the logs afterwards.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=11841
    "plenty of line "ACPI: EC: non-query interrupt received,
     switching to interrupt mode" in dmesg"
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1cfe62c8010ac56e1bd3827e30386a87cc2f3594
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Tue Oct 28 00:35:30 2008 +0300

    ACPI: EC: revert msleep patch
    
    With the better solution for EC interrupt storm issue,
    there is no need to use msleep over udelay.
    
    References:
    	http://bugzilla.kernel.org/show_bug.cgi?id=11810
    	http://bugzilla.kernel.org/show_bug.cgi?id=10724
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2dba1b5d87e08a294da5cdfa4d32908000e9b085
Author: Thomas Renninger <trenn@suse.de>
Date:   Fri Aug 1 17:38:03 2008 +0200

    thinkpad_acpi: fingers off backlight if video.ko is serving this functionality
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 540b8bb9c33935183ceb5bed466a42ad72b2af56
Author: Thomas Renninger <trenn@suse.de>
Date:   Fri Aug 1 17:38:02 2008 +0200

    sony-laptop: fingers off backlight if video.ko is serving this functionality
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a598c82f39892069a8f6693459b1179fd9ef30e1
Author: Thomas Renninger <trenn@suse.de>
Date:   Fri Aug 1 17:38:01 2008 +0200

    msi-laptop: fingers off backlight if video.ko is serving this functionality
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7d5c89a615c5dae039094a3cf4a56fe6aab81765
Author: Thomas Renninger <trenn@suse.de>
Date:   Fri Aug 1 17:38:00 2008 +0200

    fujitsu-laptop: fingers off backlight if video.ko is serving this functionality
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a2bf8c01048f855fbf65a8fc41460aef71ca39dc
Author: Thomas Renninger <trenn@suse.de>
Date:   Fri Aug 1 17:37:59 2008 +0200

    eeepc-laptop: fingers off backlight if video.ko is serving this functionality
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 29454f17124c655236d2972dad21907e15ca294b
Author: Thomas Renninger <trenn@suse.de>
Date:   Fri Aug 1 17:37:58 2008 +0200

    compal: fingers off backlight if video.ko is serving this functionality
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6766fec3669d5053b987e111afb348b885237bfc
Author: Thomas Renninger <trenn@suse.de>
Date:   Fri Aug 1 17:37:57 2008 +0200

    asus-acpi: fingers off backlight if video.ko is serving this functionality
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit febf2d95a71cd594182e4b3defb0e0ffdfe61482
Author: Thomas Renninger <trenn@suse.de>
Date:   Fri Aug 1 17:37:56 2008 +0200

    Acer-WMI: fingers off backlight if video.ko is serving this functionality
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Acked-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c3d6de698c84efdbdd3781b7058bcc339ab43da8
Author: Thomas Renninger <trenn@suse.de>
Date:   Fri Aug 1 17:37:55 2008 +0200

    ACPI video: if no ACPI backlight support, use vendor drivers
    
    If an ACPI graphics device supports backlight brightness functions (cmp. with
    latest ACPI spec Appendix B), let the ACPI video driver control backlight and
    switch backlight control off in vendor specific ACPI drivers (asus_acpi,
    thinkpad_acpi, eeepc, fujitsu_laptop, msi_laptop, sony_laptop, acer-wmi).
    
    Currently it is possible to load above drivers and let both poke on the
    brightness HW registers, the video and vendor specific ACPI drivers -> bad.
    
    This patch provides the basic support to check for BIOS capabilities before
    driver loading time. Driver specific modifications are in separate follow up
    patches.
    
    "acpi_backlight=vendor"
    	Prever vendor driver over ACPI driver for backlight.
    "acpi_backlight=video" (default)
    	Prever ACPI driver over vendor driver for backlight.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 22c13f9d8179f4c9caecfcb60a95214562b9addc
Author: Thomas Renninger <trenn@suse.de>
Date:   Fri Aug 1 17:37:54 2008 +0200

    ACPI: video: Ignore devices that aren't present in hardware
    
    This is a reimplemention of commit
    0119509c4fbc9adcef1472817fda295334612976
    from Matthew Garrett <mjg59@srcf.ucam.org>
    
    This patch got removed because of a regression: ThinkPads with a
    Intel graphics card and an Integrated Graphics Device BIOS implementation
    stopped working.
    In fact, they only worked because the ACPI device of the discrete, the
    wrong one, got used (via int10). So ACPI functions were poking on the wrong
    hardware used which is a sever bug.
    The next patch provides support for above ThinkPads to be able to
    switch brightness via the legacy thinkpad_acpi driver and automatically
    detect when to use it.
    
    Original commit message from Matthew Garrett:
        Vendors often ship machines with a choice of integrated or discrete
        graphics, and use the same DSDT for both. As a result, the ACPI video
        module will locate devices that may not exist on this specific platform.
        Attempt to determine whether the device exists or not, and abort the
        device creation if it doesn't.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9614
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a1a8d334f9e8c89a15bba8f34e443a37c29079c3
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Jul 31 23:02:28 2008 +0200

    Delete an unwanted return statement at evgpe.c
    
    Len's tree branch release-2.6.27, found an unwanted return statement at
    evgpe.c.
    
    (git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6
    release-2.6.27)
    
    Signed-of-by Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a0d84a92df43b7206b9c1330a2cccf109cf0a41a
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Fri Nov 7 16:58:05 2008 -0700

    ACPI: update debug parameter documentation
    
    Reformat acpi.debug_layer and acpi.debug_level documentation so it's
    more readable, add some clues about how to figure out the mask bits that
    enable a specific ACPI_DEBUG_PRINT statement, and include some useful
    examples.
    
    Move the list of masks to Documentation/acpi/debug.txt (these are
    copies of the authoritative values in acoutput.h and acpi_drivers.h).
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 87b586088ef953c602680e5aff8ab83a2e299498
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Fri Nov 7 16:58:00 2008 -0700

    ACPI: turn off all debug output by default
    
    When CONFIG_ACPI_DEBUG=y, the default acpi_dbg_layer and acpi_dbg_level
    values built into the ACPI CA have some debug output enabled.  We'd
    rather be quiet unless the user actually specified the acpi.debug_level
    argument.
    
    This enables distros to ship with CONFIG_ACPI_DEBUG=y without
    inundating users with debug output.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bdd7279919f682da8752fb47784a1ee302f8b7ea
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Fri Nov 7 16:57:55 2008 -0700

    ACPI: add driver component definitions to sysfs debug_layers
    
    /sys/module/acpi/parameters/debug_layers used to contain only the
    debug layers defined by the ACPI CA.  This patch adds the additional
    layer definitions for ACPI drivers.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 44342f9e8dfbe8c0fadf940bf6b5c2eaaffe6850
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Fri Nov 7 16:57:50 2008 -0700

    ACPI: fix conflicting component definitions
    
    Some of the component definitions that were previous scattered around
    the drivers conflict with each other.  That doesn't hurt anything
    except that setting one bit in the debug_layer mask would turn on
    debugging in two different modules.  This patch fixes the conflicts.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 89595b8f2850a080d290bf778ec933ea1d99f78e
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Fri Nov 7 16:57:45 2008 -0700

    ACPI: consolidate ACPI_*_COMPONENT definitions in acpi_drivers.h
    
    Move all the component definitions for drivers to a single shared place,
    include/acpi/acpi_drivers.h.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d21cf3c16b1191f3154a51e0b20c82bf851cc553
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Mon Nov 3 14:26:40 2008 -0500

    ACPI EC: Fix regression due to use of uninitialized variable
    
    breakage introduced by following patch
    commit 27663c5855b10af9ec67bc7dfba001426ba21222
    Author: Matthew Wilcox <willy@linux.intel.com>
    Date:   Fri Oct 10 02:22:59 2008 -0400
    
    acpi_evaluate_integer() does not clear passed variable if
    there is an error at evaluation.
    So if we ignore error, we must supply initialized variable.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=11917
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Tested-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4feba70a2c1a1a0c96909f657f48b2e11e682370
Author: Peter Gruber <nokos@gmx.net>
Date:   Mon Oct 27 23:59:36 2008 -0400

    ACPI: avoid empty file name in sysfs
    
    Since commit bc45b1d39a925b56796bebf8a397a0491489d85c acpi tables are
    allowed to have an empty signature and /sys/firmware/acpi/tables uses the
    signature as filename.  Applications using naive recursion through /sys
    loop forever.  A possible solution would be: (replacing the zero length
    filename with the string "NULL")
    
    http://bugzilla.kernel.org/show_bug.cgi?id=11539
    
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 14a63ba821ac2a0f5166789b31241c0b7eb147d9
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Wed Oct 29 14:13:22 2008 -0700

    ACPI: use macro to replace hard number
    
    Impact: cleanup
    
    Use MACRO for rev 3 fadt id instead of 3 directly.
    
    Signed-off-by: Yinghai Lu <yinghai@kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit afeb12b7478fee31888e7c34804bee2f658e7765
Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Wed Oct 29 14:13:20 2008 -0700

    fujitsu-laptop: fix section mismatch warning
    
    Could fix a bug in a hotplug add scenario.
    
    WARNING: drivers/misc/fujitsu-laptop.o(.text+0xbde): Section mismatch in reference from the function acpi_fujitsu_add() to the variable .init.data:fujitsu_dmi_table
    The function acpi_fujitsu_add() references
    the variable __initdata fujitsu_dmi_table.
    This is often because acpi_fujitsu_add lacks a __initdata
    annotation or the annotation of fujitsu_dmi_table is wrong.
    
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0794469da3f7b2093575cbdfc1108308dd3641ce
Author: Kay Sievers <kay.sievers@vrfy.org>
Date:   Thu Oct 30 01:18:59 2008 +0100

    ACPI: struct device - replace bus_id with dev_name(), dev_set_name()
    
    This patch is part of a larger patch series which will remove
    the "char bus_id[20]" name string from struct device. The device
    name is managed in the kobject anyway, and without any size
    limitation, and just needlessly copied into "struct device".
    
    To set and read the device name dev_name(dev) and dev_set_name(dev)
    must be used. If your code uses static kobjects, which it shouldn't
    do, "const char *init_name" can be used to statically provide the
    name the registered device should have. At registration time, the
    init_name field is cleared, to enforce the use of dev_name(dev) to
    access the device name at a later time.
    
    We need to get rid of all occurrences of bus_id in the entire tree
    to be able to enable the new interface. Please apply this patch,
    and possibly convert any remaining remaining occurrences of bus_id.
    
    We want to submit a patch to -next, which will remove bus_id from
    "struct device", to find the remaining pieces to convert, and finally
    switch over to the new api, which will remove the 20 bytes array
    and does no longer have a size limitation.
    
    Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
    Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2d59f6a73e1cb4415cdd5a0083b1196cceffa275
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Fri Aug 1 10:01:12 2008 -0600

    PNP: add Bjorn Helgaas as PNP co-maintainer
    
    Update Adam's email address and add myself as PNP co-maintainer.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d17cb18a07c587b8f9ff174a1bf6d03413eabe64
Author: Len Brown <len.brown@intel.com>
Date:   Thu Nov 6 20:51:59 2008 -0500

    Revert "ACPI: Ingore the RESET_REG_SUP bit when using ACPI reset mechanism"
    
    This reverts commit 8fd145917fb62368a9b80db59562c20576238f5a.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=11942
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f4a9bc4c7de4cef83e86a7052eb2e88b193668e4
Author: Thomas, Sujith <sujith.thomas@intel.com>
Date:   Wed Nov 5 16:15:31 2008 +0530

    intel_menlow: MAINTAINERS
    
    Signed-off-by: Sujith Thomas <sujith.thomas@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d65dcdcf0cd55b4be1fd1f5025388e91042d63fc
Author: Thomas, Sujith <sujith.thomas@intel.com>
Date:   Wed Nov 5 16:15:13 2008 +0530

    intel_menlow: Add comment documenting legal GTHS values
    
    Signed-off-by: Sujith Thomas <sujith.thomas@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5b53ed69158eeff115004f246193d07a083445f6
Author: Myron Stowe <myron.stowe@hp.com>
Date:   Tue Nov 4 14:53:05 2008 -0700

    ACPI: 80 column adherence and spelling fix (no functional change)
    
    Signed-off-by: Myron Stowe <myron.stowe@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b26e9286fb438eb78bcdb68b67a3dbb8bc539125
Author: Myron Stowe <myron.stowe@hp.com>
Date:   Tue Nov 4 14:53:00 2008 -0700

    ACPI: Behave uniquely based on processor declaration definition type
    
    Associating a Local SAPIC with a processor object is dependent upon the
    processor object's definition type.  CPUs declared as "Processor" should
    use the Local SAPIC's 'processor_id', and CPUs declared as "Device"
    should use the 'uid'.  Note that for "Processor" declarations, even if a
    '_UID' child object exists, it has no bearing with respect to mapping
    Local SAPICs (see section 5.2.11.13 - Local SAPIC Structure; "Advanced
    Configuration and Power Interface Specification", Revision 3.0b).
    
    This patch changes the lsapic mapping logic to rely on the distinction of
    how the processor object was declared - the mapping can't just try both
    types of matches regardless of declaration type and rely on one failing
    as is currently being done.
    
    Signed-off-by: Myron Stowe <myron.stowe@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ad93a765c1834db031b5bf1c2baf2a50d0462ca4
Author: Myron Stowe <myron.stowe@hp.com>
Date:   Tue Nov 4 14:52:55 2008 -0700

    ACPI: Disambiguate processor declaration type
    
    Declaring processors in ACPI namespace can be done using either a
    "Processor" definition or a "Device" definition (see section 8.4 -
    Declaring Processors; "Advanced Configuration and Power Interface
    Specification", Revision 3.0b).  Currently the two processor
    declaration types are conflated.
    
    This patch disambiguates the processor declaration's definition type
    enabling subsequent code to behave uniquely based explicitly on the
    declaration's type.
    
    Signed-off-by: Myron Stowe <myron.stowe@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8950d89acaa8c353869e681772479d7955ae6f7a
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Wed Nov 5 16:18:03 2008 -0700

    ACPI: remove CONFIG_ACPI_EC
    
    Remove CONFIG_ACPI_EC.  It was always set the same as CONFIG_ACPI,
    and it had no menu label, so there was no way to set it to anything
    other than "y".
    
    Per section 6.5.4 of the ACPI 3.0b specification,
    
        OSPM must make Embedded Controller operation regions, accessed
        via the Embedded Controllers described in ECDT, available before
        executing any control method.
    
    The ECDT table is optional, but if it is present, the above text
    means that the EC it describes is a required part of the ACPI
    subsystem, so CONFIG_ACPI_EC=n wouldn't make sense.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fefe5ab3d67b0ade6200fec5ed6f2812cbcbb658
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Wed Nov 5 16:17:58 2008 -0700

    ACPI: remove CONFIG_ACPI_POWER
    
    Remove CONFIG_ACPI_POWER.  It was always set the same as CONFIG_ACPI,
    and it had no menu label, so there was no way to set it to anything
    other than "y".
    
    The interfaces under CONFIG_ACPI_POWER (acpi_device_sleep_wake(),
    acpi_power_transition(), etc) are called unconditionally from the
    ACPI core, so we already depend on it always being present.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5b881479af4352791e5004b74e3639f1416c5fe4
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Wed Nov 5 16:17:47 2008 -0700

    ACPI: SBS: remove useless acpi_cm_sbs_init() initcall
    
    acpi_cm_sbs_init() doesn't do anything, so we can just remove it.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5704d626e7c770ef4a984a697bac7eff07420a39
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Wed Nov 5 16:17:42 2008 -0700

    ACPI: remove comments about debug layer/level to use
    
    I don't think there's any point in cluttering the code with these.
    Better to improve the documentation so *anybody* can figure out
    what layer & level to use.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c2d06fe338912ee56c2ddd7de5574d5396ed8050
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Sep 11 10:56:00 2008 +0800

    intel_menlow: don't set max_state a negative value
    
    max_state is unsigned long.
    don't set max_state a negative value
    
    Cc : Thomas Sujith <sujith.thomas@intel.com>
    Cc : Roel Kluin <roel.kluin@gmail.com>
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ed206fac87d65917280b6c3edd3f01125d4095c9
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Mon Oct 27 14:01:02 2008 -0700

    ACPI: bugfix reporting of event handler status
    
    Introduce a new flag showing whether the event has an event handler/method.
    
    For all the GPEs and Fixed Events,
     1. ACPI_EVENT_FLAG_HANDLE is cleared, it's an "invalid" ACPI event.
     2. Both ACPI_EVENT_FLAG_HANDLE and ACPI_EVENT_FLAG_DISABLE are set,
        it's "disabled".
     3. Both ACPI_EVENT_FLAG_HANDLE and ACPI_EVENT_FLAG_ENABLE are set,
        it's "enabled".
     4. Both ACPI_EVENT_FLAG_HANDLE and ACPI_EVENT_FLAG_WAKE_ENABLE are set,
        it's "wake_enabled".
    
    Among other things, this prevents incorrect reporting of ACPI events
    as being "invalid" when it's really just (temporarily) "disabled".
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 676962dac6e267ce7c13f73962208f9124a084bb
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Mon Oct 27 16:05:39 2008 +0800

    ACPI: fan: Delete the strict check in power transition
    
    On some laptops the Fan device is turned on/off by controlling the
    corresponding power resource. For example: If the power resource
    defined in _PR0 object is turned off, it indicates that the FAN device
    is in off state(the ACPI state is in D3 state).
    
    Maybe the device is already in D3 state and expected to be transited to
    D3 state. As there is no _PR3 object, the power transition can't be
    finished and it will be switched to the Unknown state.
    
    Maybe it is more reasonable that the strick check in power transistion
    is deleted.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9485
    
    Signed-off-by: yakui.zhao@intel.com
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b1b57fbe9bb10d94682a975456de7a727d1dbc84
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Mon Oct 27 16:04:53 2008 +0800

    ACPI: fix de-reference bug in power resource driver
    
    change state to *state in the function of acpi_power_get_state()
    
    Signed-off-by: yakui.zhao@intel.com
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bd2b064ecd5504a9e9eeaa5742b9f8bcc6d27637
Author: Matthew Garrett <mjg59@srcf.ucam.org>
Date:   Thu Oct 16 17:29:10 2008 -0400

    sony-laptop: Ignore missing _DIS method on pic device
    
    At least the Vaio VGN-Z540N doesn't have this method, so let's not fail
    to suspend just because it doesn't exist.
    
    Signed-off-by: Adam Jackson <ajax@redhat.com>
    Acked-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2830c9fb8e66cee70b8bffdfb0de01c144c7e643
Author: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Fri Oct 24 11:00:35 2008 -0700

    i7300_idle: Kconfig, show menu only on x86_64
    
    ...since today it contains only a single driver
    which is visible to just x86_64
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
