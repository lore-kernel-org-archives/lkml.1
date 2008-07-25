Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbYGYO0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbYGYO0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 10:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbYGYO0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 10:26:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:62227 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbYGYO0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 10:26:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=OkH1dPHvQnVtB3viAO23MybpBwBowuASlIqe51VsVuDG+rhoKWDeW1z8EcabOj16z2
         z/1uNUkUNhrQYwfdpzBlSvp+RRz+yG4GeWglFwkpVcCDjQP2mZi788ISKDj8eY94MaQA
         YCkG+nRkJ9QQp0wrdixBEwsdPW5WOTtb80d08=
Message-ID: <b6a2187b0807250726n77a0cd6eqb97b817fddc343b9@mail.gmail.com>
Date: Fri, 25 Jul 2008 22:26:38 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: please revert commit 53f1b1433da7eac2607a4a0898a221a4485fd732 (rtc: push the BKL down into the driver ioctl method)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

53f1b1433da7eac2607a4a0898a221a4485fd732 is first bad commit
commit 53f1b1433da7eac2607a4a0898a221a4485fd732
Author: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date:   Wed Jul 23 21:30:32 2008 -0700

    rtc: push the BKL down into the driver ioctl method


This commit is breaking vmware-6.0.4. Upon booting linux (guest) on
vmware, the whole vmware environment crashed.

Reverting this commit make vmware runs again.

Thanks,
Jeff.


Here's the oops.

BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<00000000>]
*pdpt = 000000003209b001 *pde = 0000000000000000
Oops: 0000 [#1] PREEMPT SMP
Modules linked in: sg 8250 serial_core sr_mod cdrom vmnet vmmon iwl3945 mac80211
 cfg80211 dummy [last unloaded: bluetooth]

Pid: 4052, comm: vmware-vmx Not tainted (2.6.26 #29)
EIP: 0060:[<00000000>] EFLAGS: 00213286 CPU: 1
EIP is at 0x0
EAX: f7483468 EBX: c03b0f04 ECX: 00007005 EDX: f2c1d880
ESI: f2c1d880 EDI: f20b4000 EBP: 000001a4 ESP: f2c99df8
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process vmware-vmx (pid: 4052, ti=f2c99000 task=f2ce46c0 task.ti=f2c99000)
Stack: f99e76a1 00000000 000001a4 00000000 f99efd65 f99f3f20 000000fa 000001a4
       f2c6ec00 f2cbc380 000007e6 000007e6 f99e5a87 b2d69163 00000000 f202f108
       f2540820 000000a0 c0118694 00000000 00000000 f2de8a04 00000001 00203282
Call Trace:
 [<f99e76a1>] HostIF_SetFastClockRate+0x8d/0x148 [vmmon]
 [<f99efd65>] Vmx86_SetHostClockRate+0xad/0xd5 [vmmon]
 [<f99e5a87>] LinuxDriver_Ioctl+0x4c6/0xdcd [vmmon]
 [<c0118694>] kmap_atomic_prot+0x102/0x137
 [<c0395846>] _spin_unlock+0x5/0x1c
 [<c017bd62>] mnt_drop_write+0x64/0xdd
 [<c01f0680>] rb_insert_color+0x4c/0xad
 [<c013260a>] enqueue_hrtimer+0xc9/0xd4
 [<c0132ba5>] hrtimer_start+0xf9/0x129
 [<c011a13c>] hrtick_start_fair+0xf7/0x123
 [<c0129e78>] group_send_sig_info+0x12/0x56
 [<c0129eed>] kill_pid_info+0x31/0x54
 [<c012a44e>] sys_kill+0x73/0x13e
 [<c0172b53>] vfs_ioctl+0x47/0x5d
 [<c0172db1>] do_vfs_ioctl+0x248/0x258
 [<c0134a11>] do_gettimeofday+0xd/0x27
 [<c0172ded>] sys_ioctl+0x2c/0x43
 [<c0102cd3>] sysenter_do_call+0x12/0x33
 =======================
Code:  Bad EIP value.
EIP: [<00000000>] 0x0 SS:ESP 0068:f2c99df8
---[ end trace 82b56b8602667b97 ]---
