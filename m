Return-Path: <linux-kernel-owner+w=401wt.eu-S1759408AbZEKUwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408AbZEKUwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 16:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbZEKUw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 16:52:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48492 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbZEKUw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 16:52:29 -0400
Date: Mon, 11 May 2009 22:51:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>, roland@redhat.com
Subject: Re: [PATCH 1/2 v2] kernel/{sched,smp}.c: fix static decl prior to
	struct declaration
Message-ID: <20090511205118.GB7737@elte.hu>
References: <20090508184838.GA11157@havoc.gtf.org> <20090508193841.GA13831@havoc.gtf.org> <20090511112648.GA27226@elte.hu> <4A08852E.4010504@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A08852E.4010504@garzik.org>
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


* Jeff Garzik <jeff@garzik.org> wrote:

> Ingo Molnar wrote:
>> -tip testing found this build bug:
>>
>> kernel/sched.c: In function ‘root_task_group_empty’:
>> kernel/sched.c:312: error: ‘root_task_group’ undeclared (first use in this function)
>> kernel/sched.c:312: error: (Each undeclared identifier is reported only once
>> kernel/sched.c:312: error: for each function it appears in.)
>>
>> config attached.
>
> Fixed and resent.

Thanks.

> What a rat's nest of ifdefs! [...]

I warned you :)

> [...]  root_task_group is outside CONFIG_USER_SCHED, and so I kept 
> that property in patch v3.
>
> However, its definition in kernel/sched.h is conditional on 
> CONFIG_USER_SCHED, even though root_task_group_empty() may exist 
> outside of CONFIG_USER_SCHED, and root_task_group is referenced vi 
> CONFIG_FAIR_GROUP_SCHED || CONFIG_RT_GROUP_SCHED.
>
> Starting to wish I had never patched this code in the first place 
> (that barb is directed at the code, not you...)

How would you fix it? People dont like the idea of unconditional 
group scheduler, so we cannot remove the variability really.

	Ingo
