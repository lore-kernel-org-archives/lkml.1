Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbZBKD41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbZBKD41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 22:56:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbZBKD4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 22:56:18 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:43876 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbZBKD4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 22:56:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f6PwS7o0RSWk7Bk3YIPbcc5WiS1HHG9M8DinoKSf3erGMViVJ9YfkFHz3Dm/Ic1S/R
         4pCVtLHLuK2/OBz+UR6zIx4U0na93eiyWewMC0UmZy9H78M/XskGoJPm5THTehHjUwZd
         gh2S6rRzfMg2QI0LDRqtAkDjBthaU2mT3CdlY=
MIME-Version: 1.0
In-Reply-To: <20090210162708.6FBF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20090210142443.629E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <19f34abd0902092310g513fb776s2e4d37285c8fa7be@mail.gmail.com>
	 <20090210162708.6FBF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Date: Wed, 11 Feb 2009 04:56:14 +0100
Message-ID: <19f34abd0902101956t2af01f9cifeab655c1f6625eb@mail.gmail.com>
Subject: Re: [CRED bug?] 2.6.29-rc3 don't survive on stress workload
From: Vegard Nossum <vegard.nossum@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Howells <dhowells@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 8:28 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> That stack trace looks somewhat similar to the one in
>> http://lkml.org/lkml/2009/2/6/136
>>
>> If this is reproducible, maybe a patch like the one attached can help
>> pinpoint it?
>
> Thanks. I'll try it.
> please wait one night, it need to reproduce.

Wow, it seems that I was able to reproduce it (somewhat, somehow) too:

[13359.131495] ------------[ cut here ]------------
[13359.133489] kernel BUG at mm/slub.c:2750!
[13359.133489] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
[13359.133489] last sysfs file: /sys/devices/pnp0/00:0d/id
[13359.133489] CPU 1
[13359.133489] Modules linked in:
[13359.133489] Pid: 917, comm: udevd Not tainted 2.6.29-rc3 #223
[13359.133489] RIP: 0010:[<ffffffff810b99c9>]  [<ffffffff810b99c9>] kfree+0x29/7
[13359.133489] RSP: 0000:ffff88003f187e28  EFLAGS: 00010246
[13359.133489] RAX: 0100000000000400 RBX: ffffffff8171fe00 RCX: 0000000000000086
[13359.133489] RDX: ffffe20000050ec8 RSI: 0000000000000085 RDI: ffffe20000050ec8
[13359.133489] RBP: ffff88003f187e38 R08: 0000000000000585 R09: ffffffff81819cb0
[13359.133489] R10: ffff88003e457b40 R11: ffff88003f187e98 R12: ffffffff81072144
[13359.133489] R13: 0000000000000001 R14: ffffffff818b13e0 R15: 000000000000000a
[13359.133489] FS:  0000000000000000(0000) GS:ffff88003f156f80(0063) knlGS:00000
[13359.218474] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[13359.218474] CR2: 0000000043d6a0ac CR3: 000000003e407000 CR4: 00000000000006a0
[13359.218474] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[13359.239494] ------------[ cut here ]------------
[13359.239498] WARNING: at lib/kref.c:43 kref_get+0x27/0x30()
[13359.239501] Hardware name: 945P-A
[13359.239503] Modules linked in:
[13359.239508] Pid: 2463, comm: a.out Not tainted 2.6.29-rc3 #223
[13359.239511] Call Trace:
[13359.239521]  [<ffffffff8103c93a>] warn_slowpath+0xb6/0xf2
[13359.239529]  [<ffffffff810b5452>] ? alloc_pages_current+0xbe/0xc7
[13359.239536]  [<ffffffff810b734e>] ? get_partial_node+0x22/0x87
[13359.239540]  [<ffffffff810b9705>] ? __slab_alloc+0xd6/0x371
[13359.239547]  [<ffffffff8103238d>] ? set_next_entity+0x8a/0xda
[13359.239553]  [<ffffffff811b2f9b>] kref_get+0x27/0x30
[13359.239560]  [<ffffffff810465ce>] alloc_uid+0xe0/0x1d5
[13359.239568]  [<ffffffff8104b501>] set_user+0x2f/0x88
[13359.239574]  [<ffffffff8104b842>] sys_setreuid+0xcd/0x133
[13359.239579]  [<ffffffff8102d398>] sysenter_dispatch+0x7/0x27
[13359.239582] ---[ end trace 41e0e7b4a6e4140a ]---
[13359.218474] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[13359.346481] Process udevd (pid: 917, threadinfo ffff88003e456000, task ffff8)
  Booting 'Fedora Core (2.6.20.9)'

(spontaneous reboot)

The second BUG is the one from my patch:

        WARN_ON(atomic_read(&kref->refcount) <= 0);

This was a program that forked and did setreuid(0, 99999);
setreuid(99999, 0); in a loop (to alloc/free uids quickly).

My theory is that the reference counting for 'struct user_struct' is
wrong in the case that CONFIG_USER_SCHED=y (check out free_user() in
the two cases), but I don't know that for sure. What is the setting of
this config variable in your configuration?

Will refine my test program to see if I can trigger this immediately
and accurately.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
