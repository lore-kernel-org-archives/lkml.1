Return-Path: <linux-kernel-owner+w=401wt.eu-S1422891AbXBANyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422891AbXBANyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 08:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422894AbXBANye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 08:54:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41562 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422886AbXBANyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 08:54:17 -0500
Date: Thu, 1 Feb 2007 14:52:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>, Zach Brown <zach.brown@oracle.com>,
       linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Message-ID: <20070201135215.GA23477@elte.hu>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu> <20070201130234.GA15257@elte.hu> <20070201131903.GA24683@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070201131903.GA24683@infradead.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.3 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4495]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> I tend to agree.  Note that there is one thing we should be doing one 
> one day (not only if we want to use it for aio) is to make kernel 
> threads more lightweight.  There a lot of baggae we keep around in 
> task_struct and co that only makes sense for threads that have a user 
> space part and aren't or shouldn't be needed for a purely 
> kernel-resistant thread.

yeah. I'm totally open to such efforts. I'd also be most happy if this 
was primarily driven via the KAIO effort: i.e. to implement it via 
kernel threads and then to benchmark the hell out of it. I volunteer to 
fix whatever fat kernel thread handling has left.

and if people agree with me that 'native' state-machine driven KAIO is 
where we want to ultimately achieve (it is certainly the best performing 
implementation) then i dont see the point in fibrils as an interim 
mechanism anyway. Lets just hide AIO complexities from userspace via 
kernel threads, and optimize this via two methods: by making kernel 
threads faster, and by simultaneously and gradually converting as much 
KAIO code to a native state machine - which would not need any kind of 
kernel thread help anyway.

(plus as i mentioned previously, co-scheduling kernel threads with 
related user space threads on the same CPU might be something useful too 
- not just for KAIO, and we could add that too.)

also, we context-switch kernel threads in 350 nsecs on current hardware 
and the -rt kernel is certainly happy with that and runs all hardirqs 
and softirqs in separate kernel thread contexts. There's not /that/ much 
fat left to cut off - and if there's something more to optimize there 
then there are a good number of projects interested in that, not just 
the KAIO effort :)

	Ingo
