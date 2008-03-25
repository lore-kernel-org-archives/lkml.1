Return-Path: <linux-kernel-owner+w=401wt.eu-S1757889AbYCYRkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbYCYRkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 13:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755070AbYCYRkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 13:40:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:10600 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092AbYCYRkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 13:40:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,553,1199692800"; 
   d="scan'208";a="539768072"
Date: Tue, 25 Mar 2008 10:38:16 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Chris Snook <csnook@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] srat, x86_64: Add support for nodes spanning other nodes
Message-ID: <20080325173815.GJ15909@linux-os.sc.intel.com>
References: <20080325171435.GA3313@linux-os.sc.intel.com> <47E93655.10907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E93655.10907@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 01:28:53PM -0400, Chris Snook wrote:
> Suresh Siddha wrote:
> >For example, If the physical address layout on a two node system with 8 GB
> >memory is something like:
> >node 0: 0-2GB, 4-6GB
> >node 1: 2-4GB, 6-8GB
> >
> >Current kernels fail to boot/detect this NUMA topology.
> >
> >ACPI SRAT tables can expose such a topology which needs to be supported.
> >
> >Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> >---
> >
> >diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> >index 227fdb0..99eb102 100644
> >--- a/arch/x86/Kconfig
> >+++ b/arch/x86/Kconfig
> >@@ -880,6 +880,15 @@ config X86_64_ACPI_NUMA
> > 	help
> > 	  Enable ACPI SRAT based node topology detection.
> > 
> >+# Some NUMA nodes have memory ranges that span
> >+# other nodes.  Even though a pfn is valid and
> >+# between a node's start and end pfns, it may not
> >+# reside on that node.  See memmap_init_zone()
> >+# for details.
> >+config NODES_SPAN_OTHER_NODES
> >+	def_bool y
> >+	depends on X86_64_ACPI_NUMA
> >+
> 
> Is this hunk a leftover from your testing?  You're not using the config 

No.

> option anywhere, and there isn't really anything in this patch that would 
> justify making this a separate config option in mainline.

Its the generic -mm code which needs this. Please refer to early_pfn_in_nid()
and its usage in memmap_init_zone()

thanks,
suresh
