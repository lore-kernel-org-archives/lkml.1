Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbZBWRhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbZBWRhg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 12:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbZBWRh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 12:37:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59553 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbZBWRh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 12:37:28 -0500
Date: Mon, 23 Feb 2009 18:37:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] tracing/ftrace: add missing wake-up on some callsites
Message-ID: <20090223173714.GA601@elte.hu>
References: <49a1cc8f.2283420a.54d2.ffff8461@mx.google.com> <alpine.DEB.2.00.0902231034570.18221@gandalf.stny.rr.com> <alpine.DEB.2.00.0902231039290.18221@gandalf.stny.rr.com> <20090223162630.GG5961@nowhere> <alpine.DEB.2.00.0902231151020.18221@gandalf.stny.rr.com> <20090223170528.GH5961@nowhere> <alpine.DEB.2.00.0902231211230.18221@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902231211230.18221@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
X-ACL-Warn: condition = 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > Which would send a delayed work to wake up?
> 
> No, I was thinking that trace_delay_wake_up() would be called 
> by these dangerous call sites. Then a per_cpu flag could be 
> set. We could have a trace point in the scheduler code that is 
> outside holding a runqueue lock, and this trace point would 
> call a trace function that will clear the per cpu flag, and 
> then call trace_wake_up().

No, that's very roundabout and ugly. If we putting a tracepoint 
there we might as well put real scheduler code there that looks 
for such a flag. But i'm not convinced we need a flag ...

	Ingo
