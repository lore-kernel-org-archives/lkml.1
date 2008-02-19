Return-Path: <linux-kernel-owner+w=401wt.eu-S1762761AbYBSK1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762761AbYBSK1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 05:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937AbYBSK1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 05:27:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60246 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808AbYBSK1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 05:27:24 -0500
Date: Tue, 19 Feb 2008 11:27:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: Linux 2.6.25-rc2
Message-ID: <20080219102700.GC14092@elte.hu>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org> <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com> <20080219061107.GA23229@elte.hu> <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com> <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Mathieu, Christoph is on vacation and I'm not at all that familiar 
> with this cmpxchg_local() optimization, so if you could take a peek at 
> this bug report to see if you can spot something obviously wrong with 
> it, I would much appreciate that.

hm, it's bad for at least one other reason as well (which is probably 
unrelated to this crash):

 /*
  * Currently fastpath is not supported if preemption is enabled.
  */
 #if defined(CONFIG_FAST_CMPXCHG_LOCAL) && !defined(CONFIG_PREEMPT)
 #define SLUB_FASTPATH
 #endif

such !PREEMPT exceptions tend to show "i didnt want to think too hard 
about the preemptible case so just turn it off" thinking.

Also, why isnt this "SLUB_FASTPATH" flag done in the Kconfig space?

	Ingo
