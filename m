Return-Path: <linux-kernel-owner+w=401wt.eu-S1751253AbZHARDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253AbZHARDY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 13:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbZHARDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 13:03:23 -0400
Received: from phunq.net ([64.81.85.152]:47739 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750874AbZHARDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 13:03:22 -0400
X-Greylist: delayed 1227 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Aug 2009 13:03:22 EDT
From: Daniel Phillips <phillips@phunq.net>
To: debian developer <debiandev@gmail.com>
Subject: Re: [Tux3] Current Activities?
Date: Sat, 1 Aug 2009 09:42:51 -0700
User-Agent: KMail/1.9.9
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, tux3@tux3.org,
       LKML <linux-kernel@vger.kernel.org>, corbet@lwn.net
References: <6dcc37b30904291901m7abdd6d7q6f44b2c248ec48c4@mail.gmail.com> <200904302049.27235.phillips@phunq.net> <f24d23310907310210w4406f596nc5b85a7ff41ee40c@mail.gmail.com>
In-Reply-To: <f24d23310907310210w4406f596nc5b85a7ff41ee40c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908010942.52623.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 July 2009, debian developer wrote:
> Hi Daniel,
> 
> On Fri, May 1, 2009 at 9:19 AM, Daniel Phillips<phillips@phunq.net> wrote:
> > On Wednesday 29 April 2009, t3right.thebashar@xoxy.net wrote:
> >> Hi Daniel,
> >>
> >> I want to apologize upfront if I sound like one of those "when will it
> >> be done" questions that are best left unasked with most open source
> >> projects.  Actually, I'm just really curious about what's been going
> >> on lately.  I am somewhat embarrassed to admit that I became
> >> fascinated with tux3's development since the first time it was
> >> featured in an article on kerneltrap.  I've greatly enjoyed reading
> >> your design notes and dialog with the btrfs team.  I had no naive
> >> hopes that tux3 would get integrated into the linux kernel
> >> immediately, but I've been extremely surprised at the loss of public
> >> progress notes from you after the initial review request back and
> >> forth died off.  In fact it seems like there's only been 7 postings
> >> from you in the month since the last kernel merge related thread.
> >>
> >> I've really missed the public view into tux3's progress.  If it's not
> >> too presumptuous, how are you? How's tux3 coming along?  What part of
> >> the kernel port is taking the bulk of the work?  What new and
> >> interesting challenges have you been wrestling with?
> >
> > Actually, I have been busy with real life for the last couple
> > of months.  An interesting challenge is how I can keep up the
> > previous development without any corporate support.  Zero.  Zip.
> > Nada.  There has been exactly zero support from the usual
> > suspects, who all have their own good reasons no doubt, which
> > do not necessarily have much to do with the good of the Linux
> > kernel or the Linux community.
> >
> > That challenge is being addressed.  Addressing it takes time and
> > energy.  Development progress continues, though perhaps not as
> > visible as it was earlier.  Being that visible takes a lot of time.
> > The Tux3 watcher community could help a lot there.  For example,
> > there is a large volume of technical material posted by me and
> > others, that needs to be organized into a coherent form.  I simply
> > don't have time to do that myself.  There are a bunch of projects
> > like that.
> >
> > I also need more response to my occasional calls for volunteers.
> > How many list readers have downloaded the code and run it?  You
> > can in fact boot to a root fileystem with it.  How many besides
> > me and Hirofumi have done that?
> >
> > Anyway, Andrew Morton was right, we should have merged into
> > mainline as soon as Tux3 was booting as root.  That would have
> > taken a big load off me.  Instead, somebody posted to LKML and
> > called for atomic commit as a precondition for merging.  Sounds
> > like a good idea, sounds logical.  But actually, in open source
> > it is counter productive, it just puts a bigger load on me, a
> > limited resource.  We should have merged first, then got the
> > logging and replay working.  In fact, we probably should still do
> > that.  I will say this now: if we are invited to merge in the
> > next major release, or in -mm or whatever, we will happily do it.
> > If we are not invited to merge, nobody has any cause to complain
> > about progress slowing down.
> >
> > Anyway, now would be a good time to have a discussion here on the
> > Tux3 list about what can be done to get more helping hands
> > involved in the heavy lifting.
> >
> 
> A list of beginner projects with instructions on how to get off would
> be helpful.
> Beginners need to be motivated to hang around long enough to become core
> developers. I am sure you will not find many core developers who are willing to
> find time to hack on another project, almost everyone has their hands full.

For your information, I have my hands more than full with things entirely
unrelated to filesystem hacking.  This situation will last another few
days then I should be able to refocus at least part of my time to the
project.  Which I still believe in completely, and want to have running
on my own computers as soon as possible.

Anyway, let me offer two beginner projects:

  1) Add success checks to unit tests
  2) add a "check" command to the tux3 command

Unit test success:

  - Unit tests are compiled as main programs in tux/user, that include
    kernel files and sometimes other userspace files as source text,
    for example: #include "kernel/filemap.c"

  - Currently, unit tests just run and produce output.  If something is
    wrong an assertion may trigger, or it may segfault, or the tracing
    output may be unreasonable.

  - It would be better if the test concluded with a test to see that
    then final result is as expected, according to the operations that
    were performed.  The main program should return 0 with no warning
    if results are correct, otherwise print a warning and return 1, a
    failure code for a shell script we may add later.

Tux3 check:

   - Command form should be:

       tux3 check <volume> [<file>]

   - As a first approximation, should just walk the filesystem tree from
     the root as Hirofumi's tux3graph program does, checking that
     physical block pointers lie within the volume and that leaf nodes
     of the inode table and file data subtrees pass the leaf checks
     already implemented.

   - Later, this walk will build a bitmap map of used blocks so that we
     can check that there is no lost space in the volume and that actual
     used/free matches the allocation bitmaps.  When building the bitmap
     we can also check for multiple pointers to the same block, which
     are not allowed in tux3.

> Other thing is the need to talk to organizations. You could have
> easily listed tux3

Anybody who wants to do that is welcome to, anybody who wants to can
appoint themselves an official representative of the tux3 project, there
is no need to ask.  Just come by irc and let us know what happened :-)

> for Google Summer of Code 2009. It would have brought attention and resources
> for the project. I am sure you will find financing as you are well
> recognized in your
> domain. I am including LKML so that others will hopefully notice and respond.
> 
> May be jonathan can help in advertising the need for developers better
> through LWN.
> 
> This can be easily done by one of us if there is a wiki. Also a wiki helps us to
> collate things which we have learned till now.

Shapor maintains our website, which does have a wiki.  Just ping him on
irc about it.

> So two things:
> 
> 1. Put up a wiki (important)
> 2. List of starter projects.
> 
> I see the dedup feature is partially complete. May be it can be completed and
> included in the kernel source of tux3. We need more projects like this.
> 
> Hope to see some activity soon. Do not let the project die.

As you just demonstrated, it can't die, it's open source.

Regards,

Daniel
