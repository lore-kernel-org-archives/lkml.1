Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbXLFWBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbXLFWBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 17:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbXLFWBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 17:01:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:57459 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbXLFWBn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 17:01:43 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: [GIT PATCH] suspend patches for 2.6.24-rc4
Date: Thu, 6 Dec 2007 17:01:22 -0500
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712061701.22736.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

These fix 2.6.24 regressions,
and will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.24/acpi-release-20070126-2.6.24-rc4.diff.gz

 arch/x86/kernel/acpi/wakeup_32.S |    4 ----
 drivers/char/apm-emulation.c     |   15 ++++++++-------
 drivers/hwmon/coretemp.c         |    5 ++---
 fs/jffs2/background.c            |    2 +-
 init/do_mounts_initrd.c          |   12 +++++++++---
 5 files changed, 20 insertions(+), 18 deletions(-)

through these commits:

Pavel Machek (1):
      ACPI: suspend: old debugging hacks sneaked back

Rafael J. Wysocki (4):
      Freezer: Fix s2disk resume from initrd
      Freezer: Fix APM emulation breakage
      HWMON: coretemp, suspend fix
      Freezer: Fix JFFS2 garbage collector freezing issue (rev. 2)

with this log:

commit 982286d1b8e438f595cdc9304cc4c185c7b90a39
Merge: 9213148... 8baabde...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Dec 6 16:52:00 2007 -0500

    Pull bugzilla-9345 into release branch

commit 921314811be704252ad2caa8dde507d4c421ddc4
Merge: f7a5274... cb43c54...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Dec 6 16:51:29 2007 -0500

    Pull apm-freeze-fix into release branch

commit f7a5274d7dde0022dedfb6bca5b4438bbf30e9ce
Merge: ceaeee6... 74d0f33...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Dec 6 16:26:52 2007 -0500

    Pull suspend-2.6.24 into release branch

commit 74d0f3338fbb3c69894968df1fedaf10c88cd0e4
Author: Pavel Machek <pavel@ucw.cz>
Date:   Thu Dec 6 09:50:40 2007 +0100

    ACPI: suspend: old debugging hacks sneaked back
    
    Old debugging hack sneaked back during x86 merge, this removes it.
    
    Signed-off-by: Pavel Machek <pavel@suse.cz>
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e136e769d471e7f3d24a8f6bf9c91dcb372bd0ab
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Dec 4 01:11:09 2007 +0100

    Freezer: Fix JFFS2 garbage collector freezing issue (rev. 2)
    
    Fix breakage caused by commit d5d8c5976d6adeddb8208c240460411e2198b393
    "freezer: do not send signals to kernel threads" in
    jffs2_garbage_collect_thread() that assumed it would be sent signals
    by the freezer.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Cc: David Woodhouse <dwmw2@infradead.org>
    Cc: Pete MacKay <armlinux@architechnical.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 561d9a969455cb009bb15b63e1d925dc527e7a9d
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Mon Dec 3 18:01:50 2007 +0100

    HWMON: coretemp, suspend fix
    
    It's not permitted to unregister a device after devices have been suspended.
    It causes deadlocks to appear on systems with coretemp hwmon loaded.  To avoid
    this, we can make coretemp_cpu_callback() do nothing if the _FROZEN bit is set
    in action.
     
    Also, in other cases it's generally too late to unregister the coretemp device
    if the CPU is already dead, so it should be unregistered on CPU_DOWN_PREPARE.
     
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Mark M. Hoffman <mhoffman@lightlink.com>
    Cc: Jiri Slaby <jirislaby@gmail.com>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cb43c54ca05c01533c45e4d3abfe8f99b7acf624
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Wed Nov 21 02:53:14 2007 +0100

    Freezer: Fix APM emulation breakage
    
    The APM emulation is currently broken as a result of commit
    831441862956fffa17b9801db37e6ea1650b0f69
    "Freezer: make kernel threads nonfreezable by default"
    that removed the PF_NOFREEZE annotations from apm_ioctl() without adding
    the appropriate freezer hooks.  Fix it and remove the unnecessary variable flags
    from apm_ioctl().
    
    Special thanks to Franck Bui-Huu <vagabon.xyz@gmail.com> for pointing out the
    problem.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Cc: Pavel Machek <pavel@ucw.cz>
    Cc: Franck Bui-Huu <vagabon.xyz@gmail.com>
    Cc: Nigel Cunningham <nigel@nigel.suspend2.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8baabde66c60a84781c718c28fe283ed411a7bd0
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Wed Nov 21 02:50:17 2007 +0100

    Freezer: Fix s2disk resume from initrd
    
    Add appropriate freezer annotations to handle_initrd(), so that it's possible
    to resume from disk from an initrd.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9345
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Cc: Pavel Machek <pavel@ucw.cz>
    Cc: Nigel Cunningham <nigel@nigel.suspend2.net>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Chris Friedhoff <chris@friedhoff.org>
    Signed-off-by: Len Brown <len.brown@intel.com>
