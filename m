Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbYIEIlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbYIEIlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 04:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbYIEIlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 04:41:06 -0400
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2754 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbYIEIlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 04:41:04 -0400
Message-ID: <48C0F09C.1000101@xs4all.nl>
Date: Fri, 05 Sep 2008 10:41:00 +0200
From: Rambaldi <rambaldi@xs4all.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080815)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.27-rc5 xen balloon driver warnings
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when running the 2.6.27-rc5 kernel as 64 bits dumU I get the following warnings:


xen_balloon: Initialising balloon driver.
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x33/0x39()
sysfs: duplicate filename 'memory' can not be created
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.27-rc5 #2

Call Trace:
  [<ffffffff80231c9c>] warn_slowpath+0xb4/0xdd
  [<ffffffff803311f8>] write_console+0xda/0x119
  [<ffffffff8020baf6>] xen_mc_flush+0x11c/0x15b
  [<ffffffff8032c0d8>] notify_update+0x2b/0x30
  [<ffffffff80330579>] vt_console_print+0x27b/0x288
  [<ffffffff802f0b6e>] idr_get_empty_slot+0x164/0x243
  [<ffffffff80274ad0>] __kmalloc+0x99/0xc6
  [<ffffffff8027456b>] kmem_cache_alloc+0x65/0x92
  [<ffffffff802b7a30>] sysfs_ilookup_test+0x0/0xf
  [<ffffffff802b7c2c>] sysfs_find_dirent+0x1b/0x2f
  [<ffffffff802b7ce2>] sysfs_add_one+0x33/0x39
  [<ffffffff802b8219>] create_dir+0x4f/0x87
  [<ffffffff802b8286>] sysfs_create_dir+0x35/0x4c
  [<ffffffff802f1959>] kobject_add_internal+0xd3/0x18e
  [<ffffffff8055dbb9>] balloon_init+0x0/0x1bd
  [<ffffffff802f1a38>] kset_register+0x24/0x3a
  [<ffffffff8055dc69>] balloon_init+0xb0/0x1bd
  [<ffffffff8020a042>] do_one_initcall+0x42/0x141
  [<ffffffff802b1b04>] create_proc_entry+0x73/0x8a
  [<ffffffff80254260>] register_irq_proc+0xa7/0xbf
  [<ffffffff805488d0>] kernel_init+0x116/0x16b
  [<ffffffff8020fd3b>] int_ret_from_sys_call+0x13/0x33
  [<ffffffff80210ef9>] child_rip+0xa/0x11
  [<ffffffff80210208>] retint_restore_args+0x5/0x20
  [<ffffffff8030caa0>] dummycon_dummy+0x0/0x3
  [<ffffffff8030caa0>] dummycon_dummy+0x0/0x3
  [<ffffffff80210eef>] child_rip+0x0/0x11

---[ end trace 4eaa2a86a8e2da22 ]---
kobject_add_internal failed for memory with -EEXIST, don't try to register things with the same name in the same directory.
Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc5 #2

Call Trace:
  [<ffffffff802f19d5>] kobject_add_internal+0x14f/0x18e
  [<ffffffff8055dbb9>] balloon_init+0x0/0x1bd
  [<ffffffff802f1a38>] kset_register+0x24/0x3a
  [<ffffffff8055dc69>] balloon_init+0xb0/0x1bd
  [<ffffffff8020a042>] do_one_initcall+0x42/0x141
  [<ffffffff802b1b04>] create_proc_entry+0x73/0x8a
  [<ffffffff80254260>] register_irq_proc+0xa7/0xbf
  [<ffffffff805488d0>] kernel_init+0x116/0x16b
  [<ffffffff8020fd3b>] int_ret_from_sys_call+0x13/0x33
  [<ffffffff80210ef9>] child_rip+0xa/0x11
  [<ffffffff80210208>] retint_restore_args+0x5/0x20
  [<ffffffff8030caa0>] dummycon_dummy+0x0/0x3
  [<ffffffff8030caa0>] dummycon_dummy+0x0/0x3
  [<ffffffff80210eef>] child_rip+0x0/0x11

SCSI subsystem initialized

