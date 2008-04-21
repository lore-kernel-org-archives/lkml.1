Return-Path: <linux-kernel-owner+w=401wt.eu-S1758964AbYDUMvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964AbYDUMvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 08:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756730AbYDUMv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 08:51:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49919 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756452AbYDUMv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 08:51:27 -0400
Date: Mon, 21 Apr 2008 14:51:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.25
Message-ID: <20080421125107.GF9554@elte.hu>
References: <1208540517.3063.18.camel@localhost.localdomain> <20080419151934.GA17089@elte.hu> <1208620484.3280.23.camel@localhost.localdomain> <20080419170530.GD1595@cs181133002.pp.htv.fi> <1208626496.3280.40.camel@localhost.localdomain> <alpine.LFD.1.10.0804191305360.2779@woody.linux-foundation.org> <1208644076.3280.54.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208644076.3280.54.camel@localhost.localdomain>
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


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Sat, 2008-04-19 at 13:14 -0700, Linus Torvalds wrote:
> > On Sat, 19 Apr 2008, James Bottomley wrote:
> > > 
> > > Well, we already had this argument on linux-scsi when the interface was
> > > first proposed:  Apart from select being very nasty and should only be
> > > sparingly used
> > 
> > I'm still not understanding people who say that.
> 
> Well, I can ... even though SCSI is one of the major users of select 
> in the tree.

you are handling it well then :) I tend to be amongst the first ones to 
notice select trouble (randconfig is quite sensitive to it) and by far 
the leading area of failure "in practice" is video drivers and sound 
modules. Networking is an occasional blip on the radar (but that's 
really just due to its sheer natural size and complexity) and i dont 
remember any deep SCSI trouble there ever.

pie-in-the-sky: a fundamentally simpler Kconfig space would be nice, 
with strict hierarchies and where enabling a lower component 
automatically selects all the upper components as well. The Kconfig 
language should detect loops in hierarchies. (it already does so in a 
number of situations)

i.e. we should only describe what depends on what - and the rest would 
be figured out automatically. In that sense "select" should be a _user 
action_ that would never pop up in the language at all - and the 
"selection" would all trickle through automatically via the 'depends on' 
links without having to mention it in the Kconfig language.

whenever due to a selection that a user made something becomes 
unavailable, the kconfig tool/GUI should warn about that with an extra 
confirmation step. I.e. it should all really be analogous to normal 
user-space package management which has its own dependency resolution 
process.

	Ingo
