Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbZGNHTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbZGNHTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 03:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbZGNHTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 03:19:44 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:58422 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbZGNHTn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 03:19:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=a9EvnqlbZ90DzfU1mPdfZ/QZ9LdVojKZ2aIre4QycKkLLrkW/3txBZRs22nNs7vuIj
         B7B006vQOjFWKtG1X8OQXAu190Z4bPqnQLxgszzno2TtV2hL7hJteHUmrJeimjzYtW7R
         z1m7p1oIHMisvTZNJKSjcp3GGuqfNh+ru3XHo=
MIME-Version: 1.0
In-Reply-To: <4A5C20E5.6010203@fisher-privat.net>
References: <4A5C20E5.6010203@fisher-privat.net>
Date: Tue, 14 Jul 2009 10:19:41 +0300
X-Google-Sender-Auth: 6a1276d2cfeaa0a8
Message-ID: <84144f020907140019g511723dctb541f6333d1a082b@mail.gmail.com>
Subject: Re: 60 memory leaks.. or is it some thing wrong with kmemleak?
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

[ Lets cc Catalin. ]

On Tue, Jul 14, 2009 at 9:08 AM, Alexey
Fisher<bug-track@fisher-privat.net> wrote:
> Hallo all,
> i enabled kmemleak and now i get a lot of them...

Which kernel version is this? You almost definitely want to try out
2.6.31-rc3 which has tons of bug fixes to kmemleak.

> i do not know if this are real or some noise..
> most of the about mounting ext4
>
> unreferenced object 0xffff880133c63800 (size 1024):
>  comm "exe", pid 1521, jiffies 4294894652
>  backtrace:
>    [<ffffffff810f8f36>] create_object+0x126/0x2b0
>    [<ffffffff810f91d5>] kmemleak_alloc+0x25/0x60
>    [<ffffffff810f32a3>] __kmalloc+0x113/0x200
>    [<ffffffff811aa061>] ext4_mb_init+0x1b1/0x570
>    [<ffffffff8119b3d2>] ext4_fill_super+0x1de2/0x26d0
>    [<ffffffff810fe40f>] get_sb_bdev+0x16f/0x1b0
>    [<ffffffff811912f3>] ext4_get_sb+0x13/0x20
>    [<ffffffff810fdee6>] vfs_kern_mount+0x76/0x180
>    [<ffffffff810fe05d>] do_kern_mount+0x4d/0x120
>    [<ffffffff81115e17>] do_mount+0x307/0x880
>    [<ffffffff8111641f>] sys_mount+0x8f/0xe0
>    [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
>    [<ffffffffffffffff>] 0xffffffffffffffff
> unreferenced object 0xffff8801334db0c0 (size 192):
>  comm "exe", pid 1521, jiffies 4294894652
>  backtrace:
>    [<ffffffff810f8f36>] create_object+0x126/0x2b0
>    [<ffffffff810f91d5>] kmemleak_alloc+0x25/0x60
>    [<ffffffff810f32a3>] __kmalloc+0x113/0x200
>    [<ffffffff811aa061>] ext4_mb_init+0x1b1/0x570
>    [<ffffffff8119b3d2>] ext4_fill_super+0x1de2/0x26d0
>    [<ffffffff810fe40f>] get_sb_bdev+0x16f/0x1b0
>    [<ffffffff811912f3>] ext4_get_sb+0x13/0x20
>    [<ffffffff810fdee6>] vfs_kern_mount+0x76/0x180
>    [<ffffffff810fe05d>] do_kern_mount+0x4d/0x120
>    [<ffffffff81115e17>] do_mount+0x307/0x880
>    [<ffffffff8111641f>] sys_mount+0x8f/0xe0
>    [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
>    [<ffffffffffffffff>] 0xffffffffffffffff
>
>
> and other seems like about control group:
>
>
> unreferenced object 0xffff88013b852440 (size 544):
>  comm "swapper", pid 0, jiffies 4294892296
>  backtrace:
>    [<ffffffff810f8f36>] create_object+0x126/0x2b0
>    [<ffffffff810f91d5>] kmemleak_alloc+0x25/0x60
>    [<ffffffff810f24f3>] kmem_cache_alloc+0xf3/0x170
>    [<ffffffff8121deff>] idr_pre_get+0x5f/0x90
>    [<ffffffff810898c5>] get_new_cssid+0x65/0x120
>    [<ffffffff8174f7a3>] cgroup_init+0x6f/0x109
>    [<ffffffff8173ad21>] start_kernel+0x3a6/0x3ca
>    [<ffffffff8173a315>] x86_64_start_reservations+0x125/0x129
>    [<ffffffff8173a3fd>] x86_64_start_kernel+0xe4/0xeb
>    [<ffffffffffffffff>] 0xffffffffffffffff
> unreferenced object 0xffff88013b852660 (size 544):
>  comm "swapper", pid 0, jiffies 4294892296
>  backtrace:
>    [<ffffffff810f8f36>] create_object+0x126/0x2b0
>    [<ffffffff810f91d5>] kmemleak_alloc+0x25/0x60
>    [<ffffffff810f24f3>] kmem_cache_alloc+0xf3/0x170
>    [<ffffffff8121deff>] idr_pre_get+0x5f/0x90
>    [<ffffffff810898c5>] get_new_cssid+0x65/0x120
>    [<ffffffff8174f7a3>] cgroup_init+0x6f/0x109
>    [<ffffffff8173ad21>] start_kernel+0x3a6/0x3ca
>    [<ffffffff8173a315>] x86_64_start_reservations+0x125/0x129
>    [<ffffffff8173a3fd>] x86_64_start_kernel+0xe4/0xeb
>    [<ffffffffffffffff>] 0xffffffffffffffff
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
