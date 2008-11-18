Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbYKRPxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbYKRPxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 10:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbYKRPw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 10:52:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43235 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbYKRPw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 10:52:58 -0500
Date: Tue, 18 Nov 2008 16:52:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: walimis <walimisdev@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ftrace: fix wrong pos computing when read buffer
	has been fulfilled.
Message-ID: <20081118155252.GA2852@elte.hu>
References: <1226733546-23190-1-git-send-email-walimisdev@gmail.com> <alpine.DEB.1.10.0811180933490.15003@gandalf.stny.rr.com> <20081118151721.GA23383@ubuntu.mshome.net> <alpine.DEB.1.10.0811181031200.15003@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811181031200.15003@gandalf.stny.rr.com>
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

> 
> On Tue, 18 Nov 2008, walimis wrote:
> > On Tue, Nov 18, 2008 at 09:36:07AM -0500, Steven Rostedt wrote:
> > >> 
> > >> fix:
> > >> 
> > >> Through checking return value of seq_printf, if less than 0, we know
> > >> this function doesn't be printed. Then we decrease position to force
> > >> this function to be printed next time, in next read buffer.
> > >
> > >A lot of the code for seq files I cut and paste from other places that I 
> > >have written it. The seq files always confuse me, so I like to use stuff 
> > >that worked before. Some of the things that walimis fixed were not needed 
> > >for this file, and was overkill.
> 
> > It also confuse me a lot. I also checked all places using seq files in
> > trace/ftrace code, to see whether there are similar problem.
> >   - trace.c: in s_start() it force pos to decrease one such as: 
> > 	l = *pos - 1;
> > 	so it works well.
> >   - trace_stack.c: t_start, in almost all cases, can be only called
> >     once, so we don't see the error. But I wonder whether it still works
> >     well if output message exceeds the size of seq file buffer and call
> >     t_start twice. If needed, I can test it.
> >   - trace_branch.c : the same with above.
> > 
> 
> If you can find a bug, then by all means, fix it ;-)

also, if you can think of a way to structure the code in a cleaner way 
to make such mistakes less likely to occur, feel free to change that 
too.

	Ingo
