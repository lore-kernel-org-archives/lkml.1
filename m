Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbZETHxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbZETHxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbZETHxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:53:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59052 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658AbZETHxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:53:34 -0400
Date: Wed, 20 May 2009 09:53:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Knoblauch <spamtrap@knobisoft.de>, Matt Mackall <mpm@selenic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Rgeression: 2.6.30-rc6-git3 build error - ICE from
	drivers/char/random.c
Message-ID: <20090520075318.GA23959@elte.hu>
References: <688406.16641.qm@web32603.mail.mud.yahoo.com> <20090518203420.GF2658@calx> <alpine.LFD.2.01.0905181506550.3301@localhost.localdomain> <231530.33013.qm@web32601.mail.mud.yahoo.com> <alpine.LFD.2.01.0905190745230.3301@localhost.localdomain> <950448.6018.qm@web32607.mail.mud.yahoo.com> <alpine.LFD.2.01.0905191055410.3301@localhost.localdomain> <alpine.LFD.2.01.0905191122320.3301@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0905191122320.3301@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 19 May 2009, Linus Torvalds wrote:
> > 
> > I guess getting rid of 'jiffies' is also worth it. Even at its very worst, 
> > 'get_cycles()' should return jiffy-level information, so adding in jiffies 
> > doesn't add anything to it.
> 
> I take that back. If there isno TSC at all, "get_cycles()" might 
> just be returning zero. So the jiffies fallback is probably better 
> than nothing.
> 
> So I'll just remove the (long)&ret part. [...]

I suspect we could add current_thread_info() or 'current' to it - as 
they are initialized variables. (which the stack pointer mostly 
boils down to - the stack depth is predictable)

Not worth the trouble though i suspect.

	Ingo
