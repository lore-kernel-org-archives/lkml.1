Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbYJ3RIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbYJ3RIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbYJ3RIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:08:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42944 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219AbYJ3RID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:08:03 -0400
Date: Thu, 30 Oct 2008 13:08:50 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] nmi_watchdog: update procfs nmi_watchdog file
	documentation v2
Message-ID: <20081030170850.GQ771@redhat.com>
References: <20081030151712.GO771@redhat.com> <20081030091921.79c04ec6.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030091921.79c04ec6.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the /proc/sys/kernel/nmi_watchdog documentation.
Updated: included Randy Dunlap's corrections.
 
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 Documentation/filesystems/proc.txt |   11 +++++++----
 Documentation/nmi_watchdog.txt     |    5 +++++
 2 files changed, 12 insertions(+), 4 deletions(-)

--- linus-2.6.orig/Documentation/nmi_watchdog.txt	2008-10-24 11:41:30.000000000 -0400
+++ linus-2.6/Documentation/nmi_watchdog.txt	2008-10-30 13:05:46.000000000 -0400
@@ -69,6 +69,11 @@ to the overall system performance.
 On x86 nmi_watchdog is disabled by default so you have to enable it with
 a boot time parameter.
 
+It's possible to disable the NMI watchdog in run-time by writing "0" to
+/proc/sys/kernel/nmi_watchdog. Writing "1" to the same file will re-enable
+the NMI watchdog. Notice that you still need to use "nmi_watchdog=" parameter
+at boot time.
+
 NOTE: In kernels prior to 2.4.2-ac18 the NMI-oopser is enabled unconditionally
 on x86 SMP boxes.
 
--- linus-2.6.orig/Documentation/filesystems/proc.txt	2008-10-24 11:41:28.000000000 -0400
+++ linus-2.6/Documentation/filesystems/proc.txt	2008-10-30 13:05:31.000000000 -0400
@@ -1338,10 +1338,13 @@ nmi_watchdog
 
 Enables/Disables the NMI watchdog on x86 systems.  When the value is non-zero
 the NMI watchdog is enabled and will continuously test all online cpus to
-determine whether or not they are still functioning properly.
-
-Because the NMI watchdog shares registers with oprofile, by disabling the NMI
-watchdog, oprofile may have more registers to utilize.
+determine whether or not they are still functioning properly. Currently,
+passing "nmi_watchdog=" parameter at boot time is required for this function
+to work.
+
+If LAPIC NMI watchdog method is in use (nmi_watchdog=2 kernel parameter), the
+NMI watchdog shares registers with oprofile. By disabling the NMI watchdog,
+oprofile may have more registers to utilize.
 
 msgmni
 ------
