Return-Path: <linux-kernel-owner+w=401wt.eu-S1759108AbYH2TLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759108AbYH2TLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 15:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755751AbYH2TLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 15:11:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41211 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593AbYH2TLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 15:11:41 -0400
Date: Fri, 29 Aug 2008 21:11:37 +0200
From: Andi Kleen <andi@firstfloor.org>
To: kkeil@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: mISDN unload kobject warnings
Message-ID: <20080829191137.GA28057@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While unloading the modules in 2.6.27rc4:

CAPI Subsystem Rev 1.1.2.8
mISDN: HFC-multi driver 2.02
mISDN: Layer-1-over-IP driver Rev. 2.00
0 virtual devices registered
DSP modul 2.0
mISDN_dsp: DSP clocks every 64 samples. This equals 2 jiffies.
mISDN_dsp_element_register: hwec registered
------------[ cut here ]------------
WARNING: at drivers/base/core.c:122 kobject_release+0x48/0x5e()
Device 'hwec' does not have a release() function, it is broken and must be fixed.
Modules linked in: scsi_wait_scan s2io mISDN_dsp(-) mISDN_core [last unloaded: l1oip]
Pid: 3960, comm: rmmod Tainted: G        W 2.6.27-rc4 #18

Call Trace:
 [<ffffffff80233060>] warn_slowpath+0xb4/0xdc
 [<ffffffff805a2d36>] schedule_timeout+0x1e/0xad
 [<ffffffff80244863>] autoremove_wake_function+0x9/0x2e
 [<ffffffff802290d0>] __wake_up_common+0x46/0x76
 [<ffffffff8022858b>] need_resched+0x1e/0x28
 [<ffffffff802c939a>] release_sysfs_dirent+0x65/0x7e
 [<ffffffff802c9601>] remove_dir+0x29/0x31
 [<ffffffff802c9677>] sysfs_remove_dir+0x6c/0x75
 [<ffffffff80363aa4>] kobject_release+0x48/0x5e
 [<ffffffff80363a5c>] kobject_release+0x0/0x5e
 [<ffffffff80364785>] kref_put+0x41/0x4c
 [<ffffffffa004b97f>] mISDN_dsp_element_unregister+0x62/0xc0 [mISDN_dsp]
 [<ffffffffa004b838>] dsp_pipeline_module_exit+0xb/0xb5 [mISDN_dsp]
 [<ffffffff80252f34>] sys_delete_module+0x1f6/0x259
 [<ffffffff80270070>] free_pgd_range+0x32a/0x406
 [<ffffffff80366811>] __up_write+0x12/0x45
 [<ffffffff8020b62b>] system_call_fastpath+0x16/0x1b

---[ end trace 4fd4257964474cca ]---
mISDN_dsp_element_unregister: hwec unregistered
dsp_pipeline_module_exit: dsp pipeline module exited


-Andi

-- 
ak@linux.intel.com
