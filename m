Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbZAKQjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbZAKQjX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 11:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbZAKQjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 11:39:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50653 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbZAKQjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 11:39:13 -0500
Date: Sun, 11 Jan 2009 17:39:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, Daniel Drake <dsd@gentoo.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Phil Dibowitz <phil@ipom.com>
Subject: Re: [Bug #12422] 2.6.28-git can't resume from str
Message-ID: <20090111163904.GA21806@elte.hu>
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera> <b6a2187b0901110813s5429573cm7d78f39e288f70a3@mail.gmail.com> <20090111162949.GA15338@elte.hu> <200901111736.24350.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901111736.24350.borntraeger@de.ibm.com>
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


* Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Am Sonntag 11 Januar 2009 schrieb Ingo Molnar:
> > 
> > * Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> > 
> > > On Sun, Jan 11, 2009 at 10:18 PM, Christian Borntraeger
> > > <borntraeger@de.ibm.com> wrote:
> > > > Am Sonntag 11 Januar 2009 schrieb Daniel Drake:
> > > >> Rafael J. Wysocki wrote:
> > > >> > This message has been generated automatically as a part of a report
> > > >> > of recent regressions.
> > > >> >
> > > >> > The following bug entry is on the current list of known regressions
> > > >> > from 2.6.28.  Please verify if it still should be listed and let me 
> know
> > > >> > (either way).
> > > >> >
> > > >> >
> > > >> > Bug-Entry   : http://bugzilla.kernel.org/show_bug.cgi?id=12422
> > > >> > Subject             : 2.6.28-git can't resume from str
> > > >> > Submitter   : Jeff Chua <jeff.chua.linux@gmail.com>
> > > >> > Date                : 2009-01-10 1:39 (2 days old)
> > > >> > References  : http://marc.info/?l=linux-kernel&m=123155157909282&w=4
> > > >>
> > > >> The bisection looks invalid. It is unlikely to be this commit at fault.
> > > >> Jeff, do you even have that camera?
> > > >>
> > > >> It is also easy to revert that commit by hand. Just delete the
> > > >> unusual_devs entry for it.
> > > >
> > > > I found a nearby commit during bisect, which looks much saner:
> > > >
> > > > http://marc.info/?l=linux-kernel&m=123167815028388&w=2
> > > 
> > > This was committed earlier than
> > > a0e280e0f33f6c859a235fb69a875ed8f3420388, and
> > > a0e280e0f33f6c859a235fb69a875ed8f3420388 was the last working kernel
> > > that is able to suspend/resume. Go one before, and suspend/resume
> > > breaks.
> > 
> > so you mean a0e280e0f33f6c859a235fb69a875ed8f3420388 seems good, while the 
> > next step in Linus's tree, 52fefcec97c25b15887e6a9a885ca54e7f7c0928 is 
> > already broken?
> 
> I guess Jeff, meant the other way around.
> Since a0e280e0f33f6c859a235fb69a875ed8f3420388 is a fix for a known S2R 
> problem , the earlier patch (before) does of course not work.

ah, okay.

So i suspect that at every bisection point, this should be done:

  git cherry-pick a0e280e0f33f6c859a235fb69a875ed8f3420388

To make sure the bisection finds the secondary breakage too.

(the cherry-pick will fail harmlessly on kernels that have that commit 
already - so it can be done unconditionally at every bisection point.)

	Ingo
