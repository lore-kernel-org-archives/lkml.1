Return-Path: <linux-kernel-owner+w=401wt.eu-S1753580Ab0ALCp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab0ALCp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 21:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224Ab0ALCp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 21:45:56 -0500
Received: from mga03.intel.com ([143.182.124.21]:22032 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177Ab0ALCp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 21:45:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="231653437"
Date: Tue, 12 Jan 2010 10:45:52 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andi Kleen <ak@linux.intel.com>,
       "Zheng, Shaohui" <shaohui.zheng@intel.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "y-goto@jp.fujitsu.com" <y-goto@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH - resend] Memory-Hotplug: Fix the bug on interface
	/dev/mem for 64-bit kernel(v1)
Message-ID: <20100112024552.GA19425@localhost>
References: <DA586906BA1FFC4384FCFD6429ECE86031560BAC@shzsmsx502.ccr.corp.intel.com> <20100108124851.GB6153@localhost> <DA586906BA1FFC4384FCFD6429ECE86031560FC1@shzsmsx502.ccr.corp.intel.com> <20100111124303.GA21408@localhost> <20100112093031.0fc6877f.kamezawa.hiroyu@jp.fujitsu.com> <4B4BD281.4080009@linux.intel.com> <20100112103944.a9b1db76.kamezawa.hiroyu@jp.fujitsu.com> <20100112105012.4a210a1c.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100112105012.4a210a1c.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 09:50:12AM +0800, KAMEZAWA Hiroyuki wrote:

> Just an information.
> 
> We already check kenerke/resource.c's resource information, here.
> 
> read_mem()
> 	-> range_is_allowed()
> 		-> devmem_is_allowd()
> 			-> iomem_is_exclusive()
> 
> extra calls of page_is_ram() to ask architecture's map seems redundunt.
> 
> But, I know PPC guys doesn't use ioresource.c, hehe.

Another exception is !CONFIG_STRICT_DEVMEM, which makes
range_is_allowed()==1. So we still need the page_is_ram() :)

Thanks,
Fengguang

