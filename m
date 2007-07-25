Return-Path: <linux-kernel-owner+w=401wt.eu-S935970AbXGYTau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935970AbXGYTau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 15:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935692AbXGYTac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 15:30:32 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:45616
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935418AbXGYTa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 15:30:29 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 1/7] lguest: documentation pt I: Preparation
Date: Wed, 25 Jul 2007 15:30:26 -0400
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
References: <1184980678.6344.1.camel@localhost.localdomain> <20070723171238.1a832b31.akpm@linux-foundation.org> <20070723192113.0eaa0ad8.rdunlap@xenotime.net>
In-Reply-To: <20070723192113.0eaa0ad8.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707251530.26326.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 July 2007 10:21:13 pm Randy Dunlap wrote:
> On Mon, 23 Jul 2007 17:12:38 -0700 Andrew Morton wrote:
> > On Sat, 21 Jul 2007 11:17:58 +1000
> >
> > Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > The netfilter code had very good documentation: the Netfilter Hacking
> > > HOWTO.  Noone ever read it.
> > >
> > > So this time I'm trying something different, using a bit of
> > > Knuthiness.  Start with drivers/lguest/README.
> >
> > um.
> >
> > I'm OK with merging patches and given lguest's newness, the timestamp on
> > these patches, the fact that they don't change code generation (right?)
> > and my reluctance to carry large do-nothing patches for two months, I'd
> > be OK with squeaking them into 2.6.23.
> >
> > But I worry that you're proposing adding what appears to be new
> > Documentation-related machinery and infrastructure when there's already
> > increased activity in that area from other people and we might all be
> > headed in different directions and stuff.
> >
> > So first I think we'd best form a kernel kommittee and mull this for a
> > while (preferably months) to screw you around as much as poss, OK?  ;)

My cent and a half:

Writing documentation is not the hardest part.  It's brutally hard, falls way 
behind the rest of development, and we may never have enough of it, but it 
turns out it's not the real _problem_.

The problem, as Rusty pointed out, is that nobody can find the documentation 
we've got because it's horribly indexed.

There's Documentation/ and "make htmldocs" in the kernel, which don't 
cross-reference each other.  Each of those has strong structural constraints: 

  Documentation is text and thus doesn't link out to the rest of the world
  gracefully.  The index really needs to be HTML because it's going to link to
  other HTML, PDF, video, wikis, tarballs of example code, source control web
  interface entries with an interesting checkin comment, and strange things I
  haven't even encountered yet.

  The htmldocs output is generated from the kernel source.  It doesn't even
  link out to the text files in Documentation most of the time, let alone out
  to the web.

People assume including all the documentation into the kernel tarball is a 
reasonable thing to do, but just the Ottawa Linux Symposium PDF files total 
several megabytes, and that's a single source of information, only about half 
of which is actually relevant to the kernel.  (Selecting that half turns out 
to be nontrivial, and it changes over time as speculative things turn real 
and other stuff goes the way of "caloric fluid".  Reiser 4 has bounced back 
and forth something like 5 times now.)

There's documentation out on developer's web pages.  There's documentation in 
wikipedia.  There's documentation on "magazine" style websites (Linux Weekly 
News, Kerneltrap, Linux Journal, and more).  There's documentation in 
developer blogs (kernelplanet.org aggregates several).  There's documentation 
on project pages on sourceforge.  There's documentation in wikis like 
kernelnewbies or Rik van Riel's mm stuff.  There's documentation in freely 
available online books like Linux Device Drivers and Mel Gorman's memory 
management book.

Lots of the time, the _rationale_ for something was explained on linux-kernel 
and the best thing to do to really understand it is link to three or four 
messages out of an lkml archive.  And sometimes, you need a summary.  
(Summarizing the recent GPLv3 discussion from the kernel developers' 
perspective isn't something I'm looking forward to, and no linking to a 1000+ 
message thread and saying "read this" is not a substitute for a coherent 
summary.  Jonathan Corbet does this kind of stuff, but it was still in 
progress last time he wrote about it, and he didn't really try to extract a 
coherent policy decision out of the flamewar and bounce it off Linus for a 
thumbs up/thumbs down.)

So I'm focusing on indexing all this existing (and new) documentation.  I'm 
writing a few bits that I happen to think I know about, or that people come 
to me and ask "where can I find documentation on this" and I can't find any, 
so I research it and write it.  But mostly I'm attempting to turn 
http://kernel.org/doc into the first stop to find something else.

Currently, that page is horrible, mostly because keeping up with the influx of 
NEW information that needs organizing is almost impossible and the huge pile 
of existing information gets neglected.  (I spent almost three months on 
triage, which is kind of frustrating.)  But I'm getting on top of it and hope 
to have a useful (if skeletal) index up there by the end of the week.  
(Moving back to Austin is screwing it up but I'm -><- this close, darn it.)

To get the old to-do heap under control, most of linux-kernel is falling on 
the floor, my to-read pile of things linked from lwn is getting laughably 
long, things are sometimes scrolling off the bottom of kernelplanet.org 
before I get to them, and so on.  But once I've got a skeleton to hang things 
on, I can delegate bits of it (like the whole VFS documentation and 
filesystems under it) to other people.

> > Items for consideration would be:
> >
> > - if this stuff is good, shouldn't other code be using it?  If so, is
> >   this new infrastructure in the correct place?
>
> I wouldn't mind having a new doc infrastructure, but I don't see this as
> it.

There's a mailing list, linux-doc@vger.kernel.org, that was _made_ for this 
kind of discussion.  I'm happy to have people tell me what I'm doing wrong, 
make suggestions, or volunteer to tackle some problem.  (Note, after the 
recent hotplug documentation thread, I feel the need to clarify that "you are 
an idiot" does not, in and of itself, qualify as useful feedback.)

> > - if, otoh, this infrastructure is _not_ suitable for other code, well,
> >   what was wrong with it?
>
> I think that we don't want to give up html/pdf/ps output formats in
> favor of just text or C source code.

Agreed.  Keep in mind that whatever your infrastructure is, you will never be 
generating the bulk of the contributions to it.  You will be integrating 
outside contributions.  And the outside contributions are primarily in HTML 
and PDF these days.  (Postscript less so, but it's still there.  And the 
occasional batch of "source formats" (tex, docbook, etc) from which HTML and 
PDF get produced, but if a web browser can't view the data format directly 
the audience for the documentation's going to be about three people, 
including the author.  Source code comments are an exception to this, but 
that can of worms is familiar enough here already.  I note that man pages are 
also sort of an exception, but a rapidly diminishing one as things like 
doclifter get off the ground.  I note that the maintainer of the man-pages 
package now has his own http://kernel.org/doc/man-pages directory because he 
wants to generate his own html versions rather than having me do it with 
doclifter.  The masters for most of the man pages are now in docbook anyway.)

> If we do continue to have 
> multiple "rich" output formats, we need even more rich syntax rules
> than we have right now.  OTOH, if we dump all of those rich output
> formats, we have less tool spice that is needed.

Keep in mind that the licensing on a lot of documentation allows it to be 
freely redistributed but not freely modified.  (Yes, this sucks, but it's a 
real world problem the same way PDF is a real world format.  Yes you can talk 
to the author, convert it into another format, or write new documentation 
once you've learned what you need from the other documentation.  But this 
takes time.)

> (I'm not ignoring Andrew's question here.  I'm just applying the
> 7 patches/series and looking at it more.)
>
> > - if the requirement is good, perhaps alternative implementations should
> >   be explored (dunno what).
>
> Yes, but I dunno what either.

I don't want to impose a workflow on documentation authors.  I don't care what 
tools they used to create HTML or PDF: they can do it in emacs or vi, they 
can use a word processor, they can use latex, or something else entirely.  I 
really don't care.  I just want to index the result.  Ideally I want to be 
able to mirror it, and being able to send comments back to the author to get 
updated versions is wonderful but at the moment it's sadly a luxury.

For example, I have Mel Gorman's memory management book mirrored at 
http://kernel.org/doc/gorman but Mel hasn't got time to update it, and he has 
to ping his publisher to see what rights have reverted to him, and when it 
comes to theoretical third-party contributions to it (of which there have so 
far been none) he has to figure out how much control he wants to give up over 
his baby anyway.  I put him and Don Marti of LinuxWorld in touch with each 
other and Mel MIGHT have time to break the book up into a series of smaller 
(updated) articles to run on LinuxWorld, each of which would be much easier 
to replace with a new version if one of them gets too badly outdated...

Half the time, when something gets passed from maintainer to maintainer, it 
gets remastered into a new source format anyway.

> > IOW, I'd be interested in hearing Rob and Randy's opinions on it all,
> > please.
>
> It's great that Rusty took the time to produce all of this documentation.
> Few people do that today.

Yay Rusty!  He writes good docs.  Kudos to his hamster.

Now the questions are:

1) How do people _find_ this documentation.
2) Review and integrating feedback.
3) Keeping it up to date in future.

I'm happy to index Rusty's doc.  This thread hasn't included the URL?  Google 
comes up with the lwn.net copy of the start of this thread:
http://lwn.net/Articles/242558/

I'm trying to maintain a documentation index: I can't maintain all the 
documentation I index, any more than Linus personally maintains the ipw2200 
wireless driver (and associated firmware).  I can sometimes note when 
something's out of date and try to do something about it, but the "something" 
varies on a case-by-case basis.

> Were current kernel-doc tools not sufficient?  If not, why not?

If by the current kernel-doc tools you mean the giant perl script to beat 
docbook out of javadoc-style comments out of the kernel source with regexes, 
that's great for documenting the arguments to functions in the kernel, and 
kind of sucks for correlating the most recent release of the man-pages 
package (which documents the syscalls and such people actually _use_) with 
anything else.

Here's a video of a talk Linus Torvalds' gave on git a couple months back:
http://youtube.com/watch?v=4XpnKHJAok8

Is this something kernel developers might be interested in?  Probably.  Is 
this something it makes the SLIGHTEST bit of sense to try to integrate into 
the kernel-doc infrastructure?  Not really, no.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
