Return-Path: <linux-kernel-owner+w=401wt.eu-S1753610AbYF1FbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbYF1FbT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 01:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbYF1Fa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 01:30:59 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:44182 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbYF1Fat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 01:30:49 -0400
Date: Sat, 28 Jun 2008 01:30:12 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: [GIT PATCH] ACPI patches for 2.6.26-rc8
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Message-id: <alpine.LFD.1.10.0806280126160.14731@localhost.localdomain>
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

Note that I will be taking a sabbatical from Intel this summer.
Andi Kleen will maintain Linux/ACPI while I'm away.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.26/acpi-release-20080609-2.6.26-rc8.diff.gz

 Documentation/feature-removal-schedule.txt |    9 +++++++++
 drivers/acpi/bay.c                         |    3 +++
 drivers/acpi/dock.c                        |    3 +++
 drivers/acpi/glue.c                        |    3 +++
 drivers/thermal/Kconfig                    |    9 +++++++++
 drivers/thermal/thermal_sys.c              |    4 ++--
 include/linux/thermal.h                    |    6 ++----
 7 files changed, 31 insertions(+), 6 deletions(-)

through these commits:

Len Brown (1):
      dock: bay: Don't call acpi_walk_namespace() when ACPI is disabled.

Rene Herman (1):
      thermal: Create CONFIG_THERMAL_HWMON=n

Vegard Nossum (1):
      ACPI: don't walk tables if ACPI was disabled

with this log:

commit c4e6a2e64e948de42473e9c829181d768b1258c3
Merge: 816c2ed... 16d7523...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Jun 26 01:56:35 2008 -0400

    Merge branches 'release', 'acpi_disabled' and 'bugzilla-10958' into release

commit 816c2eda3ce8fa7eb62f22e01e2ec7a3f7d677c0
Author: Len Brown <len.brown@intel.com>
Date:   Tue Jun 24 22:57:12 2008 -0400

    dock: bay: Don't call acpi_walk_namespace() when ACPI is disabled.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4389ed2ff61de2b1485b31bf342da913dd342f59
Author: Vegard Nossum <vegard.nossum@gmail.com>
Date:   Fri Jun 20 15:39:09 2008 +0200

    ACPI: don't walk tables if ACPI was disabled
    
    Ingo Molnar wrote:
    > -tip auto-testing started triggering this spinlock corruption message
    > yesterday:
    >
    > [    3.976213] calling  acpi_rtc_init+0x0/0xd3
    > [    3.980213] ACPI Exception (utmutex-0263): AE_BAD_PARAMETER, Thread F7C50000 could not acquire Mutex [3] [20080321]
    > [    3.992213] BUG: spinlock bad magic on CPU#0, swapper/1
    > [    3.992213]  lock: c2508dc4, .magic: 00000000, .owner: swapper/1, .owner_cpu: 0
    
    This is apparently because some parts of ACPI, including mutexes, are not
    initialized when acpi=off is passed to the kernel.
    
    Reported-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 16d752397301b95abaa95cbaf9e785d221872311
Author: Rene Herman <rene.herman@keyaccess.nl>
Date:   Tue Jun 24 19:38:56 2008 +0200

    thermal: Create CONFIG_THERMAL_HWMON=n
    
    A bug in libsensors <= 2.10.6 is exposed
    when this new hwmon I/F is enabled.
    Create CONFIG_THERMAL_HWMON=n
    until some time after libsensors 2.10.7 ships
    so those users can run the latest kernel.
    
    libsensors 3.x is already fixed -- those users
    can use CONFIG_THERMAL_HWMON=y now.
    
    Signed-off-by: Rene Herman <rene.herman@gmail.com>
    Acked-by: Mark M. Hoffman <mhoffman@lightlink.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
