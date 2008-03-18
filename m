Return-Path: <linux-kernel-owner+w=401wt.eu-S1752915AbYCRJMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbYCRJMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 05:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbYCRJMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 05:12:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:60645 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbYCRJMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 05:12:08 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: [GIT PATCH] ACPI patches for 2.6.25-rc6
Date: Tue, 18 Mar 2008 05:10:47 -0400
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803180510.47670.lenb@kernel.org>
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
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.25/acpi-release-20070126-2.6.25-rc6.diff.gz

 drivers/acpi/asus_acpi.c      |    2 +-
 drivers/acpi/battery.c        |   11 +--
 drivers/acpi/processor_idle.c |   12 ++-
 drivers/acpi/video.c          |   60 +--------------
 drivers/ata/Kconfig           |    1 +
 drivers/thermal/Kconfig       |    2 -
 drivers/thermal/thermal.c     |  169 ++++++----------------------------------
 7 files changed, 43 insertions(+), 214 deletions(-)

through these commits:

Alexey Starikovskiy (1):
      ACPI: battery: Don't return -EFAIL on broken packages.

Julia Lawall (1):
      asus_acpi: remove misleading mask

Len Brown (5):
      ACPI: fix ATA_ACPI build
      Revert "thermal: fix generic thermal I/F for hwmon"
      thermal: delete "default y"
      Revert "ACPI: video: Ignore ACPI video devices that aren't present in hardware"
      Revert "ACPI: video: Ignore devices that aren't present in hardware"

Venki Pallipadi (1):
      ACPI: lockdep warning on boot, 2.6.25-rc5

Zhang, Rui (1):
      thermal: re-document thermal units

with this log:

commit d9ea1364d37b53710519909ab125a53b0a8ca64f
Merge: abc5a87... b8a1bdb... 77321e6... 0ac4a3c... 71e93d1... ece54e2...
Author: Len Brown <len.brown@intel.com>
Date:   Tue Mar 18 04:52:57 2008 -0400

    Merge branches 'release', 'asus', 'bugzilla-8573', 'bugzilla-9995', 'bugzilla-10272', 'lockdep' and 'thermal' into release

commit 77321e624b64f1e5985a20f3cd16b94c96d0dbb4
Author: Len Brown <len.brown@intel.com>
Date:   Tue Mar 18 04:04:35 2008 -0400

    Revert "ACPI: video: Ignore devices that aren't present in hardware"
    
    This reverts commit 0119509c4fbc9adcef1472817fda295334612976.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9995
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit abc5a87f4e627e058813a95b112e9f5f21668f9d
Author: Julia Lawall <julia@diku.dk>
Date:   Tue Mar 4 15:00:13 2008 -0800

    asus_acpi: remove misleading mask
    
    led_out is boolean, so there is no functional change here,
    but apparently an extra mask with 1 caused some style checkers
    to flag this as logic bug.
    
    Signed-off-by: Julia Lawall <julia@diku.dk>
    Acked-by: Luca Tettamanti <kronos.it@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f0d6752c9fa51d24c86b57c76ec5b2926a716b23
Author: Len Brown <len.brown@intel.com>
Date:   Tue Mar 18 01:43:53 2008 -0400

    Revert "ACPI: video: Ignore ACPI video devices that aren't present in hardware"
    
    This reverts commit 3fa2cdcc45a0176de15cac9dbf4ed2834ebf8932.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9995
    
    Signed-off-by: Len Brown <len.brown>

commit ece54e2ff45062852e4647e85b2bb5f6aee8211c
Author: Len Brown <len.brown@intel.com>
Date:   Tue Mar 18 01:22:10 2008 -0400

    thermal: delete "default y"
    
    The generic thermal I/F gets selected by ACPI_THERMAL --
    its only current customer.
    it doesn't need to clutter other configs by default.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6d7f014e55c5227220da1f021c518487fcfd585a
Author: Zhang, Rui <rui.zhang@intel.com>
Date:   Tue Mar 18 10:40:29 2008 +0800

    thermal: re-document thermal units
    From: Zhang Rui <rui.zhang@intel.com>
    
    (reverting the previous sysfs patch also reverted a fix
     to the thermal units documentation, which is restored by this commit)
    
    The generic thermal driver shows temperature in millidegree Celsius.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 91f57fa1215952af579f304821a15cc6c656042c
Author: Len Brown <len.brown@intel.com>
Date:   Tue Mar 18 01:14:37 2008 -0400

    Revert "thermal: fix generic thermal I/F for hwmon"
    
    This reverts commit 3152fb9f11cdd2fd8688c2c5cb805e5c09b53dd9.
    
    This broke libsensors.
    
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Acked-by: Jean Delvare <khali@linux-fr.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0ac4a3c2fbbcadc3e96e4dc47d4ae802d66e6f67
Author: Len Brown <len.brown@intel.com>
Date:   Tue Mar 18 00:26:07 2008 -0400

    ACPI: fix ATA_ACPI build
    
    drivers/ata/libata-acpi.c fails to build
    
    drivers/built-in.o: In function `ata_acpi_associate':
    (.text+0x7106a): undefined reference to `register_hotplug_dock_device'
    
    When CONFIG_ATA_ACPI=y and CONFIG_ACPI_DOCK=m
    But if dock is selected from ata_acpi, dock will =y
    when ata_acpi=y, avoiding this problem.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=10272
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b8a1bdb14940946fcf0438a6337b2a6c54294fb8
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Mon Mar 17 22:37:42 2008 -0400

    ACPI: battery: Don't return -EFAIL on broken packages.
    
    Acer BIOS has a bug which is exposed when a dead battery is present.
    
    The package template that is used to describe battery status is
    over-written with sane values when the battery is live.
    But when the batter is dead, a bogus reference in the template
    is used.  In this case, Linux returns a fault, when instead
    it should simply return that it doesn't know the missing value.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=8573
    http://bugzilla.kernel.org/show_bug.cgi?id=10202
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 71e93d15612c61c2e26a169567becf088e71b8ff
Author: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Thu Mar 13 17:18:19 2008 -0700

    ACPI: lockdep warning on boot, 2.6.25-rc5
    
    This avoids the harmless WARNING by lockdep in acpi_processor_idle().
    
    The reason for WARNING is because at the depth of idle handling code,
    some of the idle handlers disable interrupts, some times, while returning from
    the idle handler. After return, acpi_processor_idle and few other routines
    in the file did an unconditional local_irq_enable(). With LOCKDEP, enabling
    irq when it is already enabled generates the below WARNING.
    
    > > [    0.593038] ------------[ cut here ]------------
    > > [    0.593267] WARNING: at kernel/lockdep.c:2035 trace_hardirqs_on+0xa0/0x115()
    > > [    0.593596] Modules linked in:
    > > [    0.593756] Pid: 0, comm: swapper Not tainted 2.6.25-rc5 #8
    > > [    0.594017]
    > > [    0.594017] Call Trace:
    > > [    0.594216]  [<ffffffff80231663>] warn_on_slowpath+0x58/0x6b
    > > [    0.594495]  [<ffffffff80495966>] ? _spin_unlock_irqrestore+0x38/0x47
    > > [    0.594809]  [<ffffffff80329a86>] ? acpi_os_release_lock+0x9/0xb
    > > [    0.595103]  [<ffffffff80337840>] ? acpi_set_register+0x161/0x173
    > > [    0.595401]  [<ffffffff8034c8d4>] ? acpi_processor_idle+0x1de/0x546
    > > [    0.595706]  [<ffffffff8020a23b>] ? default_idle+0x0/0x73
    > > [    0.595970]  [<ffffffff8024fc0e>] trace_hardirqs_on+0xa0/0x115
    > > [    0.596049]  [<ffffffff8034c6f6>] ? acpi_processor_idle+0x0/0x546
    > > [    0.596346]  [<ffffffff8034c8d4>] acpi_processor_idle+0x1de/0x546
    > > [    0.596642]  [<ffffffff8020a23b>] ? default_idle+0x0/0x73
    > > [    0.596912]  [<ffffffff8034c6f6>] ? acpi_processor_idle+0x0/0x546
    > > [    0.597209]  [<ffffffff8020a23b>] ? default_idle+0x0/0x73
    > > [    0.597472]  [<ffffffff8020a355>] cpu_idle+0xa7/0xd1
    > > [    0.597717]  [<ffffffff80485fa1>] rest_init+0x55/0x57
    > > [    0.597957]  [<ffffffff8062fb49>] start_kernel+0x29d/0x2a8
    > > [    0.598215]  [<ffffffff8062f1da>] _sinittext+0x1da/0x1e1
    > > [    0.598464]
    > > [    0.598546] ---[ end trace 778e504de7e3b1e3 ]---
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
