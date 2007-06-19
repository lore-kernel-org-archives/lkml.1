Return-Path: <linux-kernel-owner+w=401wt.eu-S1757934AbXFSPE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934AbXFSPE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 11:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbXFSPEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 11:04:20 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33023 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753030AbXFSPET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 11:04:19 -0400
Date: Tue, 19 Jun 2007 17:04:35 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Oleg Verych <olecom@flower.upol.cz>
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
Message-ID: <20070619150435.GD12950@stusta.de>
References: <20070617220927.99ebc1ee.akpm@linux-foundation.org> <F1D642E5A91BC94D9504EC83AE19E6B0128A0D@ecqcmtlmail3.quebec.int.ec.gc.ca> <32209efe0706181531x5322533dr31dc90e6dd8c7973@mail.gmail.com> <46770A22.4020007@mbligh.org> <32209efe0706181556l2ed378f4sf520c3852f398fa4@mail.gmail.com> <46771C5D.10809@mbligh.org> <alpine.LFD.0.98.0706181706470.3593@woody.linux-foundation.org> <E1I0UzP-0004AY-Hy@flower> <20070619124855.GB12950@stusta.de> <20070619140512.GA19904@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070619140512.GA19904@flower.upol.cz>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 04:05:12PM +0200, Oleg Verych wrote:
>...
> On Tue, Jun 19, 2007 at 02:48:55PM +0200, Adrian Bunk wrote:
> > On Tue, Jun 19, 2007 at 06:06:47AM +0200, Oleg Verych wrote:
>...
> > >   When patch in sent to this PTS, your lovely
> > >   checkpatch/check-whatever-crap-has-being-sent tools can be set up as
> > >   gatekeepers, thus making impossible stupid errors with MIME coding,
> > >   line wrapping, whatever style you've came up with now in checking
> > >   sent crap.
> > 
> > The -mm kernel already implements what your proposed PTS would do.
> 
> Having all-in-one patchset, like -mm is easy thing to provide
> interested parties with "you know what you have -- crazy development"
> 
> However [P]TS is tracking, recording, organizing tool. {1} Andrew's cron
> daemon easily can run script to check status of particular patch (cc,
> tested-by, acked-by). If patch have no TS ID, Andrew's watchdog is
> barking back to patch originator (with polite asking to send patch as:
> 
> * TS as "To:" target
> * patch author as "Cc:" target, this is useful to require:
>   . author can check that copy himself with text-only pager program
>     (to see any MIME coding crap)
>   . preventing SPAM
> * maybe somebody else in Cc or Bcc.)

Quite a big part of -mm are git trees of maintainers.
Where are they in your tool?

And I still don't think your tool would make sense.
But hey, simply try it - that's the only way for you to prove me wrong.
People said similar things about the 2.6.16 kernel or my regression 
tracking, and I simply did it.

> > Plus it gives testers more or less all patches currently pending 
> > inclusion into Linus' tree in one kernel they can test.
> 
> Crazy development{0}. Somebody knows, that comprehensively testing
> hibernation is their thing. I don't care about it, i care about foo, bar.
> Thus i can apply for example lguest patches and implement and test new
> asm-offset replacement, *easily*. Somebody, as you know, likes new fancy
> file system, and no-way other. Let them be happy testing that thing
> *easily*. Because another fancy NO_MHz will hang their testing bench
> right after best ever speed results were recorded.

Patch dependencies and patch conflicts will be the interesting parts 
when you will implement this.

E.g. new fancy filesystem patch in -mm might depend on some VFS change 
that requires changes to all other filesystems.

I'm really looking forward to see how you will implement this for 
something like -mm with > 1000 patches (many of them git trees that 
themselves contain many different patches) without offloading all the 
additional work to the kernel developers.

> > The problem are more social problems like patches Andrew has never heard 
> > of before getting into Linus' tree during the merge window.
> 
> Linus' watchdog, as well, asking for valid patch id, or just doesn't
> care (in similar manner Linus does :).
> 
> So far no human is involved in social things. Do you agree?

No.

Forcing people to use some tool (no matter whether it's Bugzilla or
the PTS you want to implement) is 100% a social problem involving humans.

> Human power is worth and needed in particular patch discussion and
> testing under the participation (by Cc, acking, test-ok *e-mails*) of
> tracking system.

For getting people to use your tool, you will have to convince them that 
using your tool will bring them real benefits.

> > >...
> > > |-*- Feature Needed -*-
> > >   Addition, needed is hardware user tested have/had/used. Currently
> > >   ``reportbug'' tool includes packed specific and system specific
> > >   additions automaticly gathered and inserted to e-mail sent to BTS.
> > >   (e.g. <http://permalink.gmane.org/gmane.linux.debian.devel.kernel/29740>)
> > 
> > The problem is that most problems don't occur on one well-defined 
> > kind of hardware - patches often break in exactly the areas the patch
> > author expected no problems in.
> 
> I tried to test that new fancy FS, and couldn't boot because of
> yet-another ACPI crap. See theme{0}?
> 
> Overall testing, like Andrew does, is doubtless brave thing, but he have
> more time after {1}, isn't it?

I doubt the placing of some Acked-By- tags in patches is really what 
is killing Andrews time.

How does Andrew check the status of 1500 patches in -mm in your PTS?

And how do you implement the use case that Andrew forwards a batch of
200 patches to Linus? How does the information from your tool come into git?

But hey, write your tool and convince Andrew of it's advantages if you 
don't believe me.

> > And in many cases a patch for a device driver was written due to a bug 
> > report - in such cases a tester with the hardware in question is already 
> > available.
> 
> Tracking all possible testers (for next driver update, for example) is
> in question.

Spamming people who have some hardware with information about patches 
won't bring you anything. You need people willing to test patches that 
won't bring them any benefit - and if you have such people they are 
usually as well willing to simply regularly test -rc kernels.

> > >...
> > > > but in the end, it needs to also be easy and painfree to the people
> > > > involved, and also make sure that any added workflow doesn't require
> > > > even *more* load and expertise on the already often overworked 
> > > > maintainers..
> > > 
> > > Experienced BTS users and developers. Please, correct me if i'm wrong.
> > > At least e-mail part of Debian's BTS and whole idea of it is *exactly*
> > > what is needed. Bugzilla fans, you can still use you useless pet,
> > > because Debian developers have done things, to track and e-mail states
> > > of bugs: <http://permalink.gmane.org/gmane.linux.debian.devel.kernel/29736>
> > >...
> > 
> > "useless pet"?
> > Be serious.
> > How many open source projects use Bugzilla and how many use the Debian BTS?
> > And then start thinking about why the "useless pet" has so many more 
> > user...
> 
> I might be stupid, but i faced it. On my amd64 512M laptop i *cannot* run
> mozillka any more, for example!

Why not?

> And i don't care, because Linus said his
> opinion and i fully agree with him.

Did Linus state he would actually actively use a Debian BTS?
If not, then there's no advantage.

> > The Debian BTS requires you to either write emails with control messages 
> > or generating control messages with external tools.
> 
> Awesome!!! Are you wrote this reply to me by 
> 
> > In Bugzilla the same works through a web interface.
> 
> web interface? If you did .........</dev/random dd bs=1 count=13.....
> Actually you didn't ;)

There's a difference between a discussion email and a control message in 
a fixed format.

> > I know both the Debian BTS and Bugzilla and although they are quite 
> > different they both are reasonable tools for their purpose.
> 
> As you just might have seen here, i was talking about organizing,
> tracking, hopefully saving and redirecting useful main power. And i don't
> bother search e-mails i saw about Bugzilla's BD from many other prominent
> developers. I just know that, not from my dream or physical vacuum.
> 
> Basic concept of Debian BTS is what i've discovered after many useless
> hours i spent in Bugzilla. And this is mainly because of one basic
> important thing, that nobody acknowledged (for newbies, like me):
> 
> * E-Mail with useful MUAs, after it got reliable delivery MTAs with qmail
>   (or exim) is the main communication toolset.
>...

How do people sell and buy goods at eBay?
eBay has a "do everything through the web interface plus notification 
emails" quite similar to Bugzilla.

Or Wikis?
Or Blogs?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

