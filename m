Return-Path: <linux-kernel-owner+w=401wt.eu-S1757043AbXEZHMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043AbXEZHMh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 03:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbXEZHMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 03:12:30 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:48994 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbXEZHM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 03:12:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=JITBXR4WWtb/sv4usAZra+oqfaXSxadINcQ1qHinQ7tuSBDy4v7/LJGrhH4fJ6uXmq0ldNIC6EjdObGkp6QAhwQqFoZy5bQElgTa0YQtOKfaKt7/eS6Tq+LzolNZ2BG9Lv9LQmOJH87n8r3bLYLYl1Zeyd1/B+xihie7QnCwcpI=
Date: Sat, 26 May 2007 02:29:07 -0400
To: Reiner Sailer <sailer@us.ibm.com>
Cc: jfannin@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, safford@us.ibm.com, zohar@us.ibm.com,
       serue@us.ibm.com
Subject: Re: 2.6.22-rc1-mm1: evm BUG when reading sysfs file
Message-ID: <20070526062906.GA26553@nineveh.local>
Mail-Followup-To: Reiner Sailer <sailer@us.ibm.com>, jfannin@gmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, safford@us.ibm.com, zohar@us.ibm.com,
	serue@us.ibm.com
References: <OF221AC3A7.91DF97D1-ON852572E6.007E756B-852572E7.000D90F8@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF221AC3A7.91DF97D1-ON852572E6.007E756B-852572E7.000D90F8@us.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: jfannin@gmail.com (Joseph Fannin)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 10:28:22PM -0400, Reiner Sailer wrote:
> On Tue, 22 May 2007 03:25:48 -0400
> jfannin@gmail.com (Joseph Fannin) wrote:
>

> > I've been getting this since 2.6.21-rc7-mm1:

> > [    2.379310] BUG: unable to handle kernel paging request at virtual address 4400d340
> > [    2.379491]  printing eip:
> > [    2.379573] c021c978
> > [    2.379656] *pdpt = 000000000353c001
> > [    2.379739] *pde = 0000000000000000
> > [    2.379824] Oops: 0000 [#1]
> > [    2.379906] PREEMPT SMP
> > [    2.380059] Modules linked in: thermal processor dm_mod
> > [    2.380288] CPU:    0
> > [    2.380289] EIP:    0060:[<c021c978>]    Not tainted VLI
> > [    2.380291] EFLAGS: 00010297   (2.6.22-rc1-mm1 #2)
> > [    2.380547] EIP is at vsnprintf+0x448/0x5d0
> > [    2.380633] eax: 4400d340   ebx: c348f034   ecx: 4400d340   edx: fffffffe
> > [    2.380721] esi: c03e0100   edi: 4400d340   ebp: c357ecc0   esp: c357ec68
> > [    2.380810] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> > [    2.380898] Process udevtrigger (pid: 686, ti=c357e000 task=c1876df0 task.ti=c357e000)
> > [    2.380987] Stack: c348f014 00000fec c03e1c60 c03e3cec c357eccc c0499b88 c357ece0 c0282513
> > [    2.381428]        c348f014 00000fec 3cb70fcb c348f034 ffffffff 00000000 ffffffff ffffffff
> > [    2.381867]        ffffffff fffffffe c03e017c c357ed18 00000034 c0494a20 c357ece0 c021cb9f
> > [    2.382305] Call Trace:
> > [    2.382470]  [<c021cb9f>] sprintf+0x1f/0x30
> > [    2.382594]  [<c02815ed>] show_uevent+0xed/0x130
> > [    2.382720]  [<c0281163>] dev_attr_show+0x23/0x30
> > [    2.382843]  [<c01dc077>] sysfs_read_file+0x97/0x140
> > [    2.382968]  [<c019502f>] vfs_read+0xaf/0x180
> > [    2.383096]  [<c0198c3a>] kernel_read+0x3a/0x50
> > [    2.383221]  [<c01f126c>] evm_calc_hash+0x11c/0x240
> > [    2.383347]  [<c01efd39>] evm_file_free+0xb9/0x330
> > [    2.383470]  [<c0195a3a>] __fput+0xba/0x180
> > [    2.383593]  [<c0195c32>] fput+0x22/0x40
> > [    2.383715]  [<c0192e07>] filp_close+0x47/0x70
> > [    2.383839]  [<c0194109>] sys_close+0x69/0xc0
> > [    2.383965]  [<c01043c8>] syscall_call+0x7/0xb
> > [    2.384092]  [<b7ebd0a7>] 0xb7ebd0a7
> > [    2.384212]  =======================
> > [    2.384295] INFO: lockdep is turned off.
> > [    2.384379] Code: 21 fd ff ff c6 03 25 e9 19 fd ff ff 8d 4f 04 b8
> > 3b a2 3d c0 8b 55 e4 89 4d 08 8b 3f 81 ff ff 0f 00 00 0f 46 f8 89 f9
> > 89 c8 eb 06 <80> 38 00 74 07 40 4a 83 fa ff 75 f4 29 c8 89 c6 8b 45 e0
> > f6 45
> > [    2.386787] EIP: [<c021c978>] vsnprintf+0x448/0x5d0 SS:ESP
> > 0068:c357ec68

>
> Joseph,
>
> thank you for posting this problem. I cannot reconstruct it on my machine.
>
> Could you tell us which kernel configuration you used (drivers/char/tpm
> and security settings) ?
> Does it disappear when IMA is disabled in the kernel config?

    I've found that disabling CONFIG_SYSFS_DEPRECATED makes the
BUG message go away; maybe that's what you're missing?

    I've also attached my .config -- but it has lots of stuff turned
on, so it may be faster to try flipping CONFIG_SYSFS_DEPRECATED on a
slimmer config, if you'd like.

    Disabling IMA doesn't change the message; it's still there.

    Thanks!
--
Joseph Fannin
jfannin@gmail.com

