Return-Path: <linux-kernel-owner+w=401wt.eu-S1759985AbYHTP2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985AbYHTP2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 11:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365AbYHTP2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 11:28:25 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:26532 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759913AbYHTP2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 11:28:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=R6n+YBSj8v+FvElbnsySn2l2GKfhM5K6ek1rdqB/G/ge+RT1nuNgKaZ/iYhI5MWiFm
         dnUlXVB1C93u2KDwz8oYfRp1mmfGfdVhjBeeVlSgILLxbyFKm8jLpZfuaBtk6RdPY+Uw
         DTGeFKAonl+tn7HsN8LdEigTbotxypnyI9iV4=
Message-ID: <19f34abd0808200828o6496cbeap75b7242845e96ef3@mail.gmail.com>
Date: Wed, 20 Aug 2008 17:28:21 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "the arch/x86 maintainers" <x86@kernel.org>
Subject: latest -git: BUG: unable to handle kernel paging request (numaq_tsc_disable)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This actually hardlocked my machine and I had to add an extra patch to
get any output at all. Base version is latest git, commit
1fca25427482387689fa27594c992a961d98768f.

Excerpt from config:

CONFIG_X86_NUMAQ=y
CONFIG_X86_SUMMIT_NUMA=y
CONFIG_NUMA=y
# CONFIG_ACPI_NUMA is not set

My machine is of course no NUMA, just a plain P4 with HT. Crash
happens when I try to online CPU1.

Booting processor 1/1 ip 6000
<1>BUG: unable to handle kernel paging request at c08a45f0
<1>IP: [<c08a45f0>] numaq_tsc_disable+0x0/0x40
*pdpt = 0000000000a11001 *pde = 0000000036994163 *pte = 00000000008a4162
<0>Oops: 0010 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Pid: 0, comm: swapper Not tainted (2.6.27-rc3-00466-gbbcc4f1 #17)
EIP: 0060:[<c08a45f0>] EFLAGS: 00010002 CPU: 1
EIP is at numaq_tsc_disable+0x0/0x40
EAX: 00000f00 EBX: f6889f08 ECX: 00000000 EDX: 00000f60
ESI: f6889f0c EDI: c12cef80 EBP: f6889f1c ESP: f6889ed4
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
<0>Process swapper (pid: 0, ti=f6888000 task=f686e800 task.ti=f6888000)
<0>Stack: c0678676 f6889ef4 f6889f00 f6889ef0 00000005 22052489 00000000 0000000
0
<0>       00000000 00000800 00000000 00000000 0000001f 01c0003f 00000000 f6889f6
c
<0>       c12cef80 f6889f68 f6889f84 c067632f 0000001b c015b77d 00000000 0000000
0
<0>Call Trace:
<0> [<c0678676>] ? init_intel+0x196/0x360
<0> [<c067632f>] ? identify_cpu+0xaf/0x430
<0> [<c015b77d>] ? put_lock_stats+0xd/0x30
<0> [<c013b55b>] ? printk+0x1b/0x20
<0> [<c067491a>] ? calibrate_delay+0x6a/0x2b0
<0> [<c06766bf>] ? identify_secondary_cpu+0xf/0x30
<0> [<c067a097>] ? smp_store_cpu_info+0x57/0x100
<0> [<c067a9f4>] ? start_secondary+0xd4/0x1c0
<0> =======================
<0>Code:  Bad EIP value.
<0>EIP: [<c08a45f0>] numaq_tsc_disable+0x0/0x40 SS:ESP 0068:f6889ed4
<4>---[ end trace ce65afb4f347eec5 ]---
<0>Kernel panic - not syncing: Attempted to kill the idle task!
<4>------------[ cut here ]------------
<4>WARNING: at /uio/arkimedes/s29/vegardno/git-working/linux-2.6/kernel/smp.c:32
8 smp_call_function_mask+0x194/0x1a0()
Pid: 0, comm: swapper Tainted: G      D   2.6.27-rc3-00466-gbbcc4f1 #17
 [<c013a9cf>] warn_on_slowpath+0x4f/0x80
 [<c037605f>] ? sprintf+0x1f/0x30
 [<c01670a2>] ? sprint_symbol+0x92/0xc0
 [<c013b25d>] ? vprintk+0x6d/0x350
 [<c014c674>] ? search_exception_tables+0x14/0x20
 [<c0123ade>] ? fixup_exception+0xe/0x30
 [<c0166074>] smp_call_function_mask+0x194/0x1a0
 [<c0119280>] ? stop_this_cpu+0x0/0x50
 [<c067fa88>] ? mutex_unlock+0x8/0x10
 [<c015b71b>] ? trace_hardirqs_off+0xb/0x10
 [<c067f9c4>] ? __mutex_unlock_slowpath+0xa4/0x160
 [<c067fa88>] ? mutex_unlock+0x8/0x10
 [<c0167d8d>] ? crash_kexec+0x6d/0xc0
 [<c067a9f4>] ? start_secondary+0xd4/0x1c0
 [<c013b25d>] ? vprintk+0x6d/0x350
 [<c0119280>] ? stop_this_cpu+0x0/0x50
 [<c01660b0>] smp_call_function+0x30/0x60
 [<c011937e>] native_smp_send_stop+0x1e/0x70
 [<c013a8c9>] panic+0x69/0x120
 [<c013de06>] do_exit+0x7e6/0x890
 [<c013b55b>] ? printk+0x1b/0x20
 [<c013a57a>] ? print_oops_end_marker+0x2a/0x30
 [<c01060f1>] oops_end+0xb1/0xc0
 [<c01067c0>] die+0x50/0x70
 [<c0122bef>] do_page_fault+0x1ef/0xa20
 [<c0681a77>] ? _spin_unlock+0x27/0x50
 [<c0122a00>] ? do_page_fault+0x0/0xa20
 [<c0681f3a>] error_code+0x72/0x78
 [<c0678676>] ? init_intel+0x196/0x360
 [<c067632f>] identify_cpu+0xaf/0x430
 [<c015b77d>] ? put_lock_stats+0xd/0x30
 [<c013b55b>] ? printk+0x1b/0x20
 [<c067491a>] ? calibrate_delay+0x6a/0x2b0
 [<c06766bf>] identify_secondary_cpu+0xf/0x30
 [<c067a097>] smp_store_cpu_info+0x57/0x100
 [<c067a9f4>] start_secondary+0xd4/0x1c0
 =======================
<4>---[ end trace ce65afb4f347eec5 ]---
<4>------------[ cut here ]------------
<4>WARNING: at /uio/arkimedes/s29/vegardno/git-working/linux-2.6/kernel/smp.c:21
7 smp_call_function_single+0x10a/0x110()
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-rc3-00466-gbbcc4f1 #17
 [<c013a9cf>] warn_on_slowpath+0x4f/0x80
 [<c037605f>] ? sprintf+0x1f/0x30
 [<c01670a2>] ? sprint_symbol+0x92/0xc0
 [<c013b25d>] ? vprintk+0x6d/0x350
 [<c0165eda>] smp_call_function_single+0x10a/0x110
 [<c0119280>] ? stop_this_cpu+0x0/0x50
 [<c014c674>] ? search_exception_tables+0x14/0x20
 [<c0123ade>] ? fixup_exception+0xe/0x30
 [<c0166022>] smp_call_function_mask+0x142/0x1a0
 [<c0119280>] ? stop_this_cpu+0x0/0x50
 [<c067fa88>] ? mutex_unlock+0x8/0x10
 [<c015b71b>] ? trace_hardirqs_off+0xb/0x10
 [<c067f9c4>] ? __mutex_unlock_slowpath+0xa4/0x160
 [<c067fa88>] ? mutex_unlock+0x8/0x10
 [<c0167d8d>] ? crash_kexec+0x6d/0xc0
 [<c067a9f4>] ? start_secondary+0xd4/0x1c0
 [<c0119280>] ? stop_this_cpu+0x0/0x50
 [<c01660b0>] smp_call_function+0x30/0x60
 [<c011937e>] native_smp_send_stop+0x1e/0x70
 [<c013a8c9>] panic+0x69/0x120
 [<c013de06>] do_exit+0x7e6/0x890
 [<c013b55b>] ? printk+0x1b/0x20
 [<c013a57a>] ? print_oops_end_marker+0x2a/0x30
 [<c01060f1>] oops_end+0xb1/0xc0
 [<c01067c0>] die+0x50/0x70
 [<c0122bef>] do_page_fault+0x1ef/0xa20
 [<c0681a77>] ? _spin_unlock+0x27/0x50
 [<c0122a00>] ? do_page_fault+0x0/0xa20
 [<c0681f3a>] error_code+0x72/0x78
 [<c0678676>] ? init_intel+0x196/0x360
 [<c067632f>] identify_cpu+0xaf/0x430
 [<c015b77d>] ? put_lock_stats+0xd/0x30
 [<c013b55b>] ? printk+0x1b/0x20
 [<c067491a>] ? calibrate_delay+0x6a/0x2b0
 [<c06766bf>] identify_secondary_cpu+0xf/0x30
 [<c067a097>] smp_store_cpu_info+0x57/0x100
 [<c067a9f4>] start_secondary+0xd4/0x1c0
 =======================
<4>---[ end trace ce65afb4f347eec5 ]---

Config is at http://master.kernel.org/~vegard/bugs/20080820-numaq/
already, but vmlinux is 122M so I guess it's better to ask if I should
provide line numbers.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
