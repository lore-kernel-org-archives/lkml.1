Return-Path: <linux-kernel-owner+w=401wt.eu-S1760041AbXFWPNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760041AbXFWPNN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 11:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757570AbXFWPM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 11:12:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:38871 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756184AbXFWPM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 11:12:58 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCH] ACPI patches for 2.6.22 - part 4
Date: Sat, 23 Jun 2007 11:12:46 -0400
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706231112.46496.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This fixes three regressions, two small ones from within 2.6.22,
and a boot hang due to a race condition originating in 2.6.20.

It will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.22/acpi-release-20070126-2.6.22-rc5.diff.gz

 drivers/acpi/processor_idle.c     |   10 ++++++----
 drivers/acpi/thermal.c            |   15 +++++++++++----
 drivers/acpi/utilities/utobject.c |    2 +-
 3 files changed, 18 insertions(+), 9 deletions(-)

through these commits:

Myron Stowe (1):
      ACPICA: fix error path in new external package objects as method arguments

Thomas Renninger (1):
      ACPI: gracefully print null trip-point device

Venkatesh Pallipadi (1):
      ACPI: fix 2.6.20 SMP boot regression

with this log:

commit 629cf6d74beca87d57cea3e38edf7522c397d41e
Merge: 75154f4... d5a3d32...
Author: Len Brown <len.brown@intel.com>
Date:   Sat Jun 23 10:58:24 2007 -0400

    Pull now into release branch

commit d5a3d32a042126f65a008e0e5204ef92ad2ee55d
Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Fri Jun 15 19:36:00 2007 -0400

    ACPI: fix 2.6.20 SMP boot regression
    
    Always disable/enable interrupts in the acpi idle routine,
    even in the error path.
    
    This is required as the 2.6.20 change in git commit d331e739f5ad2aaa9...
    "Fix interrupt race in idle callback" expects the idle handler
    to enable interrupt before returning.
    
    There was a case in acpi idle routine, in which interrupt was not being
    enabled before return, which caused the system to hang at bootup, while
    enabling C-states on an SMP system.
    
    The signature of the hang was that "processor.nocst"
    was required to enable boot.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 83dd4504456d4b5e464d6ec4a7665e2c922db67f
Author: Myron Stowe <myron.stowe@hp.com>
Date:   Mon Jun 4 16:25:37 2007 -0600

    ACPICA: fix error path in new external package objects as method arguments
    
    In the routine acpi_ut_create_package_object(), if the
    ACPI_ALLOCATE_ZEROED() fails then ACPI_FREE(package_desc) is called as
    part of the cleanup.  This should instead be
    acpi_ut_remove_reference(package_desc) in order to remove the reference
    acquired from acpi_ut_create_internal_object() [see the routine
    acpi_ut_create_buffer_object() as an example of proper functionality].
    
    Signed-off-by: Myron Stowe <myron.stowe@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e7c746ef098770f863ba294adac5b30d124ba469
Author: Thomas Renninger <trenn@suse.de>
Date:   Mon Jun 18 00:40:51 2007 -0400

    ACPI: gracefully print null trip-point device
    
    if acpi_bus_get_device() returns NULL, print nothing
    instead of "<NUL" in /proc/acpi/thermal_zone/*/trip_points
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>
