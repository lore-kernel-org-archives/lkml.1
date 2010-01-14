Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825Ab0ANOIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab0ANOIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 09:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756776Ab0ANOIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 09:08:36 -0500
Received: from mga03.intel.com ([143.182.124.21]:36613 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756775Ab0ANOIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 09:08:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="232699893"
Date: Thu, 14 Jan 2010 22:08:15 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Zheng, Shaohui" <shaohui.zheng@intel.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       "y-goto@jp.fujitsu.com" <y-goto@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [ RESEND PATCH v3] Memory-Hotplug: Fix the bug on interface
	/dev/mem for 64-bit kernel
Message-ID: <20100114140815.GA18580@localhost>
References: <DA586906BA1FFC4384FCFD6429ECE860316C0133@shzsmsx502.ccr.corp.intel.com> <20100112170433.394be31b.kamezawa.hiroyu@jp.fujitsu.com> <20100114132451.GA2546@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100114132451.GA2546@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 2. pgdat->[start,end], totalram_pages etc...are updated at memory hotplug.
> >    Please place the hook nearby them.
> 
> arch/x86/mm/init_64.c:arch_add_memory() updates max_pfn_mapped, in
> this sense it's equally OK to update max_pfn/max_low_pfn etc before
> the call to arch_add_memory() ;)

Shaohui, I'd suggest to update max_pfn/max_low_pfn/high_memory in
arch/x86/mm/init_64.c:arch_add_memory() now, for X86_64.

Later on we can add code to arch/x86/mm/init_32.c:arch_add_memory()
for X86_32.

The code cannot be shared anyway.

Thanks,
Fengguang
