Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbXDNQTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbXDNQTl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 12:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbXDNQTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 12:19:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33619 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845AbXDNQTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 12:19:40 -0400
Date: Sat, 14 Apr 2007 18:19:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070414161927.GD3099@elte.hu>
References: <20070413202100.GA9957@elte.hu> <20070414020424.GB14544@wotan.suse.de> <20070414063254.GB14875@elte.hu> <20070414064334.GA19463@elte.hu> <20070414080833.GL943@1wt.eu> <20070414083625.GM943@1wt.eu> <20070414105338.GB19454@elte.hu> <20070414130101.GA2538@1wt.eu> <20070414132732.GA22103@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070414132732.GA22103@1wt.eu>
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


* Willy Tarreau <w@1wt.eu> wrote:

> On Sat, Apr 14, 2007 at 03:01:01PM +0200, Willy Tarreau wrote:
> > 
> > Well, I'll stop heating the room for now as I get out of ideas about how
> > to defeat it.
> 
> Ah, I found something nasty.
> If I start large batches of processes like this :
> 
> $ for i in $(seq 1 1000); do ./scheddos2 4000 4000 & done
> 
> the ramp up slows down after 700-800 processes, but something very 
> strange happens. If I'm under X, I can switch the focus to all xterms 
> (the WM is still alive) but all xterms are frozen. On the console, 
> after one moment I simply cannot switch to another VT anymore while I 
> can still start commands locally. But "chvt 2" simply blocks. SysRq-K 
> killed everything and restored full control. Dmesg shows lots of :

> SAK: killed process xxxx (scheddos2): process_session(p)==tty->session.
> 
> I wonder if part of the problem would be too many processes bound to 
> the same tty :-/

hm, that's really weird. I've Cc:-ed the tty experts (Erik, Jiri, Alan), 
maybe this description rings a bell with them?

	Ingo
