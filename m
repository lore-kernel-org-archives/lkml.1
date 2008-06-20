Return-Path: <linux-kernel-owner+w=401wt.eu-S1756313AbYFTNVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313AbYFTNVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 09:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbYFTNVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 09:21:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33347 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312AbYFTNVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 09:21:34 -0400
Date: Fri, 20 Jun 2008 15:21:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: Re: [BUG][PATCH -mm] avoid BUG() in __stop_machine_run()
Message-ID: <20080620132110.GB19740@elte.hu>
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org> <485A03E6.2090509@hitachi.com> <200806192012.44459.rusty@rustcorp.com.au> <485A806A.2090602@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485A806A.2090602@goop.org>
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

>> This simply introduces a flag to allow us to disable the capability 
>> checks for internal callers (this is simpler than splitting the 
>> sched_setscheduler() function, since it loops checking permissions).
>>   
> What about?
>
> int sched_setscheduler(struct task_struct *p, int policy,
> 		       struct sched_param *param)
> {
> 	return __sched_setscheduler(p, policy, param, true);
> }
>
>
> int sched_setscheduler_nocheck(struct task_struct *p, int policy,
> 		               struct sched_param *param)
> {
> 	return __sched_setscheduler(p, policy, param, false);
> }
>
>
> (With the appropriate transformation of sched_setscheduler -> __)
>
> Better than scattering stray true/falses around the code.

agreed - it would also be less intrusive on the API change side.

i've created a new tip/sched/new-API-sched_setscheduler topic for this 
to track it, but it would be nice to have a v2 of this patch that 
introduces the new API the way suggested by Jeremy. (Hence the new topic 
is auto-merged into tip/master but not into linux-next yet.) Thanks,

	Ingo
