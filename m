Return-Path: <linux-kernel-owner+w=401wt.eu-S1753698AbYKRQfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbYKRQfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 11:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbYKRQfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 11:35:08 -0500
Received: from main.gmane.org ([80.91.229.2]:58063 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbYKRQfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 11:35:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: another DMAR error, this time on cdrom
Date: Tue, 18 Nov 2008 10:34:17 -0600
Message-ID: <4922EE89.9060900@shaw.ca>
References: <e38d12ff0811172253n12bf27cam9c047282139f5749@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
In-Reply-To: <e38d12ff0811172253n12bf27cam9c047282139f5749@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Vul wrote:
> The ICH9 on my laptop is starting to feel very flaky ... I hope it's
> only the driver.
> See previous jfs post for kernel config.
> 
> dmesg for cdrom error:
> [ 3936.102010] DMAR:[DMA Read] Request device [08:00.0] fault addr fffc2000
> [ 3936.102014] DMAR:[fault reason 06] PTE Read access is not set

This looks like your Ethernet controller, actually..

> [17954.788992] cp used greatest stack depth: 3888 bytes left
> [18350.879117] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> [18350.879135] ata2.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> [18350.879138]          cdb 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> [18350.879141]          res 40/00:03:00:fe:00/00:00:00:00:00/a0 Emask
> 0x4 (timeout)
> [18350.879148] ata2.00: status: { DRDY }

Likely it messing with the SATA controller again.. though possibly 
unrelated.

> [18350.879162] ata2: hard resetting link
> [18356.233076] ata2: link is slow to respond, please be patient (ready=0)
> [18360.925084] ata2: COMRESET failed (errno=-16)
> [18360.925095] ata2: hard resetting link
> [18366.231088] ata2: link is slow to respond, please be patient (ready=0)
> [18370.974076] ata2: COMRESET failed (errno=-16)
> [18370.974086] ata2: hard resetting link
> [18376.330089] ata2: link is slow to respond, please be patient (ready=0)
> [18406.016320] ata2: COMRESET failed (errno=-16)
> [18406.016332] ata2: limiting SATA link speed to 1.5 Gbps
> [18406.016338] ata2: hard resetting link
> [18411.064079] ata2: COMRESET failed (errno=-16)
> [18411.064089] ata2: reset failed, giving up
> [18411.064095] ata2.00: disabled
> [18411.064117] ata2: EH complete
> [18411.064239] sr 1:0:0:0: [sr0] Result: hostbyte=DID_BAD_TARGET
> driverbyte=DRIVER_OK,SUGGEST_OK
> [18411.064250] end_request: I/O error, dev sr0, sector 717108
> [18411.064269] Buffer I/O error on device sr0, logical block 179277
> [18411.064309] Buffer I/O error on device sr0, logical block 179239
> [18411.064316] Buffer I/O error on device sr0, logical block 179240
> [18411.064324] Buffer I/O error on device sr0, logical block 179241
> [18411.064330] Buffer I/O error on device sr0, logical block 179242
> [18411.064337] Buffer I/O error on device sr0, logical block 179243
> [18411.064343] Buffer I/O error on device sr0, logical block 179244
> [18411.064350] Buffer I/O error on device sr0, logical block 179245
> [18411.064356] Buffer I/O error on device sr0, logical block 179246
> [18411.064362] Buffer I/O error on device sr0, logical block 179247
> [18411.064426] sr 1:0:0:0: [sr0] Result: hostbyte=DID_BAD_TARGET
> driverbyte=DRIVER_OK,SUGGEST_OK
> [18411.064434] end_request: I/O error, dev sr0, sector 716700
> [18411.159667] VFS: busy inodes on changed media.
> [18411.159859] VFS: busy inodes on changed media.
> [18411.160408] VFS: busy inodes on changed media.
> [18411.160933] VFS: busy inodes on changed media.
> [18411.160997] VFS: busy inodes on changed media.
> [18411.531810] VFS: busy inodes on changed media.
> [18411.531886] VFS: busy inodes on changed media.
> [18411.531939] VFS: busy inodes on changed media.
> [18411.532771] VFS: busy inodes on changed media.
> [18411.532832] VFS: busy inodes on changed media.
> [18411.532897] VFS: busy inodes on changed media.
> [18413.873727] VFS: busy inodes on changed media.
> [18413.873895] VFS: busy inodes on changed media.
> [18415.873217] VFS: busy inodes on changed media.
> [18415.873380] VFS: busy inodes on changed media.
> [18417.873157] VFS: busy inodes on changed media.
> [18417.873306] VFS: busy inodes on changed media.
> [18419.873202] VFS: busy inodes on changed media.
> [18419.873344] VFS: busy inodes on changed media.
> [18421.873198] VFS: busy inodes on changed media.
> [18421.873364] VFS: busy inodes on changed media.
> [18423.873132] VFS: busy inodes on changed media.
> ...
> 
> I have a very strong feeling that this error and the previous jfs one
> are strongly related :\

Can you try booting with intel_iommu=off on the command line and see if 
these errors go away?

