Return-Path: <linux-kernel-owner+w=401wt.eu-S1753165AbYICQTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbYICQTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 12:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbYICQTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 12:19:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751351AbYICQTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 12:19:16 -0400
Date: Wed, 3 Sep 2008 09:18:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org, ak@axet.ru
Subject: Re: [Bugme-new] [Bug 11490] New: Old mtrr bug comeback
Message-Id: <20080903091842.dc0982ee.akpm@linux-foundation.org>
In-Reply-To: <bug-11490-10286@http.bugzilla.kernel.org/>
References: <bug-11490-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Wed,  3 Sep 2008 08:44:27 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11490
> 
>            Summary: Old mtrr bug comeback
>            Product: Memory Management
>            Version: 2.5
>      KernelVersion: v2.6.27-rc5
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: MTTR
>         AssignedTo: akpm@osdl.org
>         ReportedBy: ak@axet.ru
> 
> 
> Latest working kernel version:v2.6.26.3
> 
> Old mtrr bug comeback, when i boot my notebook with last kerenl they going to
> work really slow as turttle. to boot on normal speed i need use kernel param
> mem=1000M
> 
> when i use 2.6.26.3 everyting going fine. as i remember that bug fixed in
> 2.6.26 stable release and was in 2.6.25 and earlier.
> 
> probably you can find more details in bugzilla.redhat.com or
> bugzilla.mozilla.com i do no remember where is exactly i have been posted that
> old bug.
> 
> here the point (warning on 2.6.26.3 kernel):
> 
> WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 7MB of RAM.
> ------------[ cut here ]------------
> WARNING: at arch/x86/kernel/cpu/mtrr/main.c:706
> mtrr_trim_uncached_memory+0x103/0x168()
> Modules linked in:
> Pid: 0, comm: swapper Not tainted 2.6.26.3 #1
>  [<c06260e9>] ? printk+0xf/0x16
>  [<c0427749>] warn_on_slowpath+0x41/0x7b
>  [<c0628171>] ? _spin_unlock_irqrestore+0x10/0x14
>  [<c0628171>] ? _spin_unlock_irqrestore+0x10/0x14
>  [<c0427e4f>] ? release_console_sem+0x181/0x189
>  [<c04282d3>] ? vprintk+0x2e6/0x30b
>  [<c04282d3>] ? vprintk+0x2e6/0x30b
>  [<c040dbfd>] ? generic_get_mtrr+0x53/0x8a
>  [<c0756177>] mtrr_trim_uncached_memory+0x103/0x168
>  [<c075606c>] ? mtrr_bp_init+0x204/0x20c
>  [<c07539a9>] setup_arch+0x27b/0x6ce
>  [<c06260e9>] ? printk+0xf/0x16
>  [<c074d5c0>] start_kernel+0x64/0x2da
>  [<c074d008>] __init_begin+0x8/0xa
>  =======================
> ---[ end trace 4eaa2a86a8e2da22 ]---
> update e820 for mtrr
> modified physical RAM map:
> 

A post-2.6.26 regression.

We have a couple of mtrr fixes pending:

http://userweb.kernel.org/~akpm/mmotm/broken-out/x86-delay-early-cpu-initialization-until-cpuid-is-done.patch

http://userweb.kernel.org/~akpm/mmotm/broken-out/x86-move-mtrr-cpu-cap-setting-early-in-early_init_xxxx.patch

but I don't know if they'll fix this regression?
