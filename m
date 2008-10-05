Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbYJEJvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbYJEJvu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 05:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbYJEJvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 05:51:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58551 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbYJEJvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 05:51:41 -0400
Date: Sun, 5 Oct 2008 11:51:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] fix printk format typo in boot ftracer.
Message-ID: <20081005095134.GC29909@elte.hu>
References: <20081004134227.465fa20c@infradead.org> <c62985530810041358p1cc361b1te89894cedcd7e3b3@mail.gmail.com> <20081004172449.58e53afd@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081004172449.58e53afd@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Sat, 4 Oct 2008 22:58:12 +0200
> "Frédéric Weisbecker" <fweisbec@gmail.com> wrote:
> 
> > > -               ret = trace_seq_printf(s, "[%5ld.%06ld] initcall %s
> > > "
> > > +               ret = trace_seq_printf(s, "[%5ld.%09ld] initcall %s
> > > " "returned %d after %lld msecs\n",
> > >                                          rettime.tv_sec,
> > >                                          rettime.tv_nsec,
> > 
> > I picked these formats from the printk.c time formatting. But you're
> > right, 09 would give us the whole nano precision.
> 
> it's more than precision, it's correctness.
> 
> doing "0.%02i" will do
> 0.100  if you pass it 100 and
> 0.10   if you pass it 10
> 
> and most off the time, except the first 0.1 seconds, you'll be passing
> it 9 digits, but the first 0.1 seconds.. the %06 will just give really
> incorrect results.

applied to tip/tracing/core, thanks!

	Ingo
