Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbYKKRPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbYKKRPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 12:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbYKKRPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 12:15:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50005 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbYKKRPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 12:15:03 -0500
Date: Tue, 11 Nov 2008 18:14:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v3][PATCH 0/2] Make ftrace able to trace function return
Message-ID: <20081111171455.GA8201@elte.hu>
References: <49191C31.1050402@gmail.com> <20081111094312.GA16496@elte.hu> <c62985530811110730x13bc92abo891b49934ea2ae6f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530811110730x13bc92abo891b49934ea2ae6f@mail.gmail.com>
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

> >  2) i cleaned up the arch/x86/Kconfig impact:
> >
> >      f1c4be5: tracing, x86: clean up FUNCTION_RET_TRACER Kconfig
> 
> 
> Ok.
> And concerning the constraint fixed in assembly. That's strange my
> compiler didn't even warn me about it.

yep, that's common with assembly constraints - often the bugs will 
only trigger with certain compilers and with certain config options. 
Generally we've got enough variations of these parameters in -tip 
testing (randconfig plus multiple tools versions) to reliably trigger 
such issues.

> > So lets use "function_full" and "function" tracing perhaps? The 
> > "full" tracer is what traces both entry and exit points, and 
> > establishes full function-call timings/costs. The "function" 
> > tracer is more lightweight and traces function entry events.
> 
> Right. I first chose function_return but it was the largest tracer 
> name and so raised a bug that has been corrected since. And I kept 
> this confusing name.
>
> I'm not sure function_full is really the good one because it's not 
> really a full version of the function tracer. It doesn't do the same 
> thing: when you look into a trace done by the function tracer, the 
> functions appear in order of their call whereas with the function 
> return tracer, they appear in the order of their return which is not 
> the same. The effect is not the same. Why not function_return or 
> something like that?

at the risk of bikeshed-painting this issue too much, the problem with 
function_return is that it has little meaning to actual users and even 
to developers. What does the "return" mean? We know what it means, 
because we know that opposed to function entry we'll also capture 
function returns, and hence be able to do full function call tracing.

so function_full i thought to conduct this aspect of it better. But 
suggestions are welcome.

	Ingo
