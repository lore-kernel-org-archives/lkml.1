Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbYKRR12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbYKRR12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 12:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbYKRR1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 12:27:20 -0500
Received: from smtp-out.google.com ([216.239.45.13]:55476 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbYKRR1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 12:27:19 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=Eoz7mxBZn9GNJk3mwdDeiPcCU/CJhd22bkfcuWN2fT+8Gt2br+GvLQPLALPBnSFt2
	pAy+BhffyPOnGL167jbIw==
MIME-Version: 1.0
In-Reply-To: <1227011444.29743.15.camel@lappy.programming.kicks-ass.net>
References: <20081115011452.GA28135@google.com> <49218FB4.6090805@nortel.com>
	 <b040c32a0811171204p4ce6d706j3ee2c018d0f33548@mail.gmail.com>
	 <4921DFD8.9060509@nortel.com>
	 <1226985548.29743.6.camel@lappy.programming.kicks-ass.net>
	 <b040c32a0811172333k5a89ccfy6438bf66d32dca5d@mail.gmail.com>
	 <1227011444.29743.15.camel@lappy.programming.kicks-ass.net>
Date: Tue, 18 Nov 2008 09:27:14 -0800
Message-ID: <b040c32a0811180927r77e0a112s97a01d20d3cbe3d5@mail.gmail.com>
Subject: Re: busted CFS group load balancer?
From: Ken Chen <kenchen@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Friesen <cfriesen@nortel.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2008 at 4:30 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> I'm also very troubled with this calculation in __update_group_shares_cpu():
>>
>>         shares = (sd_shares * rq_weight) / (sd_rq_weight + 1);
>>
>> Won't you have rounding problem here?  value 'shares' will gradually
>> decrease for each iteration of __update_group_shares_cpu()?
>
> Yes it will, however at the top of the sched-domain tree its reset.
>
>        if (!sd->parent || !(sd->parent->flags & SD_LOAD_BALANCE))
>                shares = tg->shares;

Hmm?  it is only true mostly on flat smp machine, or on numa system
where task is woken up across a sched-domain.

There is this code in try_to_wake_up():

                for_each_domain(this_cpu, sd) {
                        if (cpu_isset(cpu, sd->span)) {
                                update_shares(sd);
                                break;
                        }
                }

It doesn't iterate to the top half of the time on numa machine.

- Ken
