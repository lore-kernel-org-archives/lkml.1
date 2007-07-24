Return-Path: <linux-kernel-owner+w=401wt.eu-S1763664AbXGXSOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763664AbXGXSOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758108AbXGXSOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:14:05 -0400
Received: from CPE0050fc332afc-CM00407b861c34.cpe.net.cable.rogers.com ([74.120.60.167]:41550
	"EHLO nk-1124.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755998AbXGXSOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:14:04 -0400
X-Greylist: delayed 1636 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jul 2007 14:14:03 EDT
Message-ID: <46A63B04.7020302@tigershaunt.com>
Date: Tue, 24 Jul 2007 13:46:44 -0400
From: Rashkae <rashkae@tigershaunt.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20060913)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: ck@vds.kolivas.org, linux-kernel@vger.kernel.org
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>	<200707102015.44004.kernel@kolivas.org>	<9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>	<46A57068.3070701@yahoo.com.au>	<2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>	<46A58B49.3050508@yahoo.com.au> <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>
In-Reply-To: <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
>> However, if we can improve basic page reclaim where it is obviously
>> lacking, that is always preferable. eg: being a highly speculative
>> operation, swap prefetch is not great for power efficiency -- but we
>> still want laptop users to have a good experience as well, right?
>

Sounds like something that can be altered with a tuneable for workloads 
where power efficiency is more important than performance.

As far as performance goes, empty memory is wasted memory.  I think the 
most important 'measurement' people can make for swap prefetch, if this 
is even possible to capture, is a positive hit ratio.  Under everyman's 
typical workload, what percentage of pages prefetched end up being used? 
And what percentage end up discarded?  I'm pulling these numbers out of 
thin air, but I would say, if > 10% is referenced, and < 70% discarded, 
then that would be significant performance boost well worthwhile.


To be clear, I don't know what I'm talking about.  It just seems to me 
however, that debating whether or not to implement a performance boost 
because we can better tune corner cases is silly.  For as long as 
computers have used swap and unused memory, there will be a performance 
gain to background prefetching.  That doesn't preclude developers from 
tuning the specific workloads that lead to such.  It's not like this 
were a theoretical discussion of should we develop this or not.. 
Prefetch is here, now, and working.  The only questions I see are:

Does the performance gain from Prefetch compensate for the prefetch code 
memory requirements?

Is there someone who's comfortable with lkml politics willing to 
maintain the thing?
