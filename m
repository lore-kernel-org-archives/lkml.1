Return-Path: <linux-kernel-owner+w=401wt.eu-S1756247AbYFXVTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbYFXVTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbYFXVTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:19:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36311 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182AbYFXVTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:19:17 -0400
Date: Tue, 24 Jun 2008 23:15:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Adrian Bunk <bunk@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [Bug #10815] 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
Message-ID: <20080624211547.GB27452@elte.hu>
References: <alpine.LFD.1.10.0806151323101.2949@woody.linux-foundation.org> <20080615232754.GD17915@linux.vnet.ibm.com> <alpine.LFD.1.10.0806151633290.2949@woody.linux-foundation.org> <20080616030154.GA7445@martell.zuzino.mipt.ru> <20080616033126.GF17915@linux.vnet.ibm.com> <20080616034659.GA7600@martell.zuzino.mipt.ru> <20080617034228.GA18217@linux.vnet.ibm.com> <20080624005053.GA4827@martell.zuzino.mipt.ru> <20080624120404.GA7978@linux.vnet.ibm.com> <20080624210812.GA27486@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080624210812.GA27486@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> > >   Also Core 2 Duo, x86_64 [1]
> > > 
> > >   Race is wide -- 60 seconds of rcutorture is enough.
> 
> This is rcutorture by itself, or in parallel with LTP/kernbench?
> 
> (I have mostly been running on 4-CPU boxes without failure either way, 
> so will try a dual-CPU box.)

FYI, i've been running rcutorture for days on lots of testboxes ranging 
all across the x86 spectrum from single CPU, through dual-core, to 
dual-socket, dual-socket HT, 8-way and 16-way - both 32-bit and 64-bit 
x86.

Not a single failure has been detected in thousands of bootups of random 
kernels (rcu-preempt + rcutorture was a frequent combination tested). I 
added a WARN_ON() to rcutorture failures so it should show up very 
clearly.

This makes me suspect that it might be some special environment issue - 
gcc for example. I'm using gcc 4.2.2 on most of the testboxes.

	Ingo
