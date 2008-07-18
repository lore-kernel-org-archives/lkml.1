Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbYGRIoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbYGRIoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 04:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbYGRInx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 04:43:53 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:37951 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbYGRInw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 04:43:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LgaA3DjFa7NBTWYWd3s6rR+SdLoy9q4BxiZQQ+g6pygC2AMNy+bgRvHgwWSYgKG6t4
         bCV6upI2inJw6aM4z8UzzT3IScYVKHdiJGtdCa+1v4iKidPh4GAxRUjyLteHstEfIjED
         bNPh9FYQgqQnmApvZUkuxSYSCVl7qYcGErmYY=
Message-ID: <19f34abd0807180143x7afe779du8bfc5eb87f8800bb@mail.gmail.com>
Date: Fri, 18 Jul 2008 10:43:51 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>
Subject: Re: latest -git: BUG at fs/jfs/namei.c:512 assert(ip->i_nlink)
Cc: jfs-discussion@lists.sourceforge.net,
       "Johannes Weiner" <hannes@saeurebad.de>, linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0807180129k5d7e64a0nd86bbd6333df72d2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807171135m4a3b39e6v4065ed676720ae46@mail.gmail.com>
	 <1216336164.32175.3.camel@norville.austin.ibm.com>
	 <19f34abd0807180110k5a19e525y463b59208f0587b2@mail.gmail.com>
	 <19f34abd0807180129k5d7e64a0nd86bbd6333df72d2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 10:29 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> BUG: unable to handle kernel paging request at c08845af
> IP: [<c02f9122>] release_metapage+0x32/0x1c0

Hi,

I am still unable to see the "already zero" message. I'll post this as
well because it looks completely different:

------------[ cut here ]------------
WARNING: at kernel/mutex.c:134 mutex_lock_nested+0x2d4/0x320()
Pid: 5335, comm: cp Not tainted 2.6.26-03415-gdf3030b #45
 [<c0135b6f>] warn_on_slowpath+0x4f/0xa0
 [<c015b6e9>] ? __lock_acquire+0x2c9/0x1110
 [<c015906b>] ? trace_hardirqs_off+0xb/0x10
 [<c015ab70>] ? mark_held_locks+0x40/0x80
 [<c015addb>] ? trace_hardirqs_on+0xb/0x10
 [<c015ad76>] ? trace_hardirqs_on_caller+0x116/0x170
 [<c0748da4>] mutex_lock_nested+0x2d4/0x320
 [<c02eb38b>] ? diAlloc+0x28b/0x680
 [<c02eb38b>] diAlloc+0x28b/0x680
 [<c074a6d7>] ? _spin_unlock+0x27/0x50
 [<c02f7bc9>] ialloc+0x49/0x320
 [<c02dffa7>] jfs_mkdir+0x77/0x3c0
 [<c015906b>] ? trace_hardirqs_off+0xb/0x10
 [<c015addb>] ? trace_hardirqs_on+0xb/0x10
 [<c015906b>] ? trace_hardirqs_off+0xb/0x10
 [<c03030b0>] ? jfs_permission+0x0/0x10
 [<c02dff30>] ? jfs_mkdir+0x0/0x3c0
 [<c01acb27>] vfs_mkdir+0xb7/0x130
 [<c074a6d7>] ? _spin_unlock+0x27/0x50
 [<c01af4b8>] sys_mkdirat+0xe8/0x100
 [<c0430948>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0120140>] ? do_page_fault+0x0/0x880
 [<c01af4f0>] sys_mkdir+0x20/0x30
 [<c010407f>] sysenter_past_esp+0x78/0xc5
 =======================
---[ end trace 010115e08457f5d6 ]---
BUG: unable to handle kernel paging request at fff7f7f7
IP: [<c04401b0>] __list_add+0x10/0x70
*pde = 00007067 *pte = 00000000
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Pid: 5335, comm: cp Tainted: G        W (2.6.26-03415-gdf3030b #45)
EIP: 0060:[<c04401b0>] EFLAGS: 00210046 CPU: 1
EIP is at __list_add+0x10/0x70
EAX: fff7f7f7 EBX: e5b77d88 ECX: e5f68a70 EDX: fff7f7f7
ESI: e5f68a50 EDI: 00200246 EBP: e5b77d60 ESP: e5b77d4c
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process cp (pid: 5335, ti=e5b76000 task=f69acfb0 task.ti=e5b76000)
Stack: c02eb38b e5f68a84 e5f68a4c e5f68a50 e5f68a4c e5b77da8 c0748baa 00000000
       00000002 c02eb38b c02eb38b 00000000 f69acfb0 e5f68a70 e5f68a84 e5b77d88
       e5b77d88 11111111 e5f68a4c e5b77d88 de0a9d8c de0a82d4 de0a9d8c e5b77e0c
Call Trace:
 [<c02eb38b>] ? diAlloc+0x28b/0x680
 [<c0748baa>] ? mutex_lock_nested+0xda/0x320
 [<c02eb38b>] ? diAlloc+0x28b/0x680
 [<c02eb38b>] ? diAlloc+0x28b/0x680
 [<c02eb38b>] ? diAlloc+0x28b/0x680
 [<c074a6d7>] ? _spin_unlock+0x27/0x50
 [<c02f7bc9>] ? ialloc+0x49/0x320
 [<c02dffa7>] ? jfs_mkdir+0x77/0x3c0
 [<c015906b>] ? trace_hardirqs_off+0xb/0x10
 [<c015addb>] ? trace_hardirqs_on+0xb/0x10
 [<c015906b>] ? trace_hardirqs_off+0xb/0x10
 [<c03030b0>] ? jfs_permission+0x0/0x10
 [<c02dff30>] ? jfs_mkdir+0x0/0x3c0
 [<c01acb27>] ? vfs_mkdir+0xb7/0x130
 [<c074a6d7>] ? _spin_unlock+0x27/0x50
 [<c01af4b8>] ? sys_mkdirat+0xe8/0x100
 [<c0430948>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0120140>] ? do_page_fault+0x0/0x880
 [<c01af4f0>] ? sys_mkdir+0x20/0x30
 [<c010407f>] ? sysenter_past_esp+0x78/0xc5
 =======================
Code: 54 24 04 c7 04 24 80 59 88 c0 e8 20 bf 30 00 0f 0b eb fe 90 8d
b4 26 00 00 00 00 55 89 e5 53 89 c3 83 ec 10 8b 41 04 39 d0 75 16 <8b>
10 39 ca 75 32 89 5a 04 89 13 89 43 04 89 18 83 c4 10 5b 5d
EIP: [<c04401b0>] __list_add+0x10/0x70 SS:ESP 0068:e5b77d4c
Kernel panic - not syncing: Fatal exception

(Followed by similar smp_call_function warnings as before.)

But I think I'll stop testing now until we have another patch.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
