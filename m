Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbXJ3DBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbXJ3DBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 23:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbXJ3DA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 23:00:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:43669 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbXJ3DAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 23:00:54 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PATCH] ACPI paches for 2.6.24-rc1
Date: Mon, 29 Oct 2007 23:00:36 -0400
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710292300.36854.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.24/acpi-release-20070126-2.6.24-rc1.diff.gz

 Documentation/kernel-parameters.txt |    5 
 MAINTAINERS                         |   18 +-
 drivers/acpi/Kconfig                |   10 -
 drivers/acpi/battery.c              |  164 +++++++++++++-----------
 drivers/acpi/bus.c                  |    8 -
 drivers/acpi/button.c               |   37 ++++-
 drivers/acpi/ec.c                   |  146 ++++++++++-----------
 drivers/acpi/fan.c                  |   72 +---------
 drivers/acpi/power.c                |   63 +++------
 drivers/acpi/sleep/main.c           |    5 
 drivers/cpuidle/cpuidle.c           |    1 
 drivers/cpuidle/governor.c          |    3 
 drivers/misc/fujitsu-laptop.c       |    7 -
 include/acpi/acpi_bus.h             |    3 
 14 files changed, 250 insertions(+), 292 deletions(-)

through these commits:

Adrian Bunk (6):
      ACPI: battery: remove dead code
      ACPI: EC: fix use-after-free
      fujitsu-laptop: make 2 functions static
      cpuidle: unexport tick_nohz_get_sleep_length
      fujitsu-laptop.c: remove dead code
      cpuidle: remove unused exports

Alexey Starikovskiy (16):
      ACPI: sleep: Fix GPE suspend cleanup
      ACPI: suspend: Wrong order of GPE restore.
      ACPI: button: send initial lid state after add and resume
      ACPI: EC: Replace atomic variables with bits
      ACPI: EC: Don't expect interrupt after last read
      ACPI: EC: auto select interrupt mode
      ACPI: EC: Don't re-enable GPE for each transaction.
      ACPI: EC: Add workaround for "optimized" controllers
      ACPI: EC: Output changes to operational mode
      ACPI: power: don't cache power resource state
      ACPI: Fan: fan device does not need own structure
      ACPI: Fan: Drop force_power_state acpi_device option
      ACPI: battery: Update battery information upon sysfs read.
      ACPI: battery: Support for non-spec name for LiIon technology
      ACPI: Battery: Allow extract string from integer
      ACPI: use select POWER_SUPPLY for AC, BATTERY and SBS

Andrey Borzenkov (1):
      ACPI: battery: register power_supply subdevice only when battery is present

Frans Pop (1):
      acpi: remove double mention of Support for ACPI option

Len Brown (2):
      ACPI: update MAINTAINERS
      suspend: MAINTAINERS update

with this log:

commit 1942971b20817def5fd1142248307c7c3c51fc8a
Merge: 37e58df... 355ee5e...
Author: Len Brown <len.brown@intel.com>
Date:   Mon Oct 29 17:31:01 2007 -0400

    Pull documentation into release branch

commit 37e58df30063e229ee5157f9d1c1fa1d749917c2
Merge: b2451e4... 83788c0...
Author: Len Brown <len.brown@intel.com>
Date:   Mon Oct 29 17:30:55 2007 -0400

    Pull cpuidle into release branch

commit b2451e4399d7233cd0008823872f51112d18f8d0
Merge: 14f7d72... b023b43...
Author: Len Brown <len.brown@intel.com>
Date:   Mon Oct 29 17:30:48 2007 -0400

    Pull fujitsu into release branch

commit 14f7d720bb6cc60be8931ea1a0f547dc1e475b88
Merge: 6a22c57... 5527c8b...
Author: Len Brown <len.brown@intel.com>
Date:   Mon Oct 29 17:30:21 2007 -0400

    Pull alexey-fixes into release branch

commit 83788c0caed3a425f64fa88fde7c78746b9cdd76
Author: Adrian Bunk <bunk@kernel.org>
Date:   Mon Oct 29 13:49:13 2007 +0100

    cpuidle: remove unused exports
    
    This patch removes the following unused exports:
    - cpuidle_devices
    - cpuidle_register_governor
    - cpuidle_unregister_governor
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 355ee5eb60e7ce5b5379788c56d36ab162771f7d
Author: Frans Pop <elendil@planet.nl>
Date:   Mon Oct 29 17:20:38 2007 -0400

    acpi: remove double mention of Support for ACPI option
    
    Current description for CONFIG_ACPI includes the word "Support" twice.  One
    effect of this is that in menuconfig the "--->" that indicates the presence
    of sub-options will not show up unless you have a very wide console.
    
    Signed-off-by: Frans Pop <elendil@planet.nl>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5527c8bee27fa063dcec0e020fb8c242ba4270c2
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Mon Oct 29 17:08:59 2007 -0400

    ACPI: use select POWER_SUPPLY for AC, BATTERY and SBS
    
    POWER_SUPPLY is needed for AC, battery, and SBS sysfs support.  Use
    'select' instead of 'depends on', as it is will not be selected by anything
    else, leading to confusion.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Tested-by: Frans Pop <elendil@planet.nl>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 106449e870b3069c049a3486ae7b47995351270c
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Mon Oct 29 23:29:40 2007 +0300

    ACPI: Battery: Allow extract string from integer
    
    Some machines return integer instead of expected string.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Tested-by: Andrey Borzenkov <arvidjaar@mail.ru>
    Tested-by: Frans Pop <elendil@planet.nl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0bde7eee9489cc7cce08cf6eba05b4f42a6b2334
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Sun Oct 28 15:33:10 2007 +0300

    ACPI: battery: Support for non-spec name for LiIon technology
    
    Support Li-Ion as possible name for technology.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 508df92d1f8d1921013cb4f45bb547d0eaff912a
Author: Andrey Borzenkov <arvidjaar@mail.ru>
Date:   Sun Oct 28 12:50:09 2007 +0300

    ACPI: battery: register power_supply subdevice only when battery is present
    
    Make sure no power_supply object is present unless we actualy detect
    presence of battery. This fixes ghost batteries detected by HAL
    
    Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a0ce317ae7d8ea99aea2c3f1a8ef0a99bab99a30
Author: Len Brown <len.brown@intel.com>
Date:   Thu Oct 25 18:05:49 2007 -0400

    suspend: MAINTAINERS update
    
    > I guess it is time to clarify that suspend and hibernation are separate
    > things, and add Rafael as a maintainer.  Plus, people blame us for suspend
    > problems, anyway, I guess it is fair to mark us as suspend maintainers, too.
    
    If blame is the qualification, I guess I'm already part of this merry band:-)
    
    Change to Supported from Maintained, as the folks that sign my paycheck
    agree it is a good idea for me to help out on suspend.
    
    Acked-by: Pavel Machek <pavel@suse.cz>
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 38e09d83e99b6c7ceb03c42046e0c2ec4850c94d
Author: Len Brown <len.brown@intel.com>
Date:   Thu Oct 25 17:55:59 2007 -0400

    ACPI: update MAINTAINERS
    
    Newly minted project home page -- http://www.lesswatts.org/projects/acpi/
    Konstantin moved on, so default back to Len for Thermal/Fan.
    Rui replaces Luming on video.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b023b43a83d231d1f3d36ac9e3ce4831b5ec2e7b
Author: Adrian Bunk <bunk@kernel.org>
Date:   Wed Oct 24 18:25:49 2007 +0200

    fujitsu-laptop.c: remove dead code
    
    This patch removes dead code spotted by the Coverity checker.
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4d8b4e1e02b4bb200e81b2efc915da6ce59d5d72
Author: Adrian Bunk <bunk@kernel.org>
Date:   Wed Oct 24 18:24:22 2007 +0200

    cpuidle: unexport tick_nohz_get_sleep_length
    
    This patch removes the unused
    EXPORT_SYMBOL_GPL(tick_nohz_get_sleep_length),
    which we no long user b/c we no longer build optional modules.
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Acked-by: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b19073a0be5e317d626b3b404e0039b59383891c
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Thu Oct 25 17:10:47 2007 -0400

    ACPI: battery: Update battery information upon sysfs read.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b6f03ae6defb61bb4b8e7a8e4b9081a1dd1d3ef9
Author: Adrian Bunk <bunk@kernel.org>
Date:   Wed Oct 24 18:23:16 2007 +0200

    fujitsu-laptop: make 2 functions static
    
    acpi_fujitsu_{add,remove}() can become static.
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1544fdbc857cbe8afca16a521d3254346befeb06
Author: Adrian Bunk <bunk@kernel.org>
Date:   Wed Oct 24 18:26:00 2007 +0200

    ACPI: EC: fix use-after-free
    
    This patch fixes a use-after-free introduced by
    commit 30c08574da0ead1a47797ce028218ce5b2de61c7
    (ACPI: EC: Add new query handler to list head)
    
    Spotted by the Coverity checker.
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c9e4172cde0f793dbf48c99bdfd0abe7d18e4b09
Author: Adrian Bunk <bunk@kernel.org>
Date:   Wed Oct 24 18:25:37 2007 +0200

    ACPI: battery: remove dead code
    
    After commit f1d4661abe05d0a2c014166042d15ed8b69ae8f2 this was dead
    code.
    
    Spotted by the Coverity checker.
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 93ad7c07ad487b036add8760dabcc35666a550ef
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Mon Oct 22 14:19:21 2007 +0400

    ACPI: Fan: Drop force_power_state acpi_device option
    
    force_power_state was used as a workaround for invalid cached
    power state of the device. We do not cache power state, so no need for
    workaround.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 968fc5dc2699434ea1cbddaf189f19c4eb4dbe55
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Mon Oct 22 14:19:15 2007 +0400

    ACPI: Fan: fan device does not need own structure
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c35923bc558074d4f5e6f9706e4cb9811ae55775
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Mon Oct 22 14:19:09 2007 +0400

    ACPI: power: don't cache power resource state
    
    ACPI may change power resource state behind our back, so don't
    keep our local copy, which may not be valid.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 95b937e3f52a7f5546c4bffe29886fe400bad1d1
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Mon Oct 22 14:19:03 2007 +0400

    ACPI: EC: Output changes to operational mode
    
    Insert printk() for every change in operational mode.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 66c5f4e7367b0085652931b2f3366de29e7ff5ec
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Mon Oct 22 14:18:56 2007 +0400

    ACPI: EC: Add workaround for "optimized" controllers
    
    Some controllers do not send interrupts for OBF=1 event, but send
    them for IBF=0. Add workaround for them.
    
    Reference: http://bugzilla.kernel.org/show_bug.cgi?id=8459
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1c55053c21706ccf1fdb26b4bb6d05c4a2782ffe
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Mon Oct 22 14:18:50 2007 +0400

    ACPI: EC: Don't re-enable GPE for each transaction.
    
    With the auto selection of operation mode, absence of GPEs does not
    really degrade performance, so let PM code to handle
    enabling/disabling GPEs.
    This is a revert of 5d57a6a55ec0bdcb952dbcd3f8ffcde8a3ee9413,
    which was meant to be temporary.
    
    Reference: http://bugzilla.kernel.org/show_bug.cgi?id=7977
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7843932ac42899b936085beaea8620d4489b8b3f
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Mon Oct 22 14:18:43 2007 +0400

    ACPI: EC: auto select interrupt mode
    
    Start in POLL mode, and if we receive confirmation GPE,
    switch to INT mode.
    If confirmations are not sent, switch back to POLL.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0c5d31f48e54b2e56e9cef8d49ffedaef1e0ea52
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Mon Oct 22 14:18:36 2007 +0400

    ACPI: EC: Don't expect interrupt after last read
    
    There is no interrupt after last read according to spec, so
    don't set bit that we are expecting one.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 080e412cc0bdb9ef8e7a983d5e008537e1c4d36c
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Mon Oct 22 14:18:30 2007 +0400

    ACPI: EC: Replace atomic variables with bits
    
    Number of flags is about to be increased, so it is better to
    put them all into bits.
    No functional changes.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 23de5d9ef2a4bbc4f733f58311bcb7cf6239c813
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Mon Oct 22 14:18:18 2007 +0400

    ACPI: button: send initial lid state after add and resume
    
    Input layer should know about initial state of lid switch,
    even before first notify.
    
    Reference: https://bugzilla.novell.com/show_bug.cgi?id=326814
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1dbc1fda5d8ca907f320b806005d4a447977d26a
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Mon Oct 22 14:18:12 2007 +0400

    ACPI: suspend: Wrong order of GPE restore.
    
    acpi_leave_sleep_state() should have correct list of wake and
    runtime GPEs, which is available only after disable_wakeup_device()
    is called.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9c1c6a1ba786d58bd03e27ee49f89a5685e8e07b
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Mon Oct 22 14:18:06 2007 +0400

    ACPI: sleep: Fix GPE suspend cleanup
    
    Commit 9b039330808b83acac3597535da26f47ad1862ce removed
    acpi_gpe_sleep_prepare(), the only function used at S5 transition
    Add call to generic acpi_enable_wake_device().
    
    Reference: https://bugzilla.novell.com/show_bug.cgi?id=299882
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>
