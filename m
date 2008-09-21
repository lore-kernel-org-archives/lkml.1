Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025AbYIUHKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbYIUHKZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 03:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYIUHKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 03:10:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35325 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbYIUHKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 03:10:13 -0400
Date: Sun, 21 Sep 2008 09:09:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       astarikovskiy@suse.de
Subject: Re: Reading EeePC900 battery info causes stalls
Message-ID: <20080921070952.GA27307@elte.hu>
References: <fa.XLGLzP+T4fm9CkeATkS1VL/Yz4Q@ifi.uio.no> <fa.z8sKLpwDO3qQ15ZJIm152YEty4I@ifi.uio.no> <fa.KyW7dWWjiSFnFxwdZZLurmVn8qA@ifi.uio.no> <48D4CC1B.7030708@yahoo.com> <alpine.DEB.1.10.0809200955360.12824@gandalf.stny.rr.com> <48D50498.5050608@yahoo.com> <alpine.DEB.1.10.0809201037070.13540@gandalf.stny.rr.com> <48D52FE3.6060803@yahoo.com> <alpine.DEB.1.10.0809201739170.18130@gandalf.stny.rr.com> <48D584D4.7070002@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D584D4.7070002@yahoo.com>
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


* Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> Dagnabit I keep confusing people. This was actually intentional 
> because I wanted to know whether the latency I was seeing should have 
> been present in a non-preempt (but voluntary) kernel. You can see the 
> subject at that start of this thread: http://tinyurl.com/4akxa5 (How 
> how latent should non-preemptive scheduling be?). I'm not running a 
> sound studio where I need the lowest possible latency at all costs. 
> Further my current understanding is that the desktop distros don't 
> tend to ship "regular desktop kernels" with preemption (I know Ubuntu 
> 8.04 and Fedora 9 didn't).
>
> Basically I have the following queries: Do you have to have preemption 
> on if you are listening to music (without noticeable skips) and 
> playing the odd game (without noticeable pauses) on a desktop? What's 
> the allowed highest latency going to be over a few minutes in such 
> kernels?  Is it simply the case that if it's a non-preemptive kernel 
> latency no longer matters?

milliseconds of stalls is definitely excessive under a non-preempt 
kernel - and you have up to 500 msecs of stalls, right?

The simplest way you can fix such latencies is to look at the function 
trace, figure out which loop in the kernel takes so long to execute, and 
add a cond_resched() call to it. [there are other situations where a 
more complicated fix is needed, but this seems like a simpler scenario.]

	Ingo
