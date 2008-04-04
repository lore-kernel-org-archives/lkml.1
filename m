Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbYDDWEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbYDDWEl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 18:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbYDDWE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 18:04:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51412 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbYDDWE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 18:04:27 -0400
Message-ID: <47F6A5E8.1030602@garzik.org>
Date: Fri, 04 Apr 2008 18:04:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Rich West <Rich.West@wesmo.com>
CC: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: sata_via
References: <47F694C8.8020507@wesmo.com>
In-Reply-To: <47F694C8.8020507@wesmo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rich West wrote:
> On my mythtv backend system, the recordings volume tends to get pounded
> rather hard (up to 5 recordings (some HD) at once with multiple frontend
> systems reading from that same volume).  I recently (4 months ago)
> upgraded the system to a motherboard that happened to have the VIA
> chipset on it.
> 
> Since that time, I have had some bizarre problems with that volume. 
> After a seemingly random amount of time, the kernel would report an
> error with the volume and put it in read-only mode.  However, it would
> not really be in read-only mode, but it would be completely
> inaccessible.  Unmounting the volume would be successful, but
> re-mounting the volume would fail.
> 
> I've replaced the drive (with an identical one), tested memory, changed
> filesystems (it was LVM + ext3, then just ext3) and the problem persists.
> 
> Running 2.6.24.4-64 (Fedora 8).
> 
> A larger snippet from the messages log is (dmesg gets cleared after 
> reboot):
> Apr  3 16:47:27 mythtv1 kernel: ata4.00: exception Emask 0x0 SAct 0x0
> SErr 0x0 action 0x2 frozen
> Apr  3 16:47:27 mythtv1 kernel: ata4.00: cmd
> c8/00:00:77:31:21/00:00:00:00:00/e1 tag 0 dma 131072 in
> Apr  3 16:47:27 mythtv1 kernel:          res
> 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> Apr  3 16:47:27 mythtv1 kernel: ata4.00: status: { DRDY }
> Apr  3 16:47:27 mythtv1 kernel: ata4: soft resetting link
> Apr  3 16:47:57 mythtv1 kernel: ata4.00: qc timeout (cmd 0x27)
> Apr  3 16:47:57 mythtv1 kernel: ata4.00: failed to read native max
> address (err_mask=0x4)
> Apr  3 16:47:57 mythtv1 kernel: ata4.00: HPA support seems broken, will
> skip HPA handling
> Apr  3 16:47:57 mythtv1 kernel: ata4.00: revalidation failed (errno=-5)
> Apr  3 16:47:57 mythtv1 kernel: ata4: failed to recover some devices,
> retrying in 5 secs
> Apr  3 16:48:02 mythtv1 kernel: ata4: soft resetting link
> Apr  3 16:48:02 mythtv1 kernel: ata4.00: configured for UDMA/133
> Apr  3 16:48:02 mythtv1 kernel: ata4: EH complete
> Apr  3 16:49:02 mythtv1 kernel: ata4.00: exception Emask 0x0 SAct 0x0
> SErr 0x0 action 0x2 frozen
> Apr  3 16:49:02 mythtv1 kernel: ata4.00: cmd
> c8/00:00:77:31:21/00:00:00:00:00/e1 tag 0 dma 131072 in
> Apr  3 16:49:02 mythtv1 kernel:          res
> 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> Apr  3 16:49:02 mythtv1 kernel: ata4.00: status: { DRDY }
> Apr  3 16:49:02 mythtv1 kernel: ata4: soft resetting link
> Apr  3 16:49:03 mythtv1 kernel: ata4.00: configured for UDMA/133
> Apr  3 16:49:03 mythtv1 kernel: ata4: EH complete
> 
> It is almost as if I am hitting some bug that is causing the drive to
> fall off, but I really don't know where else to look or where else to
> turn...
> 
> I'm tempted to just go back to using a PATA drive (smaller.  :(  ) to
> avoid the problem.  I'm just at a loss as to how it can actually be solved.

This timeout/DRDY message has been a common one recently.  Some of the 
issues causing this may be resolved in 2.6.25-rc, can you try that?

Also, if you could build and test some older kernels to see when this 
behavior first appeared, that would be quite helpful.

Overall, a timeout _might_ be a problem with libata (the kernel SATA 
drivers), or it _might_ be a problem with your system's interrupt 
delivery (sometimes an ACPI or BIOS problem).  Try booting with 'noapic' 
or 'acpi=off'.

	Jeff




