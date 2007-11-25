Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbXKYMxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbXKYMxz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 07:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbXKYMxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 07:53:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34864 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbXKYMxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 07:53:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: kernel bugzilla is FPOS (was: Re: "buggy cmd640" message followed by soft lockup)
Date: Sun, 25 Nov 2007 14:11:15 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, Adrian Bunk <bunk@kernel.org>
References: <200711222007.12497.elendil@planet.nl> <200711242007.52430.rjw@sisk.pl> <200711250126.11603.bzolnier@gmail.com>
In-Reply-To: <200711250126.11603.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711251411.16034.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 25 of November 2007, Bartlomiej Zolnierkiewicz wrote:
> 
> [ I removed Frans from cc: since it is off-topic to the original bugreport ]
> 
> On Saturday 24 November 2007, Rafael J. Wysocki wrote:
> > On Saturday, 24 of November 2007, Bartlomiej Zolnierkiewicz wrote:
> > [--snip--]
> > > Rafael, I see that you've filled a bug for this bugreport into kernel
> > > bugzilla tracker (one day after the bugreport):
> > > 
> > > 	http://bugzilla.kernel.org/show_bug.cgi?id=9442
> > > 
> > > Since we try to address regressions with the highest priority in the
> > > IDE-land (and usually they get fixed quickly) I would strongly prefer to
> > > use bugzilla only for long-term bugs and avoid the needless bureaucracy.
> > 
> > As a rule, I put all of the reported regressions into the Bugzilla early.  You
> > are not required to use these entries for tracking the bugs, though.  If you
> 
> [ I really don't think that the recent push from both Andrew and you in
>   bugzilla direction is a good thing... ]

Well, I use the Bugzilla as a tool for tracking regressions.

You don't need to use or even follow the entries created by me, but some
people do with good results.

> There is a mix of technical and psychological issues with using bugzilla:
> 
> * Interface for filling bugs is a joke:
>   - help for "Product" selection is mediocre
>     ("IO/Storage:" -> "Bugs related to IO")

Here, I agree, but IMO that's an organizational issue.  We first should assign
people to handling bugs related to various subsystems and based on that create
the menu so that the right people are notified of the reports.

>   - there is no help for "Componenet" selection
>   - "Some basic debugging hints" are not there

It looks like you'd like the reporter to initially debug the issue for you
before actually reporting it.  I don't think it's realistic. ;-)

>   - "Kernel version" given by reporter should be checked against the latest
>     kernel version and if not matching there should be a kind request to
>     retest with the latest kernel

Why?

If someone has a problem with 2.6.23.x which has already been fixed in the
mainline, we should be able to point him to the fix.  If we aren't, then
something is wrong on our side.

>   - it should be strongly suggested to attach dmesg output and kernel config

I, personally, don't like reports with dmesgs and .configs attached from the
start, especially if they are cut'n'pasted into the message window, because
they often don't contain the relevant information.

>   - zillion other little improvements...

Sure, improvements are always possible. :-)

>   [ The average bug quality is not very high (bugs often lack critical
>     information) and this is really not reporters' fault!  The interface
>     should be kept as simple as possible but if the reporter wants to
>     find some help and hints they should be there. ]

IMO, if there's a user who has a problem with _our_ code, we should do our best
to help him even if he doesn't report the bug very well.  Also, if the problem
is not with the most recent kernel, we should at least ask the reporter to try
a newer version.

> * Bugs that sit in NEEDINFO state for more than i.e. one month should be
>   automatically closed.

I agree that we probably should do something like this.
 
> * After each major kernel release bugzilla should send a kind request for
>   retesting to all open bugs.

Good idea, IMO.

> * You can't close/reject bugs by email.

Well, how would you authenticate?

> * There is "Assigned-to:" field which is described as "This is the person in
>   charge of resolving the bug." in bugzilla's help so people get assumptions
>   that there is somebody who is supposed to handle the bug and that this
>   person should be actively working on it.  Both assumptions may be invalid
>   (orhpaned drivers, there are more high priority bugs etc.).

True and that's why I think there should be some poeple officially resposnible
for handling bugs (which involves talking with the reporter and forwarding the
bug to an appropriate developer if necessary etc.).

>   OTOH mailing list doesn't give such assumptions and encourages more active
>   attitudes of bugreporters.

Nothing prevents bugreporters from sending emails along with filing Bugzilla
reports.
 
>   [ also compare this with "Maintained" definition in MAINTAINERS file ]
> 
> * From maintainer/developer POV you really want to track bugs in public
>   (mailing list) so other people can jump in and help.
>
>   [ It is also important that the other developers see that you are active. ]

You can always ask on the list, pointing to the Bugzilla entry in question.
 
> * We want bug tracking the other way around: everything goes through mailing
>   list first (including bugs filled to the bug tracker) and if not fixed
>   quickly, somebody (maintainer of the given part of code or a higher level
>   maintainer) replies cc:ing bugzilla so the new bug entry is added.
> 
>   Also this way we fix trivial/easy/medium bugs ASAP or reject invalid ones
>   without any bugzilla overhead.  We also add a new patch description tags:
>   - "Fixes-bug:" tag with reference to the original discussion

Alternatively, we can give a Bugzilla link here pointing to the entry which
contains a pointer to the original discussion.  [This may be more convenient,
since some bugs are reported multiple times and tracked separately to the point
in which it turns out that they really are the same.]

>   and
>   - "Fixes-commit:" tag with reference to the kernel commit
>   which are automatically snooped by bugzilla from git so we keep info about
>   fixed bugs/regression for statistics, bugs history and to aid -stable team
>   in their efforts.
> 
>   [ This is just a blurry sketch of the desired workflow but please note how
>     this is different from just assigning your component to the mailing list
>     address which should already be possible. ]

This obviously is a matter for discussion.

I think that many bugs have been lost, because they haven't be recorded
anywhere and the Bugzilla is a place where you can record information about
the bug with some references to more information, if need be.  [BTW, that's
exactly what I use it for.]

> * Last but not least our bugzilla just looks ugly (it is _very_ important,
>   I feel disgusted each time I have to work with it, OTOH I love using
>   gitweb - you get the idea).

Well, that doesn't matter to me as long as it's useful.  Any ideas how to
improve that? ;-)
 
> Sigh, I've just realized that comparing to source code control we are in
> the "stone-age" when it comes to bug tracking.

I agree.

> Hmm, what about switching to some proprietary bug tracking system just to
> talk Linus into writing a superior one?  ;-)

I think that we just have to get an idea of what exactly is needed.  IOW, we
need to know exactly how we're going to handle bugs as much as we needed
to know exactly how we were going the handle the flow of changes.
Perhaps it would be necessary to use a proprietary bug tracking system for some
time for this purpose, but _maybe_ we can figure it out without anything like
that.

The first, most important, step is to realize that we have a problem ...

> > don't want to, just leave the entry as is and I'll close it when the fix is in
> > the Linus' tree.
> 
> > > Therefore I kindly ask you to defer filling bugs for new bugreports for
> > > a week or two, and give us some time to react (and always ping me about
> > > the bugreport status before filling bugzilla entry).
> > 
> > Well, I thought you'd get an email from the Bugzilla, but of course I can notify
> > you directly about reported regressions related to IDE.
> 
> I do get mails from bugzilla so if you are going to assign these bugs to
> yourself and track them, then no need to notify me.
> 
> [ I also regularly read your regressions list. ]

OK :-)
 
> > > The alternative solution would be that you fill all new bugreports but
> > > then please assign them to yourself and track their status (if after two
> > > weeks the problem is not fixed feel free to reassign bug to me).
> > 
> > I can do that, but please note that the bugs filed against IDE are assigned to
> > you automatically, so I'll have to reassign them to me (as I've just done with
> 
> Thank you.
> 
> > this particular entry).  If you don't want them to be assigned to you at all,
> > please contact the Bugzilla administrators and ask them to change that.
> 
> Well, I consider this from time to time...

Greetings,
Rafael
