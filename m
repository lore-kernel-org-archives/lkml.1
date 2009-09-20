Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbZIUABz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbZIUABz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 20:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755046AbZIUABy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 20:01:54 -0400
Received: from smtpauth18.prod.mesa1.secureserver.net ([64.202.165.31]:44549
	"HELO smtpauth18.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755007AbZIUABx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 20:01:53 -0400
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Sep 2009 20:01:53 EDT
Date: Sun, 20 Sep 2009 23:54:23 +1200
From: Kelly Bowa <kbpm@tuxedu.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Eric Paris <eparis@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: BUG: scheduling while atomic: ..
Message-ID: <20090920115423.GA28749@tuxedu.home>
Mail-Followup-To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	Eric Paris <eparis@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jens Axboe <jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
found following bug in 2.6.31-rc8. CPU model is Intel(R) Atom(TM) CPU N270. This is produced at boot time. I havent had time to look into this yet but looks like an ACPI bug to me..

<6>Checking 'hlt' instruction... OK.
<6>ACPI: Core revision 20090521
<3>BUG: scheduling while atomic: swapper/0/0x10000002
<4>Modules linked in:
<4>Pid: 0, comm: swapper Not tainted 2.6.31-git #3
<4>Call Trace:
<4> [<c0129e92>] __schedule_bug+0x4d/0x52
<4> [<c03a0354>] schedule+0x97/0xa6b
<4> [<c01b8e4a>] ? __slab_free+0xd7/0x2ab
<4> [<c01bf271>] ? put_object+0x3a/0x3d
<4> [<c02ce4d8>] ? acpi_debug_print+0xa/0xc2
<4> [<c02cb15d>] ? acpi_ps_pop_scope+0x79/0x84
<4> [<c02ce4d8>] ? acpi_debug_print+0xa/0xc2
<4> [<c012ba43>] __cond_resched+0x17/0x23
<4> [<c03a0e2e>] _cond_resched+0x20/0x2b
<4> [<c02ca71c>] acpi_ps_complete_op+0x214/0x223
<4> [<c02c9a8d>] ? acpi_ps_get_next_simple_arg+0xe0/0xeb
<4> [<c02cad98>] acpi_ps_parse_loop+0x66d/0x7bd
<4> [<c02ca089>] acpi_ps_parse_aml+0xd4/0x324
<4> [<c02c909a>] acpi_ns_one_complete_parse+0x10e/0x124
<4> [<c02c90e9>] acpi_ns_parse_table+0x39/0x78
<4> [<c02c5f57>] acpi_ns_load_table+0x63/0xe0
<4> [<c02ccea6>] acpi_load_tables+0x6b/0x13e
<4> [<c05606d1>] acpi_early_init+0x5d/0xeb
<4> [<c054180c>] start_kernel+0x2ce/0x2dd
<4> [<c0541091>] __init_begin+0x91/0x96
<3>BUG: scheduling while atomic: swapper/0/0x10000002
<4>Modules linked in:
<4>Pid: 0, comm: swapper Not tainted 2.6.31-git #3
<4>Call Trace:
<4> [<c0129e92>] __schedule_bug+0x4d/0x52
<4> [<c03a0354>] schedule+0x97/0xa6b
<4> [<c01b8e4a>] ? __slab_free+0xd7/0x2ab
<4> [<c01bf271>] ? put_object+0x3a/0x3d
<4> [<c02ce4d8>] ? acpi_debug_print+0xa/0xc2
<4> [<c02cb15d>] ? acpi_ps_pop_scope+0x79/0x84
<4> [<c02ce4d8>] ? acpi_debug_print+0xa/0xc2
<4> [<c012ba43>] __cond_resched+0x17/0x23
<4> [<c03a0e2e>] _cond_resched+0x20/0x2b
<4> [<c02ca71c>] acpi_ps_complete_op+0x214/0x223
<4> [<c02cad98>] acpi_ps_parse_loop+0x66d/0x7bd
<4> [<c02ca089>] acpi_ps_parse_aml+0xd4/0x324
<4> [<c02c909a>] acpi_ns_one_complete_parse+0x10e/0x124
<4> [<c02c90e9>] acpi_ns_parse_table+0x39/0x78
<4> [<c02c5f57>] acpi_ns_load_table+0x63/0xe0
<4> [<c02ccea6>] acpi_load_tables+0x6b/0x13e
<4> [<c05606d1>] acpi_early_init+0x5d/0xeb
<4> [<c054180c>] start_kernel+0x2ce/0x2dd
<4> [<c0541091>] __init_begin+0x91/0x96
<3>BUG: scheduling while atomic: swapper/0/0x10000002
<4>Modules linked in:
<4>Pid: 0, comm: swapper Not tainted 2.6.31-git #3
<4>Call Trace:
<4> [<c0129e92>] __schedule_bug+0x4d/0x52
<4> [<c03a0354>] schedule+0x97/0xa6b
<4> [<c01b8e4a>] ? __slab_free+0xd7/0x2ab
<4> [<c01bf271>] ? put_object+0x3a/0x3d
<4> [<c02ce4d8>] ? acpi_debug_print+0xa/0xc2
<4> [<c02cb15d>] ? acpi_ps_pop_scope+0x79/0x84
<4> [<c02ce4d8>] ? acpi_debug_print+0xa/0xc2
<4> [<c012ba43>] __cond_resched+0x17/0x23
<4> [<c03a0e2e>] _cond_resched+0x20/0x2b
<4> [<c02ca71c>] acpi_ps_complete_op+0x214/0x223
<4> [<c02cad98>] acpi_ps_parse_loop+0x66d/0x7bd
<4> [<c02ca089>] acpi_ps_parse_aml+0xd4/0x324
<4> [<c02c909a>] acpi_ns_one_complete_parse+0x10e/0x124
<4> [<c02c90e9>] acpi_ns_parse_table+0x39/0x78
<4> [<c02c5f57>] acpi_ns_load_table+0x63/0xe0
<4> [<c02ccea6>] acpi_load_tables+0x6b/0x13e
<4> [<c05606d1>] acpi_early_init+0x5d/0xeb
<4> [<c054180c>] start_kernel+0x2ce/0x2dd
<4> [<c0541091>] __init_begin+0x91/0x96
<3>BUG: scheduling while atomic: swapper/0/0x10000002
<4>Modules linked in:
<4>Pid: 0, comm: swapper Not tainted 2.6.31-git #3
<4>Call Trace:
<4> [<c0129e92>] __schedule_bug+0x4d/0x52
<4> [<c03a0354>] schedule+0x97/0xa6b
<4> [<c01b7e49>] ? init_object+0xe/0x67
<4> [<c03a49d1>] ? sub_preempt_count+0x9/0x9f
<4> [<c01ba21f>] ? kmem_cache_free+0x85/0xd5
<4> [<c02abae5>] ? acpi_os_release_object+0xd/0x11
<4> [<c02abae5>] ? acpi_os_release_object+0xd/0x11
<4> [<c02abae5>] ? acpi_os_release_object+0xd/0x11
<4> [<c02cb2c3>] ? acpi_ps_free_op+0x51/0x56
<4> [<c02cafd0>] ? acpi_ps_delete_parse_tree+0x38/0x50
<4> [<c012ba43>] __cond_resched+0x17/0x23
<4> [<c03a0e2e>] _cond_resched+0x20/0x2b
<4> [<c02ca71c>] acpi_ps_complete_op+0x214/0x223
<4> [<c02b8ab9>] ? acpi_ds_load2_end_op+0x1b3/0x3f6
<4> [<c02cad98>] acpi_ps_parse_loop+0x66d/0x7bd
<4> [<c02ca089>] acpi_ps_parse_aml+0xd4/0x324
<4> [<c02c909a>] acpi_ns_one_complete_parse+0x10e/0x124
<4> [<c02c911b>] acpi_ns_parse_table+0x6b/0x78
<4> [<c02c5f57>] acpi_ns_load_table+0x63/0xe0
<4> [<c02ccea6>] acpi_load_tables+0x6b/0x13e
<4> [<c05606d1>] acpi_early_init+0x5d/0xeb
<4> [<c054180c>] start_kernel+0x2ce/0x2dd
<4> [<c0541091>] __init_begin+0x91/0x96
<3>BUG: scheduling while atomic: swapper/0/0x10000002
<4>Modules linked in:
<4>Pid: 0, comm: swapper Not tainted 2.6.31-git #3
<4>Call Trace:
<4> [<c0129e92>] __schedule_bug+0x4d/0x52
<4> [<c03a0354>] schedule+0x97/0xa6b
<4> [<c01b8e4a>] ? __slab_free+0xd7/0x2ab
<4> [<c01bf271>] ? put_object+0x3a/0x3d
<4> [<c02ce4d8>] ? acpi_debug_print+0xa/0xc2
<4> [<c02cb15d>] ? acpi_ps_pop_scope+0x79/0x84
<4> [<c02ce4d8>] ? acpi_debug_print+0xa/0xc2
<4> [<c012ba43>] __cond_resched+0x17/0x23
<4> [<c03a0e2e>] _cond_resched+0x20/0x2b
<4> [<c02ca71c>] acpi_ps_complete_op+0x214/0x223
<4> [<c02cb21c>] ? acpi_ps_init_op+0x8/0x12
<4> [<c02c9a8d>] ? acpi_ps_get_next_simple_arg+0xe0/0xeb
<4> [<c02cad98>] acpi_ps_parse_loop+0x66d/0x7bd
<4> [<c02ca089>] acpi_ps_parse_aml+0xd4/0x324
<4> [<c02c909a>] acpi_ns_one_complete_parse+0x10e/0x124
<4> [<c02c911b>] acpi_ns_parse_table+0x6b/0x78
<4> [<c02c5f57>] acpi_ns_load_table+0x63/0xe0
<4> [<c02ccea6>] acpi_load_tables+0x6b/0x13e
<4> [<c05606d1>] acpi_early_init+0x5d/0xeb
<4> [<c054180c>] start_kernel+0x2ce/0x2dd
<4> [<c0541091>] __init_begin+0x91/0x96
<3>BUG: scheduling while atomic: swapper/0/0x10000002
<4>Modules linked in:
<4>Pid: 0, comm: swapper Not tainted 2.6.31-git #3
<4>Call Trace:
<4> [<c0129e92>] __schedule_bug+0x4d/0x52
<4> [<c03a0354>] schedule+0x97/0xa6b
<4> [<c01b7e49>] ? init_object+0xe/0x67
<4> [<c03a49d1>] ? sub_preempt_count+0x9/0x9f
<4> [<c01ba21f>] ? kmem_cache_free+0x85/0xd5
<4> [<c02abae5>] ? acpi_os_release_object+0xd/0x11
<4> [<c02abae5>] ? acpi_os_release_object+0xd/0x11
<4> [<c02abae5>] ? acpi_os_release_object+0xd/0x11
<4> [<c02cb2c3>] ? acpi_ps_free_op+0x51/0x56
<4> [<c02cafd0>] ? acpi_ps_delete_parse_tree+0x38/0x50
<4> [<c012ba43>] __cond_resched+0x17/0x23
<4> [<c03a0e2e>] _cond_resched+0x20/0x2b
<4> [<c02ca71c>] acpi_ps_complete_op+0x214/0x223
<4> [<c02b8ab9>] ? acpi_ds_load2_end_op+0x1b3/0x3f6
<4> [<c02cad98>] acpi_ps_parse_loop+0x66d/0x7bd
<4> [<c02ca089>] acpi_ps_parse_aml+0xd4/0x324
<4> [<c02c909a>] acpi_ns_one_complete_parse+0x10e/0x124
<4> [<c02c911b>] acpi_ns_parse_table+0x6b/0x78
<4> [<c02c5f57>] acpi_ns_load_table+0x63/0xe0
<4> [<c02ccea6>] acpi_load_tables+0x6b/0x13e
<4> [<c05606d1>] acpi_early_init+0x5d/0xeb
<4> [<c054180c>] start_kernel+0x2ce/0x2dd
<4> [<c0541091>] __init_begin+0x91/0x96
<6>ftrace: converting mcount calls to 0f 1f 44 00 00
<6>ftrace: allocating 14224 entries in 28 pages
<6>..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
<6>CPU0: Intel(R) Atom(TM) CPU N270   @ 1.60GHz stepping 02
<6>Booting processor 1 APIC 0x1 ip 0x6000
<6>Initializing CPU#1
.....

<3>BUG: using smp_processor_id() in preemptible [00000000] code: events/0/9
<4>caller is vmstat_update+0x14/0x3e
<4>Pid: 9, comm: events/0 Not tainted 2.6.31-git #3
<4>Call Trace:
<4> [<c039ff98>] ? printk+0x14/0x1c
<4> [<c0284e7a>] debug_smp_processor_id+0x9e/0xb4
<4> [<c01a4749>] vmstat_update+0x14/0x3e
<4> [<c0144a30>] worker_thread+0x15f/0x1e8
<4> [<c01a4735>] ? vmstat_update+0x0/0x3e
<4> [<c014809f>] ? autoremove_wake_function+0x0/0x38
<4> [<c01448d1>] ? worker_thread+0x0/0x1e8
<4> [<c0147d9e>] kthread+0x66/0x6b
<4> [<c0147d38>] ? kthread+0x0/0x6b
<4> [<c01035cf>] kernel_thread_helper+0x7/0x10
<3>BUG: using smp_processor_id() in preemptible [00000000] code: events/0/9
<4>caller is vmstat_update+0x2a/0x3e
<4>Pid: 9, comm: events/0 Not tainted 2.6.31-git #3
<4>Call Trace:
<4> [<c039ff98>] ? printk+0x14/0x1c
<4> [<c0284e7a>] debug_smp_processor_id+0x9e/0xb4
<4> [<c01a475f>] vmstat_update+0x2a/0x3e
<4> [<c0144a30>] worker_thread+0x15f/0x1e8
<4> [<c01a4735>] ? vmstat_update+0x0/0x3e
<4> [<c014809f>] ? autoremove_wake_function+0x0/0x38
<4> [<c01448d1>] ? worker_thread+0x0/0x1e8
<4> [<c0147d9e>] kthread+0x66/0x6b
<4> [<c0147d38>] ? kthread+0x0/0x6b
<4> [<c01035cf>] kernel_thread_helper+0x7/0x10

kbpm
