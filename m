Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbXFXUcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbXFXUcd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 16:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbXFXUcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 16:32:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44935 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbXFXUcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 16:32:24 -0400
Date: Sun, 24 Jun 2007 22:31:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch] CFS scheduler, -v18
Message-ID: <20070624203148.GA22571@elte.hu>
References: <20070622220202.GA16872@elte.hu> <20070623132418.GA32449@1wt.eu> <20070624155214.GA11978@elte.hu> <20070624170802.GA10976@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070624170802.GA10976@1wt.eu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Willy Tarreau <w@1wt.eu> wrote:

> > > I have no idea about what version brought that unexpected 
> > > behaviour, but it's clearly something which needs to be tracked 
> > > down.
> > 
> > hm, the two problems might be related. Could you try v17 perhaps? In 
> > v18 i have 'unified' all the sched.c's between the various kernel 
> > releases, maybe that brought in something unexpected on 2.6.20.14. 
> > (perhaps try v2.6.21.5 based cfs too?)
> 
> Well, forget this, I'm nuts. I'm sorry, but I did not set any of the 
> -R and -S parameter on ocbench, which means that all the processes ran 
> at full speed and did not sleep. The load distribution was not fair, 
> but since they put a lot of stress on the X server, I think it might 
> be one of the reasons for the unfairness. I got the same behaviour 
> with -v17, -v9 and even 2.4 ! It told me something was wrong on my 
> side ;-)
> 
> I've retried with 50%/50% run/sleep, and it now works like a charm. 
> It's perfectly smooth with both small and long run/sleep times 
> (between 1 and 100 ms). I think that with X saturated, it might 
> explain why I only had one CPU running at 100% !

ah, great! :-) My testbox needs a 90% / 10% ratio between sleep/run for 
an 8x8 matrix of ocbench tasks to not overload the X server. Once the 
overload happens X starts penalizing certain clients it finds abusive (i 
think), and that mechanism seems to be wall-clock based and it thus 
brings in alot of non-determinism and skews the clients.

	Ingo
