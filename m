Return-Path: <linux-kernel-owner+w=401wt.eu-S1757977AbXIXDZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977AbXIXDZl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 23:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbXIXDZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 23:25:34 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:43188 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbXIXDZc (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 23:25:32 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Matt Mackall <mpm@selenic.com>, Dave Airlie <airlied@gmail.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
In-Reply-To: Your message of "Fri, 21 Sep 2007 21:43:20 +0200."
             <46F41ED8.3020301@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46F10B69.5070008@gmail.com> <46F10DCB.1090302@gmail.com> <46F13938.1070709@gmail.com> <20070919121017.0cbcbc30.akpm@linux-foundation.org> <20070919192453.GB18707@one.firstfloor.org> <21d7e9970709191842h3111390cl8f09745bed6bd8f9@mail.gmail.com> <20070920220604.GA17536@waste.org> <10207.1190394975@turing-police.cc.vt.edu> <46F3FF9C.7040200@gmail.com> <4109.1190403228@turing-police.cc.vt.edu> <46F41DC0.9060407@gmail.com>
            <46F41ED8.3020301@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1190604314_7192P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 23 Sep 2007 23:25:14 -0400
Message-ID: <18727.1190604314@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190604314_7192P
Content-Type: text/plain; charset=us-ascii

On Fri, 21 Sep 2007 21:43:20 +0200, Jiri Slaby said:
> On 09/21/2007 09:38 PM, Jiri Slaby wrote:
> > It is rather the other user who adds the page to some other list while bein
g at
> > deferred_pages list. Could you try my debug patch
> > (http://lkml.org/lkml/2007/9/19/141)?
> 
> or the whitespace non-damaged version:
> http://www.fi.muni.cz/~xslaby/sklad/pageattr_debug

Gaak. Is that thing *supposed* to spew zillions of lines of output?

Some of the hits we get (I'm wondering if anything after the first makes
any sense, or if we're just slowly watching the corruption spread - the
thing ended up near 23K lines long before I gave up and hit the poweroff
button because there was no end in sight):

(If there's something specific you want me to find in the output,
like "the first time we see XYZ", yell...)

[  103.701000] POISONS (ffff81000117dc88): ffff810006d14000, ffff8100034225c0
[  103.701000]
[  103.701000] Call Trace:
[  103.701000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[  103.701000]  [<ffffffff80358117>] list_add+0xc/0x11
[  103.701000]  [<ffffffff80270865>] free_hot_cold_page+0xe8/0x16d
[  103.701000]  [<ffffffff8027093e>] free_hot_page+0xb/0xd
[  103.701000]  [<ffffffff80270958>] __free_pages+0x18/0x21
[  103.701000]  [<ffffffff80270990>] free_pages+0x2f/0x34
[  103.701000]  [<ffffffff8028922d>] kmem_freepages+0xc5/0xce
[  103.701000]  [<ffffffff8028957f>] slab_destroy+0x3c/0x53
[  103.701000]  [<ffffffff80289663>] free_block+0xcd/0x110
[  103.701000]  [<ffffffff8028973a>] drain_array+0x94/0xc9
[  103.701000]  [<ffffffff8028a8c3>] cache_reap+0x0/0x105
[  103.701000]  [<ffffffff8028a948>] cache_reap+0x85/0x105
[  103.701000]  [<ffffffff80243d5d>] run_workqueue+0x8e/0x125
[  103.701000]  [<ffffffff8024478d>] worker_thread+0x0/0xe7
[  103.701000]  [<ffffffff80244869>] worker_thread+0xdc/0xe7
[  103.701000]  [<ffffffff80247f13>] autoremove_wake_function+0x0/0x38
[  103.701000]  [<ffffffff80247ddd>] kthread+0x49/0x78
[  103.701000]  [<ffffffff8020cfc8>] child_rip+0xa/0x12
[  103.701000]  [<ffffffff80247d94>] kthread+0x0/0x78
[  103.701000]  [<ffffffff8020cfbe>] child_rip+0x0/0x12
[  103.701000]

[  103.701000] POISONS (ffff81000117eac0): ffff810006d55000, ffff8100034225c0
[  103.701000]
[  103.701000] Call Trace:
[  103.701000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[  103.701000]  [<ffffffff80358117>] list_add+0xc/0x11
[  103.701000]  [<ffffffff80270865>] free_hot_cold_page+0xe8/0x16d
[  103.701000]  [<ffffffff8027093e>] free_hot_page+0xb/0xd
[  103.701000]  [<ffffffff80270958>] __free_pages+0x18/0x21
[  103.701000]  [<ffffffff80270990>] free_pages+0x2f/0x34
[  103.701000]  [<ffffffff8028922d>] kmem_freepages+0xc5/0xce
[  103.701000]  [<ffffffff8028957f>] slab_destroy+0x3c/0x53
[  103.701000]  [<ffffffff80289663>] free_block+0xcd/0x110
[  103.701000]  [<ffffffff8028973a>] drain_array+0x94/0xc9
[  103.701000]  [<ffffffff8028a8c3>] cache_reap+0x0/0x105
[  103.701000]  [<ffffffff8028a948>] cache_reap+0x85/0x105
[  103.701000]  [<ffffffff80243d5d>] run_workqueue+0x8e/0x125
[  103.701000]  [<ffffffff8024478d>] worker_thread+0x0/0xe7
[  103.701000]  [<ffffffff80244869>] worker_thread+0xdc/0xe7
[  103.701000]  [<ffffffff80247f13>] autoremove_wake_function+0x0/0x38
[  103.701000]  [<ffffffff80247ddd>] kthread+0x49/0x78
[  103.701000]  [<ffffffff8020cfc8>] child_rip+0xa/0x12
[  103.701000]  [<ffffffff80247d94>] kthread+0x0/0x78
[  103.701000]  [<ffffffff8020cfbe>] child_rip+0x0/0x12
[  103.701000]
(That trace repeats 16 times, then we see:)
[  106.284000] POISONS (ffff810004432810): ffff810005291378, ffff81000524e618
[  106.284000] 
[  106.284000] Call Trace:
[  106.284000]  [<ffffffff80517086>] __down_write_nested+0x3d/0xa1
[  106.284000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[  106.284000]  [<ffffffff802765fe>] vma_prio_tree_add+0xc9/0xe0
[  106.284000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[  106.284000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[  106.284000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[  106.284000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[  106.284000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[  106.284000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[  106.284000] 
..
[  106.284000] POISONS (ffff810004432768): ffff81000524e618, ffff81000524e618
[  106.284000]
[  106.284000] Call Trace:
[  106.284000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[  106.284000]  [<ffffffff802765fe>] vma_prio_tree_add+0xc9/0xe0
[  106.284000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[  106.284000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[  106.284000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[  106.284000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[  106.284000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[  106.284000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[  106.284000]  
...
[  106.285000] POISONS (ffff810003637b30): ffff810003637c18, 0000000000000246
[  106.285000]
[  106.285000] Call Trace:
[  106.285000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[  106.285000]  [<ffffffff80358117>] list_add+0xc/0x11
[  106.285000]  [<ffffffff80248110>] add_wait_queue+0x2c/0x40
[  106.285000]  [<ffffffff8029ac28>] __pollwait+0xd6/0xdf
[  106.285000]  [<ffffffff802b80a3>] inotify_poll+0x29/0x5c
[  106.285000]  [<ffffffff8029a498>] do_select+0x2fa/0x50d
[  106.285000]  [<ffffffff8029ab52>] __pollwait+0x0/0xdf
[  106.285000]  [<ffffffff8022d480>] default_wake_function+0x0/0xf
[  106.285000]  [<ffffffff8051471d>] __down_trylock+0x4d/0x5a
[  106.285000]  [<ffffffff80517241>] __down_failed_trylock+0x35/0x3a
[  106.285000]  [<ffffffff8022c1b3>] __update_rq_clock+0x1a/0xe5
[  106.285000]  [<ffffffff80270e41>] __alloc_pages+0x5c/0x2b5
[  106.285000]  [<ffffffff8029a89e>] core_sys_select+0x1f3/0x2a2
[  106.285000]  [<ffffffff802453c3>] alloc_pid+0x2f8/0x34f
[  106.285000]  [<ffffffff80353c5b>] __up_read+0x7a/0x83
[  106.285000]  [<ffffffff8024b25b>] up_read+0x9/0xb
[  106.285000]  [<ffffffff80519a92>] do_page_fault+0x405/0x7ac
[  106.285000]  [<ffffffff8029acf0>] sys_select+0xbf/0x17b
[  106.285000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[  106.285000] POISONS (ffff810003637ba0): ffffffff8060ff48, ffffffff8051471d
[  106.285000]
[  106.285000] Call Trace:
[  106.285000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[  106.285000]  [<ffffffff80358117>] list_add+0xc/0x11
[  106.285000]  [<ffffffff80248110>] add_wait_queue+0x2c/0x40
[  106.285000]  [<ffffffff8029ac28>] __pollwait+0xd6/0xdf
[  106.285000]  [<ffffffff80477b83>] datagram_poll+0x23/0xd5
[  106.285000]  [<ffffffff8046ea63>] sock_poll+0x18/0x1a
[  106.285000]  [<ffffffff8029a498>] do_select+0x2fa/0x50d
[  106.285000]  [<ffffffff8029ab52>] __pollwait+0x0/0xdf
[  106.285000]  [<ffffffff8022d480>] default_wake_function+0x0/0xf
[  106.285000]  [<ffffffff8022d480>] default_wake_function+0x0/0xf
[  106.285000]  [<ffffffff8022d480>] default_wake_function+0x0/0xf
[  106.285000]  [<ffffffff8051471d>] __down_trylock+0x4d/0x5a
[  106.285000]  [<ffffffff80517241>] __down_failed_trylock+0x35/0x3a
[  106.285000]  [<ffffffff8022c1b3>] __update_rq_clock+0x1a/0xe5
[  106.285000]  [<ffffffff80270e41>] __alloc_pages+0x5c/0x2b5
[  106.285000]  [<ffffffff8029a89e>] core_sys_select+0x1f3/0x2a2
[  106.285000]  [<ffffffff802453c3>] alloc_pid+0x2f8/0x34f
[  106.285000]  [<ffffffff80353c5b>] __up_read+0x7a/0x83
[  106.285000]  [<ffffffff8024b25b>] up_read+0x9/0xb
[  106.285000]  [<ffffffff80519a92>] do_page_fault+0x405/0x7ac
[  106.285000]  [<ffffffff8029acf0>] sys_select+0xbf/0x17b
[  106.285000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[  106.285000] POISONS (ffff810003637ba0): ffffffff8060ff48, ffffffff8051471d
[  106.285000]
[  106.285000] Call Trace:
[  106.285000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[  106.285000]  [<ffffffff80358117>] list_add+0xc/0x11
[  106.285000]  [<ffffffff80248110>] add_wait_queue+0x2c/0x40
[  106.285000]  [<ffffffff8029ac28>] __pollwait+0xd6/0xdf
[  106.285000]  [<ffffffff80477b83>] datagram_poll+0x23/0xd5
[  106.285000]  [<ffffffff8046ea63>] sock_poll+0x18/0x1a
[  106.285000]  [<ffffffff8029a498>] do_select+0x2fa/0x50d
[  106.285000]  [<ffffffff8029ab52>] __pollwait+0x0/0xdf
[  106.285000]  [<ffffffff8022d480>] default_wake_function+0x0/0xf
[  106.285000]  [<ffffffff8022d480>] default_wake_function+0x0/0xf
[  106.285000]  [<ffffffff8022d480>] default_wake_function+0x0/0xf
[  106.285000]  [<ffffffff8051471d>] __down_trylock+0x4d/0x5a
[  106.285000]  [<ffffffff80517241>] __down_failed_trylock+0x35/0x3a
[  106.285000]  [<ffffffff8022c1b3>] __update_rq_clock+0x1a/0xe5
[  106.285000]  [<ffffffff80270e41>] __alloc_pages+0x5c/0x2b5
[  106.285000]  [<ffffffff8029a89e>] core_sys_select+0x1f3/0x2a2
[  106.285000]  [<ffffffff802453c3>] alloc_pid+0x2f8/0x34f
[  106.285000]  [<ffffffff80353c5b>] __up_read+0x7a/0x83
[  106.285000]  [<ffffffff8024b25b>] up_read+0x9/0xb
[  106.285000]  [<ffffffff80519a92>] do_page_fault+0x405/0x7ac
[  106.285000]  [<ffffffff8029acf0>] sys_select+0xbf/0x17b
[  106.285000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[  106.285000] 
...
[  109.705000] POISONS (ffff8100047638c8): 0000000000200200, 0000000000000000
[  109.705000]
[  109.705000] Call Trace:
[  109.705000]  <IRQ>  [<ffffffff803580aa>] __list_add+0xd7/0x138
[  109.705000]  [<ffffffff8023c44c>] internal_add_timer+0xbb/0xbd
[  109.705000]  [<ffffffff8023d0a2>] __mod_timer+0xb8/0xd6
[  109.705000]  [<ffffffff803ec908>] ata_qc_issue+0x4bd/0x517
[  109.705000]  [<ffffffff8023d306>] mod_timer+0x3d/0x42
[  109.705000]  [<ffffffff8034a3d2>] as_antic_waitnext+0x33/0x41
[  109.705000]  [<ffffffff8034b10f>] as_dispatch_request+0x1e0/0x3e6
[  109.705000]  [<ffffffff8034206b>] elv_next_request+0x1a1/0x1b3
[  109.705000]  [<ffffffff803e1032>] scsi_request_fn+0x74/0x345
[  109.826000]  [<ffffffff803463cd>] blk_run_queue+0x42/0x75
[  109.826000]  [<ffffffff803df887>] scsi_run_queue+0x1d1/0x1e0
[  109.826000]  [<ffffffff803dfaa4>] scsi_next_command+0x36/0x46
[  109.826000]  [<ffffffff803dfcf4>] scsi_end_request+0xc2/0xd5
[  109.826000]  [<ffffffff803dff6d>] scsi_io_completion+0x105/0x34f
[  109.826000]  [<ffffffff803eca57>] ata_hsm_qc_complete+0xf5/0xfe
[  109.826000]  [<ffffffff803e7737>] sd_rw_intr+0x184/0x1b2
[  109.826000]  [<ffffffff803e07dc>] scsi_device_unbusy+0x89/0x91
[  109.826000]  [<ffffffff803dbd05>] scsi_finish_command+0x56/0x5f
[  109.826000]  [<ffffffff803e093e>] scsi_softirq_done+0xd0/0xd8
[  109.826000]  [<ffffffff803f1438>] ata_interrupt+0x20c/0x224
[  109.826000]  [<ffffffff80346784>] blk_done_softirq+0x63/0x72
[  109.826000]  [<ffffffff802395ad>] __do_softirq+0x57/0xc7
[  109.826000]  [<ffffffff8020d32c>] call_softirq+0x1c/0x28
[  109.826000]  [<ffffffff8020e916>] do_softirq+0x34/0x87
[  109.826000]  [<ffffffff80239443>] irq_exit+0x3f/0x90
[  109.826000]  [<ffffffff8020eaad>] do_IRQ+0x144/0x167
[  109.826000]  [<ffffffff8020c691>] ret_from_intr+0x0/0xa
[  109.826000]  <EOI>  [<ffffffff880135ef>] :processor:acpi_idle_enter_bm+0x2cd/0x346
[  109.826000]  [<ffffffff880135e5>] :processor:acpi_idle_enter_bm+0x2c3/0x346
[  109.826000]  [<ffffffff8043caca>] menu_select+0x6b/0x94
[  109.826000]  [<ffffffff8043bbb9>] cpuidle_idle_call+0x71/0x9e
[  109.826000]  [<ffffffff8043bb48>] cpuidle_idle_call+0x0/0x9e
[  109.826000]  [<ffffffff8020aefc>] cpu_idle+0xca/0x110
[  109.826000]  [<ffffffff80514fb8>] rest_init+0x7c/0x7e
[  109.826000]  [<ffffffff806d5ac6>] start_kernel+0x2c9/0x2d4
[  109.826000]  [<ffffffff806d5111>] _sinittext+0x111/0x118
[  109.826000]
...
[  111.313000] POISONS (ffff810003637b68): 00007fffd149e2a0, ffff810003637be8
[  111.313000]
[  111.313000] Call Trace:
[  111.313000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[  111.313000]  [<ffffffff80358117>] list_add+0xc/0x11
[  111.313000]  [<ffffffff80248110>] add_wait_queue+0x2c/0x40
[  111.313000]  [<ffffffff8029ac28>] __pollwait+0xd6/0xdf
[  111.313000]  [<ffffffff80477b83>] datagram_poll+0x23/0xd5
[  111.313000]  [<ffffffff8046ea63>] sock_poll+0x18/0x1a
[  111.313000]  [<ffffffff8029a498>] do_select+0x2fa/0x50d
[  111.313000]  [<ffffffff8029ab52>] __pollwait+0x0/0xdf
[  111.313000]  [<ffffffff8022d480>] default_wake_function+0x0/0xf
[  111.313000]  [<ffffffff8022d480>] default_wake_function+0x0/0xf
[  111.313000]  [<ffffffff80519a92>] do_page_fault+0x405/0x7ac
[  111.313000]  [<ffffffff80323c61>] inode_has_perm+0x6b/0x7a
[  111.313000]  [<ffffffff8032840f>] selinux_inode_permission+0x98/0x9d
[  111.313000]  [<ffffffff80322dbf>] avc_has_perm+0x4c/0x5e
[  111.313000]  [<ffffffff8029a89e>] core_sys_select+0x1f3/0x2a2
[  111.313000]  [<ffffffff80353c5b>] __up_read+0x7a/0x83
[  111.313000]  [<ffffffff80248153>] remove_wait_queue+0x2f/0x38
[  111.313000]  [<ffffffff8029acf0>] sys_select+0xbf/0x17b
[  111.313000]  [<ffffffff8022d480>] default_wake_function+0x0/0xf
[  111.313000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[  111.313000]


--==_Exmh_1190604314_7192P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG9y4acC3lWbTT17ARAk2iAJ4s4oJ0gr4wICJ+C7siohrr1tcNXACg3c7z
cvFLRrpkZ9Y9/r5zXt/IH/4=
=CSpO
-----END PGP SIGNATURE-----

--==_Exmh_1190604314_7192P--
