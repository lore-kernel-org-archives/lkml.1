Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbYKMJo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbYKMJo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 04:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbYKMJoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 04:44:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43392 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbYKMJoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 04:44:20 -0500
Date: Thu, 13 Nov 2008 10:44:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/function-return-tracer: Call
	prepare_ftrace_return by registers
Message-ID: <20081113094412.GL25479@elte.hu>
References: <491B4F63.3090909@gmail.com> <20081112221623.GB6125@elte.hu> <c62985530811121422w6d33de3cp506bdf1aa96efd81@mail.gmail.com> <alpine.DEB.1.10.0811121824380.21116@gandalf.stny.rr.com> <c62985530811121535t13a60c93y9e4c22e365ca1b34@mail.gmail.com> <alpine.DEB.1.10.0811121911340.30248@gandalf.stny.rr.com> <20081113085949.GG25479@elte.hu> <c62985530811130138v69b260dcy59adfba24afee0ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530811130138v69b260dcy59adfba24afee0ca@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/11/13 Ingo Molnar <mingo@elte.hu>:
> > hm, function-exit is a quite bad name i think that tells nothing to
> > the user. I like "function-cost tracer" because that tells the user
> > what it's all about in the end.
> >
> > Or perhaps we could name it the "callgraph" tracer? (as opposed to the
> > simpler function tracer which traces function entries) Note that we
> > could use the output to build function call coverage graphs.
> 
> But you can build a call graph with the function tracer, that what 
> does the script draw_trace.py in a bit loosely way for example.

yes, but not reliably so - there's no guaranteed callgraph structure. 
With entry tracing we have entry+parent events, but especially across 
longer callchains there's no truly guaranteed way to preserve the full 
graph.

> IMHO, function cost measurement or call graphs are particular uses 
> that can be made of this engine. You can also use it to trace 
> function return values for example.

yes. The mockup output has place for that.

> So perhaps naming it by thinking on the purpose it could be use at 
> most would be better that its "general" or "potential" purpose. I 
> don't know...

i suggested "full-function" tracer name before, but that sounds a bit 
quirky too.

Perhaps this should be the function-tracer, and the entry tracer would 
be the function-entry tracer?

	Ingo
