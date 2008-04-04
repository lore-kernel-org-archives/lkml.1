Return-Path: <linux-kernel-owner+w=401wt.eu-S1752368AbYDDVAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbYDDVAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 17:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbYDDVAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 17:00:07 -0400
Received: from static-151-204-187-166.pskn.east.verizon.net ([151.204.187.166]:33218
	"EHLO wesmo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbYDDVAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 17:00:06 -0400
X-Greylist: delayed 525 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Apr 2008 17:00:06 EDT
Message-ID: <47F694C8.8020507@wesmo.com>
Date: Fri, 04 Apr 2008 16:51:20 -0400
From: Rich West <Rich.West@wesmo.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: sata_via
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (wesmo.com [192.168.56.10]); Fri, 04 Apr 2008 16:51:20 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my mythtv backend system, the recordings volume tends to get pounded
rather hard (up to 5 recordings (some HD) at once with multiple frontend
systems reading from that same volume).  I recently (4 months ago)
upgraded the system to a motherboard that happened to have the VIA
chipset on it.

Since that time, I have had some bizarre problems with that volume. 
After a seemingly random amount of time, the kernel would report an
error with the volume and put it in read-only mode.  However, it would
not really be in read-only mode, but it would be completely
inaccessible.  Unmounting the volume would be successful, but
re-mounting the volume would fail.

I've replaced the drive (with an identical one), tested memory, changed
filesystems (it was LVM + ext3, then just ext3) and the problem persists.

Running 2.6.24.4-64 (Fedora 8).

A larger snippet from the messages log is (dmesg gets cleared after reboot):
Apr  3 16:47:27 mythtv1 kernel: ata4.00: exception Emask 0x0 SAct 0x0
SErr 0x0 action 0x2 frozen
Apr  3 16:47:27 mythtv1 kernel: ata4.00: cmd
c8/00:00:77:31:21/00:00:00:00:00/e1 tag 0 dma 131072 in
Apr  3 16:47:27 mythtv1 kernel:          res
40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Apr  3 16:47:27 mythtv1 kernel: ata4.00: status: { DRDY }
Apr  3 16:47:27 mythtv1 kernel: ata4: soft resetting link
Apr  3 16:47:57 mythtv1 kernel: ata4.00: qc timeout (cmd 0x27)
Apr  3 16:47:57 mythtv1 kernel: ata4.00: failed to read native max
address (err_mask=0x4)
Apr  3 16:47:57 mythtv1 kernel: ata4.00: HPA support seems broken, will
skip HPA handling
Apr  3 16:47:57 mythtv1 kernel: ata4.00: revalidation failed (errno=-5)
Apr  3 16:47:57 mythtv1 kernel: ata4: failed to recover some devices,
retrying in 5 secs
Apr  3 16:48:02 mythtv1 kernel: ata4: soft resetting link
Apr  3 16:48:02 mythtv1 kernel: ata4.00: configured for UDMA/133
Apr  3 16:48:02 mythtv1 kernel: ata4: EH complete
Apr  3 16:49:02 mythtv1 kernel: ata4.00: exception Emask 0x0 SAct 0x0
SErr 0x0 action 0x2 frozen
Apr  3 16:49:02 mythtv1 kernel: ata4.00: cmd
c8/00:00:77:31:21/00:00:00:00:00/e1 tag 0 dma 131072 in
Apr  3 16:49:02 mythtv1 kernel:          res
40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Apr  3 16:49:02 mythtv1 kernel: ata4.00: status: { DRDY }
Apr  3 16:49:02 mythtv1 kernel: ata4: soft resetting link
Apr  3 16:49:03 mythtv1 kernel: ata4.00: configured for UDMA/133
Apr  3 16:49:03 mythtv1 kernel: ata4: EH complete

It is almost as if I am hitting some bug that is causing the drive to
fall off, but I really don't know where else to look or where else to
turn...

I'm tempted to just go back to using a PATA drive (smaller.  :(  ) to
avoid the problem.  I'm just at a loss as to how it can actually be solved.

-Rich


