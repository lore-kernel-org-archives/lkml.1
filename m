Return-Path: <linux-kernel-owner+w=401wt.eu-S1753657AbYJ1W4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbYJ1W4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 18:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbYJ1W4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 18:56:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39626 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054AbYJ1W4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 18:56:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: v2.6.28-rc1: possible recursive locking detected
Date: Wed, 29 Oct 2008 00:00:39 +0100
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <19f34abd0810260807n3a3a575ah62a60a5b6ed737f7@mail.gmail.com>
In-Reply-To: <19f34abd0810260807n3a3a575ah62a60a5b6ed737f7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810290000.39682.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 26 of October 2008, Vegard Nossum wrote:
> Hi,
> 
> I think that this wasn't my fault. It's v2.6.28-rc1+kmemcheck.

Is this reproducible on -rc2?

Rafael


> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.28-rc1 #58
> ---------------------------------------------
> cat/25690 is trying to acquire lock:
>  (&hashbin->hb_spinlock){....}, at: [<c1780e1f>] irias_seq_show+0x3f/0x180
> 
> but task is already holding lock:
>  (&hashbin->hb_spinlock){....}, at: [<c1780f95>] irias_seq_start+0x15/0x90
> 
> other info that might help us debug this:
> 2 locks held by cat/25690:
>  #0:  (&p->lock){--..}, at: [<c0502545>] seq_read+0x25/0x2e0
>  #1:  (&hashbin->hb_spinlock){....}, at: [<c1780f95>] irias_seq_start+0x15/0x90
> 
> stack backtrace:
> Pid: 25690, comm: cat Not tainted 2.6.28-rc1 #58
> Call Trace:
>  [<c195b5d6>] ? printk+0x18/0x1a
>  [<c048a0bb>] __lock_acquire+0xf0b/0xf80
>  [<c044c8da>] ? kmemcheck_hide_addr+0x4a/0x60
>  [<c042529b>] ? do_debug+0x3b/0x1b0
>  [<c048a1a1>] lock_acquire+0x71/0xa0
>  [<c1780e1f>] ? irias_seq_show+0x3f/0x180
>  [<c195e636>] _spin_lock+0x36/0x60
>  [<c1780e1f>] ? irias_seq_show+0x3f/0x180
>  [<c1780e1f>] irias_seq_show+0x3f/0x180
>  [<c050270c>] seq_read+0x1ec/0x2e0
>  [<c0502520>] ? seq_read+0x0/0x2e0
>  [<c05297ed>] proc_reg_read+0x5d/0x90
>  [<c04ea749>] vfs_read+0x99/0x160
>  [<c0529790>] ? proc_reg_read+0x0/0x90
>  [<c04ea8cd>] sys_read+0x3d/0x70
>  [<c0422f83>] sysenter_do_call+0x12/0x3f
>  [<c0420000>] ? svm_intr_assist+0x90/0x1a0
> 
> 
> Vegard
> 


