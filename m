Return-Path: <linux-kernel-owner+w=401wt.eu-S1757988AbZEXTPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988AbZEXTPv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 15:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbZEXTPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 15:15:43 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:35581 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbZEXTPm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 15:15:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Y2tZU0xjjSa7cHtv7CqDb+R6COKTS2f4+MwJtUnTGlb5RPO+aORexYvm4gCov3Pegd
         VRPE75GDfRTiWdlTMyqTn6p0vmiX4WHZLtP8ITd0e9oyrpzUDWTDsNJECgImewxS+hm5
         jro36GyleyVXOS84LHv7eVI9iBVl5S07K9OWs=
MIME-Version: 1.0
In-Reply-To: <4A199327.5030503@kernel.org>
References: <20090518142707.GA24142@elte.hu> <20090518164921.GA6903@elte.hu>
	 <alpine.LFD.2.01.0905180955550.3301@localhost.localdomain>
	 <20090518170909.GA1623@elte.hu> <20090518190320.GA20260@elte.hu>
	 <alpine.LFD.2.01.0905181208130.3301@localhost.localdomain>
	 <20090518202031.GA26549@elte.hu>
	 <alpine.LFD.2.01.0905181457320.3301@localhost.localdomain>
	 <Pine.LNX.4.64.0905241911120.12189@melkki.cs.Helsinki.FI>
	 <4A199327.5030503@kernel.org>
Date: Sun, 24 May 2009 22:15:42 +0300
X-Google-Sender-Auth: bc998bb531e0737b
Message-ID: <84144f020905241215s1db61d2fyfa09c4154a466add@mail.gmail.com>
Subject: Re: [GIT PULL] scheduler fixes
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeff Garzik <jgarzik@pobox.com>, Alexander Viro <viro@ftp.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 24, 2009 at 9:34 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> Ingo, here's a patch that boots UMA+SMP+SLUB x86-64 kernel on qemu all
>> the way to userspace. It probably breaks bunch of things for now but
>> something for you to play with if you want.
>>
>
> updated with tip/master. also add change to cpupri_init
> otherwise will get
> [    0.000000] Memory: 523096612k/537526272k available (10461k kernel code, 656156k absent, 13773504k reserved, 7186k data, 2548k init)
> [    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=32, Nodes=8
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at kernel/lockdep.c:2282 lockdep_trace_alloc+0xaf/0xee()
> [    0.000000] Hardware name: Sun Fire X4600 M2
> [    0.000000] Modules linked in:
> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.30-rc6-tip-01778-g0afdd0f-dirty #259
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff810a0274>] ? lockdep_trace_alloc+0xaf/0xee
> [    0.000000]  [<ffffffff81075ab0>] warn_slowpath_common+0x88/0xcb
> [    0.000000]  [<ffffffff81075b15>] warn_slowpath_null+0x22/0x38
> [    0.000000]  [<ffffffff810a0274>] lockdep_trace_alloc+0xaf/0xee
> [    0.000000]  [<ffffffff8110301b>] kmem_cache_alloc_node+0x38/0x14d
> [    0.000000]  [<ffffffff813ec548>] ? alloc_cpumask_var_node+0x4a/0x10a
> [    0.000000]  [<ffffffff8109eb61>] ? lockdep_init_map+0xb9/0x564
> [    0.000000]  [<ffffffff813ec548>] alloc_cpumask_var_node+0x4a/0x10a
> [    0.000000]  [<ffffffff813ec62c>] alloc_cpumask_var+0x24/0x3a
> [    0.000000]  [<ffffffff819e6306>] cpupri_init+0x7f/0x112
> [    0.000000]  [<ffffffff819e5a30>] init_rootdomain+0x72/0xb7
> [    0.000000]  [<ffffffff821facce>] sched_init+0x109/0x660
> [    0.000000]  [<ffffffff82203082>] ? kmem_cache_init+0x193/0x1b2
> [    0.000000]  [<ffffffff821dfd7a>] start_kernel+0x218/0x3f3
> [    0.000000]  [<ffffffff821df2a9>] x86_64_start_reservations+0xb9/0xd4
> [    0.000000]  [<ffffffff821df3b2>] x86_64_start_kernel+0xee/0x109
> [    0.000000] ---[ end trace a7919e7f17c0a725 ]---
>
> works with 8 sockets numa amd64 box.

Oh, cool. Thanks for testing! I'll rebase on top of tip and merge your
changes to my patch.
