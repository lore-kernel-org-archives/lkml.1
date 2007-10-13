Return-Path: <linux-kernel-owner+w=401wt.eu-S1761119AbXJMG4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761119AbXJMG4z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 02:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbXJMG4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 02:56:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48135 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751706AbXJMG4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 02:56:45 -0400
Date: Fri, 12 Oct 2007 23:56:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 2.6.23-rc8-mm2 - call trace at kernel/lockdep.c:2664
Message-Id: <20071012235636.7237ccff.akpm@linux-foundation.org>
In-Reply-To: <471063E5.8050706@linux.vnet.ibm.com>
References: <471063E5.8050706@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Oct 2007 11:51:25 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi Andrew,
> 
> Following call trace is seen will booting up the machine. Similar
> call trace was reported for 2.6.23-rc3-mm1 at
> http://lkml.org/lkml/2007/8/26/77
> 
> Mount-cache hash table entries: 512
> WARNING: at kernel/lockdep.c:2664 check_flags()
>  [<c010612f>] dump_trace+0x68/0x1d2
>  [<c01062b1>] show_trace_log_lvl+0x18/0x2c
>  [<c0106c23>] show_trace+0xf/0x11
>  [<c0106d33>] dump_stack+0x12/0x14
>  [<c01414ac>] check_flags+0x92/0x145
>  [<c0144426>] lock_acquire+0x2f/0x8a
>  [<c0509771>] _spin_lock+0x33/0x3e
>  [<c0180e2b>] ifind+0x16/0x7f
>  [<c0180eff>] ilookup5_nowait+0x33/0x38
>  [<c01a793d>] sysfs_addrm_start+0x36/0x84
>  [<c01a7dc7>] create_dir+0x37/0x86
>  [<c01a7e43>] sysfs_create_dir+0x2d/0x40
>  [<c029ab5e>] kobject_add+0xe9/0x190
>  [<c029ac26>] kset_register+0x19/0x2e
>  [<c07a58a7>] mnt_init+0xe0/0x1be
>  [<c07a552a>] vfs_caches_init+0x11e/0x12e
>  [<c07938e5>] start_kernel+0x2ed/0x318
>  =======================
> irq event stamp: 1139108
> hardirqs last  enabled at (1139108): [<c05085a4>] __mutex_lock_slowpath+0x24d/0x273
> hardirqs last disabled at (1139107): [<c0124221>] cpu_clock+0xd/0x4c
> softirqs last  enabled at (1138798): [<c012d2b5>] do_softirq+0x36/0x51
> softirqs last disabled at (1138793): [<c012d2b5>] do_softirq+0x36/0x51
> CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0004e3bd 00000000 00000001 00000000
> 

Were kprobes/jprobes in use?  If so, 2.6.23-mm1's
lockdep-annotate-kprobes-irq-fiddling.patch should help.  
