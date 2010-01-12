Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828Ab0ALCmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab0ALCmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 21:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536Ab0ALCmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 21:42:20 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52134 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab0ALCmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 21:42:19 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 12 Jan 2010 11:39:03 +0900
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
Message-Id: <20100112113903.89163c46.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100112023307.GA16661@localhost>
References: <DA586906BA1FFC4384FCFD6429ECE86031560BAC@shzsmsx502.ccr.corp.intel.com>
	<20100108124851.GB6153@localhost>
	<DA586906BA1FFC4384FCFD6429ECE86031560FC1@shzsmsx502.ccr.corp.intel.com>
	<20100111124303.GA21408@localhost>
	<20100112093031.0fc6877f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100112023307.GA16661@localhost>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jan 2010 10:33:08 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> Sure, here it is :)
> ---
> x86: use the generic page_is_ram()
> 
> The generic resource based page_is_ram() works better with memory
> hotplug/hotremove. So switch the x86 e820map based code to it.
> 
> CC: Andi Kleen <andi@firstfloor.org> 
> CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Ack.


> +#ifdef CONFIG_X86
> +	/*
> +	 * A special case is the first 4Kb of memory;
> +	 * This is a BIOS owned area, not kernel ram, but generally
> +	 * not listed as such in the E820 table.
> +	 */
> +	if (pfn == 0)
> +		return 0;
> +
> +	/*
> +	 * Second special case: Some BIOSen report the PC BIOS
> +	 * area (640->1Mb) as ram even though it is not.
> +	 */
> +	if (pfn >= (BIOS_BEGIN >> PAGE_SHIFT) &&
> +	    pfn <  (BIOS_END   >> PAGE_SHIFT))
> +		return 0;
> +#endif

I'm glad if this part is sorted out in clean way ;)

Thanks,
-Kame

