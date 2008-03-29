Return-Path: <linux-kernel-owner+w=401wt.eu-S1756364AbYC2Uqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364AbYC2Uqa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 16:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444AbYC2UqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 16:46:24 -0400
Received: from testure.choralone.org ([194.9.77.134]:54832 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbYC2UqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 16:46:23 -0400
Date: Sat, 29 Mar 2008 16:46:15 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Linux Kernel <linux-kernel@vger.kernel.org>, mchehab@infradead.org
Subject: Re: v4l oops in 2.6.25-rc7
Message-ID: <20080329204615.GA25345@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>, mchehab@infradead.org
References: <20080327230430.GA28795@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327230430.GA28795@codemonkey.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 07:04:30PM -0400, Dave Jones wrote:
 > Booted up with an ancient bt848 card present and got this..
 > 
 > 
 > BUG: unable to handle kernel NULL pointer dereference at 000001e0
 > IP: [<c0500ba2>] strlen+0xb/0x15
 > *pde = 02e0d067 *pte = 00000000 
 > Oops: 0000 [#1] SMP 
 > Modules linked in: sha256_generic aes_generic cbc dm_crypt crypto_blkcipher dm_emc dm_round_robin dm_multipath dm_snapshot dm_mirror dm_zero dm_mod xfs jfs reiserfs lock_nolock gfs2 msdos linear raid10 raid456 async_xor async_memcpy async_tx xor raid1 raid0 sg sr_mod cdrom sd_mod ata_generic bttv videodev v4l1_compat ir_common compat_ioctl32 i2c_algo_bit v4l2_common videobuf_dma_sg videobuf_core btcx_risc tveeprom i2c_core e100 tulip ehci_hcd mii ata_piix pata_acpi ohci_hcd libata uhci_hcd iscsi_tcp libiscsi scsi_transport_iscsi scsi_mod ext2 ext3 jbd ext4dev jbd2 mbcache crc16 squashfs pcspkr edd floppy loop nfs lockd nfs_acl sunrpc vfat fat cramfs
 > 
 > Pid: 1513, comm: hald-probe-vide Not tainted (2.6.25-0.161.rc7.fc9.i586 #1)
 > EIP: 0060:[<c0500ba2>] EFLAGS: 00010246 CPU: 0
 > EIP is at strlen+0xb/0x15
 > EAX: 00000000 EBX: 000001e0 ECX: ffffffff EDX: 000001e0
 > ESI: 00000020 EDI: 000001e0 EBP: c2e8bdfc ESP: c2e8bdf8
 >  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
 > Process hald-probe-vide (pid: 1513, ti=c2e8b000 task=c2dda000 task.ti=c2e8b000)
 > Stack: c2e8bf34 c2e8be14 c04ff683 c2e8bedc c2e8becc cf116a70 c2e8bf34 c2e8be24 
 >        d0a7d931 d0a7d903 c2fd1500 c2e8bea4 d0a4dfc1 c2e8be40 80685600 c2fd1500 
 >        cd68e050 d0a9830c c2dda6c0 c2e8be4c c040a6e2 c2e8be60 c2e8be64 c040a9b0 
 > Call Trace:
 >  [<c04ff683>] ? strlcpy+0x17/0x48
 >  [<d0a7d931>] ? radio_querycap+0x2e/0x5b [bttv]
 >  [<d0a7d903>] ? radio_querycap+0x0/0x5b [bttv]
 >  [<d0a4dfc1>] ? __video_do_ioctl+0x494/0x295e [videodev]
 >  [<c040a6e2>] ? sched_clock+0x8/0xb
 >  [<c040a9b0>] ? native_sched_clock+0xb5/0xd1
 >  [<d0a5063b>] ? video_ioctl2+0x1b0/0x24d [videodev]
 >  [<c063bb4a>] ? __down_failed+0xa/0x10
 >  [<c0495d96>] ? vfs_ioctl+0x4e/0x67
 >  [<c0495fe8>] ? do_vfs_ioctl+0x239/0x24c
 >  [<c04dbb8d>] ? selinux_file_ioctl+0xa8/0xab
 >  [<c049603b>] ? sys_ioctl+0x40/0x5d
 >  [<c0405d52>] ? syscall_call+0x7/0xb
 >  =======================
 > Code: 5d c3 55 89 e5 56 89 c6 89 d0 88 c4 ac 38 e0 74 09 84 c0 75 f7 be 01 00 00 00 89 f0 48 5e 5d c3 55 83 c9 ff 89 e5 57 89 c7 31 c0 <f2> ae f7 d1 49 89 c8 5f 5d c3 55 89 e5 57 31 ff 85 c9 74 0e 89 
 > EIP: [<c0500ba2>] strlen+0xb/0x15 SS:ESP 0068:c2e8bdf8
 > ---[ end trace fba34738c02be064 ]---

I looked at this a bit closer.  The problem seems to be caused by an
selinux denial.  The selinux policy is being updated to allow the action to succeed,
but we shouldn't oops in the case that an action gets denied.

	Dave

-- 
http://www.codemonkey.org.uk
