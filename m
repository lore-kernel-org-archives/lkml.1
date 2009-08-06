Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbZHFHwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbZHFHwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 03:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbZHFHv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 03:51:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43438 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbZHFHv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 03:51:59 -0400
Date: Thu, 6 Aug 2009 17:51:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Li Zefan <lizf@cn.fujitsu.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: linux-next: manual merge of the edac-amd tree with the rr tree
Message-Id: <20090806175152.1e0b96cf.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

Today's linux-next merge of the edac-amd tree got a conflict in
arch/x86/kernel/smpboot.c between commit
d39044d21e1a2d3713f1329ad22d23df5d20140b ("cpumask: use zalloc_cpumask_var
() where possible") from the rr tree and commit
a763af6587fbead6cee75ad3ae14709fa67e7dbb ("x86: provide CPU topology
information for multi-node processors") from the edac-amd tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/smpboot.c
index 70bd79b,5428337..0000000
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@@ -1057,9 -1068,14 +1068,10 @@@ void __init native_smp_prepare_cpus(uns
  #endif
  	current_thread_info()->cpu = 0;  /* needed? */
  	for_each_possible_cpu(i) {
 -		alloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
 -		alloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
 -		alloc_cpumask_var(&per_cpu(cpu_node_map, i), GFP_KERNEL);
 -		alloc_cpumask_var(&cpu_data(i).llc_shared_map, GFP_KERNEL);
 -		cpumask_clear(per_cpu(cpu_core_map, i));
 -		cpumask_clear(per_cpu(cpu_node_map, i));
 -		cpumask_clear(per_cpu(cpu_sibling_map, i));
 -		cpumask_clear(cpu_data(i).llc_shared_map);
 +		zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
 +		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
++		zalloc_cpumask_var(&per_cpu(cpu_node_map, i), GFP_KERNEL);
 +		zalloc_cpumask_var(&cpu_data(i).llc_shared_map, GFP_KERNEL);
  	}
  	set_cpu_sibling_map(0);
  
