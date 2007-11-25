Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbXKYOBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbXKYOBX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 09:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbXKYOBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 09:01:13 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:15890 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbXKYOBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 09:01:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=C8xLxAjeE+9tIcZTwvwlMLkeFLpoqXUyXZ1QYhSROkT+1ESDaEu6vpnod19jYCqzhBmZBh47l7GcI9jZsWkfygbAA/noloAokUu5/DOGx+Hhf8A1zBJz1NIQk27sGH9Gi/rw4Ipl4y4UBDRtDer0vIJXRp7ZvT8EGy+ex4QMbl0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: kernel bugzilla is FPOS (was: Re: "buggy cmd640" message followed by soft lockup)
Date: Sun, 25 Nov 2007 15:08:11 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, Adrian Bunk <bunk@kernel.org>
References: <200711222007.12497.elendil@planet.nl> <200711250126.11603.bzolnier@gmail.com> <200711251411.16034.rjw@sisk.pl>
In-Reply-To: <200711251411.16034.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200711251508.11434.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Sunday 25 November 2007, Rafael J. Wysocki wrote:
> On Sunday, 25 of November 2007, Bartlomiej Zolnierkiewicz wrote:
> > 
> > [ I removed Frans from cc: since it is off-topic to the original bugreport ]
> > 
> > On Saturday 24 November 2007, Rafael J. Wysocki wrote:
> > > On Saturday, 24 of November 2007, Bartlomiej Zolnierkiewicz wrote:
> > > [--snip--]
> > > > Rafael, I see that you've filled a bug for this bugreport into kernel
> > > > bugzilla tracker (one day after the bugreport):
> > > > 
> > > > 	http://bugzilla.kernel.org/show_bug.cgi?id=9442
> > > > 
> > > > Since we try to address regressions with the highest priority in the
> > > > IDE-land (and usually they get fixed quickly) I would strongly prefer to
> > > > use bugzilla only for long-term bugs and avoid the needless bureaucracy.
> > > 
> > > As a rule, I put all of the reported regressions into the Bugzilla early.  You
> > > are not required to use these entries for tracking the bugs, though.  If you
> > 
> > [ I really don't think that the recent push from both Andrew and you in
> >   bugzilla direction is a good thing... ]
> 
> Well, I use the Bugzilla as a tool for tracking regressions.
> 
> You don't need to use or even follow the entries created by me, but some
> people do with good results.
> 
> > There is a mix of technical and psychological issues with using bugzilla:
> > 
> > * Interface for filling bugs is a joke:
> >   - help for "Product" selection is mediocre
> >     ("IO/Storage:" -> "Bugs related to IO")
> 
> Here, I agree, but IMO that's an organizational issue.  We first should assign
> people to handling bugs related to various subsystems and based on that create
> the menu so that the right people are notified of the reports.
> 
> >   - there is no help for "Componenet" selection
> >   - "Some basic debugging hints" are not there
> 
> It looks like you'd like the reporter to initially debug the issue for you
> before actually reporting it.  I don't think it's realistic. ;-)

Give people right hints and tools and they will work miracles. ;-)

If user reports hard lockup propably the first thing to ask will be
to try NMI watchdog etc.  We have this kind of information spreaded
through various files in Documentation/ (and also other sources).

What we right now we have in bugzilla is:

"
Some basic debugging hints

    * Diagnosing OOM conditions
    * Debugging kernel hangs
    * Setting up a serial console
"

[ at http://test.kernel.org/bugzilla/faq.html ]

and all entries end up with "This page does not exist yet. You can create
a new empty page, or use one of the page templates. Before creating the
page, please check if a similar page already exists."

> >   - "Kernel version" given by reporter should be checked against the latest
> >     kernel version and if not matching there should be a kind request to
> >     retest with the latest kernel
> 
> Why?

To speedup a process.

> If someone has a problem with 2.6.23.x which has already been fixed in the
> mainline, we should be able to point him to the fix.  If we aren't, then
> something is wrong on our side.

Sure there is something wrong on our side as we don't store this kind of
information in organized way currently.

> >   - it should be strongly suggested to attach dmesg output and kernel config
> 
> I, personally, don't like reports with dmesgs and .configs attached from the
> start, especially if they are cut'n'pasted into the message window, because

I do.

> they often don't contain the relevant information.

If you are lucky the right information will be there and it will save both
reporter and the developer one "communication cycle".

> >   - zillion other little improvements...
> 
> Sure, improvements are always possible. :-)
> 
> >   [ The average bug quality is not very high (bugs often lack critical
> >     information) and this is really not reporters' fault!  The interface
> >     should be kept as simple as possible but if the reporter wants to
> >     find some help and hints they should be there. ]
> 
> IMO, if there's a user who has a problem with _our_ code, we should do our best
> to help him even if he doesn't report the bug very well.  Also, if the problem
> is not with the most recent kernel, we should at least ask the reporter to try
> a newer version.

Fully agreed.

I rather meant that the we can make the process work better for both sides.

> > * Bugs that sit in NEEDINFO state for more than i.e. one month should be
> >   automatically closed.
> 
> I agree that we probably should do something like this.
>  
> > * After each major kernel release bugzilla should send a kind request for
> >   retesting to all open bugs.
> 
> Good idea, IMO.
> 
> > * You can't close/reject bugs by email.
> 
> Well, how would you authenticate?

Technically it is not a problem at all, i.e. you can sign mail with GPG etc.

> > * There is "Assigned-to:" field which is described as "This is the person in
> >   charge of resolving the bug." in bugzilla's help so people get assumptions
> >   that there is somebody who is supposed to handle the bug and that this
> >   person should be actively working on it.  Both assumptions may be invalid
> >   (orhpaned drivers, there are more high priority bugs etc.).
> 
> True and that's why I think there should be some poeple officially resposnible
> for handling bugs (which involves talking with the reporter and forwarding the
> bug to an appropriate developer if necessary etc.).
> 
> >   OTOH mailing list doesn't give such assumptions and encourages more active
> >   attitudes of bugreporters.
> 
> Nothing prevents bugreporters from sending emails along with filing Bugzilla
> reports.

Duplicating efforts is not good thing (wasted time).

[...]

> > * Last but not least our bugzilla just looks ugly (it is _very_ important,
> >   I feel disgusted each time I have to work with it, OTOH I love using
> >   gitweb - you get the idea).
> 
> Well, that doesn't matter to me as long as it's useful.  Any ideas how to
> improve that? ;-)

Well, I hope that we can use some help from distro people here
(many distros have bugzillas superior to our).

Bart
