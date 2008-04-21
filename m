Return-Path: <linux-kernel-owner+w=401wt.eu-S1761384AbYDUONS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761384AbYDUONS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 10:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757154AbYDUONK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 10:13:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42707 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756578AbYDUONJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 10:13:09 -0400
Date: Mon, 21 Apr 2008 16:12:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Wessel <jason.wessel@windriver.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kgdb: core
Message-ID: <20080421141252.GR9554@elte.hu>
References: <200804181741.m3IHfTeC012089@hera.kernel.org> <20080418150930.476ea7aa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418150930.476ea7aa.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > +/*
> > + *	kgdb_skipexception - Bail out of KGDB when we've been triggered.
> > + *	@exception: Exception vector number
> > + *	@regs: Current &struct pt_regs.
> > + *
> > + *	On some architectures we need to skip a breakpoint exception when
> > + *	it occurs after a breakpoint has been removed.
> > + */
> > +extern int kgdb_skipexception(int exception, struct pt_regs *regs);
> 
> Please just nuke all the interface comments in the header files.  They 
> duplicate the kernedoc comments at the definition site and we don't 
> want to have to update both versions whenever we change something.

well that way we'll have to update _all_ arch versions whenever we 
change something - while the reference prototype in kgdb.h should all 
cover it. Do we really want to do that?

> > +/*
> > + * Functions each KGDB-supporting architecture must provide:
> > + */
> > +
> > +/*
> > + *	kgdb_arch_init - Perform any architecture specific initalization.
> > + *
> > + *	This function will handle the initalization of any architecture
> > + *	specific callbacks.
> > + */
> > +extern int kgdb_arch_init(void);
> 
> Well, these are trickier because there is an implementation of this 
> function within each architecture.  So I think that in this case it 
> _does_ make sense to document the function in a common place, and the 
> only common place is this header file.
> 
> So please
> 
> a) make this a kerneldoc comment and
> 
> b) remove the kerneldoc at the definition site(s).
> 
> (alternative: teach the kerneldoc system to go fishing in the various 
> arch directories to find the appropriate documentation, but I don't 
> know enough about kerneldoc to be able say anything about that).

well there's lkml feedback ping-pong effect here. It was pointed out in 
earlier kgdb review that it's an "error" to put kerneldoc into header 
files. I pointed out that it makes no sense to do otherwise but removed 
the kerneldoc annotation to resolve the "objection".

> This should become a kernedoc comment, as this is the only place we 
> can document it.  So please add the leading /**

same deal - it was objected to in review.

> > +static const char	hexchars[] = "0123456789abcdef";
> > +
> > +static int hex(char ch)
> > +{
> > +	if ((ch >= 'a') && (ch <= 'f'))
> > +		return ch - 'a' + 10;
> > +	if ((ch >= '0') && (ch <= '9'))
> > +		return ch - '0';
> > +	if ((ch >= 'A') && (ch <= 'F'))
> > +		return ch - 'A' + 10;
> > +	return -1;
> > +}
> 
> How many are we up to now?
> 
> akpm:/usr/src/linux-2.6.25> grep -ri '"0123456789abcdef"' . | wc -l
> 40
> 
> lol.

okay, hex_asc() it should use. Probably KGDB's code predates that of 
kernel.h though ;-)

> Nice-looking code - kgb has improved rather a lot.  I'm glad we 
> finally got it in.  [...]

thanks :)

> [...] Maybe one day I'll get to use it again :(

/me duly notes this request to break Andrew's systems even more frequently ;-)

	Ingo
