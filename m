Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbYJVP3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbYJVP3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 11:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbYJVP2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 11:28:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52511 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbYJVP2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 11:28:51 -0400
Date: Wed, 22 Oct 2008 17:28:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 4/4] Implement semaphore latency tracer
Message-ID: <20081022152842.GI23060@elte.hu>
References: <1223817124-27239-1-git-send-email-edwintorok@gmail.com> <1223817124-27239-6-git-send-email-edwintorok@gmail.com> <1223838786.8634.8.camel@lappy.programming.kicks-ass.net> <48F259A7.2030800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48F259A7.2030800@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Török Edwin <edwintorok@gmail.com> wrote:

> On 2008-10-12 22:13, Peter Zijlstra wrote:
> > On Sun, 2008-10-12 at 16:12 +0300, Török Edwin wrote:
> >   
> >> Each time a down_read or down_write fails, a unique latency id is generated.
> >> Later when someone releases the semaphore, it is blamed for the latency of all
> >> tasks on the wait_list of the semaphore.
> >> If you would group the output from latency_trace by the latency_id you get all those
> >> who were contending on a lock, and the tasks that were holding the lock.
> >> An entry in latency_trace has the format:
> >> (latency_id) [semaphore_id] read|write
> >> stacktrace <= stacktrace
> >>     
> >
> > What can this tracer do that latencytop cannot already do?
> 
> Latencytop can show latencies in down_read or down_write (and is very
> useful at doing that), but it cannot show who else was holding the
> semaphore,
> i.e. the true cause of the latency.
> 
> Consider:
> process A holds a semaphore for reading, process B tries to acquire it
> for writing and fails. Latencytop shows the latency in process B, but
> doesn't
> show anything about process A.
> 
> The semlat tracer is doing something more similar to lockstat, but
> doesn't need lockdep, and it adds tracepoints on the slowpath only (lock
> failed, wakeup).

hm, but the most common synchronization primitive are mutexes - and 
those are not covered by your patchset.

	Ingo
