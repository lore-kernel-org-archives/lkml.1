Return-Path: <linux-kernel-owner+w=401wt.eu-S1754494Ab0ALAds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab0ALAds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 19:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419Ab0ALAdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 19:33:47 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45630 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401Ab0ALAdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 19:33:47 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 12 Jan 2010 09:30:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "Zheng, Shaohui" <shaohui.zheng@intel.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       "y-goto@jp.fujitsu.com" <y-goto@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH - resend] Memory-Hotplug: Fix the bug on interface
 /dev/mem for 64-bit kernel(v1)
Message-Id: <20100112093031.0fc6877f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100111124303.GA21408@localhost>
References: <DA586906BA1FFC4384FCFD6429ECE86031560BAC@shzsmsx502.ccr.corp.intel.com>
	<20100108124851.GB6153@localhost>
	<DA586906BA1FFC4384FCFD6429ECE86031560FC1@shzsmsx502.ccr.corp.intel.com>
	<20100111124303.GA21408@localhost>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jan 2010 20:43:03 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> > > +	/* if add to low memory, update max_low_pfn */
> > > +	if (unlikely(start_pfn < limit_low_pfn)) {
> > > +		if (end_pfn <= limit_low_pfn)
> > > +			max_low_pfn = end_pfn;
> > > +		else
> > > +			max_low_pfn = limit_low_pfn;
> > 
> > X86_64 actually always set max_low_pfn=max_pfn, in setup_arch():
> > [Zheng, Shaohui] there should be some misunderstanding, I read the
> > code carefully, if the total memory is under 4G, it always
> > max_low_pfn=max_pfn. If the total memory is larger than 4G,
> > max_low_pfn means the end of low ram. It set
> 
> > max_low_pfn = e820_end_of_low_ram_pfn();.
> 
> The above line is very misleading.. In setup_arch(), it will be
> overrode by the following block.
> 

Hmmm....could you rewrite /dev/mem to use kernel/resource.c other than
modifing e820 maps. ?
Two reasons.
  - e820map is considerted to be stable, read-only after boot.
  - We don't need to add more x86 special codes.


Thanks,
-Kame

