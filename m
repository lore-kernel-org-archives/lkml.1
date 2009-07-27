Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbZG0Sru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbZG0Sru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 14:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbZG0Sru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 14:47:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:34979 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbZG0Srt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 14:47:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,277,1246863600"; 
   d="scan'208";a="536345642"
Subject: Re: [PATCH] x86: don't use current_cpu_data in x2apic phys_pkg_id
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4A6ADD0D.10002@kernel.org>
References: <4A6ADD0D.10002@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 27 Jul 2009 11:44:06 -0700
Message-Id: <1248720246.27006.10764.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-25 at 03:23 -0700, Yinghai Lu wrote:
> one system that socket 1 come up as BSP. kexeced kernel report BSP as:
> [    1.524550] Initializing cgroup subsys cpuacct
> [    1.536064] initial_apicid:20
> [    1.537135] ht_mask_width:1
> [    1.538128] core_select_mask:f
> [    1.539126] core_plus_mask_width:5
> [    1.558479] CPU: Physical Processor ID: 0
> [    1.559501] CPU: Processor Core ID: 0
> [    1.560539] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    1.579098] CPU: L2 cache: 256K
> [    1.580085] CPU: L3 cache: 24576K
> [    1.581108] CPU 0/0x20 -> Node 0
> [    1.596193] CPU 0 microcode level: 0xffff0008
> 
> it doesn't have correct physical processor id. and will get error
> [   38.840859] CPU0 attaching sched-domain:
> [   38.848287]  domain 0: span 0,8,72 level SIBLING
> [   38.851151]   groups: 0 8 72
> [   38.858137]   domain 1: span 0,8-15,72-79 level MC
> [   38.868944]    groups: 0,8,72 9,73 10,74 11,75 12,76 13,77 14,78 15,79
> [   38.881383] ERROR: parent span is not a superset of domain->span
> [   38.890724]    domain 2: span 0-7,64-71 level CPU
> [   38.899237] ERROR: domain->groups does not contain CPU0
> [   38.909229]     groups: 8-15,72-79
> [   38.912547] ERROR: groups don't span domain->span
> [   38.919665]     domain 3: span 0-127 level NODE
> [   38.930739]      groups: 0-7,64-71 8-15,72-79 16-23,80-87 24-31,88-95 32-39,96-103 40-47,104-111 48-55,112-119 56-63,120-127
> 
> it turns out:
> we can not use current_cpu_data in phys_pgd_id for x2apic.
> 
> identify_boot_cpu is called by check_bugs before smp_prepare_cpus.
> and till smp_prepare_cpus current_cpu_data for bsp is assigned with
> boot_cpu_data
> 
> just make phys_pkg_id for x2apic is aligned to xapic
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

