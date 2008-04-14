Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbYDNK1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbYDNK1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 06:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbYDNK0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 06:26:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45828 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbYDNK0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:26:51 -0400
Date: Mon, 14 Apr 2008 12:26:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Andrew <nick@nick-andrew.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       joe@perches.com
Subject: Re: [PATCH 2/2] printk: Remember the message level for multi-line
	output
Message-ID: <20080414102634.GA20649@elte.hu>
References: <20080413115152.29086.37845.stgit@marcab.local.tull.net> <20080413122735.31769.17716.stgit@marcab.local.tull.net> <20080414080351.GL16163@elte.hu> <20080414101200.GH29599@tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414101200.GH29599@tull.net>
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


* Nick Andrew <nick@nick-andrew.net> wrote:

> > i've applied this too for testing.
> > 
> > but multi-line strings are a bit unclean i think: each message line 
> > should have its separate printk.
> 
> You'd think. But there are a lot of calls to printk() with multi-line 
> format strings; developers clearly expect it to "just work" and that a 
> message level set at the start will be retained across lines.

ok :-)

> > will your patch leave the behavior of multiple calls to printk alone? 
> > I.e. if i do:
> > 
> >   printk(KERN_ALERT "Danger Will Robinson!\n");
> >   printk("Alien Approaching!\n");
> > 
> > then we'll still get a KERN_ALERT plus a default printk, right?
> 
> Yes, quite. The state of whether we're inside a line is retained 
> across calls to printk (from anywhere in the system) - this allows 
> code like this to usually do what you expect:
> 
> 	printk(KERN_ERR "Error:");
> 	for (i = 0; i < 16; ++i) {
> 		printk("  %02x", i);
> 	}
> 	printk("\n");
> 
> But in your example the first printk call contains a \n at the end of 
> the line and so upon entry to the second printk call the function 
> knows a new line is beginning.

ok - i think your change is a good one.

btw., we could also start emitting debug warnings that the printk is not 
conform. Something like:

  "INFO: the previous printk was done without a KERN_ annotation"

?

	Ingo

