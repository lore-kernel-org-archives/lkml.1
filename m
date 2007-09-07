Return-Path: <linux-kernel-owner+w=401wt.eu-S932961AbXIGPyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961AbXIGPyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 11:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932617AbXIGPx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 11:53:59 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55821 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757089AbXIGPx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 11:53:59 -0400
Message-ID: <46E17282.9030902@sgi.com>
Date: Fri, 07 Sep 2007 08:47:14 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <ak@suse.de>, clameter@sgi.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] core: fix build error when referencing arch specific
 structures
References: <20070907040943.467530005@sgi.com>	<200709070828.05730.ak@suse.de> <20070907035632.13ceb928.akpm@linux-foundation.org>
In-Reply-To: <20070907035632.13ceb928.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> On Fri, 7 Sep 2007 08:28:05 +0100 Andi Kleen <ak@suse.de> wrote:
>> On Friday 07 September 2007 05:09, travis@sgi.com wrote:
>>> Since the core kernel routines need to reference cpu_sibling_map,
>>> whether it be a static array or a per_cpu data variable, an access
>>> function has been defined.
>>>
>>> In addition, changes have been made to the ia64 and ppc64 arch's to
>>> move the cpu_sibling_map from a static cpumask_t array [NR_CPUS] to
>>> be per_cpu cpumask_t arrays.
>>>
>>> Note that I do not have the ability to build or test patch 3/3, the
>>> ppc64 changes.
>>>
>>> Patches are referenced against 2.6.23-rc4-mm1 .
>> It would be better if you could redo the patches with the original patches
>> reverted, not incremental changes. In the end we'll need a full patch set
>> with full changelog anyways, not a series of incremental fixes.
> 
> yup
>  
>> Also I guess some powerpc testers would be needed. Perhaps cc the
>> maintainers?
>>
> 
> yup
> 
> All architectures except sparc64 are now done - please have a shot at doing
> sparc64 as well.

Ok, will do.  I didn't realize there was only one more that used the SCHED_SMT
code.

> 
> I'd suggest that we not implement that cpu_sibling_map() macro and just
> open-code the per_cpu() everywhere.  So henceforth any architecture which
> implements CONFIG_SCHED_SMT must implement the per-cpu sibling map.

Yes, with only one more to do it's not that daunting. ;-)

> That's nice and simple, and avoids the unpleasant
> pretend-function-used-as-an-lvalue trick.  (Well OK, per_cpu() does
> that, but let's avoid resinning).

Yes, the per_cpu macro is quite the specimen. ;-)

Thanks!
Mike

