Return-Path: <linux-kernel-owner+w=401wt.eu-S1755726AbYB0Lj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbYB0Lj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 06:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbYB0LjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 06:39:16 -0500
Received: from mail.gmx.net ([213.165.64.20]:57198 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752789AbYB0LjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 06:39:15 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18ZPmdS9AkZ1nac+cvfFXmV6H2Bn68W9+pOsIxMOb
	Rb95JZL5sKsLG4
Date: Wed, 27 Feb 2008 12:39:25 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Greg KH <greg@kroah.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PCI] duplicate sysfs symbols getting registered in current git
In-Reply-To: <20080226201619.GA10343@kroah.com>
Message-ID: <Pine.LNX.4.64.0802271237360.5059@axis700.grange>
References: <Pine.LNX.4.64.0802182142240.11540@axis700.grange>
 <20080220063834.GA22708@kroah.com> <Pine.LNX.4.64.0802251341160.4430@axis700.grange>
 <20080226201619.GA10343@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008, Greg KH wrote:

> We did just find a problem in the kobject core that might be causing
> this to happen, can you try the patch below to see if this causes it to
> go away as well?

No, didn't help, same 3 stack dumps, only offsets / addresses a bit 
different (CONFIG_SYSFS_DEPRECATED enabled):

kobject (c7c35900): tried to init an initialized object, something is 
seriously wrong.
Pid: 1, comm: swapper Not tainted 2.6.25-rc2-testpm-dirty #37
 [<c01ea0c5>] kobject_init+0x75/0x80
 [<c025072e>] device_initialize+0x1e/0x90
 [<c0250f7b>] device_register+0xb/0x20
 [<c01f3db8>] pci_bus_add_devices+0x98/0x140
 [<c030add7>] ? pcibios_scan_root+0x27/0xa0
 [<c03f69d0>] pci_legacy_init+0x50/0xf0
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
Pid: 1, comm: swapper Not tainted 2.6.25-rc2-testpm-dirty #37
 [<c01209f4>] warn_on_slowpath+0x54/0x70
 [<c01210bc>] ? __call_console_drivers+0x5c/0x70
 [<c0313e81>] ? _spin_unlock_irqrestore+0x11/0x30
 [<c0121379>] ? release_console_sem+0x1d9/0x1f0
 [<c01217fd>] ? vprintk+0x2ad/0x3b0
 [<c01e9749>] ? ida_get_new_above+0x89/0x180
 [<c01aa410>] ? sysfs_ilookup_test+0x0/0x20
 [<c0313ddf>] ? _spin_unlock+0xf/0x30
 [<c01807aa>] ? ifind+0x8a/0x90
 [<c012191b>] ? printk+0x1b/0x20
 [<c01aa7a0>] sysfs_add_one+0x80/0xa0
 [<c01aacd9>] create_dir+0x49/0x90
 [<c01aad4b>] sysfs_create_dir+0x2b/0x50
 [<c01ea38e>] kobject_add_internal+0xae/0x190
 [<c01ea4ed>] ? kobject_set_name_vargs+0x2d/0x40
 [<c01ea4ed>] ? kobject_set_name_vargs+0x2d/0x40
 [<c01ea54f>] kobject_add_varg+0x4f/0x60
 [<c01ea83f>] kobject_add+0x2f/0x60
 [<c01ea252>] ? kobject_get+0x12/0x20
 [<c0250b0c>] device_add+0x8c/0x4f0
 [<c01ea07a>] ? kobject_init+0x2a/0x80
 [<c0250f82>] device_register+0x12/0x20
 [<c01f3db8>] pci_bus_add_devices+0x98/0x140
 [<c030add7>] ? pcibios_scan_root+0x27/0xa0
 [<c03f69d0>] pci_legacy_init+0x50/0xf0
 [<c03db5c2>] kernel_init+0x132/0x310
 [<c010303a>] ? ret_from_fork+0x6/0x1c
 [<c03db490>] ? kernel_init+0x0/0x310
 [<c03db490>] ? kernel_init+0x0/0x310
 [<c0103d3f>] kernel_thread_helper+0x7/0x18
 =======================
---[ end trace ca143223eefdc828 ]---
kobject_add_internal failed for 0000:01 with -EEXIST, don't try to 
register things with the same name in the same directory.
Pid: 1, comm: swapper Not tainted 2.6.25-rc2-testpm-dirty #37
 [<c01ea419>] kobject_add_internal+0x139/0x190
 [<c01ea4ed>] ? kobject_set_name_vargs+0x2d/0x40
 [<c01ea54f>] kobject_add_varg+0x4f/0x60
 [<c01ea83f>] kobject_add+0x2f/0x60
 [<c01ea252>] ? kobject_get+0x12/0x20
 [<c0250b0c>] device_add+0x8c/0x4f0
 [<c01ea07a>] ? kobject_init+0x2a/0x80
 [<c0250f82>] device_register+0x12/0x20
 [<c01f3db8>] pci_bus_add_devices+0x98/0x140
 [<c030add7>] ? pcibios_scan_root+0x27/0xa0
 [<c03f69d0>] pci_legacy_init+0x50/0xf0
 [<c03db5c2>] kernel_init+0x132/0x310
 [<c010303a>] ? ret_from_fork+0x6/0x1c
 [<c03db490>] ? kernel_init+0x0/0x310
 [<c03db490>] ? kernel_init+0x0/0x310
 [<c0103d3f>] kernel_thread_helper+0x7/0x18
 =======================

Thanks
Guennadi
---
Guennadi Liakhovetski
