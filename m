Return-Path: <linux-kernel-owner+w=401wt.eu-S1762092AbYFFS6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762092AbYFFS6Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 14:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbYFFS6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 14:58:15 -0400
Received: from mga10.intel.com ([192.55.52.92]:31777 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752938AbYFFS6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 14:58:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,601,1204531200"; 
   d="scan'208";a="573501398"
Message-ID: <484988C8.1080105@linux.intel.com>
Date: Fri, 06 Jun 2008 11:58:16 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Top kernel oopses/warnings for the week of Friday June 6th, 2008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The http://www.kerneloops.org website collects kernel oops and
warning reports from various mailing lists and bugzillas as well as
with a client users can install to auto-submit oopses.
Below is a top 12 list of the traces collected in the last 7 days.
(Reports prior to 2.6.23 have been omitted in collecting the top 10)

This week, a total of 3425 oopses and warnings have been reported,
compared to 3522 reports in the previous week.

This weeks result look rather different from last weeks; mostly because I've spend
some time improving the "who is guilty" algorith to more accurately pinpoint the
blame on the really guilty party.


Per file statistics
751	external/madwifi/wrapper (P)
374	external/madwifi/binary (P)
295	drivers/parport/procfs.c
253	fs/sysfs/dir.c
197	fs/jbd/journal.c
180	security/selinux/hooks.c
95	kernel/time/tick-broadcast.c
39	external/rt/locking
39	net/mac80211/main.c
37	external/vmware/networking (P)
35	drivers/ata/libata-core.c
34	fs/ext3/super.c


Seen in untainted kernels
-------------------------
Rank 3: parport_device_proc_register (warning)
	Reported 298 times (938 total reports)
	Duplicate /proc registration in the parport driver
	This warning was last seen in version 2.6.26-rc4-git2, and first seen in 2.6.24-rc5.
	More info: http://www.kerneloops.org/searchweek.php?search=parport_device_proc_register

Rank 4: sysfs_add_one (warning)
	Reported 242 times (992 total reports)
	Duplicate sysfs registration in various components. We don't seem to be making progress on this
	one unfortunately.
	This warning was last seen in version 2.6.26-rc3, and first seen in 2.6.24-rc6.
	More info: http://www.kerneloops.org/searchweek.php?search=sysfs_add_one

Rank 6: journal_update_superblock (warning)
	Reported 171 times (709 total reports)
	Likely caused by the user removing a USB stick while mounted
	This warning was last seen in version 2.6.26, and first seen in 2.6.24-rc6-git1.
	More info: http://www.kerneloops.org/searchweek.php?search=journal_update_superblock

Rank 8: tick_broadcast_oneshot_control (deadlock)
	Reported 95 times (315 total reports)
	The deadlock/timeout detector triggers in this codepath rather agressively. I'm hesitant
	to pin this one on bad hardware, it's happening too repeastedly too much.
	This deadlock was last seen in version 2.6.25.3, and first seen in 2.6.24-rc4.
	More info: http://www.kerneloops.org/searchweek.php?search=tick_broadcast_oneshot_control

Rank 9: ieee80211_stop_tx_ba_session (warning)
	Reported 39 times (200 total reports)
	Bug in the iwl4965 driver
	This warning was last seen in version 2.6.25.3, and first seen in 2.6.25-rc7-git6.
	More info: http://www.kerneloops.org/searchweek.php?search=ieee80211_stop_tx_ba_session

Rank 11: ata_hsm_move (warning)
	Reported 34 times (95 total reports)
	Needs diagnosing
	This warning was last seen in version 2.6.25.3, and first seen in 2.6.25-rc9-git1.
	More info: http://www.kerneloops.org/searchweek.php?search=ata_hsm_move

Rank 12: set_irq_wake (warning)
	Reported 32 times (94 total reports)
	[fixed] Bug in serial_core.c where disable_irq_wake/enable_irq_wake were unbalanced
	This warning was last seen in version 2.6.25.3, and first seen in 2.6.25-rc9-git1.
	More info: http://www.kerneloops.org/searchweek.php?search=set_irq_wake

Rank 13: ext3_commit_super (warning)
	Reported 32 times (174 total reports)
	Likely caused by the user removing a USB stick while mounted
	This warning was last seen in version 2.6.25.3, and first seen in 2.6.24.
	More info: http://www.kerneloops.org/searchweek.php?search=ext3_commit_super


Caused by binary modules
------------------------
Rank 1: ath_dynamic_sysctl_register (warning)
	Reported 646 times (2522 total reports)
	[external] Bug in the proprietary madwifi driver
	warning only shows up in tainted kernels
	This warning was last seen in version 2.6.25.4, and first seen in 2.6.24.
	More info: http://www.kerneloops.org/searchweek.php?search=ath_dynamic_sysctl_register

Rank 2: init_ath_hal (warning)
	Reported 379 times (1485 total reports)
	[external] Bug in the proprietary madwifi driver
	warning only shows up in tainted kernels
	This warning was last seen in version 2.6.25.4, and first seen in 2.6.24.
	More info: http://www.kerneloops.org/searchweek.php?search=init_ath_hal

Rank 5: task_has_capability (warning)
	Reported 178 times (369 total reports)
	[external] Bug in the proprietary firegl driver
	warning only shows up in tainted kernels
	This warning was last seen in version 2.6.25.4, and first seen in 2.6.25.
	More info: http://www.kerneloops.org/searchweek.php?search=task_has_capability

Rank 7: ath_sysctl_register (warning)
	Reported 115 times (589 total reports)
	[external] Bug in the proprietary madwifi driver
	warning only shows up in tainted kernels
	This warning was last seen in version 2.6.25.4, and first seen in 2.6.24-rc4-git4.
	More info: http://www.kerneloops.org/searchweek.php?search=ath_sysctl_register

Rank 10: VNetBridgeDown (warning)
	Reported 37 times (170 total reports)
	[external] Bug in the proprietary VMWare drivers
	warning only shows up in tainted kernels
	This warning was last seen in version 2.6.25.4, and first seen in 2.6.24.
	More info: http://www.kerneloops.org/searchweek.php?search=VNetBridgeDown


