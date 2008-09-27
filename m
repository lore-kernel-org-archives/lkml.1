Return-Path: <linux-kernel-owner+w=401wt.eu-S1757165AbYI0Rwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165AbYI0Rwk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbYI0RsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:48:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47159 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755749AbYI0RsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:48:03 -0400
Date: Sat, 27 Sep 2008 19:47:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch -tip 3/3] Tracing/ftrace: Don't consume entries
	unhandled by mmiotrace
Message-ID: <20080927174756.GF26047@elte.hu>
References: <48DB8408.7080408@gmail.com> <20080925173435.5f525557@daedalus.pq.iki.fi> <c62985530809250744t3ce0011ajebd8343eb748cf24@mail.gmail.com> <20080925183608.283babfb@daedalus.pq.iki.fi> <c62985530809250913q227a5876k19b1b0ec591ad3cd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530809250913q227a5876k19b1b0ec591ad3cd@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/9/25 Pekka Paalanen <pq@iki.fi>:
> > We can (must) return to this if/when multiple tracers are allowed
> > to be active simultaneously. But in the current situation, I do not
> > see a way to trace more than one thing, but I haven't really looked
> > into the other tracers.
> 
> You can enable another tracer simultaneously. I never tried it but you 
> can launch one from debugfs and another from kernel code for example. 
> The new boot tracer will have to launch the sched_switch tracer.

hm, right now i can see a lot of problems with that approach - the 
buffers are partly per tracer and partly global.

the new trace-ringbuffer design Steve is working on would abstract away 
this complication - then we could make tracers truly independent 
entities.

	Ingo
