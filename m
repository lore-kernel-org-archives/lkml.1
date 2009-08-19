Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbZHSOgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbZHSOgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 10:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbZHSOgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 10:36:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:50750 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343AbZHSOgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 10:36:36 -0400
Message-ID: <4A8C0DE5.302@kernel.org>
Date: Wed, 19 Aug 2009 23:36:21 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: "Yu, Fenghua" <fenghua.yu@intel.com>
CC: "Luck, Tony" <tony.luck@intel.com>,
       "'lkml'" <linux-kernel@vger.kernel.org>,
       "'linux-arch@vger.kernel.org'" <linux-arch@vger.kernel.org>,
       "'linux-ia64@vger.kernel.org'" <linux-ia64@vger.kernel.org>
Subject: Re: [RFC PATCH] ia64: convert to dynamic percpu allocator
References: <4A65B0AB.5000608@kernel.org> <A6AD88C3F2289247BE726C37303E1EB8B097D4C5@orsmsx505.amr.corp.intel.com> <4A663DC7.4060600@kernel.org> <A6AD88C3F2289247BE726C37303E1EB8B0A9115B@orsmsx505.amr.corp.intel.com> <4A695897.2020902@kernel.org> <A6AD88C3F2289247BE726C37303E1EB8B3A85355@orsmsx505.amr.corp.intel.com> <4A826785.4000509@kernel.org>
In-Reply-To: <4A826785.4000509@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 19 Aug 2009 14:36:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> * Is ai->reserved_size necessary for ia64?  This is necessary if
>   there's linking range restriction when loading modules.
>   ai->reserved_size guarantees that all static module percpu variables
>   are allocated in the first chunk which will be in the linear address
>   range and very close to __per_cpu_start.  If ai->reserved_size is
>   not set, these areas are likely to end up high in the vmalloc area.
> 
>   For example, x86_64 assumes 32bit relocations should be enough to
>   link module symbols and thus needs to set reserved_size but x86_32
>   can link to the whole 32bit space and thus can leave reserved_size
>   at zero.
> 
> * After determining the above, we can set ai->dyn_size to be
> 
>   ai->dyn_size = min(ai->unit_size - ai->static_size - ai->reserved_size,
> 		     PERCPU_DYNAMIC_RESERVE);
> 
> Would the above work?
> 
>> Even with the above PAGE_SIZE changes, the kernel still reports
>> warning from 952: WARN_ON(chunk->immutable) and then panic.
> 
> Hah... strange.  Can you please attach full boot log?  This is
> dicontig configuration, right?

Any news?

Thanks.

-- 
tejun
