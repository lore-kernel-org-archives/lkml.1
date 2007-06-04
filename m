Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbXFDUYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbXFDUYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbXFDUYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:24:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57964 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbXFDUYQ (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:24:16 -0400
Date: Mon, 4 Jun 2007 22:24:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Morris <jmorris@namei.org>
Cc: Matt Mackall <mpm@selenic.com>, Rusty Russell <rusty@rustcorp.com.au>,
       akpm@linux-foundation.org, Linux-kernel@vger.kernel.org
Subject: Re: Interesting interaction between lguest and CFS
Message-ID: <20070604202405.GA27632@elte.hu>
References: <20070604173710.GR11166@waste.org> <20070604181151.GA1745@elte.hu> <Line.LNX.4.64.0706041613310.13341@d.namei>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Line.LNX.4.64.0706041613310.13341@d.namei>
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


* James Morris <jmorris@namei.org> wrote:

> On Mon, 4 Jun 2007, Ingo Molnar wrote:
> 
> > perhaps lguest does something unusual when it idles? Does it fiddle 
> > sched_clock() in any way?
> 
> One of the lguest processes calls nice(2), which seems like a long 
> shot, but also not impossibly related.  (Note that newer patches in 
> the lguest queue remove this, so it'll depend on exactly which patches 
> you have applied).

i've got 2.6.22-rc3-mm1's lguest (with a trivial boot-time crash fix in 
sched_clock that i ran into). But nice(2) should only cause a gentle, 
20% smaller CPU bandwidth to be allocated by CFS to that thread, nothing 
more drastic like user-visible delays.

	Ingo
