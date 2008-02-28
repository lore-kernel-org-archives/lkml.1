Return-Path: <linux-kernel-owner+w=401wt.eu-S1760370AbYB1ByR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760370AbYB1ByR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 20:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755598AbYB1ByA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 20:54:00 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40901 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247AbYB1Bx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 20:53:59 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5239"; a="958862"
Message-ID: <47C61434.7060703@qualcomm.com>
Date: Wed, 27 Feb 2008 17:53:56 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu, tglx@linutronix.de,
       oleg@tv-sign.ru, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 2/4] cpuset: system sets
References: <20080227222103.673194000@chello.nl>	<20080227222542.311184000@chello.nl> <20080227173958.c6ffb32a.pj@sgi.com>
In-Reply-To: <20080227173958.c6ffb32a.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Peter wrote:
>> A system set will be one that caters the
>> general purpose OS. This patch provides the infrastructure, but doesn't
>> actually provide any new functionality.
>>
>> Typical functionality would be setting the IRQ affinity of unbound IRQs to
>> within the system set. And setting the affinity of unbounded kernel threads to
>> within the system set.
> 
> "one that caters the general purpose OS" ... a tad terse on the
> documentation ;).
> 
> I guess what you have is a new cpumask_t cpu_system_map, which is the
> union of the CPUs of all the cpusets marked 'system', where to a rough
> approximation the CPUs -not- in that cpumask are what we would have
> called the isolated CPUs by the old code?
Yes it's in fact exactly the same as ~cpu_isolated_map in the patches that I 
sent out earlier.

> In any case, if this patch survives its birth, it will need an added
> change for some file in the Documentation directory.
Sure. We can just update readme from my patch to use cpuset instead of 
/sys/system/cpu/cpu1/isolated bits. If we go with this approach that is.

> Could we get the term 'cpu' in the name 'system' somehow?  Perhaps call
> this new cpuset flag 'cpus_system' or some such.  Cpusets handles both
> CPU and memory configuration, and I make some effort to mark per-cpuset
> specific attributes that apply to only one of these with a prefix
> indicating to which they apply.  The per-cpuset flag name 'system', by
> itself, would mean little to someone just listing the files in a cpuset
> directory.
Makes sense to me too. ie cpus_system is more descriptive.

> In the rebuild_system_map() code, you have:
> +	if (cpus_empty(*new_system_map))
> +		BUG();
> 
> ... what's to prevent simply turning off the 'system' (aka cpus_system)
> in the top cpuset, on a system with only that one cpuset, and hitting
> this BUG()?
Good point.

> Overall I like this approach.  I suspect you made a good choice in
> marking the non-isolated (aka system) CPUs, rather than the isolated
> CPUs.  It seems clearer that way, in understanding the affects of
> overlapping cpusets with various markings.
Ok so you did not like the 'isolated' name too ;-).

Max





