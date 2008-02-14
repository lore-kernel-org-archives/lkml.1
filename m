Return-Path: <linux-kernel-owner+w=401wt.eu-S932486AbYBNIN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486AbYBNIN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 03:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755058AbYBNINO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 03:13:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:47554 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718AbYBNINM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 03:13:12 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PATCH] ACPI patches for 2.6.25-rc1
Date: Thu, 14 Feb 2008 03:12:52 -0500
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802140312.52984.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This batch...
fixes two suspend regressions
tidies up the recently updated cpuidle code, including adding documentation.
and some other fluff.

This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.25/acpi-release-20070126-2.6.25-rc1.diff.gz

 Documentation/00-INDEX             |    2 +
 Documentation/cpuidle/core.txt     |   23 ++++++++++
 Documentation/cpuidle/driver.txt   |   31 ++++++++++++++
 Documentation/cpuidle/governor.txt |   29 +++++++++++++
 Documentation/cpuidle/sysfs.txt    |   79 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/acpi/cstate.c      |    2 +
 drivers/acpi/blacklist.c           |   64 +++++++++++++++++++++++++----
 drivers/acpi/event.c               |    2 +-
 drivers/acpi/hardware/hwsleep.c    |    1 +
 drivers/acpi/osl.c                 |    6 +-
 drivers/acpi/processor_idle.c      |   19 +++++++++
 drivers/cpuidle/cpuidle.c          |    3 +-
 drivers/cpuidle/sysfs.c            |   14 +++++-
 drivers/misc/thinkpad_acpi.c       |    4 +-
 drivers/pnp/pnpacpi/core.c         |    2 +-
 include/acpi/processor.h           |    9 +++-
 include/linux/acpi.h               |    1 +
 include/linux/cpuidle.h            |    2 +
 18 files changed, 271 insertions(+), 22 deletions(-)
 create mode 100644 Documentation/cpuidle/core.txt
 create mode 100644 Documentation/cpuidle/driver.txt
 create mode 100644 Documentation/cpuidle/governor.txt
 create mode 100644 Documentation/cpuidle/sysfs.txt

through these commits:

Adrian Bunk (4):
      thinkpad_acpi: static
      ACPI: static acpi_no_initrd_override_setup()
      ACPI: static acpi_find_dsdt_initrd()
      ACPI: static acpi_chain_head

Len Brown (2):
      ACPI: DMI blacklist updates
      ACPI: DMI: quirk for FSC ESPRIMO Mobile V5505

Rafael J. Wysocki (1):
      ACPI suspend: Execute _WAK with the right argument

Roel Kluin (1):
      pnpacpi: __initdata is not an identifier

Venkatesh Pallipadi (3):
      ACPI: fix suspend regression due to idle update
      ACPI, cpuidle: Clarify C-state description in sysfs
      cpuidle: Add Documentation

with this log:

commit f60d63f642d824914677fb40330671117dc39c3b
Merge: 46c1fbd... fe8e288... 6bf69b5...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Feb 14 02:44:28 2008 -0500

    Merge branches 'release', 'dmi', 'idle' and 'misc' into release

commit 46c1fbdb7191bf07979d7cd5f08d1a86458181a2
Author: Len Brown <len.brown@intel.com>
Date:   Wed Feb 13 23:13:25 2008 -0500

    ACPI: DMI: quirk for FSC ESPRIMO Mobile V5505
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9939
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bb54675b9b2f968f07e29b6c23b8dc90bad59723
Author: Len Brown <len.brown@intel.com>
Date:   Sun Feb 10 21:29:56 2008 -0500

    ACPI: DMI blacklist updates
    
    Acer Extensa 5220 -- OSI(Linux) is a NOP
    Dell OptiPlex 755 -- OSI(Linux) turns GUSB into a NOP
    Dell PowerEdge 1950 -- OSI(Linux) is a NOP
    Dell Precision 690 -- OSI(Linux) touches USB (skips GUSB)
    FSC ESPRIMO Mobile V5505 -- OSI(Linux) is a NOP
    Lenovo LENOVO3000 V100 -- OSI(Linux) is a NOP
    Lenovo X61x -- OSI(Linux) enables Linux specific AML
    Sony Vaio VGN-NR11S_S - OSI(Linux) is a NOP
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6bf69b5ebf22f8f5b4551bad688979fe29049126
Author: Roel Kluin <12o3l@tiscali.nl>
Date:   Mon Feb 11 16:05:35 2008 +0100

    pnpacpi: __initdata is not an identifier
    
    sparse complains at drivers/pnp/pnpacpi/core.c:39 with the error:
    Trying to use reserved word '__attribute__' as identifier
    Expected ) in function declarator, got ".init.data"
    
    and at drivers/pnp/pnpacpi/core.c:49:38 with the error:
    undefined identifier 'excluded_id_list'
    
    With the patch below these sparse complaints do not occur
    
    Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c8e773fa4f6a999a80d9fa3836f412e259ab6fa1
Author: Adrian Bunk <bunk@kernel.org>
Date:   Wed Feb 13 23:29:57 2008 +0200

    ACPI: static acpi_chain_head
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit adba2a876c1c971980f9bb3c6c8e20c61490647b
Author: Adrian Bunk <bunk@kernel.org>
Date:   Wed Feb 13 23:29:58 2008 +0200

    ACPI: static acpi_find_dsdt_initrd()
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bfaed45e30f19bb4cee779f3229d2744bc2b2c46
Author: Adrian Bunk <bunk@kernel.org>
Date:   Wed Feb 13 23:30:00 2008 +0200

    ACPI: static acpi_no_initrd_override_setup()
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Acked-by: Eric Piel <eric.piel@tremplin-utc.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1d5a2b54f39cab8ab8bee5290798ea6516c4a68c
Author: Adrian Bunk <bunk@kernel.org>
Date:   Wed Feb 13 23:30:06 2008 +0200

    thinkpad_acpi: static
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 314ccd644cc14b9ebc1996afbabfb4d108004fd0
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Wed Feb 13 00:32:16 2008 +0100

    ACPI suspend: Execute _WAK with the right argument
    
    The _WAK global ACPI control method has to be called with the
    argument representing the sleep state being exited.  Make it happen.
    
    Special thanks to Mirco Tischler <mt-ml@gmx.de> for reporting the
    problem and debugging.
    
    Reported-by: Mirco Tischler <mt-ml@gmx.de>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fe8e288a63f2f3c51c288500282d0eb5cd26a534
Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Thu Feb 14 00:16:13 2008 -0500

    cpuidle: Add Documentation
    
    Documentation for cpuidle infrastructure. (resend)
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Reviewed-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4fcb2fcd4d0678b8ae103d257dcb28074cbfc7fa
Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Mon Feb 11 17:46:31 2008 -0800

    ACPI, cpuidle: Clarify C-state description in sysfs
    
    Add a new sysfs entry under cpuidle states. desc - can be used by driver to
    communicate to userspace any specific information about the state.
    This helps in identifying the exact hardware C-states behind the ACPI C-state
    definition.
    
    Idea is to export this through powertop, which will help to map the C-state
    reported by powertop to actual hardware C-state.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b077fbada161479d9a32a7730d2822d5e737b306
Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Mon Feb 11 15:20:27 2008 -0800

    ACPI: fix suspend regression due to idle update
    
    Earlier patch (bc71bec91f9875ef825d12104acf3bf4ca215fa4) broke
    suspend resume on many laptops. The problem was reported by
    Carlos R. Mafra and Calvin Walton, who bisected the issue to above patch.
    
    The problem was because, C2 and C3 code were calling acpi_idle_enter_c1
    directly, with C2 or C3 as state parameter, while suspend/resume was in
    progress. The patch bc71bec started making use of that state information,
    assuming that it would always be referring to C1 state. This caused the
    problem with suspend-resume as we ended up using C2/C3 state indirectly.
    
    Fix this by adding acpi_idle_suspend check in enter_c1.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
