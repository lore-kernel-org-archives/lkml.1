Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbXKYXKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbXKYXKl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 18:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbXKYXKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 18:10:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36281 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbXKYXKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 18:10:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: kernel bugzilla is FPOS (was: Re: "buggy cmd640" message followed by soft lockup)
Date: Mon, 26 Nov 2007 00:28:17 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
References: <200711222007.12497.elendil@planet.nl> <200711252339.00557.rjw@sisk.pl> <20071125224010.GA5006@stusta.de>
In-Reply-To: <20071125224010.GA5006@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711260028.18489.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 25 of November 2007, Adrian Bunk wrote:
> On Sun, Nov 25, 2007 at 11:38:59PM +0100, Rafael J. Wysocki wrote:
> > On Sunday, 25 of November 2007, Adrian Bunk wrote:
> > > On Sun, Nov 25, 2007 at 10:28:06PM +0100, Rafael J. Wysocki wrote:
> > > > On Sunday, 25 of November 2007, Adrian Bunk wrote:
> > > >..
> > > > > First of all, Bugzilla is a quite often used bug tracker in the open 
> > > > > source world [1], so many users already know it.
> > > > > 
> > > > > But more important, "it pretends to require them to spend" isn't true 
> > > > > because there's no pretending - we actually often require bug reporters 
> > > > > to spend a lot of time on the bug report (e.g. when asking for 
> > > > > bisecting).
> > > > 
> > > > But not *initially*.
> > > > 
> > > > We should not confuse *debugging* with *reporting bugs*.  While the former is
> > > > actually more difficult and more time consuming than writing the code in which
> > > > the bug is present, the latter should be as simple as sending an email.
> > > 
> > > For hardcore geeks like you and me sending an email might be easier than 
> > > using some web interface.
> > > 
> > > Normal humans tend to be more accustomed to web interfaces, and 
> > > following the instructions on some web page is _much_ easier than 
> > > reading three text files for knowing what to write in an email.
> > 
> > Hm, this is a good argument for having such a web interface, but IMO it
> > shouldn't be mandatory.  IOW, there should be a way to report a bug using plain
> > email, if the reporter prefers that.  We can, however, request that the address
> > of our bug tracking system be added to the report's Cc list.
> 
> Looking at both other open source projects and the support of commercial 
> software a web interface should be enough.

Well, IMHO the Linux kernel is exceptional in many ways ...

> But this is not the problem - the problem is what happens after the 
> initial report with the bug report.

Not only that.

First, each bug report has to reach the right lists/people and that's what we
can't assure using the Bugzilla alone right now.  To make the Bugzilla
generally useful for that we need to change the way in which the target of the
report is selected and make it send reports to mailing lists rather than to
individual people.

Second, once the bug report have reached the right place, we have two problems
to solve:
(1) we need to make the developers respond and actively work on the bug
(2) we need to make the tracking of the bug possibly unintrusive (ie.
    developers should be able to work with the reporter in a way that *they*
    prefer)
While it's generally difficult to solve (1), we can at least make (2) happen
(well, in theory).

> > Now, the question is what information this web interface should ask for.
> > 
> > IMO, first, it should ask for what the bug is against, ie.:
> > - kernel version (to be obtained from 'git describe' or from /proc/version or
> >   from .config, if the kernel doesn't boot)
> > - architecture (x86, ARM, MIPS etc.)
> > - subsystem and subsubsystem (that could be selectable from a menu and might
> >   depend on the architecture)
> > 
> > It also should ask if the problem is a regression and what was the last known
> > good kernel (I'd prefer that to be the last known major release selectable from
> > a list).
> > 
> > Also, the reporter should be required to provide a summary (subject) and
> > a (concise) description of the problem and a list of email addresses to
> > send the report to in addition to the regular handling (there should be a way
> > to verify which addresses are acceptable).
> > 
> > Anything else?
> > 
> > Next, the report should be sent to a mailing list selected on the basis of the
> > information provided (not necessarily to individual developers, unless there
> > are some addresses provided explicitly by the reporter).
> 
> The architecture choice seems to be the only thing from your list that
> isn't already available in the "Enter a new bug report" dialog of the
> kernel Bugzilla.

Yet, the architecture choice affects the way in which the other choices are
made.  Also, the "sending to mailing lists" part is obviously missing.

> > IMO, it should be possible to work on the bug using both email and the web
> > interface, whichever is preferred by the participant in question, without the
> > need to stick to any of them (ie. email messages sent in the corresponding
> > email thread should be registered by the bug tracking system and comments
> > entered into it should appear as messages in the email thread with the
> > appropriate To:, From: and Cc: information).
> > 
> > There surely are more things that we'd like it to do, but the above seem to be
> > a reasonable minimum.
> 
> Except from the From: header in outgoing emails the kernel Bugzilla 
> already offers this for years.

No, it doesn't.  You can't send the initial report by email so that it's
registered by the Bugzilla, at least I'm not aware of such a possibility.

Also, if you "switch to email", and then want to switch back to the web
interface, the Cc list from the email messages will be lost.

Greetings,
Rafael
