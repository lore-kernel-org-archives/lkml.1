Return-Path: <linux-kernel-owner+w=401wt.eu-S1764915AbXGPMSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764915AbXGPMSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 08:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756565AbXGPMSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 08:18:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:32884 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167AbXGPMR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 08:17:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=tp4Em9u3+e2XcnTzFUjnSsKkk6dkSBfldwhVWg7WJMnNwvMXkNNdk9AhUhgXCB8ZwJW0raTUJHUcz92Z2K8PlMPRVsll6jNYMUl1bTrpypBzJEDgZbzHgSeZbHz8WMIetC8mW/16sFH4pJvM6wJka0WilrZbQd4DC5qU7rJD4so=
Message-ID: <469B61C8.8010902@googlemail.com>
Date: Mon, 16 Jul 2007 14:17:12 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, htejun@gmail.com, gregkh@suse.de
Subject: Re: Oops while modprobing phy fixed module
References: <4698BF14.10807@googlemail.com>	 <a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com>	 <469A5C94.7030201@googlemail.com> <a781481a0707151414l3efcd2d0q93db88a32b90e344@mail.gmail.com> <469A9D5D.10509@googlemail.com>
In-Reply-To: <469A9D5D.10509@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Satyam Sharma wrote:
>   
>> On 7/15/07, Gabriel C <nix.or.die@googlemail.com> wrote:
>>   
>>     
>>>>> [...]
>>>>> doing a modprobe fixed the driver segfaults and I get this Oops:
>>>>>
>>>>> Jul 14 13:43:30 lara [  157.953261] BUG: unable to handle kernel paging
>>>>> request at virtual address 43b7a800
>>>>>
>>>>>         
>>>>>           
>>>> 43b7a800 looks suspicious, it could have been a valid kernel
>>>> address, if only for what looks like a single-bit flip.
>>>>
>>>>
>>>>       
>>>>         
>>>>> Jul 14 13:43:30 lara [  157.953273]  printing eip:
>>>>> Jul 14 13:43:30 lara [  157.953278] c015d269
>>>>> Jul 14 13:43:30 lara [  157.953283] *pde = 00000000
>>>>> Jul 14 13:43:30 lara [  157.953293] Oops: 0000 [#1]
>>>>> Jul 14 13:43:30 lara [  157.953301] PREEMPT SMP
>>>>> Jul 14 13:43:30 lara [  157.953309] Modules linked in: fixed pc87360
>>>>> hwmon_vid i2c_isa eeprom adm1021 uhci_hcd sr_mod shpchp pci_hotplug
>>>>> ohci_hcd iTCO_wdt iTCO_vendor_support intel_agp i82860_edac i2c_i801
>>>>> ehci_hcd usbcore edac_mc cdrom agpgart 3c59x mii ext4dev jbd2 capability
>>>>> commoncap loop lp parport_pc parport
>>>>> Jul 14 13:43:30 lara [  157.953386] CPU:    3
>>>>> Jul 14 13:43:30 lara [  157.953387] EIP:    0060:[<c015d269>]    Not
>>>>> tainted VLI
>>>>> Jul 14 13:43:30 lara [  157.953391] EFLAGS: 00210006   (2.6.22-g8d9107e8 #7)
>>>>> Jul 14 13:43:30 lara [  157.953404] EIP is at kmem_cache_zalloc+0x75/0x89
>>>>> Jul 14 13:43:30 lara [  157.953412] eax: 00000000   ebx: 00200282   ecx:
>>>>> c14c8760   edx: 43b7a800
>>>>> Jul 14 13:43:30 lara [  157.953423] esi: e7f75840   edi: c17937b8   ebp:
>>>>> 000000d0   esp: db1ced98
>>>>> Jul 14 13:43:30 lara [  157.953434] ds: 007b   es: 007b   fs: 00d8  gs:
>>>>> 0033  ss: 0068
>>>>> Jul 14 13:43:30 lara [  157.953444] Process modprobe (pid: 2164,
>>>>> ti=db1ce000 task=de78ac20 task.ti=db1ce000)
>>>>> Jul 14 13:43:30 lara [  157.953450] Stack: c014cfd4 c01cf2f7 43b7a800
>>>>> c03ae384 c036d990 db150690 c17937b8 c17937b8
>>>>> Jul 14 13:43:30 lara [  157.953470]        c019752a 00000002 41ed0000
>>>>> e643bb60 c036d990 db150690 c036d990 e643bb60
>>>>> Jul 14 13:43:30 lara [  157.953489]        c01979b1 c0197712 db1cede4
>>>>> 00000000 e643bb60 c036d990 00000000 c03b8e98
>>>>> Jul 14 13:43:30 lara [  157.953513] Call Trace:
>>>>> Jul 14 13:43:30 lara [  157.953518]  [<c014cfd4>] kstrdup+0x27/0x47
>>>>> Jul 14 13:43:30 lara [  157.953530]  [<c01cf2f7>]
>>>>> ida_get_new_above+0xe6/0x166
>>>>> Jul 14 13:43:30 lara [  157.953551]  [<c019752a>] sysfs_new_dirent+0x3d/0xdc
>>>>> Jul 14 13:43:30 lara [  157.953574]  [<c01979b1>] create_dir+0x1e/0x8c
>>>>> Jul 14 13:43:30 lara [  157.953588]  [<c0197712>]
>>>>> sysfs_addrm_finish+0x13/0x1d8
>>>>> Jul 14 13:43:30 lara [  157.953609]  [<c0197a90>]
>>>>> sysfs_create_subdir+0x13/0x16
>>>>> Jul 14 13:43:30 lara [  157.953622]  [<c0198dba>]
>>>>> sysfs_create_group+0x25/0xe7
>>>>> Jul 14 13:43:30 lara [  157.953642]  [<c0233616>] device_pm_add+0x38/0x72
>>>>> Jul 14 13:43:30 lara [  157.953655]  [<c022f61d>] device_add+0x230/0x3d8
>>>>> Jul 14 13:43:30 lara [  157.953678]  [<e8c8f26d>]
>>>>> fixed_mdio_register_device+0x17a/0x20d [fixed]
>>>>> Jul 14 13:43:30 lara [  157.953706]  [<e8c8702c>] fixed_init+0x2c/0x2f
>>>>> [fixed]
>>>>> Jul 14 13:43:30 lara [  157.953718]  [<c01376ab>]
>>>>> sys_init_module+0x1686/0x175a
>>>>> Jul 14 13:43:30 lara [  157.953734]  [<c01601e3>] do_sync_read+0x0/0x10a
>>>>> Jul 14 13:43:30 lara [  157.953797]  [<c0103dee>]
>>>>> sysenter_past_esp+0x5f/0x85
>>>>> Jul 14 13:43:30 lara [  157.953816]  [<c0300000>]
>>>>> packet_setsockopt+0x1c9/0x2f3
>>>>> Jul 14 13:43:30 lara [  157.953835]  =======================
>>>>> Jul 14 13:43:30 lara [  157.953841] Code: 08 00 74 2f 8b 56 08 31 c0 89
>>>>> d1 c1 e9 02 8b 7c 24 08 f3 ab f6 c2 02 74 02 66 ab f6 c2 01 74 01 aa eb
>>>>> 10 0f b7 41 0a 8b 54 24 08 <8b> 04 82 89 41 0c eb c8 8b 44 24 08 83 c4
>>>>> 10 5b 5e 5f 5d c3 57
>>>>>
>>>>>         
>>>>>           
>>>> Thanks to Randy's wonderful decodecode script, we know this is
>>>> mov    (%edx,%eax,4),%eax
>>>>
>>>>
>>>>       
>>>>         
>>>>> Jul 14 13:43:30 lara [  157.953943] EIP: [<c015d269>]
>>>>> kmem_cache_zalloc+0x75/0x89 SS:ESP 0068:db1ced98
>>>>>
>>>>>         
>>>>>           
>>>> I think this is slab_alloc() inlined from SLUB's kmem_cache_zalloc():
>>>>
>>>>       page = s->cpu_slab[smp_processor_id()];
>>>>       if (unlikely(!page || !page->lockless_freelist ||
>>>>                       (node != -1 && page_to_nid(page) != node)))
>>>>
>>>>               object = __slab_alloc(s, gfpflags, node, addr, page);
>>>>
>>>>       else {
>>>>               object = page->lockless_freelist;
>>>>               page->lockless_freelist = object[page->offset]; <=== Oops
>>>>       }
>>>>
>>>> which shouldn't happen unless you have memory errors. I'd suggest
>>>> to check with memtest86+.
>>>>
>>>>       
>>>>         
>>> I did so again ( did a 24h memtest run like 2 weeks ago with no errors )
>>> for 12 hours now an no errors / no ECC errors , so I think my RAM is ok.
>>>
>>> That box is using RDRAM PC800 ECC Rambus.
>>>
>>> Do you want me to try reproduce this Oops with a full debug enabled kernel ?
>>>     
>>>       
>> Yup, it'll be good if you can reproduce the oops -- whether with a debug
>> enabled kernel or not (race conditions could get hidden with debug stuff
>> enabled, so getting oops frequently even without the debug stuff would
>> still be helpful).
>>
>>   
>>     
> Ok here it is again same config but with DEBUG_KERNEL=n
>
>
> ...
>
> Jul 15 23:51:01 lara [  220.800701] Fixed PHY: Registered new driver
> Jul 15 23:51:01 lara [  220.800815] Device 'fixed@100:1' does not have a
> release() function, it is broken and must be fixed.
> Jul 15 23:51:01 lara [  220.800823] WARNING: at drivers/base/core.c:107
> device_release()
> Jul 15 23:51:01 lara [  220.800837]  [<c01cf7c9>] kobject_cleanup+0x3d/0x54
> Jul 15 23:51:01 lara [  220.800853]  [<c01cf7e0>] kobject_release+0x0/0x8
> Jul 15 23:51:01 lara [  220.800863]  [<c01d03b0>] kref_put+0x60/0x6d
> Jul 15 23:51:01 lara [  220.800870]  [<c022f198>] device_del+0x1f3/0x215
> Jul 15 23:51:01 lara [  220.800888]  [<e8c8f2d5>]
> fixed_mdio_register_device+0x1e2/0x20d [fixed]
> Jul 15 23:51:01 lara [  220.800910]  [<e8c8701b>] fixed_init+0x1b/0x2f
> [fixed]
> Jul 15 23:51:01 lara [  220.800920]  [<c01376c3>]
> sys_init_module+0x1686/0x175a
> Jul 15 23:51:01 lara [  220.800934]  [<c0160070>] do_sync_read+0x0/0x10a
> Jul 15 23:51:01 lara [  220.800984]  [<c0103dee>]
> sysenter_past_esp+0x5f/0x85
> Jul 15 23:51:01 lara [  220.801000]  [<c0300000>]
> packet_getsockopt+0x5a/0x103
> Jul 15 23:51:01 lara [  220.801016]  =======================
> Jul 15 23:51:01 lara [  220.801045] BUG: unable to handle kernel paging
> request at virtual address 0f096800
> Jul 15 23:51:01 lara [  220.801053]  printing eip:
> Jul 15 23:51:01 lara [  220.801056] c015d0f1
> Jul 15 23:51:01 lara [  220.801060] *pde = 00000000
> Jul 15 23:51:01 lara [  220.801068] Oops: 0000 [#1]
> Jul 15 23:51:01 lara [  220.801068] Oops: 0000 [#1]
> Jul 15 23:51:01 lara [  220.801071] PREEMPT SMP
> Jul 15 23:51:01 lara [  220.801071] PREEMPT SMP
> Jul 15 23:51:01 lara [  220.801076] Modules linked in: fixed pc87360
> hwmon_vid i2c_isa eeprom adm1021 uhci_hcd sr_mod shpchp pci_hotplug
> ohci_hcd iTCO_wdt iTCO_vendor_support intel_agp i82860_edac i2c_i801
> ehci_hcd usbcore edac_mc cdrom agpgart 3c59x mii ext4dev jbd2 capability
> commoncap loop lp parport_pc parport
> Jul 15 23:51:01 lara [  220.801130] CPU:    1
> Jul 15 23:51:01 lara [  220.801130] CPU:    1
> Jul 15 23:51:01 lara [  220.801133] EIP:    0060:[<c015d0f1>]    Not
> tainted VLI
> Jul 15 23:51:01 lara [  220.801133] EIP:    0060:[<c015d0f1>]    Not
> tainted VLI
> Jul 15 23:51:01 lara [  220.801135] EFLAGS: 00210006   (2.6.22-g8d9107e8
> #11)
> Jul 15 23:51:01 lara [  220.801135] EFLAGS: 00210006   (2.6.22-g8d9107e8
> #11)
> Jul 15 23:51:01 lara [  220.801145] EIP is at kmem_cache_zalloc+0x75/0x89
> Jul 15 23:51:01 lara [  220.801145] EIP is at kmem_cache_zalloc+0x75/0x89
> Jul 15 23:51:01 lara [  220.801151] eax: 00000000   ebx: 00200282   ecx:
> c1381e00   edx: 0f096800
> Jul 15 23:51:01 lara [  220.801151] eax: 00000000   ebx: 00200282   ecx:
> c1381e00   edx: 0f096800
> Jul 15 23:51:01 lara [  220.801159] esi: e7f75840   edi: e7f0f6a8   ebp:
> 000000d0   esp: dbe97d98
> Jul 15 23:51:01 lara [  220.801159] esi: e7f75840   edi: e7f0f6a8   ebp:
> 000000d0   esp: dbe97d98
> Jul 15 23:51:01 lara [  220.801168] ds: 007b   es: 007b   fs: 00d8  gs:
> 0033  ss: 0068
> Jul 15 23:51:01 lara [  220.801168] ds: 007b   es: 007b   fs: 00d8  gs:
> 0033  ss: 0068
> Jul 15 23:51:01 lara [  220.801176] Process modprobe (pid: 2240,
> ti=dbe96000 task=db72ec20 task.ti=dbe96000)
> Jul 15 23:51:01 lara [  220.801176] Process modprobe (pid: 2240,
> ti=dbe96000 task=db72ec20 task.ti=dbe96000)
> Jul 15 23:51:01 lara [  220.801181] Stack: c014ce5c c01cf177 0f096800
> c03ae384 c036d768 db0ae690 e7f0f6a8 e7f0f6a8
> Jul 15 23:51:01 lara [  220.801181] Stack: c014ce5c c01cf177 0f096800
> c03ae384 c036d768 db0ae690 e7f0f6a8 e7f0f6a8
> Jul 15 23:51:01 lara [  220.801201]        c01973aa 00000002 41ed0000
> dc0f08c0 c036d768 db0ae690 c036d768 dc0f08c0
> Jul 15 23:51:01 lara [  220.801201]        c01973aa 00000002 41ed0000
> dc0f08c0 c036d768 db0ae690 c036d768 dc0f08c0
> Jul 15 23:51:01 lara [  220.801233]        c0197831 c0197592 dbe97de4
> 00000000 dc0f08c0 c036d768 00000000 c03b8e98
> Jul 15 23:51:01 lara [  220.801233]        c0197831 c0197592 dbe97de4
> 00000000 dc0f08c0 c036d768 00000000 c03b8e98
> Jul 15 23:51:01 lara [  220.801257] Call Trace:
> Jul 15 23:51:01 lara [  220.801257] Call Trace:
> Jul 15 23:51:01 lara [  220.801261]  [<c014ce5c>] kstrdup+0x27/0x47
> Jul 15 23:51:01 lara [  220.801261]  [<c014ce5c>] kstrdup+0x27/0x47
> Jul 15 23:51:01 lara [  220.801272]  [<c01cf177>]
> ida_get_new_above+0xe6/0x166
> Jul 15 23:51:01 lara [  220.801272]  [<c01cf177>]
> ida_get_new_above+0xe6/0x166
> Jul 15 23:51:01 lara [  220.801288]  [<c01973aa>] sysfs_new_dirent+0x3d/0xdc
> Jul 15 23:51:01 lara [  220.801288]  [<c01973aa>] sysfs_new_dirent+0x3d/0xdc
> Jul 15 23:51:01 lara [  220.801306]  [<c0197831>] create_dir+0x1e/0x8c
> Jul 15 23:51:01 lara [  220.801306]  [<c0197831>] create_dir+0x1e/0x8c
> Jul 15 23:51:01 lara [  220.801316]  [<c0197592>]
> sysfs_addrm_finish+0x13/0x1d8
> Jul 15 23:51:01 lara [  220.801316]  [<c0197592>]
> sysfs_addrm_finish+0x13/0x1d8
> Jul 15 23:51:01 lara [  220.801332]  [<c0197910>]
> sysfs_create_subdir+0x13/0x16
> Jul 15 23:51:01 lara [  220.801332]  [<c0197910>]
> sysfs_create_subdir+0x13/0x16
> Jul 15 23:51:01 lara [  220.801343]  [<c0198c3a>]
> sysfs_create_group+0x25/0xe7
> Jul 15 23:51:01 lara [  220.801343]  [<c0198c3a>]
> sysfs_create_group+0x25/0xe7
> Jul 15 23:51:01 lara [  220.801359]  [<c0233492>] device_pm_add+0x38/0x72
> Jul 15 23:51:01 lara [  220.801359]  [<c0233492>] device_pm_add+0x38/0x72
> Jul 15 23:51:01 lara [  220.801371]  [<c022f499>] device_add+0x230/0x3d8
> Jul 15 23:51:01 lara [  220.801371]  [<c022f499>] device_add+0x230/0x3d8
> Jul 15 23:51:01 lara [  220.801389]  [<e8c8f26d>]
> fixed_mdio_register_device+0x17a/0x20d [fixed]
> Jul 15 23:51:01 lara [  220.801389]  [<e8c8f26d>]
> fixed_mdio_register_device+0x17a/0x20d [fixed]
> Jul 15 23:51:01 lara [  220.801411]  [<e8c8702c>] fixed_init+0x2c/0x2f
> [fixed]
> Jul 15 23:51:01 lara [  220.801411]  [<e8c8702c>] fixed_init+0x2c/0x2f
> [fixed]
> Jul 15 23:51:01 lara [  220.801422]  [<c01376c3>]
> sys_init_module+0x1686/0x175a
> Jul 15 23:51:01 lara [  220.801422]  [<c01376c3>]
> sys_init_module+0x1686/0x175a
> Jul 15 23:51:01 lara [  220.801435]  [<c0160070>] do_sync_read+0x0/0x10a
> Jul 15 23:51:01 lara [  220.801435]  [<c0160070>] do_sync_read+0x0/0x10a
> Jul 15 23:51:01 lara [  220.801478]  [<c0103dee>]
> sysenter_past_esp+0x5f/0x85
> Jul 15 23:51:01 lara [  220.801478]  [<c0103dee>]
> sysenter_past_esp+0x5f/0x85
> Jul 15 23:51:01 lara [  220.801495]  [<c0300000>]
> packet_getsockopt+0x5a/0x103
> Jul 15 23:51:01 lara [  220.801495]  [<c0300000>]
> packet_getsockopt+0x5a/0x103
> Jul 15 23:51:01 lara [  220.801510]  =======================
> Jul 15 23:51:01 lara [  220.801510]  =======================
> Jul 15 23:51:01 lara [  220.801515] Code: 08 00 74 2f 8b 56 08 31 c0 89
> d1 c1 e9 02 8b 7c 24 08 f3 ab f6 c2 02 74 02 66 ab f6 c2 01 74 01 aa eb
> 10 0f b7 41 0a 8b 54 24 08 <8b> 04 82 89 41 0c eb c8 8b 44 24 08 83 c4
> 10 5b 5e 5f 5d c3 57
> Jul 15 23:51:01 lara [  220.801515] Code: 08 00 74 2f 8b 56 08 31 c0 89
> d1 c1 e9 02 8b 7c 24 08 f3 ab f6 c2 02 74 02 66 ab f6 c2 01 74 01 aa eb
> 10 0f b7 41 0a 8b 54 24 08 <8b> 04 82 89 41 0c eb c8 8b 44 24 08 83 c4
> 10 5b 5e 5f 5d c3 57
> Jul 15 23:51:01 lara [  220.801670] EIP: [<c015d0f1>]
> kmem_cache_zalloc+0x75/0x89 SS:ESP 0068:dbe97d98
> Jul 15 23:51:01 lara [  220.801670] EIP: [<c015d0f1>]
> kmem_cache_zalloc+0x75/0x89 SS:ESP 0068:dbe97d98
> Jul 15 23:51:06 lara [  225.774876] BUG: unable to handle kernel paging
> request at virtual address 0f096800
> Jul 15 23:51:06 lara [  225.774884]  printing eip:
> Jul 15 23:51:06 lara [  225.774888] c015d3b8
> Jul 15 23:51:06 lara [  225.774890] *pde = 00000000
> Jul 15 23:51:06 lara [  225.774895] Oops: 0000 [#2]
> Jul 15 23:51:06 lara [  225.774895] Oops: 0000 [#2]
> Jul 15 23:51:06 lara [  225.774898] PREEMPT SMP
> Jul 15 23:51:06 lara [  225.774898] PREEMPT SMP
> Jul 15 23:51:06 lara [  225.774902] Modules linked in: fixed pc87360
> hwmon_vid i2c_isa eeprom adm1021 uhci_hcd sr_mod shpchp pci_hotplug
> ohci_hcd iTCO_wdt iTCO_vendor_support intel_agp i82860_edac i2c_i801
> ehci_hcd usbcore edac_mc cdrom agpgart 3c59x mii ext4dev jbd2 capability
> commoncap loop lp parport_pc parport
> Jul 15 23:51:06 lara [  225.774944] CPU:    1
> Jul 15 23:51:06 lara [  225.774944] CPU:    1
> Jul 15 23:51:06 lara [  225.774945] EIP:    0060:[<c015d3b8>]    Not
> tainted VLI
> Jul 15 23:51:06 lara [  225.774945] EIP:    0060:[<c015d3b8>]    Not
> tainted VLI
> Jul 15 23:51:06 lara [  225.774947] EFLAGS: 00010006   (2.6.22-g8d9107e8
> #11)
> Jul 15 23:51:06 lara [  225.774947] EFLAGS: 00010006   (2.6.22-g8d9107e8
> #11)
> Jul 15 23:51:06 lara [  225.774958] EIP is at kmem_cache_alloc+0x4e/0x56
> Jul 15 23:51:06 lara [  225.774958] EIP is at kmem_cache_alloc+0x4e/0x56
> Jul 15 23:51:06 lara [  225.774962] eax: 00000000   ebx: 00000286   ecx:
> c1381e00   edx: 0f096800
> Jul 15 23:51:06 lara [  225.774962] eax: 00000000   ebx: 00000286   ecx:
> c1381e00   edx: 0f096800
> Jul 15 23:51:06 lara [  225.774967] esi: e7f75840   edi: e88556c4   ebp:
> 00000050   esp: e69e3ec0
> Jul 15 23:51:06 lara [  225.774967] esi: e7f75840   edi: e88556c4   ebp:
> 00000050   esp: e69e3ec0
> Jul 15 23:51:06 lara [  225.774972] ds: 007b   es: 007b   fs: 00d8  gs:
> 0000  ss: 0068
> Jul 15 23:51:06 lara [  225.774972] ds: 007b   es: 007b   fs: 00d8  gs:
> 0000  ss: 0068
> Jul 15 23:51:06 lara [  225.774977] Process kjournald2 (pid: 887,
> ti=e69e2000 task=e7edf840 task.ti=e69e2000)
> Jul 15 23:51:06 lara [  225.774977] Process kjournald2 (pid: 887,
> ti=e69e2000 task=e7edf840 task.ti=e69e2000)
> Jul 15 23:51:06 lara [  225.774981] Stack: 00000000 e7f6ac00 e6d92d20
> e69e2000 e68fa000 00000000 e88556c4 e737e248
> Jul 15 23:51:06 lara [  225.774981] Stack: 00000000 e7f6ac00 e6d92d20
> e69e2000 e68fa000 00000000 e88556c4 e737e248
> Jul 15 23:51:06 lara [  225.774993]        00000003 e4c0a578 e737e240
> 00000000 e6d92d20 00000000 e68fa000 e69e2000
> Jul 15 23:51:06 lara [  225.774993]        00000003 e4c0a578 e737e240
> 00000000 e6d92d20 00000000 e68fa000 e69e2000
> Jul 15 23:51:06 lara [  225.775004]        e88570cc 00001000 0000061b
> 00000000 de20e780 e4c0a578 e69e2000 e8852c68
> Jul 15 23:51:06 lara [  225.775004]        e88570cc 00001000 0000061b
> 00000000 de20e780 e4c0a578 e69e2000 e8852c68
> Jul 15 23:51:06 lara [  225.775016] Call Trace:
> Jul 15 23:51:06 lara [  225.775016] Call Trace:
> Jul 15 23:51:06 lara [  225.775023]  [<e88556c4>]
> jbd2_journal_add_journal_head+0x29/0x189 [jbd2]
> Jul 15 23:51:06 lara [  225.775023]  [<e88556c4>]
> jbd2_journal_add_journal_head+0x29/0x189 [jbd2]
> Jul 15 23:51:06 lara [  225.775046]  [<e88570cc>]
> jbd2_journal_get_descriptor_buffer+0x7b/0x83 [jbd2]
> Jul 15 23:51:06 lara [  225.775046]  [<e88570cc>]
> jbd2_journal_get_descriptor_buffer+0x7b/0x83 [jbd2]
> Jul 15 23:51:06 lara [  225.775063]  [<e8852c68>]
> jbd2_journal_commit_transaction+0x7eb/0x1163 [jbd2]
> Jul 15 23:51:06 lara [  225.775063]  [<e8852c68>]
> jbd2_journal_commit_transaction+0x7eb/0x1163 [jbd2]
> Jul 15 23:51:06 lara [  225.775077]  [<c0301644>]
> __sched_text_start+0x654/0x6cc
> Jul 15 23:51:06 lara [  225.775077]  [<c0301644>]
> __sched_text_start+0x654/0x6cc
> Jul 15 23:51:06 lara [  225.775095]  [<c0122602>] lock_timer_base+0x19/0x35
> Jul 15 23:51:06 lara [  225.775095]  [<c0122602>] lock_timer_base+0x19/0x35
> Jul 15 23:51:06 lara [  225.775106]  [<c0122662>]
> try_to_del_timer_sync+0x44/0x4a
> Jul 15 23:51:06 lara [  225.775106]  [<c0122662>]
> try_to_del_timer_sync+0x44/0x4a
> Jul 15 23:51:06 lara [  225.775115]  [<e88569bc>] kjournald2+0xb0/0x1ef
> [jbd2]
> Jul 15 23:51:06 lara [  225.775115]  [<e88569bc>] kjournald2+0xb0/0x1ef
> [jbd2]
> Jul 15 23:51:06 lara [  225.775129]  [<c012ad54>]
> autoremove_wake_function+0x0/0x33
> Jul 15 23:51:06 lara [  225.775129]  [<c012ad54>]
> autoremove_wake_function+0x0/0x33
> Jul 15 23:51:06 lara [  225.775139]  [<e885690c>] kjournald2+0x0/0x1ef
> [jbd2]
> Jul 15 23:51:06 lara [  225.775139]  [<e885690c>] kjournald2+0x0/0x1ef
> [jbd2]
> Jul 15 23:51:06 lara [  225.775151]  [<c012ac87>] kthread+0x38/0x5d
> Jul 15 23:51:06 lara [  225.775151]  [<c012ac87>] kthread+0x38/0x5d
> Jul 15 23:51:06 lara [  225.775157]  [<c012ac4f>] kthread+0x0/0x5d
> Jul 15 23:51:06 lara [  225.775157]  [<c012ac4f>] kthread+0x0/0x5d
> Jul 15 23:51:06 lara [  225.775162]  [<c0104a3f>]
> kernel_thread_helper+0x7/0x10
> Jul 15 23:51:06 lara [  225.775162]  [<c0104a3f>]
> kernel_thread_helper+0x7/0x10
> Jul 15 23:51:06 lara [  225.775172]  =======================
> Jul 15 23:51:06 lara [  225.775172]  =======================
> Jul 15 23:51:06 lara [  225.775175] Code: 8b 51 0c 85 d2 75 20 89 4c 24
> 04 89 3c 24 83 c9 ff 89 ea 89 f0 e8 a7 f7 ff ff 89 c2 53 9d 89 d0 5f 5d
> 5b 5e 5f 5d c3 0f b7 41 0a <8b> 04 82 89 41 0c eb e9 55 57 56 53 83 ec
> 10 89 c1 89 54 24 0c
> Jul 15 23:51:06 lara [  225.775175] Code: 8b 51 0c 85 d2 75 20 89 4c 24
> 04 89 3c 24 83 c9 ff 89 ea 89 f0 e8 a7 f7 ff ff 89 c2 53 9d 89 d0 5f 5d
> 5b 5e 5f 5d c3 0f b7 41 0a <8b> 04 82 89 41 0c eb e9 55 57 56 53 83 ec
> 10 89 c1 89 54 24 0c
> Jul 15 23:51:06 lara [  225.775235] EIP: [<c015d3b8>]
> kmem_cache_alloc+0x4e/0x56 SS:ESP 0068:e69e3ec0
> Jul 15 23:51:06 lara [  225.775235] EIP: [<c015d3b8>]
> kmem_cache_alloc+0x4e/0x56 SS:ESP 0068:e69e3ec0
>
> .....
>
> Second Oops occurred while doing 'ls'.
>
> ( http://194.231.229.228/Oops.txt )
>   


I cannot reproduce this on plain 2.6.22 so I've started to bisect the
problem.

Here the bisect result:

3007e997de91ec59af39a3f9c91595b31ae6e08b is first bad commit
commit 3007e997de91ec59af39a3f9c91595b31ae6e08b
Author: Tejun Heo <htejun@gmail.com>
Date:   Thu Jun 14 04:27:23 2007 +0900

    sysfs: use sysfs_mutex to protect the sysfs_dirent tree

    As kobj sysfs dentries and inodes are gonna be made reclaimable,
    i_mutex can't be used to protect sysfs_dirent tree.  Use sysfs_mutex
    globally instead.  As the whole tree is protected with sysfs_mutex,
    there is no reason to keep sysfs_rename_sem.  Drop it.

    While at it, add docbook comments to functions which require
    sysfs_mutex locking.

    Signed-off-by: Tejun Heo <htejun@gmail.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

:040000 040000 9deba7887752bc343cc4f5dea2dac70e895ea8b6
75340b6e18c1ada500bb1a2b99ee88fd93ebae8c M      fs

I cannot revert while some conflicts and I don't know how to solve the
conflicts manually.

Git bisect log :

$ git bisect log
git-bisect start
# bad: [8d9107e8c50e1c4ff43c91c8841805833f3ecfb9] Revert "SELinux: use
SECINITSID_NETMSG instead of SECINITSID_UNLABELED for NetLabel"
git-bisect bad 8d9107e8c50e1c4ff43c91c8841805833f3ecfb9
# good: [7dcca30a32aadb0520417521b0c44f42d09fe05c] Linux 2.6.22
git-bisect good 7dcca30a32aadb0520417521b0c44f42d09fe05c
# good: [15028aad00ddf241581fbe74a02ec89cbb28d35d] [TG3]: Update version
to 3.78.
git-bisect good 15028aad00ddf241581fbe74a02ec89cbb28d35d
# bad: [39892da44b21b5362eb848ca424d73a25ccc488f] USB: Digi AccelePort
adapted to new tty buffering
git-bisect bad 39892da44b21b5362eb848ca424d73a25ccc488f
# bad: [dc690d8ef842b464f1c429a376ca16cb8dbee6ae] Merge
master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6
git-bisect bad dc690d8ef842b464f1c429a376ca16cb8dbee6ae
# good: [82afee684fe3badaf5ee3fc5b6fda687d558bfb5] Merge
master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6
git-bisect good 82afee684fe3badaf5ee3fc5b6fda687d558bfb5
# good: [380e6fbb729a55b73d5d8409551474884e0d93fc] sysfs: implement
SYSFS_FLAG_REMOVED flag
git-bisect good 380e6fbb729a55b73d5d8409551474884e0d93fc
# good: [c6e54a578133fb353a50fb44d650768b3b9eb18e] libata: remove irq_on
from ata_bus_reset() and ata_std_postreset()
git-bisect good c6e54a578133fb353a50fb44d650768b3b9eb18e
# good: [28fc582cc9b7fc6ed6a9fbf9565a2b1e56eee880] [MIPS] Sparse: Use
NULL for pointer
git-bisect good 28fc582cc9b7fc6ed6a9fbf9565a2b1e56eee880
# bad: [51225039f3cf9d250596d1344494b293274b9169] sysfs: make directory
dentries and inodes reclaimable
git-bisect bad 51225039f3cf9d250596d1344494b293274b9169
# bad: [3007e997de91ec59af39a3f9c91595b31ae6e08b] sysfs: use sysfs_mutex
to protect the sysfs_dirent tree
git-bisect bad 3007e997de91ec59af39a3f9c91595b31ae6e08b
# good: [608e266a2d4e62c1b98c1c573064b6afe8c06a58] sysfs: make kobj
point to sysfs_dirent instead of dentry
git-bisect good 608e266a2d4e62c1b98c1c573064b6afe8c06a58
# good: [5f9953237f684ea1778adb9d26162da00b282225] sysfs: consolidate
sysfs spinlocks
git-bisect good 5f9953237f684ea1778adb9d26162da00b282225


Gabriel



