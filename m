Return-Path: <linux-kernel-owner+w=401wt.eu-S1758460AbXGPSBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460AbXGPSBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 14:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757096AbXGPSAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 14:00:53 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:52725 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757354AbXGPSAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 14:00:43 -0400
X-Greylist: delayed 1038 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jul 2007 14:00:43 EDT
Date: Mon, 16 Jul 2007 21:43:40 +0400
From: Vitaly Bordug <vbordug@ru.mvista.com>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Christoph Lameter <clameter@sgi.com>
Subject: Re: Oops while modprobing phy fixed module
Message-ID: <20070716214340.06e94d5e@vitb.ru.mvista.com>
In-Reply-To: <469A5C94.7030201@googlemail.com>
References: <4698BF14.10807@googlemail.com>
	<a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com>
	<469A5C94.7030201@googlemail.com>
Organization: MontaVista software, Inc.
X-Mailer: Claws Mail 2.9.1cvs30 (GTK+ 2.6.10; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

I will have the fix and rework to the fixed phy posted by today/tomorrow.
You'll have to modify platform code a bit

Thanks,
-Vitaly


On Sun, 15 Jul 2007 19:42:44 +0200
Gabriel C <nix.or.die@googlemail.com> wrote:

> Satyam Sharma wrote:
> > Hi Gabriel,
> >   
> 
> Hi Satyam ,
> 
> > On 7/14/07, Gabriel C <nix.or.die@googlemail.com> wrote:
> >   
> >> Hi,
> >>
> >> doing a modprobe fixed the driver segfaults and I get this Oops:
> >>
> >>
> >> Jul 14 13:43:30 lara [  157.952915] Fixed PHY: Registered new driver
> >> Jul 14 13:43:30 lara [  157.953010] Device 'fixed@100:1' does not have a
> >> release() function, it is broken and must be fixed.
> >> Jul 14 13:43:30 lara [  157.953019] WARNING: at drivers/base/core.c:107
> >> device_release()
> >> Jul 14 13:43:30 lara [  157.953032]  [<c01cf949>] kobject_cleanup+0x3d/0x54
> >> Jul 14 13:43:30 lara [  157.953050]  [<c01cf960>] kobject_release+0x0/0x8
> >> Jul 14 13:43:30 lara [  157.953060]  [<c01d0530>] kref_put+0x60/0x6d
> >> Jul 14 13:43:30 lara [  157.953068]  [<c022f31c>] device_del+0x1f3/0x215
> >> Jul 14 13:43:30 lara [  157.953083]  [<e8c8f2d5>]
> >> fixed_mdio_register_device+0x1e2/0x20d [fixed]
> >> Jul 14 13:43:30 lara [  157.953108]  [<e8c8701b>] fixed_init+0x1b/0x2f
> >> [fixed]
> >> Jul 14 13:43:30 lara [  157.953119]  [<c01376ab>]
> >> sys_init_module+0x1686/0x175a
> >> Jul 14 13:43:30 lara [  157.953133]  [<c01601e3>] do_sync_read+0x0/0x10a
> >> Jul 14 13:43:30 lara [  157.953180]  [<c0103dee>]
> >> sysenter_past_esp+0x5f/0x85
> >> Jul 14 13:43:30 lara [  157.953195]  [<c0300000>]
> >> packet_setsockopt+0x1c9/0x2f3
> >> Jul 14 13:43:30 lara [  157.953232]  =======================
> >>     
> >
> > This looks unrelated to the oops itself, but still something that
> > needs to be fixed, of course. [ Maintainers added to Cc: ]
> >
> >   
> >> Jul 14 13:43:30 lara [  157.953261] BUG: unable to handle kernel paging
> >> request at virtual address 43b7a800
> >>     
> >
> > 43b7a800 looks suspicious, it could have been a valid kernel
> > address, if only for what looks like a single-bit flip.
> >
> >   
> >> Jul 14 13:43:30 lara [  157.953273]  printing eip:
> >> Jul 14 13:43:30 lara [  157.953278] c015d269
> >> Jul 14 13:43:30 lara [  157.953283] *pde = 00000000
> >> Jul 14 13:43:30 lara [  157.953293] Oops: 0000 [#1]
> >> Jul 14 13:43:30 lara [  157.953301] PREEMPT SMP
> >> Jul 14 13:43:30 lara [  157.953309] Modules linked in: fixed pc87360
> >> hwmon_vid i2c_isa eeprom adm1021 uhci_hcd sr_mod shpchp pci_hotplug
> >> ohci_hcd iTCO_wdt iTCO_vendor_support intel_agp i82860_edac i2c_i801
> >> ehci_hcd usbcore edac_mc cdrom agpgart 3c59x mii ext4dev jbd2 capability
> >> commoncap loop lp parport_pc parport
> >> Jul 14 13:43:30 lara [  157.953386] CPU:    3
> >> Jul 14 13:43:30 lara [  157.953387] EIP:    0060:[<c015d269>]    Not
> >> tainted VLI
> >> Jul 14 13:43:30 lara [  157.953391] EFLAGS: 00210006   (2.6.22-g8d9107e8 #7)
> >> Jul 14 13:43:30 lara [  157.953404] EIP is at kmem_cache_zalloc+0x75/0x89
> >> Jul 14 13:43:30 lara [  157.953412] eax: 00000000   ebx: 00200282   ecx:
> >> c14c8760   edx: 43b7a800
> >> Jul 14 13:43:30 lara [  157.953423] esi: e7f75840   edi: c17937b8   ebp:
> >> 000000d0   esp: db1ced98
> >> Jul 14 13:43:30 lara [  157.953434] ds: 007b   es: 007b   fs: 00d8  gs:
> >> 0033  ss: 0068
> >> Jul 14 13:43:30 lara [  157.953444] Process modprobe (pid: 2164,
> >> ti=db1ce000 task=de78ac20 task.ti=db1ce000)
> >> Jul 14 13:43:30 lara [  157.953450] Stack: c014cfd4 c01cf2f7 43b7a800
> >> c03ae384 c036d990 db150690 c17937b8 c17937b8
> >> Jul 14 13:43:30 lara [  157.953470]        c019752a 00000002 41ed0000
> >> e643bb60 c036d990 db150690 c036d990 e643bb60
> >> Jul 14 13:43:30 lara [  157.953489]        c01979b1 c0197712 db1cede4
> >> 00000000 e643bb60 c036d990 00000000 c03b8e98
> >> Jul 14 13:43:30 lara [  157.953513] Call Trace:
> >> Jul 14 13:43:30 lara [  157.953518]  [<c014cfd4>] kstrdup+0x27/0x47
> >> Jul 14 13:43:30 lara [  157.953530]  [<c01cf2f7>]
> >> ida_get_new_above+0xe6/0x166
> >> Jul 14 13:43:30 lara [  157.953551]  [<c019752a>] sysfs_new_dirent+0x3d/0xdc
> >> Jul 14 13:43:30 lara [  157.953574]  [<c01979b1>] create_dir+0x1e/0x8c
> >> Jul 14 13:43:30 lara [  157.953588]  [<c0197712>]
> >> sysfs_addrm_finish+0x13/0x1d8
> >> Jul 14 13:43:30 lara [  157.953609]  [<c0197a90>]
> >> sysfs_create_subdir+0x13/0x16
> >> Jul 14 13:43:30 lara [  157.953622]  [<c0198dba>]
> >> sysfs_create_group+0x25/0xe7
> >> Jul 14 13:43:30 lara [  157.953642]  [<c0233616>] device_pm_add+0x38/0x72
> >> Jul 14 13:43:30 lara [  157.953655]  [<c022f61d>] device_add+0x230/0x3d8
> >> Jul 14 13:43:30 lara [  157.953678]  [<e8c8f26d>]
> >> fixed_mdio_register_device+0x17a/0x20d [fixed]
> >> Jul 14 13:43:30 lara [  157.953706]  [<e8c8702c>] fixed_init+0x2c/0x2f
> >> [fixed]
> >> Jul 14 13:43:30 lara [  157.953718]  [<c01376ab>]
> >> sys_init_module+0x1686/0x175a
> >> Jul 14 13:43:30 lara [  157.953734]  [<c01601e3>] do_sync_read+0x0/0x10a
> >> Jul 14 13:43:30 lara [  157.953797]  [<c0103dee>]
> >> sysenter_past_esp+0x5f/0x85
> >> Jul 14 13:43:30 lara [  157.953816]  [<c0300000>]
> >> packet_setsockopt+0x1c9/0x2f3
> >> Jul 14 13:43:30 lara [  157.953835]  =======================
> >> Jul 14 13:43:30 lara [  157.953841] Code: 08 00 74 2f 8b 56 08 31 c0 89
> >> d1 c1 e9 02 8b 7c 24 08 f3 ab f6 c2 02 74 02 66 ab f6 c2 01 74 01 aa eb
> >> 10 0f b7 41 0a 8b 54 24 08 <8b> 04 82 89 41 0c eb c8 8b 44 24 08 83 c4
> >> 10 5b 5e 5f 5d c3 57
> >>     
> >
> > Thanks to Randy's wonderful decodecode script, we know this is
> > mov    (%edx,%eax,4),%eax
> >
> >   
> >> Jul 14 13:43:30 lara [  157.953943] EIP: [<c015d269>]
> >> kmem_cache_zalloc+0x75/0x89 SS:ESP 0068:db1ced98
> >>     
> >
> > I think this is slab_alloc() inlined from SLUB's kmem_cache_zalloc():
> >
> > 	page = s->cpu_slab[smp_processor_id()];
> > 	if (unlikely(!page || !page->lockless_freelist ||
> > 			(node != -1 && page_to_nid(page) != node)))
> >
> > 		object = __slab_alloc(s, gfpflags, node, addr, page);
> >
> > 	else {
> > 		object = page->lockless_freelist;
> > 		page->lockless_freelist = object[page->offset];	<=== Oops
> > 	}
> >
> > which shouldn't happen unless you have memory errors. I'd suggest
> > to check with memtest86+.
> >   
> 
> I did so again ( did a 24h memtest run like 2 weeks ago with no errors )
> for 12 hours now an no errors / no ECC errors , so I think my RAM is ok.
> 
> That box is using RDRAM PC800 ECC Rambus.
> 
> Do you want me to try reproduce this Oops with a full debug enabled kernel ?
> 
> > Satyam
> >
> >   
> 
> Gabriel


-- 
Sincerely, 
Vitaly
