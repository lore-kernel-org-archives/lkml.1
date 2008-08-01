Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbYHAJJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbYHAJJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 05:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbYHAJJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 05:09:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52184 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbYHAJJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 05:09:24 -0400
Date: Fri, 1 Aug 2008 11:09:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86: implement multiple queues for smp function
	call IPIs
Message-ID: <20080801090910.GA3282@elte.hu>
References: <488FA8A9.6000005@goop.org> <20080731220825.GD23801@elte.hu> <48923B7A.3020805@goop.org> <20080731224202.GB22426@elte.hu> <4892980A.2010101@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4892980A.2010101@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> Yes on the 64-bit side we've had NUM_INVALIDATE_TLB_VECTORS (==8) for a 
>> long time, but note that 64-bit is obviously for more modern CPUs. What 
>> i'm mindful about (i'm not _that_ worried) are fragile APICs and 
>> unknown erratas.
>>   
>
> Well, the whole exercise is only useful if you have a relatively large 
> number of CPUs, which presumably means you have relatively modern 
> APICs.  If we set the number of queues to 1 for < 4 CPUs, would that 
> avoid the problem APICs?

hm, but such special casing would reduce testing exposure and would also 
needlessly penalize boxes that work perfectly fine.

So ... how about my original suggestion, to add a (default-off) boot 
option that reduces the queues to 1? I.e. lets have something in place 
from day 1 on that could be quirk-handler-driven, should the need arise. 
"apic=simpleipi" or something like that.

In a year or two, once this all has proven itself fine on a broad range 
of systems, we'll laugh out loud at being so cautious and can remove the 
boot option for good ;-)

	Ingo
