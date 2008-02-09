Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbYBIJ5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbYBIJ5s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 04:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbYBIJ5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 04:57:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:38601 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbYBIJ5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 04:57:36 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PATCH] ACPI patches for 2.6.25-rc0 (#3)
Date: Sat, 9 Feb 2008 04:53:00 -0500
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802090453.01266.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This fixes a boot regression, two build failures, and updates some documentation.

This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.24/acpi-release-20070126-2.6.24.diff.gz

 Documentation/00-INDEX                        |    8 +-
 Documentation/laptops/00-INDEX                |   10 ++
 Documentation/laptops/acer-wmi.txt            |  202 +++++++++++++++++++++++++
 Documentation/{ => laptops}/sony-laptop.txt   |    1 -
 Documentation/{ => laptops}/sonypi.txt        |    0 
 Documentation/{ => laptops}/thinkpad-acpi.txt |    0 
 arch/x86/Kconfig                              |    3 +
 drivers/acpi/Makefile                         |    2 +-
 drivers/acpi/sbs.c                            |    2 +-
 drivers/acpi/sbshc.c                          |    6 +
 drivers/char/Kconfig                          |    2 +-
 drivers/cpuidle/cpuidle.c                     |   13 ++-
 drivers/misc/Kconfig                          |   13 +-
 drivers/misc/acer-wmi.c                       |    6 +-
 include/linux/thermal.h                       |   23 +++-
 15 files changed, 269 insertions(+), 22 deletions(-)
 create mode 100644 Documentation/laptops/00-INDEX
 create mode 100644 Documentation/laptops/acer-wmi.txt
 rename Documentation/{ => laptops}/sony-laptop.txt (99%)
 rename Documentation/{ => laptops}/sonypi.txt (100%)
 rename Documentation/{ => laptops}/thinkpad-acpi.txt (100%)

through these commits:

Alexey Starikovskiy (1):
      ACPI: SBS: Host controller must initialize before SBS.

Carlos Corbacho (7):
      tc1100-wmi: Mark as experimental
      acer-wmi: Fix backlight on AMW0 (V1) laptops
      Documentation - Create laptops sub-directory
      thinkpad-acpi - Move thinkpad-acpi.txt to Documentation/laptops
      sony-laptop - Move sony-laptop.txt to Documentation/laptops
      sonypi - Move sonypi.txt to Documentation/laptops
      acer-wmi - Add documentation

Len Brown (1):
      ACPI: thermal: buildfix for CONFIG_THERMAL=n

Venki Pallipadi (1):
      cpuidle: build fix for non-x86

with this log:

commit a52500c917ead55dd78d9f37b8ca993f4f79f72a
Merge: d47b180... 4609d02... 16111c7...
Author: Len Brown <len.brown@intel.com>
Date:   Sat Feb 9 04:32:55 2008 -0500

    Merge branches 'release', 'wmi' and 'laptop-docs' into release

commit d47b180c26c22d78c2428117abb7e6beba00b7ef
Merge: 249d621... bbafbec...
Author: Len Brown <len.brown@intel.com>
Date:   Sat Feb 9 04:32:47 2008 -0500

    Merge branches 'release' and 'bugzilla-9910' into release

commit 249d621a85668b3b09296fbcfcf1cb5e9372a5ea
Author: Len Brown <len.brown@intel.com>
Date:   Sat Feb 9 04:32:40 2008 -0500

    Merge branches 'release' and 'buildfix' into release

commit 16111c797990f4fab571f6e982390cb842d16bf0
Author: Carlos Corbacho <carlos@strangeworlds.co.uk>
Date:   Sat Feb 9 01:32:25 2008 +0000

    acer-wmi - Add documentation
    
    Add some initial documentation detailing what acer-wmi is, and how to use
    it. Update the Kconfig entry with a reference to the documentation.
    
    Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 018a651a9c4e3fba623b735593fb39869a69c2f7
Author: Carlos Corbacho <carlos@strangeworlds.co.uk>
Date:   Sat Feb 9 01:32:19 2008 +0000

    sonypi - Move sonypi.txt to Documentation/laptops
    
    Also update references to sonypi.txt in Kconfig.
    
    Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    CC: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f04b7c402ba587a299e62907a457013914dec477
Author: Carlos Corbacho <carlos@strangeworlds.co.uk>
Date:   Sat Feb 9 01:32:14 2008 +0000

    sony-laptop - Move sony-laptop.txt to Documentation/laptops
    
    Also update references to sony-laptop.txt in Kconfig.
    
    Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    CC: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f191dc6b55cf92eb8e1f48b41533ecf4d6161569
Author: Carlos Corbacho <carlos@strangeworlds.co.uk>
Date:   Sat Feb 9 01:32:09 2008 +0000

    thinkpad-acpi - Move thinkpad-acpi.txt to Documentation/laptops
    
    Also update references to thinkpad-acpi.txt in Kconfig.
    
    Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d6ff3655773a1810b15da942c40478bf5217e390
Author: Carlos Corbacho <carlos@strangeworlds.co.uk>
Date:   Sat Feb 9 01:32:03 2008 +0000

    Documentation - Create laptops sub-directory
    
    There are currently various laptop drivers floating about with no central
    place for their documentation, which is currently scattered around the top
    level Documentation/ directory.
    
    So, as a first step, lets create a Documentation sub-directory, and update
    the relevant index files. The work of then moving the existing laptop
    driver related documentation will then be handled later.
    
    Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    CC: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a0dd25b2c83de4623487ca4de9c1d962b552ca0f
Author: Len Brown <len.brown@intel.com>
Date:   Sat Feb 9 04:01:48 2008 -0500

    ACPI: thermal: buildfix for CONFIG_THERMAL=n
    
    This fixes the build, but acpi_fan_add() still needs
    to be updated to handle thermal_cooling_device_register()
    returning NULL as a non-fatal condition.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a6869cc4cfd633d909918f1489a6a8ac668cd6aa
Author: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Fri Feb 8 17:05:44 2008 -0800

    cpuidle: build fix for non-x86
    
    The last posted version of this patch gave compile error
    on IA64. So, here goes yet another rewrite of the patch.
    
    Convert cpu_idle_wait() to cpuidle_kick_cpus() which is
    SMP-only, and gives error on non supported CPU.
    
    Changes from last patch sent by Kevin:
    Moved the definition of kick_cpus back to cpuidle.c from cpuidle.h:
    * Having it in .h gives #error on archs which includes the header file without
      actually having CPU_IDLE configured. To make it work in .h, we need one more
      #ifdef around that code which makes it messy.
    * Also, the function is only called from one file. So, it can be in declared
      statically in .c rather than making it available to everyone who includes
      the .h file.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Kevin Hilman <khilman@mvista.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4609d029aa8a2c7e0ad71e329c6e3493e1e95040
Author: Carlos Corbacho <carlos@strangeworlds.co.uk>
Date:   Fri Feb 8 23:51:49 2008 +0000

    acer-wmi: Fix backlight on AMW0 (V1) laptops
    
    There is some leftover cruft from the old quirk infrastructure that causes
    us to be unable to set the backlight on older laptops.
    
    Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b01368291926b30abc702dee35c688408b54d422
Author: Carlos Corbacho <carlos@strangeworlds.co.uk>
Date:   Fri Feb 8 23:51:43 2008 +0000

    tc1100-wmi: Mark as experimental
    
    tc1100-wmi has not undergone as much testing as acer-wmi, so it certainly
    should be marked as experimental as well until we get more user feedback.
    
    Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bbafbecb24190959d77a8fee7bd23798b81e25c2
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Sat Feb 9 03:22:13 2008 -0500

    ACPI: SBS: Host controller must initialize before SBS.
    
    In static case sbshc must be compiled ahead of sbs, so that
    hc is configured first.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9910
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>
