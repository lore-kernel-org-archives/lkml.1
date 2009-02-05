Return-Path: <linux-kernel-owner+w=401wt.eu-S932307AbZBEB22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307AbZBEB22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756286AbZBEB2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:28:18 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:59144 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755335AbZBEB2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:28:17 -0500
Date: Thu, 5 Feb 2009 12:26:00 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>
Cc: Bron Gondwana <brong@fastmail.fm>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Norbert Preining <preining@logic.at>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: Re: 2.6.29-rc3-git6: Reported regressions from 2.6.28
Message-ID: <20090205012559.GA3889@brong.net>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <alpine.LFD.2.00.0902040759420.3247@localhost.localdomain> <20090204181109.GR21085@gamma.logic.tuwien.ac.at> <alpine.LFD.2.00.0902041012440.3247@localhost.localdomain> <20090204185606.GA12991@elte.hu> <20090204222256.GA6954@brong.net> <20090205010811.GA5152@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205010811.GA5152@elte.hu>
Organization: brong.net
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 02:08:11AM +0100, Ingo Molnar wrote:
> 
> (Cc:-ed Davide)

eep

> * Bron Gondwana <brong@fastmail.fm> wrote:
> 
> > On Wed, Feb 04, 2009 at 07:56:06PM +0100, Ingo Molnar wrote:
> > >    [...] it is a natural reaction: 
> > >    they only see the small trivial annoyance they intruduce themselves - 
> > >    which is in a code area and usecase they are prominently familiar with, 
> > >    so they cannot personally relate to the trouble that users go through if 
> > >    they hit such issues.
> > 
> > Amen.  Preach it.  I spent quite a while just a week ago arguing that 
> > every semi-loaded machine out there using epoll should not require the 
> > admin to discover that their previously happy software stack was suddenly 
> > hitting an artificially tiny per-user instances count.
> > 
> > Luckily I was able to find multiple blog posts and mailing list archives 
> > with people who had literally spent _days_ tracking down why things had 
> > broken for them when they upgraded to a new -stable kernel.
> > 
> > You really do have to assume that your users don't have time for this 
> > shit.  Anything that really can't DTRT automatically needs to be covered 
> > with plenty of easy to follow instructions on how to fix the problem - 
> > because for someone unfamiliar with that area of the system it really does 
> > take enormous effort to track down what's changed.
> 
> do you know which commit that was (or which exact tunable default value it 
> is about) and whether we could restore the old default safely, and whether 
> there's some reasonable minium must-have value that still works well in 
> practice?

Oh, it got sorted out eventually, but not without a whole lot of debate
about how it wasn't that hard (per individual).  Let's not stir this one
up again :)  We've resolved it to everyone's satisfaction.

It's the more abstract "I understand the issue and it's easy for me 
to set a sane config for my environment" being extended to everyone 
having to understand yet another bloody tunable.

And I'm somewhat guilty of it myself with Cyrus.  You run into the
thorny issue of: there's (a) the sane choice, (b) the backwards
compatible choice.  Every new site should be running (a), but you
don't want to ship a new stable version with (a) as the default
because it will break everything and people will need to figure out
what your stupid little change was and why it broke them.  Especially
if the underlying issue doesn't actually bother their config.

I tend to side with defaulting to (b), and the basic config file on
our of our imap servers just keeps getting longer.
 
> With Moore's law still alive and kicking there's normally no reason to 
> narrow defaults - if then they get increased or get changed to some 
> auto-size-to-hw-capabilities dynamic method.

It was an N^2 issue.  I appreciate the DoS risk it solved, just that
the solution was a stab in the dark, and it wound up hitting a lot
more people than expected (who knew that most epoll users create one
watcher per process, but still create lots of processes as well,
obviously not many people until it was shown to affect at least
postfix, apache and java.  Quite the collection!)

> Upstream defaults usually get narrowed only for really good reasons and 
> often the reason is DoS and security and a specific testcase that kills a 
> default box with a too large default. Sometimes they get narrowed spuriously 
> and then we can fix things reasonably.

Yeah.  It's a pain - especially since more fine-grained tracking to
distinguish between a DoS and a reasonable user comes with its own costs
(see companies that expect you to track your time in 5 minute
increments, and act all surprised when half of everyone's time
comes back coded as "filling in the stupid timesheets")

Bron.
