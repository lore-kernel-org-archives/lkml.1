Return-Path: <linux-kernel-owner+w=401wt.eu-S1754438AbYHUBEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbYHUBEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 21:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbYHUBE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 21:04:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750972AbYHUBE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 21:04:27 -0400
Date: Wed, 20 Aug 2008 18:04:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       j_kernel@hoblitt.com
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of
 16gb of memory is usable
Message-Id: <20080820180405.7f164450.akpm@linux-foundation.org>
In-Reply-To: <bug-11388-27@http.bugzilla.kernel.org/>
References: <bug-11388-27@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Wed, 20 Aug 2008 17:38:59 -0700 (PDT)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11388
> 
>            Summary: 2.6.27-rc3 warns about MTRR range; only 3 of 16gb of
>                     memory is usable
>            Product: Memory Management
>            Version: 2.5
>      KernelVersion: 2.6.27-rc3
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: MTTR
>         AssignedTo: akpm@osdl.org
>         ReportedBy: j_kernel@hoblitt.com
> 
> 
> Latest working kernel version: 2.4.24.2 (possibly later)
> Earliest failing kernel version: 2.6.27-rc3-21328-ga7f5aaf (from netdev-2.6)
> Distribution: Gentoo
> Hardware Environment: 2x Intel X5482
> Software Environment:
> Problem Description:
> 
> [    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing
> 13056MB of RAM.
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/main.c:1561
> mtrr_trim_uncached_memory+0x508/0x550()
> [    0.000000] Modules linked in:
> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc3-21328-ga7f5aaf #8
> [    0.000000] 
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff80234c3e>] warn_on_slowpath+0x51/0x77
> [    0.000000]  [<ffffffff8023570a>] printk+0x4e/0x56
> [    0.000000]  [<ffffffff803add02>] sort+0xfa/0x18c
> [    0.000000]  [<ffffffff808283d3>] cmp_range+0x0/0x6
> [    0.000000]  [<ffffffff80828a47>] mtrr_trim_uncached_memory+0x508/0x550
> [    0.000000]  [<ffffffff802178e1>] post_set+0x20/0x3d
> [    0.000000]  [<ffffffff80824f99>] setup_arch+0x39d/0x6be
> [    0.000000]  [<ffffffff8081e962>] start_kernel+0x74/0x341
> [    0.000000]  [<ffffffff8081e394>] x86_64_start_kernel+0xe3/0xe7
> [    0.000000] 
> [    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
> 
> 
> Steps to reproduce:
> 
> This warning isn't present under 2.6.24.2 and the full range of physical memory
> is usable.

Looks like a post-2.6.26 regression caused by
12031a624af7816ec7660b82be648aa3703b4ebe.

