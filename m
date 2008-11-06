Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbYKFG2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbYKFG2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 01:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbYKFG2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 01:28:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:34475 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbYKFG2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 01:28:12 -0500
Message-ID: <49128E50.3020704@kernel.org>
Date: Wed, 05 Nov 2008 22:27:28 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Yinghai Lu <yinghai@kernel.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.28-rc2: REGRESSION in early boot
References: <20081104224510.GA7672@mit.edu> <86802c440811041614i5ab5e7f5hf910211ef57423e7@mail.gmail.com> <20081105153508.GB22998@mit.edu> <86802c440811050922o53f494c6y7b007f094a6ece2e@mail.gmail.com> <20081106052340.GA12762@mit.edu>
In-Reply-To: <20081106052340.GA12762@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Wed, Nov 05, 2008 at 09:22:38AM -0800, Yinghai Lu wrote:
>>> What is your theory for why this was causing a failure in the timer
>>> subsystem?  Were we overrunning the end of irq_desc array and stomping
>>> on some other data structure?
>> Yes. Please do apply that two patches at first.
>>
> 
> Success!  Applying these two patches, as found at:
> 

did you apply 
http://lkml.org/lkml/2008/11/4/431

it seems we aready incread NR_IRQS big enough, but still get...

[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/kernel/io_apic.c:3614 probe_nr_irqs+0x44/0x4d()
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.28-rc3-00123-g72a0780 #97
[    0.000000] Call Trace:
[    0.000000]  [<c01418f1>] warn_on_slowpath+0x46/0x60
[    0.000000]  [<c0160a3e>] ? __lock_acquire+0x3d9/0xa5b
[    0.000000]  [<c06dd463>] ? alloc_bootmem_core+0x1bf/0x221
[    0.000000]  [<c012db8b>] ? native_pmd_val+0x8/0xa
[    0.000000]  [<c01324a2>] ? pmd_val+0x11/0x21
[    0.000000]  [<c011bb31>] ? sched_clock+0xc/0x1c
[    0.000000]  [<c015e5fb>] ? lock_release_holdtime+0x43/0x48
[    0.000000]  [<c016142c>] ? lock_release+0x14c/0x155
[    0.000000]  [<c015e46b>] ? trace_hardirqs_off_caller+0x79/0x84
[    0.000000]  [<c04ab040>] ? _spin_unlock_irqrestore+0x3e/0x55
[    0.000000]  [<c015e5b6>] ? trace_hardirqs_off+0xb/0xd
[    0.000000]  [<c04ab040>] ? _spin_unlock_irqrestore+0x3e/0x55
[    0.000000]  [<c06d5853>] probe_nr_irqs+0x44/0x4d
[    0.000000]  [<c06cbfe8>] setup_arch+0xa90/0xb00
[    0.000000]  [<c015e46b>] ? trace_hardirqs_off_caller+0x79/0x84
[    0.000000]  [<c015e5b6>] ? trace_hardirqs_off+0xb/0xd
[    0.000000]  [<c015e91a>] ? lockdep_init_map+0x6b/0xc7
[    0.000000]  [<c06c65e2>] start_kernel+0x85/0x30e
[    0.000000]  [<c06c6080>] __init_begin+0x80/0x88
[    0.000000] ---[ end trace 8305b6ae03c24dde ]---

YH
> 	

>         http://lkml.org/lkml/2008/11/5/81
> 
> ... and my 2.6.28-rc3-git2 based kernel successfully booted on my
> system.
> 
> I'll update:  http://bugzilla.kernel.org/show_bug.cgi?id=11951
> accordingly.   Are these two patches scheduled to be pushed to 
> mainstream, hopefully ASAP since they are a regression fix?
> 
> 						- Ted
> 
> P.S.  I've attached the dmesg of the patched 2.6.28-rc3-git2 kernel.
> 
> 
> 
> 
> 

