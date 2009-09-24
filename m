Return-Path: <linux-kernel-owner+w=401wt.eu-S1751913AbZIXHkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbZIXHkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 03:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbZIXHkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 03:40:03 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:47878 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751387AbZIXHkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 03:40:01 -0400
Date: Thu, 24 Sep 2009 03:36:11 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Tejun Heo <tj@kernel.org>
cc: Nick Piggin <npiggin@suse.de>, Tony Luck <tony.luck@intel.com>,
       Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ia64: allocate percpu area for cpu0 like percpu
 areas for other cpus
In-Reply-To: <4ABA9B14.20904@kernel.org>
Message-ID: <alpine.DEB.1.10.0909240332130.1488@V090114053VZO-1>
References: <1253605214-23210-1-git-send-email-tj@kernel.org> <1253605214-23210-3-git-send-email-tj@kernel.org> <alpine.DEB.1.10.0909221856050.9410@V090114053VZO-1> <4AB983B6.6050203@kernel.org> <alpine.DEB.1.10.0909230941560.21821@V090114053VZO-1>
 <4ABA2A3A.6020308@kernel.org> <alpine.DEB.1.10.0909231315310.4025@V090114053VZO-1> <4ABA9B14.20904@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009, Tejun Heo wrote:

> > How does the new percpu allocator support this? Does it use different
> > methods of access for static and dynamic percpu access?
>
> That's only when __ia64_per_cpu_var() macro is used in arch code which
> always references static perpcu variable in the kernel image which
> falls inside PERCPU_PAGE_SIZE.  For everything else, __my_cpu_offset
> is defined as __ia64_per_cpu_var(local_per_cpu_offset) and regular
> pointer offsetting is used.

So this means that address arithmetic needs to be performed for each
percpu access. The virtual mapping would allow the calculation of the
address at link time. Calculation means that a single atomic instruction
for percpu access wont be possible for ia64.

I can toss my ia64 percpu optimization patches. No point anymore.

Tony: We could then also drop the virtual per cpu mapping. Its only useful
for arch specific code and an alternate method of reference exists.


