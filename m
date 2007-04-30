Return-Path: <linux-kernel-owner+w=401wt.eu-S1422707AbXD3BPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422707AbXD3BPm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 21:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422716AbXD3BPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 21:15:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:38786 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1422707AbXD3BPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 21:15:01 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX181UPgsTog1qLj3KB/xjx8Y7W1bDiiIC+dHdH8iH5
	4/QBnU7dHwUt62
Date: Mon, 30 Apr 2007 03:14:58 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070430011458.GL5824@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Adrian Bunk <bunk@stusta.de>, Diego Calleja <diegocg@gmail.com>,
	Chuck Ebbert <cebbert@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070426201325.8a1ebda3.diegocg@gmail.com> <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org> <20070426224148.69b91b2e.diegocg@gmail.com> <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org> <20070428195320.GZ3468@stusta.de> <20070428202701.GA30343@flint.arm.linux.org.uk> <20070428224904.GE3468@stusta.de> <alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org> <p73d51n1fup.fsf@bingen.suse.de> <20070429235535.GC19937@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070429235535.GC19937@thunk.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Oops, the first try of this mail got out from my local address, sorry]

On 2007.04.29 19:55:35 -0400, Theodore Tso wrote:
> On Sun, Apr 29, 2007 at 03:15:42PM +0200, Andi Kleen wrote:
> > This means we need people who figure out who to assign bugs too.
> > Aka bugmasters.
> > 
> > BTW one big problem in our current bugzilla is that a lot of people
> > cannot reassign bugs they don't own. I sometimes see bugs that I don't
> > own bug I know who is responsible, but bugzilla doesn't allow me to do it.
> > 
> > So I think what would help:
> > 
> > - Ask more people to just categorize and reassign bugs (anybody interested?)
> > - Give more people in bugzilla the power to reassign arbitary bugs
> > (bugzilla maintainers would need to do that)
> 
> Folks might want to take a look at the Debian Bug Tracking System
> (BTS).  It has a web interface which you can use to query history, but
> *everything* is e-mail driven, and the way you submit, close, update,
> tag/classfy bugs --- everything --- is via e-mail.
> 
> More importantly, anyone is allowed to recategorize and reassign bugs.
> If someone does so maliciously or incorrectly, you can always revert
> it, and if someone is being truly malicious, you can always blacklist
> that one person.  It this respect, it is far more wiki-like than
> bugzilla, which has always been too much like a straightjacket.
> 
> It's not perfect, but it's better than bugzilla --- but then again,
> just about *anything* would be better than bugzilla.  (Hmm, except
> maybe SourceForge's very tragic bug tracking system... :-)
> 
> Of course, as Linus has said, it's not a complete solution --- you
> still need humans to be smart about things --- but if the goal is to
> make it easier to archive and track information about a bug, at
> *least* with the Debian BTS, when you reply to an e-mail message, the
> reply is automatically appended to the bug log!

I've started hacking on some bash scripts to do the e-mail part, based
on the requirements I've gathered from reading this thread. So far, I
got one script that can be plugged into procmail and processes mails to
do the following (right now):

 - Create a bug
 - Set the bug type to "regression"
 - Update the timestamp of the last action for that bug
 - Assign the bug to a subsystem
 - Track the submitter and whoever grabs the bug

More (hopefully) to come...

Those commands are just added to any email in the thread discussing a
bug like this:
@bugthing
mine		# Mark myself as owner
regression	# Mark this bug as a regression (used for reports)
subsystem mm	# Assign the bug to mm
needinfo	# Tell the tracker to bug the reporter if nothing happens
Thanks

That block can appear anywhere in the email, so if you're discussing
some problem on lkml and want to track that bug, you can just add such a
block to your email and turn an untracked email conversion into a
tracked bug.

Tracking does _not_ mean that all emails are stored, those can be looked
up on lkml.org or MARC, where the created reports will probably contain
URLs to the latter, because it supports lookups based on message ids.

Tracking does just mean that the state of the bug is stored somewhere.
That means (currently, suggestions welcome):

 - What's its name? (E-Mail subject)
 - Who reported it?
 - Who (if any) stepped up to own that bug?
 - What type of bug is it?
 - Which subsystem does it belong to?
 - What's its current state? (new, owned, fixed, ...)
 - When did the last action on this bug happen?

Based on that information, I've started writing some scripts that create
"reports" (all of them currently being pretty incomplete):

 - Bugs that belong to a specific subsystem (on request, currently
   through a procmail triggered script; this is meant to satisfy
   Adrian's request of asking for example for all SATA bugs.)

 - Bugs that are not owned and didn't see any action for one week
   (cronjob; to lkml, the submitter, the recipients of the bug mail and
   maybe folks who subscribed to such mails)

 - All bugs marked as regressions (complete list to lkml, personalised
   lists to each owner of any regressions, probably sent on request)

 - Annoy the bug submitter if someone tagged the bug with "moreinfo" and
   there wasn't any reply from the submitter within one week

 - Annoy the bug owner if he didn't do anything about his bug within
   one week

Those "reports" should push the relevant parties into looking at those
bugs again while being terse, like Adrian's regression list and not
annoying anyone but those who are most likely to be interested.

Bugs in which noone shows interest (i.e. nothing happens at all), should
probably be removed after 2-3 weeks, with a notice going to the
submitter and recipients of the bug's emails as well as those subscribed
to receiving reports of non-owned inactive bugs. Well, unless those bugs
are regressions, we should probably bug about them until they get
closed.


That's my plan so far. It's probably going to be ugly and all, but I
wanted to get something done quick (and learn a bit about bash scripting
along the way) to see if it works at all, and what you guys think about
that approach. Maybe I can write a less ugly version later, or someone
picks up the approach and writes a better implementation himself. But
maybe the preliminary one (once it is somewhat useable) could be tested
by a few brave folks to see if the approach works out at all...

I don't know about the Debian BTS internals, but IMHO, the mentioned
capability of being email-based isn't enough for Linux.  Things might
start out on lkml as some small issue, but suddenly there's some reason
to track a bug that is discussed in an already existing thread. If you
file it into an email based system, you loose the entire history of that
discussion if you look at it from the BTS.  With the tracker-only
approach, you simply stay email based and if required, you just lookup
the right thread using the information from the tracker and go back to
email, if you don't have those emails, the public archives most probably
do.

And far more important are IMHO the reports, which should distribute the
work of tracking bugs a bit. If a regression is found, the reporter, the
owner or anyone reading the thread, can mark it as such and noone is
forced to track _all_ regressions. The wiki helps with this, too, but
IMHO it's neither easy nor fast enough to look up and change that patch
manually for anyone to enjoy that. Also, the automatic reminders should
help (a bit) to not loose too many bugs, just because the person
responsible for it got distracted (and forgot about it) or because the
bug submitter forgets that he needed to provide more info, which he
couldn't do at the time the request hit his inbox (I do that all the
time).

Does this sound like something usable in the long run? Do I just waste
my time? Do I miss something very important?

Björn
