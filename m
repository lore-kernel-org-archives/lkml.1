Return-Path: <linux-kernel-owner+w=401wt.eu-S1761749AbXGDLSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761749AbXGDLSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 07:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758572AbXGDLSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 07:18:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48782 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756338AbXGDLSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 07:18:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
Date: Wed, 4 Jul 2007 13:25:55 +0200
User-Agent: KMail/1.9.5
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <20070703211227.GA28758@srcf.ucam.org> <200707041242.59552.rjw@sisk.pl> <18059.32111.58643.97174@cargo.ozlabs.ibm.com>
In-Reply-To: <18059.32111.58643.97174@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707041325.55779.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 4 July 2007 12:58, Paul Mackerras wrote:
> Rafael J. Wysocki writes:
> 
> > Okay, so in fact you don't know.
> 
> Don't know what exactly?

How many drivers will be adversely affected by the $subject change.

> It has been a while since I had my head in the USB code.  I assume
> it's being maintained by competent people. :)

I'm not talking about USB.
 
> > And that's my point in this thread.
> 
> Well, I'd be interested in hearing from Matthew whether he has
> actually been using his patch in Ubuntu, and if so, what bug reports
> he has been receiving related to it?

Me too.

> > I won't fight for the freezer for what it's worth, but let's do things in the
> > _right_ _order_.  For example, let's make sure that by making the $subject
> > change we won't introduce (too many) regressions and fix the frameworks
> > that don't get it right.
> > 
> > Using the problems with FUSE as an argument for making this change immediately
> > doesn't seem to be right to me.
> 
> I can see your point, but I won't be moving powermac over to use the
> generic suspend path until the freezer is gone, since I am pretty
> confident that the drivers we care about behave sensibly, and I have
> seen a lot of traffic on linux-pm and lkml about problems caused by
> the freezer.

They are mostly related to kernel threads, that we've already agreed no to
freeze (except for the ones that want that, but they will be responsible for
getting everything right).  The initial patches for that are in -mm and more
will come.

> Also, no-one has yet answered my fundamental objection to the freezer,
> which is that the very kernel threads we would want to freeze are
> often the same ones that we must not freeze, namely the threads that
> issue I/O requests in order to satisfy incoming I/O requests.

See above.  We're moving away from freezing kernel threads.

> If there was an automatic way to construct the graph of dependencies
> (including data flows) between tasks, and derive an ordering for
> freezing that guarantees that all I/Os will get completed without
> deadlocks, then I could accept the freezer.  But we don't have
> anything like that.

No we don't.

Still, my position is this:

1) The freezer (in the modified form, with the freezing of kernel threads
limited to the ones that want to be frozen) is needed for hibernation.

2) The freezer is generally not needed for suspend, _but_ there are drivers
in the tree that rely on it being used.  Thus, at some point in time we can
remove the freezer from the suspend code path, _but_ no sooner than we are
sure that the majority of drivers is prepared for that.

3) In the meantime, if there are freezer-related problems, they should be
fixed rather than used as arguments for immediate removal of it, because of 2).

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
