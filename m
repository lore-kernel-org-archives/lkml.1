Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbYGJHTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbYGJHTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 03:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbYGJHTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 03:19:05 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:52027 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbYGJHTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 03:19:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=obHfwSqEdc3GXaHFYPNF/G5H9TMxDxlNkh0wIjHLwiIFpCVb51o76tkVJ4XCgsSQhO
         86nx6/YSORXLnnCxuleUAAnDEp5dvxShGaegMDvodXYlM3wYaCA57/HwMoxtc1ieo+xF
         Ym2UVDnMxVvKA0NCAmT5qyCKifqFNvD4ffxzs=
Message-ID: <19f34abd0807100019t392621dci306420150343d13d@mail.gmail.com>
Date: Thu, 10 Jul 2008 09:19:01 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: linux-next: Tree for July 9 (kmemcheck: Caught 8-bit read from freed memory (ffff880127c120e8))
Cc: linux-next@vger.kernel.org, "Stephen Rothwell" <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
In-Reply-To: <200807100025.13973.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080709183047.0eb1eb72.sfr@canb.auug.org.au>
	 <200807100017.04397.rjw@sisk.pl> <200807100025.13973.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 12:25 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, 10 of July 2008, Rafael J. Wysocki wrote:
>> With this tree (and several previous ones, it appears) my quad core test
>> box's CPU is detected as one core.  With 2.6.26-rc9 four cores are
>> detected as appropriate.
>>
>> dmesg from the failing kernel (today's linux-next) is at:
>> http://www.sisk.pl/kernel/debug/20080709/dmesg-20080709.log
>>
>> dmesg from a non-failing kernel (2.6.26-rc9) is at:
>> http://www.sisk.pl/kernel/debug/20080709/dmesg-rc9.log
>>
>> .config is at: http://www.sisk.pl/kernel/debug/20080709/next-config
>
> Ah, I see.  kmemcheck has detected a problem and disabled the secondary
> CPUs:
>
> kmemcheck: Caught 8-bit read from freed memory (ffff880127c120e8)
> iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiffffffffffffffffffffffffffffffff
>                                        ^
>
> Modules linked in:
> Pid: 0, comm: swapper Not tainted 2.6.26-rc9-next #37
> RIP: 0010:[<ffffffff802b5ac0>]  [<ffffffff802b5ac0>] check_poison_obj+0x90/0x210
> RSP: 0018:ffffffff806c1e08  EFLAGS: 00010293
> RAX: 000000000000006b RBX: 0000000000000000 RCX: ffffffff802b820e
> RDX: 0000000000000000 RSI: ffff880127c120e0 RDI: ffff880127c01480
> RBP: ffffffff806c1e48 R08: 0000000000000001 R09: 0000000000000001
> R10: 0000000000000001 R11: 0000000000000040 R12: ffff880127c120e8
> R13: 0000000000000040 R14: 0000000000000000 R15: 000000000000003f
> FS:  0000000000000000(0000) GS:ffffffff806b8f40(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: ffff880127c101b8 CR3: 0000000000201000 CR4: 00000000000006a0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
>  [<ffffffff802b647c>] cache_alloc_debugcheck_after+0x1ac/0x1f0
>  [<ffffffff802b7fac>] kmem_cache_alloc+0x9c/0x140
>  [<ffffffff802b820e>] do_tune_cpucache+0x2e/0x2d0
>  [<ffffffff802b862b>] enable_cpucache+0x3b/0xb0
>  [<ffffffff806e4caa>] kmem_cache_init+0x3ca/0x4c0
>  [<ffffffff806c8ece>] start_kernel+0x27e/0x4c0
>  [<ffffffff806c827c>] x86_64_start_reservations+0x7c/0xc0
>  [<ffffffff806c83b6>] x86_64_start_kernel+0xf6/0x100
>  [<ffffffffffffffff>] 0xffffffffffffffff
> Calibrating delay loop (skipped), value calculated using timer frequency.. <6>5015.24 BogoMIPS (lpj=10030484)
> Security Framework initialized
> SELinux:  Initializing.
> SELinux:  Starting in permissive mode
> selinux_register_security:  Registering secondary module capability
> Capability LSM initialized as secondary
> Mount-cache hash table entries: 256
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 512K (64 bytes/line)
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> using C1E aware idle routine
> ACPI: Core revision 20080609
> CPU0: AMD Phenom(tm) 9850 Quad-Core Processor stepping 03
> Using local APIC timer interrupts.
> APIC timer calibration result 12538092
> Detected 12.538 MHz APIC timer.
> kmemcheck: "Bugs, beware!"
> kmemcheck: Limiting number of CPUs to 1.

Hm.

No, they're not disabled because an error was detected. They're always
disabled unless you explicitly allow the SMP+kmemcheck combination in
config. But this combination sucks at the moment because it means
halting all the CPUs on the system for every kernel-mode memory
dereference on any CPU!

Also, the error report is bogus. We should make kmemcheck depend on
!CONFIG_DEBUG_SLAB && !CONFIG_SLUB_DEBUG_ON for now, because these
modes interfere with the checking that kmemcheck does.

(Just think of it -- if SLUB wants to check whether the padding was
overwritten, it *will* have to make a read from the padding area. And
kmemcheck will not differentiate between reads from the allocator vs.
reads from the rest of the kernel. And in every other case, this read
would be a real error.)

That said, we *might* be able to do a kmemcheck_off()/kmemcheck_on()
thing around the special code. Maybe a kmemcheck_read()  which
bypasses the checking for a single read.

But I really do think kmemcheck and slab/slub debugging should be
mutually exclusive. They do essentially the same thing, except that
kmemcheck is much more eager and detects problems right where they
happen (though sometimes too eagerly too; the false positives).

Thanks for trying it out :-D


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
