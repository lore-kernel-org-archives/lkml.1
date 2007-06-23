Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbXFWIYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbXFWIYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 04:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbXFWIYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 04:24:05 -0400
Received: from 1wt.eu ([62.212.114.60]:3102 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbXFWIYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 04:24:04 -0400
Date: Sat, 23 Jun 2007 10:23:22 +0200
From: Willy Tarreau <w@1wt.eu>
To: Alberto Gonzalez <info@gnebu.es>
Cc: Paolo Ornati <ornati@fastwebnet.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Question about fair schedulers
Message-ID: <20070623082320.GX943@1wt.eu>
References: <200706230007.15622.info@gnebu.es> <20070623090655.36d1794c@localhost> <200706231001.02497.info@gnebu.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706231001.02497.info@gnebu.es>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 10:01:02AM +0200, Alberto Gonzalez wrote:
> Thanks for your thoughts.
> 
> On Saturday 23 June 2007, Paolo Ornati wrote:
> > On Sat, 23 Jun 2007 00:07:15 +0200
> >
> > Alberto Gonzalez wrote:
> > > My conclusion is that SD behaves as expected: it's more fair. But for a
> > > desktop, shouldn't an "intelligently unfair" scheduler be better?
> >
> > "intelligently unfair" is what the current scheduler is (because of
> > interactivity estimator).
> >
> > When it works (say 90% of the time) the desktop feels really good...
> > but when it doesn't it can be a disaster.
> 
> I see. So you mean that in 90% of the cases the mainline scheduler behaves 
> better than fair schedulers, but when its "logic" fails it behaves much worse 
> (the other 10% cases)? In my very simple test scenario the mainline scheduler 
> did behave much better. Maybe the problem comes with very complex scenarios 
> like the ones I've seen when testing these 2 fair schedulers (something like 
> compiling a kernel while you open 5 instances of glxgears, write an email, 
> play music in Amarok and watch 2 HD videos all at the same time). The 
> question would then be if these kind of situations are likely to happen in 
> real world, or even if it doesn't make more sense to try to improve the logic 
> of the mainline scheduler so that those 10% cases are handled better instead 
> of writing a new one that would behave worse in 90% of the cases and better 
> in the other 10%.

No, in fact, the mainline scheduler is good only for the very particular
cases you propose here. But on some fairly trivial situations (such as two
processes consuming very close to 50% CPU), it can be a disaster. I've had
proxies under medium load slow down sshd so much that it was impossible to
log in. Most of the worst situations have been fixed since the early 2.6
versions (2.6.11 was still horrible), but it's the general design which
makes such cases hard to find and to fix.

Your situation is clearly something standard where only the user can decide
which application should get more CPU. You start two CPU hogs, and your mind
tells you that you would prefer the video not to skip and the encoding to
finish later. For other people, it might be the reverse because the video
will be there just for monitoring purposes. The nice command was invented
exactly for that, and people have been happily using it for the last 30
years. I don't see why it should become hard to use ! Many CPU-sensitive
applications already provide the ability to change their nice value
themselves using a command line parameter.

And if it is still too hard to assign nice values from within your
environment, then perhaps it's the environment which does not suit your
needs. Even Windows users can choose to assign more priorities to
foreground/background tasks, so it is something universally accepted,
and I would be really surprized that you would not have the ability
to proceed the same way.

> 	Alberto.

Regards,
Willy

