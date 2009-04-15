Return-Path: <linux-kernel-owner+w=401wt.eu-S1759369AbZDOMoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369AbZDOMoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 08:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757737AbZDOMnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 08:43:55 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:61567 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbZDOMny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 08:43:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=UphaFO2ySrYbgm8DlmWlFjqIoi1RWglyveXFMX+azCj8zvgVBuuXd4Ys/NqmAKQRz5
         CO18HrWyv+KHXXgyjG6ZyJCKejGdfM8VhCi0+CzayxbGDE41O/4D2rUnYeEdTUKuUITY
         PyPNbrzlpU9r5B8SCvNSCJFUomnuaM7IT714o=
MIME-Version: 1.0
Date: Wed, 15 Apr 2009 16:43:52 +0400
Message-ID: <a4423d670904150543w3d6e1371i874618c6bd8bbd0e@mail.gmail.com>
Subject: 2.6.30-rc2: BUG: MAX_LOCKDEP_ENTRIES too low! when mounting rootfs
From: Alexander Beregalov <a.beregalov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Alexander Viro <viro@zeniv.linux.org.uk>,
       linux-fsdevel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

bnx2: eth0 NIC Copper Link is Up, 1000 Mbps full duplex, receive &
transmit flow control ON
BUG: MAX_LOCKDEP_ENTRIES too low!
turning off the locking correctness validator.
Pid: 2382, comm: mount Tainted: G        W  2.6.30-rc2-dirty #121
Call Trace:
 [<ffffffff80280aa7>] add_lock_to_list+0xf7/0x110
 [<ffffffff80282ad1>] ? check_irq_usage+0xb1/0x110
 [<ffffffff802df73c>] ? lock_super+0x3c/0x60
 [<ffffffff80284f20>] __lock_acquire+0xe80/0x12b0
 [<ffffffff802df73c>] ? lock_super+0x3c/0x60
 [<ffffffff802853f0>] lock_acquire+0xa0/0xe0
 [<ffffffff802df73c>] ? lock_super+0x3c/0x60
 [<ffffffff805f0b50>] ? usbfs_fill_super+0x0/0xe0
 [<ffffffff806d9178>] __mutex_lock_common+0x68/0x500
 [<ffffffff802df73c>] ? lock_super+0x3c/0x60
 [<ffffffff802df73c>] ? lock_super+0x3c/0x60
 [<ffffffff805f0b50>] ? usbfs_fill_super+0x0/0xe0
 [<ffffffff806d9738>] mutex_lock_nested+0x48/0x70
 [<ffffffff802df73c>] lock_super+0x3c/0x60
 [<ffffffff802dfa7a>] __fsync_super+0x2a/0xa0
 [<ffffffff802dfb10>] fsync_super+0x20/0x50
 [<ffffffff802f1f70>] ? shrink_dcache_sb+0x20/0x40
 [<ffffffff802dfb8c>] do_remount_sb+0x4c/0x250
 [<ffffffff802e08a5>] get_sb_single+0x75/0x100
 [<ffffffff805f02b9>] usb_get_sb+0x29/0x50
 [<ffffffff802df0e7>] vfs_kern_mount+0x67/0xf0
 [<ffffffff802f942d>] ? get_fs_type+0x4d/0xf0
 [<ffffffff802df21d>] do_kern_mount+0x5d/0x130
 [<ffffffff802fcd88>] do_mount+0x2e8/0x930
 [<ffffffff802a996e>] ? __get_free_pages+0x2e/0x80
 [<ffffffff802fd4b0>] sys_mount+0xe0/0x120
 [<ffffffff8020ba6b>] system_call_fastpath+0x16/0x1b
