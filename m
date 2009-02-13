Return-Path: <linux-kernel-owner+w=401wt.eu-S1760381AbZBMSFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760381AbZBMSFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 13:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbZBMSFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 13:05:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50034 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbZBMSFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 13:05:45 -0500
Date: Fri, 13 Feb 2009 19:05:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@suse.de>,
       akpm <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: irq-disabled vs vmap vs text_poke
Message-ID: <20090213180513.GC18581@elte.hu>
References: <1234529407.6519.28.camel@twins> <20090213125505.GE18462@wotan.suse.de> <1234530138.6519.38.camel@twins> <20090213130450.GB9346@elte.hu> <20090213142521.GB31922@Krystal> <1234535626.6519.113.camel@twins> <20090213144346.GA857@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213144346.GA857@Krystal>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Peter Zijlstra (peterz@infradead.org) wrote:
> > On Fri, 2009-02-13 at 09:25 -0500, Mathieu Desnoyers wrote:
> > > * Ingo Molnar (mingo@elte.hu) wrote:
> > > > 
> > > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > > 
> > > > > > I think I got a mostly working patch cobbled together sitting here
> > > > > > somewhere. I was waiting for some _really_ good use case before spending
> > > > > > more time on it. I would prefer if at all possible to do vmap operations
> > > > > > in sleepable, process context.
> > > > > 
> > > > > Agreed, I think we want to fix text_poke() and make the vmap/vunmap()
> > > > > ops yell louder at violations of these rules.
> > > > > 
> > > > > I'm just totally clueless wrt text_poke() hence this email ;-)
> > > > 
> > > > also, this started triggering yesterday for the first time - and never
> > > > saw it before. Has some commit caused this side-effect?
> > > > 
> > > > It triggers during kprobes self-test - has that been improved recently?
> > > > 
> > > 
> > > When is this self-test run ? If it's at early boot while still in UP
> > > with interrupts off, kprobes should probably use text_poke_early()
> > > rather than text_poke().
> > 
> > Looking at the dmesg it looks to be post smp-init, so its late init
> > calls.
> > 
> > I think its the do_initcalls() from do_basic_setup(). So the machine
> > should be mostly up and running.
> 
> Here with 2.6.29-rc4 (commit 8e4921515c1a379539607eb443d51c30f4f7f338).
> I don't seem to get any warning with a might_sleep() in text_poke.
> 
> Kprobe smoke test started
> Kprobe smoke test passed successfully

it doesnt always trigger. It triggers on a box that also generates a
lot of NMIs - maybe there's a connection?

	Ingo
