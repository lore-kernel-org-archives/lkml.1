Return-Path: <linux-kernel-owner+w=401wt.eu-S1753097AbYJYJLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbYJYJLb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 05:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbYJYJLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 05:11:20 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:52713 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbYJYJLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 05:11:19 -0400
Date: Sat, 25 Oct 2008 05:11:08 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: [GIT PATCH] ACPI patches for Linux-2.6.28-rc1
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Message-id: <alpine.LFD.2.00.0810250421430.10850@localhost.localdomain>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_UDSe4giRWGVuzR4LT6vcvw)"
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_UDSe4giRWGVuzR4LT6vcvw)
Content-type: TEXT/PLAIN; charset=UTF-8
Content-transfer-encoding: 8BIT

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

some small build and bug fixes, including an oops regression fix
on a broken BIOS, plus some driver specific updates.

This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.28/acpi-release-20080926-2.6.28-rc1.diff.gz

 drivers/acpi/button.c            |    3 +-
 drivers/acpi/processor_perflib.c |    5 ++
 drivers/acpi/sleep/main.c        |    2 +
 drivers/acpi/toshiba_acpi.c      |    2 +
 drivers/dma/ioat_dma.c           |    7 ++-
 drivers/idle/Kconfig             |   11 ++--
 drivers/idle/i7300_idle.c        |  105 +++++++------------------------------
 drivers/leds/leds-hp-disk.c      |    2 +-
 drivers/pci/pci-acpi.c           |    3 +
 include/linux/i7300_idle.h       |   83 ++++++++++++++++++++++++++++++
 10 files changed, 129 insertions(+), 94 deletions(-)
 create mode 100644 include/linux/i7300_idle.h

through these commits:

Guillem Jover (1):
      ACPI: Always report a sync event after a lid state change

Len Brown (2):
      toshiba_acpi: always call input_sync() after input_report_switch()
      leds-hp-disk: fix build warning

Miao Xie (1):
      ACPI: cpufreq, processor: fix compile error in drivers/acpi/processor_perflib.c

Rafael J. Wysocki (2):
      ACPI suspend: build fix for ACPI_SLEEP=n && XEN_SAVE_RESTORE=y.
      ACPI: Oops in ACPI with git latest

Venki Pallipadi (3):
      i7300_idle: Disable ioat channel only on platforms where ile driver can load
      i7300_idle: Cleanup based review comments
      i7300_idle: Fix compile warning CONFIG_I7300_IDLE_IOAT_CHANNEL not defined

with this log:

commit 9fb3c5ca3dabe06758c35f790c68e273ed749e19
Merge: 438f8de... f371be6...
Author: Len Brown <len.brown@intel.com>
Date:   Sat Oct 25 04:07:44 2008 -0400

    Merge branch 'i7300_idle' into release

commit 438f8de46bc261b35d84771ae9992cfff3ff4dd8
Author: Len Brown <len.brown@intel.com>
Date:   Sat Oct 25 03:52:16 2008 -0400

    leds-hp-disk: fix build warning
    
    drivers/leds/leds-hp-disk.c:59: warning: passing argument 4 of ‘acpi_evaluate_integer’ from incompatible pointer type
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f8123381bae8d581d81f24b55719db3d9a6a262c
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Oct 24 21:50:31 2008 +0200

    ACPI: Oops in ACPI with git latest
    
    ACPI Warning (nseval-0168): Insufficient arguments - method [_OSC] needs 5, found 4 [20080926]
    ACPI Warning (nspredef-0252): \_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, expected 4 [20080926]
    ACPI Error (nspredef-0163): \_SB_.PCI0._OSC: Missing expected return value [20080926]
    BUG: unable to handle kernel NULL pointer dereference at 00000000
    IP: [<c0237671>] acpi_run_osc+0xa1/0x170
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Tested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 92daa7b53b76984565dfdfda5d9c679884121fb2
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Oct 23 21:46:43 2008 +0200

    ACPI suspend: build fix for ACPI_SLEEP=n && XEN_SAVE_RESTORE=y.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cab08969188e2da09923fe9c4a99ec9b934b0708
Author: Len Brown <len.brown@intel.com>
Date:   Fri Oct 24 15:39:47 2008 -0400

    toshiba_acpi: always call input_sync() after input_report_switch()
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit df316e939100e789b3c5d4d102619ccf5834bd00
Author: Guillem Jover <guillem.jover@nokia.com>
Date:   Fri Oct 24 00:28:33 2008 +0300

    ACPI: Always report a sync event after a lid state change
    
    Currently not always an EV_SYN event is reported to userland
    after the EV_SW SW_LID event has been sent. This is easy to verify
    by using “input-events” from input-utils and just closing and opening
    the lid.
    
    Signed-off-by: Guillem Jover <guillem.jover@nokia.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 16be87ea170ae6cfaa9f47f79d14f7577d8cb420
Author: Miao Xie <miaox@cn.fujitsu.com>
Date:   Fri Oct 24 17:22:04 2008 +0800

    ACPI: cpufreq, processor: fix compile error in drivers/acpi/processor_perflib.c
    
    When trying to build 2.6.28-rc1 on ia64, make aborts with:
    
      CC      drivers/acpi/processor_perflib.o
      drivers/acpi/processor_perflib.c:41:28: error: asm/cpufeature.h: No such file or directory
      drivers/acpi/processor_perflib.c: In function ‘acpi_processor_get_performance_info’:
      drivers/acpi/processor_perflib.c:364: error: implicit declaration of function ‘boot_cpu_has’
      drivers/acpi/processor_perflib.c:364: error: ‘X86_FEATURE_EST’ undeclared (first use in this function)
      drivers/acpi/processor_perflib.c:364: error: (Each undeclared identifier is reported only once
      drivers/acpi/processor_perflib.c:364: error: for each function it appears in.)
      make[2]: *** [drivers/acpi/processor_perflib.o] Error 1
      make[1]: *** [drivers/acpi] Error 2
      make: *** [drivers] Error 2
    
    this patch fix it.
    
    Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
    Acked-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f371be6352cdde3df2253b76acb979480e93ce4f
Author: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Thu Oct 23 15:39:06 2008 -0700

    i7300_idle: Fix compile warning CONFIG_I7300_IDLE_IOAT_CHANNEL not defined
    
    When I7300_idle driver is not configured, there is a compile time
    warning about IDLE_IOAT_CHANNEL not defined. Fix it.
    
    Reported-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Reported-by: Arjan van de Ven <arjan@linux.intel.com>
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 33093e186c8f80b443fafb1d347a140bdd2b86c6
Author: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Wed Oct 22 16:51:03 2008 -0700

    i7300_idle: Cleanup based review comments
    
    Cleanup of i7300 idle driver based on review comments from Randy Dunlap,
    Andi Kleen and Len Brown.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3ad0b02e4c1d5feba44b8ff48dccd1ba61a826b0
Author: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Wed Oct 22 16:34:52 2008 -0700

    i7300_idle: Disable ioat channel only on platforms where ile driver can load
    
    Based on input from Andi Kleen:
    share the platform detection code with ioat_dma and disable the channel in
    dma engine only for specific platforms.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

--Boundary_(ID_UDSe4giRWGVuzR4LT6vcvw)--
