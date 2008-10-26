Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbYJZPIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbYJZPIE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 11:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbYJZPHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 11:07:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:59725 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbYJZPHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 11:07:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=s6EuAZnDi6urVo3bX74OF21ec0nAwcwiPQiH4uYU/AzhHjDCKTjj2dkFN32PrCEEaq
         2BgKZx2iSZcDUpMuHXJ661CpUbxLXUoCKoSvKNWk1qEgtNn5Hekc8P8G2I5D/6cBZAxC
         lztm49EVSFiiG6S8LEhm/59IUQV+v721wgzok=
Message-ID: <19f34abd0810260807n3a3a575ah62a60a5b6ed737f7@mail.gmail.com>
Date: Sun, 26 Oct 2008 16:07:52 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: v2.6.28-rc1: possible recursive locking detected
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think that this wasn't my fault. It's v2.6.28-rc1+kmemcheck.

=============================================
[ INFO: possible recursive locking detected ]
2.6.28-rc1 #58
---------------------------------------------
cat/25690 is trying to acquire lock:
 (&hashbin->hb_spinlock){....}, at: [<c1780e1f>] irias_seq_show+0x3f/0x180

but task is already holding lock:
 (&hashbin->hb_spinlock){....}, at: [<c1780f95>] irias_seq_start+0x15/0x90

other info that might help us debug this:
2 locks held by cat/25690:
 #0:  (&p->lock){--..}, at: [<c0502545>] seq_read+0x25/0x2e0
 #1:  (&hashbin->hb_spinlock){....}, at: [<c1780f95>] irias_seq_start+0x15/0x90

stack backtrace:
Pid: 25690, comm: cat Not tainted 2.6.28-rc1 #58
Call Trace:
 [<c195b5d6>] ? printk+0x18/0x1a
 [<c048a0bb>] __lock_acquire+0xf0b/0xf80
 [<c044c8da>] ? kmemcheck_hide_addr+0x4a/0x60
 [<c042529b>] ? do_debug+0x3b/0x1b0
 [<c048a1a1>] lock_acquire+0x71/0xa0
 [<c1780e1f>] ? irias_seq_show+0x3f/0x180
 [<c195e636>] _spin_lock+0x36/0x60
 [<c1780e1f>] ? irias_seq_show+0x3f/0x180
 [<c1780e1f>] irias_seq_show+0x3f/0x180
 [<c050270c>] seq_read+0x1ec/0x2e0
 [<c0502520>] ? seq_read+0x0/0x2e0
 [<c05297ed>] proc_reg_read+0x5d/0x90
 [<c04ea749>] vfs_read+0x99/0x160
 [<c0529790>] ? proc_reg_read+0x0/0x90
 [<c04ea8cd>] sys_read+0x3d/0x70
 [<c0422f83>] sysenter_do_call+0x12/0x3f
 [<c0420000>] ? svm_intr_assist+0x90/0x1a0


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
