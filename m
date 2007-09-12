Return-Path: <linux-kernel-owner+w=401wt.eu-S1765558AbXILHtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765558AbXILHtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 03:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757139AbXILHom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 03:44:42 -0400
Received: from mx1.aecom.yu.edu ([129.98.1.51]:34081 "EHLO mx1.aecom.yu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764474AbXILHol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 03:44:41 -0400
X-Greylist: delayed 2115 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Sep 2007 03:44:41 EDT
X-AuditID: 816201a0-ac6c2bb000003f1e-e6-46e78d70a24a
Mime-Version: 1.0
Message-Id: <a06240411c30cd5dee72c@[129.98.90.227]>
Date: Wed, 12 Sep 2007 03:09:14 -0400
To: linux-lvm@redhat.com
From: Maurice Volaski <mvolaski@aecom.yu.edu>
Subject: Can LVM block I/O and hang a system?
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A working system begins hanging and it seems to be stuck on I/O 
processes that use ext3 partitions that are running on top of LVM. 
The system is AMD 64-bit running Gentoo. Kernel is Gentoo 2.6.22-r3 
and LVM lvm2-2.02.27. Here is the disk setup:

Boot disk, attached to motherboard via SATA
1) some partitions accessed via ext3 -> hardware partition.
2) some partitions accessed via ext3 -> drbd, which is version 8.0.5, 
-> hardware partition.

External SATA-SCSI RAID, attached to via an LSI Logic card,
3) one partition accessed via ext3 -> drbd -> hardware partition.
4) some partitions accessed via ext3 -> LVM -> drbd -> hardware partition.

On repeated reboots, #1) boots fine, and I can fsck #2) no problem. I 
can also fsck #3, but the fsck processes on #4, which all are trying 
to recover the journals, just seem to not do anything. There is no 
evidence of I/O and there are no errors reported anywhere. The frozen 
fsck processes cannot even be killed and the system ignores the 
shutdown command.

That the hanging fsck processes are all occurring on just the LVM 
partitions seems to imply that LVM is responsible.

drbd had been unattached to its peer during this time, and when I 
reattached it, it had no trouble syncing to the peer. That system, 
which should basically be identical, however, has no trouble running 
running fsck everywhere. I'm not sure, though, if that lets LVM off 
the hook.
-- 

Maurice Volaski, mvolaski@aecom.yu.edu
Computing Support, Rose F. Kennedy Center
Albert Einstein College of Medicine of Yeshiva University
