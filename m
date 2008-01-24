Return-Path: <linux-kernel-owner+w=401wt.eu-S1755062AbYAXE6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbYAXE6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 23:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbYAXE6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 23:58:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:39751 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332AbYAXE6U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 23:58:20 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PATCH] ACPI patches for 2.6.24-rc8
Date: Wed, 23 Jan 2008 23:58:00 -0500
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801232358.01008.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This fixes a couple of 2.6.24 regressions, and also installs the latest DMI blacklist.
While the DMI blacklist is a lot of text, it is almost entirely about avoiding
dmesg spam to make the release more supportable.  Indeed, I plan to submit
the DMI update to 2.6.23.stable.

This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.24/acpi-release-20070126-2.6.24-rc8.diff.gz

 drivers/acpi/blacklist.c            |  381 ++++++++++++++++++++++++
 drivers/acpi/bus.c                  |    2 
 drivers/acpi/ec.c                   |   26 +
 drivers/acpi/fan.c                  |   40 ++
 drivers/acpi/osl.c                  |  173 ++++++++--
 drivers/acpi/processor_throttling.c |    4 
 drivers/firmware/dmi-id.c           |    2 
 drivers/firmware/dmi_scan.c         |    8 
 include/acpi/acpi_bus.h             |    3 
 include/linux/acpi.h                |    7 
 include/linux/dmi.h                 |    4 
 11 files changed, 591 insertions(+), 59 deletions(-)

through these commits:

Alexey Starikovskiy (2):
      ACPI: processor: Fix null pointer dereference in throttling
      ACPI: EC: fix dmesg spam regression

Len Brown (9):
      DMI: move dmi_available declaration to linux/dmi.h
      DMI: create dmi_get_slot()
      ACPI: create acpi_dmi_dump()
      ACPI: on OSI(Linux), print needed DMI rather than requesting dmidecode output
      ACPI: Delete Intel Customer Reference Board (CRB) from OSI(Linux) DMI list
      ACPI: make _OSI(Linux) console messages smarter
      ACPI: Add ThinkPad R61, ThinkPad T61 to OSI(Linux) white-list
      ACPI: DMI blacklist to reduce console warnings on OSI(Linux) systems.
      Revert "ACPI: Fan: Drop force_power_state acpi_device option"

Márton Németh (2):
      ACPI: EC: add leading zeros to debug messages
      ACPI: EC: "DEBUG" needs to be defined earlier

with this log:

commit 63eac9badbe35054c0ae61a9dbcf4830c7429040
Merge: 3645ca8... a1bd4e3...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 23 23:50:01 2008 -0500

    Pull dmi-2.6.24 into release branch

commit 3645ca8359328ea4c75bce4af54ad24028381f30
Merge: 0f23a6b... ec68373...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 23 23:48:46 2008 -0500

    Pull bugzilla-9798 into release branch

commit 0f23a6b0c182b1040cb0b89e20527cd07d85aebf
Merge: 7456337... d772b3b...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 23 23:48:33 2008 -0500

    Pull bugzilla-8459 into release branch

commit 7456337d1fd38e463674dcb5a3df21ca332cb8b0
Merge: 667984d... d1154be...
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 23 23:48:19 2008 -0500

    Pull bugzilla-9747 into release branch

commit ec68373c04495edbe39fb94fad963fb781e062e5
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 23 22:41:20 2008 -0500

    Revert "ACPI: Fan: Drop force_power_state acpi_device option"
    
    This reverts commit 93ad7c07ad487b036add8760dabcc35666a550ef.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9798
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d772b3b323a15588a757f5af28e51a57d0d2f622
Author: Márton Németh <nm127@freemail.hu>
Date:   Wed Jan 23 22:34:09 2008 -0500

    ACPI: EC: "DEBUG" needs to be defined earlier
    
    The "DEBUG" symbol needs to be defined before #including <linux/kernel.h> to
    get the pr_debug() working.
    
    Signed-off-by: Márton Németh <nm127@freemail.hu>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 86dae0154a49b67c908faffeb33ba37eddceba74
Author: Márton Németh <nm127@freemail.hu>
Date:   Wed Jan 23 22:33:06 2008 -0500

    ACPI: EC: add leading zeros to debug messages
    
    Add leading zeros to pr_debug() calls. For example if x=0x0a, the format
    "0x%2x" will result the string "0x a", the format "0x%2.2x" will result "0x0a".
    
    Signed-off-by: Márton Németh <nm127@freemail.hu>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 03d1d99c55649ca641b86d2e3489b167ede1671a
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed Jan 23 22:28:34 2008 -0500

    ACPI: EC: fix dmesg spam regression
    
    Return OBF_1 optimization workaround
    
    http://bugzilla.kernel.org/show_bug.cgi?id=8459
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a1bd4e35e8d9df24db7d7addd74cbfcc87ec9fb3
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 23 21:19:27 2008 -0500

    ACPI: DMI blacklist to reduce console warnings on OSI(Linux) systems.
    
    This DMI blacklist reduces the console messages
    on systems which have a BIOS that invokes OSI(Linux).
    
    As the DMI blacklist already knows about these systems,
    the request for DMI info itself is disabled.
    
    Further, if OSI(Linux) has already been determined
    to have no beneift, we disable the console message
    requesting acpi_osi=Linux test results.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 98f1db22d70b0660a27cc8818a61181b5d503671
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 23 20:56:18 2008 -0500

    ACPI: Add ThinkPad R61, ThinkPad T61 to OSI(Linux) white-list
    
    acpi_osi=Linux helps sound on these systems.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d4b7dc499daae909e62dc260b95cd618f2970ded
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 23 20:50:56 2008 -0500

    ACPI: make _OSI(Linux) console messages smarter
    
    If BIOS invokes _OSI(Linux), the kernel response
    depends on what the ACPI DMI list knows about the system,
    and that is reflectd in dmesg:
    
    1) System unknown to DMI:
    
    ACPI: BIOS _OSI(Linux) query ignored
    ACPI: DMI System Vendor: LENOVO
    ACPI: DMI Product Name: 7661W1P
    ACPI: DMI Product Version: ThinkPad T61
    ACPI: DMI Board Name: 7661W1P
    ACPI: DMI BIOS Vendor: LENOVO
    ACPI: DMI BIOS Date: 10/18/2007
    ACPI: Please send DMI info above to linux-acpi@vger.kernel.org
    ACPI: If "acpi_osi=Linux" works better, please notify linux-acpi@vger.kernel.org
    
    2) System known to DMI, but effect of OSI(Linux) unknown:
    
    ACPI: DMI detected: Lenovo ThinkPad T61
    ...
    ACPI: BIOS _OSI(Linux) query ignored via DMI
    ACPI: If "acpi_osi=Linux" works better, please notify linux-acpi@vger.kernel.org
    
    3) System known to DMI, which disables _OSI(Linux):
    
    ACPI: DMI detected: Lenovo ThinkPad T61
    ...
    ACPI: BIOS _OSI(Linux) query ignored via DMI
    
    4) System known to DMI, which enable _OSI(Linux):
    
    ACPI: DMI detected: Lenovo ThinkPad T61
    ACPI: Added _OSI(Linux)
    ...
    ACPI: BIOS _OSI(Linux) query honored via DMI
    
    cmdline overrides take precidence over the built-in
    default and the DMI prescribed default.
    cmdline "acpi_osi=Linux" results in:
    
    ACPI: BIOS _OSI(Linux) query honored via cmdline
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7ce95ce5c6dbbc3f70933f04537860ffd9dbe17e
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 23 20:06:41 2008 -0500

    ACPI: Delete Intel Customer Reference Board (CRB) from OSI(Linux) DMI list
    
    Linux does not want BIOS writers to invoke _OSI(Linux) -
    for in the field it causes more Windows incompatibility problems
    than it solves.
    
    So when it is seen in the BIOS for an Intel Customer Reference Board,
    Linux should ignore its effect by default, and should complain loudly.
    Otherwise, the reference BIOS will go unfixed, and the bad BIOS
    will spread to the field.
    
    Users of this board can get the old behavior with "acpi_osi=Linux"
    
    As this was the only entry, delete acpi_osl_dmi_table[].
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f40cd6fddcb1d51d8a2a67ddc81c14a3532f3cb7
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 23 20:04:28 2008 -0500

    ACPI: on OSI(Linux), print needed DMI rather than requesting dmidecode output
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5a4e143271b97dcaa113761a76942c4d4bc273a2
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 23 20:01:22 2008 -0500

    ACPI: create acpi_dmi_dump()
    
    A utility routine to print common entries used
    for ACPI-related DMI blacklist entries.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f89e3b0620a0dc19f313218f55373b9361142203
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 23 16:36:45 2008 -0500

    DMI: create dmi_get_slot()
    
    This simply allows other sub-systems (such as ACPI)
    to access and print out slots in static dmi_ident[].
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 81b4e1f6269cea345f17d3aa349ec9beb31a8cd3
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 16 17:20:37 2008 -0500

    DMI: move dmi_available declaration to linux/dmi.h
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d1154be3004e9db2d61533e16bb2cf85dd27a8cb
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Tue Jan 15 00:47:47 2008 -0500

    ACPI: processor: Fix null pointer dereference in throttling
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9747
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>
