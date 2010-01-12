Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506Ab0ALBCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab0ALBCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 20:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249Ab0ALBCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 20:02:21 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49490 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab0ALBCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 20:02:20 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 12 Jan 2010 09:58:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@kernel.org>,
       "Zheng, Shaohui" <shaohui.zheng@intel.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "y-goto@jp.fujitsu.com" <y-goto@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>,
       "Wu, Fengguang" <fengguang.wu@intel.com>,
       "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH - resend] Memory-Hotplug: Fix the bug on interface
 /dev/mem for 64-bit kernel(v1)
Message-Id: <20100112095848.b2cee1f3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4B478BEA.1010504@linux.intel.com>
References: <DA586906BA1FFC4384FCFD6429ECE86031560BAC@shzsmsx502.ccr.corp.intel.com>
	<4B46BC6F.5060607@kernel.org>
	<4B478BEA.1010504@linux.intel.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Jan 2010 20:47:54 +0100
Andi Kleen <ak@linux.intel.com> wrote:

> H. Peter Anvin wrote:
> > On 01/07/2010 07:32 PM, Zheng, Shaohui wrote:
> >> Resend the patch to the mailing-list, the original patch URL is 
> >> http://patchwork.kernel.org/patch/69075/, it is not accepted without comments,
> >> sent it again to review.
> >>
> >> Memory-Hotplug: Fix the bug on interface /dev/mem for 64-bit kernel
> >>
> >> The new added memory can not be access by interface /dev/mem, because we do not
> >>  update the variable high_memory. This patch add a new e820 entry in e820 table,
> >>  and update max_pfn, max_low_pfn and high_memory.
> >>
> >> We add a function update_pfn in file arch/x86/mm/init.c to udpate these
> >>  varibles. Memory hotplug does not make sense on 32-bit kernel, so we did not
> >>  concern it in this function.
> >>
> > 
> > Memory hotplug makes sense on 32-bit kernels, at least in virtual
> > environments.
> 
> No VM currently supports it to my knowledge. They all use traditional
> balooning.
> 
> If someone adds that they can still fix it, but right now fixing it on 64bit
> is the important part.
> 
I wonder...with some modification, memory hotplug (or Mel's page coalescing)
can be used for balloning in MAX_ORDER page size.
I'm sorry if VM' baloon drivers has no fragmentaion problem.

Thanks,
-Kame

