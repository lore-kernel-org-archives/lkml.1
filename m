Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479AbYE3QjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbYE3QjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 12:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbYE3QjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 12:39:12 -0400
Received: from mga10.intel.com ([192.55.52.92]:49314 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752040AbYE3QjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 12:39:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,567,1204531200"; 
   d="scan'208";a="334177178"
Message-ID: <48402DAA.60202@linux.intel.com>
Date: Fri, 30 May 2008 09:39:06 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, Hugh Dickins <hugh@veritas.com>,
       Jeff Garzik <jeff@garzik.org>
Subject: Top kernel oopses/warnings for the week of May 30th 2008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The http://www.kerneloops.org website collects kernel oops and
warning reports from various mailing lists and bugzillas as well as
with a client users can install to auto-submit oopses.
Below is a top 10 list of the traces collected in the last 7 days.
(Reports prior to 2.6.23 have been omitted in collecting the top 10)

This week, a total of 3670 oopses and warnings have been reported,
compared to 3029 reports in the previous week.



In addition to Fedora, Debian now has included the client application in their
default GUI install targets, thanks a lot for that!

This week, based on feedback, I've split the report into "untainted"
and "caused by proprietary drivers". Let me know if I should continue
doing this or if the old format was better.

As an experiment (on request) I've exported the database to text files (one file
per report) and stuck it in a git repository. You can take a look with
git clone git://www.kerneloops.org/
Suggestions for improving the format of this are obviously very welcome, as are
"yes useful" and "no not useful" comments. Again, this is an experiment, if it's
not seen as useful I may discontinue it.



Per file statistics
1427	kernel/sysctl.c
238	fs/sysfs/dir.c
206	fs/buffer.c
167	security/selinux/hooks.c
84	kernel/spinlock.c
53	net/mac80211/main.c
48	mm/highmem.c
30	net/core/sock.c
26	net/bluetooth/rfcomm/sock.c
26	drivers/media/video/saa7134/saa7134-cards.c
24	mm/rmap.c
23	kernel/softirq.c



Seen with untainted systems
---------------------------
Rank 2: sysfs_add_one (warning)
	Reported 243 times (759 total reports)
	Duplicated sysfs entries, various drivers including USB
	This warning was last seen in version 2.6.26-rc3, and first seen in 2.6.24-rc6.
	More info: http://www.kerneloops.org/searchweek.php?search=sysfs_add_one

Rank 3: mark_buffer_dirty (warning)
	Reported 222 times (759 total reports)
	EXT3 bug while hot-removing a USB device
	This warning was last seen in version 2.6.25.3, and first seen in 2.6.24-rc6.
	More info: http://www.kerneloops.org/searchweek.php?search=mark_buffer_dirty

Rank 5: _spin_unlock_irqrestore (lockup)
	Reported 85 times (293 total reports)
	Soft lockup, mostly coming out of the scsi layer or out of idle
	This lockup was last seen in version 2.6.26-rc4, and first seen in 2.6.22-rc1.
	More info: http://www.kerneloops.org/searchweek.php?search=_spin_unlock_irqrestore

Rank 6: ieee80211_stop_tx_ba_session (warning)
	Reported 65 times (164 total reports)
	iwl4965 driver bug
	This warning was last seen in version 2.6.25.3, and first seen in 2.6.25-rc7-git6.
	More info: http://www.kerneloops.org/searchweek.php?search=ieee80211_stop_tx_ba_session

Rank 7: set_page_address (oops)
	Reported 53 times (65 total reports)
	crash coming from flush_all_zero_pkmaps; was this fixed by Hugh the other day?
	This oops was last seen in version 2.6.25.3, and first seen in 2.6.25.
	More info: http://www.kerneloops.org/searchweek.php?search=set_page_address

Rank 8: ata_hsm_move (warning)
	Reported 34 times (63 total reports)
	SATA layer bug
	This warning was last seen in version 2.6.25.3, and first seen in 2.6.25-rc9-git1.
	More info: http://www.kerneloops.org/searchweek.php?search=ata_hsm_move

Rank 10: __ioremap_caller (warning)
	Reported 26 times (32 total reports)
	[fixed] bug in the ck804xrom driver that would mark a large chunk of ram uncachable
	(fixed in 2.6.26-rc4)
	This warning was last seen in version 2.6.26-rc3-git6, and first seen in 2.6.25.
	More info: http://www.kerneloops.org/searchweek.php?search=__ioremap_caller

Rank 11: rfcomm_sock_destruct (oops)
	Reported 26 times (51 total reports)
	[fixed] Bug in the bluetooth protocol stack where a double spin-unlock caused an underflow of the lock variable
	This oops was last seen in version 2.6.25.3, and first seen in 2.6.25.
	(fix available in -mm)
	More info: http://www.kerneloops.org/searchweek.php?search=rfcomm_sock_destruct

Rank 12: saa7134_tuner_callback (oops)
	Reported 26 times (31 total reports)
	This oops was last seen in version 2.6.25.3, and first seen in 2.6.25-rc5-git4.
	Seems to crash during a string copy operation
	More info: http://www.kerneloops.org/searchweek.php?search=saa7134_tuner_callback


	
Caused by proprietary drivers
-----------------------------

Rank 1: __register_sysctl_paths (warning)
	Reported 1566 times (4003 total reports)
	Duplicate /proc registration. Bugs in madwifi (but also in the parport driver)
	This warning was last seen in version 2.6.26-rc4-git2, and first seen in 2.6.25-rc3.
	More info: http://www.kerneloops.org/searchweek.php?search=__register_sysctl_paths

Rank 4: task_has_capability (warning)
	Reported 181 times (202 total reports)
	[out of tree] Bug in the proprietary firegl driver
	warning only shows up in tainted kernels
	This warning was last seen in version 2.6.25.3, and first seen in 2.6.25.
	More info: http://www.kerneloops.org/searchweek.php?search=task_has_capability

Rank 9: sk_free (warning)
	Reported 30 times (135 total reports)
	VMWare driver bug
	warning only shows up in tainted kernels
	This warning was last seen in version 2.6.25.4, and first seen in 2.6.23.9.
	More info: http://www.kerneloops.org/searchweek.php?search=sk_free


