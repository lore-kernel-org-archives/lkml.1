Return-Path: <linux-kernel-owner+w=401wt.eu-S1759522AbYCZPxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522AbYCZPxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 11:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759340AbYCZPxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 11:53:30 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54663 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759330AbYCZPx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:53:29 -0400
Message-ID: <47EA7177.8010605@sgi.com>
Date: Wed, 26 Mar 2008 08:53:27 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/12] cpumask: reduce stack pressure from local/passed
 cpumask variables v2
References: <20080326013811.569646000@polaris-admin.engr.sgi.com> <20080326061824.GB18301@elte.hu>
In-Reply-To: <20080326061824.GB18301@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Modify usage of cpumask_t variables to use pointers as much as 
>> possible.
> 
> hm, why is there no minimal patch against -git that does nothing but 
> introduces the new pointer based generic APIs (without using them) - 
> such as set_cpus_allowed_ptr(), etc.? Once that is upstream all the 
> remaining changes can trickle one arch and one subsystem at a time, and 
> once that's done, the old set_cpus_allowed() can be removed. This is far 
> more manageable than one large patch.
> 
> and the cpumask_of_cpu() change should be Kconfig based initially - once 
> all arches have moved to it (or even sooner) we can remove that.
> 
> 	Ingo

Yes, good idea!  I'll see about dividing them up.  Though 99% seems to
be in generic kernel code (kernel/sched.c is by far the biggest user.)

There is one function pointer in a struct that would need an additional entry
if we keep both interfaces.

Thanks,
Mike
