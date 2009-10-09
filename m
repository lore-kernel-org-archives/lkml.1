Return-Path: <linux-kernel-owner+w=401wt.eu-S933990AbZJIQdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933990AbZJIQdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 12:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933914AbZJIQde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 12:33:34 -0400
Received: from mga10.intel.com ([192.55.52.92]:65228 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933644AbZJIQdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 12:33:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,533,1249282800"; 
   d="scan'208";a="734763870"
Message-ID: <4ACF658D.4010605@linux.intel.com>
Date: Fri, 09 Oct 2009 09:32:13 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
CC: Kyle McMartin <kyle@mcmartin.ca>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.32-rc3: floating-point build failure (undefined reference
 to `__udivdi3' in menu governor)
References: <20091007104125.GA1449@rhlx01.hs-esslingen.de> <4ACCA44B.3070706@linux.intel.com> <20091007173457.GA25415@rhlx01.hs-esslingen.de> <20091007174553.GC11702@bombadil.infradead.org> <20091009160123.GA14808@rhlx01.hs-esslingen.de>
In-Reply-To: <20091009160123.GA14808@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Mohr wrote:
> Hi,
> 
> On Wed, Oct 07, 2009 at 01:45:54PM -0400, Kyle McMartin wrote:
>> On Wed, Oct 07, 2009 at 07:34:58PM +0200, Andreas Mohr wrote:
>>> Still happening.
>>> IOW it must be somewhere inside the DIV_ROUND_CLOSEST macro or so.
>>>
>> It's being a jerk and not realizing that RESOLUTION * DECAY is a power
>> of 2, so it can just do a shift...
>>
>> I don't recall if gcc 3 had these magic builtins, but if it does,
>> something like this might help since it's the u64 case that's
>> problematic.
> 
> Uh... nope:
> 
> In file included from kernel/sched.c:1818:
> kernel/sched_fair.c: In function `select_task_rq_fair':
> kernel/sched_fair.c:1366: implicit declaration of function `__builtin_popcountll'
> kernel/sched_fair.c:1366: implicit declaration of function `__builtin_ffsll'
> kernel/sched_fair.c:1366: warning: suggest parentheses around + or - inside shift
> kernel/sched.c: In function `update_sg_lb_stats':
> kernel/sched.c:3755: warning: suggest parentheses around + or - inside shift
> kernel/sched.c: In function `find_busiest_queue':
> kernel/sched.c:4050: warning: suggest parentheses around + or - inside shift
> make[1]: *** [kernel/sched.o] Error 1
> make: *** [kernel] Error 2
> 
> 
> Hmpf. Rather stuck now, ain'tcha, given that gcc 3.2.3 doesn't even have those?
> 

wonder if making a new define with the value of RESOLUTION * DECAY
(the actual value obviously) convinces your gcc that it really is a power of two ?
