Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbYKLVGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbYKLVGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbYKLVGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:06:33 -0500
Received: from smooth.piipiip.net ([194.100.76.170]:39649 "EHLO
	smooth.piipiip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbYKLVGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:06:31 -0500
Date: Wed, 12 Nov 2008 23:06:25 +0200
From: Jarkko Lavinen <jlavi@iki.fi>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Doug Thompson <dougthompson@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: i82875p_edac: BAR 0 collision
Message-ID: <20081112210625.GA31887@piipiip.net>
References: <20081107114355.GA31730@piipiip.net> <20081111000152.271d9706.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111000152.271d9706.akpm@linux-foundation.org>
X-Operating-System: Linux smooth.piipiip.net 2.6.18-5-k7
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: jlavi@piipiip.net
X-SA-Exim-Scanned: No (on smooth.piipiip.net); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 12:01:52AM -0800, Andrew Morton wrote:
> Might be an EDAC driver regression.  It might also be a consequence of
> PCI address space management fiddlings, but I think most of the changes
> there post-date 2.6.26?

I tried having pci_bus_assign_resources() before enabling the
overflow device in 2.6.27.  The driver gets now loaded, but then 
I get false memory error reports and removing the module segfaults.

Those false memory errors with i82875p edac driver are nothing
new have been reported many times over the past years. On most
kernels i82875p_edac is totally unusable because of these false
errors.

I ran "modprobe i82875p_edac; sleep 5; rmmod i82875p_edac" in
2.6.27.5.  i82875p_setup_overfl_dev() is modified to use
pci_bus_assign_resources() and to be more verbose:

[  235.248583] EDAC DEBUG: i82875p_init_one()
[  235.248592] EDAC i82875p: i82875p init one
[  235.248689] EDAC DEBUG: i82875p_probe1()
[  235.248700] i82875p_setup_overfl_dev pci_get_device: 00000000
[  235.248813] pci 0000:00:06.0: found [8086/257e] class 000880 header type 00
[  235.248827] PCI: 0000:00:06.0 reg 10 32bit mmio: [fecf0000, fecf0fff]
[  235.248875] pci 0000:00:06.0: calling pci_fixup_transparent_bridge+0x0/0x2b
[  235.249676] i82875p_setup_overfl_dev pci_scan_device: f6c4f000
[  235.250982] i82875p_setup_overfl_dev calling pci_bus_assign_resources for dev->bus before enabling the device
[  235.251178] pci 0000:00:06.0: BAR 0: got res [0x88101000-0x88101fff] bus [0x88101000-0x88101fff] flags 0x20200
[  235.251190] pci 0000:00:06.0: BAR 0: moved to bus [0x88101000-0x88101fff] flags 0x20200
[  235.251196] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[  235.251290] pci 0000:00:01.0:   IO window: disabled
[  235.251386] pci 0000:00:01.0:   MEM window: 0xfd900000-0xfe9fffff
[  235.251483] pci 0000:00:01.0:   PREFETCH window: 0x000000f3f00000-0x000000f7efffff
[  235.251631] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
[  235.251727] pci 0000:00:1e.0:   IO window: 0xd000-0xdfff
[  235.251823] pci 0000:00:1e.0:   MEM window: 0xfea00000-0xfeafffff
[  235.251921] pci 0000:00:1e.0:   PREFETCH window: 0x00000088000000-0x000000880fffff
[  235.252092] EDAC DEBUG: edac_mc_register_sysfs_main_kobj()
[  235.253209] EDAC DEBUG: edac_mc_register_sysfs_main_kobj() Registered '.../edac/mc0' kobject
[  235.253233] EDAC DEBUG: edac_mc_add_mc()
[  235.253456] EDAC DEBUG: edac_create_sysfs_mci_device() idx=0
[  235.253654] EDAC DEBUG: edac_mc_workq_setup()
[  235.253665] EDAC MC0: Giving out device to 'i82875p_edac' 'i82875p': DEV 0000:00:00.0
[  235.253810] EDAC DEBUG: edac_pci_alloc_ctl_info()
[  235.253815] EDAC DEBUG: edac_pci_add_device()
[  235.254214] EDAC DEBUG: add_edac_pci_to_global_list()
[  235.254223] EDAC DEBUG: find_edac_pci_by_dev()
[  235.254227] EDAC DEBUG: edac_pci_create_sysfs() idx=0
[  235.254231] EDAC DEBUG: edac_pci_main_kobj_setup()
[  235.254603] EDAC DEBUG: Registered '.../edac/pci' kobject
[  235.254611] EDAC DEBUG: edac_pci_create_instance_kobj()
[  235.254843] EDAC DEBUG: edac_pci_create_instance_kobj() Register instance 'pci0' kobject
[  235.254984] EDAC DEBUG: edac_pci_workq_setup()
[  235.254996] EDAC PCI0: Giving out device to module 'i82875p_edac' controller 'EDAC PCI controller': DEV '0000:00:00.0' (POLLED)
[  236.253020] EDAC DEBUG: MC0: i82875p_check()
[  236.253043] EDAC DEBUG: MC0: edac_mc_find_csrow_by_page(): 0x8f9
[  236.253051] EDAC MC0: UE page 0x8f9, offset 0x0, grain 4096, row 0, labels ":": i82875p UE
[  237.253020] EDAC DEBUG: MC0: i82875p_check()
[  237.253043] EDAC DEBUG: MC0: edac_mc_find_csrow_by_page(): 0x9ae
[  237.253050] EDAC MC0: UE page 0x9ae, offset 0x0, grain 4096, row 0, labels ":": i82875p UE
[  238.253018] EDAC DEBUG: MC0: i82875p_check()
[  238.253040] EDAC DEBUG: MC0: edac_mc_find_csrow_by_page(): 0x25fe
[  238.253047] EDAC MC0: UE page 0x25fe, offset 0x0, grain 4096, row 0, labels ":": i82875p UE
[  239.253017] EDAC DEBUG: MC0: i82875p_check()
[  239.253039] EDAC DEBUG: MC0: edac_mc_find_csrow_by_page(): 0x25fe
[  239.253046] EDAC MC0: UE page 0x25fe, offset 0x0, grain 4096, row 0, labels ":": i82875p UE
[  240.253018] EDAC DEBUG: MC0: i82875p_check()
[  240.253040] EDAC DEBUG: MC0: edac_mc_find_csrow_by_page(): 0x25fe
[  240.253047] EDAC MC0: UE page 0x25fe, offset 0x0, grain 4096, row 0, labels ":": i82875p UE
[  241.253025] BUG: unable to handle kernel paging request at f898c10d
[  241.253203] IP: [<f898c10d>]
[  241.253330] *pde = 37814067 *pte = 00000000 
[  241.253501] Oops: 0000 [#1] SMP 
[  241.253665] Modules linked in: edac_core skge [last unloaded: i82875p_edac]
[  241.253911] 
[  241.253997] Pid: 2721, comm: edac-poller Not tainted (2.6.27.5 #1)
[  241.254005] EIP: 0060:[<f898c10d>] EFLAGS: 00010282 CPU: 0
[  241.254005] EIP is at 0xf898c10d
[  241.254005] EAX: f708f000 EBX: f708f000 ECX: f708f0b4 EDX: f898c10d
[  241.254005] ESI: f708f0b0 EDI: f8998caf EBP: f6ca3f90 ESP: f6ca3f88
[  241.254005]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  241.254005] Process edac-poller (pid: 2721, ti=f6ca2000 task=f7831da0 task.ti=f6ca2000)
[  241.254005] Stack: f8998d02 f7187b80 f6ca3fa8 c022ea8e f7187b84 f7187b80 f7187b84 f7187b8c 
[  241.254005]        f6ca3fd0 c022ebba 00000000 f7831da0 c0231887 f6ca3fbc f6ca3fbc f7187b80 
[  241.254005]        c022eb03 00000000 f6ca3fe0 c02315fe c02315c3 00000000 00000000 c02044ab 
[  241.254005] Call Trace:
[  241.254005]  [<f8998d02>] ? edac_mc_workq_function+0x53/0x7c [edac_core]
[  241.254005]  [<c022ea8e>] ? run_workqueue+0x71/0xe6
[  241.254005]  [<c022ebba>] ? worker_thread+0xb7/0xc3
[  241.254005]  [<c0231887>] ? autoremove_wake_function+0x0/0x33
[  241.254005]  [<c022eb03>] ? worker_thread+0x0/0xc3
[  241.254005]  [<c02315fe>] ? kthread+0x3b/0x61
[  241.254005]  [<c02315c3>] ? kthread+0x0/0x61
[  241.254005]  [<c02044ab>] ? kernel_thread_helper+0x7/0x10
[  241.254005]  =======================
[  241.254005] Code:  Bad EIP value.
[  241.254005] EIP: [<f898c10d>] 0xf898c10d SS:ESP 0068:f6ca3f88
[  241.254005] ---[ end trace 9169bd6e3112abca ]---

Cheers
Jarkko Lavinen
