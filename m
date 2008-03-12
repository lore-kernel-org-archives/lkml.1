Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbYCLDDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbYCLDDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 23:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbYCLDDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 23:03:41 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:46420 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbYCLDDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 23:03:41 -0400
Subject: Re: [2.6.25-rc5-mm1] BUG() at mnt_want_write().
From: Dave Hansen <haveblue@us.ibm.com>
To: penguin-kernel@i-love.sakura.ne.jp
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
In-Reply-To: <200803120137.m2C1bffL037440@www262.sakura.ne.jp>
References: <200803120137.m2C1bffL037440@www262.sakura.ne.jp>
Content-Type: text/plain
Date: Tue, 11 Mar 2008 20:03:30 -0700
Message-Id: <1205291010.9828.60.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-12 at 10:37 +0900, penguin-kernel@i-love.sakura.ne.jp
...
> checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> Brought up 2 CPUs
> khelper used greatest stack depth: 2684 bytes left
> net_namespace: 320 bytes
> NET: Registered protocol family 16
> INFO: trying to register non-static key.
> the code is fine but needs lockdep annotation.
> turning off the locking correctness validator.
> Pid: 1, comm: swapper Not tainted 2.6.25-rc5-mm1 #1
>  [<c013dd91>] __lock_acquire+0x194/0x6a3
>  [<c0167ded>] ? cache_free_debugcheck+0x1fd/0x219
>  [<c0168938>] ? kfree+0xdb/0xe5
>  [<c013e775>] lock_acquire+0x6a/0x87
>  [<c01368e4>] ? down+0xc/0x2f
>  [<c03492b1>] _spin_lock_irqsave+0x25/0x55
>  [<c01368e4>] ? down+0xc/0x2f
>  [<c01368e4>] down+0xc/0x2f
>  [<c022caf3>] device_add+0x152/0x243
>  [<c022cbf6>] device_register+0x12/0x15
>  [<c022ce9b>] device_create+0x76/0x90
>  [<c04a1861>] vtconsole_class_init+0x72/0xb9
>  [<c048d8ae>] ? kernel_init+0x0/0x88
>  [<c048d784>] do_initcalls+0x59/0x134
>  [<c014bcb1>] ? register_irq_proc+0xb1/0xca
>  [<c01a0000>] ? proc_symlink+0x5/0x73
>  [<c048d8ae>] ? kernel_init+0x0/0x88
>  [<c048d87b>] do_basic_setup+0x1c/0x1e
>  [<c048d8fb>] kernel_init+0x4d/0x88
>  [<c01045b7>] kernel_thread_helper+0x7/0x10
>  =======================

What is that, btw?? ^^

> BUG: unable to handle kernel paging request at de92efe8
> IP: [<c017e0bb>] mnt_want_write+0x40/0x5f
> *pde = 1ec02163 *pte = 1e92e160
> Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
> last sysfs file:
> Modules linked in:
> 
> Pid: 1, comm: init Not tainted (2.6.25-rc5-mm1 #1)
> EIP: 0060:[<c017e0bb>] EFLAGS: 00010286 CPU: 1
> EIP is at mnt_want_write+0x40/0x5f
> EAX: 00000000 EBX: c14a3460 ECX: 00000001 EDX: de92ef78
> ESI: de926f78 EDI: 00000000 EBP: df8e1ef8 ESP: df8e1eec
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process init (pid: 1, ti=df8e1000 task=df8f8020 task.ti=df8e1000)
> Stack: ffffffeb 00000200 df8e1f28 df8e1f84 c017346d 00000003 00000000 df8f8020
>        00000002 00008242 00000000 00000002 00008241 de926f78 df55ff50 de926f78
>        df55ff50 92aaee34 0000000d df24f010 00000300 00000000 00000000 df8e1f60
> Call Trace:
>  [<c017346d>] ? do_filp_open+0x233/0x52f
>  [<c03496b3>] ? _spin_unlock+0x1d/0x20
>  [<c016aaac>] ? do_sys_open+0x3f/0xbe
>  [<c016ab41>] ? sys_open+0x16/0x18
>  [<c0103966>] ? syscall_call+0x7/0xb
>  =======================
> Code: 53 8d 1c 02 89 d8 e8 c7 b4 1c 00 89 f0 e8 7e ff ff ff 85 c0 74 07 bf e2 ff ff ff eb 1f 8b 53 2c 39 f2 74 15 85 d2 74 0e 8b 43 28 <f0> 01 42 70 c7 43 28
>  00 00 00 00 89 73 2c ff 43 28 89 d8 e8 c3
> EIP: [<c017e0bb>] mnt_want_write+0x40/0x5f SS:ESP 0068:df8e1eec
> ---[ end trace 6f0b2838d1d55c90 ]---
> Kernel panic - not syncing: Attempted to kill init!

Looks to me like you passed a null vfsmount into mnt_want_write().  

Could you stick a printk() into do_sys_open() and see what file it is
trying to open?  My guess is that it is either cramfs or the ramdisk
code causing trouble.  I'll look into it in more detail, but the
printk() would still be a good data point.

-- Dave

