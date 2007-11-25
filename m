Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbXKYWVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbXKYWVd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbXKYWVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:21:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36113 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbXKYWVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:21:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: kernel bugzilla is FPOS (was: Re: "buggy cmd640" message followed by soft lockup)
Date: Sun, 25 Nov 2007 23:38:59 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
References: <200711222007.12497.elendil@planet.nl> <200711252228.07312.rjw@sisk.pl> <20071125213640.GC18284@stusta.de>
In-Reply-To: <20071125213640.GC18284@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711252339.00557.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 25 of November 2007, Adrian Bunk wrote:
> On Sun, Nov 25, 2007 at 10:28:06PM +0100, Rafael J. Wysocki wrote:
> > On Sunday, 25 of November 2007, Adrian Bunk wrote:
> >..
> > > First of all, Bugzilla is a quite often used bug tracker in the open 
> > > source world [1], so many users already know it.
> > > 
> > > But more important, "it pretends to require them to spend" isn't true 
> > > because there's no pretending - we actually often require bug reporters 
> > > to spend a lot of time on the bug report (e.g. when asking for 
> > > bisecting).
> > 
> > But not *initially*.
> > 
> > We should not confuse *debugging* with *reporting bugs*.  While the former is
> > actually more difficult and more time consuming than writing the code in which
> > the bug is present, the latter should be as simple as sending an email.
> 
> For hardcore geeks like you and me sending an email might be easier than 
> using some web interface.
> 
> Normal humans tend to be more accustomed to web interfaces, and 
> following the instructions on some web page is _much_ easier than 
> reading three text files for knowing what to write in an email.

Hm, this is a good argument for having such a web interface, but IMO it
shouldn't be mandatory.  IOW, there should be a way to report a bug using plain
email, if the reporter prefers that.  We can, however, request that the address
of our bug tracking system be added to the report's Cc list.

Now, the question is what information this web interface should ask for.

IMO, first, it should ask for what the bug is against, ie.:
- kernel version (to be obtained from 'git describe' or from /proc/version or
  from .config, if the kernel doesn't boot)
- architecture (x86, ARM, MIPS etc.)
- subsystem and subsubsystem (that could be selectable from a menu and might
  depend on the architecture)

It also should ask if the problem is a regression and what was the last known
good kernel (I'd prefer that to be the last known major release selectable from
a list).

Also, the reporter should be required to provide a summary (subject) and
a (concise) description of the problem and a list of email addresses to
send the report to in addition to the regular handling (there should be a way
to verify which addresses are acceptable).

Anything else?

Next, the report should be sent to a mailing list selected on the basis of the
information provided (not necessarily to individual developers, unless there
are some addresses provided explicitly by the reporter).

IMO, it should be possible to work on the bug using both email and the web
interface, whichever is preferred by the participant in question, without the
need to stick to any of them (ie. email messages sent in the corresponding
email thread should be registered by the bug tracking system and comments
entered into it should appear as messages in the email thread with the
appropriate To:, From: and Cc: information).

There surely are more things that we'd like it to do, but the above seem to be
a reasonable minimum.

> > > I'm also sometimes writing bug reports in different areas, and in my 
> > > experience it doesn't matter whether it's web-based Bugzilla, the 
> > > email-based Debian bug tracker or whatever else system - the time spent 
> > > on a good bug report is not spend on pasting the text whereever or on 
> > > clicking on a few boxes, the time is spent on tracking the issue down 
> > > and writing a good bug report.
> > 
> > Apparently, you are expecting the reporters do *debug* problems, while they need
> > not be aware of how to do that.
> > 
> > IMHO, we should make reporting problems as simple as reasonably possible and
> 
> Agreed, and as said above simple = web interface.
> 
> >...
> > > What matters for a bug reporter is to get a solution for his problem 
> > > within a reasonable amount of time.
> > 
> > Still, it's annoying if you attach tons of information to the report and that
> > information does not turn out to be useful.
> 
> Agreed.
> 
> > > > Also, some developers do not consider the Bugzilla as a useful thing and
> > > > wouldn't like to use it (which is why this thread has appeared, among other
> > > > things ;-)).
> > > >...
> > > 
> > > And that's part of the problem.
> > > 
> > > Bugzilla is a usable tool, but it isn't the only tool available.
> > > 
> > > If there was one tool all developers would be willing to use that would 
> > > be a reason why we should switch to whatever tool this is.
> > 
> > The choice of the tool should be a result of the choice of a *method*.  IOW,
> > we have to know our needs and choose the tool that satisfies them or write one
> > if it doesn't exist.
> > 
> > For now, IMHO, we don't really know what we need.
> 
> Even worse:
> Different people have different opinions what they need and what they 
> don't want...

Let's collect these opitions, then, and try to find a solution that would
satisfy all of them or at least the majority of them.

Greetings,
Rafael
