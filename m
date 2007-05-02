Return-Path: <linux-kernel-owner+w=401wt.eu-S2993453AbXEBQRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993453AbXEBQRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 12:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993448AbXEBQRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 12:17:17 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:23585 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993447AbXEBQRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 12:17:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=HuRj8Aq7Ag5F51U8d1m3v8JQ7HC5XITUobQnRYzlyPs83DXlwCP1335nklRTNQvj93jJuzTtgGNWsDwXCoAoLyPtQlwvj6dVj72l+8R1c2qJ4eppUN9yUU7w2u63q9tlZeMg8tujRyk1xvGEXhySybxoxAUTfbxfv7AgCBt71Ag=
Message-ID: <c547abb70705020917u7daca6d4i708474a9cc976bf7@mail.gmail.com>
Date: Wed, 2 May 2007 12:17:12 -0400
From: "brendan powers" <brendan0powers@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: BUG: soft lockup detected on CPU#1!
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, i'm running debin sarge(3.1) with kernel 2.6.16.7 and came
across this kernel oops. It locked up shortly afterwords. Its a
terminal server so there is a lot of different things going on so i'm
not sure exactly what caused this to happen. Anyone have any ideas?

Here is the log of what happened.

CIFS VFS: Error 0xfffffff3 on cifs_get_inode_info in lookup of \.directory
smbfs: Unrecognized mount option domain
BUG: soft lockup detected on CPU#1!

Pid: 8657, comm:             kio_file
EIP: 0060:[get_offset_pmtmr+22/3661] CPU: 1
EIP is at get_offset_pmtmr+0x16/0xe4d
 EFLAGS: 00000246    Not tainted  (2.6.16.7.resara-opteron #1)
EAX: 00906422 EBX: d4d49de8 ECX: 00906416 EDX: 00001008
ESI: 00905639 EDI: 0090641c EBP: 0000000a DS: 007b ES: 007b
CR0: 8005003b CR2: 091d9000 CR3: 36e1dac0 CR4: 000006f0
 [do_gettimeofday+28/164] do_gettimeofday+0x1c/0xa4
 [getnstimeofday+15/39] getnstimeofday+0xf/0x27
 [ktime_get_ts+24/81] ktime_get_ts+0x18/0x51
 [ktime_get+16/58] ktime_get+0x10/0x3a
 [hrtimer_run_queues+45/225] hrtimer_run_queues+0x2d/0xe1
 [run_timer_softirq+34/387] run_timer_softirq+0x22/0x183
 [__do_softirq+91/196] __do_softirq+0x5b/0xc4
 [do_softirq+45/49] do_softirq+0x2d/0x31
 [apic_timer_interrupt+28/36] apic_timer_interrupt+0x1c/0x24
 [generic_fillattr+117/157] generic_fillattr+0x75/0x9d
 [pg0+948724075/1069974528] cifs_getattr+0x1f/0x26 [cifs]
 [vfs_getattr+65/150] vfs_getattr+0x41/0x96
 [vfs_stat_fd+50/69] vfs_stat_fd+0x32/0x45
 [current_fs_time+72/95] current_fs_time+0x48/0x5f
 [dput+27/281] dput+0x1b/0x119
 [mntput_no_expire+20/113] mntput_no_expire+0x14/0x71
 [vfs_stat+15/19] vfs_stat+0xf/0x13
 [sys_stat64+16/39] sys_stat64+0x10/0x27
 [sys_readlink+19/23] sys_readlink+0x13/0x17
 [syscall_call+7/11] syscall_call+0x7/0xb
BUG: soft lockup detected on CPU#0!

Pid: 8694, comm:             kio_file
EIP: 0060:[generic_fillattr+114/157] CPU: 0
EIP is at generic_fillattr+0x72/0x9d
 EFLAGS: 00000202    Not tainted  (2.6.16.7.resara-opteron #1)
EAX: 0000002d EBX: defc7f64 ECX: c481fb04 EDX: 00000001
ESI: 00000000 EDI: 00000000 EBP: e8afc740 DS: 007b ES: 007b
CR0: 8005003b CR2: 091d6a8c CR3: 1a457380 CR4: 000006f0
 [pg0+948724075/1069974528] cifs_getattr+0x1f/0x26 [cifs]
 [vfs_getattr+65/150] vfs_getattr+0x41/0x96
 [vfs_stat_fd+50/69] vfs_stat_fd+0x32/0x45
 [__mark_inode_dirty+38/339] __mark_inode_dirty+0x26/0x153
 [dput+27/281] dput+0x1b/0x119
 [mntput_no_expire+20/113] mntput_no_expire+0x14/0x71
 [vfs_stat+15/19] vfs_stat+0xf/0x13
 [sys_stat64+16/39] sys_stat64+0x10/0x27
 [sys_readlink+19/23] sys_readlink+0x13/0x17
 [syscall_call+7/11] syscall_call+0x7/0xb
 CIFS VFS: Send error in read = -13
May  2 09:44:09 localhost last message repeated 9 times
BUG: soft lockup detected on CPU#3!

Pid: 8684, comm:            konqueror
EIP: 0060:[generic_fillattr+117/157] CPU: 3
EIP is at generic_fillattr+0x75/0x9d
 EFLAGS: 00000202    Not tainted  (2.6.16.7.resara-opteron #1)
EAX: 0000002f EBX: d17d5f64 ECX: c481fb04 EDX: 00000001
ESI: 00000000 EDI: 00000000 EBP: e8afc740 DS: 007b ES: 007b
CR0: 8005003b CR2: ab5f7000 CR3: 1a457840 CR4: 000006f0
 [pg0+948724075/1069974528] cifs_getattr+0x1f/0x26 [cifs]
 [vfs_getattr+65/150] vfs_getattr+0x41/0x96
 [vfs_stat_fd+50/69] vfs_stat_fd+0x32/0x45
 [vfs_stat+15/19] vfs_stat+0xf/0x13
 [sys_stat64+16/39] sys_stat64+0x10/0x27
 [slab_destroy+56/91] slab_destroy+0x38/0x5b
 [syscall_call+7/11] syscall_call+0x7/0xb
 CIFS VFS: Send error in read = -13
