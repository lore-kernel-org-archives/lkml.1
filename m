Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbYB0NqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbYB0NqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 08:46:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755045AbYB0Npz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 08:45:55 -0500
Received: from mail.gmx.net ([213.165.64.20]:49013 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754975AbYB0Npy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 08:45:54 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/vSR8N+s3vaSXdnnqRqC3ow7b5pd7hDrdP83VnS6
	ziktqhLC3lKdFZ
Date: Wed, 27 Feb 2008 14:46:05 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PCI] duplicate sysfs symbols getting registered in current git
In-Reply-To: <20080227142103.1dd42f8f@gondolin.boeblingen.de.ibm.com>
Message-ID: <Pine.LNX.4.64.0802271438170.5059@axis700.grange>
References: <Pine.LNX.4.64.0802182142240.11540@axis700.grange>
 <20080220063834.GA22708@kroah.com> <Pine.LNX.4.64.0802251341160.4430@axis700.grange>
 <20080226201619.GA10343@kroah.com> <Pine.LNX.4.64.0802271222530.5059@axis700.grange>
 <20080227124748.2e89e628@gondolin.boeblingen.de.ibm.com>
 <Pine.LNX.4.64.0802271328300.5059@axis700.grange>
 <20080227142103.1dd42f8f@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, Cornelia Huck wrote:

> On Wed, 27 Feb 2008 13:33:13 +0100 (CET),
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > You mean the kernel panic without CONFIG_SYSFS_DEPRECATED? No, 
> > unfortunately is doesn't.
> 
> Hm, dev->kobj.parent may be NULL in cleanup_device_parent(). Does this
> one help?

Yes, this one does. But Greg's original idea, that disabling 
CONFIG_SYSFS_DEPRECATED would eliminate one of the warnings doesn't hold, 
all three of them are still there (after your patches):

kobject (c7c84700): tried to init an initialized object, something is seriously wrong.
Pid: 1, comm: swapper Not tainted 2.6.25-rc2-testpm-dirty #40
 [<c01ea105>] kobject_init+0x75/0x80
 [<c025093e>] device_initialize+0x1e/0x90
 [<c02510bb>] device_register+0xb/0x20
 [<c01f3df8>] pci_bus_add_devices+0x98/0x140
 [<c030abc7>] ? pcibios_scan_root+0x27/0xa0
 [<c03f69e0>] pci_legacy_init+0x50/0xf0
 [<c03db5c2>] kernel_init+0x132/0x310
 [<c010303a>] ? ret_from_fork+0x6/0x1c
 [<c03db490>] ? kernel_init+0x0/0x310
 [<c03db490>] ? kernel_init+0x0/0x310
 [<c0103d3f>] kernel_thread_helper+0x7/0x18
 =======================
sysfs: duplicate filename '0000:01' can not be created
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:424 sysfs_add_one+0x80/0xa0()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.25-rc2-testpm-dirty #40
 [<c01209f4>] warn_on_slowpath+0x54/0x70
 [<c01210bc>] ? __call_console_drivers+0x5c/0x70
 [<c0313c71>] ? _spin_unlock_irqrestore+0x11/0x30
 [<c0121379>] ? release_console_sem+0x1d9/0x1f0
 [<c01217fd>] ? vprintk+0x2ad/0x3b0
 [<c01e9789>] ? ida_get_new_above+0x89/0x180
 [<c01aa450>] ? sysfs_ilookup_test+0x0/0x20
 [<c0313bcf>] ? _spin_unlock+0xf/0x30
 [<c01807aa>] ? ifind+0x8a/0x90
 [<c012191b>] ? printk+0x1b/0x20
 [<c01aa7e0>] sysfs_add_one+0x80/0xa0
 [<c01aad19>] create_dir+0x49/0x90
 [<c01aad8b>] sysfs_create_dir+0x2b/0x50
 [<c01ea3ce>] kobject_add_internal+0xae/0x190
 [<c01ea52d>] ? kobject_set_name_vargs+0x2d/0x40
 [<c01ea52d>] ? kobject_set_name_vargs+0x2d/0x40
 [<c01ea58f>] kobject_add_varg+0x4f/0x60
 [<c01ea87f>] kobject_add+0x2f/0x60
 [<c0250d1c>] device_add+0x8c/0x420
 [<c02510c2>] device_register+0x12/0x20
 [<c01f3df8>] pci_bus_add_devices+0x98/0x140
 [<c030abc7>] ? pcibios_scan_root+0x27/0xa0
 [<c03f69e0>] pci_legacy_init+0x50/0xf0
 [<c03db5c2>] kernel_init+0x132/0x310
 [<c010303a>] ? ret_from_fork+0x6/0x1c
 [<c03db490>] ? kernel_init+0x0/0x310
 [<c03db490>] ? kernel_init+0x0/0x310
 [<c0103d3f>] kernel_thread_helper+0x7/0x18
 =======================
---[ end trace ca143223eefdc828 ]---
kobject_add_internal failed for 0000:01 with -EEXIST, don't try to register things with the same name in the same directory.
Pid: 1, comm: swapper Not tainted 2.6.25-rc2-testpm-dirty #40
 [<c01ea459>] kobject_add_internal+0x139/0x190
 [<c01ea52d>] ? kobject_set_name_vargs+0x2d/0x40
 [<c01ea58f>] kobject_add_varg+0x4f/0x60
 [<c01ea87f>] kobject_add+0x2f/0x60
 [<c0250d1c>] device_add+0x8c/0x420
 [<c02510c2>] device_register+0x12/0x20
 [<c01f3df8>] pci_bus_add_devices+0x98/0x140
 [<c030abc7>] ? pcibios_scan_root+0x27/0xa0
 [<c03f69e0>] pci_legacy_init+0x50/0xf0
 [<c03db5c2>] kernel_init+0x132/0x310
 [<c010303a>] ? ret_from_fork+0x6/0x1c
 [<c03db490>] ? kernel_init+0x0/0x310
 [<c03db490>] ? kernel_init+0x0/0x310
 [<c0103d3f>] kernel_thread_helper+0x7/0x18
 =======================
pci 0000:00:01.0: Error registering pci_bus device bridge symlink, 
continuing...PCI: Using IRQ router PIIX/ICH [8086/7110] at 0000:00:14.0

BTW, it might help to know, that under 2.6.24(.2) I'm getting only the 
third one:

PCI: Probing PCI hardware
sysfs: duplicate filename 'bridge' can not be created
WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Pid: 1, comm: swapper Not tainted 2.6.24-noapm #4
 [<c0103fca>] show_trace_log_lvl+0x1a/0x30
 [<c0104a82>] show_trace+0x12/0x20
 [<c010530e>] dump_stack+0x6e/0x80
 [<c01ac2dd>] sysfs_add_one+0x9d/0xe0
 [<c01ad0fb>] sysfs_create_link+0x8b/0x130
 [<c01f3cf4>] pci_bus_add_devices+0x94/0x120
 [<c03e8dd0>] pci_legacy_init+0x50/0xf0
 [<c03cf5f2>] kernel_init+0x142/0x320
 [<c0103b93>] kernel_thread_helper+0x7/0x14
 =======================
pci 0000:00:01.0: Error creating sysfs bridge symlink, continuing...
PCI: Using IRQ router PIIX/ICH [8086/7110] at 0000:00:14.0

Thanks
Guennadi
---
Guennadi Liakhovetski
