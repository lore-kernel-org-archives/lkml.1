Return-Path: <linux-kernel-owner+w=401wt.eu-S1763428AbXFEHKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763428AbXFEHKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 03:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762325AbXFEHKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 03:10:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47108 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762174AbXFEHKa (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 03:10:30 -0400
Date: Tue, 5 Jun 2007 09:10:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Matt Mackall <mpm@selenic.com>, akpm@linux-foundation.org,
       Linux-kernel@vger.kernel.org
Subject: Re: Interesting interaction between lguest and CFS
Message-ID: <20070605071011.GA25163@elte.hu>
References: <20070604173710.GR11166@waste.org> <1181002734.25878.56.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181002734.25878.56.camel@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> This sounds like the waker process (nice 19) not getting a chance to 
> run.  You can hack around it for the moment by changing "nice(19)" in 
> Documentation/lguest/lguest.c to something less aggressive.

even if the waker runs at nice+19, under CFS (which schedules 
deterministically) it should not be delayed by a single nice-0 task by 
more than ~70 msecs. That is a far cry from the 'seconds' that Matt saw 
- and the sched stats he sent look anomalous too. Also, i'm not able to 
reproduce it at all - while any nice+19 related problem should be 
readily reproducable on my box too. So my current take is that this is 
some sort of host-side CFS related problem and that the lguest host 
threads somehow were the first ones that managed to trigger it in some 
really bad way.

OTOH i do agree with your patch, that nice+19 thing is quite hacky :-)

	Ingo
