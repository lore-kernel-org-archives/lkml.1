Return-Path: <linux-kernel-owner+w=401wt.eu-S933306AbXCHUug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306AbXCHUug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 15:50:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933219AbXCHUug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 15:50:36 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:36503 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933306AbXCHUuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 15:50:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=M/n+AsAIpUvvXg+QxZ6ybKkpRvU6PY/T9ty7Gim5BfWPugl7mAkYrg3yW9mUTaglARGRW2YeA+YsmlpH65CReIhFx117o8OUu1O0R99wdTdSwcKTIOlG82smiIYMGz7jS7jCZdk3YcFh+bBbpZxGAZEiJza/jQTLE9mxsrrBFPE=
Message-ID: <45F07715.9090502@googlemail.com>
Date: Thu, 08 Mar 2007 21:50:29 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc3-mm1
References: <20070307201839.6f45735b.akpm@linux-foundation.org>
In-Reply-To: <20070307201839.6f45735b.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napisał(a):
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc3-mm1/
> 
> Will appear later at
> 
>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc3/2.6.21-rc3-mm1/
> 

cpu_hotplug (AutoTest) hangs at this

=============================================
[ INFO: possible recursive locking detected ]
2.6.21-rc3-mm1 #2
---------------------------------------------
sh/7213 is trying to acquire lock:
 (sched_hotcpu_mutex){--..}, at: [<c033883a>] mutex_lock+0x1c/0x1f

but task is already holding lock:
 (sched_hotcpu_mutex){--..}, at: [<c033883a>] mutex_lock+0x1c/0x1f

other info that might help us debug this:
4 locks held by sh/7213:
 #0:  (cpu_add_remove_lock){--..}, at: [<c033883a>] mutex_lock+0x1c/0x1f
 #1:  (sched_hotcpu_mutex){--..}, at: [<c033883a>] mutex_lock+0x1c/0x1f
 #2:  (cache_chain_mutex){--..}, at: [<c033883a>] mutex_lock+0x1c/0x1f
 #3:  (workqueue_mutex){--..}, at: [<c033883a>] mutex_lock+0x1c/0x1f

stack backtrace:
 [<c0105256>] show_trace_log_lvl+0x1a/0x2f
 [<c010597b>] show_trace+0x12/0x14
 [<c0105a3d>] dump_stack+0x16/0x18
 [<c013fc73>] __lock_acquire+0x1aa/0xceb
 [<c014082d>] lock_acquire+0x79/0x93
 [<c03385dc>] __mutex_lock_slowpath+0x107/0x349
 [<c033883a>] mutex_lock+0x1c/0x1f
 [<c011d924>] sched_getaffinity+0x14/0x91
 [<c015796d>] __synchronize_sched+0x11/0x5f
 [<c011d257>] detach_destroy_domains+0x2c/0x30
 [<c011fc1a>] update_sched_domains+0x27/0x3a
 [<c012fe7a>] notifier_call_chain+0x2b/0x4a
 [<c012fec6>] __raw_notifier_call_chain+0x19/0x1e
 [<c0145756>] _cpu_down+0x70/0x282
 [<c014598e>] cpu_down+0x26/0x38
 [<c0272714>] store_online+0x27/0x5a
 [<c026f610>] sysdev_store+0x20/0x25
 [<c01b7a8e>] sysfs_write_file+0xc1/0xe9
 [<c0180052>] vfs_write+0xd1/0x15a
 [<c0180682>] sys_write+0x3d/0x72
 [<c0104270>] syscall_call+0x7/0xb

l *0xc033883a
0xc033883a is in mutex_lock (/mnt/md0/devel/linux-mm/kernel/mutex.c:92).
87              /*
88               * The locking fastpath is the 1->0 transition from
89               * 'unlocked' into 'locked' state.
90               */
91              __mutex_fastpath_lock(&lock->count, __mutex_lock_slowpath);
92      }
93
94      EXPORT_SYMBOL(mutex_lock);
95
96      static void fastcall noinline __sched

I didn't test other -mm's with this test.

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc3-mm1/console.log
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc3-mm1/mm-config

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
