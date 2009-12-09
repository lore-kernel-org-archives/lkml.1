Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbZLIReq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbZLIReq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 12:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbZLIReo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 12:34:44 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:63259 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961AbZLIRek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 12:34:40 -0500
Date: Wed, 09 Dec 2009 12:34:27 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: [git pull request] ACPICA patches for Linux-2.6.33-merge
Message-id: <alpine.LFD.2.00.0912091216500.22890@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git acpica

This updates Linux to ACPICA v20091112 from v20090903.
Later during the v2.6.33 cycle, I may also cherry pick
a few debug tweaks I'm expecting in a subsequent ACPICA release.

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.32/acpi-acpica-20091112-2.6.32-rc8.diff.gz

 arch/ia64/sn/kernel/io_acpi_init.c     |    2 +-
 arch/x86/kernel/cpu/cpufreq/longhaul.c |    2 +-
 drivers/acpi/acpi_memhotplug.c         |    4 +-
 drivers/acpi/acpica/Makefile           |    2 +-
 drivers/acpi/acpica/acmacros.h         |    3 +
 drivers/acpi/acpica/acnamesp.h         |   16 +-
 drivers/acpi/acpica/acutils.h          |    7 +
 drivers/acpi/acpica/dsinit.c           |    2 +-
 drivers/acpi/acpica/dsmthdat.c         |    4 +-
 drivers/acpi/acpica/dsobject.c         |    8 +-
 drivers/acpi/acpica/dswload.c          |   50 ++-
 drivers/acpi/acpica/evgpeblk.c         |    8 +-
 drivers/acpi/acpica/evregion.c         |   81 ++++-
 drivers/acpi/acpica/exconfig.c         |    4 +-
 drivers/acpi/acpica/exconvrt.c         |    3 +-
 drivers/acpi/acpica/exfield.c          |    3 +-
 drivers/acpi/acpica/exoparg1.c         |   38 +--
 drivers/acpi/acpica/exoparg6.c         |    7 +-
 drivers/acpi/acpica/nsdump.c           |    4 +-
 drivers/acpi/acpica/nsdumpdv.c         |    3 +-
 drivers/acpi/acpica/nseval.c           |   50 ++-
 drivers/acpi/acpica/nsinit.c           |    8 +-
 drivers/acpi/acpica/nspredef.c         |   49 +++-
 drivers/acpi/acpica/nsrepair.c         |  114 +++++--
 drivers/acpi/acpica/nsrepair2.c        |  540 ++++++++++++++++++++++++++++++++
 drivers/acpi/acpica/nswalk.c           |  200 +++++++-----
 drivers/acpi/acpica/nsxfeval.c         |   32 ++-
 drivers/acpi/acpica/psloop.c           |   32 ++-
 drivers/acpi/acpica/psparse.c          |    8 +-
 drivers/acpi/acpica/psxface.c          |    4 +-
 drivers/acpi/acpica/utmisc.c           |   42 +++
 drivers/acpi/acpica/utobject.c         |   29 ++
 drivers/acpi/container.c               |    4 +-
 drivers/acpi/dock.c                    |    8 +-
 drivers/acpi/ec.c                      |    2 +-
 drivers/acpi/glue.c                    |    2 +-
 drivers/acpi/pci_slot.c                |    8 +-
 drivers/acpi/processor_core.c          |    4 +-
 drivers/acpi/scan.c                    |    2 +-
 drivers/acpi/video_detect.c            |    6 +-
 drivers/gpu/drm/i915/intel_lvds.c      |    2 +-
 drivers/i2c/busses/i2c-scmi.c          |    2 +-
 drivers/pci/hotplug/acpi_pcihp.c       |    2 +-
 drivers/pci/hotplug/acpiphp_glue.c     |   22 +-
 drivers/pci/hotplug/acpiphp_ibm.c      |    2 +-
 drivers/platform/x86/intel_menlow.c    |    2 +-
 drivers/platform/x86/sony-laptop.c     |    2 +-
 drivers/platform/x86/thinkpad_acpi.c   |    2 +-
 include/acpi/acpixf.h                  |    5 +-
 49 files changed, 1153 insertions(+), 283 deletions(-)
 create mode 100644 drivers/acpi/acpica/nsrepair2.c

through these commits:

Bob Moore (9):
      ACPICA: Add repair for bad _BIF/_BIX packages
      ACPICA: Update version to 20091013
      ACPICA: Reduce severity of predefined repair messages, Warning to Info
      ACPICA: Change package length error message to an info message
      ACPICA: Fix possible fault if return Package objects contain NULL elements
      ACPICA: Add repair for predefined methods that must return sorted lists
      ACPICA: New internal utility function to create Integer objects
      ACPICA: Deploy new create integer interface where appropriate
      ACPICA: Update version to 20091112.

Lin Ming (5):
      ACPICA: Add repair for bad _MAT buffers
      ACPICA: Remove possibility of executing _REG methods twice
      ACPICA: Fix possible memory leak for Scope ASL operator
      ACPICA: Add post-order callback to acpi_walk_namespace
      ACPICA: Add additional module-level code support

with this log:

commit b00eb796f1b67c46036b5490e83b31741f1eebaf
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Nov 13 10:01:43 2009 +0800

    ACPICA: Update version to 20091112.
    
    Version 20091112.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9a884ab64a4d092b4c3bf24fd9a30f7fbd4591e7
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Nov 12 09:57:53 2009 +0800

    ACPICA: Add additional module-level code support
    
    This change will execute module-level code that is not at the
    root of the namespace (under a Device object, etc.).
    ACPICA BZ 762.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=762
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit dc95a270c684e771b25dce0b60559cc80c033f22
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Nov 12 09:52:45 2009 +0800

    ACPICA: Deploy new create integer interface where appropriate
    
    Simplifies creation of simple integer objects.
    ACPICA BZ 823.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=823
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 502f7efa6ae7c3f6d93dac417af521af1f56bcc7
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Nov 12 09:49:50 2009 +0800

    ACPICA: New internal utility function to create Integer objects
    
    acpi_ut_create_integer_object. This function (when deployed) should
    simplify some of the object creation code.  ACPICA BZ 823.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=823
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ad5babeed8d3082406c5b67ae558b95a479ddb6f
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Nov 12 09:44:06 2009 +0800

    ACPICA: Add repair for predefined methods that must return sorted lists
    
    This change will repair (by sorting) packages returned by _ALR,
    _PSS, and _TSS. Drivers can now assume that the packages are
    correctly sorted. Adds one new file, nsrepair2.c.
    ACPICA BZ 784.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=784
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 419a909dd10142d015dd96457db1b1eda643f89e
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Nov 12 09:36:00 2009 +0800

    ACPICA: Fix possible fault if return Package objects contain NULL elements
    
    For predefined name validation. Also adds a warning if a NULL
    element is followed by any non-null elements.  ACPICA BZ 813, 814.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=813
    http://www.acpica.org/bugzilla/show_bug.cgi?id=814
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2263576cfc6e8f6ab038126c3254404b9fcb1c33
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Fri Nov 13 10:06:08 2009 +0800

    ACPICA: Add post-order callback to acpi_walk_namespace
    
    The existing interface only has a pre-order callback. This change
    adds an additional parameter for a post-order callback which will
    be more useful for bus scans. ACPICA BZ 779.
    
    Also update the external calls to acpi_walk_namespace.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=779
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7d5d05d0704127c9acd24090c14731c111bd0af1
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Nov 12 09:31:50 2009 +0800

    ACPICA: Change package length error message to an info message
    
    This message happens when the package element list is longer than
    the declared length of the package. Changed to an info message
    because this condition is not actually an error. It is caused by
    the BIOS attempting to truncate the package on the fly by adjusting
    the package element count at the start of the package definition.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7df200cd980442868f5579c0880a9221da628d17
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Nov 12 09:18:45 2009 +0800

    ACPICA: Reduce severity of predefined repair messages, Warning to Info
    
    Since the object was successfully repaired, a Warning is too
    severe.  Reduced to Info for now. We may eventually change these
    messages to debug-only. ACPICA BZ 812.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=812
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cc3316e7a97cdbfc34633e20195f8c98b9ff9ff5
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Oct 14 09:01:39 2009 +0800

    ACPICA: Update version to 20091013
    
    Version 20091013.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 50b77eda9b12ff0ccf12b4021b7193d71778c0a9
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Tue Oct 13 10:34:56 2009 +0800

    ACPICA: Fix possible memory leak for Scope ASL operator
    
    Using Scope(\) to change the scope to the root could cause a
    single object memory leak.
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 74d3ec77a5e0633b0c7a8490941432c2e4789037
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Tue Oct 13 10:29:30 2009 +0800

    ACPICA: Remove possibility of executing _REG methods twice
    
    If a custom address space handler is installed by the host
    before the "initialize operation regions" phase of the ACPICA
    initialization, any _REG methods for that address space could
    be executed twice. This change fixes the problem.
    ACPICA BZ 427.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=427
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0240d7b4f20f7d156a74dfdd0647a0231b7e8ef4
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Tue Oct 13 10:23:20 2009 +0800

    ACPICA: Add repair for bad _MAT buffers
    
    _MAT can inadvertently return an Integer instead of a Buffer
    if the return value has been read from a Field whose width is
    less than or equal to the global integer width (32 or 64 bits).
    ACPICA BZ 810.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=810
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2752699392b828edf3123f911f6e8b4dd7daeb56
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Oct 13 10:20:33 2009 +0800

    ACPICA: Add repair for bad _BIF/_BIX packages
    
    Add a repair for the "Oem Information" field which is often
    mistakenly returned as an integer. It should always be a string.
    ACPICA BZ 807.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=807
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
