Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbZIWCLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbZIWCLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 22:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbZIWCLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 22:11:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:41524 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819AbZIWCLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 22:11:18 -0400
Message-ID: <4AB983B6.6050203@kernel.org>
Date: Wed, 23 Sep 2009 11:11:02 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Nick Piggin <npiggin@suse.de>, Tony Luck <tony.luck@intel.com>,
       Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ia64: allocate percpu area for cpu0 like percpu areas
 for other cpus
References: <1253605214-23210-1-git-send-email-tj@kernel.org> <1253605214-23210-3-git-send-email-tj@kernel.org> <alpine.DEB.1.10.0909221856050.9410@V090114053VZO-1>
In-Reply-To: <alpine.DEB.1.10.0909221856050.9410@V090114053VZO-1>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 23 Sep 2009 02:11:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 22 Sep 2009, Tejun Heo wrote:
> 
>> +#ifdef	CONFIG_SMP
>> +  . = ALIGN(PERCPU_PAGE_SIZE);
>> +  __cpu0_per_cpu = .;
> 
> __per_cpu_start?
> 
>> +  . = . + PERCPU_PAGE_SIZE;	/* cpu0 per-cpu space */
>> +#endif
> 
> This is a statically sized per cpu area that is used by __get_cpu_var()
> Data is access via a cpu specific memory mapping. How does this work when
> the area grows beyond  PERCPU_PAGE_SIZE? As far as I can see: It seems
> that __get_cpu_var would then cause a memory fault?

On ia64, the first chunk is fixed at PERCPU_PAGE_SIZE.  It's something
hardwired into the page fault logic and the linker script.  Build will
fail if the static + reserved area goes over PERCPU_PAGE_SIZE and in
that case ia64 will need to update the special case page fault logic
and increase PERCPU_PAGE_SIZE.  The area reserved above is interim
per-cpu area for cpu0 which is used between head.S and proper percpu
area setup and will be ditched once initialization is complete.

Thanks.

-- 
tejun
