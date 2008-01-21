Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbYAUVOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbYAUVOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 16:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbYAUVOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 16:14:03 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:32983 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbYAUVOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 16:14:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=k6tjUKilubNxtzWO8yYZvWUfR9s62u1xa+TyLegZEPUAnI2AkjLQtpXGMeHvi61G88bMbJi4fiwCp5WGs/xsnXKfMPgoeIfGXLPfW6vXpmDrqZ3CRa+MU0BqSBEOEJ9IoxcfzhEYSSkTO4YOUApLxwm47QrEIwxDXEG5a/qf614=
Date: Mon, 21 Jan 2008 22:16:25 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Alan Stern <stern@rowland.harvard.edu>,
       Greg KH <gregkh@suse.de>, stefanr@s5r6.in-berlin.de,
       David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct
	class
Message-ID: <20080121211625.GA2758@ami.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0801210044t5f705f77n8e310878775f7b5b@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young wrote, On 01/21/2008 09:44 AM:
...
> I applied it in my kernel, built and run without warnings, but it need
> more testing.
> I will be very glad to see the test result about this if you could, thanks.

Bad news. (Alas I won't be able to check this today.)

=============================================
[ INFO: possible recursive locking detected ]
2.6.24-rc8 #5
---------------------------------------------
modprobe/536 is trying to acquire lock:
 (&cls->mutex/1){--..}, at: [<c0217e43>] class_device_add+0x2c6/0x322

but task is already holding lock:
 (&cls->mutex/1){--..}, at: [<c0217e43>] class_device_add+0x2c6/0x322

other info that might help us debug this:
2 locks held by modprobe/536:
 #0:  (&shost->scan_mutex){--..}, at: [<ce82795b>] __scsi_add_device+0x60/0xc9 [scsi_mod]
 #1:  (&cls->mutex/1){--..}, at: [<c0217e43>] class_device_add+0x2c6/0x322

stack backtrace:
Pid: 536, comm: modprobe Not tainted 2.6.24-rc8 #5
 [<c0138edf>] __lock_acquire+0x962/0x10d4
 [<c028be37>] _spin_unlock_irqrestore+0x34/0x39
 [<c015e693>] kfree+0x87/0xad
 [<c01380cb>] trace_hardirqs_on+0xba/0x15b
 [<c01396c2>] lock_acquire+0x71/0x8b
 [<c0217e43>] class_device_add+0x2c6/0x322
 [<c028a87f>] mutex_lock_nested+0x92/0x2bc
 [<c0217e43>] class_device_add+0x2c6/0x322
 [<c0217e43>] class_device_add+0x2c6/0x322
 [<c0217e43>] class_device_add+0x2c6/0x322
 [<c01afd42>] kobject_get+0xf/0x13
 [<c01afe68>] kobject_init+0x29/0x38
 [<c0217f2c>] class_device_create+0x7d/0x9e
 [<cebfe5b4>] sg_add+0x144/0x39f [sg]
 [<c0217e71>] class_device_add+0x2f4/0x322
 [<ce8289f7>] scsi_sysfs_add_sdev+0x64/0x1ac [scsi_mod]
 [<ce840ece>] ata_scsi_dev_config+0x14/0x91 [libata]
 [<ce826b5c>] scsi_probe_and_add_lun+0x9c0/0x9e0 [scsi_mod]
 [<ce82795b>] __scsi_add_device+0x60/0xc9 [scsi_mod]
 [<ce8279c2>] __scsi_add_device+0xc7/0xc9 [scsi_mod]
 [<ce841401>] ata_scsi_scan_host+0xd3/0x26a [libata]
 [<ce83e7e6>] ata_host_register+0x205/0x280 [libata]
 [<ce83f430>] ata_interrupt+0x0/0x200 [libata]
 [<ce83e8ec>] ata_host_activate+0x8b/0xf2 [libata]
 [<ceb95504>] svia_init_one+0x2e2/0x511 [sata_via]
 [<c01ca42c>] pci_match_device+0xa5/0xb6
 [<ceb95222>] svia_init_one+0x0/0x511 [sata_via]
 [<c01ca4e9>] pci_device_probe+0x40/0x5f
 [<c02173ae>] driver_probe_device+0x7c/0x175
 [<c02175ed>] __driver_attach+0xa2/0xa4
 [<c02168dd>] bus_for_each_dev+0x3c/0x5a
 [<c0217263>] driver_attach+0x16/0x1a
 [<c021754b>] __driver_attach+0x0/0xa4
 [<c0216bea>] bus_add_driver+0x72/0x1c0
 [<c01ca642>] __pci_register_driver+0x56/0x89
 [<c013f11d>] sys_init_module+0xf8/0x1891
 [<ce83901f>] ata_port_start+0x0/0x65 [libata]
 [<c01380cb>] trace_hardirqs_on+0xba/0x15b
 [<c0102936>] syscall_call+0x7/0xb
 =======================
scsi 2:0:0:0: Attached scsi generic sg1 type 0

Regards,
Jarek P.
