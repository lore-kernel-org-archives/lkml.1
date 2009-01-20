Return-Path: <linux-kernel-owner+w=401wt.eu-S1760545AbZATL1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760545AbZATL1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 06:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757968AbZATL1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 06:27:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34724 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119AbZATL1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 06:27:05 -0500
Date: Tue, 20 Jan 2009 12:26:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       jeremy@xensource.com, chrisw@sous-sol.org, zach@vmware.com,
       rusty@rustcorp.com.au
Subject: Re: lmbench lat_mmap slowdown with CONFIG_PARAVIRT
Message-ID: <20090120112634.GA20858@elte.hu>
References: <20090120110542.GE19505@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120110542.GE19505@wotan.suse.de>
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


* Nick Piggin <npiggin@suse.de> wrote:

> Hi,
> 
> I'm looking at regressions since 2.6.16, and one is lat_mmap has slowed 
> down. On further investigation, a large part of this is not due to a 
> _regression_ as such, but the introduction of CONFIG_PARAVIRT=y.
> 
> Now, it is true that lat_mmap is basically a microbenchmark, however it 
> is exercising the memory mapping and page fault handler paths, so we're 
> talking about pretty important paths here. So I think it should be of 
> interest.
> 
> I've run the tests on a 2s8c AMD Barcelona system, binding the test to 
> CPU0, and running 100 times (stddev is a bit hard to bring down, and my 
> scripts needed 100 runs in order to pick up much smaller changes in the 
> results -- for CONFIG_PARAVIRT, just a couple of runs should show up the 
> problem).
> 
> Times I believe are in nanoseconds for lmbench, anyway lower is better.
> 
> non pv   AVG=464.22 STD=5.56
> paravirt AVG=502.87 STD=7.36
> 
> Nearly 10% performance drop here, which is quite a bit... hopefully 
> people are testing the speed of their PV implementations against non-PV 
> bare metal :)

Ouch, that looks unacceptably expensive. All the major distros turn 
CONFIG_PARAVIRT on. paravirt_ops was introduced in x86 with the express 
promise to have no measurable runtime overhead.

( And i suspect the real life mmap cost is probably even more expensive,
  as on a Barcelona all of lmbench fits into the cache hence we dont see
  any real $cache overhead. )

Jeremy, any ideas where this slowdown comes from and how it could be 
fixed?

	Ingo
