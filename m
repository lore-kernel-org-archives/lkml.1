Return-Path: <linux-kernel-owner+w=401wt.eu-S1758147AbYG0ROc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbYG0ROc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 13:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbYG0ROZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 13:14:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:38795 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbYG0ROX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 13:14:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fXHbwiEWdXCsy7X/8opZtvdR+aMhQyMzevibeuFFGakUiIbmXkwYYJTNNd8hSmmYqO
         qZ6urCnrt5z/vM32ZSLfj7fTGi+Hucy4BkLab179UXPg9WH+FUPFtG671dAYgqCeD5kL
         g9fkQcvSbVGNuQV76FmX7/OXF6r0YRE42/B8o=
Message-ID: <b647ffbd0807271014j17d1a14cncd0976ff4d3ff3fd@mail.gmail.com>
Date: Sun, 27 Jul 2008 19:14:22 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: -git: BUG: unable to handle kernel paging request at c0100248 [CPU hotplug]
Cc: lkml <linux-kernel@vger.kernel.org>, "Thomas Meyer" <thomas@m3y3r.de>,
       "the arch/x86 maintainers" <x86@kernel.org>
In-Reply-To: <19f34abd0807270255o1ff260a8ucb9d931905aa4947@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807270255o1ff260a8ucb9d931905aa4947@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/27 Vegard Nossum <vegard.nossum@gmail.com>:
> Hi,
>
> Something broke CPU-hotplug _again_, here with a freshly built latest -git:
>
> BUG: unable to handle kernel paging request at c0100248
> IP: [<c067c3db>] native_cpu_up+0x26b/0x880
> *pde = 00cc9067 *pte = 00100161
> Oops: 0003 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> Pid: 3849, comm: bash Not tainted (2.6.26-07588-g5d1201a #5)
> EIP: 0060:[<c067c3db>] EFLAGS: 00210282 CPU: 0
> EIP is at native_cpu_up+0x26b/0x880
> EAX: c08f9000 EBX: c08fa028 ECX: 01669000 EDX: c08f7004
> ESI: 00000001 EDI: 00000000 EBP: f5bd9ed8 ESP: f5bd9dfc
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process bash (pid: 3849, ti=f5bd8000 task=f480bfc0 task.ti=f5bd8000)
> Stack: 00000000 c01e2153 f5bd9e3c f5992bb0 00000001 00000001 c01e2193 f5bd9e30
>       c01e2223 f59929a0 f5bd9e3c f5992bb0 00000000 00000000 dead4ead ffffffff
>       ffffffff c0889bc0 ffffffe0 f5bd9eec f5bd9ec4 f5bd9ea8 00000000 f5bd9e88
> Call Trace:
>  [<c01e2153>] ? __sysfs_add_one+0x63/0x90
>  [<c01e2193>] ? sysfs_add_one+0x13/0x50
>  [<c01e2223>] ? sysfs_addrm_start+0x53/0xa0
>  [<c01e3811>] ? internal_create_group+0xd1/0x180
>  [<c067bdc0>] ? do_fork_idle+0x0/0x20
>  [<c014db69>] ? __raw_notifier_call_chain+0x19/0x20
>  [<c067dbc3>] ? _cpu_up+0x83/0x100
>  [<c067dc89>] ? cpu_up+0x49/0x80
>  [<c065eb58>] ? store_online+0x58/0x80
>  [<c065eb00>] ? store_online+0x0/0x80
>  [<c03f443c>] ? sysdev_store+0x2c/0x40
>  [<c01e16d2>] ? sysfs_write_file+0xa2/0x100
>  [<c01a35a6>] ? vfs_write+0x96/0x130
>  [<c01e1630>] ? sysfs_write_file+0x0/0x100
>  [<c01a3aed>] ? sys_write+0x3d/0x70
>  [<c0103f5b>] ? sysenter_do_call+0x12/0x3f
>  =======================
> Code: 34 ff ff ff b8 00 70 8f c0 03 04 95 80 8e 89 c0 8b 55 a8 89 10 8b 85 34 ff
>  ff ff e8 f0 0a 00 00 8b b5 34 ff ff ff b8 00 90 8f c0 <c7> 05 48 02 10 c0 f0 c9
>  67 c0 03 04 b5 80 8e 89 c0 a3 2e 31 81
>
> c067c3db:       c7 05 48 02 10 c0 f0    movl   $0xc067c9f0,0xc0100248
> c067c3e2:       c9 67 c0
>
> $ addr2line -e vmlinux -i c067c3db
> arch/x86/kernel/smpboot.c:859
> arch/x86/kernel/smpboot.c:993
>
> Hm... that doesn't really make sense, does it? It's this line:
>
>        initial_code = (unsigned long)start_secondary;
>
> ..but I don't see where the memory dereference comes from.
>
>
> I can reproduce it every time, simply by bringing CPU 1 down and up.

cpu_up() is also executed during an initial boot-up of your system
(for non boot-up cpus).
You should see it with "dmesg | grep "Booting processor".

So it has not caused any problems at that time... maybe something to
do with __initdata.
[ I'm a bit short of time so just speculating here :-) ]


>
> Vegard
>

-- 
Best regards,
Dmitry Adamushko
