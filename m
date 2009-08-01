Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262AbZHAUCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbZHAUCk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 16:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbZHAUCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 16:02:39 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:52816 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbZHAUCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 16:02:38 -0400
Date: Sun, 2 Aug 2009 01:32:00 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: memory-controller patch fails to boot in qemu [mmotm]
Message-ID: <20090801200200.GB8514@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <4A744C2A.6040009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4A744C2A.6040009@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jiri Slaby <jirislaby@gmail.com> [2009-08-01 16:07:38]:

> Hi,
> 
> in mmotm-2009-07-30-05-01, the patch named
> memory-controller-soft-limit-organize-cgroups-v9.patch
> causes qemu fail to boot with tons of:
> BUG: scheduling while atomic: async/2/480/0x10000002
> Modules linked in:
> Pid: 480, comm: async/2 Tainted: G       AW  2.6.31-rc4-mm1-bh #13
> Call Trace:
>  [<ffffffff81036b6c>] __schedule_bug+0x5c/0x70
>  [<ffffffff8140491b>] thread_return+0x5c1/0x786
>  [<ffffffff8103dd30>] __cond_resched+0x20/0x50
>  [<ffffffff81404b9d>] _cond_resched+0x2d/0x40
>  [<ffffffff81096694>] truncate_inode_pages_range+0x224/0x450
>  [<ffffffff8106dfa1>] ? smp_call_function_many+0x1e1/0x210
>  [<ffffffff810e50d0>] ? invalidate_bh_lru+0x0/0x90
>  [<ffffffff810e514b>] ? invalidate_bh_lru+0x7b/0x90
>  [<ffffffff810e50d0>] ? invalidate_bh_lru+0x0/0x90
>  [<ffffffff810968d0>] truncate_inode_pages+0x10/0x20
>  [<ffffffff810ea875>] kill_bdev+0x35/0x40
>  [<ffffffff810eba18>] __blkdev_put+0xa8/0x190
>  [<ffffffff810ebb0b>] blkdev_put+0xb/0x10
>  [<ffffffff81116f62>] register_disk+0x172/0x180
>  [<ffffffff8115bca5>] add_disk+0x85/0x150
>  [<ffffffff812398cf>] sd_probe_async+0x12f/0x200
>  [<ffffffff810616ca>] async_thread+0x10a/0x270
>  [<ffffffff8103f7a0>] ? default_wake_function+0x0/0x10
>  [<ffffffff810615c0>] ? async_thread+0x0/0x270
>  [<ffffffff8105ac66>] kthread+0x96/0xa0
>  [<ffffffff8100ceaa>] child_rip+0xa/0x20
>  [<ffffffff8105abd0>] ? kthread+0x0/0xa0
>  [<ffffffff8100cea0>] ? child_rip+0x0/0x20
> 
> Looks like an omitted unlock. I don't see anything suspicious in the
> patch though.


Thanks for the report, did you bisect the mmotm series to identify the
root cause? What does your .config look like? I tried kvm with the
patches (mmotm 30th July) and qemu-kvm (30th-july) with a Fedora 11
guest image and the system booted just fine for me.

Could you share your command line as well?


-- 
	Balbir
