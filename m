Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbZHYIJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbZHYIJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 04:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbZHYIJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 04:09:35 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:33416 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbZHYIJe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 04:09:34 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Aug 2009 04:09:34 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ul1ITJlCrxKbiquanioNYC6tfRxWdeaDK8rhs+5dtV+R9f/2qgYhuhRLEToHSimqtE
         rBlYa3H9HdTSNPocAKgLTCDQeKf2te+3pqdhdvlIHx7BM9/42WzSQo6MS506/u+Pelm3
         uYCHX3p1JzTSrrBChlE2hWOrrZfrGX3qcqoG8=
MIME-Version: 1.0
In-Reply-To: <20090825071959.GA25877@elte.hu>
References: <20090825071959.GA25877@elte.hu>
Date: Tue, 25 Aug 2009 10:04:29 +0200
Message-ID: <19f34abd0908250104y6e877545y485a2104c2b97cfd@mail.gmail.com>
Subject: Re: WARNING: kmemcheck: Caught 32-bit read from uninitialized memory 
	(f6f6e1a4), by kmemleak's scan_block()
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/25 Ingo Molnar <mingo@elte.hu>:
>
> FYI, -tip testing triggered the following kmemcheck warning in
> kmemleak:
>
> PM: Adding info for No Bus:vcsa7
> WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (f6f6e1a4)
> d873f9f600000000c42ae4c1005c87f70000000070665f666978656400000000
>  i i i i u u u u i i i i i i i i i i i i i i i i i i i i i u u u
>         ^
>
> Pid: 3091, comm: kmemleak Not tainted (2.6.31-rc7-tip #1303) P4DC6
> EIP: 0060:[<c110301f>] EFLAGS: 00010006 CPU: 0
> EIP is at scan_block+0x3f/0xe0
> EAX: f40bd700 EBX: f40bd780 ECX: f16b46c0 EDX: 00000001
> ESI: f6f6e1a4 EDI: 00000000 EBP: f10f3f4c ESP: c2605fcc
>  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> CR0: 8005003b CR2: e89a4844 CR3: 30ff1000 CR4: 000006f0
> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> DR6: ffff4ff0 DR7: 00000400
>  [<c110313c>] scan_object+0x7c/0xf0
>  [<c1103389>] kmemleak_scan+0x1d9/0x400
>  [<c1103a3c>] kmemleak_scan_thread+0x4c/0xb0
>  [<c10819d4>] kthread+0x74/0x80
>  [<c10257db>] kernel_thread_helper+0x7/0x3c
>  [<ffffffff>] 0xffffffff
> kmemleak: 515 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
> kmemleak: 42 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
>
> config attached. (And this is the first documented case of a kmem
> civil war i guess ;-)

Already the patch to make kmemcheck and kmemleak mutually exclusive is
underway. It is not surprising that kmemleak is scanning uninitialized
memory. But if you say that you have tried it before, it is strange
that it didn't appear until now.

In any case, I don't think it is very productive to run them both at
the same time, simply because kmemcheck slows every memory access down
so much and scanning memory doesn't exactly help that. It _could_ be
useful to have them compiled into the same kernel, though, e.g. a
distro "-debug" kernel.

Maybe you can just add the "depends on !KMEMLEAK" to CONFIG_KMEMCHECK
in tip/out-of-tree for now?


Vegard
