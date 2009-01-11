Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194AbZAKSIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbZAKSIF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 13:08:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbZAKSHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 13:07:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37561 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbZAKSHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 13:07:38 -0500
Date: Sun, 11 Jan 2009 19:07:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Daniel Drake <dsd@gentoo.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Phil Dibowitz <phil@ipom.com>
Subject: Re: [Bug #12422] 2.6.28-git can't resume from str
Message-ID: <20090111180714.GB15326@elte.hu>
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera> <b6a2187b0901110813s5429573cm7d78f39e288f70a3@mail.gmail.com> <20090111162949.GA15338@elte.hu> <200901111736.24350.borntraeger@de.ibm.com> <20090111163904.GA21806@elte.hu> <b6a2187b0901110856j3f2ff6fepc19a816178e38a95@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0901110856j3f2ff6fepc19a816178e38a95@mail.gmail.com>
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


* Jeff Chua <jeff.chua.linux@gmail.com> wrote:

> On Mon, Jan 12, 2009 at 12:39 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > * Christian Borntraeger <borntraeger@de.ibm.com> wrote
> >> I guess Jeff, meant the other way around.
> >> Since a0e280e0f33f6c859a235fb69a875ed8f3420388 is a fix for a known S2R
> >> problem , the earlier patch (before) does of course not work.
> > ah, okay.
> > So i suspect that at every bisection point, this should be done:
> >  git cherry-pick a0e280e0f33f6c859a235fb69a875ed8f3420388
> 
> I started with the latest git, and did this ...
> 
> git bisect start
> git bisect bad
> git bisect good a0e280e0f33f6c859a235fb69a875ed8f3420388
> 
> Everything in-between should have
> a0e280e0f33f6c859a235fb69a875ed8f3420388 applied?

not necessarily - if an intermediate tree that is checked happened to have 
been based on some earlier -rc, it might have that bug included. Safest is 
to always cherry-pick that commit. (if it has no dependencies)

	Ingo
