Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbZAMB2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbZAMB2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755699AbZAMB20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:28:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45714 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521AbZAMB2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:28:25 -0500
Date: Tue, 13 Jan 2009 02:28:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Daniel Drake <dsd@gentoo.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Phil Dibowitz <phil@ipom.com>
Subject: Re: [Bug #12422] 2.6.28-git can't resume from str
Message-ID: <20090113012800.GA15492@elte.hu>
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera> <b6a2187b0901110813s5429573cm7d78f39e288f70a3@mail.gmail.com> <20090111162949.GA15338@elte.hu> <200901111736.24350.borntraeger@de.ibm.com> <20090111163904.GA21806@elte.hu> <b6a2187b0901110856j3f2ff6fepc19a816178e38a95@mail.gmail.com> <20090111180714.GB15326@elte.hu> <b6a2187b0901121720s1f9b12ednb76a90dcc7eddc81@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0901121720s1f9b12ednb76a90dcc7eddc81@mail.gmail.com>
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

> On Mon, Jan 12, 2009 at 2:07 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >> Everything in-between should have
> >> a0e280e0f33f6c859a235fb69a875ed8f3420388 applied?
> > not necessarily - if an intermediate tree that is checked happened to have
> > been based on some earlier -rc, it might have that bug included. Safest is
> > to always cherry-pick that commit. (if it has no dependencies)
> 
> Thanks for pointing this out. My bisect was thrown off course because
> I didn't "cherry-pick" that commit.
> 
> After cherry picking, I ended up with the same commit as was reported by
> Christian Borntraeger -- "Regression 2.6.28-git: suspend/resume
> failure. git bisected to usb suspend/resume patch".
> 
> I was trying to bisect further, but ended up with this strange behavior...
> 
> # start with a "fresh linux git download".
> # ls
> .               ..             .git     .gitignore   .mailmap  COPYING
> CREDITS         Documentation  Kbuild   MAINTAINERS  Makefile  README
> REPORTING-BUGS  arch           block    crypto       drivers   firmware
> fs              include        init     ipc          kernel    lib
> mm              net            samples  scripts      security  sound
> usr             virt
> 
> # git bisect bad ae04d1401577bb63151480a053057de58b8e10bb
> # git bisect good a3a798c88a14b35e5d4ca30716dbc9eb9a1ddfe2
> Bisecting: 579 revisions left to test after this
> [079899c2384023cd8efcd3806680b4f1d2abbd54] Btrfs: Change
> find_extent_buffer to use TestSetPageLocked
> 
> # ls
> .  ..  .git  fs
> 
> Is this a bug or a feature?

that's a feature - the btrfs history looks like this. You can mark get out 
of that bisection set by doing this:

        git bisect good 34353029534a08e41cfb8be647d734b9ce9ebff8

	Ingo
