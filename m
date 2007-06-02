Return-Path: <linux-kernel-owner+w=401wt.eu-S1757729AbXFBFUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729AbXFBFUu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 01:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbXFBFUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 01:20:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:36994 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624AbXFBFUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 01:20:41 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCH] ACPI patches for 2.6.22 - part 3
Date: Sat, 2 Jun 2007 01:20:23 -0400
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706020120.23255.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This batch fixes two places where Linux currently fails to load tables
of the format that we expect OEM's to soon ship -- OEMx and
packages-as-method-arguments for _DSM.  In both cases the changed
code has no effect on systems without those needs.

The acpi_osi= boot parameter is expanded and invoked automatically
via DMI for some systems that need it.  We stop short here of changing
the default to acpi_osi=Linux -- that waits for 2.6.23.
The Thinkpad commit is for a 2.6.22 regression,
as is the section mis-match build fix.

This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.22/acpi-release-20070126-2.6.22-rc3.diff.gz

 Documentation/kernel-parameters.txt |    5 -
 Documentation/thinkpad-acpi.txt     |   25 ++---
 drivers/acpi/numa.c                 |    2 
 drivers/acpi/osl.c                  |  118 +++++++++++++++++++++--
 drivers/acpi/tables/tbinstal.c      |    8 -
 drivers/acpi/thermal.c              |   13 +-
 drivers/acpi/utilities/utcopy.c     |  120 ++++++++++--------------
 drivers/acpi/utilities/uteval.c     |   28 +++++
 drivers/acpi/utilities/utobject.c   |   42 ++++++++
 drivers/acpi/utilities/utxface.c    |    4 
 drivers/misc/thinkpad_acpi.c        |   17 +--
 drivers/misc/thinkpad_acpi.h        |    6 -
 include/acpi/acpi_numa.h            |    2 
 include/acpi/acpiosxf.h             |    3 
 include/acpi/acpixf.h               |    2 
 include/acpi/acutils.h              |    2 
 16 files changed, 267 insertions(+), 130 deletions(-)

through these commits:

Bob Moore (1):
      ACPICA: Support for external package objects as method arguments

Henrique de Moraes Holschuh (1):
      ACPI: thinkpad-acpi: do not use named sysfs groups

Len Brown (4):
      ACPICA: allow Load(OEMx) tables
      ACPI: extend "acpi_osi=" boot option
      ACPI: Make _OSI(Linux) a special case
      ACPI: add __init to acpi_initialize_subsystem()

Thomas Renninger (1):
      ACPI: thermal: Replace pointer with name in trip_points

Tony Luck (1):
      ACPI: Section mismatch ... acpi_map_pxm_to_node

with this log:

commit c4d36a822e7c51cd6ffcf9133854d5e32489d269
Merge: fcf7535... dd272b5...
Author: Len Brown <len.brown@intel.com>
Date:   Sat Jun 2 01:02:09 2007 -0400

    Pull osi-now into release branch

commit fcf75356e9cf0460ef47a5b756bc3b0951ecab59
Merge: f285e3d... 6287ee3...
Author: Len Brown <len.brown@intel.com>
Date:   Sat Jun 2 00:48:48 2007 -0400

    Pull now into release branch

commit 6287ee32952b502c23d54f12895c3895ddbe5013
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Apr 3 19:59:37 2007 -0400

    ACPICA: Support for external package objects as method arguments
    
    Implemented support to allow Package objects to be passed as
    method arguments to the acpi_evaluate_object interface. Previously,
    this would return an AE_NOT_IMPLEMENTED exception.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8ff6f48d99a0351bcc9ceab422042ef9d3bad9aa
Author: Luck, Tony <tony.luck@intel.com>
Date:   Thu May 24 13:57:40 2007 -0700

    ACPI: Section mismatch ... acpi_map_pxm_to_node
    
    Last of the "Section mismatch" errors from ia64 builds! acpi_map_pxm_to_node()
    is defined with attribute __cpuinit, but is called by "normal" kernel functions
    acpi_getnode() and acpi_map_cpu2node().
    
    Commit f363d16fbb9374c0bd7f2757d412c287169094c9 moved the data structures on
    which this routine operates from __cpuinitdata to regular memory, so this
    routine can also move out of init space.
    
    Signed-off-by: Tony Luck <tony.luck@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cc4c24e115ca7bc2e4ec74d70bcb8fda1d1a8df8
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Wed May 30 20:50:14 2007 -0300

    ACPI: thinkpad-acpi: do not use named sysfs groups
    
    The initial version of the thinkpad-acpi sysfs interface (not yet released
    in any stable mainline kernel) made liberal use of named sysfs groups, in
    order to get the attributes more organized.
    
    This proved to be a really bad design decision.  Maybe if attribute groups
    were as flexible as a real directory, and if binary attributes were not
    second-class citizens, the idea of subdirs and named groups would not have
    been so bad.
    
    This patch makes all the thinkpad-acpi sysfs groups anonymous (thus
    removing the subdirs), adds the former group names as a prefix (so that
    hotkey/enable becomes hotkey_enable for example), and updates the
    documentation.
    
    These changes will make the thinkpad-acpi sysfs ABI a lot easier to
    maintain.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit dd272b5716a54afa33a69f2241284d8ec60b7892
Author: Len Brown <len.brown@intel.com>
Date:   Wed May 30 00:26:11 2007 -0400

    ACPI: add __init to acpi_initialize_subsystem()
    
    Add __init to:
    acpi_initialize_subsystem() (and un-export it)
    acpi_os_initialize()
    
    Add __initdata to:
    acpi_osl_dmi_table[]
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f507654d450d329c81a70eec0096d5dfe67802ec
Author: Len Brown <len.brown@intel.com>
Date:   Wed May 30 00:10:38 2007 -0400

    ACPI: Make _OSI(Linux) a special case
    
    _OSI("Linux") is like _OS("Linux"), it is ill-defined and
    virtually no BIOS vendors test interaction with it.
    As a result, it can do more damage than good because
    it causes the BIOS to follow un-tested paths.
    
    Recently, several machines have turned up that erroneously
    test this string in a way which causes them to _not_ test other
    compatibility strings, including the ZI9 and Toshiba.
    So it appears that this bad code has made it into
    a BIOS vendor's reference BIOS.
    
    Linux has no choice but to stop advertising compatibility
    with _OSI string "Linux" - as there are an unbounded
    number of possible incompatibilities going forward.
    
    But some BIOSes have already shipped which do use it
    for things like conditionally re-enabling video on resume
    from S3.  (Too bad they didn't do that unconditionally)
    
    Add special case code for _OSI(Linux)
    Squawk to dmesg if _OSI(Linux) is requested
    Add DMI list both to enable and disable _OSI(Linux)
    But for now, keep the default enabled via
    #define OSI_LINUX_ENABLED.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=7787
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ae00d812436dc968f4a5dea7757b6a94910b6dc4
Author: Len Brown <len.brown@intel.com>
Date:   Tue May 29 18:43:33 2007 -0400

    ACPI: extend "acpi_osi=" boot option
    
    The boot option "acpi_osi=" has always disabled Linux _OSI support,
    thus disabling all OS Interface strings which are advertised
    by Linux to the BIOS.
    
    Now...
    acpi_osi="string" adds the interface string, and
    acpi_osi="!string" invalidates the pre-defined interface string
    
    eg. acpi_osi="!Windows 2006"
    would disable Linux's claim of Vista compatibility.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 68ccfaa8222f2a26f0689fad9e8c0c3f4c19f599
Author: Thomas Renninger <trenn@suse.de>
Date:   Sun Nov 19 23:01:40 2006 +0100

    ACPI: thermal: Replace pointer with name in trip_points
    
    For users with active thermal trip points, they need
    the fan's name, rather than its address, to understand
    where to look to observe and control fan state.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0efabac9b7c8535eeb199d2f16d3eb44dc4761b2
Author: Len Brown <len.brown@intel.com>
Date:   Thu May 24 02:25:00 2007 -0400

    ACPICA: allow Load(OEMx) tables
    
    HP and Hitachi machines have been implemented with SSDT's
    that use the "OEMx" signatures.  But upon Load, ACPICA is rejecting
    these tables because they are not using the "SSDT" signature.
    
    ACPI Error (tbinstal-0134): Table has invalid signature [OEMx], must be SSDT...
    
    Signed-off-by: Len Brown <len.brown@intel.com>
