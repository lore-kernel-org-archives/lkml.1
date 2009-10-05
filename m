Return-Path: <linux-kernel-owner+w=401wt.eu-S932460AbZJEJ4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460AbZJEJ4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 05:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932440AbZJEJ4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 05:56:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60985 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932415AbZJEJ4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 05:56:36 -0400
Date: Mon, 5 Oct 2009 11:55:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, peterz@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] perf_core: provide a kernel-internal interface to
	get to performance counters
Message-ID: <20091005095543.GA4266@elte.hu>
References: <20090925122556.2f8bd939@infradead.org> <y0mhbuplmlr.fsf@fche.csb> <20090926183246.GA4141@in.ibm.com> <20090926204848.0b2b48d2@infradead.org> <20091001072518.GA1502@elte.hu> <20091001081616.GA3636@in.ibm.com> <20091001085330.GC15345@elte.hu> <20091004222838.GA5001@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091004222838.GA5001@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Can't we instead modify the perf events to be able to run on multiple 
> contexts?
> 
> We could change struct perf_event::ctx into a list of context and then 
> attach it to several cpu contexts.
> 
> The perf event struct have been designed to run on only one context so 
> its structure and handling does not deal with races due to concurrent 
> uses I guess. But at a first glance, few things would need to be 
> modified to handle that, and at a low cost.
> 
> There might be bad corner cases I forget though...

Dunno, i assumed it wouldnt be possible sanely. If you tried a patch we 
could argue about the particulars ...

This would in essence create a new event type: system-wide. It doesnt 
scale in its naive implementation - which would be fine for low freq 
events.

We could encode it via sys_perf_event_open(pid:-1, cpu:-1).

	Ingo
