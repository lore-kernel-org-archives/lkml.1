Return-Path: <linux-kernel-owner+w=401wt.eu-S932619AbZJLUou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619AbZJLUou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 16:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932416AbZJLUou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 16:44:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50230 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932415AbZJLUot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 16:44:49 -0400
Date: Mon, 12 Oct 2009 22:44:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regressions] Re: kbuild: save ARCH & CROSS_COMPILE when
	building a kernel
Message-ID: <20091012204402.GC17163@elte.hu>
References: <20091003103441.GA10874@elte.hu> <20091004191729.GA20203@merkur.ravnborg.org> <20091009092648.GA18894@elte.hu> <20091011213546.GB2768@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091011213546.GB2768@merkur.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Fri, Oct 09, 2009 at 11:26:48AM +0200, Ingo Molnar wrote:
> > 
> > * Sam Ravnborg <sam@ravnborg.org> wrote:
> > 
> > > On Sat, Oct 03, 2009 at 12:34:41PM +0200, Ingo Molnar wrote:
> > > > 
> > > > Sam,
> > > > 
> > > > that arch-cache thing introduced in:
> > > > 
> > > >  5755433: kbuild: save ARCH & CROSS_COMPILE when building a kernel
> > > > 
> > > > isnt working very well in my experience.
> > > > 
> > > > 1) it's a nuisance in cross-builds (it broke several cross-build scripts 
> > > >    of mine)
> > >
> > > On the contrary it has helped me big time on my cross builds. [...]
> > 
> > Could you please try to do that without hurting the existing scripting 
> > and existing workflow of other people?
> 
> The only message in the above was that this was also beneficial
> to some - and not a nusiance only.
> 
> > 
> > > No need to script is all to remember to set the correct ARCH + 
> > > CROSS_COMPILE settings.
> > 
> > Then put your new state into the .config instead of this stupid 
> > include/generated/ extra state that is a _big_ regression over v2.6.31 
> > in terms of cross-build usability.
> 
> I cannot see why saving this in include/generated/*
> has anything to do with your complains. I guess you did not look
> at the patch in question.
> 
> What is hurting you and several other users are _not_ related
> to the fact that we save ARCH and CROSS_COMPILE setting or where
> we save it.
> What hurt you is the consistency checks that was added
> to try to catch people in doing something unexpected.
> 
> Unexpected like trying to build a 64 bit kernel where they
> previosuly were building a 32 bit kernel.
> Or when they suddenly used a different set of binutils
> because they changed CROSS_COMPILE settings.
> 
> 
> The patch in question is reverted in my next push to Linus.

Thanks! Mind sending the fix/revert here too, so that we can test 
whether that resolves all the problems?

	Ingo
