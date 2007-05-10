Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbXEJINJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbXEJINJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 04:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756932AbXEJIM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 04:12:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:50041 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755738AbXEJIMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 04:12:52 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCH] ACPI patches for 2.6.22 - part 2
Date: Thu, 10 May 2007 04:11:32 -0400
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705100411.32349.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

Please test this on your Evo before pushing it upstream.

Due to a crash on some ACER laptops, this reverts
the Notify-on-stack fix from 2.6.21 and goes
back to an updated notify work-queue fix that we've
discussed (and struggled with) before.

I'm not totally satisfied that we've reverse engineered
all the bizarre Notify cases that BIOS send us, but this
should work on the machines we've seen to date...

The bulk of the text changes are to restore the invariant
that ACPICA is Lindent clean.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.21/acpi-release-20070126-2.6.21.diff.gz

 drivers/acpi/dispatcher/dsmethod.c |   12 
 drivers/acpi/dispatcher/dsopcode.c |    3 
 drivers/acpi/dispatcher/dsutils.c  |    7 
 drivers/acpi/dispatcher/dswstate.c |    9 
 drivers/acpi/ec.c                  |   39 -
 drivers/acpi/events/evgpe.c        |    5 
 drivers/acpi/events/evgpeblk.c     |    3 
 drivers/acpi/events/evmisc.c       |   20 
 drivers/acpi/events/evregion.c     |   15 
 drivers/acpi/events/evrgnini.c     |    3 
 drivers/acpi/events/evxface.c      |    7 
 drivers/acpi/events/evxfevnt.c     |    2 
 drivers/acpi/executer/exconvrt.c   |    5 
 drivers/acpi/executer/excreate.c   |    6 
 drivers/acpi/executer/exdump.c     |   17 
 drivers/acpi/executer/exmutex.c    |   37 -
 drivers/acpi/executer/exnames.c    |    3 
 drivers/acpi/executer/exprep.c     |    2 
 drivers/acpi/executer/exresop.c    |    3 
 drivers/acpi/executer/exsystem.c   |   30 -
 drivers/acpi/executer/exutils.c    |  104 +++-
 drivers/acpi/hardware/hwsleep.c    |    1 
 drivers/acpi/namespace/nseval.c    |   13 
 drivers/acpi/namespace/nsinit.c    |    7 
 drivers/acpi/namespace/nswalk.c    |    6 
 drivers/acpi/namespace/nsxfeval.c  |   17 
 drivers/acpi/osl.c                 |   45 +
 drivers/acpi/parser/psopcode.c     |  618 ++++++++++++-------------
 drivers/acpi/resources/rscalc.c    |    3 
 drivers/acpi/resources/rscreate.c  |   13 
 drivers/acpi/resources/rsdump.c    |    8 
 drivers/acpi/resources/rsinfo.c    |    2 
 drivers/acpi/resources/rslist.c    |    7 
 drivers/acpi/resources/rsmisc.c    |    4 
 drivers/acpi/resources/rsutils.c   |    6 
 drivers/acpi/resources/rsxface.c   |    3 
 drivers/acpi/sleep/main.c          |    3 
 drivers/acpi/sleep/proc.c          |   11 
 drivers/acpi/tables/tbfadt.c       |    6 
 drivers/acpi/tables/tbxface.c      |   16 
 drivers/acpi/thermal.c             |  104 ----
 drivers/acpi/utilities/utalloc.c   |    1 
 drivers/acpi/utilities/utcache.c   |    3 
 drivers/acpi/utilities/utcopy.c    |    4 
 drivers/acpi/utilities/utdebug.c   |    4 
 drivers/acpi/utilities/utdelete.c  |    1 
 drivers/acpi/utilities/utglobal.c  |    6 
 drivers/acpi/utilities/utmisc.c    |    6 
 drivers/acpi/utilities/utmutex.c   |    8 
 drivers/acpi/utilities/utresrc.c   |    1 
 drivers/acpi/utilities/utxface.c   |    2 
 drivers/misc/Kconfig               |    2 
 drivers/misc/asus-laptop.c         |   66 ++
 drivers/misc/msi-laptop.c          |   12 
 drivers/misc/sony-laptop.c         |    8 
 include/acpi/acdispat.h            |    9 
 include/acpi/acglobal.h            |    2 
 include/acpi/acinterp.h            |    9 
 include/acpi/aclocal.h             |    2 
 include/acpi/acnamesp.h            |    6 
 include/acpi/acobject.h            |    4 
 include/acpi/acpi_bus.h            |    9 
 include/acpi/acpi_drivers.h        |    6 
 include/acpi/acpi_numa.h           |    2 
 include/acpi/acpiosxf.h            |    3 
 include/acpi/actypes.h             |    2 
 include/acpi/acutils.h             |    3 
 include/acpi/platform/aclinux.h    |   21 
 include/acpi/processor.h           |   18 
 include/linux/acpi.h               |    3 
 70 files changed, 721 insertions(+), 727 deletions(-)

through these commits:

Alexey Starikovskiy (1):
      ACPI: created a dedicated workqueue for notify() execution

Corentin Chary (4):
      asus-laptop: notify ALL events
      asus-laptop: add GPS support
      asus-laptop: fix light sens init
      asus-laptop: version bump and lindent

Len Brown (6):
      ACPI: thermal trip points are read-only
      ACPI: delete un-reliable concept of cooling mode
      Revert "ACPICA: revert "acpi_serialize" changes"
      Revert "Execute AML Notify() requests on stack."
      Revert "ACPICA: fix AML mutex re-entrancy"
      ACPICA: Lindent

Lennart Poettering (1):
      acpi,msi-laptop: Fall back to EC polling mode for MSI laptop specific EC commands

Mattia Dongili (1):
      sony-laptop: rename SONY_LAPTOP_OLD to a more meaningful SONYPI_COMPAT

with this log:

commit f685648e7d6520653fa2641840cccc58ba8ef8e0
Merge: f142051... 00eb43a...
Author: Len Brown <len.brown@intel.com>
Date:   Thu May 10 04:06:12 2007 -0400

    Pull misc-for-upstream into release branch

commit 00eb43a1897a8845d0edb198cec69ac5f1f299dd
Author: Lennart Poettering <mzxreary@0pointer.de>
Date:   Fri May 4 14:16:19 2007 +0200

    acpi,msi-laptop: Fall back to EC polling mode for MSI laptop specific EC commands
    
    The ACPI EC that is used in MSI laptops knows some non-standard
    commands for changing the screen brighntess and a few other things,
    which are used by the msi-laptop.c driver. Unfortunately for these
    commands no GPE events for IBF and OBF are triggered. Since nowadays
    the EC code uses the ec_intr=1 mode by default, this causes these
    operations to timeout, although they don't fail. In result, all
    operations that you can do with the msi-laptop.c driver take more or
    less 1s to complete, which is awfully slow.
    
    In one of the more recent kernels (2.6.20?) the EC subsystem has been
    revamped. With that change the EC timeout has been increased. before
    that increase the MSI EC accesses were slow -- but not *that* slow,
    hence I took notice of this limitation of the MSI EC hardware only very
    recently.
    
    The standard EC operations on the MSI EC as defined in the ACPI spec
    support GPE events properly.
    
    The following patch adds a new argument "force_poll" to the
    ec_transaction() function (and friends). If set to 1, the function
    will poll for IBF/OBF even if ec_intr=1 is enabled. If set to 0 the
    current behaviour is used. The msi-laptop driver is modified to make
    use of this new flag, so that OBF/IBF is polled for the special MSI EC
    transactions -- but only for them.
    
    Signed-off-by: Lennart Poettering <mzxreary@0pointer.de>
    Acked-by: Alexey Starikovskiy <aystarik@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f142051505154da4ba689e129deb06524c5ece8a
Merge: 19ed0d6... a64e62a...
Author: Len Brown <len.brown@intel.com>
Date:   Thu May 10 02:50:09 2007 -0400

    Pull misc-for-upstream into release branch

commit 19ed0d6fa894aec0050ab75185e69785a656da91
Merge: 71b43ca... f398532...
Author: Len Brown <len.brown@intel.com>
Date:   Thu May 10 02:50:01 2007 -0400

    Pull asus into release branch

commit 71b43ca46fc5f0588ef64a14c6133c19a9b3f1ea
Merge: 3dd6786... fd35094...
Author: Len Brown <len.brown@intel.com>
Date:   Thu May 10 02:49:34 2007 -0400

    Pull acpica into release branch

commit 3dd6786f55219f87fd33e153669600d715ca9270
Merge: f697b67... 88db5e1...
Author: Len Brown <len.brown@intel.com>
Date:   Thu May 10 02:49:21 2007 -0400

    Pull bugzilla-8385 into release branch

commit f697b677620d04d8c77841745727de85f7e948b1
Merge: de56037... eaca2d3...
Author: Len Brown <len.brown@intel.com>
Date:   Thu May 10 02:49:01 2007 -0400

    Pull thermal into release branch

commit a64e62a07097f67108f0b68bc15216c3a4a5299b
Author: Mattia Dongili <malattia@linux.it>
Date:   Tue May 1 11:19:53 2007 +0900

    sony-laptop: rename SONY_LAPTOP_OLD to a more meaningful SONYPI_COMPAT
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f398532722b44aa797915d6b784e8694b277c2c7
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Sun May 6 14:48:22 2007 +0200

    asus-laptop: version bump and lindent
    
    Version bump, lindent, etc ..
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 832d995029466e12aef66187bc9103487bf7be9f
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Sun May 6 14:47:29 2007 +0200

    asus-laptop: fix light sens init
    
    Fix a stupid light sens detection bug.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e539c2f69ca17f71dd41ba89cde67612a1326c57
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Sun May 6 14:47:06 2007 +0200

    asus-laptop: add GPS support
    
    Just adds GPS support found in R2H thanks to Sam Lin.  It will
    make a "gps" file in /sys/devices/platform/asus-laptop/.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a9dbcb37a45f45813fc64d672a1f7ae6135650b1
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Sun May 6 14:46:41 2007 +0200

    asus-laptop: notify ALL events
    
    We need to handle all events, because some dsdt use events >= 0x80
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fd3509436fde38d4c854bf5a6b83d2c779904f8e
Author: Len Brown <len.brown@intel.com>
Date:   Wed May 9 23:34:35 2007 -0400

    ACPICA: Lindent
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 88db5e1489f23876a226f5393fd978ddc09dc5f9
Author: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
Date:   Wed May 9 23:31:03 2007 -0400

    ACPI: created a dedicated workqueue for notify() execution
    
    HP nx6125/nx6325/... machines have a _GPE handler with an infinite
    loop sending Notify() events to different ACPI subsystems.
    
    Notify handler in ACPI driver is a C-routine, which may call ACPI
    interpreter again to get access to some ACPI variables
    (acpi_evaluate_xxx).
    On these HP machines such an evaluation changes state of some variable
    and lets the loop above break.
    
    In the current ACPI implementation Notify requests are being deferred
    to the same kacpid workqueue on which the above GPE handler with
    infinite loop is executing. Thus we have a deadlock -- loop will
    continue to spin, sending notify events, and at the same time
    preventing these notify events from being run on a workqueue. All
    notify events are deferred, thus we see increase in memory consumption
    noticed by author of the thread. Also as GPE handling is bloked,
    machines overheat. Eventually by external poll of the same
    acpi_evaluate, kacpid is released and all the queued notify events are
    free to run, thus 100% cpu utilization by kacpid for several seconds
    or more.
    
    To prevent all these horrors it's needed to not put notify events to
    kacpid workqueue by either executing them immediately or putting them
    on some other thread. It's dangerous to execute notify events in
    place, as it will put several ACPI interpreter stacks on top of each
    other (at least 4 in case of nx6125), thus causing kernel  stack
    overflow.
    
    First attempt to create a new thread was done by Peter Wainwright
    He created a bunch of threads, which were stealing work from a kacpid
    workqueue.
    This patch appeared in 2.6.15 kernel shipped with Ubuntu 6.06 LTS.
    
    Second attempt was done by me, I created a new thread for each Notify
    event. This worked OK on HP nx machines, but broke Linus' Compaq
    n620c, by producing threads with a speed what they stopped the machine
    completely. Thus this patch was reverted from 18-rc2 as I remember.
    I re-made the patch to create second workqueue just for notify events,
    thus hopping it will not break Linus' machine. Patch was tested on the
    same HP nx machines in #5534 and #7122, but I did not received reply
    from Linus on a test patch sent to him.
    Patch went to 19-rc and was rejected with much fanfare again.
    There was 4th patch, which inserted schedule_timeout(1) into deferred
    execution of kacpid, if we had any notify requests pending, but Linus
    decided that it was too complex (involved either changes to workqueue
    to see if it's empty or atomic inc/dec).
    Now you see last variant which adds yield() to every GPE execution.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=5534
    http://bugzilla.kernel.org/show_bug.cgi?id=8385
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 262a7a28de060f3a63cae20035876d6f22fd7670
Author: Len Brown <len.brown@intel.com>
Date:   Wed May 9 23:01:59 2007 -0400

    Revert "ACPICA: fix AML mutex re-entrancy"
    
    This reverts commit c0d127b56937c3e72c2b1819161d2f6718eee877.
    
    These changes to AML locking were made to allow
    Notify handlers to be called on the stack
    and not deadlock.  However, that scheme turns
    out to be flawed and was reverted by the previous commit,
    so this commit restores the locking to it previous design.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 40d07080e585396dc58bc64befa1de0695318b3b
Author: Len Brown <len.brown@intel.com>
Date:   Wed May 9 22:59:38 2007 -0400

    Revert "Execute AML Notify() requests on stack."
    
    This reverts commit 5f7748cf91558a5026ded5be93c5bf6c1ac34edf.
    
    While that change fixed the HP
    http://bugzilla.kernel.org/show_bug.cgi?id=5534
    
    it broke the ACER:
    http://bugzilla.kernel.org/show_bug.cgi?id=8385
    which as AML that caused Linux go recursive
    and stack fault.
    
    So this commit by itself will restore the ACER
    and again break the HP, which we'll fix another way.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4d2acd9ea539e0f59178b126f6750ccc41eefcdd
Author: Len Brown <len.brown@intel.com>
Date:   Wed May 9 22:56:38 2007 -0400

    Revert "ACPICA: revert "acpi_serialize" changes"
    
    This reverts commit a8f4af6dc6600980885c594f52eecd60edd62013.
    Thus restoring ACPICA's new acpi_serialize code.
    
    This commit by itself may cause a regression, but
    it is reverted in this order so that subsequent
    reverts reverts under this one can be made
    without conflict.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit eaca2d3f6c4de9d4274a4e2be54c9693e76b0303
Author: Len Brown <len.brown@intel.com>
Date:   Mon Apr 30 23:27:43 2007 -0400

    ACPI: delete un-reliable concept of cooling mode
    
    The scheme where the thermal driver displayed the
    cooling mode /proc/acpi/thermal_zone/*/cooling_mode
    was flawed in two ways.
    
    First, the success of _SCP doesn't actually mean
    that the BIOS moved any trip points.
    On many BIOS, _SCP is present, but does nothing.
    So displaying what _SCP executed actually
    was wrong more times than it was right.
    
    Second, examining the relative position of the
    trip points when the thermal_zone is added
    is insufficient -- as the BIOS reserves the right
    to change the trip points at run-time.
    
    The only reliable way for the user to determine if
    the thermal zone is in active, passive, or critical
    mode is to examine the relative position of the trip points.
    The user can do this without the kernel doing it
    for them by looking in /proc/acpi/thermal_zone/*/trip_points
    
    New contents for /proc/acpi/thermal_zone/*/cooling_mode:
    
    If _SCP available:
    "0 - Active; 1 - Passive\n"
    
    If _SCP unavailable:
    "<setting not supported>\n"
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 11ccc0f249cb01a129f54760b8ff087f242935d4
Author: Len Brown <len.brown@intel.com>
Date:   Mon Apr 30 22:36:01 2007 -0400

    ACPI: thermal trip points are read-only
    
    /proc/acpi/thermal_zone/*/trip_points displays
    what the kernel reads from the BIOS via ACPI.
    
    If you echo a string of ':' deliminted numbers to this file
    then it will change what it displays.
    
    But it shouldn't, since the kernel has no way to communicate
    these changes to ACPI thermal zones.  ACPI thermal zone
    trip points are read-only.
    
    The kernel does have the opportunity to ask the BIOS to change
    the trip points with _SCP - Set Cooling Policy.
    
    Request Active Cooling Mode:
    # echo 0 > /proc/acpi/thermal_zone/*/cooling_policy
    
    Request Passive Cooling Mode:
    # echo 1 > /proc/acpi/thermal_zone/*/cooling_policy
    
    However, in practice it is quite rare for the BIOS
    to support the optional _SCP, and it is even more rare
    for the BIOS to export an _SCP that actually changes
    the trip points.
    
    Signed-off-by: Len Brown <len.brown@intel.com>
