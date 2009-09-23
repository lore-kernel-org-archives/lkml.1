Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbZIWWCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbZIWWCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 18:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZIWWCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 18:02:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:37502 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbZIWWC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 18:02:29 -0400
Message-ID: <4ABA9B14.20904@kernel.org>
Date: Thu, 24 Sep 2009 07:03:00 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Nick Piggin <npiggin@suse.de>, Tony Luck <tony.luck@intel.com>,
       Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ia64: allocate percpu area for cpu0 like percpu areas
 for other cpus
References: <1253605214-23210-1-git-send-email-tj@kernel.org> <1253605214-23210-3-git-send-email-tj@kernel.org> <alpine.DEB.1.10.0909221856050.9410@V090114053VZO-1> <4AB983B6.6050203@kernel.org> <alpine.DEB.1.10.0909230941560.21821@V090114053VZO-1> <4ABA2A3A.6020308@kernel.org> <alpine.DEB.1.10.0909231315310.4025@V090114053VZO-1>
In-Reply-To: <alpine.DEB.1.10.0909231315310.4025@V090114053VZO-1>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 23 Sep 2009 22:02:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Wed, 23 Sep 2009, Tejun Heo wrote:
> 
>> any special handling.  What problems are you seeing?
> 
> per cpu variable access on IA64 does not use the percpu_offset for the
> calculation of the current per cpu data area. Its using a virtual mapping.
> 
> How does the new percpu allocator support this? Does it use different
> methods of access for static and dynamic percpu access?

That's only when __ia64_per_cpu_var() macro is used in arch code which
always references static perpcu variable in the kernel image which
falls inside PERCPU_PAGE_SIZE.  For everything else, __my_cpu_offset
is defined as __ia64_per_cpu_var(local_per_cpu_offset) and regular
pointer offsetting is used.

Thanks.

-- 
tejun
