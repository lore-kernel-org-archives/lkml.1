Return-Path: <linux-kernel-owner+w=401wt.eu-S1751944AbZH1ST3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbZH1ST3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 14:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbZH1ST2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 14:19:28 -0400
Received: from www.tglx.de ([62.245.132.106]:59055 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbZH1ST1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 14:19:27 -0400
Date: Fri, 28 Aug 2009 20:19:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ashwin Chaugule <ashwinc@codeaurora.org>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [RFC] [PATCH 1/1] hrtimers: Cache next hrtimer
In-Reply-To: <4A98070D.1050308@codeaurora.org>
Message-ID: <alpine.LFD.2.00.0908282005410.19335@localhost.localdomain>
References: <4A96FFE9.6060105@codeaurora.org> <4A970103.7010804@codeaurora.org> <alpine.LFD.2.00.0908280045200.2888@localhost.localdomain> <4A971245.5070507@codeaurora.org> <alpine.LFD.2.00.0908280111260.2888@localhost.localdomain> <4A9771AA.2090004@codeaurora.org>
 <alpine.LFD.2.00.0908281308380.2888@localhost.localdomain> <4A98070D.1050308@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009, Ashwin Chaugule wrote:
> Thomas Gleixner wrote:
> Avg startup time 26.4 (10 runs) same as last run.
> 
> total_calls is again equal to cache_hits ... Its been a while since I wrote my
> patch. I'll need to look deeper to see if I've done something more. B)
> Just to make sure, I ran my patch again, I clearly see cache_hits is always
> less than total_calls.

Hmm. I'd really like to know why that's behaving different. 

Usually there are only timers in the CLOCK_MONOTONIC base during
boot. CLOCK_REALTIME base should be empty most of the time. If my
theory is correct then the number of reprogram events is correct as
well because base[MONOTONIC]->first is always the one which armed the
timer.

Can you add some debug which tells us to which base the removed timer
belongs ?

Thanks,

	tglx
