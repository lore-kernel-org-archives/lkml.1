Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbZGJOQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbZGJOQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 10:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbZGJOQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 10:16:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56385 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbZGJOQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 10:16:32 -0400
Date: Fri, 10 Jul 2009 16:16:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] kernel.printk.c - ensure that "console
	enabled"messages are printed on the console
Message-ID: <20090710141618.GF26264@elte.hu>
References: <200907040017.26921.rgetz@blackfin.uclinux.org> <200907091308.37370.rgetz@blackfin.uclinux.org> <20090710102547.GD5499@elte.hu> <200907101013.56177.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907101013.56177.rgetz@blackfin.uclinux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robin Getz <rgetz@blackfin.uclinux.org> wrote:

> On Fri 10 Jul 2009 06:25, Ingo Molnar pondered:
> > 
> > * Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> > 
> > > From: Robin Getz <rgetz@blackfin.uclinux.org>
> > > 
> > > Today, when a console is registered without CON_PRINTBUFFER, end 
> > > users never see the announcement of it being added, and never know 
> > > if they missed something, if the console is really at the start or 
> > > not, and just leads to general confusion.
> > > 
> > > This re-orders existing code, to make sure the console is added, 
> > > before the "console [%s%d] enabled" is printed out - ensuring that 
> > > this message is _always_ seen.
> > > 
> > > This has the desired/intended side effect of making sure that 
> > > "console enabled:" messages are printed on the bootconsole, and 
> > > the real console. This does cause the same line is printed twice 
> > > if the bootconsole and real console are the same device, but if 
> > > they are on different devices, the message is printed to both 
> > > consoles.
> > > 
> > > Signed-off-by : Robin Getz <rgetz@blackfin.uclinux.org>
> > > 
> > > ---
> > > 
> > >  printk.c |   44 +++++++++++++++++++++++++++++---------------
> > >  1 file changed, 29 insertions(+), 15 deletions(-)
> > > 
> > > patch generated for -tip
> > 
> > Looks good, applied it to tip:core/printk for v2.6.32, thanks Robin. 
> > 
> > i fixed a couple of small details in the patch:
> > 
> >  - re-broke the commit log as it was too wide for nice git log 
> >    output
> 
> Hmm - I didn't know there was a restriction on this - what is the number?

I use:

autocmd BufNewFile,BufRead *.patch setlocal textwidth=60

in ~/.vimrc - i.e. 60 cols.

'git log' adds 4 leading spaces to commit messages and then if you 
look at it via a small terminal it can quickly wrap at the end, 
making the commit log harder to read.

Also, commit logs get quoted in emails and if we reply to that in up 
to a depth of 4, the colums do get eaten up quickly.

60 cols sounds like a reasonable compromise. There's no 'written' 
rule for this AFAIK, i just do it for all changes i commit, to 
increase commit quality.

	Ingo
