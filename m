Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbXLHPgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbXLHPgQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 10:36:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750989AbXLHPgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 10:36:03 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:61838 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbXLHPgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 10:36:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DvqW6cqe6aqatuda8C5cvw4T/T76IIMOplN/Exy03Rp0dPjIPRvCAKYjEYvOs76yZHLTwEqQq4uoC2hS2pyoGRSUBWiR3uQKjjhwe5My2nWLWkKHFlWdJsKJF/dVXLJimP0cHFT1NcPGzq3w6iyd9o89iP3JJoYgiwstomh8bB4=
Message-ID: <82e4877d0712080736v12c1e31at9149655ae000fe50@mail.gmail.com>
Date: Sat, 8 Dec 2007 10:36:00 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <82e4877d0712080710g205ba93ag12ee204b15d70fdb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82e4877d0712071453h38795e36of26324a4b123fa6c@mail.gmail.com>
	 <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com>
	 <alpine.LFD.0.99999.0712080821220.3070@localhost.localdomain>
	 <82e4877d0712080710g205ba93ag12ee204b15d70fdb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 8, 2007 10:10 AM, Parag Warudkar <parag.warudkar@gmail.com> wrote:
> On Dec 7, 2007 9:56 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > This looks pretty much like the problem I was solving yesterday.
> >
> > Parag, can you please try Linus latest and please check whether there
> > is a stack trace with clockevents_program_event on the top in your
> > dmesg.
> >
>
> Just booted with latest git and there is no  clockevents_program_event
> in dmesg anywhere.
>
> Any way I have enabled CPU_IDLE again and the machine's got to do lot
> of compiles today.
> I'll see if the problem reproduces.
>

Whoa whoa whoa - this happens left and right with latest Linus +CPU_IDLE.

As soon as I start compiling, dmesg starts filling up with -

Pid: 0, comm: swapper Not tainted (2.6.24-rc4 #5)
EIP: 0060:[<c0533d06>] EFLAGS: 00000202 CPU: 1
EIP is at acpi_idle_enter_simple+0x166/0x1d0
EAX: f7829f88 EBX: 00000da1 ECX: 00000266 EDX: 00000000
ESI: 00000000 EDI: 00042070 EBP: 000412cf ESP: f7829f88
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 080ce178 CR3: 00715000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c058cf03>] cpuidle_idle_call+0x53/0x78
 [<c058ceb0>] cpuidle_idle_call+0x0/0x78
 [<c0402575>] cpu_idle+0x97/0xb8
 =======================
BUG: soft lockup - CPU#1 stuck for 11s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-rc4 #5)
EIP: 0060:[<c0603eaa>] EFLAGS: 00000202 CPU: 1
EIP is at _spin_lock_irqsave+0x16/0x27
EAX: c06b4110 EBX: 00000001 ECX: f7873808 EDX: 00000293
ESI: 00000005 EDI: f7873808 EBP: 00000000 ESP: f7829f10
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 080ff4b0 CR3: 37cf5000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c0438293>] tick_broadcast_oneshot_control+0x10/0xda
 [<c0437ce2>] tick_notify+0x1d4/0x2eb
 [<c04281bc>] get_next_timer_interrupt+0x143/0x1b4
 [<c06058a1>] notifier_call_chain+0x2a/0x47
 [<c04345c0>] raw_notifier_call_chain+0x17/0x1a
 [<c043781e>] clockevents_notify+0x19/0x4f
 [<c0533d23>] acpi_idle_enter_simple+0x183/0x1d0
 [<c058cf03>] cpuidle_idle_call+0x53/0x78
 [<c058ceb0>] cpuidle_idle_call+0x0/0x78
 [<c0402575>] cpu_idle+0x97/0xb8
 =======================
BUG: soft lockup - CPU#1 stuck for 11s! [vim:3736]

Pid: 3736, comm: vim Not tainted (2.6.24-rc4 #5)
EIP: 0060:[<c060540b>] EFLAGS: 00000206 CPU: 1
EIP is at do_page_fault+0x117/0x583
EAX: f6ec1380 EBX: 005d0ff4 ECX: 0000007b EDX: 00000003
ESI: f6dd1fb8 EDI: 004c2000 EBP: f149eae0 ESP: f6dd1f70
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 8005003b CR2: 004c2000 CR3: 3736a000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c046d80d>] vfs_read+0x105/0x115
 [<c06052f4>] do_page_fault+0x0/0x583
 [<c06040aa>] error_code+0x72/0x78
 [<c0600000>] netlbl_domhsh_walk+0x94/0xba
 =======================
BUG: soft lockup - CPU#1 stuck for 11s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-rc4 #5)
EIP: 0060:[<c0533d06>] EFLAGS: 00000202 CPU: 1
EIP is at acpi_idle_enter_simple+0x166/0x1d0
EAX: f7829f88 EBX: 0000000a ECX: 00000266 EDX: 00000000
ESI: 00000000 EDI: 008e8c88 EBP: 008e8c7e ESP: f7829f88
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 005da044 CR3: 37cf5000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c058cf03>] cpuidle_idle_call+0x53/0x78
 [<c058ceb0>] cpuidle_idle_call+0x0/0x78
 [<c0402575>] cpu_idle+0x97/0xb8
 =======================
BUG: soft lockup - CPU#1 stuck for 22s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-rc4 #5)
EIP: 0060:[<c0533d06>] EFLAGS: 00000206 CPU: 1
EIP is at acpi_idle_enter_simple+0x166/0x1d0
EAX: f7829f88 EBX: 00000d9b ECX: 00000266 EDX: 00000000
ESI: 00000000 EDI: 007d1802 EBP: 007d0a67 ESP: f7829f88
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 005da044 CR3: 37cf5000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c058cf03>] cpuidle_idle_call+0x53/0x78
 [<c058ceb0>] cpuidle_idle_call+0x0/0x78
 [<c0402575>] cpu_idle+0x97/0xb8
 =======================
BUG: soft lockup - CPU#1 stuck for 18s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-rc4 #5)
EIP: 0060:[<c0533d06>] EFLAGS: 00000206 CPU: 1
EIP is at acpi_idle_enter_simple+0x166/0x1d0
EAX: f7829f88 EBX: 00000da2 ECX: 00000266 EDX: 00000000
ESI: 00000000 EDI: 00b651f2 EBP: 00b64450 ESP: f7829f88
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 005da044 CR3: 37cf5000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c058cf03>] cpuidle_idle_call+0x53/0x78
 [<c058ceb0>] cpuidle_idle_call+0x0/0x78
 [<c0402575>] cpu_idle+0x97/0xb8
 =======================
BUG: soft lockup - CPU#1 stuck for 14s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-rc4 #5)
EIP: 0060:[<c0603eaa>] EFLAGS: 00000202 CPU: 1
EIP is at _spin_lock_irqsave+0x16/0x27
EAX: c06b4110 EBX: 00000001 ECX: f7873808 EDX: 00000293
ESI: 00000005 EDI: f7873808 EBP: 00000000 ESP: f7829f10
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 080ff4b0 CR3: 37cf5000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c0438293>] tick_broadcast_oneshot_control+0x10/0xda
 [<c0437ce2>] tick_notify+0x1d4/0x2eb
 [<c04281bc>] get_next_timer_interrupt+0x143/0x1b4
 [<c06058a1>] notifier_call_chain+0x2a/0x47
 [<c04345c0>] raw_notifier_call_chain+0x17/0x1a
 [<c043781e>] clockevents_notify+0x19/0x4f
 [<c0533d23>] acpi_idle_enter_simple+0x183/0x1d0
 [<c058cf03>] cpuidle_idle_call+0x53/0x78
 [<c058ceb0>] cpuidle_idle_call+0x0/0x78
 [<c0402575>] cpu_idle+0x97/0xb8
 =======================
BUG: soft lockup - CPU#1 stuck for 11s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-rc4 #5)
EIP: 0060:[<c0533d06>] EFLAGS: 00000206 CPU: 1
EIP is at acpi_idle_enter_simple+0x166/0x1d0
EAX: f7829f88 EBX: 00000020 ECX: 00000266 EDX: 00000000
ESI: 00000000 EDI: 00261276 EBP: 00261256 ESP: f7829f88
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7f5e000 CR3: 37314000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c058cf03>] cpuidle_idle_call+0x53/0x78
 [<c058ceb0>] cpuidle_idle_call+0x0/0x78
 [<c0402575>] cpu_idle+0x97/0xb8
 =======================
