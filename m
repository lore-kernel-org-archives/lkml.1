Return-Path: <linux-kernel-owner+w=401wt.eu-S1750768AbYJ3T0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750768AbYJ3T0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756477AbYJ3T01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:26:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40537 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173AbYJ3T00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:26:26 -0400
Date: Thu, 30 Oct 2008 20:26:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Make ftrace able to trace function return
Message-ID: <20081030192621.GF27407@elte.hu>
References: <490A08E3.2040201@gmail.com> <20081030182056.GA14102@elte.hu> <c62985530810301130q41cc5c0ete2d7610d2172775@mail.gmail.com> <20081030183714.GA17822@elte.hu> <alpine.DEB.1.10.0810301447490.15853@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810301447490.15853@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> gcc -c -finstrument-functions traceme.c

> This is not 5 extra bytes but 27 extra bytes for a total of 32 bytes 
> at every function. Also note that this also adds these calls to 
> inline functions as well. We could easly stop that by adding 
> "notrace" to the inline define (which I've done).
> 
> But this would make the patching a bit more difficult (not 
> impossible). But it will bloat the image quite a bit.

yeah, i too knew it was expensive, but didnt realize it's this bloaty. 
It's a non-starter really.

How reliable can we make Frederic's trampoline approach? Especially 
with the opt-in function filters of dyn-ftrace, there's real value in 
the trampoline approach IMO (we could display real function cost, 
etc.), and the runtime cost should be OK as long we dont probe a ton 
of functions all the time. (and it's optional anyway)

	Ingo
