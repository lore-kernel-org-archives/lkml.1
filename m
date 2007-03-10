Return-Path: <linux-kernel-owner+w=401wt.eu-S1767851AbXCJQDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767851AbXCJQDR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 11:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767854AbXCJQDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 11:03:17 -0500
Received: from mail.gmx.net ([213.165.64.20]:54384 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1767851AbXCJQDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 11:03:16 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18qlUxln/0qTWH015BaobORbJtHAj6csdn2FUS1F8
	0SBgUbRhyp/0Hh
Subject: Re: kref refcounting breakage in mainline
From: Mike Galbraith <efault@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <htejun@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>
In-Reply-To: <1173541446.6561.32.camel@Homer.simpson.net>
References: <20070302005833.949be737.akpm@linux-foundation.org>
	 <20070306002521.GA12164@kroah.com>
	 <1173159802.6955.6.camel@Homer.simpson.net>
	 <20070306210445.GB29164@kroah.com>
	 <1173245937.6613.26.camel@Homer.simpson.net>
	 <1173541446.6561.32.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Sat, 10 Mar 2007 17:03:08 +0100
Message-Id: <1173542588.6561.41.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

P.S.  forgot to include diagnostic log.  Kobject c0644890 is the source
of my woes.  Printk's come below WARN_ON(is_ipmi_si_kobj).  Post-tinker
log is huge, and probably not interesting.

[   30.397160] kobject ipmi_devintf: registering. parent: <NULL>, set: module
[   30.404033] kobject_uevent_env
[   30.407098] fill_kobj_path: path = '/module/ipmi_devintf'
[   30.412524] BUG: at lib/kobject.c:448 kobject_get()
[   30.417402]  [<c0105086>] show_trace_log_lvl+0x1a/0x30
[   30.422564]  [<c01057b2>] show_trace+0x12/0x14
[   30.427031]  [<c0105856>] dump_stack+0x16/0x18
[   30.431501]  [<c02d3c2b>] kobject_get+0x66/0x87
[   30.436056]  [<c02d3f1e>] kobject_shadow_add+0x10/0x1e8
[   30.441312]  [<c02d4100>] kobject_add+0xa/0xc
[   30.445695]  [<c06804c0>] kernel_param_sysfs_setup+0x4d/0x7f
[   30.451376]  [<c068067a>] param_sysfs_init+0x188/0x1c3
[   30.456538]  [<c06725bc>] init+0x144/0x26c
[   30.460661]  [<c0104cfb>] kernel_thread_helper+0x7/0x1c
[   30.465907]  =======================
[   30.469486] get: c18f65c0 count after get is 2
[   30.473927] kobject ipmi_si: registering. parent: <NULL>, set: module
[   30.480372] kobject_uevent_env
[   30.483430] fill_kobj_path: path = '/module/ipmi_si'


......


[   73.266556] bus platform: add driver ipmi
[   73.278013] kobject ipmi: registering. parent: <NULL>, set: drivers
[   73.291847] kobject_uevent_env
[   73.302358] fill_kobj_path: path = '/bus/platform/drivers/ipmi'
[   73.315943] ipmi message handler version 39.1
[   73.327839] ipmi device interface
[   73.338524] device class 'ipmi': registering
[   73.350158] subsystem ipmi: registering
[   73.361309] kobject ipmi: registering. parent: <NULL>, set: class
[   73.374841] bus platform: add driver ipmi_si
[   73.386442] BUG: at lib/kobject.c:448 kobject_get()
[   73.398617]  [<c0105086>] show_trace_log_lvl+0x1a/0x30
[   73.411079]  [<c01057b2>] show_trace+0x12/0x14
[   73.422780]  [<c0105856>] dump_stack+0x16/0x18
[   73.434324]  [<c02d3c2b>] kobject_get+0x66/0x87
[   73.445860]  [<c02d3f1e>] kobject_shadow_add+0x10/0x1e8
[   73.458088]  [<c02d4100>] kobject_add+0xa/0xc
[   73.469286]  [<c02d4248>] kobject_register+0x22/0xb3
[   73.480986]  [<c035a13e>] bus_add_driver+0x77/0x1ae
[   73.492592]  [<c035b109>] driver_register+0x54/0x84
[   73.504101]  [<c034c486>] init_ipmi_si+0x4d/0x829
[   73.515335]  [<c06725bc>] init+0x144/0x26c
[   73.525822]  [<c0104cfb>] kernel_thread_helper+0x7/0x1c
[   73.537452]  =======================
[   73.547290] get: c064475c count after get is 2
[   73.557969] kobject ipmi_si: registering. parent: <NULL>, set: drivers
[   73.570825] kobject_uevent_env
[   73.580011] fill_kobj_path: path = '/bus/platform/drivers/ipmi_si'
[   73.592622] BUG: at lib/kobject.c:242 kobject_register()
[   73.604312]  [<c0105086>] show_trace_log_lvl+0x1a/0x30
[   73.615822]  [<c01057b2>] show_trace+0x12/0x14
[   73.626551]  [<c0105856>] dump_stack+0x16/0x18
[   73.637211]  [<c02d429f>] kobject_register+0x79/0xb3
[   73.648325]  [<c035a13e>] bus_add_driver+0x77/0x1ae
[   73.659297]  [<c035b109>] driver_register+0x54/0x84
[   73.670164]  [<c034c486>] init_ipmi_si+0x4d/0x829
[   73.680756]  [<c06725bc>] init+0x144/0x26c
[   73.690699]  [<c0104cfb>] kernel_thread_helper+0x7/0x1c
[   73.701854]  =======================
[   73.711295] register: c064475c count now is 2 error 0
[   73.722218] BUG: at lib/kobject.c:448 kobject_get()
[   73.732911]  [<c0105086>] show_trace_log_lvl+0x1a/0x30
[   73.743927]  [<c01057b2>] show_trace+0x12/0x14
[   73.754112]  [<c0105856>] dump_stack+0x16/0x18
[   73.764253]  [<c02d3c2b>] kobject_get+0x66/0x87
[   73.774532]  [<c035b157>] get_driver+0x11/0x18
[   73.784725]  [<c035b194>] driver_create_file+0xf/0x32
[   73.795559]  [<c035a221>] bus_add_driver+0x15a/0x1ae
[   73.806343]  [<c035b109>] driver_register+0x54/0x84
[   73.817055]  [<c034c486>] init_ipmi_si+0x4d/0x829
[   73.827595]  [<c06725bc>] init+0x144/0x26c
[   73.837468]  [<c0104cfb>] kernel_thread_helper+0x7/0x1c
[   73.848544]  =======================
[   73.857932] get: c064475c count after get is 3
[   73.868223] BUG: at lib/kobject.c:494 kobject_put()
[   73.878943]  [<c0105086>] show_trace_log_lvl+0x1a/0x30
[   73.890019]  [<c01057b2>] show_trace+0x12/0x14
[   73.900239]  [<c0105856>] dump_stack+0x16/0x18
[   73.910294]  [<c02d3ae7>] kobject_put+0x69/0x82
[   73.920304]  [<c035b144>] put_driver+0xb/0xd
[   73.929909]  [<c035b1b0>] driver_create_file+0x2b/0x32
[   73.940362]  [<c035a221>] bus_add_driver+0x15a/0x1ae
[   73.950686]  [<c035b109>] driver_register+0x54/0x84
[   73.960966]  [<c034c486>] init_ipmi_si+0x4d/0x829
[   73.971055]  [<c06725bc>] init+0x144/0x26c
[   73.980478]  [<c0104cfb>] kernel_thread_helper+0x7/0x1c
[   73.991119]  =======================
[   74.000050] put: c064475c count before put is 3
[   74.010026] BUG: at lib/kobject.c:448 kobject_get()
[   74.020367]  [<c0105086>] show_trace_log_lvl+0x1a/0x30
[   74.031011]  [<c01057b2>] show_trace+0x12/0x14
[   74.040867]  [<c0105856>] dump_stack+0x16/0x18
[   74.050602]  [<c02d3c2b>] kobject_get+0x66/0x87
[   74.060353]  [<c035b157>] get_driver+0x11/0x18
[   74.070034]  [<c035b194>] driver_create_file+0xf/0x32
[   74.080418]  [<c035a233>] bus_add_driver+0x16c/0x1ae
[   74.090742]  [<c035b109>] driver_register+0x54/0x84
[   74.100979]  [<c034c486>] init_ipmi_si+0x4d/0x829
[   74.111041]  [<c06725bc>] init+0x144/0x26c
[   74.120431]  [<c0104cfb>] kernel_thread_helper+0x7/0x1c
[   74.131047]  =======================
[   74.139949] get: c064475c count after get is 3
[   74.149807] BUG: at lib/kobject.c:494 kobject_put()
[   74.160111]  [<c0105086>] show_trace_log_lvl+0x1a/0x30
[   74.170739]  [<c01057b2>] show_trace+0x12/0x14
[   74.180569]  [<c0105856>] dump_stack+0x16/0x18
[   74.190286]  [<c02d3ae7>] kobject_put+0x69/0x82
[   74.200019]  [<c035b144>] put_driver+0xb/0xd
[   74.209503]  [<c035b1b0>] driver_create_file+0x2b/0x32
[   74.219982]  [<c035a233>] bus_add_driver+0x16c/0x1ae
[   74.230312]  [<c035b109>] driver_register+0x54/0x84
[   74.240550]  [<c034c486>] init_ipmi_si+0x4d/0x829
[   74.250614]  [<c06725bc>] init+0x144/0x26c
[   74.260001]  [<c0104cfb>] kernel_thread_helper+0x7/0x1c
[   74.270618]  =======================
[   74.279530] put: c064475c count before put is 3
[   74.289481] IPMI System Interface driver.
[   74.298864] bus pci: add driver ipmi_si
[   74.308007] BUG: at lib/kobject.c:448 kobject_get()
[   74.318260]  [<c0105086>] show_trace_log_lvl+0x1a/0x30
[   74.328861]  [<c01057b2>] show_trace+0x12/0x14
[   74.338637]  [<c0105856>] dump_stack+0x16/0x18
[   74.348372]  [<c02d3c2b>] kobject_get+0x66/0x87
[   74.358245]  [<c02d3f1e>] kobject_shadow_add+0x10/0x1e8
[   74.368837]  [<c02d4100>] kobject_add+0xa/0xc
[   74.378528]  [<c02d4248>] kobject_register+0x22/0xb3
[   74.388817]  [<c035a13e>] bus_add_driver+0x77/0x1ae
[   74.399027]  [<c035b109>] driver_register+0x54/0x84
[   74.409229]  [<c02e2999>] __pci_register_driver+0x7e/0xb3
[   74.420004]  [<c034c830>] init_ipmi_si+0x3f7/0x829
[   74.430196]  [<c06725bc>] init+0x144/0x26c
[   74.439611]  [<c0104cfb>] kernel_thread_helper+0x7/0x1c
[   74.450184]  =======================
[   74.459045] get: c0644890 count after get is 2
[   74.468796] kobject ipmi_si: registering. parent: <NULL>, set: drivers
[   74.480769] kobject_uevent_env
[   74.489210] fill_kobj_path: path = '/bus/pci/drivers/ipmi_si'
[   74.500675] BUG: at lib/kobject.c:242 kobject_register()
[   74.511779]  [<c0105086>] show_trace_log_lvl+0x1a/0x30
[   74.522812]  [<c01057b2>] show_trace+0x12/0x14
[   74.533082]  [<c0105856>] dump_stack+0x16/0x18
[   74.543269]  [<c02d429f>] kobject_register+0x79/0xb3
[   74.554015]  [<c035a13e>] bus_add_driver+0x77/0x1ae
[   74.564685]  [<c035b109>] driver_register+0x54/0x84
[   74.575363]  [<c02e2999>] __pci_register_driver+0x7e/0xb3
[   74.586595]  [<c034c830>] init_ipmi_si+0x3f7/0x829
[   74.597161]  [<c06725bc>] init+0x144/0x26c
[   74.606974]  [<c0104cfb>] kernel_thread_helper+0x7/0x1c
[   74.617989]  =======================
[   74.627292] register: c0644890 count now is 2 error 0
[   74.638150] BUG: at lib/kobject.c:448 kobject_get()
[   74.648812]  [<c0105086>] show_trace_log_lvl+0x1a/0x30
[   74.659872]  [<c01057b2>] show_trace+0x12/0x14
[   74.670237]  [<c0105856>] dump_stack+0x16/0x18
[   74.680554]  [<c02d3c2b>] kobject_get+0x66/0x87
[   74.690962]  [<c02d434c>] kset_find_obj+0x73/0x77
[   74.701563]  [<c01442c5>] module_add_driver+0x64/0x7d
[   74.712578]  [<c035a170>] bus_add_driver+0xa9/0x1ae
[   74.723405]  [<c035b109>] driver_register+0x54/0x84
[   74.734247]  [<c02e2999>] __pci_register_driver+0x7e/0xb3
[   74.745636]  [<c034c830>] init_ipmi_si+0x3f7/0x829
[   74.756393]  [<c06725bc>] init+0x144/0x26c
[   74.766429]  [<c0104cfb>] kernel_thread_helper+0x7/0x1c
[   74.777654]  =======================
[   74.787103] get: c18f65c0 count after get is 3
[   74.797461] BUG: at lib/kobject.c:448 kobject_get()
[   74.808209]  [<c0105086>] show_trace_log_lvl+0x1a/0x30
[   74.819241]  [<c01057b2>] show_trace+0x12/0x14
[   74.829427]  [<c0105856>] dump_stack+0x16/0x18
[   74.839446]  [<c02d3c2b>] kobject_get+0x66/0x87
[   74.849465]  [<c01b4812>] sysfs_create_link+0xd3/0x151
[   74.860178]  [<c0144285>] module_add_driver+0x24/0x7d
[   74.870866]  [<c035a170>] bus_add_driver+0xa9/0x1ae
[   74.881370]  [<c035b109>] driver_register+0x54/0x84
[   74.891850]  [<c02e2999>] __pci_register_driver+0x7e/0xb3
[   74.902918]  [<c034c830>] init_ipmi_si+0x3f7/0x829
[   74.913354]  [<c06725bc>] init+0x144/0x26c
[   74.923019]  [<c0104cfb>] kernel_thread_helper+0x7/0x1c
[   74.933904]  =======================
[   74.943042] get: c18f65c0 count after get is 4
[   74.953046] BUG: at lib/kobject.c:448 kobject_get()
[   74.963497]  [<c0105086>] show_trace_log_lvl+0x1a/0x30
[   74.974262]  [<c01057b2>] show_trace+0x12/0x14
[   74.984220]  [<c0105856>] dump_stack+0x16/0x18
[   74.994120]  [<c02d3c2b>] kobject_get+0x66/0x87
[   75.004167]  [<c02d3f4a>] kobject_shadow_add+0x3c/0x1e8
[   75.014941]  [<c02d4100>] kobject_add+0xa/0xc
[   75.024787]  [<c02d4248>] kobject_register+0x22/0xb3
[   75.035216]  [<c02d4431>] kobject_add_dir+0x4f/0x6e
[   75.045511]  [<c01442d9>] module_add_driver+0x78/0x7d
[   75.055991]  [<c035a170>] bus_add_driver+0xa9/0x1ae
[   75.066262]  [<c035b109>] driver_register+0x54/0x84
[   75.076489]  [<c02e2999>] __pci_register_driver+0x7e/0xb3
[   75.087297]  [<c034c830>] init_ipmi_si+0x3f7/0x829
[   75.097483]  [<c06725bc>] init+0x144/0x26c
[   75.106862]  [<c0104cfb>] kernel_thread_helper+0x7/0x1c
[   75.117454]  =======================
[   75.126306] get: c18f65c0 count after get is 5
[   75.136022] kobject drivers: registering. parent: ipmi_si, set: <NULL>
[   75.148068] kobject_uevent_env
[   75.156609] kobject filter function caused the event to drop!
[   75.168050] BUG: at lib/kobject.c:448 kobject_get()
[   75.178631]  [<c0105086>] show_trace_log_lvl+0x1a/0x30
[   75.189595]  [<c01057b2>] show_trace+0x12/0x14
[   75.199789]  [<c0105856>] dump_stack+0x16/0x18
[   75.209905]  [<c02d3c2b>] kobject_get+0x66/0x87
[   75.220072]  [<c01b4812>] sysfs_create_link+0xd3/0x151
[   75.230853]  [<c01442a5>] module_add_driver+0x44/0x7d
[   75.241531]  [<c035a170>] bus_add_driver+0xa9/0x1ae
[   75.252030]  [<c035b109>] driver_register+0x54/0x84
[   75.262455]  [<c02e2999>] __pci_register_driver+0x7e/0xb3
[   75.273444]  [<c034c830>] init_ipmi_si+0x3f7/0x829
[   75.283813]  [<c06725bc>] init+0x144/0x26c
[   75.293382]  [<c0104cfb>] kernel_thread_helper+0x7/0x1c
[   75.304189]  =======================
[   75.313370] get: c0644890 count after get is 3
[   75.323512] BUG: at lib/kobject.c:448 kobject_get()
[   75.334155]  [<c0105086>] show_trace_log_lvl+0x1a/0x30
[   75.345215]  [<c01057b2>] show_trace+0x12/0x14
[   75.355547]  [<c0105856>] dump_stack+0x16/0x18
[   75.365827]  [<c02d3c2b>] kobject_get+0x66/0x87
[   75.376185]  [<c035b157>] get_driver+0x11/0x18
[   75.386420]  [<c035b194>] driver_create_file+0xf/0x32
[   75.397291]  [<c035a221>] bus_add_driver+0x15a/0x1ae
[   75.408056]  [<c035b109>] driver_register+0x54/0x84
[   75.418682]  [<c02e2999>] __pci_register_driver+0x7e/0xb3
[   75.429904]  [<c034c830>] init_ipmi_si+0x3f7/0x829
[   75.440480]  [<c06725bc>] init+0x144/0x26c
[   75.450257]  [<c0104cfb>] kernel_thread_helper+0x7/0x1c
[   75.461238]  =======================
[   75.470402] get: c0644890 count after get is 4
[   75.480404] BUG: at lib/kobject.c:494 kobject_put()
[   75.490866]  [<c0105086>] show_trace_log_lvl+0x1a/0x30
[   75.501613]  [<c01057b2>] show_trace+0x12/0x14
[   75.511530]  [<c0105856>] dump_stack+0x16/0x18
[   75.521420]  [<c02d3ae7>] kobject_put+0x69/0x82
[   75.531449]  [<c035b144>] put_driver+0xb/0xd
[   75.541209]  [<c035b1b0>] driver_create_file+0x2b/0x32
[   75.551845]  [<c035a221>] bus_add_driver+0x15a/0x1ae
[   75.562324]  [<c035b109>] driver_register+0x54/0x84
[   75.572682]  [<c02e2999>] __pci_register_driver+0x7e/0xb3
[   75.583628]  [<c034c830>] init_ipmi_si+0x3f7/0x829
[   75.593942]  [<c06725bc>] init+0x144/0x26c
[   75.603469]  [<c0104cfb>] kernel_thread_helper+0x7/0x1c
[   75.614233]  =======================
[   75.623258] put: c0644890 count before put is 4
[   75.633227] BUG: at lib/kobject.c:448 kobject_get()
[   75.643575]  [<c0105086>] show_trace_log_lvl+0x1a/0x30
[   75.654272]  [<c01057b2>] show_trace+0x12/0x14
[   75.664153]  [<c0105856>] dump_stack+0x16/0x18
[   75.673991]  [<c02d3c2b>] kobject_get+0x66/0x87
[   75.683977]  [<c035b157>] get_driver+0x11/0x18
[   75.693884]  [<c035b194>] driver_create_file+0xf/0x32
[   75.704423]  [<c035a233>] bus_add_driver+0x16c/0x1ae
[   75.714893]  [<c035b109>] driver_register+0x54/0x84
[   75.725245]  [<c02e2999>] __pci_register_driver+0x7e/0xb3
[   75.736189]  [<c034c830>] init_ipmi_si+0x3f7/0x829
[   75.746496]  [<c06725bc>] init+0x144/0x26c
[   75.756023]  [<c0104cfb>] kernel_thread_helper+0x7/0x1c
[   75.766778]  =======================
[   75.775786] get: c0644890 count after get is 4
[   75.785652] BUG: at lib/kobject.c:494 kobject_put()
[   75.795990]  [<c0105086>] show_trace_log_lvl+0x1a/0x30
[   75.806687]  [<c01057b2>] show_trace+0x12/0x14
[   75.816577]  [<c0105856>] dump_stack+0x16/0x18
[   75.826416]  [<c02d3ae7>] kobject_put+0x69/0x82
[   75.836390]  [<c035b144>] put_driver+0xb/0xd
[   75.846107]  [<c035b1b0>] driver_create_file+0x2b/0x32
[   75.856744]  [<c035a233>] bus_add_driver+0x16c/0x1ae
[   75.867222]  [<c035b109>] driver_register+0x54/0x84
[   75.877589]  [<c02e2999>] __pci_register_driver+0x7e/0xb3
[   75.888545]  [<c034c830>] init_ipmi_si+0x3f7/0x829
[   75.898868]  [<c06725bc>] init+0x144/0x26c
[   75.908412]  [<c0104cfb>] kernel_thread_helper+0x7/0x1c
[   75.919193]  =======================
[   75.928228] put: c0644890 count before put is 4
[   75.949537] ipmi_si: pci_unregister_driver()
[   75.959258] bus pci: remove driver ipmi_si
[   75.968766] BUG: at lib/kobject.c:448 kobject_get()
[   75.979081]  [<c0105086>] show_trace_log_lvl+0x1a/0x30
[   75.989802]  [<c01057b2>] show_trace+0x12/0x14
[   75.999832]  [<c0105856>] dump_stack+0x16/0x18
[   76.009799]  [<c02d3c2b>] kobject_get+0x66/0x87
[   76.019863]  [<c035b157>] get_driver+0x11/0x18
[   76.029822]  [<c035b16c>] driver_remove_file+0xe/0x27
[   76.040389]  [<c035a019>] bus_remove_driver+0x3a/0xa4
[   76.050989]  [<c035b0a8>] driver_unregister+0xb/0x18
[   76.061432]  [<c02e282c>] pci_unregister_driver+0x13/0x73
[   76.072312]  [<c034cc34>] init_ipmi_si+0x7fb/0x829
[   76.082589]  [<c06725bc>] init+0x144/0x26c
[   76.092090]  [<c0104cfb>] kernel_thread_helper+0x7/0x1c
[   76.102742]  =======================
[   76.111690] get: c0644890 count after get is 4
[   76.121537] BUG: at lib/kobject.c:494 kobject_put()
[   76.131808]  [<c0105086>] show_trace_log_lvl+0x1a/0x30
[   76.142477]  [<c01057b2>] show_trace+0x12/0x14
[   76.152463]  [<c0105856>] dump_stack+0x16/0x18
[   76.162397]  [<c02d3ae7>] kobject_put+0x69/0x82
[   76.172408]  [<c035b144>] put_driver+0xb/0xd
[   76.182134]  [<c035b181>] driver_remove_file+0x23/0x27
[   76.192759]  [<c035a019>] bus_remove_driver+0x3a/0xa4
[   76.203309]  [<c035b0a8>] driver_unregister+0xb/0x18
[   76.213726]  [<c02e282c>] pci_unregister_driver+0x13/0x73
[   76.224578]  [<c034cc34>] init_ipmi_si+0x7fb/0x829
[   76.234840]  [<c06725bc>] init+0x144/0x26c
[   76.244316]  [<c0104cfb>] kernel_thread_helper+0x7/0x1c
[   76.254951]  =======================
[   76.263853] put: c0644890 count before put is 4
[   76.273754] BUG: at lib/kobject.c:448 kobject_get()
[   76.284057]  [<c0105086>] show_trace_log_lvl+0x1a/0x30
[   76.294677]  [<c01057b2>] show_trace+0x12/0x14
[   76.304462]  [<c0105856>] dump_stack+0x16/0x18
[   76.314213]  [<c02d3c2b>] kobject_get+0x66/0x87
[   76.324122]  [<c035b157>] get_driver+0x11/0x18
[   76.333942]  [<c035b16c>] driver_remove_file+0xe/0x27
[   76.344405]  [<c035a025>] bus_remove_driver+0x46/0xa4
[   76.354882]  [<c035b0a8>] driver_unregister+0xb/0x18
[   76.365243]  [<c02e282c>] pci_unregister_driver+0x13/0x73
[   76.376110]  [<c034cc34>] init_ipmi_si+0x7fb/0x829
[   76.386356]  [<c06725bc>] init+0x144/0x26c
[   76.395830]  [<c0104cfb>] kernel_thread_helper+0x7/0x1c
[   76.406544]  =======================
[   76.415524] get: c0644890 count after get is 4
[   76.425362] BUG: at lib/kobject.c:494 kobject_put()
[   76.435659]  [<c0105086>] show_trace_log_lvl+0x1a/0x30
[   76.446287]  [<c01057b2>] show_trace+0x12/0x14
[   76.456107]  [<c0105856>] dump_stack+0x16/0x18
[   76.465876]  [<c02d3ae7>] kobject_put+0x69/0x82
[   76.475800]  [<c035b144>] put_driver+0xb/0xd
[   76.485457]  [<c035b181>] driver_remove_file+0x23/0x27
[   76.496030]  [<c035a025>] bus_remove_driver+0x46/0xa4
[   76.506536]  [<c035b0a8>] driver_unregister+0xb/0x18
[   76.516911]  [<c02e282c>] pci_unregister_driver+0x13/0x73
[   76.527772]  [<c034cc34>] init_ipmi_si+0x7fb/0x829
[   76.538017]  [<c06725bc>] init+0x144/0x26c
[   76.547492]  [<c0104cfb>] kernel_thread_helper+0x7/0x1c
[   76.558194]  =======================
[   76.567160] put: c0644890 count before put is 4
[   76.577094] BUG: at lib/kobject.c:494 kobject_put()
[   76.587399]  [<c0105086>] show_trace_log_lvl+0x1a/0x30
[   76.598051]  [<c01057b2>] show_trace+0x12/0x14
[   76.607880]  [<c0105856>] dump_stack+0x16/0x18
[   76.617676]  [<c02d3ae7>] kobject_put+0x69/0x82
[   76.627617]  [<c01b27a3>] sysfs_hash_and_remove+0x116/0x11f
[   76.638712]  [<c01b473d>] sysfs_remove_link+0xb/0xd
[   76.649096]  [<c0144151>] module_remove_driver+0x18/0x57
[   76.659972]  [<c035a06b>] bus_remove_driver+0x8c/0xa4
[   76.670600]  [<c035b0a8>] driver_unregister+0xb/0x18
[   76.681138]  [<c02e282c>] pci_unregister_driver+0x13/0x73
[   76.692128]  [<c034cc34>] init_ipmi_si+0x7fb/0x829
[   76.702470]  [<c06725bc>] init+0x144/0x26c
[   76.712092]  [<c0104cfb>] kernel_thread_helper+0x7/0x1c
[   76.722899]  =======================
[   76.731916] put: c18f65c0 count before put is 5
[   76.741944] kobject ipmi_si: unregistering
[   76.751496] kobject_uevent_env
[   76.759873] fill_kobj_path: path = '/bus/pci/drivers/ipmi_si'
[   76.771235] BUG: at lib/kobject.c:494 kobject_put()
[   76.781811]  [<c0105086>] show_trace_log_lvl+0x1a/0x30
[   76.792782]  [<c01057b2>] show_trace+0x12/0x14
[   76.803009]  [<c0105856>] dump_stack+0x16/0x18
[   76.813168]  [<c02d3ae7>] kobject_put+0x69/0x82
[   76.823379]  [<c02d3bc2>] unlink+0x3b/0x3e
[   76.833121]  [<c02d3caf>] kobject_del+0x16/0x19
[   76.843272]  [<c02d3ce6>] kobject_unregister+0x34/0xa1
[   76.854002]  [<c035a073>] bus_remove_driver+0x94/0xa4
[   76.864671]  [<c035b0a8>] driver_unregister+0xb/0x18
[   76.875185]  [<c02e282c>] pci_unregister_driver+0x13/0x73
[   76.886124]  [<c034cc34>] init_ipmi_si+0x7fb/0x829
[   76.896439]  [<c06725bc>] init+0x144/0x26c
[   76.905974]  [<c0104cfb>] kernel_thread_helper+0x7/0x1c
[   76.916676]  =======================
[   76.925694] put: c0644890 count before put is 3
[   76.935799] BUG: at lib/kobject.c:430 kobject_unregister()
[   76.946990]  [<c0105086>] show_trace_log_lvl+0x1a/0x30
[   76.957893]  [<c01057b2>] show_trace+0x12/0x14
[   76.968033]  [<c0105856>] dump_stack+0x16/0x18
[   76.978063]  [<c02d3d3a>] kobject_unregister+0x88/0xa1
[   76.988811]  [<c035a073>] bus_remove_driver+0x94/0xa4
[   76.999498]  [<c035b0a8>] driver_unregister+0xb/0x18
[   77.010064]  [<c02e282c>] pci_unregister_driver+0x13/0x73
[   77.021089]  [<c034cc34>] init_ipmi_si+0x7fb/0x829
[   77.031524]  [<c06725bc>] init+0x144/0x26c
[   77.041179]  [<c0104cfb>] kernel_thread_helper+0x7/0x1c
[   77.051980]  =======================
[   77.061057] unregister: c0644890 count before put is 2
[   77.071811] BUG: at lib/kobject.c:494 kobject_put()
[   77.082360]  [<c0105086>] show_trace_log_lvl+0x1a/0x30
[   77.093203]  [<c01057b2>] show_trace+0x12/0x14
[   77.103189]  [<c0105856>] dump_stack+0x16/0x18
[   77.113053]  [<c02d3ae7>] kobject_put+0x69/0x82
[   77.123022]  [<c02d3d09>] kobject_unregister+0x57/0xa1
[   77.133655]  [<c035a073>] bus_remove_driver+0x94/0xa4
[   77.144247]  [<c035b0a8>] driver_unregister+0xb/0x18
[   77.154753]  [<c02e282c>] pci_unregister_driver+0x13/0x73
[   77.165770]  [<c034cc34>] init_ipmi_si+0x7fb/0x829
[   77.176205]  [<c06725bc>] init+0x144/0x26c
[   77.185880]  [<c0104cfb>] kernel_thread_helper+0x7/0x1c
[   77.196791]  =======================
[   77.205972] put: c0644890 count before put is 2


