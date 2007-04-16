Return-Path: <linux-kernel-owner+w=401wt.eu-S1030455AbXDPLZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030455AbXDPLZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 07:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030449AbXDPLZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 07:25:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48007 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030455AbXDPLZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 07:25:06 -0400
Date: Mon, 16 Apr 2007 13:24:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Willy Tarreau <w@1wt.eu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jirislaby@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070416112440.GA20014@elte.hu>
References: <20070414172920.GA2433@1wt.eu> <m1647yn956.fsf@ebiederm.dsl.xmission.com> <20070414175433.GA17527@elte.hu> <20070414181854.GA5826@1wt.eu> <20070415175555.GA28524@elte.hu> <20070415180604.GA550@1wt.eu> <20070415192046.GA7504@elte.hu> <20070415193531.GD2986@holomorphy.com> <20070415195748.GA16004@elte.hu> <20070415235421.GF2986@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415235421.GF2986@holomorphy.com>
User-Agent: Mutt/1.4.2.2i
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


* William Lee Irwin III <wli@holomorphy.com> wrote:

> On Sun, Apr 15, 2007 at 09:57:48PM +0200, Ingo Molnar wrote:
> > Oh I was very much testing "CPU bandwidth allocation as influenced by 
> > nice numbers" - it's one of the basic things i do when modifying the 
> > scheduler. An automated tool, while nice (all automation is nice) 
> > wouldnt necessarily show such bugs though, because here too it needed 
> > thousands of running tasks to trigger in practice. Any volunteers? ;)
> 
> Worse comes to worse I might actually get around to doing it myself. 
> Any more detailed descriptions of the test for a rainy day?

the main complication here is that the handling of nice levels is still 
typically a 2nd or 3rd degree design factor when writing schedulers. The 
reason isnt carelessness, the reason is simply that users typically only 
care about a single nice level: the one that all tasks run under by 
default.

Also, often there's just one or two good ways to attack the problem 
within a given scheduler approach and the quality of nice levels often 
suffers under other, more important design factors like performance.

This means that for example for the vanilla scheduler the distribution 
of CPU power depends on HZ, on the number of tasks and on the scheduling 
pattern. The distribution of CPU power amongst nice levels is basically 
a function of _everything_. That makes any automated test pretty 
challenging. Both with SD and with CFS there's a good chance to actually 
formalize the meaning of nice levels, but i'd not go as far as to 
mandate any particular behavior by rigidly saying "pass this automated 
tool, else ...", other than "make nice levels resonable". All the other 
more formal CPU resource limitation techniques are then a matter of 
CKRM-alike patches, which offer much more finegrained mechanisms than 
pure nice levels anyway.

so to answer your question: it's pretty much freely defined. Make up 
your mind about it and figure out the ways how people use nice levels 
and think about which aspects of that experience are worth testing for 
intelligently.

	Ingo
