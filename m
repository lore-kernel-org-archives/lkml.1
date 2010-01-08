Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058Ab0AHTsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab0AHTsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 14:48:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520Ab0AHTsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 14:48:01 -0500
Received: from mga12.intel.com ([143.182.124.36]:48939 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752437Ab0AHTsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 14:48:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="230758496"
Message-ID: <4B478BEA.1010504@linux.intel.com>
Date: Fri, 08 Jan 2010 20:47:54 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@kernel.org>
CC: "Zheng, Shaohui" <shaohui.zheng@intel.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "y-goto@jp.fujitsu.com" <y-goto@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>,
       "Wu, Fengguang" <fengguang.wu@intel.com>,
       "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH - resend] Memory-Hotplug: Fix the bug on interface /dev/mem
 for 64-bit kernel(v1)
References: <DA586906BA1FFC4384FCFD6429ECE86031560BAC@shzsmsx502.ccr.corp.intel.com> <4B46BC6F.5060607@kernel.org>
In-Reply-To: <4B46BC6F.5060607@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 01/07/2010 07:32 PM, Zheng, Shaohui wrote:
>> Resend the patch to the mailing-list, the original patch URL is 
>> http://patchwork.kernel.org/patch/69075/, it is not accepted without comments,
>> sent it again to review.
>>
>> Memory-Hotplug: Fix the bug on interface /dev/mem for 64-bit kernel
>>
>> The new added memory can not be access by interface /dev/mem, because we do not
>>  update the variable high_memory. This patch add a new e820 entry in e820 table,
>>  and update max_pfn, max_low_pfn and high_memory.
>>
>> We add a function update_pfn in file arch/x86/mm/init.c to udpate these
>>  varibles. Memory hotplug does not make sense on 32-bit kernel, so we did not
>>  concern it in this function.
>>
> 
> Memory hotplug makes sense on 32-bit kernels, at least in virtual
> environments.

No VM currently supports it to my knowledge. They all use traditional
balooning.

If someone adds that they can still fix it, but right now fixing it on 64bit
is the important part.

-Andi
