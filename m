Return-Path: <linux-kernel-owner+w=401wt.eu-S1752452AbYCEO3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbYCEO3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 09:29:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbYCEO2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 09:28:49 -0500
Received: from sacred.ru ([62.205.161.221]:37530 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbYCEO2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 09:28:48 -0500
Message-ID: <47CEADFA.8070003@openvz.org>
Date: Wed, 05 Mar 2008 17:28:10 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>
Subject: Re: 2.6.25-rc3-mm1
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>	 <47CE9A6B.9080006@openvz.org> <1204723866.5212.3.camel@lov.site>	 <47CEA247.1040506@openvz.org> <1204725260.5212.8.camel@lov.site>
In-Reply-To: <1204725260.5212.8.camel@lov.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 05 Mar 2008 17:28:03 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Wed, 2008-03-05 at 16:38 +0300, Pavel Emelyanov wrote:
>> Kay Sievers wrote:
>>> On Wed, 2008-03-05 at 16:04 +0300, Pavel Emelyanov wrote:
>>>> With CONFIG_SYSFS not set got this on boot:
>>>>
>>>> kobject: '<NULL>' (f88774c8): is not initialized, yet kobject_put() is
>>>> ------------[ cut here ]------------
>>>> WARNING: at lib/kobject.c:652 kobject_put+0x29/0x3c()
>>>> Modules linked in: sky2 e1000
>>>> Pid: 1303, comm: modprobe Not tainted 2.6.25-rc3-mm1 #79
>>>>  [<c041855b>] warn_on_slowpath+0x40/0x66
>>>>  [<c041c687>] irq_exit+0x50/0x67
>>>>  [<c040cc70>] smp_apic_timer_interrupt+0x6e/0x7a
>>>>  [<c0403380>] apic_timer_interrupt+0x28/0x30
>>>>  [<c0418e36>] vprintk+0x2b0/0x2df
>>>>  [<c04118e8>] __update_rq_clock+0x1d/0x110
>>>>  [<c0565e43>] schedule_timeout+0x13/0x86
>>>>
>>>>  [<c05656c2>] wait_for_common+0xd1/0x123
>>>>  [<c0418e79>] printk+0x14/0x18
>>>>  [<c04b34bf>] kobject_put+0x29/0x3c
>>>>  [<c0431e39>] free_module+0x2f/0x72
>>>>  [<c04328dd>] sys_init_module+0xa61/0x15d2
>>>>
>>>>  [<c04ba863>] pci_bus_read_config_byte+0x0/0x58
>>>>  [<c0454f87>] vfs_read+0x6c/0x8b
>>>>  [<c0455323>] sys_read+0x3c/0x63
>>>>  [<c04028b2>] sysenter_past_esp+0x5f/0x85
>>>>
>>>>  =======================
>>>> ---[ end trace d50646e8e8e48682 ]---
>>> Does this fix it?:
>>>
>>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=120fc3d77acfd91f3521737a440d42839c475982
>> This is already in 2.6.25-rc3-mm1, so the answer is "no it does not" :)
> 
> Ok. Care to enable CONFIG_DEBUG_KOBJECT, and post the part of the log
> that happens right before the WARN()? We might get a hint where to look
> for the stuff that goes wrong.

Hm... Not sure how may lines are required, but here'are the ones
that are related to sky2 module, which is loaded and then removed:

kobject: 'sky2' (f74de280): kobject_add_internal: parent: 'drivers', set: 'drivers'
PCI: Setting latency timer of device 0000:02:00.0 to 64
sky2 0000:02:00.0: v1.21 addr 0xdeefc000 irq 16 Yukon-EC (0xb6) rev 2
kobject: 'net' (f7512200): kobject_add_internal: parent: '0000:02:00.0', set: '<NULL>'
kobject: 'eth1' (f74ccb64): kobject_add_internal: parent: 'net', set: 'devices'
kobject: 'eth1' (f74ccb64): kobject_uevent_env
kobject: 'eth1' (f74ccb64): fill_kobj_path: path = '/devices/pci0000:00/0000:00:03.0/0000:02:00.0/net/eth1'
sky2 eth1: addr 00:0e:0c:3b:d8:8a
kobject: 'sky2' (f74de280): kobject_uevent_env
kobject: 'sky2' (f74de280): fill_kobj_path: path = '/bus/pci/drivers/sky2'
sky2 eth1: enabling interface
sky2 eth1: disabling interface
kobject: 'eth1' (f74ccb64): kobject_uevent_env
kobject: 'eth1' (f74ccb64): fill_kobj_path: path = '/devices/pci0000:00/0000:00:03.0/0000:02:00.0/net/eth1'
kobject: 'net' (f7512200): kobject_cleanup

kobject: 'net' (f7512200): auto cleanup kobject_del
kobject: 'net' (f7512200): calling ktype release
kobject: (f7512200): dynamic_kobj_release
kobject: 'net': free name
kobject: 'eth1' (f74ccb64): kobject_cleanup
kobject: 'eth1' (f74ccb64): calling ktype release
kobject: 'eth1': free name
kobject: 'sky2' (f74de280): kobject_cleanup

kobject: 'sky2' (f74de280): auto cleanup 'remove' event
kobject: 'sky2' (f74de280): kobject_uevent_env
kobject: 'sky2' (f74de280): fill_kobj_path: path = '/bus/pci/drivers/sky2'
kobject: 'sky2' (f74de280): auto cleanup kobject_del
kobject: 'sky2' (f74de280): calling ktype release

kobject: 'sky2': free name
kobject: '<NULL>' (f886cb48): is not initialized, yet kobject_put() is being called.
------------[ cut here ]------------
WARNING: at lib/kobject.c:652 kobject_put+0x29/0x3c()
Modules linked in: e1000 [last unloaded: sky2]
Pid: 3188, comm: rmmod Tainted: G        W 2.6.25-rc3-mm1 #88
 [<c041855b>] warn_on_slowpath+0x40/0x66

 [<c041c687>] irq_exit+0x50/0x67
 [<c040cc70>] smp_apic_timer_interrupt+0x6e/0x7a
 [<c0403380>] apic_timer_interrupt+0x28/0x30
 [<c0418e36>] vprintk+0x2b0/0x2df
 [<c04118e8>] __update_rq_clock+0x1d/0x110
 [<c0565f43>] schedule_timeout+0x13/0x86
 [<c05657c2>] wait_for_common+0xd1/0x123
 [<c0418e79>] printk+0x14/0x18
 [<c04b3474>] kobject_put+0x29/0x3c
 [<c0431e39>] free_module+0x2f/0x72
 [<c0433a09>] sys_delete_module+0x19a/0x1b1
 [<c040f866>] do_page_fault+0x1f6/0x4cc
 [<c04028b2>] sysenter_past_esp+0x5f/0x85

 =======================

But this happens _after_ the very first warning and I can't figure 
out which modules causes one :( Do you need a full dmesg for that?

> Thanks,
> Kay
> 
> 

