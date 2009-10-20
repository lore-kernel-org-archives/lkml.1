Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbZJTHiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbZJTHiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 03:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbZJTHiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 03:38:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:42376 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbZJTHiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 03:38:07 -0400
Message-ID: <4ADD6915.7000909@kernel.org>
Date: Tue, 20 Oct 2009 16:39:01 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Jiri Kosina <jkosina@suse.cz>,
       Jeff Mahoney <jeffm@suse.com>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64@vger.kernel.org
Subject: Re: Commit 34d76c41 causes linker errors on ia64 with NR_CPUS=4096
References: <4ADB967A.4080707@suse.com> <alpine.LRH.2.00.0910200356340.20992@twin.jikos.cz> <alpine.LRH.2.00.0910200651510.20992@twin.jikos.cz> <20091020061557.GE8550@elte.hu> <alpine.LSU.2.00.0910200820500.8582@wotan.suse.de> <20091020063555.GJ8550@elte.hu> <4ADD62AA.8060503@gmail.com>
In-Reply-To: <4ADD62AA.8060503@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 20 Oct 2009 07:37:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Ingo Molnar a écrit :
>  
>> Still looks like a bug if it causes a breakage (linker error) on IA64, 
>> and if the 'fix' (i'd call it a workaround) causes a (small but nonzero) 
>> performance regression on other architectures.
>>
> 
> True, but this also save some amount of ram for some distro kernels.
> 
> If we keep this static NR_CPUS thing, we might be able to free
> the end of table, for other per_cpu users ?
> 
> if (nr_cpus_ids < NR_CPUS) {
> 	per_cpu_free_static_zone(&update_shares_data[nr_cpus_ids],
> 				 sizeof(long)*(NR_CPUS - nr_cpus_ids));
> }

That's doable but Considering that the users of NR_CPUS are pretty few
(and should be kept that way), I think it would be better to just use
dynamic allocation, which no longer incurs any major performance
difference (the only difference is constant offset vs. pointer in a
variable), for those cases.

Thanks.

-- 
tejun
