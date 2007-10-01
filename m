Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbXJATKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbXJATKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 15:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbXJATKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 15:10:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54119 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbXJATKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 15:10:23 -0400
Date: Mon, 1 Oct 2007 21:09:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Jarek Poplawski <jarkao2@o2.pl>, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Schwartz <davids@webmaster.com>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Martin Michlmayr <tbm@cyrius.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: iperf yield usage
Message-ID: <20071001190932.GA9302@elte.hu>
References: <20070926133138.GA23187@elte.hu> <20070927133123.GA6901@elte.hu> <20070927144228.GC2431@ff.dom.local> <200709281610.00682.nickpiggin@yahoo.com.au> <20071001084356.GA1866@ff.dom.local> <20071001162507.GA22791@elte.hu> <47012696.2010606@nortel.com> <20071001170903.GA2492@elte.hu> <4701323F.3000500@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4701323F.3000500@nortel.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Friesen <cfriesen@nortel.com> wrote:

> >See the background and answers to that in:
> >
> >   http://lkml.org/lkml/2007/9/19/357
> >   http://lkml.org/lkml/2007/9/19/328
> >
> >there's plenty of recourse possible to all possible kinds of apps. 
> >Tune the sysctl flag in one direction or another, depending on which 
> >behavior the app is expecting.
> 
> Yeah, I read those threads.
> 
> It seems like the fundamental source of the disconnect is that the 
> tasks used to be sorted by priority (thus making it easy to bump a 
> yielding task to the end of that priority level) while now they're 
> organized by time (making it harder to do anything priority-based).  
> Do I have that right?

not really - the old yield implementation in essence gave the task a 
time hit too, because we rotated through tasks based on timeslices. But 
the old one requeued yield-ing tasks to the 'active array', and the 
decision whether a task is in the active or in the expired array was a 
totally stohastic, load-dependent thing. As a result, certain tasks, 
under certain workloads saw a "stronger" yield, other tasks saw a 
"weaker" yield. (The reason for that implementation was simple: yield 
was (and is) unimportant and it was implemented in the most 
straightforward way that caused no overhead anywhere else in the 
scheduler.)

( and to keep perspective it's also important to correct the subject
  line here: it's not about "network slowdown" - nothing in networking
  slowed down in any way - it was that iperf used yield in a horrible
  way. I changed the subject line to reflect that. )

	Ingo
