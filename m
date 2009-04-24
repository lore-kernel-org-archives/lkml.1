Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbZDXGCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbZDXGCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 02:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756005AbZDXGBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 02:01:55 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:58990 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbZDXGBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 02:01:52 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_M1KwnosXaQXO9t28NoBoCA)"
Date: Fri, 24 Apr 2009 02:01:46 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: [GIT PATCH] ACPI and driver patches for 2.6.30-rc3
Message-id: <alpine.LFD.2.00.0904240158041.15843@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_M1KwnosXaQXO9t28NoBoCA)
Content-type: TEXT/PLAIN; charset=UTF-8
Content-transfer-encoding: 8BIT

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

Some regression fixes, some bug fixes, some cleanups...
The hpet fix is fresh, but it works for me and I figured
it makes more sense to test it upstream now than wait.

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.30/acpi-release-20090422-2.6.30-rc3.diff.gz

 Documentation/ABI/testing/sysfs-firmware-acpi |    8 +-
 Documentation/laptops/thinkpad-acpi.txt       |    4 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c    |   30 +++---
 arch/x86/kernel/quirks.c                      |    2 -
 drivers/acpi/acpica/hwsleep.c                 |   43 +++++---
 drivers/acpi/acpica/hwvalid.c                 |   86 +++++++++++++---
 drivers/acpi/acpica/rscreate.c                |   27 +-----
 drivers/acpi/button.c                         |  140 ++++++++-----------------
 drivers/acpi/ec.c                             |    1 +
 drivers/acpi/osl.c                            |    4 +-
 drivers/acpi/processor_idle.c                 |   28 ++---
 drivers/acpi/sleep.c                          |   27 +++++
 drivers/acpi/system.c                         |   11 ++-
 drivers/acpi/thermal.c                        |    2 +-
 drivers/acpi/video.c                          |   51 +++++----
 drivers/gpu/drm/Kconfig                       |    1 +
 drivers/gpu/drm/i915/i915_opregion.c          |    9 +-
 drivers/platform/x86/sony-laptop.c            |   27 ++++--
 drivers/platform/x86/thinkpad_acpi.c          |   81 ++++++++-------
 include/acpi/processor.h                      |    1 -
 include/linux/acpi.h                          |    1 +
 21 files changed, 319 insertions(+), 265 deletions(-)

through these commits:

Almer S. Tigelaar (4):
      sony-laptop: Duplicate SNC 127 Event Fix
      sony-laptop: SNC 127 Initialization Fix
      sony-laptop: SNC input event 38 fix
      ACPI: EC: Fix ACPI EC resume non-query interrupt message

Bjorn Helgaas (6):
      ACPI: button: whitespace changes
      ACPI: button: remove unnecessary null pointer checks
      ACPI: button: use Linux style for getting driver_data
      ACPI: button: cache hid/name/class pointers
      ACPI: button: remove button->device pointer
      ACPI: button: remove control method/fixed hardware distinctions

Henrique de Moraes Holschuh (5):
      thinkpad-acpi: silence hotkey enable warning for module parameter
      thinkpad-acpi: fix LED blinking through timer trigger
      thinkpad-acpi: fix use of MODULE_AUTHOR
      thinkpad-acpi: simplify module autoloading
      thinkpad-acpi: bump up version to 0.23

Len Brown (8):
      ACPI: Disable _GTS and _BFS support by default
      ACPI: add /sys/firmware/acpi/interrupts/sci_not counter
      ACPI: idle: mark_tsc_unstable() at init-time, not run-time
      ACPI: delete obsolete "bus master activity" proc field
      ACPI/hpet: prevent boot hang when hpet=force used on ICH-4M
      HPET: stop soliciting hpet=force users on ICH4M
      ACPI: prevent processor.max_cstate=0 boot crash
      Revert "ACPICA: delete check for AML access to port 0x81-83"

Lin Ming (1):
      I/O port protection: update for windows compatibility.

Matthew Garrett (3):
      thermal: Fix polling frequency for systems without passive cooling
      ACPI/i915: build fix
      ACPI, i915: Register ACPI video even when not modesetting

Mattia Dongili (2):
      sony-laptop: fix bogus error message display on resume
      sony-laptop: always try to unblock rfkill on load

Pallipadi, Venkatesh (1):
      x86, acpi_cpufreq: Fix the NULL pointer dereference in get_measured_perf

Thomas Renninger (3):
      acpi-cpufreq: Cleanup: Use printk_once
      acpi-cpufreq: style-only: add parens to math expression
      acpi-cpufreq: Do not let get_measured perf depend on internal variable

Zhang Rui (3):
      ACPI: Revert conflicting workaround for BIOS w/ mangled PRT entries
      ACPI video: handle indexed _BQC correctly
      ACPI video: fix an error when the brightness levels on AC and on Battery are same

with this log:

commit 042ff65872b4c75b26827a5bc95545375f84ee8a
Merge: a76750c d68b597
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 24 01:38:22 2009 -0400

    Merge branch 'bjorn.button' into release

commit a76750c596d3947f5a19a1073faca502ab1ccc67
Merge: 31bf1f9 a38d75f
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 24 01:38:15 2009 -0400

    Merge branch 'bugzilla-13036' into release

commit 31bf1f944bf861338c34c9ab116e0e65e7fe6766
Merge: fca0f58 b7f0ab4
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 24 01:38:08 2009 -0400

    Merge branch 'bugzilla-13048' into release

commit fca0f58060c36739553566cffd55e2e39ab86c2c
Merge: 75e9c05 615dfd9
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 24 01:38:01 2009 -0400

    Merge branch 'bugzilla-13142' into release

commit 75e9c055e926c757a909e5f847c0bfeffe5fdf54
Merge: 6a33e55 f4b9c75
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 24 01:37:49 2009 -0400

    Merge branch 'hpet' into release

commit 6a33e5590fab46244e4a79ac52a118d795b14400
Merge: 2d40570 4b10fee2
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 24 01:37:41 2009 -0400

    Merge branch 'i915' into release

commit 2d40570786c7c208539c65893818119557327ba0
Merge: 04a2e62 e047cca
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 24 01:35:46 2009 -0400

    Merge branch 'bugzilla-12249' into release

commit 04a2e6297df5ff04ddfbd6f2bdeefc218195ce96
Merge: ac0849f 82babbb
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 24 01:35:33 2009 -0400

    Merge branch 'bugzilla-12270' into release

commit ac0849fb6c66ca865270fda32bcbc39f6dd52de1
Merge: 09041da 96f15ef
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 24 01:35:24 2009 -0400

    Merge branch 'bugzilla-13041' into release

commit 09041daeea467090f57507473a3ec8ec0e68be6d
Merge: f752a09 d876dfb
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 24 01:35:15 2009 -0400

    Merge branch 'cpufreq' into release

commit f752a091abd1f9d38f926823bfd5c8480dd1132b
Merge: 6e6c348 9261461
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 24 01:35:08 2009 -0400

    Merge branch 'idle' into release

commit 6e6c348fb23122c6faf89ef10f1b9f034dba0da5
Merge: 7f3745a 88bea18
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 24 01:34:59 2009 -0400

    Merge branch 'irq' into release

commit 7f3745ad7aca48b946136e3173861821fa8b24c5
Merge: 771e5ce 53005a0
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 24 01:34:52 2009 -0400

    Merge branch 'sony-laptop' into release

commit 771e5ce3bd96f315e213f6263e40b2b2ee7e5201
Merge: 7b80601 6740543
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 24 01:34:45 2009 -0400

    Merge branch 'thermal-regression' into release

commit 7b806016b14532b4206b81ba16062cf82c68e430
Merge: 60cd8ad b57f7e7
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 24 01:34:37 2009 -0400

    Merge branch 'thinkpad-acpi' into release

commit 60cd8adc6bfddd5139a4400ba5127863f0381dac
Merge: 0910697 90af2cf
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 24 01:34:29 2009 -0400

    Merge branch 'video-ac-dc' into release

commit b7f0ab460f772b09a9c664d746236a280fec714c
Author: Matthew Garrett <mjg59@srcf.ucam.org>
Date:   Wed Apr 15 21:46:36 2009 +0100

    ACPI, i915: Register ACPI video even when not modesetting
    
    The ACPI video driver defers registration to the i915 driver if the
    system supports opregion-mediated backlight control. This registration
    was only being performed in the KMS case. Ensure it's done even if we
    don't have modesetting enabled.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13048
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a38d75fa2e48d4960b656eac39bc8a6b584a83c0
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 24 00:32:52 2009 -0400

    Revert "ACPICA: delete check for AML access to port 0x81-83"
    
    This reverts commit fdbdc7fc79c02ae4ede869d514179a2c65633d28.
    
    That temporary quick-fix is no longer necessary,
    as the previous patch, a65131e942e25c707a652fa4ec2cfcd8b63fec11,
    "I/O port protection: update for windows compatibility"
    should handle this issue for all ports, including this one.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a65131e942e25c707a652fa4ec2cfcd8b63fec11
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 16 15:18:16 2009 +0800

    I/O port protection: update for windows compatibility.
    
    For windows compatibility,
    1) On a port protection violation, simply ignore the request and
       do not return an exception (allow the control method to continue execution.)
    2) If only part of the request overlaps a protected port,
       read/write the individual ports that are not protected.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13036
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 53005a0a1b53bda5810c45efe3025d1884aa6bb3
Author: Mattia Dongili <malattia@linux.it>
Date:   Sun Apr 12 11:26:31 2009 +0000

    sony-laptop: always try to unblock rfkill on load
    
    This fixes an inconsistent behaviour when loading the driver with the
    switch on or off. In the former case you would also need to soft unblock
    the switch via the sysfs file entries to really disable rfkill, in the
    latter you wouldn't.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Cc: Matthias Welwarsky <matze@welwarsky.de>
    Acked-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c35d4b3532ed3e2076fb14c25385cf6cef41cc69
Author: Mattia Dongili <malattia@linux.it>
Date:   Sun Apr 12 11:26:30 2009 +0000

    sony-laptop: fix bogus error message display on resume
    
    sony_backlight_update_status returns 0 on success -1 on failure (i.e.: the
    return value from acpi_callsetfunc. The return value in the resume path
    was broken and thus always displaying a bogus warning about not being able
    to restore the brightness level.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5aa63f038f042fd1acd6e720a95df72857db0bc7
Author: Almer S. Tigelaar <almer@gnome.org>
Date:   Sun Apr 12 11:26:29 2009 +0000

    ACPI: EC: Fix ACPI EC resume non-query interrupt message
    
    When resuming from standby (on a laptop) I see the following message in
    my kernel.log:
    "ACPI: EC: non-query interrupt received, switching to interrupt mode"
    This apparently prevented sony-laptop to properly restore the brightness
    level on resume.
    
    The cause: In drivers/acpi/ec.c the acpi_ec_suspend function clears the
    GPE mode bit, but this is not restored in acpi_ec_resume (the function
    below it). The patch below fixes this by properly restoring the GPE_MODE
    bit. Tested and confirmed to work.
    
    Signed-off-by: Almer S. Tigelaar <almer@gnome.org>
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a83021a229016f93b4e532d9cef21b01be5a8bb7
Author: Almer S. Tigelaar <almer@gnome.org>
Date:   Sun Apr 12 11:26:28 2009 +0000

    sony-laptop: SNC input event 38 fix
    
    Fixes the "unknown input event 38" messages. ANYBUTTON_RELEASED is now
    treated the same way as FN_KEY_RELEASED.
    
    Signed-off-by: Almer S. Tigelaar <almer@gnome.org>
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 560e84ac1b92d2a704fbfda29b46ad1b0a8d457e
Author: Almer S. Tigelaar <almer@gnome.org>
Date:   Sun Apr 12 11:26:27 2009 +0000

    sony-laptop: SNC 127 Initialization Fix
    
    Fixes additional special key initialization for SNC 127 key events.
    Verified / tested on a Sony VAIO SR model.
    
    Signed-off-by: Almer S. Tigelaar <almer@gnome.org>
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 226fced325e2865369cbeac41c6a97536d4daa1b
Author: Almer S. Tigelaar <almer@gnome.org>
Date:   Sun Apr 12 11:26:26 2009 +0000

    sony-laptop: Duplicate SNC 127 Event Fix
    
    Fixes a duplicate mapping in the SNC sony_127_events structure.
    
    Signed-off-by: Almer S. Tigelaar <almer@gnome.org>
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 615dfd93e2346b604232b559e7ea0835d24abe26
Author: Len Brown <len.brown@intel.com>
Date:   Thu Apr 23 23:21:29 2009 -0400

    ACPI: prevent processor.max_cstate=0 boot crash
    
    As processor.max_cstate is an init-time-only modparam,
    sanity checking it at init-time is sufficient.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13142
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f4b9c759cb9a6c0f1bc221a7fe617ba5e3555582
Author: Len Brown <len.brown@intel.com>
Date:   Thu Apr 23 19:14:21 2009 -0400

    HPET: stop soliciting hpet=force users on ICH4M
    
    The HPET in the ICH4M is not documented in the data sheet
    because it was not officially validated.
    
    While it is fine for hackers to continue to use "hpet=force"
    to enable the hardware that they have, it is not prudent to
    solicit additional "hpet=force" users on this hardware.
    
    Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f461ddea0af8b98e2b7940eba9c693b0ee44d64a
Author: Len Brown <len.brown@intel.com>
Date:   Thu Apr 23 18:59:43 2009 -0400

    ACPI/hpet: prevent boot hang when hpet=force used on ICH-4M
    
    Linux tells ICH4 users that they can (manually) invoke
    "hpet=force" to enable the undocumented ICH-4M HPET.
    The HPET becomes available for both clocksource and clockevents.
    
    But as of ff69f2bba67bd45514923aaedbf40fe351787c59
    (acpi: fix of pmtimer overflow that make Cx states time incorrect)
    the HPET may be used via clocksource for idle accounting, and
    hpet=force on an ICH4 box hangs boot.
    
    It turns out that touching the MMIO HPET withing
    the ARB_DIS part of C3 will hang the hardware.
    
    The fix is to simply move the timer access outside
    the ARB_DIS region.  This is a no-op on modern hardware
    because ARB_DIS is no longer used.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13087
    
    Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4b10fee2ec45eae912c2c81730f4eee82e61a247
Author: Matthew Garrett <mjg59@srcf.ucam.org>
Date:   Wed Apr 15 21:56:56 2009 +0100

    ACPI/i915: build fix
    
    CONFIG_DRM_I915=y
    CONFIG_ACPI_VIDEO=m
    
    drivers/built-in.o: In function `intel_opregion_init':
    (.text+0x9d540): undefined reference to `acpi_video_register'
    
    Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 92614610774072ea68131f16e024ee8fc15be9be
Author: Len Brown <len.brown@intel.com>
Date:   Wed Apr 22 19:28:15 2009 -0400

    ACPI: delete obsolete "bus master activity" proc field
    
    Linux-2.6.29 deleted the legacy ACPI idle handler, leaving
    the CPU_IDLE handler, which does not track bus master activity.
    
    So delete the unused bm_activity field -- it is confusing to
    print an always zero value.
    
    This patch could break programs that parse
    /proc/acpi/processor/*/power, since it deletes this
    line from that file:
    
    bus master activity:     00000000
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13145
    is not fixed by this patch, but provoked this patch.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a71e4917dc0ebbcb5a0ecb7ca3486643c1c9a6e2
Author: Len Brown <len.brown@intel.com>
Date:   Tue Apr 21 00:50:11 2009 -0400

    ACPI: idle: mark_tsc_unstable() at init-time, not run-time
    
    The c2 and c3 idle handlers check tsc_halts_in_c()
    after every time they return from idle.  Um, when?:-)
    
    Move this check to init-time to remove the unnecessary
    run-time overhead, and also to have the check complete before
    the first entry into the idle handler.
    
    ff69f2bba67bd45514923aaedbf40fe351787c59
    (acpi: fix of pmtimer overflow that make Cx states time incorrect)
    replaced the hard-coded use of the PM-timer inside idle,
    with ktime_get_readl(), which possibly uses the TSC --
    so it is now especially prudent to detect a broken TSC
    before entering idle.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13087
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 88bea188b85f9cefefbbd56b8a48d0f798409177
Author: Len Brown <len.brown@intel.com>
Date:   Tue Apr 21 00:35:47 2009 -0400

    ACPI: add /sys/firmware/acpi/interrupts/sci_not counter
    
    This counter may prove useful in debugging some
    spurious interrupt issues seen in the field.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 90af2cf6205bfc8def8c5a64c9134031d60b10fb
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Tue Apr 14 11:02:18 2009 +0800

    ACPI video: fix an error when the brightness levels on AC and on Battery are same
    
    when the brightness level on AC and brightness level on Battery
    are same, the level_ac_battery is 1 in the current code,
    which is wrong.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d876dfbbf5c8728102fb4f683450fa9ae3259cda
Author: Thomas Renninger <trenn@suse.de>
Date:   Fri Apr 17 16:22:08 2009 +0200

    acpi-cpufreq: Do not let get_measured perf depend on internal variable
    
    Take already available policy->cpuinfo.max_freq and get rid of acpi-cpufreq
    specific max_freq variable.
    
    This implies that P0 is always the highest frequency which should always
    be true as ACPI spec says:
    As a result, the zeroth entry describes the highest performance state
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d91758f5ddb80e91176fa2cf80c88c1633950b3d
Author: Thomas Renninger <trenn@suse.de>
Date:   Fri Apr 17 16:22:07 2009 +0200

    acpi-cpufreq: style-only: add parens to math expression
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e0e8c4e512e92bc25c19bd8d4926de17d2f8fbf2
Author: Thomas Renninger <trenn@suse.de>
Date:   Fri Apr 17 16:22:06 2009 +0200

    acpi-cpufreq: Cleanup: Use printk_once
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 093f13e23137b9e5f7629dd5932ceea1419e2b61
Author: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
Date:   Wed Apr 15 10:37:33 2009 -0700

    x86, acpi_cpufreq: Fix the NULL pointer dereference in get_measured_perf
    
    Fix for a regression that was introduced by earlier commit
    18b2646fe3babeb40b34a0c1751e0bf5adfdc64c on Mon Apr 6 11:26:08 2009
    
    Regression resulted in the below error happened on systems with
    software coordination where per_cpu acpi data will not be initiated for
    secondary CPUs in a P-state domain.
    
    On Tue, 2009-04-14 at 23:01 -0700, Zhang, Yanmin wrote:
     My machine hanged with kernel 2.6.30-rc2 when script read
    > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor.
    >
    > opps happens in get_measured_perf:
    >
    >         cur.aperf.whole = readin.aperf.whole -
    >                                 per_cpu(drv_data, cpu)->saved_aperf;
    >
    > Because per_cpu(drv_data, cpu)=NULL.
    >
    > So function get_measured_perf should check if (per_cpu(drv_data,
    > cpu)==NULL)
    > and return 0 if it's NULL.
    
    --------------sys log------------------
    
    BUG: unable to handle kernel NULL pointer dereference at
    0000000000000020
    IP: [<ffffffff8021af75>] get_measured_perf+0x4a/0xf9
    PGD a7dd88067 PUD a7ccf5067 PMD 0
    Oops: 0000 [#1] SMP
    last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
    CPU 0
    Modules linked in: video output
    Pid: 2091, comm: kondemand/0 Not tainted 2.6.30-rc2 #1 MP Server
    RIP: 0010:[<ffffffff8021af75>]  [<ffffffff8021af75>]
    get_measured_perf+0x4a/0xf9
    RSP: 0018:ffff880a7d56de20  EFLAGS: 00010246
    RAX: 0000000000000000 RBX: 00000046241a42b6 RCX: ffff88004d219000
    RDX: 000000000000b660 RSI: 0000000000000020 RDI: 0000000000000001
    RBP: ffff880a7f052000 R08: 00000046241a42b6 R09: ffffffff807639f0
    R10: 00000000ffffffea R11: ffffffff802207f4 R12: ffff880a7f052000
    R13: ffff88004d20e460 R14: 0000000000ddd5a6 R15: 0000000000000001
    FS:  0000000000000000(0000) GS:ffff88004d200000(0000)
    knlGS:0000000000000000
    CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
    CR2: 0000000000000020 CR3: 0000000a7f1bf000 CR4: 00000000000006e0
    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
    Process kondemand/0 (pid: 2091, threadinfo ffff880a7d56c000, task
    ffff880a7d4d18c0)
    Stack:
     ffff880a7f052078 ffffffff803efd54 00000046241a42b6 000000462ffa9e95
     0000000000000001 0000000000000001 00000000ffffffea ffffffff8064f41a
     0000000000000012 0000000000000012 ffff880a7f052000 ffffffff80650547
    Call Trace:
     [<ffffffff803efd54>] ? kobject_get+0x12/0x17
     [<ffffffff8064f41a>] ? __cpufreq_driver_getavg+0x42/0x57
     [<ffffffff80650547>] ? do_dbs_timer+0x147/0x272
     [<ffffffff80650400>] ? do_dbs_timer+0x0/0x272
     [<ffffffff802474ca>] ? worker_thread+0x15b/0x1f5
     [<ffffffff8024a02c>] ? autoremove_wake_function+0x0/0x2e
     [<ffffffff8024736f>] ? worker_thread+0x0/0x1f5
     [<ffffffff80249f0d>] ? kthread+0x54/0x83
     [<ffffffff8020c87a>] ? child_rip+0xa/0x20
     [<ffffffff80249eb9>] ? kthread+0x0/0x83
     [<ffffffff8020c870>] ? child_rip+0x0/0x20
    Code: 99 a6 03 00 31 c9 85 c0 0f 85 c3 00 00 00 89 df 4c 8b 44 24 10 48
    c7 c2 60 b6 00 00 48 8b 0c fd e0 30 a5 80 4c 89 c3 48 8b 04 0a <48> 2b
    58 20 48 8b 44 24 18 48 89 1c 24 48 8b 34 0a 48 2b 46 28
    RIP  [<ffffffff8021af75>] get_measured_perf+0x4a/0xf9
     RSP <ffff880a7d56de20>
    CR2: 0000000000000020
    ---[ end trace 2b8fac9a49e19ad4 ]---
    
    Tested-by: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b57f7e7b836d271902b8b7b1ec8cf9312dc5d228
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Apr 14 02:44:14 2009 +0000

    thinkpad-acpi: bump up version to 0.23
    
    Plenty of high-profile changes, so it deserves a new version number.
    
    Features added since 0.22:
     *  Restrict unsafe LEDs
     *  New race-less brightness control strategy for IBM ThinkPads
     *  Disclose TGID of driver access from userspace (debug)
     *  Warn when deprecated functions are used
    
    Other changes:
     *  Better debug messages in some subdrivers
     *  Removed "hotkey disable" support, since it breaks the driver
     *  Dropped "ibm-acpi" alias
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 922fe097b1e8f2f2f23dbed61cfe6e0316fecff1
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Apr 14 02:44:13 2009 +0000

    thinkpad-acpi: simplify module autoloading
    
    Simplify the module autoloading a great deal, by keying to the HID for
    the HKEY interface.
    
    Only _really_ ancient IBM ThinkPad models like the 240, 240x and 570
    lack the HKEY interface, and they're getting their own trimmed-down
    driver one of these days.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f68f53a217b827580647d23fdc34eecdcb3739c6
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Apr 14 02:44:12 2009 +0000

    thinkpad-acpi: fix use of MODULE_AUTHOR
    
    Fix the module to use one instance of MODULE_AUTHOR per author.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 75bd3bf2ade9d548be0d2bde60b5ee0fdce0b127
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Apr 14 02:44:11 2009 +0000

    thinkpad-acpi: fix LED blinking through timer trigger
    
    The set_blink hook code in the LED subdriver would never manage to get
    a LED to blink, and instead it would just turn it on.  The consequence
    of this is that the "timer" trigger would not cause the LED to blink
    if given default parameters.
    
    This problem exists since 2.6.26-rc1.
    
    To fix it, switch the deferred LED work handling to use the
    thinkpad-acpi-specific LED status (off/on/blink) directly.
    
    This also makes the code easier to read, and to extend later.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: stable@kernel.org
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 406e988bef742aa74cdc1f5fafc812ecebf7c02b
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Tue Apr 14 02:44:10 2009 +0000

    thinkpad-acpi: silence hotkey enable warning for module parameter
    
    Avoid the WARN() when the procfs handler for hotkey enable is used by
    a module parameter.  Instead, urge the user to stop doing that.
    
    Reported-by: Niel Lambrechts <niel.lambrechts@gmail.com>
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 67405439bca28c4dbecd3fefd97fbdb282a302d9
Author: Matthew Garrett <mjg59@srcf.ucam.org>
Date:   Tue Apr 14 20:16:45 2009 +0100

    thermal: Fix polling frequency for systems without passive cooling
    
    The polling interval (in deciseconds) was accidently interpreted as
    being in milliseconds in one codepath, resulting in excessively frequent
    polling. Ensure that the conversion is performed.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 96f15efcea94545987715f453a8c2b8ea592d000
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 17 23:32:20 2009 -0400

    ACPI: Disable _GTS and _BFS support by default
    
    Executing BIOS code paths not exercised by Windows
    tends to get Linux into trouble.
    
    However, if a system does benefit from _GTS or _BFS,
    acpi.gts=1 an acpi.bfs=1 are now available to enable them.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13041
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e047cca66c6bb0b1c346e91305011aab79dfc4b0
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Apr 9 14:24:35 2009 +0800

    ACPI video: handle indexed _BQC correctly
    
    In the current code, for a box with an indexed _BQC method, we
    1. get the current brightness level by evaluating _BQC
    2. set the value gotten in step 1 to _BCM
    3. get the current brightness level again
    4. set the _BQC_use_index flag if the results gotten
       in step 1 and in step 3 don't equal.
    
    But this logic doesn't work actually, because the _BQC_use_index
    is not set when ﻿acpi_video_device_lcd_set_level is invoked.
    This results in a failure in step 2.
    http://bugzilla.kernel.org/show_bug.cgi?id=12249#c83
    
    Now, we set the _BQC_use_index flag after invoking _BQC for the first
    time. And reevaluate the _BQC to get the correct brightness level.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 82babbb3887e234c995626e4121d411ea9070ca5
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Wed Apr 8 09:44:29 2009 +0800

    ACPI: Revert conflicting workaround for BIOS w/ mangled PRT entries
    
    2f894ef9c8b36a35d80709bedca276d2fc691941
    in Linux-2.6.21 worked around BIOS with mangled _PRT entries:
    http://bugzilla.kernel.org/show_bug.cgi?id=6859
    
    d0e184abc5983281ef189db2c759d65d56eb1b80
    worked around the same issue via ACPICA, and shipped in 2.6.27.
    
    Unfortunately the two workarounds conflict:
    http://bugzilla.kernel.org/show_bug.cgi?id=12270
    
    So revert the Linux specific one.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d68b597c883cf863c7216564cae08a4730d56cc1
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Wed Apr 8 15:40:04 2009 +0000

    ACPI: button: remove control method/fixed hardware distinctions
    
    This patch removes the driver distinction between control method (CM)
    and fixed hardware (FF) buttons.  We previously needed that so we
    could install either a fixed event handler or a notify handler, but
    the Linux/ACPI code now handles that for us, so we don't need to
    worry about it.
    
    Note that this removes the FF/CM annotation from the "info" files
    in /proc.  For example,
    
        /proc/acpi/button/PWRF/info:
        -type:		Power Button (FF)
        +type:		Power Button
    
    I don't think there's anything meaningful user-space can do by
    knowing whether a button is a control method or a fixed hardware
    button, so nobody should be looking at the FF/CM.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 106c19e7b978e1b84ea5cabbd470a0ddced577c8
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Wed Apr 8 15:39:59 2009 +0000

    ACPI: button: remove button->device pointer
    
    We no longer need a pointer from struct acpi_button back to the
    struct acpi_device.  Everywhere we used that pointer, we either
    already have, or can easily get, the acpi_device pointer without
    using the copy from acpi_button.  So this patch removes the
    structure element.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bf04a77227db76f163bc2355ef4e176794987be2
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Wed Apr 8 15:39:54 2009 +0000

    ACPI: button: cache hid/name/class pointers
    
    This patch adds temporaries to cache the acpi_device_hid(),
    acpi_device_name(), and acpi_device_class() pointers so we
    don't have to clutter the code with so many uses of those
    interfaces.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1bce81131c71064bc3163078f24545b839a31967
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Wed Apr 8 15:39:49 2009 +0000

    ACPI: button: use Linux style for getting driver_data
    
    It's typical and slightly more compact to look up the driver_data
    structure by initializing the automatic variable at its definition.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e2fb9754d27513918a4936e8cbaad50ff56cfd3d
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Wed Apr 8 15:39:43 2009 +0000

    ACPI: button: remove unnecessary null pointer checks
    
    Better to oops and learn about a bug than to silently cover it up.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 50a4da890102a455e5cd3dd358c38650d07178d3
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Wed Apr 8 15:39:38 2009 +0000

    ACPI: button: whitespace changes
    
    This patch changes a bit of whitespace to follow Linux conventions.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

--Boundary_(ID_M1KwnosXaQXO9t28NoBoCA)--
