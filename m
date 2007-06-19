Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbXFSNwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbXFSNwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 09:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbXFSNwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 09:52:41 -0400
Received: from barikada.upol.cz ([158.194.242.200]:34835 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbXFSNwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 09:52:40 -0400
Date: Tue, 19 Jun 2007 16:05:12 +0200
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@mbligh.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: This is [Re:] How to improve the quality of the kernel[?].
Message-ID: <20070619140512.GA19904@flower.upol.cz>
References: <4675C083.6080409@s5r6.in-berlin.de> <20070617220927.99ebc1ee.akpm@linux-foundation.org> <F1D642E5A91BC94D9504EC83AE19E6B0128A0D@ecqcmtlmail3.quebec.int.ec.gc.ca> <32209efe0706181531x5322533dr31dc90e6dd8c7973@mail.gmail.com> <46770A22.4020007@mbligh.org> <32209efe0706181556l2ed378f4sf520c3852f398fa4@mail.gmail.com> <46771C5D.10809@mbligh.org> <alpine.LFD.0.98.0706181706470.3593@woody.linux-foundation.org> <E1I0UzP-0004AY-Hy@flower> <20070619124855.GB12950@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619124855.GB12950@stusta.de>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Dropping noise for Debbugs, because interested people may join via Gmane]

On Tue, Jun 19, 2007 at 02:48:55PM +0200, Adrian Bunk wrote:
> On Tue, Jun 19, 2007 at 06:06:47AM +0200, Oleg Verych wrote:
> > [Dear Debbug developers, i wish your ideas will be useful.]
> > 
> > * From: Linus Torvalds
> > * Newsgroups: gmane.linux.kernel
> > * Date: Mon, 18 Jun 2007 17:09:37 -0700 (PDT)
> > >
> > > On Mon, 18 Jun 2007, Martin Bligh wrote:
> > >> 
> > >> Sorry to be a wet blanket, but I've seen those sort of things
> > >> before, and they just don't seem to work, especially in the
> > >> environment we're in with such a massive diversity of hardware.
> > >
> > > I do agree. It _sounds_ like a great idea to try to control the flow of 
> > > patches better,
> > 
> > There were some ideas, i will try to summarize:
> > 
> > * New Patches (or sets) need tracking, review, testing
> > 
> >   Zero (tracking) done by sending (To, or bcc) [RFC] patch to something
> >   like submit@pts.e-mail.example.com (like BTS now). Notifications will
> >   be sent to intrested maintainers (if meta-information is ok) or testers
> >   (see below)
> > 
> >   First is mostly done by maintainers or interested individuals.
> >   Result is "Acked-by" and "Cc" entries in the next patch sent. Due to
> >   lack of tracking this things are done manually, are generally in
> >   trusted manner. But bad like <200706172053.41806.bzolnier@gmail.com>
> >   sometimes happens.
> 
> The goal is to get all patches for a maintained subsystem submitted to 
> Linus by the maintainer.
> 
> >   When patch in sent to this PTS, your lovely
> >   checkpatch/check-whatever-crap-has-being-sent tools can be set up as
> >   gatekeepers, thus making impossible stupid errors with MIME coding,
> >   line wrapping, whatever style you've came up with now in checking
> >   sent crap.
> 
> The -mm kernel already implements what your proposed PTS would do.

Having all-in-one patchset, like -mm is easy thing to provide
interested parties with "you know what you have -- crazy development"

However [P]TS is tracking, recording, organizing tool. {1} Andrew's cron
daemon easily can run script to check status of particular patch (cc,
tested-by, acked-by). If patch have no TS ID, Andrew's watchdog is
barking back to patch originator (with polite asking to send patch as:

* TS as "To:" target
* patch author as "Cc:" target, this is useful to require:
  . author can check that copy himself with text-only pager program
    (to see any MIME coding crap)
  . preventing SPAM
* maybe somebody else in Cc or Bcc.)

> Plus it gives testers more or less all patches currently pending 
> inclusion into Linus' tree in one kernel they can test.

Crazy development{0}. Somebody knows, that comprehensively testing
hibernation is their thing. I don't care about it, i care about foo, bar.
Thus i can apply for example lguest patches and implement and test new
asm-offset replacement, *easily*. Somebody, as you know, likes new fancy
file system, and no-way other. Let them be happy testing that thing
*easily*. Because another fancy NO_MHz will hang their testing bench
right after best ever speed results were recorded.

> The problem are more social problems like patches Andrew has never heard 
> of before getting into Linus' tree during the merge window.

Linus' watchdog, as well, asking for valid patch id, or just doesn't
care (in similar manner Linus does :).

So far no human is involved in social things. Do you agree?

Human power is worth and needed in particular patch discussion and
testing under the participation (by Cc, acking, test-ok *e-mails*) of
tracking system.

> >...
> > |-*- Feature Needed -*-
> >   Addition, needed is hardware user tested have/had/used. Currently
> >   ``reportbug'' tool includes packed specific and system specific
> >   additions automaticly gathered and inserted to e-mail sent to BTS.
> >   (e.g. <http://permalink.gmane.org/gmane.linux.debian.devel.kernel/29740>)
> 
> The problem is that most problems don't occur on one well-defined 
> kind of hardware - patches often break in exactly the areas the patch
> author expected no problems in.

I tried to test that new fancy FS, and couldn't boot because of
yet-another ACPI crap. See theme{0}?

Overall testing, like Andrew does, is doubtless brave thing, but he have
more time after {1}, isn't it?

> And in many cases a patch for a device driver was written due to a bug 
> report - in such cases a tester with the hardware in question is already 
> available.

Tracking all possible testers (for next driver update, for example) is
in question.

> 
> >...
> > > but in the end, it needs to also be easy and painfree to the people
> > > involved, and also make sure that any added workflow doesn't require
> > > even *more* load and expertise on the already often overworked 
> > > maintainers..
> > 
> > Experienced BTS users and developers. Please, correct me if i'm wrong.
> > At least e-mail part of Debian's BTS and whole idea of it is *exactly*
> > what is needed. Bugzilla fans, you can still use you useless pet,
> > because Debian developers have done things, to track and e-mail states
> > of bugs: <http://permalink.gmane.org/gmane.linux.debian.devel.kernel/29736>
> >...
> 
> "useless pet"?
> Be serious.
> How many open source projects use Bugzilla and how many use the Debian BTS?
> And then start thinking about why the "useless pet" has so many more 
> user...

I might be stupid, but i faced it. On my amd64 512M laptop i *cannot* run
mozillka any more, for example! And i don't care, because Linus said his
opinion and i fully agree with him.

> The Debian BTS requires you to either write emails with control messages 
> or generating control messages with external tools.

Awesome!!! Are you wrote this reply to me by 

> In Bugzilla the same works through a web interface.

web interface? If you did .........</dev/random dd bs=1 count=13.....
Actually you didn't ;)

> I know both the Debian BTS and Bugzilla and although they are quite 
> different they both are reasonable tools for their purpose.

As you just might have seen here, i was talking about organizing,
tracking, hopefully saving and redirecting useful main power. And i don't
bother search e-mails i saw about Bugzilla's BD from many other prominent
developers. I just know that, not from my dream or physical vacuum.

Basic concept of Debian BTS is what i've discovered after many useless
hours i spent in Bugzilla. And this is mainly because of one basic
important thing, that nobody acknowledged (for newbies, like me):

* E-Mail with useful MUAs, after it got reliable delivery MTAs with qmail
  (or exim) is the main communication toolset.

Can't you see that from Linux's patch sending policy?

I also what to reply to myself about why LKML was established and
USENET (news) was abandoned.

To control and to keep running *your* _main communication toolset_
(read as "your user,developer feedback").

I just couldn't realize that, because i grew up in free web e-mail, after
having set up my own server with MTA and real e-mail and after
discovering Gmane (really mind-blowing evolution of the e-mail system!)

> cu
> Adrian
> 
> -- 
____
