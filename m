Return-Path: <linux-kernel-owner+w=401wt.eu-S1764098AbZAIAeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764098AbZAIAeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 19:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756681AbZAIAeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 19:34:11 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:8017 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbZAIAeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 19:34:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pNMNgvz/ltA+cYq66sPGGKc/ZiaA07wC8QoKJ0NK+rChp8UW7oKJXgegeP4Xlo4EqG
         J31tzSrcMtGJyhf4tVvSShep0+jTTIX9KTuADHsP9Nq6ZSkzEQbSDrD5TXCc0TatRjd3
         l/jNKYSxDwtLojqrtTjjdRxtoCJVVDbjTuXnI=
Message-ID: <49669B77.9030706@gmail.com>
Date: Thu, 08 Jan 2009 16:33:59 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081126)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jeff Garzik <jgarzik@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [fix] Too async libata breakage
References: <b6fcc0a0901081202m30be591fse66e7f38477e0c0c@mail.gmail.com> <20090108221753.78648cd6@daedalus.pq.iki.fi> <20090108125317.648397d2@infradead.org> <49667C36.4080300@gmail.com> <20090108143127.437c15de@infradead.org> <4966974B.3090700@gmail.com> <alpine.LFD.2.00.0901081619330.3322@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901081619330.3322@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Thu, 8 Jan 2009, Justin P. Mattock wrote:
>   
>> O.K. attached is the results of
>> dmesg after doing a git-pull
>> (system didn't freeze, but there's
>> a slew of warnings); i.g.
>>     
>
> That's a different thing now - some very annoying warnings indeed.
>
> Tejun, I think it's yours. And I think it should be removed, or at the 
> very least changed into a WARN_ON_ONCE. Because spamming the console with 
> this is not a good idea:
>
> 		Linus
>
>   
That's fine.
better than having the machine freeze,
three times, before a bootup.

regards;

Justin P. Mattock
>> [    1.739745] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
>> [    1.741682] Hardware name: MacBookPro2,2
>> [    1.741682] Modules linked in:
>> [    1.741682] Pid: 1, comm: swapper Not tainted 2.6.28-07812-g5fbbf5f #9
>> [    1.741682] Call Trace:
>> [    1.741682]  [<c01292ca>] warn_slowpath+0x76/0xad
>> [    1.741682]  [<c0263865>] ? cfb_fillrect+0x182/0x275
>> [    1.741682]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
>> [    1.741682]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
>> [    1.741682]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
>> [    1.741682]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
>> [    1.741682]  [<c015a307>] handle_IRQ_event+0x34/0x69
>> [    1.741682]  [<c015b47e>] handle_edge_irq+0xc8/0x109
>> [    1.741682]  [<c0104bc9>] do_IRQ+0x92/0xad
>> [    1.741682]  [<c010396c>] common_interrupt+0x2c/0x34
>> [    1.741682]  [<c012007b>] ? sched_debug_show+0x803/0xbbd
>> [    1.741682]  [<c012da4f>] ? __do_softirq+0x6b/0x154
>> [    1.741682]  [<c012db6c>] ? do_softirq+0x34/0x7e
>> [    1.741682]  [<c012db8a>] do_softirq+0x52/0x7e
>> [    1.741682]  [<c012dcd6>] irq_exit+0x49/0x77
>> [    1.741682]  [<c03e56e9>] __irqentry_text_start+0x79/0x87
>> [    1.741682]  [<c0103aa1>] apic_timer_interrupt+0x2d/0x34
>> [    1.741682]  [<c0129e84>] ? vprintk+0x2aa/0x2d5
>> [    1.741682]  [<c03df731>] printk+0x14/0x1b
>> [    1.741682]  [<c05780e8>] mousedev_init+0x70/0x78
>> [    1.741682]  [<c0101137>] _stext+0x4f/0x127
>> [    1.741682]  [<c0578078>] ? mousedev_init+0x0/0x78
>> [    1.741682]  [<c015be1c>] ? register_irq_proc+0x84/0xa0
>> [    1.741682]  [<c015be90>] ? init_irq_proc+0x58/0x65
>> [    1.741682]  [<c055a309>] kernel_init+0x105/0x156
>> [    1.741682]  [<c055a204>] ? kernel_init+0x0/0x156
>> [    1.741682]  [<c0103bcb>] kernel_thread_helper+0x7/0x10
>> [    1.741682] ---[ end trace a1303c5fb15c2002 ]---
>>
>> [    2.013026] ------------[ cut here ]------------
>> [    2.013028] WARNING: at drivers/ata/libata-sff.c:1017
>> ata_sff_hsm_move+0x49c/0x6d0()
>> [    2.013030] Hardware name: MacBookPro2,2
>> [    2.013031] Modules linked in:
>> [    2.013033] Pid: 578, comm: scsi_eh_3 Tainted: G        W
>> 2.6.28-07812-g5fbbf5f #9
>> [    2.013035] Call Trace:
>> [    2.013038]  [<c01292ca>] warn_slowpath+0x76/0xad
>> [    2.013042]  [<c011bbac>] ? update_curr+0xae/0x189
>> [    2.013045]  [<c011e7c1>] ? dequeue_entity+0x1b/0x20d
>> [    2.013048]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
>> [    2.013050]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
>> [    2.013053]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
>> [    2.013056]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
>> [    2.013059]  [<c015a307>] handle_IRQ_event+0x34/0x69
>> [    2.013061]  [<c015b47e>] handle_edge_irq+0xc8/0x109
>> [    2.013064]  [<c0104bc9>] do_IRQ+0x92/0xad
>> [    2.013066]  [<c010396c>] common_interrupt+0x2c/0x34
>> [    2.013068]  [<c012007b>] ? sched_debug_show+0x803/0xbbd
>> [    2.013071]  [<c012da4f>] ? __do_softirq+0x6b/0x154
>> [    2.013073]  [<c012db6c>] ? do_softirq+0x34/0x7e
>> [    2.013075]  [<c012db8a>] do_softirq+0x52/0x7e
>> [    2.013077]  [<c012dcd6>] irq_exit+0x49/0x77
>> [    2.013080]  [<c03e56e9>] __irqentry_text_start+0x79/0x87
>> [    2.013082]  [<c0103aa1>] apic_timer_interrupt+0x2d/0x34
>> [    2.013085]  [<c03e007b>] ? schedule+0x695/0x8f1
>> [    2.013088]  [<c03e214c>] ? _spin_unlock_irqrestore+0x31/0x3c
>> [    2.013090]  [<c02e8818>] ata_eh_thaw_port+0x3b/0x3f
>> [    2.013093]  [<c02e94b4>] ata_eh_reset+0x6cc/0x9bd
>> [    2.013096]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
>> [    2.013098]  [<c02eeb26>] ? ata_sff_prereset+0x0/0x9e
>> [    2.013101]  [<c02eea18>] ? ata_sff_softreset+0x0/0x10e
>> [    2.013105]  [<c02e032a>] ? ata_dev_init+0x5d/0x80
>> [    2.013107]  [<c02ead0a>] ata_eh_recover+0x29c/0xafd
>> [    2.013110]  [<c02eea18>] ? ata_sff_softreset+0x0/0x10e
>> [    2.013112]  [<c02ecf23>] ? ata_sff_postreset+0x0/0x5a
>> [    2.013115]  [<c02eea18>] ? ata_sff_softreset+0x0/0x10e
>> [    2.013117]  [<c02eeb26>] ? ata_sff_prereset+0x0/0x9e
>> [    2.013120]  [<c011e7c1>] ? dequeue_entity+0x1b/0x20d
>> [    2.013122]  [<c011ef1c>] ? dequeue_task_fair+0x5c/0x61
>> [    2.013125]  [<c0101e73>] ? __switch_to+0xce/0x14f
>> [    2.013127]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
>> [    2.013130]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
>> [    2.013132]  [<c0125c92>] ? finish_task_switch+0x37/0x8a
>> [    2.013134]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
>> [    2.013137]  [<c0131627>] ? lock_timer_base+0x24/0x43
>> [    2.013140]  [<c02eea18>] ? ata_sff_softreset+0x0/0x10e
>> [    2.013143]  [<c02eeb26>] ? ata_sff_prereset+0x0/0x9e
>> [    2.013145]  [<c02eb6f8>] ata_do_eh+0x30/0x72
>> [    2.013148]  [<c02ecf23>] ? ata_sff_postreset+0x0/0x5a
>> [    2.013150]  [<c02ecf19>] ata_sff_error_handler+0x12b/0x135
>> [    2.013153]  [<c02ecf23>] ? ata_sff_postreset+0x0/0x5a
>> [    2.013155]  [<c02eea18>] ? ata_sff_softreset+0x0/0x10e
>> [    2.013158]  [<c02ebec7>] ata_scsi_error+0x2b5/0x5e6
>> [    2.013162]  [<c02ce15b>] scsi_error_handler+0xc1/0x454
>> [    2.013164]  [<c012390a>] ? default_wake_function+0x10/0x12
>> [    2.013167]  [<c03e2148>] ? _spin_unlock_irqrestore+0x2d/0x3c
>> [    2.013169]  [<c011e4d1>] ? complete+0x39/0x43
>> [    2.013171]  [<c02ce09a>] ? scsi_error_handler+0x0/0x454
>> [    2.013175]  [<c0139f9c>] kthread+0x40/0x66
>> [    2.013178]  [<c0139f5c>] ? kthread+0x0/0x66
>> [    2.013180]  [<c0103bcb>] kernel_thread_helper+0x7/0x10
>> [    2.013182] ---[ end trace a1303c5fb15c2003 ]---
>>
>> [    2.436869] ------------[ cut here ]------------
>> [    2.442849] WARNING: at drivers/ata/libata-sff.c:1017
>> ata_sff_hsm_move+0x49c/0x6d0()
>> [    2.446154] Hardware name: MacBookPro2,2
>> [    2.446154] Modules linked in:
>> [    2.446154] Pid: 1, comm: swapper Tainted: G        W
>> 2.6.28-07812-g5fbbf5f #9
>> [    2.446154] Call Trace:
>> [    2.446154]  [<c01292ca>] warn_slowpath+0x76/0xad
>> [    2.446154]  [<c011e7c1>] ? dequeue_entity+0x1b/0x20d
>> [    2.446154]  [<c0101e73>] ? __switch_to+0xce/0x14f
>> [    2.446154]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
>> [    2.446154]  [<c0243563>] ? _raw_spin_trylock+0xf/0x30
>> [    2.446154]  [<c0125c92>] ? finish_task_switch+0x37/0x8a
>> [    2.446154]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
>> [    2.446154]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
>> [    2.446154]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
>> [    2.446154]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
>> [    2.446154]  [<c015a307>] handle_IRQ_event+0x34/0x69
>> [    2.446154]  [<c015b47e>] handle_edge_irq+0xc8/0x109
>> [    2.446154]  [<c0104bc9>] do_IRQ+0x92/0xad
>> [    2.446154]  [<c010396c>] common_interrupt+0x2c/0x34
>> [    2.446154]  [<c01c00d8>] ? proc_task_readdir+0x76/0x283
>> [    2.446154]  [<c0243830>] ? _raw_spin_lock+0x0/0xf8
>> [    2.446154]  [<c03e21f4>] ? _spin_lock+0xd/0xf
>> [    2.446154]  [<c01c79a1>] sysfs_new_dirent+0x5a/0xe0
>> [    2.446154]  [<c01c7347>] sysfs_add_file_mode+0x2b/0x72
>> [    2.446154]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
>> [    2.446154]  [<c03e2164>] ? _spin_unlock+0xd/0xf
>> [    2.446154]  [<c01c73a1>] sysfs_add_file+0x13/0x18
>> [    2.446154]  [<c01c7445>] sysfs_create_file+0x25/0x27
>> [    2.446154]  [<c02b2857>] driver_create_file+0x1b/0x1d
>> [    2.446154]  [<c02b1955>] bus_add_driver+0xd9/0x1c2
>> [    2.446154]  [<c02b275b>] driver_register+0x86/0xe6
>> [    2.446154]  [<c03215a9>] __hid_register_driver+0x43/0x68
>> [    2.446154]  [<c0325ba2>] ch_init+0x19/0x1b
>> [    2.446154]  [<c0101137>] _stext+0x4f/0x127
>> [    2.446154]  [<c0325b89>] ? ch_init+0x0/0x1b
>> [    2.446154]  [<c015be1c>] ? register_irq_proc+0x84/0xa0
>> [    2.446154]  [<c015be90>] ? init_irq_proc+0x58/0x65
>> [    2.446154]  [<c055a309>] kernel_init+0x105/0x156
>> [    2.446154]  [<c055a204>] ? kernel_init+0x0/0x156
>> [    2.446154]  [<c0103bcb>] kernel_thread_helper+0x7/0x10
>> [    2.446154] ---[ end trace a1303c5fb15c2004 ]---
>>
>>
>> [   10.336705] ------------[ cut here ]------------
>> [   10.354651] WARNING: at drivers/ata/libata-sff.c:1017
>> ata_sff_hsm_move+0x49c/0x6d0()
>> [   10.354651] Hardware name: MacBookPro2,2
>> [   10.354651] Modules linked in:
>> [   10.354651] Pid: 889, comm: udevd Tainted: G        W
>> 2.6.28-07812-g5fbbf5f #9
>> [   10.354651] Call Trace:
>> [   10.354651]  [<c01292ca>] warn_slowpath+0x76/0xad
>> [   10.354651]  [<c011b7ad>] ? resched_task+0x25/0x69
>> [   10.354651]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
>> [   10.354651]  [<c01238ef>] ? try_to_wake_up+0x245/0x250
>> [   10.354651]  [<c016e6cf>] ? get_page_from_freelist+0x2a6/0x3ed
>> [   10.354651]  [<c0169974>] ? find_get_page+0x22/0x86
>> [   10.354651]  [<c016ea87>] ? __alloc_pages_internal+0x9b/0x36a
>> [   10.354651]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
>> [   10.354651]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
>> [   10.354651]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
>> [   10.354651]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
>> [   10.354651]  [<c015a307>] handle_IRQ_event+0x34/0x69
>> [   10.354651]  [<c015b47e>] handle_edge_irq+0xc8/0x109
>> [   10.354651]  [<c0104bc9>] do_IRQ+0x92/0xad
>> [   10.354651]  [<c010396c>] common_interrupt+0x2c/0x34
>> [   10.354651]  [<c03e007b>] ? schedule+0x695/0x8f1
>> [   10.354651]  [<c03e3ee5>] ? do_page_fault+0x272/0x6f9
>> [   10.354651]  [<c011e70c>] ? set_next_entity+0xa7/0x113
>> [   10.354651]  [<c011eeb9>] ? pick_next_task_fair+0x73/0x7a
>> [   10.354651]  [<c018aed4>] ? __slab_free+0x280/0x2b8
>> [   10.354651]  [<c018a64d>] ? check_object+0x139/0x190
>> [   10.354651]  [<c03e2423>] ? error_code+0x73/0x7c
>> [   10.354651]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
>> [   10.354651]  [<c0240320>] ? trace_hardirqs_on_thunk+0xc/0x10
>> [   10.354651]  [<c0240330>] ? trace_hardirqs_off_thunk+0xc/0x10
>> [   10.354651]  [<c03e2423>] ? error_code+0x73/0x7c
>> [   10.354651]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
>> [   10.354651]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
>> [   10.354651]  [<c03e2427>] error_code+0x77/0x7c
>> [   10.354651] ---[ end trace a1303c5fb15c2006 ]---
>> [   10.647515] ------------[ cut here ]------------
>>
>> [   10.647515] ------------[ cut here ]------------
>> [   10.654832] WARNING: at drivers/ata/libata-sff.c:1017
>> ata_sff_hsm_move+0x49c/0x6d0()
>> [   10.656261] Hardware name: MacBookPro2,2
>> [   10.656261] Modules linked in:
>> [   10.656261] Pid: 893, comm: udevd Tainted: G        W
>> 2.6.28-07812-g5fbbf5f #9
>> [   10.656261] Call Trace:
>> [   10.656261]  [<c01292ca>] warn_slowpath+0x76/0xad
>> [   10.656261]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
>> [   10.656261]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
>> [   10.656261]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
>> [   10.656261]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
>> [   10.656261]  [<c015a307>] handle_IRQ_event+0x34/0x69
>> [   10.656261]  [<c015b47e>] handle_edge_irq+0xc8/0x109
>> [   10.656261]  [<c0104bc9>] do_IRQ+0x92/0xad
>> [   10.656261]  [<c010396c>] common_interrupt+0x2c/0x34
>> [   10.656261]  [<c011007b>] ? acpi_processor_ffh_cstate_enter+0x3/0x2c
>> [   10.656261]  [<c016a048>] ? filemap_fault+0x9/0x308
>> [   10.656261]  [<c011a603>] ? ptep_set_access_flags+0x5f/0x69
>> [   10.656261]  [<c011b332>] ? kunmap_atomic+0x72/0x92
>> [   10.656261]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
>> [   10.656261]  [<c0179723>] __do_fault+0x40/0x345
>> [   10.656261]  [<c017b345>] handle_mm_fault+0x29e/0x606
>> [   10.656261]  [<c03e405c>] ? do_page_fault+0x3e9/0x6f9
>> [   10.656261]  [<c03e3ee3>] ? do_page_fault+0x270/0x6f9
>> [   10.656261]  [<c03e3fed>] do_page_fault+0x37a/0x6f9
>> [   10.656261]  [<c018a64d>] ? check_object+0x139/0x190
>> [   10.656261]  [<c014129b>] ? getnstimeofday+0x56/0xdf
>> [   10.656261]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
>> [   10.656261]  [<c013cee5>] ? hrtimer_start_range_ns+0x234/0x23f
>> [   10.656261]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
>> [   10.656261]  [<c013cee5>] ? hrtimer_start_range_ns+0x234/0x23f
>> [   10.656261]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
>> [   10.656261]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
>> [   10.656261]  [<c012c65d>] ? do_setitimer+0x160/0x2d9
>> [   10.656261]  [<c0240330>] ? trace_hardirqs_off_thunk+0xc/0x10
>> [   10.656261]  [<c03e2423>] ? error_code+0x73/0x7c
>> [   10.656261]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
>> [   10.656261]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
>> [   10.656261]  [<c03e2427>] error_code+0x77/0x7c
>> [   10.656261] ---[ end trace a1303c5fb15c2007 ]---
>> [   10.910249] ------------[ cut here ]------------
>>
>> [   10.910249] ------------[ cut here ]------------
>> [   10.916793] WARNING: at drivers/ata/libata-sff.c:1017
>> ata_sff_hsm_move+0x49c/0x6d0()
>> [   10.920003] Hardware name: MacBookPro2,2
>> [   10.920003] Modules linked in:
>> [   10.920003] Pid: 891, comm: udevd Tainted: G        W
>> 2.6.28-07812-g5fbbf5f #9
>> [   10.920003] Call Trace:
>> [   10.920003]  [<c01292ca>] warn_slowpath+0x76/0xad
>> [   10.920003]  [<c0180030>] ? move_page_tables+0x88/0x28b
>> [   10.920003]  [<c018aed4>] ? __slab_free+0x280/0x2b8
>> [   10.920003]  [<c018beb3>] ? kmem_cache_free+0xae/0xc2
>> [   10.920003]  [<c034872d>] ? __kfree_skb+0x73/0x76
>> [   10.920003]  [<c034872d>] ? __kfree_skb+0x73/0x76
>> [   10.920003]  [<c0348760>] ? kfree_skb+0x30/0x32
>> [   10.920003]  [<c03ab36c>] ? unix_dgram_sendmsg+0x437/0x47b
>> [   10.920003]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
>> [   10.920003]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
>> [   10.920003]  [<c017b345>] ? handle_mm_fault+0x29e/0x606
>> [   10.920003]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
>> [   10.920003]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
>> [   10.920003]  [<c015a307>] handle_IRQ_event+0x34/0x69
>> [   10.920003]  [<c015b47e>] handle_edge_irq+0xc8/0x109
>> [   10.920003]  [<c0104bc9>] do_IRQ+0x92/0xad
>> [   10.920003]  [<c010396c>] common_interrupt+0x2c/0x34
>> [   10.920003]  [<c0116eed>] ? __ticket_spin_trylock+0x4/0x21
>> [   10.920003]  [<c0243883>] _raw_spin_lock+0x53/0xf8
>> [   10.920003]  [<c018a64d>] ? check_object+0x139/0x190
>> [   10.920003]  [<c03e21f4>] _spin_lock+0xd/0xf
>> [   10.920003]  [<c023aa85>] _atomic_dec_and_lock+0x29/0x48
>> [   10.920003]  [<c019e26d>] iput+0x29/0x53
>> [   10.920003]  [<c019bea5>] dentry_iput+0x81/0x9c
>> [   10.920003]  [<c019bf74>] d_kill+0x32/0x4c
>> [   10.920003]  [<c019c663>] dput+0x101/0x10a
>> [   10.920003]  [<c018fed3>] __fput+0x13b/0x15c
>> [   10.920003]  [<c018ff12>] fput+0x1e/0x20
>> [   10.920003]  [<c018d67f>] filp_close+0x56/0x60
>> [   10.920003]  [<c018d6f8>] sys_close+0x6f/0xa9
>> [   10.920003]  [<c010329f>] sysenter_do_call+0x12/0x34
>> [   10.920003] ---[ end trace a1303c5fb15c2008 ]---
>> [   11.187174] ------------[ cut here ]------------
>> [   11.190008] WARNING: at drivers/ata/libata-sff.c:1017
>> ata_sff_hsm_move+0x49c/0x6d0()
>> [   11.196573] Hardware name: MacBookPro2,2
>> [   11.203397] Modules linked in:
>> [   11.209319] Pid: 923, comm: path_id Tainted: G        W
>> 2.6.28-07812-g5fbbf5f #9
>> [   11.219223] Call Trace:
>> [   11.219223]  [<c01292ca>] warn_slowpath+0x76/0xad
>> [   11.219223]  [<c0230030>] ? elv_attr_store+0x15/0x5e
>> [   11.219223]  [<c011160a>] ? flush_tlb_page+0x47/0x6e
>> [   11.219223]  [<c011a603>] ? ptep_set_access_flags+0x5f/0x69
>> [   11.219223]  [<c011b332>] ? kunmap_atomic+0x72/0x92
>> [   11.256355]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
>> [   11.256355]  [<c017a1b4>] ? do_wp_page+0x586/0x5eb
>> [   11.272445]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
>> [   11.272445]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
>> [   11.272445]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
>> [   11.272445]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
>> [   11.272445]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
>> [   11.304326]  [<c015a307>] handle_IRQ_event+0x34/0x69
>> [   11.304326]  [<c015b47e>] handle_edge_irq+0xc8/0x109
>> [   11.304326]  [<c0104bc9>] do_IRQ+0x92/0xad
>> [   11.304326]  [<c010396c>] common_interrupt+0x2c/0x34
>> [   11.304326]  [<c0196c85>] ? putname+0x29/0x34
>> [   11.304326]  [<c018007b>] ? move_page_tables+0xd3/0x28b
>> [   11.304326]  [<c018beb7>] ? kmem_cache_free+0xb2/0xc2
>> [   11.304326]  [<c0196c85>] ? putname+0x29/0x34
>> [   11.304326]  [<c0196c85>] putname+0x29/0x34
>> [   11.304326]  [<c0198701>] user_path_at+0x4a/0x67
>> [   11.304326]  [<c013a41e>] ? remove_wait_queue+0x35/0x39
>> [   11.304326]  [<c018feec>] ? __fput+0x154/0x15c
>> [   11.304326]  [<c018e048>] sys_chdir+0x23/0x64
>> [   11.304326]  [<c010329f>] sysenter_do_call+0x12/0x34
>> [   11.304326] ---[ end trace a1303c5fb15c2009 ]---
>> [   11.404868] ------------[ cut here ]------------
>> [   11.411491] WARNING: at drivers/ata/libata-sff.c:1017
>> ata_sff_hsm_move+0x49c/0x6d0()
>> [   11.412573] Hardware name: MacBookPro2,2
>> [   11.412573] Modules linked in:
>> [   11.412573] Pid: 966, comm: udevd Tainted: G        W
>> 2.6.28-07812-g5fbbf5f #9
>> [   11.412573] Call Trace:
>> [   11.412573]  [<c01292ca>] warn_slowpath+0x76/0xad
>> [   11.412573]  [<c0169974>] ? find_get_page+0x22/0x86
>> [   11.412573]  [<c0169cb5>] ? find_lock_page+0x18/0x4c
>> [   11.412573]  [<c016a0d0>] ? filemap_fault+0x91/0x308
>> [   11.412573]  [<c011b332>] ? kunmap_atomic+0x72/0x92
>> [   11.412573]  [<c0169c9a>] ? unlock_page+0x43/0x46
>> [   11.412573]  [<c01799f0>] ? __do_fault+0x30d/0x345
>> [   11.412573]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
>> [   11.412573]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
>> [   11.412573]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
>> [   11.412573]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
>> [   11.412573]  [<c015a307>] handle_IRQ_event+0x34/0x69
>> [   11.412573]  [<c015b47e>] handle_edge_irq+0xc8/0x109
>> [   11.412573]  [<c0104bc9>] do_IRQ+0x92/0xad
>> [   11.412573]  [<c0196cb5>] ? getname+0x25/0xbc
>> [   11.412573]  [<c010396c>] common_interrupt+0x2c/0x34
>> [   11.412573]  [<c0196cb5>] ? getname+0x25/0xbc
>> [   11.412573]  [<c018007b>] ? move_page_tables+0xd3/0x28b
>> [   11.412573]  [<c018bf5a>] ? kmem_cache_alloc+0x93/0xcc
>> [   11.412573]  [<c0196cb5>] ? getname+0x25/0xbc
>> [   11.412573]  [<c0196cb5>] getname+0x25/0xbc
>> [   11.412573]  [<c01986d1>] user_path_at+0x1a/0x67
>> [   11.412573]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
>> [   11.412573]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
>> [   11.412573]  [<c012c65d>] ? do_setitimer+0x160/0x2d9
>> [   11.412573]  [<c0191e60>] sys_readlinkat+0x2b/0x86
>> [   11.412573]  [<c0191ed3>] sys_readlink+0x18/0x1a
>> [   11.412573]  [<c010329f>] sysenter_do_call+0x12/0x34
>> [   11.412573] ---[ end trace a1303c5fb15c200a ]---
>> [   11.631708] ------------[ cut here ]------------
>> [   11.637944] WARNING: at drivers/ata/libata-sff.c:1017
>> ata_sff_hsm_move+0x49c/0x6d0()
>> [   11.640002] Hardware name: MacBookPro2,2
>> [   11.640002] Modules linked in:
>> [   11.640002] Pid: 960, comm: udevd Tainted: G        W
>> 2.6.28-07812-g5fbbf5f #9
>> [   11.640002] Call Trace:
>> [   11.640002]  [<c01292ca>] warn_slowpath+0x76/0xad
>> [   11.640002]  [<c0169974>] ? find_get_page+0x22/0x86
>> [   11.640002]  [<c0169cb5>] ? find_lock_page+0x18/0x4c
>> [   11.640002]  [<c016a0d0>] ? filemap_fault+0x91/0x308
>> [   11.640002]  [<c011b332>] ? kunmap_atomic+0x72/0x92
>> [   11.640002]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
>> [   11.640002]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
>> [   11.640002]  [<c018aed4>] ? __slab_free+0x280/0x2b8
>> [   11.640002]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
>> [   11.640002]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
>> [   11.640002]  [<c015a307>] handle_IRQ_event+0x34/0x69
>> [   11.640002]  [<c015b47e>] handle_edge_irq+0xc8/0x109
>> [   11.640002]  [<c0104bc9>] do_IRQ+0x92/0xad
>> [   11.640002]  [<c0196cb5>] ? getname+0x25/0xbc
>> [   11.640002]  [<c010396c>] common_interrupt+0x2c/0x34
>> [   11.640002]  [<c0196cb5>] ? getname+0x25/0xbc
>> [   11.640002]  [<c018007b>] ? move_page_tables+0xd3/0x28b
>> [   11.640002]  [<c018bf5a>] ? kmem_cache_alloc+0x93/0xcc
>> [   11.640002]  [<c0196cb5>] ? getname+0x25/0xbc
>> [   11.640002]  [<c0196cb5>] getname+0x25/0xbc
>> [   11.640002]  [<c01986d1>] user_path_at+0x1a/0x67
>> [   11.640002]  [<c012c65d>] ? do_setitimer+0x160/0x2d9
>> [   11.640002]  [<c0191e60>] sys_readlinkat+0x2b/0x86
>> [   11.640002]  [<c0191ed3>] sys_readlink+0x18/0x1a
>> [   11.640002]  [<c010329f>] sysenter_do_call+0x12/0x34
>> [   11.640002] ---[ end trace a1303c5fb15c200b ]---
>> [   11.859983] ------------[ cut here ]------------
>> [   11.863325] WARNING: at drivers/ata/libata-sff.c:1017
>> ata_sff_hsm_move+0x49c/0x6d0()
>> [   11.870937] Hardware name: MacBookPro2,2
>> [   11.878612] Modules linked in:
>> [   11.882417] Pid: 988, comm: udevd Tainted: G        W
>> 2.6.28-07812-g5fbbf5f #9
>> [   11.889932] Call Trace:
>> [   11.896866]  [<c01292ca>] warn_slowpath+0x76/0xad
>> [   11.901313]  [<c011b332>] ? kunmap_atomic+0x72/0x92
>> [   11.906787]  [<c01799f0>] ? __do_fault+0x30d/0x345
>> [   11.906787]  [<c0212f70>] ? avc_has_perm+0x3e/0x48
>> [   11.906787]  [<c018a64d>] ? check_object+0x139/0x190
>> [   11.932317]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
>> [   11.932317]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
>> [   11.932317]  [<c0217852>] ? selinux_inode_alloc_security+0x2e/0x73
>> [   11.932317]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
>> [   11.932317]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
>> [   11.932317]  [<c015a307>] handle_IRQ_event+0x34/0x69
>> [   11.932317]  [<c015b47e>] handle_edge_irq+0xc8/0x109
>> [   11.932317]  [<c0104bc9>] do_IRQ+0x92/0xad
>> [   11.932317]  [<c0196cb5>] ? getname+0x25/0xbc
>> [   11.932317]  [<c010396c>] common_interrupt+0x2c/0x34
>> [   11.932317]  [<c0196cb5>] ? getname+0x25/0xbc
>> [   11.932317]  [<c018007b>] ? move_page_tables+0xd3/0x28b
>> [   12.009738]  [<c018bf5a>] ? kmem_cache_alloc+0x93/0xcc
>> [   12.009738]  [<c0196cb5>] ? getname+0x25/0xbc
>> [   12.009738]  [<c0196cb5>] getname+0x25/0xbc
>> [   12.009738]  [<c018d74b>] do_sys_open+0x19/0xbc
>> [   12.009738]  [<c018d83a>] sys_open+0x23/0x2b
>> [   12.009738]  [<c010329f>] sysenter_do_call+0x12/0x34
>> [   12.009738] ---[ end trace a1303c5fb15c200c ]---
>> [   12.065027] ------------[ cut here ]------------
>> [   12.070720] WARNING: at drivers/ata/libata-sff.c:1017
>> ata_sff_hsm_move+0x49c/0x6d0()
>> [   12.070720] Hardware name: MacBookPro2,2
>> [   12.070720] Modules linked in:
>> [   12.070720] Pid: 1018, comm: udevd Tainted: G        W
>> 2.6.28-07812-g5fbbf5f #9
>> [   12.070720] Call Trace:
>> [   12.070720]  [<c01292ca>] warn_slowpath+0x76/0xad
>> [   12.070720]  [<c0190029>] ? get_empty_filp+0x82/0x175
>> [   12.070720]  [<c018fd49>] ? file_free_rcu+0x35/0x38
>> [   12.070720]  [<c011160a>] ? flush_tlb_page+0x47/0x6e
>> [   12.070720]  [<c011a603>] ? ptep_set_access_flags+0x5f/0x69
>> [   12.070720]  [<c011b332>] ? kunmap_atomic+0x72/0x92
>> [   12.070720]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
>> [   12.070720]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
>> [   12.070720]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
>> [   12.070720]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
>> [   12.070720]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
>> [   12.070720]  [<c015a307>] handle_IRQ_event+0x34/0x69
>> [   12.070720]  [<c015b47e>] handle_edge_irq+0xc8/0x109
>> [   12.070720]  [<c0104bc9>] do_IRQ+0x92/0xad
>> [   12.070720]  [<c010396c>] common_interrupt+0x2c/0x34
>> [   12.070720]  [<c03e007b>] ? schedule+0x695/0x8f1
>> [   12.070720]  [<c03e3ee5>] ? do_page_fault+0x272/0x6f9
>> [   12.070720]  [<c0190029>] ? get_empty_filp+0x82/0x175
>> [   12.070720]  [<c018fd49>] ? file_free_rcu+0x35/0x38
>> [   12.070720]  [<c018a64d>] ? check_object+0x139/0x190
>> [   12.070720]  [<c03e2423>] ? error_code+0x73/0x7c
>> [   12.070720]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
>> [   12.070720]  [<c0240320>] ? trace_hardirqs_on_thunk+0xc/0x10
>> [   12.070720]  [<c0240330>] ? trace_hardirqs_off_thunk+0xc/0x10
>> [   12.070720]  [<c03e2423>] ? error_code+0x73/0x7c
>> [   12.070720]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
>> [   12.070720]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
>> [   12.070720]  [<c03e2427>] error_code+0x77/0x7c
>> [   12.070720] ---[ end trace a1303c5fb15c200d ]---
>> [   12.300395] ------------[ cut here ]------------
>> [   12.306909] WARNING: at drivers/ata/libata-sff.c:1017
>> ata_sff_hsm_move+0x49c/0x6d0()
>> [   12.310003] Hardware name: MacBookPro2,2
>> [   12.310003] Modules linked in:
>> [   12.310003] Pid: 999, comm: udevd Tainted: G        W
>> 2.6.28-07812-g5fbbf5f #9
>> [   12.310003] Call Trace:
>> [   12.310003]  [<c01292ca>] warn_slowpath+0x76/0xad
>> [   12.310003]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
>> [   12.310003]  [<c03e2164>] ? _spin_unlock+0xd/0xf
>> [   12.310003]  [<c016e6cf>] ? get_page_from_freelist+0x2a6/0x3ed
>> [   12.310003]  [<c0169974>] ? find_get_page+0x22/0x86
>> [   12.310003]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
>> [   12.310003]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
>> [   12.310003]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
>> [   12.310003]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
>> [   12.310003]  [<c015a307>] handle_IRQ_event+0x34/0x69
>> [   12.310003]  [<c015b47e>] handle_edge_irq+0xc8/0x109
>> [   12.310003]  [<c0104bc9>] do_IRQ+0x92/0xad
>> [   12.310003]  [<c010396c>] common_interrupt+0x2c/0x34
>> [   12.310003]  [<c03e00d8>] ? schedule+0x6f2/0x8f1
>> [   12.310003]  [<c013d32b>] ? down_read_trylock+0x17/0x20
>> [   12.310003]  [<c03e3f32>] do_page_fault+0x2bf/0x6f9
>> [   12.310003]  [<c011e70c>] ? set_next_entity+0xa7/0x113
>> [   12.310003]  [<c014129b>] ? getnstimeofday+0x56/0xdf
>> [   12.310003]  [<c023de7b>] ? rb_insert_color+0x9b/0xc0
>> [   12.310003]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
>> [   12.310003]  [<c013cee5>] ? hrtimer_start_range_ns+0x234/0x23f
>> [   12.310003]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
>> [   12.310003]  [<c013cee5>] ? hrtimer_start_range_ns+0x234/0x23f
>> [   12.310003]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
>> [   12.310003]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
>> [   12.310003]  [<c012c65d>] ? do_setitimer+0x160/0x2d9
>> [   12.310003]  [<c0240330>] ? trace_hardirqs_off_thunk+0xc/0x10
>> [   12.310003]  [<c03e2423>] ? error_code+0x73/0x7c
>> [   12.310003]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
>> [   12.310003]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
>> [   12.310003]  [<c03e2427>] error_code+0x77/0x7c
>> [   12.310003] ---[ end trace a1303c5fb15c200e ]---
>> [   12.547900] ------------[ cut here ]------------
>> [   12.554293] WARNING: at drivers/ata/libata-sff.c:1017
>> ata_sff_hsm_move+0x49c/0x6d0()
>> [   12.555950] Hardware name: MacBookPro2,2
>> [   12.555950] Modules linked in:
>> [   12.555950] Pid: 998, comm: udevd Tainted: G        W
>> 2.6.28-07812-g5fbbf5f #9
>> [   12.555950] Call Trace:
>> [   12.555950]  [<c01292ca>] warn_slowpath+0x76/0xad
>> [   12.555950]  [<c018a64d>] ? check_object+0x139/0x190
>> [   12.601146]  [<c03e3ee3>] ? do_page_fault+0x270/0x6f9
>> [   12.601146]  [<c03e405c>] ? do_page_fault+0x3e9/0x6f9
>> [   12.601146]  [<c018bcfd>] ? kfree+0xd5/0xe9
>> [   12.601146]  [<c015c92f>] ? call_rcu+0x63/0x74
>> [   12.601146]  [<c018fd0e>] ? put_filp+0x47/0x4d
>> [   12.601146]  [<c0196c53>] ? release_open_intent+0x16/0x1f
>> [   12.601146]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
>> [   12.601146]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
>> [   12.601146]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
>> [   12.601146]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
>> [   12.601146]  [<c015a307>] handle_IRQ_event+0x34/0x69
>> [   12.601146]  [<c015b47e>] handle_edge_irq+0xc8/0x109
>> [   12.601146]  [<c0104bc9>] do_IRQ+0x92/0xad
>> [   12.601146]  [<c010396c>] common_interrupt+0x2c/0x34
>> [   12.601146] ---[ end trace a1303c5fb15c200f ]---
>>
>> [   20.550550] ------------[ cut here ]------------
>> [   20.550554] WARNING: at drivers/ata/libata-sff.c:1017
>> ata_sff_hsm_move+0x49c/0x6d0()
>> [   20.550556] Hardware name: MacBookPro2,2
>> [   20.550558] Modules linked in: fan battery container ipt_LOG xt_limit
>> xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat
>> nf_conntrack_ftp ipmi_watchdog ipmi_msghandler isight_firmware uinput
>> arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack
>> nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp
>> eeprom acpi_cpufreq cpufreq_powersave cpufreq_performance cpufreq_ondemand
>> cpufreq_conservative firewire_sbp2 firewire_core raw1394 appletouch
>> snd_hda_codec_idt uvcvideo ohci1394 thermal joydev snd_hda_intel snd_hda_codec
>> ath9k ieee1394 video ac button processor applesmc uhci_hcd ehci_hcd snd_hwdep
>> snd_pcm snd_page_alloc pata_acpi evdev
>> [   20.550621] Pid: 0, comm: swapper Tainted: G        W
>> 2.6.28-07812-g5fbbf5f #9
>> [   20.550623] Call Trace:
>> [   20.550630]  [<c01292ca>] warn_slowpath+0x76/0xad
>> [   20.550635]  [<c013e562>] ? sched_clock_cpu+0x137/0x146
>> [   20.550639]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
>> [   20.550642]  [<c013c4e7>] ? hrtimer_forward+0xf9/0x10f
>> [   20.550646]  [<c014129b>] ? getnstimeofday+0x56/0xdf
>> [   20.550650]  [<c01119f4>] ? lapic_next_event+0x18/0x1c
>> [   20.550653]  [<c0143380>] ? clockevents_program_event+0xe0/0xef
>> [   20.550659]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
>> [   20.550662]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
>> [   20.550665]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
>> [   20.550669]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
>> [   20.550672]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
>> [   20.550677]  [<c015a307>] handle_IRQ_event+0x34/0x69
>> [   20.550680]  [<c015b47e>] handle_edge_irq+0xc8/0x109
>> [   20.550684]  [<c0104bc9>] do_IRQ+0x92/0xad
>> [   20.550687]  [<c010396c>] common_interrupt+0x2c/0x34
>> [   20.550699]  [<f806c727>] ? acpi_idle_enter_bm+0x2df/0x36b [processor]
>> [   20.550703]  [<c0144b5a>] ? tick_nohz_restart_sched_tick+0x139/0x14b
>> [   20.550708]  [<c031e695>] cpuidle_idle_call+0x65/0x98
>> [   20.550711]  [<c01023b7>] cpu_idle+0x84/0xa5
>> [   20.550714]  [<c03d388f>] rest_init+0x53/0x55
>> [   20.550717] ---[ end trace a1303c5fb15c2010 ]---
>> [   20.551664] ------------[ cut here ]------------
>> [   20.551669] WARNING: at drivers/ata/libata-sff.c:1017
>> ata_sff_hsm_move+0x49c/0x6d0()
>> [   20.551673] Hardware name: MacBookPro2,2
>> [   20.551676] Modules linked in: fan battery container ipt_LOG xt_limit
>> xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat
>> nf_conntrack_ftp ipmi_watchdog ipmi_msghandler isight_firmware uinput
>> arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack
>> nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp
>> eeprom acpi_cpufreq cpufreq_powersave cpufreq_performance cpufreq_ondemand
>> cpufreq_conservative firewire_sbp2 firewire_core raw1394 appletouch
>> snd_hda_codec_idt uvcvideo ohci1394 thermal joydev snd_hda_intel snd_hda_codec
>> ath9k ieee1394 video ac button processor applesmc uhci_hcd ehci_hcd snd_hwdep
>> snd_pcm snd_page_alloc pata_acpi evdev
>> [   20.551785] Pid: 0, comm: swapper Tainted: G        W
>> 2.6.28-07812-g5fbbf5f #9
>> [   20.551789] Call Trace:
>> [   20.551797]  [<c01292ca>] warn_slowpath+0x76/0xad
>> [   20.551805]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
>> [   20.551812]  [<c01238ef>] ? try_to_wake_up+0x245/0x250
>> [   20.551819]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
>> [   20.551828]  [<c02ce674>] ? scsi_eh_scmd_add+0x83/0x8c
>> [   20.551835]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
>> [   20.551842]  [<c02ce674>] ? scsi_eh_scmd_add+0x83/0x8c
>> [   20.551849]  [<c02ce6cf>] ? scsi_times_out+0x52/0x6c
>> [   20.551856]  [<c0235c66>] ? blk_rq_timed_out+0x11/0x4b
>> [   20.551863]  [<c0235ce3>] ? blk_abort_request+0x43/0x46
>> [   20.551870]  [<c02ebb5c>] ? ata_qc_schedule_eh+0x49/0x50
>> [   20.551877]  [<c02e1d9f>] ? ata_qc_complete+0x75/0x1a9
>> [   20.551884]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
>> [   20.551892]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
>> [   20.551899]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
>> [   20.551906]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
>> [   20.551914]  [<c015a307>] handle_IRQ_event+0x34/0x69
>> [   20.551921]  [<c015b47e>] handle_edge_irq+0xc8/0x109
>> [   20.551928]  [<c0104bc9>] do_IRQ+0x92/0xad
>> [   20.551934]  [<c010396c>] common_interrupt+0x2c/0x34
>> [   20.551954]  [<f806c727>] ? acpi_idle_enter_bm+0x2df/0x36b [processor]
>> [   20.551961]  [<c0144b5a>] ? tick_nohz_restart_sched_tick+0x139/0x14b
>> [   20.551969]  [<c031e695>] cpuidle_idle_call+0x65/0x98
>> [   20.551975]  [<c01023b7>] cpu_idle+0x84/0xa5
>> [   20.551982]  [<c03d388f>] rest_init+0x53/0x55
>> [   20.551986] ---[ end trace a1303c5fb15c2011 ]---
>> [   20.558509] ------------[ cut here ]------------
>> [   20.558512] WARNING: at drivers/ata/libata-sff.c:1017
>> ata_sff_hsm_move+0x49c/0x6d0()
>> [   20.558514] Hardware name: MacBookPro2,2
>> [   20.558516] Modules linked in: fan battery container ipt_LOG xt_limit
>> xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat
>> nf_conntrack_ftp ipmi_watchdog ipmi_msghandler isight_firmware uinput
>> arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack
>> nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp
>> eeprom acpi_cpufreq cpufreq_powersave cpufreq_performance cpufreq_ondemand
>> cpufreq_conservative firewire_sbp2 firewire_core raw1394 appletouch
>> snd_hda_codec_idt uvcvideo ohci1394 thermal joydev snd_hda_intel snd_hda_codec
>> ath9k ieee1394 video ac button processor applesmc uhci_hcd ehci_hcd snd_hwdep
>> snd_pcm snd_page_alloc pata_acpi evdev
>> [   20.558573] Pid: 2519, comm: hald-addon-macb Tainted: G        W
>> 2.6.28-07812-g5fbbf5f #9
>> [   20.558575] Call Trace:
>> [   20.558580]  [<c01292ca>] warn_slowpath+0x76/0xad
>> [   20.558585]  [<c011b332>] ? kunmap_atomic+0x72/0x92
>> [   20.558588]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
>> [   20.558600]  [<c03e3ee3>] ? do_page_fault+0x270/0x6f9
>> [   20.558600]  [<c03e405c>] ? do_page_fault+0x3e9/0x6f9
>> [   20.558600]  [<c023c89f>] ? prio_tree_insert+0x18c/0x1ff
>> [   20.558602]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
>> [   20.558606]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
>> [   20.558610]  [<c03e2164>] ? _spin_unlock+0xd/0xf
>> [   20.558613]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
>> [   20.558617]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
>> [   20.558630]  [<c015a307>] handle_IRQ_event+0x34/0x69
>> [   20.558630]  [<c015b47e>] handle_edge_irq+0xc8/0x109
>> [   20.558630]  [<c0104bc9>] do_IRQ+0x92/0xad
>> [   20.558631]  [<c010396c>] common_interrupt+0x2c/0x34
>> [   20.558633] ---[ end trace a1303c5fb15c2012 ]---
>> [   20.623177] ------------[ cut here ]------------
>> [   20.623181] WARNING: at drivers/ata/libata-sff.c:1017
>> ata_sff_hsm_move+0x49c/0x6d0()
>> [   20.623184] Hardware name: MacBookPro2,2
>> [   20.623185] Modules linked in: fan battery container ipt_LOG xt_limit
>> xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat
>> nf_conntrack_ftp ipmi_watchdog ipmi_msghandler isight_firmware uinput
>> arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack
>> nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp
>> eeprom acpi_cpufreq cpufreq_powersave cpufreq_performance cpufreq_ondemand
>> cpufreq_conservative firewire_sbp2 firewire_core raw1394 appletouch
>> snd_hda_codec_idt uvcvideo ohci1394 thermal joydev snd_hda_intel snd_hda_codec
>> ath9k ieee1394 video ac button processor applesmc uhci_hcd ehci_hcd snd_hwdep
>> snd_pcm snd_page_alloc pata_acpi evdev
>> [   20.623245] Pid: 2519, comm: hald-addon-macb Tainted: G        W
>> 2.6.28-07812-g5fbbf5f #9
>> [   20.623247] Call Trace:
>> [   20.623252]  [<c01292ca>] warn_slowpath+0x76/0xad
>> [   20.623257]  [<c011b332>] ? kunmap_atomic+0x72/0x92
>> [   20.623260]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
>> [   20.623264]  [<c03e3ee3>] ? do_page_fault+0x270/0x6f9
>> [   20.623267]  [<c03e405c>] ? do_page_fault+0x3e9/0x6f9
>> [   20.623272]  [<c03e2164>] ? _spin_unlock+0xd/0xf
>> [   20.623276]  [<c017e7d2>] ? vma_adjust+0x31a/0x378
>> [   20.623279]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
>> [   20.623283]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
>> [   20.623286]  [<c017f421>] ? mmap_region+0x17e/0x435
>> [   20.623289]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
>> [   20.623293]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
>> [   20.623296]  [<c015a307>] handle_IRQ_event+0x34/0x69
>> [   20.623300]  [<c015b47e>] handle_edge_irq+0xc8/0x109
>> [   20.623304]  [<c0104bc9>] do_IRQ+0x92/0xad
>> [   20.623307]  [<c010396c>] common_interrupt+0x2c/0x34
>> [   20.623309] ---[ end trace a1303c5fb15c2013 ]---
>> [   20.624217] ------------[ cut here ]------------
>> [   20.624220] WARNING: at drivers/ata/libata-sff.c:1017
>> ata_sff_hsm_move+0x49c/0x6d0()
>> [   20.624222] Hardware name: MacBookPro2,2
>> [   20.624224] Modules linked in: fan battery container ipt_LOG xt_limit
>> xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat
>> nf_conntrack_ftp ipmi_watchdog ipmi_msghandler isight_firmware uinput
>> arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack
>> nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp
>> eeprom acpi_cpufreq cpufreq_powersave cpufreq_performance cpufreq_ondemand
>> cpufreq_conservative firewire_sbp2 firewire_core raw1394 appletouch
>> snd_hda_codec_idt uvcvideo ohci1394 thermal joydev snd_hda_intel snd_hda_codec
>> ath9k ieee1394 video ac button processor applesmc uhci_hcd ehci_hcd snd_hwdep
>> snd_pcm snd_page_alloc pata_acpi evdev
>> [   20.624279] Pid: 2519, comm: hald-addon-macb Tainted: G        W
>> 2.6.28-07812-g5fbbf5f #9
>> [   20.624281] Call Trace:
>> [   20.624285]  [<c01292ca>] warn_slowpath+0x76/0xad
>> [   20.624289]  [<c023fac6>] ? vsnprintf+0x866/0x8c5
>> [   20.624293]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
>> [   20.624296]  [<c01299ba>] ? release_console_sem+0x1b8/0x1e5
>> [   20.624300]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
>> [   20.624303]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
>> [   20.624307]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
>> [   20.624310]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
>> [   20.624314]  [<c015a307>] handle_IRQ_event+0x34/0x69
>> [   20.624317]  [<c015b47e>] handle_edge_irq+0xc8/0x109
>> [   20.624320]  [<c0104bc9>] do_IRQ+0x92/0xad
>> [   20.624323]  [<c010396c>] common_interrupt+0x2c/0x34
>> [   20.624328]  [<c017734f>] ? __inc_zone_state+0x1b/0x7b
>> [   20.624331]  [<c01773cc>] __inc_zone_page_state+0x1d/0x1f
>> [   20.624334]  [<c018168f>] page_add_new_anon_rmap+0x44/0x6a
>> [   20.624338]  [<c017b2a5>] handle_mm_fault+0x1fe/0x606
>> [   20.624343]  [<c02155a8>] ? selinux_socket_unix_stream_connect+0xa4/0xac
>> [   20.624346]  [<c03e3ee3>] ? do_page_fault+0x270/0x6f9
>> [   20.624349]  [<c03e3fed>] do_page_fault+0x37a/0x6f9
>> [   20.624352]  [<c03e20e4>] ? _read_unlock+0xd/0xf
>> [   20.624357]  [<c03454d3>] ? sock_def_readable+0x60/0x65
>> [   20.624362]  [<c03acb34>] ? unix_stream_connect+0x338/0x398
>> [   20.624365]  [<c0343d18>] ? sys_connect+0x65/0x82
>> [   20.624368]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
>> [   20.624371]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
>> [   20.624374]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
>> [   20.624379]  [<c01326c9>] ? do_sigaction+0x13d/0x14e
>> [   20.624382]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
>> [   20.624385]  [<c0240330>] ? trace_hardirqs_off_thunk+0xc/0x10
>> [   20.624388]  [<c03e2423>] ? error_code+0x73/0x7c
>> [   20.624391]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
>> [   20.624394]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
>> [   20.624397]  [<c03e2427>] error_code+0x77/0x7c
>> [   20.624400] ---[ end trace a1303c5fb15c2014 ]---
>> [   20.625285] ------------[ cut here ]------------
>> [   20.625288] WARNING: at drivers/ata/libata-sff.c:1017
>> ata_sff_hsm_move+0x49c/0x6d0()
>> [   20.625290] Hardware name: MacBookPro2,2
>> [   20.625292] Modules linked in: fan battery container ipt_LOG xt_limit
>> xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat
>> nf_conntrack_ftp ipmi_watchdog ipmi_msghandler isight_firmware uinput
>> arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack
>> nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp
>> eeprom acpi_cpufreq cpufreq_powersave cpufreq_performance cpufreq_ondemand
>> cpufreq_conservative firewire_sbp2 firewire_core raw1394 appletouch
>> snd_hda_codec_idt uvcvideo ohci1394 thermal joydev snd_hda_intel snd_hda_codec
>> ath9k ieee1394 video ac button processor applesmc uhci_hcd ehci_hcd snd_hwdep
>> snd_pcm snd_page_alloc pata_acpi evdev
>> [   20.625344] Pid: 2466, comm: hald Tainted: G        W
>> 2.6.28-07812-g5fbbf5f #9
>> [   20.625346] Call Trace:
>> [   20.625349]  [<c01292ca>] warn_slowpath+0x76/0xad
>> [   20.625353]  [<c0213328>] ? selinux_socket_recvmsg+0x1a/0x1c
>> [   20.625357]  [<c0342ccb>] ? sock_aio_read+0x109/0x117
>> [   20.625361]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
>> [   20.625364]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
>> [   20.625367]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
>> [   20.625371]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
>> [   20.625374]  [<c015a307>] handle_IRQ_event+0x34/0x69
>> [   20.625377]  [<c015b47e>] handle_edge_irq+0xc8/0x109
>> [   20.625381]  [<c0104bc9>] do_IRQ+0x92/0xad
>> [   20.625384]  [<c010396c>] common_interrupt+0x2c/0x34
>> [   20.625386] ---[ end trace a1303c5fb15c2015 ]---
>> [   20.660553] ------------[ cut here ]------------
>> [   20.660556] WARNING: at drivers/ata/libata-sff.c:1017
>> ata_sff_hsm_move+0x49c/0x6d0()
>> [   20.660558] Hardware name: MacBookPro2,2
>> [   20.660560] Modules linked in: fan battery container ipt_LOG xt_limit
>> xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat
>> nf_conntrack_ftp ipmi_watchdog ipmi_msghandler isight_firmware uinput
>> arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack
>> nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp
>> eeprom acpi_cpufreq cpufreq_powersave cpufreq_performance cpufreq_ondemand
>> cpufreq_conservative firewire_sbp2 firewire_core raw1394 appletouch
>> snd_hda_codec_idt uvcvideo ohci1394 thermal joydev snd_hda_intel snd_hda_codec
>> ath9k ieee1394 video ac button processor applesmc uhci_hcd ehci_hcd snd_hwdep
>> snd_pcm snd_page_alloc pata_acpi evdev
>> [   20.660619] Pid: 2519, comm: hald-addon-macb Tainted: G        W
>> 2.6.28-07812-g5fbbf5f #9
>> [   20.660621] Call Trace:
>> [   20.660626]  [<c01292ca>] warn_slowpath+0x76/0xad
>> [   20.660631]  [<c013cca6>] ? hrtimer_cancel+0x12/0x1d
>> [   20.660635]  [<c03e1285>] ? schedule_hrtimeout_range+0x10b/0x12a
>> [   20.660639]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
>> [   20.660642]  [<c03e2148>] ? _spin_unlock_irqrestore+0x2d/0x3c
>> [   20.660647]  [<c013a41e>] ? remove_wait_queue+0x35/0x39
>> [   20.660651]  [<c019a87b>] ? poll_freewait+0x34/0x7d
>> [   20.660654]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
>> [   20.660658]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
>> [   20.660661]  [<c011b332>] ? kunmap_atomic+0x72/0x92
>> [   20.660665]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
>> [   20.660668]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
>> [   20.660672]  [<c015a307>] handle_IRQ_event+0x34/0x69
>> [   20.660676]  [<c015b47e>] handle_edge_irq+0xc8/0x109
>> [   20.660679]  [<c0104bc9>] do_IRQ+0x92/0xad
>> [   20.660682]  [<c010396c>] common_interrupt+0x2c/0x34
>> [   20.660687]  [<c016e758>] ? get_page_from_freelist+0x32f/0x3ed
>> [   20.660691]  [<c016ea87>] __alloc_pages_internal+0x9b/0x36a
>> [   20.660694]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
>> [   20.660697]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
>> [   20.660700]  [<c016ed6f>] get_zeroed_page+0x19/0x2b
>> [   20.660704]  [<c01c82f5>] sysfs_follow_link+0x22/0x13d
>> [   20.660708]  [<c01971a5>] __link_path_walk+0x459/0xc5a
>> [   20.660712]  [<c0215291>] ? selinux_file_alloc_security+0x2d/0x46
>> [   20.660715]  [<c0197b43>] path_walk+0x55/0xaa
>> [   20.660718]  [<c0197d66>] do_path_lookup+0x145/0x18d
>> [   20.660721]  [<c0197e50>] path_lookup_open+0x4b/0x7c
>> [   20.660724]  [<c01988d6>] do_filp_open+0xa8/0x6e8
>> [   20.660728]  [<c018bb89>] ? __slab_alloc+0x409/0x4a8
>> [   20.660731]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
>> [   20.660734]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
>> [   20.660737]  [<c0196cb5>] ? getname+0x25/0xbc
>> [   20.660739]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
>> [   20.660743]  [<c018d779>] do_sys_open+0x47/0xbc
>> [   20.660746]  [<c018d83a>] sys_open+0x23/0x2b
>> [   20.660749]  [<c010329f>] sysenter_do_call+0x12/0x34
>> [   20.660751] ---[ end trace a1303c5fb15c2016 ]---
>> [   20.662220] ------------[ cut here ]------------
>> [   20.662223] WARNING: at drivers/ata/libata-sff.c:1017
>> ata_sff_hsm_move+0x49c/0x6d0()
>> [   20.662225] Hardware name: MacBookPro2,2
>> [   20.662226] Modules linked in: fan battery container ipt_LOG xt_limit
>> xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat
>> nf_conntrack_ftp ipmi_watchdog ipmi_msghandler isight_firmware uinput
>> arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack
>> nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp
>> eeprom acpi_cpufreq cpufreq_powersave cpufreq_performance cpufreq_ondemand
>> cpufreq_conservative firewire_sbp2 firewire_core raw1394 appletouch
>> snd_hda_codec_idt uvcvideo ohci1394 thermal joydev snd_hda_intel snd_hda_codec
>> ath9k ieee1394 video ac button processor applesmc uhci_hcd ehci_hcd snd_hwdep
>> snd_pcm snd_page_alloc pata_acpi evdev
>> [   20.662280] Pid: 2423, comm: klogd Tainted: G        W
>> 2.6.28-07812-g5fbbf5f #9
>> [   20.662282] Call Trace:
>> [   20.662286]  [<c01292ca>] warn_slowpath+0x76/0xad
>> [   20.662290]  [<c03e0b94>] ? __mutex_lock_slowpath+0x25b/0x263
>> [   20.662293]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
>> [   20.662296]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
>> [   20.662298]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
>> [   20.662302]  [<c03e2164>] ? _spin_unlock+0xd/0xf
>> [   20.662306]  [<c01a1823>] ? mnt_drop_write+0x68/0xcc
>> [   20.662309]  [<c019e22a>] ? touch_atime+0xa5/0xbf
>> [   20.662313]  [<c019541e>] ? pipe_read+0x2f7/0x305
>> [   20.662316]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
>> [   20.662320]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
>> [   20.662323]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
>> [   20.662327]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
>> [   20.662330]  [<c015a307>] handle_IRQ_event+0x34/0x69
>> [   20.662334]  [<c015b47e>] handle_edge_irq+0xc8/0x109
>> [   20.662337]  [<c0104bc9>] do_IRQ+0x92/0xad
>> [   20.662340]  [<c010396c>] common_interrupt+0x2c/0x34
>> [   20.662342] ---[ end trace a1303c5fb15c2017 ]---
>> [   20.663258] ------------[ cut here ]------------
>> [   20.663260] WARNING: at drivers/ata/libata-sff.c:1017
>> ata_sff_hsm_move+0x49c/0x6d0()
>> [   20.663262] Hardware name: MacBookPro2,2
>> [   20.663264] Modules linked in: fan battery container ipt_LOG xt_limit
>> xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat
>> nf_conntrack_ftp ipmi_watchdog ipmi_msghandler isight_firmware uinput
>> arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack
>> nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp
>> eeprom acpi_cpufreq cpufreq_powersave cpufreq_performance cpufreq_ondemand
>> cpufreq_conservative firewire_sbp2 firewire_core raw1394 appletouch
>> snd_hda_codec_idt uvcvideo ohci1394 thermal joydev snd_hda_intel snd_hda_codec
>> ath9k ieee1394 video ac button processor applesmc uhci_hcd ehci_hcd snd_hwdep
>> snd_pcm snd_page_alloc pata_acpi evdev
>> [   20.663318] Pid: 2420, comm: dd Tainted: G        W  2.6.28-07812-g5fbbf5f
>> #9
>> [   20.663320] Call Trace:
>> [   20.663323]  [<c01292ca>] warn_slowpath+0x76/0xad
>> [   20.663327]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
>> [   20.663331]  [<c01238ef>] ? try_to_wake_up+0x245/0x250
>> [   20.663334]  [<c011bbac>] ? update_curr+0xae/0x189
>> [   20.663337]  [<c01206a1>] ? enqueue_entity+0x26c/0x274
>> [   20.663341]  [<c011b7ad>] ? resched_task+0x25/0x69
>> [   20.663344]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
>> [   20.663347]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
>> [   20.663351]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
>> [   20.663354]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
>> [   20.663358]  [<c015a307>] handle_IRQ_event+0x34/0x69
>> [   20.663361]  [<c015b47e>] handle_edge_irq+0xc8/0x109
>> [   20.663364]  [<c0104bc9>] do_IRQ+0x92/0xad
>> [   20.663368]  [<c010396c>] common_interrupt+0x2c/0x34
>> [   20.663371]  [<c03e007b>] ? schedule+0x695/0x8f1
>> [   20.663374]  [<c03e2111>] ? _spin_unlock_irq+0x14/0x1e
>> [   20.663378]  [<c0125c92>] finish_task_switch+0x37/0x8a
>> [   20.663381]  [<c03e026d>] schedule+0x887/0x8f1
>> [   20.663385]  [<c0240330>] ? trace_hardirqs_off_thunk+0xc/0x10
>> [   20.663388]  [<c0103210>] ? resume_userspace+0x14/0x28
>> [   20.663391]  [<c010344e>] work_resched+0x5/0x2d
>> [   20.663393] ---[ end trace a1303c5fb15c2018 ]---
>>
>> this was just after compiling. rebooted to this.
>> seems harmless,(just warnings);
>>
>>
>> regards;
>>
>> Justin P. Mattock
>>
>>
>>
>>
>>
>>
>>     
>
>   

