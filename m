Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbZANSm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbZANSm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 13:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbZANSml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 13:42:41 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:37092 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067AbZANSmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 13:42:37 -0500
X-IronPort-AV: E=Sophos;i="4.37,263,1231113600"; 
   d="scan'208";a="229842603"
From: Roland Dreier <rdreier@cisco.com>
To: linux-kernel@vger.kernel.org
Subject: CPA warning when running dmidecode on 2.6.29-rc1
X-Message-Flag: Warning: May contain useful information
Date: Wed, 14 Jan 2009 10:42:36 -0800
Message-ID: <adaab9tivab.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Jan 2009 18:42:37.0087 (UTC) FILETIME=[DEF9D2F0:01C97677]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just got the following when trying to dmidecode on a system running
2.6.29-rc1-git... STRICT_DEVMEM isn't set.  Let me know if any further
info would be helpful...

[72673.717016] ------------[ cut here ]------------
[72673.721697] WARNING: at /scratch/Ksrc/linux-git/arch/x86/mm/pageattr.c:560 __change_page_attr_set_clr+0xe2/0x867()
[72673.732061] Hardware name: PowerEdge SC1435
[72673.736260] CPA: called for zero pte. vaddr = ffff8800dffbc000 cpa->vaddr = ffff8800dffbc000
[72673.744710] Modules linked in: tun nfs lockd nfs_acl auth_rpcgss sunrpc ipv6 bridge stp llc dm_snapshot dm_mirror dm_region_hash dm_log dm_mod kvm_amd kvm loop evdev ib_mthca thermal serio_raw psmouse pcspkr ib_mad ib_core ohci_hcd ehci_hcd tg3 libphy processor dcdbas
[72673.769213] Pid: 2622, comm: dmidecode Not tainted 2.6.29-rc1 #38
[72673.775329] Call Trace:
[72673.777802]  [<ffffffff80233cc5>] warn_slowpath+0xd8/0x112
[72673.783310]  [<ffffffff8026f178>] __alloc_pages_internal+0xd2/0x40e
[72673.789596]  [<ffffffff80310f15>] do_get_write_access+0x3c6/0x408
[72673.795705]  [<ffffffff80278b18>] zone_statistics+0x3c/0x5f
[72673.801292]  [<ffffffff80222e64>] __change_page_attr_set_clr+0xe2/0x867
[72673.807916]  [<ffffffff802855ae>] __purge_vmap_area_lazy+0x146/0x155
[72673.814274]  [<ffffffff802869b7>] vm_unmap_aliases+0x16f/0x180
[72673.820107]  [<ffffffff80223734>] change_page_attr_set_clr+0x14b/0x2fa
[72673.826643]  [<ffffffff802239eb>] _set_memory_wb+0x1d/0x20
[72673.832136]  [<ffffffff80224c71>] reserve_pfn_range+0x1a2/0x233
[72673.838066]  [<ffffffff8027d966>] remap_pfn_range+0x8f/0x342
[72673.843732]  [<ffffffff80224795>] reserve_memtype+0x193/0x4cd
[72673.849480]  [<ffffffff8022509e>] phys_mem_access_prot_allowed+0xb4/0x1aa
[72673.856275]  [<ffffffff803c79d8>] mmap_mem+0x6c/0x91
[72673.861249]  [<ffffffff8028205c>] mmap_region+0x2e0/0x57d
[72673.866657]  [<ffffffff80282585>] do_mmap_pgoff+0x28c/0x2f3
[72673.872240]  [<ffffffff8020fa7f>] sys_mmap+0x8c/0xc5
[72673.877212]  [<ffffffff8020bedb>] system_call_fastpath+0x16/0x1b
[72673.883227] ---[ end trace 592fdf59445922ef ]---
[72673.887864] dmidecode:2622 reserve_pfn_range ioremap_change_attr failed write-back for dffbc000-dffbd000
[72673.897346] dmidecode:2622 freeing invalid memtype dffbc000-dffbd000
