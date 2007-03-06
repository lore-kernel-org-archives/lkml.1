Return-Path: <linux-kernel-owner+w=401wt.eu-S1030462AbXCFJfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030462AbXCFJfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 04:35:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030463AbXCFJfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 04:35:38 -0500
Received: from linux.dunaweb.hu ([62.77.196.1]:42206 "EHLO linux.dunaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030462AbXCFJfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 04:35:36 -0500
Message-ID: <45ED35E0.3060402@dunaweb.hu>
Date: Tue, 06 Mar 2007 10:35:28 +0100
From: Zoltan Boszormenyi <zboszor@dunaweb.hu>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Subject: BUG in kernel-rt 2.6.20-0119.rt8
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am using kernel-rt on my FC6/x86-64 system,
the CPU is an Athlon64 X2.

It locks up very rarely (I haven't found any sign in the logs for that)
but I always get this on shutdown, I wonder if it might be related
to the lockup:

Mar  5 23:53:52 static-81-17-177-202 kernel: BUG: using 
smp_processor_id() in preemptible [00000000] code: nfsd/3939
Mar  5 23:53:52 static-81-17-177-202 kernel: caller is 
drain_array+0x25/0x132
Mar  5 23:53:52 static-81-17-177-202 kernel:
Mar  5 23:53:52 static-81-17-177-202 kernel: Call Trace:
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8026d828>] 
dump_trace+0xbd/0x3d8
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8026db87>] 
show_trace+0x44/0x6d
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8026ddc8>] 
dump_stack+0x13/0x15
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff80355e2e>] 
debug_smp_processor_id+0xe3/0xf1
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff802e01b5>] 
drain_array+0x25/0x132
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff802e07ac>] 
__cache_shrink+0xd5/0x1a6
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff802e0a47>] 
kmem_cache_destroy+0x6c/0xe3
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8878a809>] 
:nfsd:nfsd4_free_slab+0x16/0x21
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8878a824>] 
:nfsd:nfsd4_free_slabs+0x10/0x36
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8878baf9>] 
:nfsd:nfs4_state_shutdown+0x1a2/0x1ae
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff887750f8>] 
:nfsd:nfsd_last_thread+0x47/0x76
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8867f63a>] 
:sunrpc:svc_destroy+0x8d/0xd1
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8867f738>] 
:sunrpc:svc_exit_thread+0xba/0xc6
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8877595f>] 
:nfsd:nfsd+0x2a3/0x2b8
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff802600f8>] 
child_rip+0xa/0x12
Mar  5 23:53:52 static-81-17-177-202 kernel:
Mar  5 23:53:52 static-81-17-177-202 kernel: ---------------------------
Mar  5 23:53:52 static-81-17-177-202 kernel: | preempt count: 00000001 ]
Mar  5 23:53:52 static-81-17-177-202 kernel: | 1-level deep critical 
section nesting:
Mar  5 23:53:52 static-81-17-177-202 kernel: 
----------------------------------------
Mar  5 23:53:52 static-81-17-177-202 kernel: .. [<ffffffff80355ddb>] 
.... debug_smp_processor_id+0x90/0xf1
Mar  5 23:53:52 static-81-17-177-202 kernel: .....[<ffffffff802e01b5>] 
..   ( <= drain_array+0x25/0x132)
Mar  5 23:53:52 static-81-17-177-202 kernel:
Mar  5 23:53:52 static-81-17-177-202 kernel: BUG: nfsd:3939 task might 
have lost a preemption check!
Mar  5 23:53:52 static-81-17-177-202 kernel:
Mar  5 23:53:52 static-81-17-177-202 kernel: Call Trace:
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8026d828>] 
dump_trace+0xbd/0x3d8
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8026db87>] 
show_trace+0x44/0x6d
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8026ddc8>] 
dump_stack+0x13/0x15
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8028be9b>] 
preempt_enable_no_resched+0x5c/0x5e
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff80355e33>] 
debug_smp_processor_id+0xe8/0xf1
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff802e01b5>] 
drain_array+0x25/0x132
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff802e07ac>] 
__cache_shrink+0xd5/0x1a6
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff802e0a47>] 
kmem_cache_destroy+0x6c/0xe3
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8878a809>] 
:nfsd:nfsd4_free_slab+0x16/0x21
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8878a824>] 
:nfsd:nfsd4_free_slabs+0x10/0x36
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8878baf9>] 
:nfsd:nfs4_state_shutdown+0x1a2/0x1ae
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff887750f8>] 
:nfsd:nfsd_last_thread+0x47/0x76
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8867f63a>] 
:sunrpc:svc_destroy+0x8d/0xd1
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8867f738>] 
:sunrpc:svc_exit_thread+0xba/0xc6
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8877595f>] 
:nfsd:nfsd+0x2a3/0x2b8
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff802600f8>] 
child_rip+0xa/0x12
Mar  5 23:53:52 static-81-17-177-202 kernel:
Mar  5 23:53:52 static-81-17-177-202 kernel: ---------------------------
Mar  5 23:53:52 static-81-17-177-202 kernel: | preempt count: 00000000 ]
Mar  5 23:53:52 static-81-17-177-202 kernel: | 0-level deep critical 
section nesting:
Mar  5 23:53:52 static-81-17-177-202 kernel: 
----------------------------------------
Mar  5 23:53:52 static-81-17-177-202 kernel:
Mar  5 23:53:52 static-81-17-177-202 kernel: BUG: using 
smp_processor_id() in preemptible [00000000] code: nfsd/3939
Mar  5 23:53:52 static-81-17-177-202 kernel: caller is 
drain_array+0x25/0x132
Mar  5 23:53:52 static-81-17-177-202 kernel:
Mar  5 23:53:52 static-81-17-177-202 kernel: Call Trace:
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8026d828>] 
dump_trace+0xbd/0x3d8
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8026db87>] 
show_trace+0x44/0x6d
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8026ddc8>] 
dump_stack+0x13/0x15
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff80355e2e>] 
debug_smp_processor_id+0xe3/0xf1
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff802e01b5>] 
drain_array+0x25/0x132
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff802e07ac>] 
__cache_shrink+0xd5/0x1a6
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff802e0a47>] 
kmem_cache_destroy+0x6c/0xe3
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8878a809>] 
:nfsd:nfsd4_free_slab+0x16/0x21
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8878a830>] 
:nfsd:nfsd4_free_slabs+0x1c/0x36
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8878baf9>] 
:nfsd:nfs4_state_shutdown+0x1a2/0x1ae
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff887750f8>] 
:nfsd:nfsd_last_thread+0x47/0x76
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8867f63a>] 
:sunrpc:svc_destroy+0x8d/0xd1
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8867f738>] 
:sunrpc:svc_exit_thread+0xba/0xc6
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8877595f>] 
:nfsd:nfsd+0x2a3/0x2b8
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff802600f8>] 
child_rip+0xa/0x12
Mar  5 23:53:52 static-81-17-177-202 kernel:
Mar  5 23:53:52 static-81-17-177-202 kernel: ---------------------------
Mar  5 23:53:52 static-81-17-177-202 kernel: | preempt count: 00000001 ]
Mar  5 23:53:52 static-81-17-177-202 kernel: | 1-level deep critical 
section nesting:
Mar  5 23:53:52 static-81-17-177-202 kernel: 
----------------------------------------
Mar  5 23:53:52 static-81-17-177-202 kernel: .. [<ffffffff80355ddb>] 
.... debug_smp_processor_id+0x90/0xf1
Mar  5 23:53:52 static-81-17-177-202 kernel: .....[<ffffffff802e01b5>] 
..   ( <= drain_array+0x25/0x132)
Mar  5 23:53:52 static-81-17-177-202 kernel:
Mar  5 23:53:52 static-81-17-177-202 kernel: BUG: using 
smp_processor_id() in preemptible [00000000] code: nfsd/3939
Mar  5 23:53:52 static-81-17-177-202 kernel: caller is 
drain_array+0x25/0x132
Mar  5 23:53:52 static-81-17-177-202 kernel:
Mar  5 23:53:52 static-81-17-177-202 kernel: Call Trace:
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8026d828>] 
dump_trace+0xbd/0x3d8
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8026db87>] 
show_trace+0x44/0x6d
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8026ddc8>] 
dump_stack+0x13/0x15
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff80355e2e>] 
debug_smp_processor_id+0xe3/0xf1
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff802e01b5>] 
drain_array+0x25/0x132
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff802e07ac>] 
__cache_shrink+0xd5/0x1a6
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff802e0a47>] 
kmem_cache_destroy+0x6c/0xe3
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8878a809>] 
:nfsd:nfsd4_free_slab+0x16/0x21
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8878a83c>] 
:nfsd:nfsd4_free_slabs+0x28/0x36
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8878baf9>] 
:nfsd:nfs4_state_shutdown+0x1a2/0x1ae
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff887750f8>] 
:nfsd:nfsd_last_thread+0x47/0x76
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8867f63a>] 
:sunrpc:svc_destroy+0x8d/0xd1
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8867f738>] 
:sunrpc:svc_exit_thread+0xba/0xc6
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8877595f>] 
:nfsd:nfsd+0x2a3/0x2b8
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff802600f8>] 
child_rip+0xa/0x12
Mar  5 23:53:52 static-81-17-177-202 kernel:
Mar  5 23:53:52 static-81-17-177-202 kernel: ---------------------------
Mar  5 23:53:52 static-81-17-177-202 kernel: | preempt count: 00000001 ]
Mar  5 23:53:52 static-81-17-177-202 kernel: | 1-level deep critical 
section nesting:
Mar  5 23:53:52 static-81-17-177-202 kernel: 
----------------------------------------
Mar  5 23:53:52 static-81-17-177-202 kernel: .. [<ffffffff80355ddb>] 
.... debug_smp_processor_id+0x90/0xf1
Mar  5 23:53:52 static-81-17-177-202 kernel: .....[<ffffffff802e01b5>] 
..   ( <= drain_array+0x25/0x132)
Mar  5 23:53:52 static-81-17-177-202 kernel:
Mar  5 23:53:52 static-81-17-177-202 kernel: BUG: using 
smp_processor_id() in preemptible [00000000] code: nfsd/3939
Mar  5 23:53:52 static-81-17-177-202 kernel: caller is 
drain_array+0x25/0x132
Mar  5 23:53:52 static-81-17-177-202 kernel:
Mar  5 23:53:52 static-81-17-177-202 kernel: Call Trace:
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8026d828>] 
dump_trace+0xbd/0x3d8
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8026db87>] 
show_trace+0x44/0x6d
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8026ddc8>] 
dump_stack+0x13/0x15
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff80355e2e>] 
debug_smp_processor_id+0xe3/0xf1
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff802e01b5>] 
drain_array+0x25/0x132
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff802e07ac>] 
__cache_shrink+0xd5/0x1a6
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff802e0a47>] 
kmem_cache_destroy+0x6c/0xe3
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8878a809>] 
:nfsd:nfsd4_free_slab+0x16/0x21
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8878a848>] 
:nfsd:nfsd4_free_slabs+0x34/0x36
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8878baf9>] 
:nfsd:nfs4_state_shutdown+0x1a2/0x1ae
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff887750f8>] 
:nfsd:nfsd_last_thread+0x47/0x76
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8867f63a>] 
:sunrpc:svc_destroy+0x8d/0xd1
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8867f738>] 
:sunrpc:svc_exit_thread+0xba/0xc6
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff8877595f>] 
:nfsd:nfsd+0x2a3/0x2b8
Mar  5 23:53:52 static-81-17-177-202 kernel:  [<ffffffff802600f8>] 
child_rip+0xa/0x12
Mar  5 23:53:52 static-81-17-177-202 kernel:
Mar  5 23:53:52 static-81-17-177-202 kernel: ---------------------------
Mar  5 23:53:52 static-81-17-177-202 kernel: | preempt count: 00000001 ]
Mar  5 23:53:52 static-81-17-177-202 kernel: | 1-level deep critical 
section nesting:
Mar  5 23:53:52 static-81-17-177-202 kernel: 
----------------------------------------
Mar  5 23:53:52 static-81-17-177-202 kernel: .. [<ffffffff80355ddb>] 
.... debug_smp_processor_id+0x90/0xf1
Mar  5 23:53:52 static-81-17-177-202 kernel: .....[<ffffffff802e01b5>] 
..   ( <= drain_array+0x25/0x132)
Mar  5 23:53:52 static-81-17-177-202 kernel:

BTW, I am kind of forced to use kernel-rt, as the official
2.6.19 based Fedora kernel doesn't behave well on my machine.
The mainboard is an ABit KN9 SLI. With that kernel, the USB
keyboard gets crazy sometimes, repeating the last pressed key
ad infinitum which although doesn't lock up the machine but
makes it unusable as the keyboard doesn't get out of this state.
Maybe the USB subsystem misses an IRQ ACK or some ACPI
bug which is fixed in 2.6.20?

Best regards,
Zoltán Böszörményi

