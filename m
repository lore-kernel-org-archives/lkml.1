Return-Path: <linux-kernel-owner+w=401wt.eu-S1758270AbZDICTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbZDICTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 22:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbZDICTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 22:19:14 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:53201 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbZDICTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 22:19:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=xvsytym9pcijNH/oWskuGyGrvBdpiiFgD0KopuDoHKvmsi/gn0/z6zabLE+bGpbrKf
         nhkXJYh+yybkvlex0M6Zysa9KPz4nfostlu1jCeZlm1kZLINqCmXTDFxX56jriear/i6
         JwZEIw6+vzAMXbvLAU70dDhoefSRPpDx0CIKA=
MIME-Version: 1.0
Date: Wed, 8 Apr 2009 19:19:11 -0700
Message-ID: <dd18b0c30904081919h7cc8333aw8e2693969a0998bf@mail.gmail.com>
Subject: BUG kmalloc-2048: Invalid object pointer 0xf656ad80
From: Justin Mattock <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

doing a:
sudo /sbin/rmmod wl
(generated a bug message)

[10018.950114] =============================================================================
[10018.950118] BUG kmalloc-2048: Invalid object pointer 0xf656ad80
[10018.950120] -----------------------------------------------------------------------------
[10018.950121]
[10018.950124] INFO: Slab 0xc16cad00 objects=15 used=14 fp=0xf656a8f0
flags=0x40002083
[10018.950128] Pid: 20025, comm: rmmod Tainted: P           2.6.29 #10
[10018.950131] Call Trace:
[10018.950139]  [<c017db89>] slab_err+0x51/0x58
[10018.950143]  [<c017e812>] ? __slab_free+0x26f/0x2a7
[10018.950147]  [<c017dbaf>] ? slab_pad_check+0x1f/0xbd
[10018.950152]  [<c017e83d>] __slab_free+0x29a/0x2a7
[10018.950186]  [<f93f8a93>] ? osl_mfree+0x11/0x13 [wl]
[10018.950190]  [<c017f59e>] kfree+0x93/0xa9
[10018.950220]  [<f93f8a93>] ? osl_mfree+0x11/0x13 [wl]
[10018.950249]  [<f93f8a93>] osl_mfree+0x11/0x13 [wl]
[10018.950279]  [<f93f5cca>] wl_free_if+0x65/0x77 [wl]
[10018.950309]  [<f93f5d0f>] wl_free+0x33/0x17f [wl]
[10018.950313]  [<c017f701>] ? kmem_cache_free+0x71/0x87
[10018.950318]  [<c01b9006>] ? release_sysfs_dirent+0x6c/0x81
[10018.950322]  [<c01b9006>] ? release_sysfs_dirent+0x6c/0x81
[10018.950326]  [<c01b9200>] ? sysfs_addrm_finish+0x1bf/0x1d2
[10018.950331]  [<c022faac>] ? _raw_spin_lock+0x53/0xfb
[10018.950337]  [<c03cc23f>] ? _spin_lock_bh+0x16/0x18
[10018.950341]  [<c022fa55>] ? _raw_spin_unlock+0x74/0x78
[10018.950370]  [<f93f8ca9>] wl_remove+0x42/0x58 [wl]
[10018.950376]  [<c023a208>] pci_device_remove+0x19/0x39
[10018.950381]  [<c029b427>] __device_release_driver+0x50/0x6d
[10018.950386]  [<c029b4b4>] driver_detach+0x70/0x94
[10018.950390]  [<c029aa26>] bus_remove_driver+0x63/0x7f
[10018.950394]  [<c029b847>] driver_unregister+0x28/0x2c
[10018.950399]  [<c023a3fe>] pci_unregister_driver+0x21/0x62
[10018.950427]  [<f93f8c65>] wl_module_exit+0xd/0xf [wl]
[10018.950433]  [<c01469eb>] sys_delete_module+0x18e/0x1e7
[10018.950438]  [<c017219d>] ? remove_vma+0x41/0x47
[10018.950442]  [<c0172d24>] ? do_munmap+0x1f1/0x20b
[10018.950446]  [<c015397e>] ? audit_syscall_entry+0x15e/0x180
[10018.950453]  [<c010301b>] sysenter_do_call+0x12/0x2f
[10018.950458]  [<c03c0000>] ? workqueue_cpu_callback+0xc0/0xd6
[10018.950461] FIX kmalloc-2048: Object at 0xf656ad80 not freed
[10018.950745] wl 0000:03:00.0: PCI INT A disabled


The kernel is tainted with nvidia, and a broadcom wl.

-- 
Justin P. Mattock
