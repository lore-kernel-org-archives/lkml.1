Return-Path: <linux-kernel-owner+w=401wt.eu-S1755793AbZA0N0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbZA0N0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 08:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbZA0N0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 08:26:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57148 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbZA0N0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 08:26:42 -0500
Date: Tue, 27 Jan 2009 14:26:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mandeep Singh Baines <msb@google.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       rientjes@google.com, mbligh@google.com, thockin@google.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4] softlockup: remove hung_task_check_count
Message-ID: <20090127132626.GH23121@elte.hu>
References: <1232991701.4863.222.camel@laptop> <20090127003055.GA21269@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090127003055.GA21269@google.com>
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


* Mandeep Singh Baines <msb@google.com> wrote:

> The design was proposed by Frédéric Weisbecker. Peter Zijlstra suggested 
> the use of RCU.

ok, this looks _much_ cleaner.

One question:

> -	read_lock(&tasklist_lock);
> +	rcu_read_lock();
>  	do_each_thread(g, t) {
> -		if (!--max_count)
> +		if (need_resched())
>  			goto unlock;

Isnt it dangerous to skip a check just because we got marked for 
reschedule? Since it runs so rarely it could by accident be preempted and 
we'd not get any checking done for a long time.

	Ingo
