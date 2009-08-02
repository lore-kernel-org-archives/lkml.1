Return-Path: <linux-kernel-owner+w=401wt.eu-S1752337AbZHBIV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbZHBIV4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 04:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbZHBIVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 04:21:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:3137 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbZHBIVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 04:21:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=OtjNrGnooIi6djdBFnlWcdrDlWIU+zh4Y9XrSyRpmHn/ZrTjfi/8m3g0qlPEOpbqUS
         IuLoFTlDO5rcle9hab+Abs9OKaocuGc64U9Poz1/Em4k+Jsi8xSC+EEJmySnBB9kTnHP
         zxWqhDRTi5/7aKD0kf1JC8MM5oDWPDPZV8fS4=
Date: Sun, 2 Aug 2009 16:21:48 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: kmemleak reporting
Message-ID: <20090802082148.GA14673@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With kmemleak I got following leaking info. 2.6.31-rc5 with Johannes Weiner's patch applied for the vc_resize leaking issue. 

[patch] fbcon: don't use vc_resize() on initialization 

unreferenced object 0xf71aa0c0 (size 64):
  comm "swapper", pid 1, jiffies 4294877648
  backtrace:
    [<c1097f31>] create_object+0x140/0x210
    [<c1098026>] kmemleak_alloc+0x25/0x49
    [<c10935e0>] kmemleak_alloc_recursive+0x11/0x14
    [<c1094323>] __kmalloc+0x15d/0x183
    [<c11593d1>] kzalloc+0xb/0xd
    [<c11599c9>] acpi_add_single_object+0x58b/0xddb
    [<c115a3ed>] acpi_bus_scan+0xff/0x170
    [<c157c92f>] acpi_scan_init+0xb7/0xdc
    [<c157c7f8>] acpi_init+0x218/0x25e
    [<c1001137>] do_one_initcall+0x4a/0x11a
    [<c155f530>] kernel_init+0x124/0x175
    [<c1003dc7>] kernel_thread_helper+0x7/0x10
    [<ffffffff>] 0xffffffff
unreferenced object 0xf71aa280 (size 64):
  comm "swapper", pid 1, jiffies 4294877650
  backtrace:
    [<c1097f31>] create_object+0x140/0x210
    [<c1098026>] kmemleak_alloc+0x25/0x49
    [<c10935e0>] kmemleak_alloc_recursive+0x11/0x14
    [<c1094323>] __kmalloc+0x15d/0x183
    [<c11593d1>] kzalloc+0xb/0xd
    [<c11599c9>] acpi_add_single_object+0x58b/0xddb
    [<c115a3ed>] acpi_bus_scan+0xff/0x170
    [<c157c92f>] acpi_scan_init+0xb7/0xdc
    [<c157c7f8>] acpi_init+0x218/0x25e
    [<c1001137>] do_one_initcall+0x4a/0x11a
    [<c155f530>] kernel_init+0x124/0x175
    [<c1003dc7>] kernel_thread_helper+0x7/0x10
    [<ffffffff>] 0xffffffff
unreferenced object 0xf71aaec0 (size 64):
  comm "swapper", pid 1, jiffies 4294877652
  backtrace:
    [<c1097f31>] create_object+0x140/0x210
    [<c1098026>] kmemleak_alloc+0x25/0x49
    [<c10935e0>] kmemleak_alloc_recursive+0x11/0x14
    [<c1094323>] __kmalloc+0x15d/0x183
    [<c11593d1>] kzalloc+0xb/0xd
    [<c11599c9>] acpi_add_single_object+0x58b/0xddb
    [<c115a3ed>] acpi_bus_scan+0xff/0x170
    [<c157c92f>] acpi_scan_init+0xb7/0xdc
    [<c157c7f8>] acpi_init+0x218/0x25e
    [<c1001137>] do_one_initcall+0x4a/0x11a
    [<c155f530>] kernel_init+0x124/0x175
    [<c1003dc7>] kernel_thread_helper+0x7/0x10
    [<ffffffff>] 0xffffffff
unreferenced object 0xf6639100 (size 64):
  comm "swapper", pid 1, jiffies 4294878947
  backtrace:
    [<c1097f31>] create_object+0x140/0x210
    [<c1098026>] kmemleak_alloc+0x25/0x49
    [<c10935e0>] kmemleak_alloc_recursive+0x11/0x14
    [<c1094323>] __kmalloc+0x15d/0x183
    [<c100fff6>] acpi_cpufreq_cpu_init+0x211/0x54b
    [<c1288664>] cpufreq_add_dev+0x1b9/0x648
    [<c11d6566>] sysdev_driver_register+0x96/0xe5
    [<c1288d15>] cpufreq_register_driver+0xa1/0x168
    [<c1567e20>] acpi_cpufreq_init+0xad/0xbf
    [<c1001137>] do_one_initcall+0x4a/0x11a
    [<c155f530>] kernel_init+0x124/0x175
    [<c1003dc7>] kernel_thread_helper+0x7/0x10
    [<ffffffff>] 0xffffffff
unreferenced object 0xf45eb280 (size 64):
  comm "pm-suspend", pid 2038, jiffies 372178
  backtrace:
    [<c1097f31>] create_object+0x140/0x210
    [<c1098026>] kmemleak_alloc+0x25/0x49
    [<c10935e0>] kmemleak_alloc_recursive+0x11/0x14
    [<c1094323>] __kmalloc+0x15d/0x183
    [<c100fff6>] acpi_cpufreq_cpu_init+0x211/0x54b
    [<c1288664>] cpufreq_add_dev+0x1b9/0x648
    [<c13389dc>] cpufreq_cpu_callback+0x5b/0x65
    [<c133c6a4>] notifier_call_chain+0x2b/0x4a
    [<c103ecd1>] __raw_notifier_call_chain+0xe/0x10
    [<c103ecdf>] raw_notifier_call_chain+0xc/0xe
    [<c133713a>] _cpu_up+0xbe/0xf3
    [<c13238be>] enable_nonboot_cpus+0x37/0x83
    [<c1052aa4>] suspend_devices_and_enter+0x122/0x17f
    [<c1052bde>] enter_state+0xdd/0x11e
    [<c10523f0>] state_store+0x96/0xac
    [<c112c014>] kobj_attr_store+0x1a/0x22
unreferenced object 0xc02ee448 (size 8):
  comm "pm-suspend", pid 2038, jiffies 372178
  backtrace:
    [<c1097f31>] create_object+0x140/0x210
    [<c1098026>] kmemleak_alloc+0x25/0x49
    [<c10935e0>] kmemleak_alloc_recursive+0x11/0x14
    [<c1094efd>] __kmalloc_track_caller+0x15b/0x181
    [<c107f629>] kstrdup+0x2a/0x4c
    [<c10d9044>] sysfs_new_dirent+0x28/0xd8
    [<c10d941d>] create_dir+0x24/0x68
    [<c10d948e>] sysfs_create_dir+0x2d/0x41
    [<c112c332>] kobject_add_internal+0xb3/0x157
    [<c112c48f>] kobject_add_varg+0x35/0x41
    [<c112c4c1>] kobject_init_and_add+0x26/0x28
    [<c1288836>] cpufreq_add_dev+0x38b/0x648
    [<c13389dc>] cpufreq_cpu_callback+0x5b/0x65
    [<c133c6a4>] notifier_call_chain+0x2b/0x4a
    [<c103ecd1>] __raw_notifier_call_chain+0xe/0x10
    [<c103ecdf>] raw_notifier_call_chain+0xc/0xe
unreferenced object 0xe5b06900 (size 48):
  comm "pm-suspend", pid 2038, jiffies 372178
  backtrace:
    [<c1097f31>] create_object+0x140/0x210
    [<c1098026>] kmemleak_alloc+0x25/0x49
    [<c10935e0>] kmemleak_alloc_recursive+0x11/0x14
    [<c1094008>] kmem_cache_alloc+0xed/0x13a
    [<c10d9062>] sysfs_new_dirent+0x46/0xd8
    [<c10d941d>] create_dir+0x24/0x68
    [<c10d948e>] sysfs_create_dir+0x2d/0x41
    [<c112c332>] kobject_add_internal+0xb3/0x157
    [<c112c48f>] kobject_add_varg+0x35/0x41
    [<c112c4c1>] kobject_init_and_add+0x26/0x28
    [<c1288836>] cpufreq_add_dev+0x38b/0x648
    [<c13389dc>] cpufreq_cpu_callback+0x5b/0x65
    [<c133c6a4>] notifier_call_chain+0x2b/0x4a
    [<c103ecd1>] __raw_notifier_call_chain+0xe/0x10
    [<c103ecdf>] raw_notifier_call_chain+0xc/0xe
    [<c133713a>] _cpu_up+0xbe/0xf3
unreferenced object 0xc02ee450 (size 8):
  comm "pm-suspend", pid 2038, jiffies 372178
  backtrace:
    [<c1097f31>] create_object+0x140/0x210
    [<c1098026>] kmemleak_alloc+0x25/0x49
    [<c10935e0>] kmemleak_alloc_recursive+0x11/0x14
    [<c1094efd>] __kmalloc_track_caller+0x15b/0x181
    [<c107f629>] kstrdup+0x2a/0x4c
    [<c10d9044>] sysfs_new_dirent+0x28/0xd8
    [<c10d941d>] create_dir+0x24/0x68
    [<c10d94b3>] sysfs_create_subdir+0x11/0x16
    [<c10da536>] internal_create_group+0x3a/0x11a
    [<c10da633>] sysfs_create_group+0xc/0x11
    [<c12894de>] cpufreq_stat_notifier_policy+0x8f/0x195
    [<c133c6a4>] notifier_call_chain+0x2b/0x4a
    [<c103ee33>] __blocking_notifier_call_chain+0x37/0x4c
    [<c103ee54>] blocking_notifier_call_chain+0xc/0xe
    [<c12879d3>] __cpufreq_set_policy+0xb1/0x1c3
    [<c12889d1>] cpufreq_add_dev+0x526/0x648
unreferenced object 0xe5b06bd0 (size 48):
  comm "pm-suspend", pid 2038, jiffies 372178
  backtrace:
    [<c1097f31>] create_object+0x140/0x210
    [<c1098026>] kmemleak_alloc+0x25/0x49
    [<c10935e0>] kmemleak_alloc_recursive+0x11/0x14
    [<c1094008>] kmem_cache_alloc+0xed/0x13a
    [<c10d9062>] sysfs_new_dirent+0x46/0xd8
    [<c10d941d>] create_dir+0x24/0x68
    [<c10d94b3>] sysfs_create_subdir+0x11/0x16
    [<c10da536>] internal_create_group+0x3a/0x11a
    [<c10da633>] sysfs_create_group+0xc/0x11
    [<c12894de>] cpufreq_stat_notifier_policy+0x8f/0x195
    [<c133c6a4>] notifier_call_chain+0x2b/0x4a
    [<c103ee33>] __blocking_notifier_call_chain+0x37/0x4c
    [<c103ee54>] blocking_notifier_call_chain+0xc/0xe
    [<c12879d3>] __cpufreq_set_policy+0xb1/0x1c3
    [<c12889d1>] cpufreq_add_dev+0x526/0x648
    [<c13389dc>] cpufreq_cpu_callback+0x5b/0x65
unreferenced object 0xe5b06c00 (size 48):
  comm "pm-suspend", pid 2038, jiffies 372178
  backtrace:
    [<c1097f31>] create_object+0x140/0x210
    [<c1098026>] kmemleak_alloc+0x25/0x49
    [<c10935e0>] kmemleak_alloc_recursive+0x11/0x14
    [<c1094008>] kmem_cache_alloc+0xed/0x13a
    [<c10d9062>] sysfs_new_dirent+0x46/0xd8
    [<c10d8883>] sysfs_add_file_mode+0x2a/0x67
    [<c10da5b4>] internal_create_group+0xb8/0x11a
    [<c10da633>] sysfs_create_group+0xc/0x11
    [<c12894de>] cpufreq_stat_notifier_policy+0x8f/0x195
    [<c133c6a4>] notifier_call_chain+0x2b/0x4a
    [<c103ee33>] __blocking_notifier_call_chain+0x37/0x4c
    [<c103ee54>] blocking_notifier_call_chain+0xc/0xe
    [<c12879d3>] __cpufreq_set_policy+0xb1/0x1c3
    [<c12889d1>] cpufreq_add_dev+0x526/0x648
    [<c13389dc>] cpufreq_cpu_callback+0x5b/0x65
    [<c133c6a4>] notifier_call_chain+0x2b/0x4a
unreferenced object 0xe5b06c30 (size 48):
  comm "pm-suspend", pid 2038, jiffies 372178
  backtrace:
    [<c1097f31>] create_object+0x140/0x210
    [<c1098026>] kmemleak_alloc+0x25/0x49
    [<c10935e0>] kmemleak_alloc_recursive+0x11/0x14
    [<c1094008>] kmem_cache_alloc+0xed/0x13a
    [<c10d9062>] sysfs_new_dirent+0x46/0xd8
    [<c10d8883>] sysfs_add_file_mode+0x2a/0x67
    [<c10da5b4>] internal_create_group+0xb8/0x11a
    [<c10da633>] sysfs_create_group+0xc/0x11
    [<c12894de>] cpufreq_stat_notifier_policy+0x8f/0x195
    [<c133c6a4>] notifier_call_chain+0x2b/0x4a
    [<c103ee33>] __blocking_notifier_call_chain+0x37/0x4c
    [<c103ee54>] blocking_notifier_call_chain+0xc/0xe
    [<c12879d3>] __cpufreq_set_policy+0xb1/0x1c3
    [<c12889d1>] cpufreq_add_dev+0x526/0x648
    [<c13389dc>] cpufreq_cpu_callback+0x5b/0x65
    [<c133c6a4>] notifier_call_chain+0x2b/0x4a
unreferenced object 0xe5b06c60 (size 48):
  comm "pm-suspend", pid 2038, jiffies 372178
  backtrace:
    [<c1097f31>] create_object+0x140/0x210
    [<c1098026>] kmemleak_alloc+0x25/0x49
    [<c10935e0>] kmemleak_alloc_recursive+0x11/0x14
    [<c1094008>] kmem_cache_alloc+0xed/0x13a
    [<c10d9062>] sysfs_new_dirent+0x46/0xd8
    [<c10d8883>] sysfs_add_file_mode+0x2a/0x67
    [<c10da5b4>] internal_create_group+0xb8/0x11a
    [<c10da633>] sysfs_create_group+0xc/0x11
    [<c12894de>] cpufreq_stat_notifier_policy+0x8f/0x195
    [<c133c6a4>] notifier_call_chain+0x2b/0x4a
    [<c103ee33>] __blocking_notifier_call_chain+0x37/0x4c
    [<c103ee54>] blocking_notifier_call_chain+0xc/0xe
    [<c12879d3>] __cpufreq_set_policy+0xb1/0x1c3
    [<c12889d1>] cpufreq_add_dev+0x526/0x648
    [<c13389dc>] cpufreq_cpu_callback+0x5b/0x65
    [<c133c6a4>] notifier_call_chain+0x2b/0x4a

--
Regards
dave
