Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbYDXBAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbYDXBAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 21:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbYDXBAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 21:00:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:39822 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158AbYDXBA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 21:00:26 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: [GIT PATCH] ACPICA patches for 2.6.26-rc0
Date: Wed, 23 Apr 2008 20:59:48 -0400
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804232059.48941.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git acpica

These 70-odd patches update the ACPICA core in Linux to version 20080321 -- modulo any upstream ACPICA patches that we rejected.

Yes, in the bad old days, this is the patch that would have been one mondo consolidated patch.
Better this way, for the inevitable bisect.

This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/acpica/2.6.25/acpi-acpica-20080321-2.6.25.diff.gz

 drivers/acpi/dispatcher/dsfield.c  |  157 ++++++-----
 drivers/acpi/dispatcher/dsmethod.c |   31 +--
 drivers/acpi/dispatcher/dsobject.c |   95 +++++--
 drivers/acpi/dispatcher/dsopcode.c |  258 ++++++++++++++++-
 drivers/acpi/dispatcher/dsutils.c  |  165 ++++++++++--
 drivers/acpi/dispatcher/dswexec.c  |   76 +++---
 drivers/acpi/dispatcher/dswload.c  |   35 ++-
 drivers/acpi/dispatcher/dswstate.c |  513 +++++++--------------------------
 drivers/acpi/events/evmisc.c       |   88 +++---
 drivers/acpi/events/evregion.c     |    2 +-
 drivers/acpi/events/evxface.c      |   21 +-
 drivers/acpi/executer/exconfig.c   |  103 ++++++--
 drivers/acpi/executer/excreate.c   |  115 +-------
 drivers/acpi/executer/exdump.c     |   63 +++--
 drivers/acpi/executer/exfield.c    |   57 +----
 drivers/acpi/executer/exfldio.c    |   44 +++-
 drivers/acpi/executer/exmutex.c    |  233 +++++++++++-----
 drivers/acpi/executer/exoparg1.c   |   23 ++-
 drivers/acpi/executer/exoparg2.c   |   19 +-
 drivers/acpi/executer/exoparg3.c   |    1 +
 drivers/acpi/executer/exoparg6.c   |    8 +-
 drivers/acpi/executer/exprep.c     |   15 +
 drivers/acpi/executer/exregion.c   |    8 +-
 drivers/acpi/executer/exresnte.c   |   10 +-
 drivers/acpi/executer/exresolv.c   |   53 ++--
 drivers/acpi/executer/exresop.c    |   11 -
 drivers/acpi/executer/exstore.c    |  105 ++++++--
 drivers/acpi/executer/exsystem.c   |    1 -
 drivers/acpi/executer/exutils.c    |   55 ++--
 drivers/acpi/hardware/hwsleep.c    |   14 +-
 drivers/acpi/namespace/nsaccess.c  |   45 +++-
 drivers/acpi/namespace/nsdump.c    |    9 +-
 drivers/acpi/namespace/nsinit.c    |   10 +
 drivers/acpi/namespace/nsload.c    |    4 +-
 drivers/acpi/namespace/nsnames.c   |    6 +
 drivers/acpi/namespace/nsparse.c   |   31 ++-
 drivers/acpi/namespace/nswalk.c    |    2 -
 drivers/acpi/namespace/nsxfeval.c  |   13 +-
 drivers/acpi/parser/psargs.c       |   55 +++-
 drivers/acpi/parser/psloop.c       |   59 +++-
 drivers/acpi/parser/psopcode.c     |   36 ++-
 drivers/acpi/parser/psparse.c      |   37 ++-
 drivers/acpi/parser/pstree.c       |    2 +
 drivers/acpi/resources/rscalc.c    |   24 ++-
 drivers/acpi/resources/rsdump.c    |    8 +-
 drivers/acpi/resources/rsio.c      |   39 +++-
 drivers/acpi/resources/rsirq.c     |   43 +++-
 drivers/acpi/resources/rsmisc.c    |   11 +
 drivers/acpi/resources/rsutils.c   |    6 +-
 drivers/acpi/scan.c                |    3 +-
 drivers/acpi/tables/tbfind.c       |   26 ++-
 drivers/acpi/tables/tbinstal.c     |   20 +-
 drivers/acpi/tables/tbxface.c      |   89 ++++++
 drivers/acpi/utilities/utalloc.c   |    2 +-
 drivers/acpi/utilities/utcopy.c    |   59 ++++-
 drivers/acpi/utilities/utdebug.c   |   17 +-
 drivers/acpi/utilities/utdelete.c  |   21 ++-
 drivers/acpi/utilities/utglobal.c  |   47 +++-
 drivers/acpi/utilities/utinit.c    |    3 +
 drivers/acpi/utilities/utmath.c    |    2 +-
 drivers/acpi/utilities/utmisc.c    |    4 +
 drivers/acpi/utilities/utobject.c  |    6 +-
 drivers/acpi/utilities/utxface.c   |    4 +
 drivers/acpi/utils.c               |    2 +-
 include/acpi/acconfig.h            |   13 +-
 include/acpi/acdisasm.h            |   36 ++-
 include/acpi/acdispat.h            |   29 +-
 include/acpi/acglobal.h            |   36 ++-
 include/acpi/acinterp.h            |   13 +-
 include/acpi/aclocal.h             |    8 +-
 include/acpi/acmacros.h            |   49 ++--
 include/acpi/acnamesp.h            |    3 +-
 include/acpi/acobject.h            |    3 +-
 include/acpi/acopcode.h            |    4 +-
 include/acpi/acparser.h            |    2 +
 include/acpi/acpixf.h              |    5 +
 include/acpi/acresrc.h             |    1 +
 include/acpi/acstruct.h            |    3 +
 include/acpi/actbl1.h              |  559 +++++++++++++++++++++++++++++++++++-
 include/acpi/actypes.h             |   91 ++++---
 include/acpi/acutils.h             |    2 +
 81 files changed, 2729 insertions(+), 1252 deletions(-)

through these commits:

Bob Moore (54):
      ACPICA: Several fixes for internal method result stack
      ACPICA: Removed unused code
      ACPICA: Update for mutiple global lock acquisitions by same thread
      ACPICA: changed order of interpretation of operand objects
      ACPICA: Avoid use of invalid pointers in returned object field
      ACPICA: Fixed a couple compiler warnings for extra extern statements
      ACPICA: Update comments for acquire/release mutex interfaces
      ACPICA: Removed extraneous code
      ACPICA: Removed obsolete ACPI_NO_INTEGER64_SUPPORT define
      ACPICA: Misc fixes for recent global lock code update
      ACPICA: Increase maximum buffer size dumped to screen in buffer object dump
      ACPICA: Fix for package reference counts
      ACPICA: Update version to 20070320
      ACPICA: Fix for update of the Global Lock Handle
      ACPICA: Update version to 20070508
      ACPICA: Updated error message for dynamic method serialization
      ACPICA: Support for iASL - multiple files and wildcards
      ACPICA: Add minimal disassembly support for the SLIC table
      ACPICA: update version number to 20070919
      ACPICA: Fix for Alias operator to see target child objects
      ACPICA: Fix for fault if Load() fails
      ACPICA: Fix a fault when storing DdbHandle to Debug object
      ACPICA: Fix for memory leak related to DdbHandle objects
      ACPICA: Add a table checksum verify for Load operator
      ACPICA: Add error checks to prevent faults
      ACPICA: Fix for Load/LoadTable to specify load location
      ACPICA: Fixed a memory leak when Device or Thermal objects referenced in packages
      ACPICA: Update version to 20071019
      ACPICA: Cosmetic changes only, no functional changes
      ACPICA: Cosmetic changes only, no functional changes
      ACPICA: Cleanup of debug output
      ACPICA: Fixes a problem with control method references within packages
      ACPICA: Fixed a problem with FromBCD and ToBCD with some compilers
      ACPICA: Update version to 20071114
      ACPICA: Fixed a problem with AcpiGetDevices where the search of a branch of the device tree could be terminated prematurely
      ACPICA: Fixed a problem with Index Fields where the Index register was incorrectly limited to a maximum of 32 bits
      ACPICA: Undo accidental checkin of not-fully-tested mutex changes
      ACPICA: Update version to 20071219
      ACPICA: Include file support for new ACPI tables
      ACPICA: Bulletproof disassembler for bad ACPI tables
      ACPICA: Update version to 20080123
      ACPICA: Add va_end statements as appropriate
      ACPICA: Added new error messages
      ACPICA: Fix for ACPI_HIDWORD macro
      ACPICA: Disassembler support for new ACPI tables
      ACPICA: Fix for resource descriptor optimization issues for _CRS/_SRC
      ACPICA: Fix for possible error when packages/buffers are passed to methods externally
      ACPICA: Update ACPICA version to 20080213
      ACPICA: Fix for extraneous debug message for packages
      ACPICA: Fixes for external Reference Objects
      ACPICA: Updates for Debug object output
      ACPICA: Fixes for size of StartDependent resource descriptor
      ACPICA: Update version to 20080321
      ACPICA: Fix for some local named nodes not marked temporary and to disallow duplicates

Lin Ming (15):
      ACPICA: New interfaces for table event handlers
      ACPICA: Fix for namespace lookup problem
      ACPICA: Fix for Increment/Decrement operator, incorrect type change
      ACPICA: Added additional parameter validation for LoadTable
      ACPICA: Fixed a problem with Index references passed as method arguments
      ACPICA: Fixed a problem with CopyObject used in conjunction with the Index operator
      ACPICA: Implemented full support for deferred execution for the TermArg string arguments for DataTableRegion
      ACPICA: Implemented full argument resolution support for the BankValue argument to BankField
      ACPICA: Fix for SizeOf when used with Buffers and Packages
      ACPICA: Methods now implicitly return 0 in slack mode
      ACPICA: Fix for Load operator
      ACPICA: Fix for LoadTable operator, input strings
      ACPICA: Fixes for Unload and DDBHandles
      ACPICA: Update behavior of CopyObject to match ACPI spec
      ACPICA: Fix to handle NULL package elements correctly

Zhang Rui (1):
      ACPICA: Update for new Notify values

with this log:

commit cca97b81564c5edbc8700ebb64fc2b4e13dfa51f
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:44 2008 +0400

    ACPICA: Fix for some local named nodes not marked temporary and to disallow duplicates
    
    Fixed a problem with the CreateField, CreateXXXField (Bit, Byte,
    Word, Dword, Qword), Field, BankField, and IndexField operators
    when invoked from inside an executing control method. In this case,
    these operators created namespace nodes that were incorrectly
    left marked as permanent nodes instead of temporary nodes. This
    could cause a problem if there is race condition between an
    exiting control method and a running namespace walk. (Reported
    by Linn Crosetto). Fixed a problem where the CreateField and
    CreateXXXField operators would incorrectly allow duplicate names
    (the name of the field) with no exception generated.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 66e2c0bcc5f6b8454d9091f6ba9ef4090abca4fd
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:44 2008 +0400

    ACPICA: Update version to 20080321
    
    Update version to 20080321.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 514d18d79b1da052ed4553ceec1f7e1197a5bb51
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Apr 10 19:06:44 2008 +0400

    ACPICA: Update for new Notify values
    
    Implemented several changes for Notify handling: Added support
    for new Notify values (ACPI 2.0+) and improved the Notify debug
    output. Notify on PowerResource objects is no longer allowed,
    as per the ACPI specification.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 66d3ca9ea28e1b3d591083772fd797b9b46410b8
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:44 2008 +0400

    ACPICA: Fixes for size of StartDependent resource descriptor
    
    Fixed a couple of size calculation issues with the variable-length
    Start Dependent resource descriptor.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d8846574ed4a81be319bf68728f9cca9af595afd
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:43 2008 +0400

    ACPICA: Updates for Debug object output
    
    Implemented several improvements for the output of the ASL "Debug"
    object to clarify and keep all data for a given object on one
    output line.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cd0b2248241f4146152fb04a6bf4bccb6ce0478a
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:43 2008 +0400

    ACPICA: Fixes for external Reference Objects
    
    All Reference Objects returned via the AcpiEvaluteObject interface
    are now marked as type "REFERENCE" instead of "ANY". The type ANY
    is now reservered for NULL objects - either NULL package elements
    or unresolved named references.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7a5bb9964512c5313af19310c6a3002ec54f7336
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:43 2008 +0400

    ACPICA: Fix to handle NULL package elements correctly
    
    Fixed problem where NULL package elements were not returned to
    the AcpiEvaluateObject interface correctly. Instead of returning a
    NULL ACPI_OBJECT package element, the element was simply ignored,
    potentially causing a buffer overflow and/or confusing the caller
    who expected a fixed number of elements.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=10132
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0ba7d25c70699cdd3e06fc049d8884ee54b9d5db
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:43 2008 +0400

    ACPICA: Fix for extraneous debug message for packages
    
    Fixed a problem where an extraneous debug message was produced for
    package objects (when debugging enabled). The message "Package
    List length larger than NumElements count" is now produced in
    the correct case, and is also an error message rather than a
    debug message. Added a debug message for the opposite case, where
    NumElements is larger than the Package List, and the package has
    been padded out with NULL elements.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a0144a2929620d9682bc4b0c6274ef03e417f49a
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:43 2008 +0400

    ACPICA: Update ACPICA version to 20080213
    
    Update ACPICA version to 20080213.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 24a3157a90ddf851a0880c0b8963bc43481cd85b
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:43 2008 +0400

    ACPICA: Fix for possible error when packages/buffers are passed to methods externally
    
    Fixed a problem where buffer and package objects passed as
    arguments to a control method via the external AcpiEvaluateObject
    interface could cause an AE_AML_INTERNAL exception depending on the
    order and type of operators executed by the target control method.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a3df4dadd446c0d7195f2bbe86dd5174426d8090
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:43 2008 +0400

    ACPICA: Update behavior of CopyObject to match ACPI spec
    
    Fixed a problem where a CopyObject to RegionField, BankField, and
    IndexField objects did not perform an implicit conversion as it
    should. These types must retain their initial type permanently as
    per the ACPI specification. However, a CopyObject to all other
    object types should not perform an implicit conversion, as per
    the ACPI specification.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=388
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1d5b285da1893b90507b081664ac27f1a8a3dc5b
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:43 2008 +0400

    ACPICA: Fix for resource descriptor optimization issues for _CRS/_SRC
    
    Fixed a problem where resource descriptor size optimization
    could cause a problem when a _CRS resource template is passed
    to a _SRS method. The _SRS resource template must use the same
    descriptors (with the same size) as returned from _CRS. This
    change affects the following resource descriptors: IRQ/IRQNoFlags
    and StartDependendentFn/StartDependentFnNoPri.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9487
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3fa347770a8a9cb3568600380ce4b5c041b3ac0b
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:43 2008 +0400

    ACPICA: Disassembler support for new ACPI tables
    
    Implemented full disassembler support for the following new ACPI
    tables: BERT, EINJ, and ERST. Partial disassembler support for
    the complicated HEST table. These tables support the Windows
    Hardware Error Architecture (WHEA).
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7823665eccdc7e230d0a904c6ec01d5c70ee099b
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:42 2008 +0400

    ACPICA: Fix for ACPI_HIDWORD macro
    
    Fixed a regression introduced in version 20071114. The ACPI_HIDWORD
    macro was inadvertently changed to return a 16-bit value instead of
    a 32-bit value, truncating the upper Dword of a 64-bit value. This
    macro is only used to display debug output, so no incorrect
    calculations were made.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b1dd9096fef08642eb509fbf2a40b3c7734dce1c
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:42 2008 +0400

    ACPICA: Added new error messages
    
    New messages for the 2 AE_SUPPORT cases.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 507f046c4dd17e9c94b5130ba184f8da90504685
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:42 2008 +0400

    ACPICA: Add va_end statements as appropriate
    
    Added missing va_end statements that should correspond with each
    va_start statement.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8c49c235774002708bd0da1c28c570073ebd963b
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:42 2008 +0400

    ACPICA: Update version to 20080123
    
    Update version to 20080123.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bc7a36ab74e09da7bb63e2477b0740ac992b290e
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:42 2008 +0400

    ACPICA: Fixes for Unload and DDBHandles
    
    Implemented support for the use of DDBHandles as an Indexed
    Reference, as per the ACPI spec.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=486.
    
    Implemented support for UserTerm (Method invocation) for the Unload operator
    as per the ACPI spec.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=580
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a6f4a4511e65942b93ded60d746094ec0e58ed8e
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:42 2008 +0400

    ACPICA: Bulletproof disassembler for bad ACPI tables
    
    Fixed a problem with the disassembler where invalid ACPI tables
    could cause faults or infinite loops.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 970d9c9ec313daa1b41db0f8bdd1ca8cc2903822
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:42 2008 +0400

    ACPICA: Include file support for new ACPI tables
    
    Implemented header file support for new ACPI tables - BERT, ERST,
    EINJ, HEST, IBFT, UEFI, WDAT. Disassembler support is forthcoming.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 47c08729bf1c60d522d020a7f8bc15d1c70e6ecb
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:42 2008 +0400

    ACPICA: Fix for LoadTable operator, input strings
    
    Fixed a problem with the LoadTable operator where the OemId
    and OemTableId input strings could cause unexpected failures if
    they were shorter than the maximum lengths allowed.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=576
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 200cce6a75061a3bf8d2e6b27c5cdcc7730893f1
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:42 2008 +0400

    ACPICA: Fix for Load operator
    
    Fixed a problem with the Load operator where an exception was not
    returned in the case where the table is already loaded.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=463
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9accd46459b8c068540451fdab07dbfcefaf7280
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:42 2008 +0400

    ACPICA: Methods now implicitly return 0 in slack mode
    
    Implemented an enhancement to the interpreter "slack mode". In the
    absence of an explicit return or an implicitly returned object from
    the last executed opcode, a control method will now implicitly
    return an integer of value 0 for Microsoft compatibility.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=392
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8246934b7cf99d1f0c053d57890775e5d0df9c33
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:41 2008 +0400

    ACPICA: Fix for SizeOf when used with Buffers and Packages
    
    Fixed a problem with the SizeOf operator when used with Package
    and Buffer objects. These objects have deferred execution for some
    arguments, and the execution is now completed before the SizeOf is
    executed. This problem caused unexpected AE_PACKAGE_LIMIT errors
    on some systems.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9558
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c351f2dd542a3980e96cf128e06d19f784c5ea3e
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:41 2008 +0400

    ACPICA: Update version to 20071219
    
    Update version to 20071219.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ef805d956320ffa36d068673d5c5eb2a7d13209b
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:41 2008 +0400

    ACPICA: Implemented full argument resolution support for the BankValue argument to BankField
    
    Previously, only constants were supported, now any TermArg may
    be used.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=387
    http://www.acpica.org/bugzilla/show_bug.cgi?id=393
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 57345ee6b807d32e5eecf724a463378b80cc261c
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:41 2008 +0400

    ACPICA: Undo accidental checkin of not-fully-tested mutex changes
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 941f48bb465b0b291f8435b1e3de95b0975b84bc
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:41 2008 +0400

    ACPICA: Implemented full support for deferred execution for the TermArg string arguments for DataTableRegion
    
    This enables forward references and full operand resolution for
    the three string arguments. Similar to OperationRegion deferred
    argument execution.)
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=430
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9aa6169f471771324b476a90d9392daa06d63a2d
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:41 2008 +0400

    ACPICA: Fixed a problem with Index Fields where the Index register was incorrectly limited to a maximum of 32 bits
    
    Now any size may be used.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 549f46044e1e207a2cbfdfb3f9a0d3fd5fd4105e
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:41 2008 +0400

    ACPICA: Fixed a problem with AcpiGetDevices where the search of a branch of the device tree could be terminated prematurely
    
    In accordance with the ACPI specification, the search is terminated
    if a device is both not present and not functional (instead of
    just not present.) Yakui Zhao.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8a2e71a82375aa2aef571d5fa9064ba67c8856a5
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:41 2008 +0400

    ACPICA: Update version to 20071114
    
    Update version to 20071114.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1cb2ef6606e0abd8565f66b5f95267de1b390694
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:41 2008 +0400

    ACPICA: Fixed a problem with CopyObject used in conjunction with the Index operator
    
    The reference was incorrectly dereferenced before the copy. The
    reference is now correctly copied.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=5391
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e5bcc811f78f294e7be8a0721b3fb513028c5af4
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:41 2008 +0400

    ACPICA: Fixed a problem with Index references passed as method arguments
    
    References passed as arguments to control methods were dereferenced
    immediately (before control was passed to the called method). The
    references are now correctly passed directly to the called
    method.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=5389
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1f549a240ccb2755066587e1e6ef9f74f485a46a
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:40 2008 +0400

    ACPICA: Fixed a problem with FromBCD and ToBCD with some compilers
    
    On some compilers, the ShortDivide function worked incorrectly,
    causing problems with the BCD functions with large input
    values. (Truncation from 64-bit to 32-bit occurred.) Internal
    http://www.acpica.org/bugzilla/show_bug.cgi?id=435
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b160987df7f49ee9c048a43b70ebae613a7e1437
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:40 2008 +0400

    ACPICA: Fixes a problem with control method references within packages
    
    Completes the package changes started with version 20071019.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f2d69559b31c368cfe3a51607d9cd5e8c0168875
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:40 2008 +0400

    ACPICA: Cleanup of debug output
    
    Improved output of object dump routine.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b7f9f04228eae2cf5adc2ffeb494d4970a8dd8a5
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:40 2008 +0400

    ACPICA: Cosmetic changes only, no functional changes
    
    Lint changes, fix compiler warnings, etc.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1d18c05825c3f2b8933a7fc7f7528881e98deb04
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:40 2008 +0400

    ACPICA: Cosmetic changes only, no functional changes
    
    Lint changes, fix compiler warnings, etc.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 39adb11e56d8eef6169aeae38f65df26883ff49c
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:40 2008 +0400

    ACPICA: Update version to 20071019
    
    Update version to 20071019.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 49718b1741cb74d86eb8b1bd8f52ad6a013b40df
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:40 2008 +0400

    ACPICA: Added additional parameter validation for LoadTable
    
    Implemented additional parameter validation for the LoadTable
    operator. The length of the input strings SignatureString,
    OemIdString, and OemTableId are now checked for maximum
    lengths.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=582
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fe4078af56a7b7f37391712cf188df3202b03776
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:40 2008 +0400

    ACPICA: Fix for Increment/Decrement operator, incorrect type change
    
    Fixed a problem with the Increment and Decrement operators where
    the type of the target object could be unexpectedly and incorrectly
    changed.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=353
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9e41d93c975d403380b7debe05517d630c8e2836
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:39 2008 +0400

    ACPICA: Fixed a memory leak when Device or Thermal objects referenced in packages
    
    Problem introduced in fix for Package references.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7f4ac9f91383a0707de559dc8fbca986fc2d302f
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:39 2008 +0400

    ACPICA: Fix for Load/LoadTable to specify load location
    
    Fixed a problem with the Load and LoadTable operators where
    the table location within the namespace was ignored. Instead,
    the table was always loaded into the root or current scope.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d8841647de7c4aa3f3ff5b8b8c4a3f042e848ff0
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:39 2008 +0400

    ACPICA: Add error checks to prevent faults
    
    Added additional error checking to prevent run-time faults.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 98af37fba9b3e601ca4bded51ef51a2be4e8c97b
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:39 2008 +0400

    ACPICA: Add a table checksum verify for Load operator
    
    Added a table checksum verification for the Load operator, in
    the case where the load is from a buffer.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=578
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a13b8460c5b43a68192b599ce437168cc2ff04de
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:39 2008 +0400

    ACPICA: Fix for memory leak related to DdbHandle objects
    
    Fixed a memory leak where DdbHandle objects were not deleted
    automatically at control method exit.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 61ce421bb761f607b802c268bd8bd6a0c928a661
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:39 2008 +0400

    ACPICA: Fix a fault when storing DdbHandle to Debug object
    
    Fixed a problem with the Debug object where a store of a DdbHandle
    reference object to the Debug object could cause a fault.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5eb691805f7ec5960fe9d5d7fc57a7fc3097bbd0
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:39 2008 +0400

    ACPICA: Fix for fault if Load() fails
    
    Fixed a problem with the Load operator when loading a table from
    a buffer object. The input buffer was prematurely zeroed and/or
    deleted.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=577
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 53cf174409a24e8388e1d554d27436275fc81fe7
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:39 2008 +0400

    ACPICA: Fix for Alias operator to see target child objects
    
    Fixed a problem with the Alias operator when the target of the
    alias is a named ASL operator that opens a new scope -- Scope,
    Device, PowerResource, Processor, and ThermalZone. In these cases,
    any children of the original operator could not be accessed via
    the alias, potentially causing unexpected AE_NOT_FOUND exceptions.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1c12a7dde1752f2c40fe170cabff463a0b362720
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:39 2008 +0400

    ACPICA: update version number to 20070919
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 14808822a9cea782c2e6f8d39e438cc3891f6472
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:38 2008 +0400

    ACPICA: Fix for namespace lookup problem
    
    Fixed a problem where objects of certain types (Device,
    ThermalZone, Processor, PowerResource) can be not found if they
    are declared and referenced from within the same control method
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=341.
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3e08e2d2d6efb256aa035e300deb059bb333b6db
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:38 2008 +0400

    ACPICA: New interfaces for table event handlers
    
    Designed and implemented new external interfaces to install and
    remove handlers for ACPI table-related events. Current events that
    are defined are LOAD and UNLOAD. These interfaces allow the host to
    track ACPI tables as they are dynamically loaded and unloaded. See
    AcpiInstallTableHandler and AcpiRemoveTableHandler.
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 698c0a0c299bd9389522e14dae1aff02070bac25
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:38 2008 +0400

    ACPICA: Add minimal disassembly support for the SLIC table
    
    SLIC - Software Licensing Description Table.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e20a679b4acf81a419bbe80beddedc988bf3bd51
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:38 2008 +0400

    ACPICA: Support for iASL - multiple files and wildcards
    
    Implemented support to allow multiple files to be
    compiled/disassembled in a single invocation. This includes
    command line wildcard support for both the Windows and Unix
    versions of the compiler. This feature simplifies the disassembly
    and compilation of multiple ACPI tables in a single directory.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6deb65dd9d66ff70fa8f8665690295a1126f801a
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:38 2008 +0400

    ACPICA: Updated error message for dynamic method serialization
    
    Added more information to make the message clearer.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5cc1b9b42663878330a4cc1d8020bb9289c46066
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:38 2008 +0400

    ACPICA: Update version to 20070508
    
    Update version to 20070508.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e5567afa5cfa19e45f93c9c8796e46187a2d12f4
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:38 2008 +0400

    ACPICA: Fix for update of the Global Lock Handle
    
    Fixed a problem where the global lock handle was not properly
    updated if a thread that acquired the global lock via
    executing AML code then attempted to acquire the lock via the
    AcpiAcquireGlobalLock interface.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 235eebbdb501261e9960deb2a9a3459af44ec0ea
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:38 2008 +0400

    ACPICA: Update version to 20070320
    
    pdate version to 20070320
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 91d02132fea3a60d3db7bd72933e38e36cd9e4c7
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:38 2008 +0400

    ACPICA: Fix for package reference counts
    
    Prevents infinite loop of 'Large Reference Count' messages in
    aslts-bdemo-b286 test.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 422f4f90a23437e3e9de31eab5feb2a13f0cbb38
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:37 2008 +0400

    ACPICA: Increase maximum buffer size dumped to screen in buffer object dump
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f02e9fa1ceee045f7d5c53d475032815752a2510
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:37 2008 +0400

    ACPICA: Misc fixes for recent global lock code update
    
    Fixes as a result of running full validation test suite.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a4df451a1055d97726ab890249bc3f941906fa75
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:37 2008 +0400

    ACPICA: Removed obsolete ACPI_NO_INTEGER64_SUPPORT define
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a69c77c72094bfda1ed02336ec9a1bae186fd2fc
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:37 2008 +0400

    ACPICA: Removed extraneous code
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 91e38d10b2b49b8a200111baa7714c4a7e658a4c
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:37 2008 +0400

    ACPICA: Update comments for acquire/release mutex interfaces
    
    pdate comments for acquire/release mutex interfaces
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit dbaaa9567543191faa933e78f979f5ff7385918c
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:37 2008 +0400

    ACPICA: Fixed a couple compiler warnings for extra extern statements
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4b6e16cf2bacbf328535097fa74f1494b1873c54
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:37 2008 +0400

    ACPICA: Avoid use of invalid pointers in returned object field
    
    During operand evaluation, ensure that the ReturnObj field is
    cleared on error and only valid pointers are stored there.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4e3156b183aa087bc19804b3295c7c1a71f64752
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:37 2008 +0400

    ACPICA: changed order of interpretation of operand objects
    
    The interpreter now evaluates operands in the order that they
    appear (both in the
     AML and ASL), instead of in reverse order. This previously
     caused subtle incompatibilities with the MS interpreter as well
     as being non-intuitive.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ba886cd4ac957608777fbc8d137f6b9f0450e775
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:37 2008 +0400

    ACPICA: Update for mutiple global lock acquisitions by same thread
    
    Allows AcpiAcquireGlobalLock external interface to be called
    multiple times by the
     same thread. Allows use of AML fields that require the global
     lock while the running AML is already holding the global lock.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f654ecbfacb47d20e8cac087bbada1b947db846b
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:36 2008 +0400

    ACPICA: Removed unused code
    
    Handling of AML_NAME_OP as a Reference.Opcode is no longer
    needed. Kernel bugzilla 2874
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 773069d48030e670cf2032a13ddf16a2e0034df3
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Apr 10 19:06:36 2008 +0400

    ACPICA: Several fixes for internal method result stack
    
    fixes STACK_OVERFLOW exception on nested method calls. internal
    bugzilla 262 and 275.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>
