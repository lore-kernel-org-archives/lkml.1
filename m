Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbYGIWXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbYGIWXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 18:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbYGIWXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 18:23:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48636 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbYGIWXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 18:23:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-next@vger.kernel.org
Subject: Re: linux-next: Tree for July 9 (kmemcheck: Caught 8-bit read from freed memory (ffff880127c120e8))
Date: Thu, 10 Jul 2008 00:25:13 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <20080709183047.0eb1eb72.sfr@canb.auug.org.au> <200807100017.04397.rjw@sisk.pl>
In-Reply-To: <200807100017.04397.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807100025.13973.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 10 of July 2008, Rafael J. Wysocki wrote:
> On Wednesday, 9 of July 2008, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since next-20080708:
> > 
> > Temporarily dropped tree: ttydev (since it would not import on top of any
> > tree I have)
> > 
> > The x86 tree lost a conflict against the ftrace tree.
> > 
> > The ide tree gained 2 conflicts against Linus' tree.
> > 
> > The nfs tree gained a conflict against Linus' tree.
> > 
> > The acpi tree lost 5 conflicts against various trees but gained another
> > against the x86 tree.
> > 
> > The net tree lost 2 conflicts against the x86 wireless-current trees.
> > 
> > I have also applied the following patches for known problems (I assume
> > that these will be merged into their appropriate trees shortly):
> > 
> > 	linux-next: zero based percpu build error on s390
> > 	sparc64: sysdev API change fallout
> > 
> > I no longer needed to revert the commits from the mmc tree.
> > ----------------------------------------------------------------------------
> 
> With this tree (and several previous ones, it appears) my quad core test
> box's CPU is detected as one core.  With 2.6.26-rc9 four cores are
> detected as appropriate.
> 
> dmesg from the failing kernel (today's linux-next) is at:
> http://www.sisk.pl/kernel/debug/20080709/dmesg-20080709.log
> 
> dmesg from a non-failing kernel (2.6.26-rc9) is at:
> http://www.sisk.pl/kernel/debug/20080709/dmesg-rc9.log
> 
> .config is at: http://www.sisk.pl/kernel/debug/20080709/next-config

Ah, I see.  kmemcheck has detected a problem and disabled the secondary
CPUs:

kmemcheck: Caught 8-bit read from freed memory (ffff880127c120e8)
iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiffffffffffffffffffffffffffffffff
                                        ^

Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.26-rc9-next #37
RIP: 0010:[<ffffffff802b5ac0>]  [<ffffffff802b5ac0>] check_poison_obj+0x90/0x210
RSP: 0018:ffffffff806c1e08  EFLAGS: 00010293
RAX: 000000000000006b RBX: 0000000000000000 RCX: ffffffff802b820e
RDX: 0000000000000000 RSI: ffff880127c120e0 RDI: ffff880127c01480
RBP: ffffffff806c1e48 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000040 R12: ffff880127c120e8
R13: 0000000000000040 R14: 0000000000000000 R15: 000000000000003f
FS:  0000000000000000(0000) GS:ffffffff806b8f40(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffff880127c101b8 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
 [<ffffffff802b647c>] cache_alloc_debugcheck_after+0x1ac/0x1f0
 [<ffffffff802b7fac>] kmem_cache_alloc+0x9c/0x140
 [<ffffffff802b820e>] do_tune_cpucache+0x2e/0x2d0
 [<ffffffff802b862b>] enable_cpucache+0x3b/0xb0
 [<ffffffff806e4caa>] kmem_cache_init+0x3ca/0x4c0
 [<ffffffff806c8ece>] start_kernel+0x27e/0x4c0
 [<ffffffff806c827c>] x86_64_start_reservations+0x7c/0xc0
 [<ffffffff806c83b6>] x86_64_start_kernel+0xf6/0x100
 [<ffffffffffffffff>] 0xffffffffffffffff
Calibrating delay loop (skipped), value calculated using timer frequency.. <6>5015.24 BogoMIPS (lpj=10030484)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using C1E aware idle routine
ACPI: Core revision 20080609
CPU0: AMD Phenom(tm) 9850 Quad-Core Processor stepping 03
Using local APIC timer interrupts.
APIC timer calibration result 12538092
Detected 12.538 MHz APIC timer.
kmemcheck: "Bugs, beware!"
kmemcheck: Limiting number of CPUs to 1.

Thanks,
Rafael
