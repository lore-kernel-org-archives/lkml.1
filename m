Return-Path: <linux-kernel-owner+w=401wt.eu-S1754756AbXKYAVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbXKYAVt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 19:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbXKYAVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 19:21:38 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:15872 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbXKYAVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 19:21:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=nD6uR/hEaAy3GR+eOA/ErwkkDNSNtqJ0No3f38h5rNhPNg3b5UWHHe+egsRd5Qo3UPJ/2//BodC894ys5QCRYs3G1zhOi/vClh9Sb3/gT8h4hUwZUnJnPdmtg+zwtgfMBndVjdX/o4VwuH0CTHkd98c/ppy1fms07sGXN2bFwDY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: kernel bugzilla is FPOS (was: Re: "buggy cmd640" message followed by soft lockup)
Date: Sun, 25 Nov 2007 01:26:11 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <200711222007.12497.elendil@planet.nl> <200711241904.13132.bzolnier@gmail.com> <200711242007.52430.rjw@sisk.pl>
In-Reply-To: <200711242007.52430.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200711250126.11603.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[ I removed Frans from cc: since it is off-topic to the original bugreport ]

On Saturday 24 November 2007, Rafael J. Wysocki wrote:
> On Saturday, 24 of November 2007, Bartlomiej Zolnierkiewicz wrote:
> [--snip--]
> > Rafael, I see that you've filled a bug for this bugreport into kernel
> > bugzilla tracker (one day after the bugreport):
> > 
> > 	http://bugzilla.kernel.org/show_bug.cgi?id=9442
> > 
> > Since we try to address regressions with the highest priority in the
> > IDE-land (and usually they get fixed quickly) I would strongly prefer to
> > use bugzilla only for long-term bugs and avoid the needless bureaucracy.
> 
> As a rule, I put all of the reported regressions into the Bugzilla early.  You
> are not required to use these entries for tracking the bugs, though.  If you

[ I really don't think that the recent push from both Andrew and you in
  bugzilla direction is a good thing... ]

There is a mix of technical and psychological issues with using bugzilla:

* Interface for filling bugs is a joke:
  - help for "Product" selection is mediocre
    ("IO/Storage:" -> "Bugs related to IO")
  - there is no help for "Componenet" selection
  - "Some basic debugging hints" are not there
  - "Kernel version" given by reporter should be checked against the latest
    kernel version and if not matching there should be a kind request to
    retest with the latest kernel
  - it should be strongly suggested to attach dmesg output and kernel config
  - zillion other little improvements...

  [ The average bug quality is not very high (bugs often lack critical
    information) and this is really not reporters' fault!  The interface
    should be kept as simple as possible but if the reporter wants to
    find some help and hints they should be there. ]

* Bugs that sit in NEEDINFO state for more than i.e. one month should be
  automatically closed.

* After each major kernel release bugzilla should send a kind request for
  retesting to all open bugs.

* You can't close/reject bugs by email.

* There is "Assigned-to:" field which is described as "This is the person in
  charge of resolving the bug." in bugzilla's help so people get assumptions
  that there is somebody who is supposed to handle the bug and that this
  person should be actively working on it.  Both assumptions may be invalid
  (orhpaned drivers, there are more high priority bugs etc.).  OTOH mailing
  list doesn't give such assumptions and encourages more active attitudes
  of bugreporters.

  [ also compare this with "Maintained" definition in MAINTAINERS file ]

* From maintainer/developer POV you really want to track bugs in public
  (mailing list) so other people can jump in and help.

  [ It is also important that the other developers see that you are active. ]

* We want bug tracking the other way around: everything goes through mailing
  list first (including bugs filled to the bug tracker) and if not fixed
  quickly, somebody (maintainer of the given part of code or a higher level
  maintainer) replies cc:ing bugzilla so the new bug entry is added.

  Also this way we fix trivial/easy/medium bugs ASAP or reject invalid ones
  without any bugzilla overhead.  We also add a new patch description tags:
  - "Fixes-bug:" tag with reference to the original discussion
  and
  - "Fixes-commit:" tag with reference to the kernel commit
  which are automatically snooped by bugzilla from git so we keep info about
  fixed bugs/regression for statistics, bugs history and to aid -stable team
  in their efforts.

  [ This is just a blurry sketch of the desired workflow but please note how
    this is different from just assigning your component to the mailing list
    address which should already be possible. ]

* Last but not least our bugzilla just looks ugly (it is _very_ important,
  I feel disgusted each time I have to work with it, OTOH I love using
  gitweb - you get the idea).

Sigh, I've just realized that comparing to source code control we are in
the "stone-age" when it comes to bug tracking.   Hmm, what about switching
to some proprietary bug tracking system just to talk Linus into writing
a superior one?  ;-)

> don't want to, just leave the entry as is and I'll close it when the fix is in
> the Linus' tree.

> > Therefore I kindly ask you to defer filling bugs for new bugreports for
> > a week or two, and give us some time to react (and always ping me about
> > the bugreport status before filling bugzilla entry).
> 
> Well, I thought you'd get an email from the Bugzilla, but of course I can notify
> you directly about reported regressions related to IDE.

I do get mails from bugzilla so if you are going to assign these bugs to
yourself and track them, then no need to notify me.

[ I also regularly read your regressions list. ]

> > The alternative solution would be that you fill all new bugreports but
> > then please assign them to yourself and track their status (if after two
> > weeks the problem is not fixed feel free to reassign bug to me).
> 
> I can do that, but please note that the bugs filed against IDE are assigned to
> you automatically, so I'll have to reassign them to me (as I've just done with

Thank you.

> this particular entry).  If you don't want them to be assigned to you at all,
> please contact the Bugzilla administrators and ask them to change that.

Well, I consider this from time to time...

Bart
