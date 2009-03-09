Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbZCITbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbZCITbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 15:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbZCITbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 15:31:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:44891 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZCITbE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 15:31:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=P+BsYfPF7A9xfXzbHWqOjP8OAzgBSnglenBb18Oo9z+t/9KmjrCfSimtKQccCY7gTN
         WvfIeX/L08Bdy++Lkzw+e2aS4Tv8drxxL0SU0gmfVu7SiE5UfXji5Wo6d2z1MWmsVNbI
         NDHGDXPf7nfgIQZXhk8UajyoEc6Slyx3iAHUo=
MIME-Version: 1.0
In-Reply-To: <20090309185117.GJ32589@ldl.fc.hp.com>
References: <20090309052933.3918.86601.stgit@bob.kio>
	 <20090309185117.GJ32589@ldl.fc.hp.com>
Date: Mon, 9 Mar 2009 20:30:59 +0100
Message-ID: <19f34abd0903091230q27a04f37mdb0ba75ba170e6a@mail.gmail.com>
Subject: Re: [PATCH v3 00/11] PCI core learns hotplug
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Alex Chiang <achiang@hp.com>, jbarnes@virtuousgeek.org,
       xyzzy@speakeasy.org, djwong@us.ibm.com, shimada-yxb@necst.nec.co.jp,
       rjw@sisk.pl, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/9 Alex Chiang <achiang@hp.com>:
> * Alex Chiang <achiang@hp.com>:
>>
>> There is still one major bug somewhere that shows up only when using
>> the PCIe portdriver (that is, any time PCIe support is built into
>> the kernel). You get an oops during multiple remove/rescan cycles,
>> especially on devices with an internal bridge.
>
> Got it, we had a double-free in the PCIe port driver which was
> causing all sorts of problems.
>
> I fixed that and now this patch series is stable enough for
> others to actually apply and test. As of now, there are no known
> bugs.
>
> Of course, I'm going to keep testing and try to find some more
> bugs. :)
>
> As a reminder, if you want to play with this series, you'll also
> need these two patches:
>
>>       http://thread.gmane.org/gmane.linux.kernel.pci/3437
>>       http://lkml.org/lkml/2009/3/7/173
>
> And now this third patch:
>
>        http://thread.gmane.org/gmane.linux.kernel.pci/3524
>
> Finally, patch 07/11 needs to be updated. I'll post a reply to
> that mail with the updated patch.

Hi,

I got this crash:

[  279.029673] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000008
[  279.030011] IP: [<ffffffff811fce96>] pci_remove_bus_device+0x56/0xe0
[  279.030011] PGD 3e47e067 PUD 3e4d1067 PMD 0
[  279.030011] Oops: 0002 [#1] SMP
[  279.030011] last sysfs file: /sys/devices/pci0000:00/0000:00:00.0/remove
[  279.030011] CPU 0
[  279.030011] Pid: 6, comm: events/0 Not tainted 2.6.29-rc6 #361 945P-A
[  279.030011] RIP: 0010:[<ffffffff811fce96>]  [<ffffffff811fce96>]
pci_remove_bus_device+0x56/0xe0
[  279.030011] RSP: 0018:ffff88003f8bde30  EFLAGS: 00010286
[  279.030011] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff817ab9b8
[  279.030011] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff817ab9b0
[  279.030011] RBP: ffff88003f8bde50 R08: 00000000002ec000 R09: 0000000000000000
[  279.030011] R10: ffff88003d9fd7c0 R11: 0000000000000040 R12: ffff88003d929800
[  279.030011] R13: ffff88003d929800 R14: ffff88003f80a908 R15: ffff88003f8adf00
[  279.030011] FS:  0000000000000000(0000) GS:ffff8800019f1000(0000)
knlGS:0000000000000000
[  279.030011] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  279.030011] CR2: ffff88003e4d1000 CR3: 000000003e452000 CR4: 00000000000006a0
[  279.030011] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  279.030011] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
[  279.030011] Process events/0 (pid: 6, threadinfo ffff88003f8bc000,
task ffff88003f8a2350)
[  279.030011] Stack:
[  279.030011]  ffffffffffffffff ffff88003d929800 ffff88003d9de800
ffff88003f80a908
[  279.030011]  ffff88003f8bde70 ffffffff81202f7d 0000000000000010
ffff88003d9de820
[  279.030011]  ffff88003f8bde90 ffffffff8112503f ffff88003f80a900
ffffffff81125020
[  279.030011] Call Trace:
[  279.030011]  [<ffffffff81202f7d>] remove_callback+0x3d/0x60
[  279.030011]  [<ffffffff8112503f>] sysfs_schedule_callback_work+0x1f/0x40
[  279.030011]  [<ffffffff81125020>] ? sysfs_schedule_callback_work+0x0/0x40
[  279.030011]  [<ffffffff81055510>] run_workqueue+0x70/0x130
[  279.030011]  [<ffffffff81055677>] worker_thread+0xa7/0x120
[  279.030011]  [<ffffffff810597f0>] ? autoremove_wake_function+0x0/0x40
[  279.030011]  [<ffffffff810555d0>] ? worker_thread+0x0/0x120
[  279.030011]  [<ffffffff810593d9>] kthread+0x49/0x90
[  279.030011]  [<ffffffff8100d45a>] child_rip+0xa/0x20
[  279.030011]  [<ffffffff81059390>] ? kthread+0x0/0x90
[  279.030011]  [<ffffffff8100d450>] ? child_rip+0x0/0x20
[  279.030011] Code: 00 00 00 4c 89 ef 4d 89 ec 31 db e8 75 fe ff ff
48 c7 c7 b0 b9 7a 81 e8 f9 f8 3a 00 49 8b 55 00 49 8b
 45 08 48 c7 c7 b0 b9 7a 81 <48> 89 42 08 48 89 10 49 c7 45 08 00 00
00 00 49 c7 45 00 00 00
[  279.030011] RIP  [<ffffffff811fce96>] pci_remove_bus_device+0x56/0xe0
[  279.030011]  RSP <ffff88003f8bde30>
[  279.030011] CR2: 0000000000000008
[  279.291933] ---[ end trace 4ba18f2857f89768 ]---

It was with this patch queue on top of pci/linux-next
(487e348b0ff23e061f60010477a664ea378c1b30):

 PCIe: portdrv: call pci_disable_device during remove
 PCIe: AER: during disable, check subordinate before walking
 PCIe portdrv: eliminate double kfree in remove path
 PCI Hotplug: schedule fakephp for feature removal
 PCI Hotplug: rename legacy_fakephp to fakephp
 PCI Hotplug: restore fakephp interface with complete reimplementation
 PCI: Introduce /sys/bus/pci/devices/.../rescan
 PCI: Introduce /sys/bus/pci/devices/.../remove (new version)
 PCI: Introduce /sys/bus/pci/rescan
 PCI: beef up pci_do_scan_bus()
 PCI: always scan child buses
 PCI: pci_scan_slot() returns newly found devices
 PCI: don't scan existing devices
 PCI: pci_is_root_bus helper

It reproduces reliably if I do this:

$ while true; do echo 1 > /sys/bus/pci/devices/0000\:00\:00.0/remove; done

Line numbers:

$ addr2line -e vmlinux -i ffffffff811fce96
include/linux/list.h:92
include/linux/list.h:105
drivers/pci/remove.c:40
drivers/pci/remove.c:106

And this is my drivers/pci/remove.c:

 33 static void pci_destroy_dev(struct pci_dev *dev)
 34 {
 35         pci_stop_dev(dev);
 36
 37         /* Remove the device from the device lists, and prevent any further
 38          * list accesses from this device */
 39         down_write(&pci_bus_sem);
 40         list_del(&dev->bus_list);
 41         dev->bus_list.next = dev->bus_list.prev = NULL;
 42         up_write(&pci_bus_sem);
 43
 44         pci_free_resources(dev);
 45         pci_dev_put(dev);
 46 }


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
