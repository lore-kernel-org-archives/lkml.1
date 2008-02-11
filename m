Return-Path: <linux-kernel-owner+w=401wt.eu-S1757178AbYBKAgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbYBKAgx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 19:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbYBKAgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 19:36:44 -0500
Received: from mga06.intel.com ([134.134.136.21]:58833 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754640AbYBKAgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 19:36:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,331,1199692800"; 
   d="scan'208";a="337822723"
Message-ID: <47AF9867.6050902@linux.intel.com>
Date: Sun, 10 Feb 2008 16:35:51 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Oops report for the week upto Feb 10th 2008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The http://www.kerneloops.org website collects kernel oops and
warning reports from various mailing lists and bugzillas as well as
with a client users can install to auto-submit oopses.
Below is a top 10 list of the oopses/backtraces collected in the last 7 days.
(Reports prior to 2.6.23 have been omitted in collecting the top 10)

This week, a total of 323 oopses and warnings have been reported,
compared to 110 reports in the previous week.

(This sharp increase is due to Fedora 9 alpha shipping the oops data
collection client in the default install, giving us much wider coverage
in the issues that actual users hit; many thanks to the Fedora project
for this)

With the 2.6.25-rc1 release out, this will be the last report that includes
2.6.23; future reports will only include issues from 2.6.24 and later.


Rank 1: set_dentry_child_flags
	WARN_ON at fs/inotify.c:172 set_dentry_child_flags
	Reported 93 times (116 total reports)
	This is a user triggered WARN_ON in inotify. Sadly inotify seems to be unmaintained.
	More info: http://www.kerneloops.org/search.php?search=set_dentry_child_flags

Rank 2: __ieee80211_rx_handle_packet
	WARN_ON at net/mac80211/rx.c:1704 __ieee80211_rx_handle_packet
	Reported 35 times (82 total reports)
	This is the well known packet alignment issue; fix in progress
	More info: http://www.kerneloops.org/search.php?search=__ieee80211_rx_handle_packet

Rank 3: remove_proc_entry
	WARN_ON at fs/proc/generic.c:736
	Reported 20 times (38 total reports)
	This WARN_ON is there if code tries to remove a non-empty /proc directory.
	Most reports are tainted, pointing at a bug in a binary module.
	Without the WARN_ON improvements from 2.6.25-rc1 it'll be hard to figure out which module is guilty.
	More info: http://www.kerneloops.org/search.php?search=remove_proc_entry

Rank 4: bad_io_access
	WARN_ON at lib/iomap.c:44
	Reported 15 times (21 total reports)
	This is a bug in the ata_bmdma code
	More info: http://www.kerneloops.org/search.php?search=bad_io_access

Rank 5: sysctl_print_path
	Reported 28 times (41 total reports)
	This is a bug in the binary-only madwifi module.
	More info: http://www.kerneloops.org/search.php?search=sysctl_print_path

Rank 6: dma_free_coherent
	WARN_ON at arch/x86/kernel/pci-dma_32.c:66
	Reported 9 times (11 total reports)
	This bug happened with the acx, arcmsr, sym2 and generic ata drivers
	More info: http://www.kerneloops.org/search.php?search=dma_free_coherent

Rank 7: _spin_unlock_irqrestore
	Soft lockup
	Reported 7 times (11 total reports)
	In all cases it happened via scsi_dispatch_cmd
	More info: http://www.kerneloops.org/search.php?search=_spin_unlock_irqrestore

Rank 8: uart_flush_buffer
	The well known bluetooth tty flush bug
	A fix for this bug has been merged into 2.6.25-rc1
	Reported 6 times (67 total reports)
	More info: http://www.kerneloops.org/search.php?search=uart_flush_buffer

Rank 9: mark_buffer_dirty
	WARN_ON at fs/buffer.c:1169
	This indicates that a non-uptodate buffer is marked dirty.
	This can lead to data corruption!
	Reported 5 times (12 total reports) - Only seen since 2.6.24-rc6
	Usually happens during umount()
	More info: http://www.kerneloops.org/search.php?search=mark_buffer_dirty

Rank 10: sysfs_add_one
	WARN_ON at fs/sysfs/dir.c:424 (duplicate filename)
	Reported 5 times (57 total reports)
	Seems to happen mostly with ALSA
	More info: http://www.kerneloops.org/search.php?search=sysfs_add_one

