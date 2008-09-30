Return-Path: <linux-kernel-owner+w=401wt.eu-S1752058AbYI3HC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbYI3HC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbYI3HCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:02:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36842 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbYI3HCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:02:18 -0400
Date: Tue, 30 Sep 2008 09:01:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Friesen <cfriesen@nortel.com>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       vatsa@linux.vnet.ibm.com, a.p.zijlstra@chello.nl
Subject: Re: [PATCH] sched: minor optimizations in wake_affine and
	select_task_rq_fair
Message-ID: <20080930070158.GA12465@elte.hu>
References: <20080929100227.GA21129@amitarora.in.ibm.com> <48E0FDC5.1080500@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E0FDC5.1080500@nortel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Friesen <cfriesen@nortel.com> wrote:

> Amit K. Arora wrote:
>> Hello,
>>
>> Please consider this patch. It makes a few minor changes to
>> sched_fair.c.
>>
>>
>> sched: Minor optimizations in wake_affine and select_task_rq_fair
>>
>> This patch does following:
>> o Reduces the number of arguments to wake_affine().
>
> At what point is it cheaper to pass items as args rather than 
> recalculating them?  If reducing the number of args is desirable, what 
> about removing the "this_cpu" and "prev_cpu" args and recalculating 
> them in wake_affine()?

it's usually not worth it, especially if it leads to duplicated 
calculations (and code) like:

+       unsigned int imbalance = 100 + (this_sd->imbalance_pct - 100) / 2;

gcc will optimize it away because it's all static functions, but still.

'size kernel/sched.o' should be a good guideline: if the .o's text 
section gets smaller due to a patch it usually gets faster as well.

	Ingo
