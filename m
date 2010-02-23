Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380Ab0BWFwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 00:52:36 -0500
Received: from vms173015pub.verizon.net ([206.46.173.15]:56715 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab0BWFwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 00:52:34 -0500
Date: Tue, 23 Feb 2010 00:52:17 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: [git pull request] ACPI & driver patches for Linux-2.6.33-rc8 (part 2)
Message-id: <alpine.LFD.2.00.1002230050390.3772@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

Three more bug-fixes.
This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.33/acpi-release-20091214-2.6.33-rc8.diff.gz

 drivers/acpi/processor_idle.c    |   28 ++++++++++++++++------------
 drivers/acpi/processor_perflib.c |    6 +++++-
 drivers/platform/x86/acer-wmi.c  |    2 +-
 3 files changed, 22 insertions(+), 14 deletions(-)

through these commits:

Carlos Corbacho (1):
      acer-wmi: Respect current backlight level when loading

Darrick J. Wong (1):
      ACPI: Fix regression where _PPC is not read at boot even when ignore_ppc=0

Pallipadi, Venkatesh (1):
      ACPI: Be in TS_POLLING state during mwait based C-state entry

with this log:

commit b2cb9dcb98cc7a3210e9138a05e0ae1863523a61
Merge: e4f23f6 455c0d7
Author: Len Brown <len.brown@intel.com>
Date:   Tue Feb 23 00:39:00 2010 -0500

    Merge branch 'pcc' into release

commit e4f23f66ed2498d7d08437d47cad2fca88b812bc
Merge: 9f3a628 6f6ef82 d306ebc
Author: Len Brown <len.brown@intel.com>
Date:   Tue Feb 23 00:19:48 2010 -0500

    Merge branches 'bugzilla-14207' and 'idle' into release

commit d306ebc28649b89877a22158fe0076f06cc46f60
Author: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
Date:   Wed Feb 10 10:35:31 2010 -0800

    ACPI: Be in TS_POLLING state during mwait based C-state entry
    
    ACPI deep C-state entry had a long standing bug/missing feature, wherein we were sending
    resched IPIs when an idle CPU is in mwait based deep C-state. Only mwait based C1 was using
    the write to the monitored address to wake up mwait'ing CPU.
    
    This patch changes the code to retain TS_POLLING bit if we are entering an mwait based
    deep C-state.
    
    The patch has been verified to reduce the number of resched IPIs in general and also
    improves the performance/power on workloads with low system utilization (i.e., when mwait based
    deep C-states are being used).
    
    Fixes "netperf ~50% regression with 2.6.33-rc1, bisect to 1b9508f"
    http://marc.info/?l=linux-kernel&m=126441481427331&w=4
    
    Reported-by: Lin Ming <ming.m.lin@intel.com>
    Tested-by: Alex Shi <alex.shi@intel.com>
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 455c0d71d46e86b0b7ff2c9dcfc19bc162302ee9
Author: Darrick J. Wong <djwong@us.ibm.com>
Date:   Thu Feb 18 10:28:20 2010 -0800

    ACPI: Fix regression where _PPC is not read at boot even when ignore_ppc=0
    
    Earlier, Ingo Molnar posted a patch to make it so that the kernel would avoid
    reading _PPC on his broken T60.  Unfortunately, it seems that with Thomas
    Renninger's patch last July to eliminate _PPC evaluations when the processor
    driver loads, the kernel never actually reads _PPC at all!  This is problematic
    if you happen to boot your non-T60 computer in a state where the BIOS _wants_
    _PPC to be something other than zero.
    
    So, put the _PPC evaluation back into acpi_processor_get_performance_info if
    ignore_ppc isn't 1.
    
    Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6f6ef82cc9de24153ba7d5cedab5970e276aefa1
Author: Carlos Corbacho <carlos@strangeworlds.co.uk>
Date:   Sat Dec 26 19:24:31 2009 +0000

    acer-wmi: Respect current backlight level when loading
    
    Set the backlight to use the current brightness when loaded, rather than
    always resetting the backlight to maximum brightness.
    
    Fixes kernel bugzilla #14207
    
    Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Reported-by: Denis Mukhin <denis_mukhin@yahoo.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
