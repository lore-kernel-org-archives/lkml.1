Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751728AbYLROiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbYLROiU (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 09:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbYLROiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 09:38:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40729 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbYLROiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 09:38:04 -0500
Date: Thu, 18 Dec 2008 15:37:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>, rjw@sisk.pl, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
Subject: Re: [Bug #12208] uml is very slow on 2.6.28 host
Message-ID: <20081218143752.GB10548@elte.hu>
References: <u7kfEgp36eE.A.qpG.Y4_QJB@chimera> <T1gm2CtAHBF.A.u6G.g4_QJB@chimera> <E1LCO85-0000rR-Br@pomaz-ex.szeredi.hu> <1229397927.5296.48.camel@marge.simson.net> <E1LCX8h-0001sh-Uo@pomaz-ex.szeredi.hu> <1229437180.5379.76.camel@marge.simson.net> <E1LCbpI-0002MN-7R@pomaz-ex.szeredi.hu> <1229494628.5280.24.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229494628.5280.24.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> On Tue, 2008-12-16 at 16:27 +0100, Miklos Szeredi wrote:
> 
> > Is there a way to trace what is happening in the scheduler?
> 
> Sure.  Ingo has a script for gathering info (attached), if you run it, 
> please gzip up the output and send me a copy offline to eyeball.
> 
> There's also ftrace, but I've not tried that yet, so can't offer any 
> advice, I use primitive but effective time_after() + printk() with klogd 
> wakeup disabled (deadlock).

btw., there's a recent commit:

  32a7600: printk: make printk more robust by not allowing recursion

since then printk shouldnt deadlock anymore, even if called from within 
the scheduler.

Btw., ftrace_printk() can be used similarly (and you can capture it 
nonstop via /debug/tracing/trace_pipe), and should not deadlock either.

	Ingo
