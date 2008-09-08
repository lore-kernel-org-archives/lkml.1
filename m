Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbYIHPlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbYIHPlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbYIHPlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:41:10 -0400
Received: from relay1.sgi.com ([192.48.171.29]:60037 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751458AbYIHPlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:41:09 -0400
Message-ID: <48C54793.6000407@sgi.com>
Date: Mon, 08 Sep 2008 08:41:07 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jes Sorensen <jes@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, David Miller <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] smp: reduce stack requirements for	smp_call_function_mask
References: <20080905214019.821172000@polaris-admin.engr.sgi.com> <20080906132944.GC4910@elte.hu> <48C4F4F8.20105@sgi.com>
In-Reply-To: <48C4F4F8.20105@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jes Sorensen wrote:
> Ingo Molnar wrote:
>>> Applies to linux-2.6.tip/master (with FUZZ).
>>
>> applied to tip/cpus4096, thanks Mike.
>>
>> I'm still wondering whether we should get rid of non-reference based
>> cpumask_t altogether ...
> 
> Cool,
> 
> I think we should, it's like a ticking bomb waiting to explode on us
> eventually. IMHO it was a big mistake to allow cpumask_t being passed
> by value in the first place.
> 
> Cheers,
> Jes

Linus's idea of defining cpumask_t to be a simple long[1] or a pointer to
a cpumask is a good one.  Unfortunately, the amount (and breadth) of the
code changes required is daunting, to say the least.  In my source tree
there are 892 references to cpumask_t.

But I'll start looking into it asap.  I don't know however if "NR_CPUS >
BITS_PER_LONG" is the correct metric to decide when to use pointers.  There
must be a better "pain" indicator... ;-)

Thanks,
Mike
