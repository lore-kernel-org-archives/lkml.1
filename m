Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbYKKKBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbYKKKBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 05:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbYKKKBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 05:01:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33049 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349AbYKKKBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 05:01:08 -0500
Date: Tue, 11 Nov 2008 11:00:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: adobriyan@gmail.com, kenchen@google.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch] add /proc/pid/stack to dump task's stack trace
Message-ID: <20081111100050.GA31766@elte.hu>
References: <20081107074147.GA26607@elte.hu> <20081107075925.GA1825@elte.hu> <20081107082003.GA15800@x200.localdomain> <20081107083249.GD4435@elte.hu> <20081107084943.GA16147@x200.localdomain> <20081107085352.GA27245@elte.hu> <20081107090304.GA30540@elte.hu> <20081107011659.98d3788a.akpm@linux-foundation.org> <20081107092902.GB7787@elte.hu> <20081110155410.be7552e3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081110155410.be7552e3.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 7 Nov 2008 10:29:02 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > I guess the 0400 mode on that file will suffice...
> > 
> > correct, 0400 is used already in the present patch:
> > 
> >  phoenix:~> cat /proc/1/stack
> >  cat: /proc/1/stack: Permission denied
> > 
> > but that is _not_ enough, it should be narrowed even more, to the 
> > boundaries that i pointed out in my first review feedback mail, and 
> > which is not implemented yet:
> > 
> >  1) only root should be allowed to do this - i.e. file needs to be 
> >     root-owned.
> > 
> >  2) there also needs to be a .config entry for folks to be able to
> >     turn it off altogether - just like folks can turn off sysrq-t 
> >     dumping via the .config.
> 
> Doing the above is desirable for another reason: given our rather 
> erratic history with the stack backtracer, this /proc file is 
> possibly a convenient way of oopsing the kernel, sending of off into 
> la-la-land, etc.

the stack tracer is rock-solid on x86 since Arjan started cleaning up 
the backtracing mess which we indeed had in x86 for years:

- adding frame-pointer support to 64-bit to improve the
  quality of stack-traces

- eliminating the broken and fragile dwarf2-unwinder

- expanding the use of the generic stacktrace infrastructure to
  lockdep, ftrace and other areas of code

if you know about any remaining fragility please holler, we havent had 
a backtracer induced oops for a long time :-)

	Ingo
