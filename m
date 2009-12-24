Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbZLXGjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbZLXGjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 01:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbZLXGjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 01:39:49 -0500
Received: from vms173013pub.verizon.net ([206.46.173.13]:42831 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbZLXGjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 01:39:49 -0500
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_Yu316arE3/obdVCtvK2XfA)"
Date: Thu, 24 Dec 2009 01:39:25 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [git pull request] ACPI & driver patches for 2.6.33-rc1
Message-id: <alpine.LFD.2.00.0912240137190.6541@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_Yu316arE3/obdVCtvK2XfA)
Content-type: TEXT/PLAIN; charset=ISO-8859-15
Content-transfer-encoding: 8BIT

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This batch fixes the one ACPI regression reported so far in .33.
It includes a few key bug fixes, plus a small arch vs ACPI code re-org.

On the platform-specific-driver side, it adds classmate-laptop,
which I should have sent up before -rc1, plus misc driver updates.

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.33/acpi-release-20091214-2.6.33-rc1.diff.gz

 MAINTAINERS                                |   11 +
 arch/ia64/include/asm/acpi.h               |    6 +
 arch/ia64/kernel/Makefile                  |    4 -
 arch/ia64/kernel/acpi-processor.c          |   85 ----
 arch/x86/include/asm/acpi.h                |   26 ++
 arch/x86/kernel/acpi/Makefile              |    2 +-
 arch/x86/kernel/acpi/processor.c           |  101 -----
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    4 +-
 drivers/acpi/Makefile                      |    1 +
 drivers/acpi/blacklist.c                   |   14 +
 drivers/acpi/bus.c                         |   28 +-
 drivers/acpi/ec.c                          |   10 +-
 drivers/acpi/internal.h                    |    1 +
 drivers/acpi/processor_core.c              |   71 +----
 drivers/acpi/processor_pdc.c               |  165 ++++++++
 drivers/ata/Kconfig                        |    1 -
 drivers/platform/x86/Kconfig               |   12 +
 drivers/platform/x86/Makefile              |    1 +
 drivers/platform/x86/acer-wmi.c            |    3 -
 drivers/platform/x86/acerhdf.c             |   68 ++-
 drivers/platform/x86/asus_acpi.c           |  321 +++++++++------
 drivers/platform/x86/classmate-laptop.c    |  609 ++++++++++++++++++++++++++++
 drivers/platform/x86/dell-wmi.c            |   42 +-
 drivers/platform/x86/fujitsu-laptop.c      |    8 +-
 drivers/platform/x86/hp-wmi.c              |   11 +-
 drivers/platform/x86/msi-wmi.c             |   10 -
 drivers/platform/x86/sony-laptop.c         |   94 ++++-
 drivers/platform/x86/tc1100-wmi.c          |  115 +++---
 drivers/platform/x86/toshiba_acpi.c        |  259 +++++++-----
 drivers/platform/x86/wmi.c                 |    4 +-
 include/acpi/processor.h                   |    8 +-
 include/linux/sonypi.h                     |    1 +
 32 files changed, 1432 insertions(+), 664 deletions(-)
 delete mode 100644 arch/ia64/kernel/acpi-processor.c
 delete mode 100644 arch/x86/kernel/acpi/processor.c
 create mode 100644 drivers/acpi/processor_pdc.c
 create mode 100644 drivers/platform/x86/classmate-laptop.c

through these commits:

Alex Chiang (11):
      ACPI: processor: call _PDC early
      ACPI: processor: introduce arch_has_acpi_pdc
      ACPI: processor: unify arch_acpi_processor_init_pdc
      ACPI: processor: factor out common _PDC settings
      ACPI: processor: finish unifying arch_acpi_processor_init_pdc()
      ACPI: processor: unify arch_acpi_processor_cleanup_pdc
      ACPI: processor: introduce acpi_processor_alloc_pdc()
      ACPI: processor: change acpi_processor_eval_pdc interface
      ACPI: processor: open code acpi_processor_cleanup_pdc
      ACPI: processor: change acpi_processor_set_pdc() interface
      ACPI: processor: remove _PDC object list from struct acpi_processor

Alexey Dobriyan (2):
      asus_acpi: convert to seq_file
      toshiba_acpi: convert to seq_file

Alexey Starikovskiy (1):
      ACPI: EC: Fix MSI DMI detection

Andrew Morton (1):
      arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c: avoid cross-CPU interrupts by using smp_call_function_any()

Anisse Astier (2):
      MAINTAINERS: add maintainer for msi-wmi driver
      wmi: Free the allocated acpi objects through wmi_get_event_data

Carlos R. Mafra (1):
      ACPI: do not select ACPI_DOCK from ATA_ACPI

Dmitry Torokhov (4):
      tc1100-wmi - switch to using attribute group
      tc1100-wmi - add error handling for device registration
      tc1100-wmi - switch to using dev_pm_ops
      dell-wmi: do not keep driver loaded on unsupported boxes

Jonathan Woithe (1):
      fujitu-laptop: fix tests of acpi_evaluate_integer() return value

Mattia Dongili (3):
      sony-laptop: add AVMode key mapping
      sony-laptop: rfkill support for newer models
      sony-laptop: enumerate rfkill devices using SN06

Peter Feuerer (2):
      acerhdf: add new BIOS versions
      drivers/platform/x86/acerhdf.c: check BIOS information whether it begins with string of table

Shaohua Li (1):
      ACPI: fix OSC regression that caused aer and pciehp not to load

Stefan Bader (1):
      acerhdf: limit modalias matching to supported

Thadeu Lima de Souza Cascardo (1):
      classmate-laptop: add support for Classmate PC ACPI devices

Thomas Renninger (2):
      acer-wmi, msi-wmi: Remove needless DMI MODULE_ALIAS
      hp-wmi: Fix two memleaks

Zhang Rui (1):
      ACPI: disable _OSI(Windows 2009) on Asus K50IJ

with this log:

commit fcb11235d3910c39afece52f6e106a9ca565d34b
Merge: 78a5331 44ef00e
Author: Len Brown <len.brown@intel.com>
Date:   Thu Dec 24 01:19:00 2009 -0500

    Merge branch 'misc-2.6.33' into release

commit 78a5331dddcffabadef024ccc051f7a519b13238
Merge: fe7fa9c 8e698a3
Author: Len Brown <len.brown@intel.com>
Date:   Thu Dec 24 01:17:46 2009 -0500

    Merge branch 'tc1100-wmi' into release

commit fe7fa9c51a76cf67934c2e77dc9d84800c9fbf79
Merge: 6d3bf68 528809c
Author: Len Brown <len.brown@intel.com>
Date:   Thu Dec 24 01:17:41 2009 -0500

    Merge branch 'sony' into release

commit 6d3bf6818a1d5527f44681d3f763051dfb1930e4
Merge: da3df85 529aa8c
Author: Len Brown <len.brown@intel.com>
Date:   Thu Dec 24 01:17:31 2009 -0500

    Merge branch 'classmate' into release

commit da3df858c88f7bb420f2517ee9aab238da2e6ed7
Merge: 309ddc5 e59897f
Author: Len Brown <len.brown@intel.com>
Date:   Thu Dec 24 01:17:21 2009 -0500

    Merge branch 'pdc' into release

commit 309ddc53be1766d6ed5411a3dc1782c2040198fa
Merge: 6f5464c 55b313f 81074e9 78f1699
Author: Len Brown <len.brown@intel.com>
Date:   Thu Dec 24 01:17:01 2009 -0500

    Merge branches 'bugzilla-14446', 'bugzilla-14753' and 'bugzilla-14824' into release

commit 6f5464ce154bc72c67bbc82e818e4fdd61cb9f8e
Merge: 2f99f5c 9dc130f
Author: Len Brown <len.brown@intel.com>
Date:   Thu Dec 24 01:16:35 2009 -0500

    Merge branch 'osc' into release

commit 529aa8cb0a59367d08883f818e8c47028e819d0d
Author: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Date:   Mon Dec 21 16:20:01 2009 -0800

    classmate-laptop: add support for Classmate PC ACPI devices
    
    This add supports for devices like keyboard, backlight, tablet and
    accelerometer.
    
    This work is supported by International Syst S/A.
    
    [randy.dunlap@oracle.com: cmpc_acpi: depends on ACPI]
    [akpm@linux-foundation.org: readability tweaks]
    [akpm@linux-foundation.org: coding-style fixes]
    Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 44ef00e6482e755f36629773abc2aee83a6f53e3
Author: Thomas Renninger <trenn@suse.de>
Date:   Fri Dec 18 15:29:23 2009 +0100

    hp-wmi: Fix two memleaks
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4d5f177caf1ef78f5e7eaee75b66b4d534445682
Author: Thomas Renninger <trenn@suse.de>
Date:   Fri Dec 18 15:29:22 2009 +0100

    acer-wmi, msi-wmi: Remove needless DMI MODULE_ALIAS
    
    Now that we have WMI autoloading
    the DMI matching is not needed anymore.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Acked-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Acked-by: Anisse Astier <anisse@astier.eu>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1fdd407f4e3f2ecb453954cbebb6c22491c61853
Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Thu Dec 17 22:19:42 2009 -0800

    dell-wmi: do not keep driver loaded on unsupported boxes
    
    There is no point in having the driver loaded in memory if we fail
    to locate particular WMI GUID.
    
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
    Acked-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3e9b988e4edf065d39c1343937f717319b1c1065
Author: Anisse Astier <anisse@astier.eu>
Date:   Fri Dec 4 10:10:09 2009 +0100

    wmi: Free the allocated acpi objects through wmi_get_event_data
    
    These function allocate an acpi object by calling wmi_get_event_data, which
    then calls acpi_evaluate_object, and it is not freed afterwards.
    
    And kernel doc is fixed for parameters of wmi_get_event_data.
    
    Signed-off-by: Anisse Astier <anisse@astier.eu>
    Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
    Acked-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit dcbfb8156a2149fd6358a377aa9400e28ef43800
Author: Peter Feuerer <peter@piie.net>
Date:   Mon Dec 21 16:20:06 2009 -0800

    drivers/platform/x86/acerhdf.c: check BIOS information whether it begins with string of table
    
    BIOS information is now checked whether it begins with the strings stored
    in the BIOS table.  Previous method did a strcmp, what lead to problems if
    BIOS information has appended whitespaces.
    
    Signed-off-by: Peter Feuerer <peter@piie.net>
    Cc: Borislav Petkov <petkovbb@gmail.com>
    Cc: Andreas Mohr <andi@lisas.de>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: "H. Peter Anvin" <hpa@zytor.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 94219d798e65dff1dac5f8f36f03a9bdb3105f91
Author: Peter Feuerer <peter@piie.net>
Date:   Mon Dec 21 16:20:05 2009 -0800

    acerhdf: add new BIOS versions
    
    Add new BIOS versions for following netbooks: Aspire 1810xx, Packard Bell
    DOTMU.
    
    Signed-off-by: Peter Feuerer <peter@piie.net>
    Cc: Borislav Petkov <petkovbb@gmail.com>
    Cc: Andreas Mohr <andi@lisas.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bdc731bc5fcd1794e9ac8ac80c389d302381c123
Author: Stefan Bader <stefan.bader@canonical.com>
Date:   Mon Dec 21 16:20:04 2009 -0800

    acerhdf: limit modalias matching to supported
    
    BugLink: https://bugs.launchpad.net/ubuntu/+bug/435958
    
    The module alias currently matches any Acer computer but when loaded the
    BIOS checks will only succeed on Aspire One models.  This causes a invalid
    BIOS warning for all other models (seen on Aspire 4810T).  This is not
    fatal but worries users that see this message.  Limiting the moule alias
    to models starting with AOA or DOA for Packard Bell.
    
    Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
    Acked-by: Borislav Petkov <petkovbb@gmail.com>
    Acked-by: Peter Feuerer <peter@piie.net>
    Cc: <stable@kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 936c8bcd7f5b418d0e040be539ceb4d2ac3bc0b8
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Mon Dec 21 16:20:02 2009 -0800

    toshiba_acpi: convert to seq_file
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Cc: John W. Linville <linville@tuxdriver.com>
    Cc: Johannes Berg <johannes@sipsolutions.net>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ff93be5dea548f16dcfe7b73ce5df7666efba92d
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Mon Dec 21 16:20:01 2009 -0800

    asus_acpi: convert to seq_file
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Cc: Corentin Chary <corentincj@iksaif.net>
    Cc: Karol Kozimor <sziwan@users.sourceforge.net>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2370b5ed03030d554adb345778d5edecab7a510c
Author: Carlos R. Mafra <crmafra@aei.mpg.de>
Date:   Tue Dec 22 13:45:39 2009 -0800

    ACPI: do not select ACPI_DOCK from ATA_ACPI
    
    In March 2008 commit 0ac4a3c2fbbcadc3e96e4dc47d4ae802d66e6f67 ("ACPI: fix
    ATA_ACPI build") made CONFIG_ACPI_DOCK be selected by CONFIG_ATA_ACPI because
    of a build error when CONFIG_ATA_ACPI=y and CONFIG_ACPI_DOCK=m.
    
    However, in September 2008 commit 898b054f3eec5921320ae8614b5bdd7b07ea5b43
    ("dock: make dock driver not a module") removed the possibility of having
    CONFIG_ACPI_DOCK=m and therefore there is no need for selecting it when
    CONFIG_ATA_ACPI=y.
    
    This makes the kernel ~5 Kb smaller for people who don't have a dock by
    allowing them to not have ACPI_DOCK compiled-in because of ATA_ACPI=y.
    
    Signed-off-by: Carlos R. Mafra <crmafra@aei.mpg.de>
    Cc: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 528809c35faebd8c50a4722c85ab8610725875cc
Author: Mattia Dongili <malattia@linux.it>
Date:   Thu Dec 17 00:08:36 2009 +0900

    sony-laptop: enumerate rfkill devices using SN06
    
    SN06 makes sure we get back a longer buffer which seems to be necessary
    going forward as the SNC devices describes more and more devices (or
    features more precisely). Moreover SN06 should be called with only the
    descriptor offset to make sure we hit the rfkill controlling function
    (F124 or F135) with a 0 argument to get a full list of features.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Tested-by: Miguel Rodríguez Pérez <miguelrp@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d5a664a311c1957a75bec1808cae0f10d606c378
Author: Mattia Dongili <malattia@linux.it>
Date:   Thu Dec 17 00:08:35 2009 +0900

    sony-laptop: rfkill support for newer models
    
    Vaio Type X and possibly other new models use F135 as the radio
    frequency controlling function attached to the SNC device. In the
    indexed table this corresponds to 0x0135 (surpise!).
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9dc130fccb874f2959ef313d7922d306dc6d4f75
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Wed Dec 23 17:04:11 2009 +0800

    ACPI: fix OSC regression that caused aer and pciehp not to load
    
    Executing _OSC returns a buffer, which has an acpi object in it.
    Don't directly returns the buffer, instead, we return the acpi object's
    buffer. This fixes a regression since caller of acpi_run_osc expects
    an acpi object's buffer returned.
    
    Tested-by: Yinghai Lu <yinghai@kernel.org>
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0f1006b1f2b7862e35973c53cc4f99bea65d5a1d
Author: Anisse Astier <anisse@astier.eu>
Date:   Thu Dec 17 11:28:49 2009 +0100

    MAINTAINERS: add maintainer for msi-wmi driver
    
    Signed-off-by: Anisse Astier <anisse@astier.eu>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3b1c37cab3765b87efbd4ed40301ceaf72b9f5c2
Author: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Date:   Wed Dec 23 09:19:42 2009 +1030

    fujitu-laptop: fix tests of acpi_evaluate_integer() return value
    
    Fix tests on return value from acpi_evaluate_integer().  Based on a patch by
    Roel Kluin <roel.kluin@gmail.com> and incorporating suggestions from Len
    Brown <lenb@kernel.org>.
    
    Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
    Signed-off-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4a28395d72a956f2dad24e343d06bc08c9afb89a
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Mon Dec 21 16:19:58 2009 -0800

    arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c: avoid cross-CPU interrupts by using smp_call_function_any()
    
    Presently acpi-cpufreq will perform the MSR read on the first CPU in the
    mask.  That's inefficient if that CPU differs from the current CPU.
    Because we have to perform a cross-CPU call, but we could have run the
    rdmsr on the current CPU.
    
    So switch to using the new smp_call_function_any(), which will perform the
    call on the current CPU if that CPU is present in the mask (it is).
    
    Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
    Cc: Dave Jones <davej@redhat.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>
    Cc: Len Brown <len.brown@intel.com>
    Cc: Mike Galbraith <efault@gmx.de>
    Cc: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Cc: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e59897fe443b5b0a71e135ef4020d1937c9f8901
Author: Alex Chiang <achiang@hp.com>
Date:   Sun Dec 20 12:23:21 2009 -0700

    ACPI: processor: remove _PDC object list from struct acpi_processor
    
    When we call _PDC, we get a handle to the processor, allocate the
    object list buffer as needed, and free it immediately after calling
    _PDC.
    
    There's no need to drag around this object list with us everywhere
    else, so let's just get rid of it.
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 43bab25ced218385f7e6a076c2459ea008cfd2e1
Author: Alex Chiang <achiang@hp.com>
Date:   Sun Dec 20 12:23:16 2009 -0700

    ACPI: processor: change acpi_processor_set_pdc() interface
    
    When calling _PDC, we really only need the handle to the processor
    to call the method; we don't look at any other parts of the
    struct acpi_processor * given to us.
    
    In the early path, when we walk the namespace, we are given the
    handle directly, so just pass it through to acpi_processor_set_pdc()
    without stuffing it into a wasteful struct acpi_processor allocated
    on the stack each time
    
    This saves 2834 bytes of stack.
    
    Update the interface accordingly.
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b9c2db783456bcbce31e2482214cd337528db295
Author: Alex Chiang <achiang@hp.com>
Date:   Sun Dec 20 12:23:11 2009 -0700

    ACPI: processor: open code acpi_processor_cleanup_pdc
    
    We have the acpi_object_list * right there in acpi_processor_set_pdc()
    so it doesn't seem necessary for an entire helper function just to
    free it.
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fa118564ed66f785f957d8230745b62e9244700d
Author: Alex Chiang <achiang@hp.com>
Date:   Sun Dec 20 12:19:45 2009 -0700

    ACPI: processor: change acpi_processor_eval_pdc interface
    
    acpi_processor_eval_pdc() really only needs a handle and an
    acpi_object_list * to do its work.
    
    No need to pass in a struct acpi_processor *, so let's be more specific
    about what we want.
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3b407aef573b82139c3bc4dcaad2731fad56c054
Author: Alex Chiang <achiang@hp.com>
Date:   Sun Dec 20 12:19:39 2009 -0700

    ACPI: processor: introduce acpi_processor_alloc_pdc()
    
    acpi_processor_init_pdc() isn't really doing anything interesting
    with the struct acpi_processor * parameter. Its real job is to allocate
    the buffer for the _PDC bits.
    
    So rename the function to acpi_processor_alloc_pdc(), and just return
    the struct acpi_object_list * it's supposed to allocate.
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 47817254b8637b56730aec26eed2c337d3938bb5
Author: Alex Chiang <achiang@hp.com>
Date:   Sun Dec 20 12:19:34 2009 -0700

    ACPI: processor: unify arch_acpi_processor_cleanup_pdc
    
    The x86 and ia64 implementations of the function in $subject are
    exactly the same.
    
    Also, since the arch-specific implementations of setting _PDC have
    been completely hollowed out, remove the empty shells.
    
    Cc: Tony Luck <tony.luck@intel.com>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: "H. Peter Anvin" <hpa@zytor.com>
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6c5807d7bc7d051fce00863ffb98d36325501eb2
Author: Alex Chiang <achiang@hp.com>
Date:   Sun Dec 20 12:19:29 2009 -0700

    ACPI: processor: finish unifying arch_acpi_processor_init_pdc()
    
    The only thing arch-specific about calling _PDC is what bits get
    set in the input obj_list buffer.
    
    There's no need for several levels of indirection to twiddle those
    bits. Additionally, since we're just messing around with a buffer,
    we can simplify the interface; no need to pass around the entire
    struct acpi_processor * just to get at the buffer.
    
    Cc: Tony Luck <tony.luck@intel.com>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: "H. Peter Anvin" <hpa@zytor.com>
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 08ea48a326d8030ef5b7fb02292faf5a53c95e0a
Author: Alex Chiang <achiang@hp.com>
Date:   Sun Dec 20 12:19:24 2009 -0700

    ACPI: processor: factor out common _PDC settings
    
    Both x86 and ia64 initialize _PDC with mostly common bit settings.
    
    Factor out the common settings and leave the arch-specific ones alone.
    
    Cc: Tony Luck <tony.luck@intel.com>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: "H. Peter Anvin" <hpa@zytor.com>
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 407cd87c54e76c266245e8faef8dd4a84b7254fe
Author: Alex Chiang <achiang@hp.com>
Date:   Sun Dec 20 12:19:19 2009 -0700

    ACPI: processor: unify arch_acpi_processor_init_pdc
    
    The x86 and ia64 implementations of arch_acpi_processor_init_pdc()
    are almost exactly the same. The only difference is in what bits
    they set in obj_list buffer.
    
    Combine the boilerplate memory management code, and leave the
    arch-specific bit twiddling in separate implementations.
    
    Cc: Tony Luck <tony.luck@intel.com>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: "H. Peter Anvin" <hpa@zytor.com>
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1d9cb470a755409ce97c3376174b1e234bd20371
Author: Alex Chiang <achiang@hp.com>
Date:   Sun Dec 20 12:19:14 2009 -0700

    ACPI: processor: introduce arch_has_acpi_pdc
    
    arch dependent helper function that tells us if we should attempt to
    evaluate _PDC on this machine or not.
    
    The x86 implementation assumes that the CPUs in the machine must be
    homogeneous, and that you cannot mix CPUs of different vendors.
    
    Cc: Tony Luck <tony.luck@intel.com>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: "H. Peter Anvin" <hpa@zytor.com>
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 78f1699659963fff97975df44db6d5dbe7218e55
Author: Alex Chiang <achiang@hp.com>
Date:   Sun Dec 20 12:19:09 2009 -0700

    ACPI: processor: call _PDC early
    
    We discovered that at least one machine (HP Envy), methods in the DSDT
    attempt to call external methods defined in a dynamically loaded SSDT.
    
    Unfortunately, the DSDT methods we are trying to call are part of the
    EC initialization, which happens very early, and the the dynamic SSDT
    is only loaded when a processor _PDC method runs much later.
    
    This results in namespace lookup errors for the (as of yet) undefined
    methods.
    
    Since Windows doesn't have any issues with this machine, we take it
    as a hint that they must be evaluating _PDC much earlier than we are.
    
    Thus, the proper thing for Linux to do should be to match the Windows
    implementation more closely.
    
    Provide a mechanism to call _PDC before we enable the EC. Doing so loads
    the dynamic tables, and allows the EC to be enabled correctly.
    
    The ACPI processor driver will still evaluate _PDC in its .add() method
    to cover the hotplug case.
    
    Resolves: http://bugzilla.kernel.org/show_bug.cgi?id=14824
    
    Cc: ming.m.lin@intel.com
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 55b313f249e11b815fd0be51869f166aaf368f44
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Tue Dec 22 02:42:52 2009 -0500

    ACPI: EC: Fix MSI DMI detection
    
    MSI strings should be ORed, not ANDed.
    
    Reference: http://bugzilla.kernel.org/show_bug.cgi?id=14446
    
    cc: stable@kernel.org
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 81074e90f5c150ca70ab8dfcc77860cbe76f364d
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Mon Dec 21 16:13:15 2009 +0800

    ACPI: disable _OSI(Windows 2009) on Asus K50IJ
    
    Fix a win7 compability issue on Asus K50IJ.
    
    Here is the _BCM method of this laptop:
                        Method (_BCM, 1, NotSerialized)
                        {
                            If (LGreaterEqual (OSFG, OSVT))
                            {
                                If (LNotEqual (OSFG, OSW7))
                                {
                                    Store (One, BCMD)
                                    Store (GCBL (Arg0), Local0)
                                    Subtract (0x0F, Local0, LBTN)
                                    ^^^SBRG.EC0.STBR ()
                                    ...
                                }
                                Else
                                {
                                    DBGR (0x0B, Zero, Zero, Arg0)
                                    Store (Arg0, LBTN)
                                    ^^^SBRG.EC0.STBR ()
                                    ...
                                }
                            }
                        }
    LBTN is used to store the index of the brightness level in the _BCL.
    GCBL is a method that convert the percentage value to the index value.
    If _OSI(Windows 2009) is not disabled, LBTN is stored a percentage
    value which is surely beyond the end of _BCL package.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=14753
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4f924ba5b5aaf1477daafeae779495d39549186d
Author: Mattia Dongili <malattia@linux.it>
Date:   Thu Dec 17 00:08:33 2009 +0900

    sony-laptop: add AVMode key mapping
    
    Some models are equipped with an "AVMode" function key that sends
      sony-laptop: Unknown event: 0x100 0xa1
      sony-laptop: Unknown event: 0x100 0x21
    for press and release respectively.
    
    Cc: "Matthew W. S. Bell" <matthew@bells23.org.uk>
    Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8e698a3c47887fe5aa5e2252c27bb6ff416a07e4
Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Fri Dec 4 00:36:20 2009 -0800

    tc1100-wmi - switch to using dev_pm_ops
    
    Also guard PM operations with CONFIG_PM.
    
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9634a627b330fcc7cdca25df4d7853ca9c7745de
Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Fri Dec 4 00:36:15 2009 -0800

    tc1100-wmi - add error handling for device registration
    
    Any of the platform API functions can fail; driver should be prepared
    to handle such failures. Also:
    
     - changed to platform_driver_probe() since the device is created
       right there with the driver;
     - added __devexit annotation to remove method;
     - fixed memory leak on module unload - named platform_device_del() is not
       enough to free platform device, need platform_device_unregister().
    
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0ad3dc3af8ba028368263b190a7a270f8d5cf5ae
Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Fri Dec 4 00:36:09 2009 -0800

    tc1100-wmi - switch to using attribute group
    
    Sysfs attribute group takes care of proper creation of a set of attributes
    and implements proper error unwinding so the driver does not have to do it.
    
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
    Signed-off-by: Len Brown <len.brown@intel.com>

--Boundary_(ID_Yu316arE3/obdVCtvK2XfA)--
