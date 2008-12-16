Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbYLPCYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbYLPCYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 21:24:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbYLPCYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 21:24:15 -0500
Received: from relay3.sgi.com ([192.48.171.31]:40526 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751584AbYLPCYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 21:24:13 -0500
Message-Id: <20081216022409.679598000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 15 Dec 2008 18:24:09 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 00/16] cpumask: consolidate and apply x86 cpumask changes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here's a consolidation of the x86-only patches.  It needs
to be applied to tip/cpus4096 at:

8299608... Merge branches 'irq/sparseirq', ... into cpus4096

... with the following tree merged in:

git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-ingo.git master

This should put the HEAD at v2.6.28-rc6-944-g968ea6d .

Note that the kernel tree will not be buildable at this point.  There's a
combination of old and new API patches being applied.  After applying
the first patch below, it will again be buildable (and bootable).

The following patches are included:

  1  x86 smp: modify send_IPI_mask interface to accept cpumask_t pointers
  2  x86: enable MAXSMP
  3  x86: move and enhance debug printk for nr_cpu_ids etc.
  4  x86: Add cpu_mask_to_apicid_and
  5  x86: update add-cpu_mask_to_apicid_and to use struct cpumask*
  6  x86: Update io_apic.c to use new cpumask API
  7  xen: convert to cpumask_var_t and new cpumask primitives.
  8  x86: fixup_irqs() doesn't need an argument.
  9  x86: cosmetic changes apic-related files.
 10  x86: Set CONFIG_NR_CPUS even on UP
 11  x86: prepare for cpumask iterators to only go to nr_cpu_ids
 12  x86: Use cpumask accessors code for possible/present maps.
 13  x86: Remove cpumask games in x86/kernel/cpu/intel_cacheinfo.c
 14  x86: use work_on_cpu in x86/kernel/cpu/mcheck/mce_amd_64.c
 15  x86: xen: use smp_call_function_many()
 16  x86: Introduce topology_core_cpumask()/topology_thread_cpumask()


Other patches not here were mostly small fixups that were folded into the
original patch, or a consoldition of patches (#6 above).

Signed-off-by: Mike Travis <travis@sgi.com>

-- 
