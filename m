Return-Path: <linux-kernel-owner+w=401wt.eu-S965446AbXBFUwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965446AbXBFUwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 15:52:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965450AbXBFUwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 15:52:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48870 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965446AbXBFUwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 15:52:39 -0500
Date: Tue, 6 Feb 2007 21:52:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
Message-ID: <20070206205231.GA25430@elte.hu>
References: <20070129204528.eb8d695e.akpm@osdl.org> <1170777802.9781.353.camel@imap.mvista.com> <1170786992.3785.0.camel@chaos> <1170787543.9781.362.camel@imap.mvista.com> <1170788870.3785.9.camel@chaos> <1170791739.3455.3.camel@dwalker1> <1170793206.3785.16.camel@chaos> <1170794437.3455.20.camel@dwalker1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170794437.3455.20.camel@dwalker1>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> On Tue, 2007-02-06 at 21:20 +0100, Thomas Gleixner wrote:
> > On Tue, 2007-02-06 at 11:55 -0800, Daniel Walker wrote:
> > > > What kind of artificial problem are you creating here ?
> > >
> > > I'm not trying to create anything .. However, as I said before
> > > the /proc/interrupts "timer" entry doesn't work the same as it has in
> > > other kernels.
> > 
> > Yes, it is different. Why are you insisting, that something is a problem
> > just because it is different ?
> 
> In this case "different" goes into userspace .. So different could 
> mean userspace regression, which is something that we don't want. I 
> have no idea if any apps use /proc/interrupts , but it's possible 
> since it's been around for a long time.

Well, if you enable dynticks you should expect the number of timer irqs 
to go down. There's no problem here.

> The reason that I'm bringing it up at all is because people have ask 
> me "Why isn't my timer ticking??"

it's quite easy to explain: because of the new dynticks feature. Both 
'timer' and 'LOC' counts go way down.

> It might be nicer to list all the registered clock event sources in 
> /proc/interrupts, with more descriptive names ..

they are already listed in /proc/interrupts, depending on how they use 
interrupts. For a more complete list of in-use clockevent drivers see 
/proc/timer_info. But it would be wrong to touch /proc/interrupts to 
create some special-case for clockevents.

	Ingo
