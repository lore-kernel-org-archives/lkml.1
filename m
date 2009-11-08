Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbZKHC7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbZKHC7M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 21:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbZKHC7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 21:59:11 -0500
Received: from vms173015pub.verizon.net ([206.46.173.15]:61502 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbZKHC7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 21:59:09 -0500
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_oN5WhgOFfAsb6j4TSJ7ZXQ)"
Date: Sat, 07 Nov 2009 21:59:13 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [git pull request] ACPI & driver patches for 2.6.32-rc6
Message-id: <alpine.LFD.2.00.0911072157250.4291@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_oN5WhgOFfAsb6j4TSJ7ZXQ)
Content-type: TEXT/PLAIN; charset=UTF-8
Content-transfer-encoding: 8BIT

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

The documentation update is clarification/cleanup relating to the existing API.
One kernel-oops fix from the kernel summit session.
A couple of fixes for things that happened within 2.6.32-rc.

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.32/acpi-release-20090903-2.6.32-rc6.diff.gz

 Documentation/thermal/sysfs-api.txt |  389 ++++++++++++++++++-----------------
 drivers/acpi/acpica/acconfig.h      |    4 +-
 drivers/acpi/acpica/exregion.c      |   35 +++-
 drivers/acpi/power_meter.c          |    6 +-
 drivers/acpi/proc.c                 |    2 +-
 drivers/acpi/processor_core.c       |    2 +-
 drivers/acpi/processor_throttling.c |    6 +-
 drivers/acpi/sleep.c                |   24 +++
 drivers/acpi/video.c                |    8 +-
 drivers/platform/x86/eeepc-laptop.c |   30 +--
 drivers/thermal/thermal_sys.c       |   10 +-
 11 files changed, 281 insertions(+), 235 deletions(-)

through these commits:

Amit Kucheria (1):
      acpi: thermal: Add EOL to the trip_point_N_type strings

Arjan van de Ven (1):
      ACPI: clean up video.c boundary checks and types

Bob Moore (1):
      ACPICA: avoid "Info: mapping multiple BARs. Your kernel is fine."

Corentin Chary (1):
      Revert "eeepc-laptop: Prevent a panic when disabling RT2860 wireless when associated"

Darrick J. Wong (1):
      acpi-power-meter: Don't leak ACPI error codes to userspace

Frans Pop (2):
      thermal: sysfs-api.txt - reformat for improved readability
      thermal: sysfs-api.txt - document passive attribute for thermal zones

Gustavo Maciel Dias Vieira (1):
      ACPI: add DMI entry for SCI_EN resume quirk on HP dv4

Julia Lawall (1):
      ACPI: Move dereference after NULL test

Luca Niccoli (1):
      eeepc-laptop: don't enable camera at startup if it's already on.

Rakib Mullick (1):
      ACPI: add __cpuinit to acpi_processor_add()

Vaibhav Verma (1):
      ACPI: sleep: another HP/Compaq DMI entries for init_set_sci_en_on_resume

with this log:

commit 43758dd88fdf1e5b3897c7a04dfae0afb8313dea
Merge: 12308a2 2839d39
Author: Len Brown <len.brown@intel.com>
Date:   Fri Nov 6 01:45:11 2009 -0500

    Merge branch 'bugzilla-13449' into release

commit 2839d396e3ae0891c1fdd87aa1cea218e6f5c4df
Author: Vaibhav Verma <vaibhav.verma86@gmail.com>
Date:   Thu Nov 5 23:13:36 2009 -0500

    ACPI: sleep: another HP/Compaq DMI entries for init_set_sci_en_on_resume
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13745
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8a1cbf64977f89e9e9bc1d80dd01503337424f96
Author: Gustavo Maciel Dias Vieira <gustavo@sagui.org>
Date:   Mon Oct 19 09:41:53 2009 -0200

    ACPI: add DMI entry for SCI_EN resume quirk on HP dv4
    
    Fixes the missing battery on sleep problem for yet another HP laptop
    ("HP Pavilion dv4").
    
    Fixes:
    	http://bugzilla.kernel.org/show_bug.cgi?id=13449
    
    Signed-off-by: Gustavo Maciel Dias Vieira <gustavo@sagui.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 12308a2f2703d135681b3e9cf582009747f588f7
Merge: 91d3f9b 29226ed 80f0c89 d410ee5
Author: Len Brown <len.brown@intel.com>
Date:   Thu Nov 5 18:31:18 2009 -0500

    Merge branches 'misc', 'eeepc-laptop' and 'bugzilla-14445' into release

commit 29226ed3c3b5cd0b2b0b1fb40ffeac3f796b80e9
Author: Frans Pop <elendil@planet.nl>
Date:   Mon Oct 26 08:39:00 2009 +0100

    thermal: sysfs-api.txt - document passive attribute for thermal zones
    
    Signed-off-by: Frans Pop <elendil@planet.nl>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 38bb0849a6799e05bb474a88f198522ae4ecace2
Author: Frans Pop <elendil@planet.nl>
Date:   Mon Oct 26 08:38:59 2009 +0100

    thermal: sysfs-api.txt - reformat for improved readability
    
    The document currently uses large indentations which make the text
    too wide for easy readability. Also improve general consistency.
    
    Signed-off-by: Frans Pop <elendil@planet.nl>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 625120a42bd4371da98808a4ca3e7589083a06d8
Author: Amit Kucheria <amit.kucheria@canonical.com>
Date:   Fri Oct 16 12:46:02 2009 +0300

    acpi: thermal: Add EOL to the trip_point_N_type strings
    
    Make the trip_point_N_type sysfs files return a string ending in EOL for
    consistency with other sysfs files.
    
    Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5cfa245b0b63c3d79568e78a1ee3d00654d5517d
Author: Julia Lawall <julia@diku.dk>
Date:   Sat Oct 17 08:34:39 2009 +0200

    ACPI: Move dereference after NULL test
    
    If the NULL test on pr is needed, then the dereference should be after the
    NULL test.
    
    A simplified version of the semantic match that detects this problem is as
    follows (http://coccinelle.lip6.fr/):
    
    // <smpl>
    @match exists@
    expression x, E;
    identifier fld;
    @@
    
    * x->fld
      ... when != \(x = E\|&x\)
    * x == NULL
    // </smpl>
    
    Signed-off-by: Julia Lawall <julia@diku.dk>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d410ee5109a1633a686a5663c6743a92e1181f9b
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Oct 22 09:11:11 2009 +0800

    ACPICA: avoid "Info: mapping multiple BARs. Your kernel is fine."
    
    Ensure that memory mappings created for operation regions
    do not cross page boundaries.  Crossing a page boundary
    while mapping regions can cause warnings if the pages have different attributes.
    
    Such regions are probably BIOS bugs, and this is the workaround.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=14445
    
    [Kernel summit hacking hour]
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 941b10fab2cbd90ac7ad6bc2338ffe30e1d3ce53
Author: Rakib Mullick <rakib.mullick@gmail.com>
Date:   Thu Nov 5 16:51:40 2009 -0500

    ACPI: add __cpuinit to acpi_processor_add()
    
    Annote acpi_processor_add with cpuinit since it calls a cpuinit function
    acpi_processor_power_init and fixes a section mismatch warning.
    
     We were warned by the following warning:
    
     LD      drivers/acpi/processor.o
    WARNING: drivers/acpi/processor.o(.text+0x1829): Section mismatch in
    reference from the function acpi_processor_add() to the function
    .cpuinit.text:acpi_processor_power_init()
    The function acpi_processor_add() references
    the function __cpuinit acpi_processor_power_init().
    This is often because acpi_processor_add lacks a __cpuinit
    annotation or the annotation of acpi_processor_power_init is wrong.
    
    Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 22aecebfd9498c4779e5c5bed1d2d054bd99f7a4
Author: Darrick J. Wong <djwong@us.ibm.com>
Date:   Wed Oct 21 18:01:37 2009 -0700

    acpi-power-meter: Don't leak ACPI error codes to userspace
    
    If the ACPI methods return an error code, we must return -EINVAL to userspace
    to flag the error.  Right now we pass the (positive) number right through,
    which causes echo to keep writing bogus values.
    
    Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
    Acked-by: Jean Delvare <khali@linux-fr.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 80f0c895b57f0d936b420de6afea5167a49f62fa
Author: Luca Niccoli <lultimouomo@gmail.com>
Date:   Fri Oct 16 22:22:47 2009 +0200

    eeepc-laptop: don't enable camera at startup if it's already on.
    
    Switching the camera takes 500ms, checking if it's on is almost free...
    The BIOS remembers the setting through reboots, so there's good chance the
    camera is already enabled.
    
    Signed-off-by: Luca Niccoli <lultimouomo@gmail.com>
    Cc: Corentin Chary <corentincj@iksaif.net>
    Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Cc: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 58ce48a9de1dd47acb5dc00e2837214d2be1d92a
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Fri Oct 16 22:22:46 2009 +0200

    Revert "eeepc-laptop: Prevent a panic when disabling RT2860 wireless when associated"
    
    rt2860sta is fine with the patch as is, but iwl3945 isn't
    (eeepc_rfkill_set() needs to call eeepc_rfkill_hotplug(true) – which means
    that we're back to causing the rt2860sta panic
    
    This reverts commit b56ab33d68638e6aafdbfc694025e8354a628f49.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Darren Salt <linux@youmustbejoking.demon.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 52a2b11cafb1b14bacfc65a20966da5ba3a863e1
Author: Arjan van de Ven <arjan@linux.intel.com>
Date:   Thu Oct 1 15:48:40 2009 -0700

    ACPI: clean up video.c boundary checks and types
    
    proc.c and video.c are a bit sloppy around types and style,
    confusing gcc for a new feature that'll be in 2.6.33 and will
    cause a warning on the current code.
    
    This patch changes
    
    if  (foo + 1 > sizeof bar)
    
    into
    
    if (foo >= sizeof(bar))
    
    which is more kernel-style.
    
    it also changes a variable in proc.c to unsigned; it gets assigned
    a value from an unsigned type, and is then only compared for > not
    for negative, so using unsigned is just outright the right type
    
    Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

--Boundary_(ID_oN5WhgOFfAsb6j4TSJ7ZXQ)--
