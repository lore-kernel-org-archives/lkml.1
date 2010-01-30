Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799Ab0A3I47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab0A3I47 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 03:56:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620Ab0A3I47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 03:56:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:56728 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab0A3I46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 03:56:58 -0500
Subject: Re: [PATCH] perf_events: improve x86 event scheduling (v6 
 incremental)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: eranian@gmail.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net
In-Reply-To: <bd4cb8901001291508w421898c2u8e8e7de32b030e67@mail.gmail.com>
References: <4b588464.1818d00a.4456.383b@mx.google.com>
	 <1264192074.4283.1602.camel@laptop>
	 <7c86c4471001250912l47aa53dfw2c056e3a4733271e@mail.gmail.com>
	 <1264440342.4283.1936.camel@laptop>
	 <7c86c4471001250948t2c1b06ebx2e70f30f45c81aad@mail.gmail.com>
	 <1264442381.4283.1944.camel@laptop>
	 <bd4cb8901001291508w421898c2u8e8e7de32b030e67@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Jan 2010 09:56:39 +0100
Message-ID: <1264841799.24455.66.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-30 at 00:08 +0100, Stephane Eranian wrote:
> I think there is a problem with this following code:
> 
> void hw_perf_enable(void)
>                 for (i = 0; i < cpuc->n_events; i++) {
> 
>                         event = cpuc->event_list[i];
>                         hwc = &event->hw;
> 
>                         if (hwc->idx == -1 || hwc->idx == cpuc->assign[i])
>                                 continue;
> 
> Here you are looking for events which are moving. I think the 2nd
> part of the if is not good enough. It is not because hwc->idx is
> identical to the assignment, that you can assume the event was
> already there. It may have been there in the past, then scheduled
> out and replaced at idx by another event. When it comes back,
> it gets its spot back, but it needs to be reprogrammed.
> 
> That is why in v6 incremental, I have added last_cpu, last_tag
> to have a stronger checks and match_prev_assignment().
> 
> Somehow it is missing in the series you've committed unless
> I am missing something.

Right, that went missing because I was assuming that was for the
optimization of reducing to one loop. And since I didn't see that one
loop version work I left that part out.

(The risk of doing more than one thing in one patch)

Still, shouldn't be hard to correct, I'll look at doing a patch for this
on monday, unless you beat me to it :-)

