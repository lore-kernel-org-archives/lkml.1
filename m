Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbYGHOnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbYGHOnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 10:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbYGHOnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 10:43:32 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:34765 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbYGHOna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 10:43:30 -0400
Message-ID: <48737CBE.4010301@linux.vnet.ibm.com>
Date: Tue, 08 Jul 2008 20:12:06 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080505)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       kernel-testers@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [BUG] 2.6.26-rc8-mm1 - sleeping function called from invalid context
 at include/linux/pagemap.h:291
References: <20080703020236.adaa51fa.akpm@linux-foundation.org>
In-Reply-To: <20080703020236.adaa51fa.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

While booting up and shutting down, x86 machine with 2.6.26-rc8-mm1 kernel,
kernel bug call trace is shows up in the logs

iscsid (pid 2163 2162) is running...
Setting up iSCSI targets: [   34.577226] BUG: sleeping function called from invalid context at include/linux/pagemap.h:291
[   34.602939] in_atomic():1, irqs_disabled():0
[   34.615866] 1 lock held by iscsid/2163:
[   34.627120]  #0:  (&mm->mmap_sem){----}, at: [<c046f393>] sys_munmap+0x23/0x3f
[   34.649978] Pid: 2163, comm: iscsid Not tainted 2.6.26-rc8-mm1-autotest #1
[   34.670212]  [<c041fdbb>] __might_sleep+0xb5/0xba
[   34.684660]  [<c046cbe9>] __munlock_pte_handler+0x44/0xf8
[   34.701053]  [<c0472007>] walk_page_range+0x15b/0x1b4
[   34.716574]  [<c046cb87>] __munlock_vma_pages_range+0x91/0x9e
[   34.734022]  [<c046ca08>] ? __munlock_pmd_handler+0x0/0x10
[   34.750860]  [<c046cba5>] ? __munlock_pte_handler+0x0/0xf8
[   34.767654]  [<c046cba3>] munlock_vma_pages_range+0xf/0x11
[   34.784328]  [<c046e42d>] do_munmap+0xe4/0x1d9
[   34.797857]  [<c046f3a0>] sys_munmap+0x30/0x3f
[   34.811451]  [<c04038c9>] sysenter_past_esp+0x6a/0xa5
[   34.826806]  =======================
[  OK  ]
[  OK  ]

While shutting down

Stopping Bluetooth services:[  OK  ]
Starting killall:  [  OK  ]
Sending all processes the TERM signal...
Sending all processes the KILL signal... [   76.982147] BUG: sleeping function called from invalid context at include/linux/pagemap.h:291
[   77.007777] in_atomic():1, irqs_disabled():0
[   77.020679] no locks held by iscsid/2163.
[   77.033260] Pid: 2163, comm: iscsid Not tainted 2.6.26-rc8-mm1-autotest #1
[   77.053985]  [<c041fdbb>] __might_sleep+0xb5/0xba
[   77.074205]  [<c046cbe9>]  __munlock_pte_handler+0x44/0xf8
[   77.098841]  [<c0472007>] walk_page_range+0x15b/0x1b4
[   77.115703]  [<c046cb87>] __munlock_vma_pages_range+0x91/0x9e
[   77.133117]  [<c046ca08>] ? __munlock_pmd_handler+0x0/0x10
[   77.149880]  [<c046cba5>] ? __munlock_pte_handler+0x0/0xf8
[   77.166634]  [<c046cba3>] munlock_vma_pages_range+0xf/0x11
[   77.183268]  [<c046db3d>] exit_mmap+0x32/0xf2
[   77.196525]  [<c0427cdc>] ? exit_mm+0xc7/0xd3
[   77.209911]  [<c0424782>] mmput+0x50/0xba
[   77.222130]  [<c0427ce3>] exit_mm+0xce/0xd3
[   77.234872]  [<c0428fe2>] do_exit+0x20b/0x617
[   77.248128]  [<c04410d6>] ? trace_hardirqs_on+0xb/0xd
[   77.263601]  [<c042944d>] do_group_exit+0x5f/0x88
[   77.277994]  [<c0430ebd>] get_signal_to_deliver+0x2eb/0x32a
[   77.294997]  [<c0402fe9>] do_notify_resume+0x93/0x74e
[   77.310437]  [<c0442042>] ? __lock_acquire+0xbb7/0xbfb
[   77.327268]  [<c04081ad>] ? native_sched_clock+0x84/0x96
[   77.342650]  [<c043f314>] ? trace_hardirqs_off+0xb/0xd
[   77.358450]  [<c04081ad>] ? native_sched_clock+0x84/0x96
[   77.374827]  [<c0403a1a>] work_notifysig+0x13/0x19
[   77.389505]  =======================
[   77.632224] type=1111 audit(1215512324.000:11): user pid=3484 uid=0 auid=4294967295 ses=4294967295 msg='changing system time: exe="/sbin/hwclock" (hostname=?, addr=?, terminal=console res=success)'
Turning off swap:
Turning off quotas:  
Unmounting pipe file systems: 
Please stand by while rebooting the system...
[   82.377079] md: stopping all md devices.
[   83.930821] Restarting system.
[   83.940099] machine restart


0xc046f393 is in sys_munmap (mm/mmap.c:1968).
1963            struct mm_struct *mm = current->mm;
1964
1965            profile_munmap(addr);
1966
1967            down_write(&mm->mmap_sem);
1968            ret = do_munmap(mm, addr, len);
1969            up_write(&mm->mmap_sem);
1970            return ret;
1971    }
1972

0xc046cbe9 is in __munlock_pte_handler (include/linux/pagemap.h:291).
286     /*
287      * lock_page may only be called if we have the page's inode pinned.
288      */
289     static inline void lock_page(struct page *page)
290     {
291             might_sleep();
292             if (TestSetPageLocked(page))
293                     __lock_page(page);
294     }
295

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
