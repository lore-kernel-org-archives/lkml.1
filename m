Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbZA0LIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbZA0LIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 06:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbZA0LId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 06:08:33 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:45370 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbZA0LIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 06:08:32 -0500
Date: Tue, 27 Jan 2009 16:38:23 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [mmotm] Backtrace __change_page_attr_set_clr
Message-ID: <20090127110823.GO504@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew,

I see the following backtrace with 2009-01-16-16-18

------------[ cut here ]------------
WARNING: at arch/x86/mm/pageattr.c:560
__change_page_attr_set_clr+0xdc/0x891()
...
CPA: called for zero pte. vaddr = ffff8800cfee2000 cpa->vaddr =
ffff8800cfee2000
Modules linked in: coretemp hwmon kvm_intel kvm rtc_cmos rtc_core
rtc_lib mptsas mptscsih mptbase scsi_transport_sas
Pid: 3486, comm: dmidecode Not tainted 2.6.29-rc1 #2
Call Trace:
 [<ffffffff8023e9da>] warn_slowpath+0xd8/0xf5
 [<ffffffff8024f00b>] __kernel_text_address+0x1a/0x26
 [<ffffffff8020f307>] print_context_stack+0x90/0xa6
 [<ffffffff8025cc63>] find_usage_backwards+0xe/0xfc
 [<ffffffff8025f500>] __lock_acquire+0x763/0x7ce
 [<ffffffff80227237>] __change_page_attr_set_clr+0x5b/0x891
 [<ffffffff80227237>] __change_page_attr_set_clr+0x5b/0x891
 [<ffffffff802272b8>] __change_page_attr_set_clr+0xdc/0x891
 [<ffffffff802a2a5c>] __purge_vmap_area_lazy+0x195/0x1a2
 [<ffffffff802a2912>] __purge_vmap_area_lazy+0x4b/0x1a2
 [<ffffffff802a3b49>] vm_unmap_aliases+0x1b9/0x1c8
 [<ffffffff802a39cd>] vm_unmap_aliases+0x3d/0x1c8
 [<ffffffff80227bac>] change_page_attr_set_clr+0x13f/0x2f1
 [<ffffffff80597355>] _spin_unlock+0x17/0x20
 [<ffffffff80227e56>] _set_memory_wb+0x1d/0x20
 [<ffffffff80229189>] reserve_pfn_range+0x1a1/0x23a
 [<ffffffff8029ab59>] remap_pfn_range+0x90/0x33a
 [<ffffffff802294a2>] phys_mem_access_prot_allowed+0x98/0x1b9
 [<ffffffff802b0e3f>] kmem_cache_alloc+0x94/0xbc
 [<ffffffff803d8d48>] mmap_mem+0x6c/0x91
 [<ffffffff8029ee18>] mmap_region+0x262/0x4a9
 [<ffffffff8029f5c4>] do_mmap_pgoff+0x2a6/0x30d
 [<ffffffff8020fa95>] sys_mmap+0x8b/0x110
 [<ffffffff8020bedb>] system_call_fastpath+0x16/0x1b
---[ end trace 21993f860dedca28 ]---
dmidecode:3486 reserve_pfn_range ioremap_change_attr failed write-back
for cfee2000-cfee3000
dmidecode:3486 freeing invalid memtype cfee2000-cfee3000

I am yet to fully investigate the problem, but did not want to hold of
reporting it.

-- 
	Balbir
