Return-Path: <linux-kernel-owner+w=401wt.eu-S932121AbZACWod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121AbZACWod (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 17:44:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755979AbZACWoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 17:44:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36392 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbZACWoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 17:44:24 -0500
Date: Sat, 3 Jan 2009 23:44:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] stackprotector re-enabling patches
Message-ID: <20090103224408.GC17047@elte.hu>
References: <20090103214353.GA22949@elte.hu> <20090103135513.20f14f1d@infradead.org> <20090103143455.4c23d243@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090103143455.4c23d243@infradead.org>
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

> On Sat, 3 Jan 2009 13:55:13 -0800
> Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > On Sat, 3 Jan 2009 22:43:53 +0100
> > Ingo Molnar <mingo@elte.hu> wrote:
> > >  
> > > diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> > > index 10d6cc3..28f1114 100644
> > > --- a/arch/x86/Kconfig.debug
> > > +++ b/arch/x86/Kconfig.debug
> > > @@ -117,6 +117,7 @@ config DEBUG_RODATA
> > >  config DEBUG_RODATA_TEST
> > >  	bool "Testcase for the DEBUG_RODATA feature"
> > >  	depends on DEBUG_RODATA
> > > +	default y
> > >  	help
> > >  	  This option enables a testcase for the DEBUG_RODATA
> > >  	  feature as well as for the change_page_attr()
> > 
> > I think this chunk isn't meant to be there...
> 
> actually never mind.
> it does make sense in general (in fact, I'd be tempted to remove the
> KConfig for this one and just always do the check)

yes. The reason why this change went into the stackprotector tree was 
because it was the same pattern: security feature breaking because it 
didnt have efficient self-tests - while attackers obviously never notified 
us that it's broken.

DEBUG_RODATA had similar bugs: it didnt work correctly in some cases and 
nothing really tested that so we had long latency of bugs. So i turned on 
that self-test too. [and that did catch some bugs, which you fixed, many 
moons ago ;-) ]

	Ingo
