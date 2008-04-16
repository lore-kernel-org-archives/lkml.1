Return-Path: <linux-kernel-owner+w=401wt.eu-S1759928AbYDPVI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928AbYDPVI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 17:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbYDPVIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 17:08:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60577 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbYDPVIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 17:08:48 -0400
Date: Wed, 16 Apr 2008 23:08:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 and DEBUG_SECTION_MISMATCH
Message-ID: <20080416210838.GA27459@elte.hu>
References: <20080416175135.GN1677@cs181133002.pp.htv.fi> <20080416192306.GA3090@uranus.ravnborg.org> <20080416193102.GA16981@elte.hu> <20080416195504.GA2408@elte.hu> <20080416205230.GA4129@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416205230.GA4129@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Wed, Apr 16, 2008 at 09:55:04PM +0200, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > * Sam Ravnborg <sam@ravnborg.org> wrote:
> > > 
> > > > I would prefer we were down to less than 5 warnings so we could 
> > > > enable it in kconfig but maybe after next merge window.
> > > 
> > > they get regenerated. More than 1 out of every 100 new patches. Quite 
> > > expensive feature (in terms of maintenance overhead) for a rather 
> > > theoretical memory saving benefit.
> > 
> > in v2.6.24 we had at least 200 section fixes:
> > 
> >   $ git-log v2.6.24.. | egrep -c 'WARNING:.*Section mismatch'
> >   198
> > 
> > for 12671 commits - that's 1 section type fix for every 60 commits.
> Please get your numbers right. What you count is the number of Section 
> mismatch warnings that has been fixed. Sometime fixing up one line of 
> code fixes >5 section mismatch warnings.

the revised number is: at least 84 commits that fixed section bugs. 
That's still rather large.

> > and 90% of the problems could be reduced via the very simple patch 
> > below ...
> > 
> > so ... why shouldnt we say that if someone wants to have this 
> > feature, it should be done all automatically, in the link space. 
> > There's no reason why the dependencies couldnt be figured out all 
> > automatically.
> 
> Or we could fix the blatant misuse of __cpuinit. If has replaced a 
> proper separation of code that is only relevant for CPU hotplug and 
> code that is used with and without CPUHOTPLUG.
> 
> I question that we have 580 functions that is used duing init in 
> normal cases and during CPU hotplug.

sure, if you can solve it, please do - but the stream of new section 
warnings and seems somewhat worrying for the long run.

	Ingo
