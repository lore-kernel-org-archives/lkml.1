Return-Path: <linux-kernel-owner+w=401wt.eu-S933166AbXCNUXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166AbXCNUXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933226AbXCNUXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:23:46 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:44522 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933166AbXCNUXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:23:45 -0400
Message-ID: <45F859CF.8040100@vmware.com>
Date: Wed, 14 Mar 2007 12:23:43 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>
Subject: Re: [patch 28/34] Xen-pv_ops: Xen SMP guest support
References: <20070313233017.933601256@goop.org> <20070313233034.586018620@goop.org> <20070314132820.GL6209@kvack.org>
In-Reply-To: <20070314132820.GL6209@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin LaHaise wrote:
>   
>> +/*
>> + * We aggressively remove defunct pgd from cr3. We execute unmap_vmas()
>> + * *much* faster this way.
>> + */
>>     
>
> Are you switching mms in order to avoid all of the overhead associated with 
> flushing an active mm during task exit?  If so, it makes much more sense to 
> do this in the generic helper, as it should be a win on x86 and x86-64 
> where switching to init_mm is relatively low cost given the support for 
> global pages.  I'll run some tests on a couple of systems this evening and 
> post the results.
>   

I tried this experiment on both x86 and x86-64 and I recall not seeing 
any effect.  The mmu_gather optimization does most of this already.

Zach
