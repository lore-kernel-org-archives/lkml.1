Return-Path: <linux-kernel-owner+w=401wt.eu-S1760389AbYHUSqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760389AbYHUSqB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754635AbYHUSpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:45:54 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:13088 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbYHUSpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:45:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Rap4MMiNPFE3hYCcZ/Hp8TslBr0wT54gJ7oSh5G4F6AR+PfCXMgQEITb0SCp8KjCOo
         zA7ayRRw+Sa0IdoclqoKDAgWR5zNIXrWERvV0SW3CWI3/FO2/bwh/nHwSMbdqoFbzkll
         MM3nPXCgERmzqkkEbeKDaOW9h3Sgm0ML5lRIw=
Message-ID: <19f34abd0808211145y1c3d5aedwf8e918afeba9cc98@mail.gmail.com>
Date: Thu, 21 Aug 2008 20:45:51 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: latest -git: suspend: unable to handle kernel paging request (was Re: no_console_suspend doesn't work?)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <19f34abd0808211121l25e6b187p93db789607c2af30@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808211028w7889587fke523ff244339e7c5@mail.gmail.com>
	 <200808212010.06043.rjw@sisk.pl>
	 <19f34abd0808211121l25e6b187p93db789607c2af30@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 8:21 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> I got a "proper" oops this time (brace yourself, it's long ;-)), and
> it does not have serial on the stack:
>
> BUG: unable to handle kernel paging request at 00100104
> IP: [<c038ad65>] __list_add+0x15/0x90
> *pdpt = 00000000325bb001 *pde = 0000000000000000
> Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> Pid: 3597, comm: bash Not tainted (2.6.27-rc4-00003-ga798564-dirty #30)
> EIP: 0060:[<c038ad65>] EFLAGS: 00210082 CPU: 0
> EIP is at __list_add+0x15/0x90

This one is slightly different:

WARNING: at lib/list_debug.c:26 __list_add+0x61/0x90()
list_add corruption. next->prev should be prev (c088e34c), but was
00200200. (next=f7814774).
Pid: 3572, comm: bash Not tainted 2.6.27-rc4-00003-ga798564-dirty #30
 [<c013a56e>] warn_slowpath+0x5e/0x80
 [<c015f7bf>] ? validate_chain+0x7df/0xe90
 [<c014c4e8>] ? __kernel_text_address+0x8/0x20
 [<c01600ea>] ? __lock_acquire+0x27a/0xa00
 [<c015b60e>] ? get_lock_stats+0x1e/0x50
 [<c015b64d>] ? put_lock_stats+0xd/0x30
 [<c038adb1>] __list_add+0x61/0x90
 [<c01b3208>] deactivate_slab+0x158/0x1b0
 [<c01b3ea5>] __slab_alloc+0x105/0x4e0
 [<c015b60e>] ? get_lock_stats+0x1e/0x50
 [<c01b4424>] kmem_cache_alloc+0xb4/0xe0
 [<c052a51b>] ? serio_queue_event+0x6b/0xe0
 [<c052a51b>] ? serio_queue_event+0x6b/0xe0
 [<c052a51b>] serio_queue_event+0x6b/0xe0
 [<c015e91b>] ? trace_hardirqs_on+0xb/0x10
 [<c052a5b8>] serio_resume+0x28/0x30
 [<c03f8bde>] device_resume+0x32e/0x380
 [<c0168791>] hibernation_snapshot+0xa1/0x220
 [<c013b55b>] ? printk+0x1b/0x20
 [<c01689f0>] hibernate+0xe0/0x180
 [<c01674a0>] ? state_store+0x0/0xd0
 [<c016755f>] state_store+0xbf/0xd0
 [<c01674a0>] ? state_store+0x0/0xd0
 [<c0375ef4>] kobj_attr_store+0x24/0x30
 [<c01fa432>] sysfs_write_file+0xa2/0x100
 [<c01bbf06>] vfs_write+0x96/0x130
 [<c01fa390>] ? sysfs_write_file+0x0/0x100
 [<c01bc44d>] sys_write+0x3d/0x70
 [<c0104f3b>] sysenter_do_call+0x12/0x3f
 =======================
---[ end trace 0bc52e2837e4b8b8 ]---

...followed by the "unable to handle kernel paging request" as in
previous e-mail. The numbers 00100104 and 00200200 seem to appear all
the time.

At least it is 100% reproducible now and with nice oopses too :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
