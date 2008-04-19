Return-Path: <linux-kernel-owner+w=401wt.eu-S932245AbYDSDKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245AbYDSDKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 23:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbYDSDKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 23:10:31 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:44153 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbYDSDK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 23:10:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ClmOUYQ7s/09m/sYBjkjjXLquXmrZdCDKLewWuhzfhr13DwIavhD2+zVgVBjnGhGZPMPF+loxUhQqzUW7gEf5Az95Lky45oATTQ/aDKfEYCj1I/PZytDx/KtEEiEEN77Whxzk/UUO0/dqiFChcUweJIrL3O3/cvd22kSjeDRxEc=
Date: Fri, 18 Apr 2008 23:10:24 -0400
From: Joseph Fannin <jfannin@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-mm1
Message-ID: <20080419031024.GC3503@nineveh.local>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 01:47:57AM -0700, Andrew Morton wrote:
>
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25/2.6.25-mm1/

New, in 2.6.25-mm1 is a hang I'm seeing, just after the kernel prints:

"[    0.160375] NET: Registered protocol family 16"

The hang lasts about five minutes, and then boot continues.  Just
after that, a backtrace is printed; I don't know if it's related.  The
backtrace will follow.

This does not occur in mainline.  It seems it might be related to OLPC
support -- I enabled all those options -- but that's not good
behavior, and I see no warning of thus in the help.

I'm sending a number or reports against 2.6.25-mm1, so I've put my
dmesg and .config on a server:

http://home.columbus.rr.com/jfannin3/dmesg.txt
http://home.columbus.rr.com/jfannin3/config-2.6.25-mm1.txt

[    0.160375] NET: Registered protocol family 16
[  400.782683] ------------[ cut here ]------------
[  400.782832] WARNING: at arch/x86/mm/ioremap.c:158 __ioremap_caller+0x27d/0x2e0()
[  400.783022] Modules linked in:
[  400.783169] Pid: 1, comm: swapper Not tainted 2.6.25-mm1 #7
[  400.783300]  [<c0130fa9>] warn_on_slowpath+0x59/0x80
[  400.783480]  [<c0106c2e>] ? profile_pc+0x3e/0x50
[  400.783682]  [<c01374ee>] ? irq_exit+0x4e/0xa0
[  400.783879]  [<c0115aec>] ? smp_apic_timer_interrupt+0x5c/0x90
[  400.784087]  [<c024314c>] ? trace_hardirqs_on_thunk+0xc/0x10
[  400.784298]  [<c01552cd>] ? trace_hardirqs_on_caller+0xcd/0x150
[  400.784506]  [<c024314c>] ? trace_hardirqs_on_thunk+0xc/0x10
[  400.784706]  [<c010416c>] ? restore_nocheck_notrace+0x0/0xe
[  400.784906]  [<c011d0e6>] ? page_is_ram+0xa6/0xd0
[  400.785059]  [<c011d4ed>] __ioremap_caller+0x27d/0x2e0
[  400.785221]  [<c03569d8>] ? _spin_unlock_irqrestore+0x48/0x80
[  400.785421]  [<c017f4cd>] ? ftrace_record_ip+0x7d/0x250
[  400.785621]  [<c0474801>] ? olpc_init+0x31/0x140
[  400.785817]  [<c011d59f>] ioremap_nocache+0x1f/0x30
[  400.785976]  [<c0474801>] ? olpc_init+0x31/0x140
[  400.786165]  [<c0474801>] olpc_init+0x31/0x140
[  400.786318]  [<c0464992>] kernel_init+0x142/0x2d0
[  400.786479]  [<c01552cd>] ? trace_hardirqs_on_caller+0xcd/0x150
[  400.786680]  [<c010416c>] ? restore_nocheck_notrace+0x0/0xe
[  400.786879]  [<c0464850>] ? kernel_init+0x0/0x2d0
[  400.787069]  [<c0464850>] ? kernel_init+0x0/0x2d0
[  400.787260]  [<c0104d9b>] kernel_thread_helper+0x7/0x10
[  400.787422]  =======================
[  400.787727] ---[ end trace 4eaa2a86a8e2da22 ]---

--
Joseph Fannin
jfannin@gmail.com

