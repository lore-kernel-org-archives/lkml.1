Return-Path: <linux-kernel-owner+w=401wt.eu-S1752923Ab0ALFxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab0ALFxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 00:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376Ab0ALFxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 00:53:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:61428 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087Ab0ALFxI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 00:53:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,260,1262592000"; 
   d="scan'208";a="483248929"
From: "Zheng, Shaohui" <shaohui.zheng@intel.com>
To: "Wu, Fengguang" <fengguang.wu@intel.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       "y-goto@jp.fujitsu.com" <y-goto@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>, "x86@kernel.org" <x86@kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 12 Jan 2010 13:51:15 +0800
Subject: RE: [PATCH - resend] Memory-Hotplug: Fix the bug on interface
	/dev/mem for 64-bit kernel(v1)
Thread-Topic: [PATCH - resend] Memory-Hotplug: Fix the bug on interface
	/dev/mem for 64-bit kernel(v1)
Thread-Index: AcqSu7hD6Q79KRLASCWpxZ0RhWbs5wAjsfNw
Message-ID: <DA586906BA1FFC4384FCFD6429ECE860316C002A@shzsmsx502.ccr.corp.intel.com>
References: <DA586906BA1FFC4384FCFD6429ECE86031560BAC@shzsmsx502.ccr.corp.intel.com>
 <20100108124851.GB6153@localhost>
 <DA586906BA1FFC4384FCFD6429ECE86031560FC1@shzsmsx502.ccr.corp.intel.com>
 <20100111124303.GA21408@localhost>
In-Reply-To: <20100111124303.GA21408@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	/* if add to low memory, update max_low_pfn */
> > +	if (unlikely(start_pfn < limit_low_pfn)) {
> > +		if (end_pfn <= limit_low_pfn)
> > +			max_low_pfn = end_pfn;
> > +		else
> > +			max_low_pfn = limit_low_pfn;
> 
> X86_64 actually always set max_low_pfn=max_pfn, in setup_arch():
> [Zheng, Shaohui] there should be some misunderstanding, I read the
> code carefully, if the total memory is under 4G, it always
> max_low_pfn=max_pfn. If the total memory is larger than 4G,
> max_low_pfn means the end of low ram. It set

> max_low_pfn = e820_end_of_low_ram_pfn();.

The above line is very misleading.. In setup_arch(), it will be
overrode by the following block.
[Zheng, Shaohui] yes, I misunderstand it because of this code. It seems that max_low_pfn == max_pfn is always true on x86_32 and x86_64.  Thanks fengguang to point it out.

>  899 #ifdef CONFIG_X86_64
>  900         if (max_pfn > max_low_pfn) {
>  901                 max_pfn_mapped = init_memory_mapping(1UL<<32,
>  902                                                      max_pfn<<PAGE_SHIFT);
>  903                 /* can we preseve max_low_pfn ?*/
>  904                 max_low_pfn = max_pfn;
>  905         }
>  906 #endif
 
Thanks,
Fengguang
