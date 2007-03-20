Return-Path: <linux-kernel-owner+w=401wt.eu-S1751060AbXCTQgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751060AbXCTQgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 12:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbXCTQgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 12:36:48 -0400
Received: from smtp.osdl.org ([65.172.181.24]:46549 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbXCTQgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:36:47 -0400
Date: Tue, 20 Mar 2007 08:36:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: mm snapshot broken-out-2007-03-18-02-44.tar.gz uploaded
Message-Id: <20070320083627.27d90a91.akpm@linux-foundation.org>
In-Reply-To: <45FF8A79.7010201@googlemail.com>
References: <200703180946.l2I9kTVc020636@shell0.pdx.osdl.net>
	<45FF8A79.7010201@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007 08:17:13 +0100 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> akpm@linux-foundation.org napisał(a):
> > The mm snapshot broken-out-2007-03-18-02-44.tar.gz has been uploaded to
> > 
> >    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-03-18-02-44.tar.gz
> > 
> > It contains the following patches against 2.6.21-rc4:
> 
> PM: Adding info for No Bus:vcsa7
> BUG: at kernel/lockdep.c:2430 check_flags()
>  [<c0105256>] show_trace_log_lvl+0x1a/0x2f
>  [<c010597b>] show_trace+0x12/0x14
>  [<c0105a3d>] dump_stack+0x16/0x18
>  [<c013e1b5>] check_flags+0xb7/0x187
>  [<c01413ea>] lock_acquire+0x3a/0x93
>  [<c0139a64>] down_write+0x3a/0x54
>  [<c0170563>] sys_munmap+0x23/0x3f
>  [<c0104270>] syscall_call+0x7/0xb
>  =======================
> irq event stamp: 302470
> hardirqs last  enabled at (302469): [<c0104391>] syscall_exit_work+0x11/0x26
> hardirqs last disabled at (302470): [<c0104119>] ret_from_exception+0x9/0xc
> softirqs last  enabled at (301928): [<c0128e58>] __do_softirq+0xe4/0xea
> softirqs last disabled at (301921): [<c0128e97>] do_softirq+0x39/0x55
> oprofile: using NMI interrupt.
> printk: 6 messages suppressed.

Don't know.  Several people seem to be hitting this.


> BUG: using smp_processor_id() in preemptible [00000001] code: mount/27913
> caller is avail_to_resrv_perfctr_nmi_bit+0x2b/0x43
>  [<c0105256>] show_trace_log_lvl+0x1a/0x2f
>  [<c010597b>] show_trace+0x12/0x14
>  [<c0105a3d>] dump_stack+0x16/0x18
>  [<c0213313>] debug_smp_processor_id+0xb3/0xc8
>  [<c0116a26>] avail_to_resrv_perfctr_nmi_bit+0x2b/0x43
>  [<fdc819b9>] nmi_create_files+0x2a/0x10e [oprofile]
>  [<fdc80f52>] oprofile_create_files+0xe6/0xec [oprofile]
>  [<fdc81157>] oprofilefs_fill_super+0x78/0x7e [oprofile]
>  [<c0182d2e>] get_sb_single+0x59/0x9f
>  [<fdc8108f>] oprofilefs_get_sb+0x1c/0x1e [oprofile]
>  [<c0182792>] vfs_kern_mount+0x81/0xf1
>  [<c0182852>] do_kern_mount+0x38/0xde
>  [<c0196671>] do_mount+0x605/0x693
>  [<c019677f>] sys_mount+0x80/0xb5
>  [<c0104270>] syscall_call+0x7/0xb
>  =======================

Odd.  It looks like oprofile has been doing this for some time.  Andi,
there are a few changes in the NMI area - can you think of one whihc would
have triggered this?

